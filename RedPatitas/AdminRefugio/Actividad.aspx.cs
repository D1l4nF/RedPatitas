using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.AdminRefugio
{
    public partial class Actividad : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UsuarioId"] == null || Session["RefugioId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CargarActividad();
            }
        }

        private void CargarActividad()
        {
            try
            {
                int idRefugio = Convert.ToInt32(Session["RefugioId"]);
                var actividad = CN_AuditoriaService.ObtenerTodaActividadXRefugio(idRefugio);

                if (actividad != null)
                {
                    var enumActividad = actividad as System.Collections.IEnumerable;
                    bool hasItems = enumActividad != null && enumActividad.GetEnumerator().MoveNext();
                    
                    if (hasItems)
                    {
                        rptActividad.DataSource = actividad;
                        rptActividad.DataBind();
                        pnlNoData.Visible = false;
                    }
                    else
                    {
                        pnlNoData.Visible = true;
                    }
                }
                else
                {
                    pnlNoData.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.Message);
            }
        }

        public string GetActionClass(string accion)
        {
            switch (accion?.ToUpper())
            {
                case "INSERT": return "success"; 
                case "UPDATE": return "warning";
                case "DELETE": return "reject";
                case "LOGIN": return "info";
                case "APROBAR_SOLICITUD": return "success";
                case "RECHAZAR_SOLICITUD": return "reject";
                default: return "pending";
            }
        }

        /// <summary>
        /// Traduce el nombre técnico de la tabla a un nombre amigable
        /// </summary>
        public string TraducirTabla(string tabla)
        {
            if (string.IsNullOrEmpty(tabla)) return "Sistema";
            switch (tabla)
            {
                case "tbl_Mascotas": return "\U0001f43e Mascotas";
                case "tbl_SolicitudesAdopcion": return "\U0001f4cb Solicitudes";
                case "tbl_Usuarios": return "\U0001f464 Usuarios";
                case "tbl_Refugios": return "\U0001f3e0 Refugios";
                case "tbl_ReportesMascotas": return "\U0001f6a8 Reportes";
                case "tbl_Adopciones": return "\u2764\ufe0f Adopciones";
                case "tbl_FotosMascotas": return "\U0001f4f7 Fotos";
                case "tbl_FotosSolicitud": return "\U0001f4f7 Fotos Solicitud";
                case "tbl_Auditoria": return "\U0001f4dc Auditoría";
                case "tbl_Razas": return "\U0001f415 Razas";
                case "tbl_Especies": return "\U0001f43e Especies";
                default:
                    // Remove tbl_ prefix and return
                    return tabla.Replace("tbl_", "");
            }
        }

        /// <summary>
        /// Traduce el código de acción a un texto amigable
        /// </summary>
        public string TraducirAccion(string accion)
        {
            if (string.IsNullOrEmpty(accion)) return "Acción";
            switch (accion.ToUpper())
            {
                case "INSERT": return "Registro";
                case "UPDATE": return "Actualización";
                case "DELETE": return "Eliminación";
                case "LOGIN": return "Inicio de Sesión";
                case "APROBAR_SOLICITUD": return "Aprobación";
                case "RECHAZAR_SOLICITUD": return "Rechazo";
                default: return accion;
            }
        }

        public string FormatDetails(string accion, object nuevoStr, object previoStr)
        {
            string detail = "";
            string valActual = nuevoStr != null ? nuevoStr.ToString() : "";
            string valAnterior = previoStr != null ? previoStr.ToString() : "";

            if (accion == "UPDATE" && !string.IsNullOrEmpty(valAnterior) && !string.IsNullOrEmpty(valActual))
            {
                detail = $"{valAnterior} <b>→</b> {valActual}";
            }
            else if (!string.IsNullOrEmpty(valActual))
            {
                detail = valActual;
            }
            return detail == "" ? "<span style='color: #aaa'>-</span>" : detail;
        }
    }
}
