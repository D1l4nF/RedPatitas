using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.Refugio
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
                System.Diagnostics.Debug.WriteLine("Error al cargar notificaciones Refugio: " + ex.Message);
            }
        }

        protected void btnMarcarLeidas_Click(object sender, EventArgs e)
        {
            try
            {
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);
                CN_NotificacionService.MarcarTodasComoLeidas(idUsuario);
                CargarNotificaciones();
                
                // Recargar página para actualizar la campana en la Master
                Response.Redirect(Request.RawUrl);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al marcar todas como leídas Refugio: " + ex.Message);
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
                    if (args.Length >= 2)
                    {
                        int idNotificacion = Convert.ToInt32(args[0]);
                        // Url puede contener ampersands o pipes si estuviera mal formado, unimos el resto.
                        string url = string.Join("|", args, 1, args.Length - 1);
                        
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
                System.Diagnostics.Debug.WriteLine("Error en comando de notificación Refugio: " + ex.Message);
            }
        }
    }
}
