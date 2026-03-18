using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.Adoptante
{
    public partial class Notificaciones : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarNotificaciones();
            }
        }

        private void CargarNotificaciones()
        {
            try
            {
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);
                var notificaciones = CN_NotificacionService.ObtenerPorUsuario(idUsuario);
                
                rptNotificaciones.DataSource = notificaciones;
                rptNotificaciones.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar notificaciones: " + ex.Message);
            }
        }

        protected void btnMarcarLeidas_Click(object sender, EventArgs e)
        {
            try
            {
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);
                CN_NotificacionService.MarcarTodasComoLeidas(idUsuario);
                CargarNotificaciones();
                
                // Recargar para que actualice el badge en la master
                Response.Redirect(Request.RawUrl);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al marcar todas como leídas: " + ex.Message);
            }
        }

        protected void rptNotificaciones_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "MarcarLeida")
                {
                    int idNotificacion = Convert.ToInt32(e.CommandArgument);
                    CN_NotificacionService.MarcarComoLeida(idNotificacion);
                    CargarNotificaciones();
                }
                else if (e.CommandName == "IrAccion")
                {
                    string[] args = e.CommandArgument.ToString().Split('|');
                    if (args.Length == 2)
                    {
                        int idNotificacion = Convert.ToInt32(args[0]);
                        string url = args[1];
                        
                        CN_NotificacionService.MarcarComoLeida(idNotificacion);
                        
                        if (!string.IsNullOrEmpty(url))
                        {
                            Response.Redirect(url);
                        }
                        else
                        {
                            CargarNotificaciones();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en comando de notificación: " + ex.Message);
            }
        }

        protected string GetNotifClass(string icono, string titulo)
        {
            if (string.IsNullOrEmpty(icono) && string.IsNullOrEmpty(titulo)) return "type-sistema";
            
            icono = icono?.ToLower() ?? "";
            titulo = titulo?.ToLower() ?? "";

            if (icono.Contains("times-circle") || titulo.Contains("rechazada")) return "type-rechazada";
            if (icono.Contains("check-circle") || titulo.Contains("aprobada")) return "type-aprobada";
            if (icono.Contains("clipboard") || icono.Contains("exclamation") || titulo.Contains("seguimiento")) return "type-seguimiento";
            
            return "type-sistema";
        }
    }
}
