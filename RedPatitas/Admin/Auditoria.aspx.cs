using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaDatos;

namespace RedPatitas.Admin
{
    public partial class Auditoria : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtFechaDesde.Text = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd");
                txtFechaHasta.Text = DateTime.Now.ToString("yyyy-MM-dd");
                CargarAuditoria();
            }
        }

        protected void Filtros_Changed(object sender, EventArgs e)
        {
            CargarAuditoria();
        }

        private void CargarAuditoria()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var query = db.tbl_Auditoria.AsQueryable();

                    // Filtro por acción
                    if (!string.IsNullOrEmpty(ddlAccion.SelectedValue))
                    {
                        query = query.Where(a => a.aud_Accion == ddlAccion.SelectedValue);
                    }

                    // Filtro por tabla
                    if (!string.IsNullOrEmpty(ddlTabla.SelectedValue))
                    {
                        query = query.Where(a => a.aud_Tabla == ddlTabla.SelectedValue);
                    }

                    // Filtro por fecha desde
                    if (!string.IsNullOrEmpty(txtFechaDesde.Text))
                    {
                        var fechaDesde = DateTime.Parse(txtFechaDesde.Text);
                        query = query.Where(a => a.aud_Fecha >= fechaDesde);
                    }

                    // Filtro por fecha hasta
                    if (!string.IsNullOrEmpty(txtFechaHasta.Text))
                    {
                        var fechaHasta = DateTime.Parse(txtFechaHasta.Text).AddDays(1);
                        query = query.Where(a => a.aud_Fecha < fechaHasta);
                    }

                    var logs = query
                        .OrderByDescending(a => a.aud_Fecha)
                        .Take(100)
                        .Select(a => new
                        {
                            Fecha = a.aud_Fecha,
                            IdUsuario = a.aud_IdUsuario,
                            Accion = a.aud_Accion,
                            Tabla = a.aud_Tabla ?? "-",
                            DireccionIP = a.aud_DireccionIP ?? "-",
                            IdRegistro = a.aud_IdRegistro,
                            NombreUsuario = a.tbl_Usuarios != null ? a.tbl_Usuarios.usu_Nombre + " " + a.tbl_Usuarios.usu_Apellido : "Sistema",
                            Iniciales = a.tbl_Usuarios != null ? 
                                (a.tbl_Usuarios.usu_Nombre.Substring(0, 1) + (a.tbl_Usuarios.usu_Apellido != null ? a.tbl_Usuarios.usu_Apellido.Substring(0, 1) : "")).ToUpper() 
                                : "SI"
                        })
                        .ToList()
                        .Select(a => new
                        {
                            a.Fecha,
                            a.Accion,
                            a.Tabla,
                            a.DireccionIP,
                            a.NombreUsuario,
                            a.Iniciales,
                            Descripcion = GetDescripcion(a.Accion, a.Tabla, a.IdRegistro)
                        })
                        .ToList();

                    if (logs.Count > 0)
                    {
                        rptAuditoria.DataSource = logs;
                        rptAuditoria.DataBind();
                        pnlSinRegistros.Visible = false;
                        lblTotal.Text = $"{logs.Count} registros";
                    }
                    else
                    {
                        pnlSinRegistros.Visible = true;
                        lblTotal.Text = "0 registros";
                    }
                }
            }
            catch (Exception ex)
            {
                pnlSinRegistros.Visible = true;
                lblTotal.Text = "Error al cargar";
                System.Diagnostics.Debug.WriteLine("Error cargando auditoría: " + ex.Message);
            }
        }

        protected string GetAccionBadgeClass(string accion)
        {
            switch (accion)
            {
                case "LOGIN": return "active";
                case "LOGOUT": return "";
                case "INSERT": return "active";
                case "UPDATE": return "pending";
                case "DELETE": return "inactive";
                case "CUENTA_BLOQUEADA": return "inactive";
                default: return "";
            }
        }

        private string GetDescripcion(string accion, string tabla, int? idRegistro)
        {
            string desc = "";
            switch (accion)
            {
                case "LOGIN": desc = "Inicio de sesión"; break;
                case "LOGOUT": desc = "Cierre de sesión"; break;
                case "INSERT": desc = $"Registro creado"; break;
                case "UPDATE": desc = $"Registro actualizado"; break;
                case "DELETE": desc = $"Registro eliminado"; break;
                case "CUENTA_BLOQUEADA": desc = "Cuenta bloqueada por intentos fallidos"; break;
                default: desc = accion; break;
            }
            if (idRegistro.HasValue && idRegistro > 0)
            {
                desc += $" (ID: {idRegistro})";
            }
            return desc;
        }
    }
}