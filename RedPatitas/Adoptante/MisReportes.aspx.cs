using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaDatos;
using CapaNegocios;

namespace RedPatitas.Adoptante
{
    public partial class MisReportes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Verificar sesión
                if (Session["UsuarioId"] == null)
                {
                    Response.Redirect("~/Login/Login.aspx");
                    return;
                }

                CargarEstadisticas();
                CargarReportes();
            }
        }

        private int ObtenerIdUsuario()
        {
            return Session["UsuarioId"] != null ? Convert.ToInt32(Session["UsuarioId"]) : 0;
        }

        private void CargarEstadisticas()
        {
            try
            {
                int idUsuario = ObtenerIdUsuario();
                using (var db = new DataClasses1DataContext())
                {
                    var reportes = db.tbl_ReportesMascotas.Where(r => r.rep_IdUsuario == idUsuario);
                    
                    litMisPerdidas.Text = reportes.Count(r => r.rep_TipoReporte == "Perdida").ToString();
                    litMisEncontradas.Text = reportes.Count(r => r.rep_TipoReporte == "Encontrada").ToString();
                    litReunidas.Text = reportes.Count(r => r.rep_Estado == "Reunido").ToString();
                    
                    // Contar avistamientos en mis reportes
                    var idsReportes = reportes.Select(r => r.rep_IdReporte).ToList();
                    litAvistamientos.Text = db.tbl_Avistamientos
                        .Count(a => idsReportes.Contains(a.avi_IdReporte))
                        .ToString();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cargando estadísticas: " + ex.Message);
            }
        }

        private void CargarReportes()
        {
            try
            {
                int idUsuario = ObtenerIdUsuario();
                var reportes = CN_ReporteService.ObtenerReportesPorUsuario(idUsuario);

                if (reportes.Count > 0)
                {
                    rptReportes.DataSource = reportes;
                    rptReportes.DataBind();
                    pnlReportes.Visible = true;
                    pnlSinReportes.Visible = false;
                }
                else
                {
                    pnlReportes.Visible = false;
                    pnlSinReportes.Visible = true;
                }
            }
            catch (Exception ex)
            {
                pnlSinReportes.Visible = true;
                System.Diagnostics.Debug.WriteLine("Error cargando reportes: " + ex.Message);
            }
        }

        protected void rptReportes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int idReporte = int.Parse(e.CommandArgument.ToString());
            int idUsuario = ObtenerIdUsuario();

            switch (e.CommandName)
            {
                case "Ver":
                    Response.Redirect($"~/Public/DetalleReporte.aspx?id={idReporte}");
                    break;

                case "Reunido":
                    var resultado = CN_ReporteService.CambiarEstadoReporte(idReporte, idUsuario, "Reunido");
                    if (resultado.Exito)
                    {
                        MostrarMensaje("¡Felicidades! 🎉 Tu mascota ha sido marcada como reunida.", "success");
                    }
                    else
                    {
                        MostrarMensaje(resultado.Mensaje, "error");
                    }
                    CargarEstadisticas();
                    CargarReportes();
                    break;

                case "Cerrar":
                    var resultadoCierre = CN_ReporteService.CambiarEstadoReporte(idReporte, idUsuario, "SinResolver");
                    if (resultadoCierre.Exito)
                    {
                        MostrarMensaje("El reporte ha sido cerrado.", "info");
                    }
                    else
                    {
                        MostrarMensaje(resultadoCierre.Mensaje, "error");
                    }
                    CargarEstadisticas();
                    CargarReportes();
                    break;
            }
        }

        protected string GetEstadoBadgeClass(string estado)
        {
            switch (estado)
            {
                case "Reportado": return "pending";
                case "EnBusqueda": return "pending";
                case "Avistado": return "pending";
                case "Encontrado": return "active";
                case "Reunido": return "active";
                case "SinResolver": return "inactive";
                default: return "";
            }
        }

        private void MostrarMensaje(string mensaje, string tipo)
        {
            string icon = tipo == "success" ? "success" : tipo == "error" ? "error" : "info";
            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                $"Swal.fire({{ icon: '{icon}', text: '{mensaje}', timer: 3000 }});", true);
        }
    }
}
