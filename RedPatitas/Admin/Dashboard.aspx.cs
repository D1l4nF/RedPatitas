using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private int _maxAdopciones = 1;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarEstadisticas();
                CargarUsuariosRecientes();
                CargarActividadReciente();
                CargarTopRefugios();
                CargarAdopcionesPorMes();
            }
        }

        private void CargarEstadisticas()
        {
            try
            {
                var dashboardService = new CN_DashboardService();
                var stats = dashboardService.ObtenerEstadisticasGenerales();

                // Formatear números con separador de miles
                litTotalUsuarios.Text = stats.TotalUsuarios.ToString("N0");
                litTotalMascotas.Text = stats.TotalMascotas.ToString("N0");
                litReportesActivos.Text = stats.ReportesActivos.ToString("N0");
                litAdopcionesExitosas.Text = stats.AdopcionesExitosas.ToString("N0");

                // Tendencias
                litTendenciaUsuarios.Text = stats.TendenciaUsuarios;
                litTendenciaMascotas.Text = stats.TendenciaMascotas;
                litTendenciaReportes.Text = stats.TendenciaReportes;
                litTendenciaAdopciones.Text = stats.TendenciaAdopciones;

                // Desglose de usuarios (Oculto por solicitud)
                /*
                litAdminRefugioCount.Text = stats.UsuariosAdminRefugio.ToString();
                litRefugioCount.Text = stats.UsuariosRefugio.ToString();
                litAdoptanteCount.Text = stats.UsuariosAdoptante.ToString();
                */
            }
            catch (Exception ex)
            {
                // En caso de error, mostrar valores por defecto
                litTotalUsuarios.Text = "0";
                litTotalMascotas.Text = "0";
                litReportesActivos.Text = "0";
                litAdopcionesExitosas.Text = "0";

                System.Diagnostics.Debug.WriteLine("Error cargando estadísticas: " + ex.Message);
            }
        }

        private void CargarUsuariosRecientes()
        {
            try
            {
                var dashboardService = new CN_DashboardService();
                var usuarios = dashboardService.ObtenerUsuariosRecientes(5);

                if (usuarios.Count > 0)
                {
                    rptUsuariosRecientes.DataSource = usuarios;
                    rptUsuariosRecientes.DataBind();
                    pnlSinUsuarios.Visible = false;
                }
                else
                {
                    pnlSinUsuarios.Visible = true;
                }
            }
            catch (Exception ex)
            {
                pnlSinUsuarios.Visible = true;
                System.Diagnostics.Debug.WriteLine("Error cargando usuarios: " + ex.Message);
            }
        }

        private void CargarActividadReciente()
        {
            try
            {
                var dashboardService = new CN_DashboardService();
                var actividad = dashboardService.ObtenerActividadReciente(5);

                if (actividad.Count > 0)
                {
                    rptActividadReciente.DataSource = actividad;
                    rptActividadReciente.DataBind();
                    pnlSinActividad.Visible = false;
                }
                else
                {
                    pnlSinActividad.Visible = true;
                }
            }
            catch (Exception ex)
            {
                pnlSinActividad.Visible = true;
                System.Diagnostics.Debug.WriteLine("Error cargando actividad: " + ex.Message);
            }
        }

        protected void rptUsuariosRecientes_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var usuario = e.Item.DataItem as CN_DashboardService.UsuarioReciente;
                if (usuario != null)
                {
                    var pnlAvatar = e.Item.FindControl("pnlAvatar") as Panel;
                    if (pnlAvatar != null)
                    {
                        pnlAvatar.Style["background"] = usuario.ColorAvatar;
                    }
                }
            }
        }

        protected void rptActividadReciente_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var actividad = e.Item.DataItem as CN_DashboardService.ActividadReciente;
                if (actividad != null)
                {
                    var pnlIcono = e.Item.FindControl("pnlIcono") as Panel;
                    var litIcono = e.Item.FindControl("litIcono") as Literal;

                    if (pnlIcono != null)
                    {
                        pnlIcono.CssClass = "activity-icon " + actividad.Tipo;
                    }

                    if (litIcono != null)
                    {
                        litIcono.Text = GetActivityIcon(actividad.Tipo);
                    }
                }
            }
        }

        /// <summary>
        /// Obtiene el ícono SVG según el tipo de actividad
        /// </summary>
        private string GetActivityIcon(string tipo)
        {
            switch (tipo)
            {
                case "user":
                    return @"<svg viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2"" width=""18"" height=""18"">
                        <path d=""M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2""></path>
                        <circle cx=""8.5"" cy=""7"" r=""4""></circle>
                    </svg>";
                case "pet":
                    return @"<svg viewBox=""0 0 24 24"" fill=""currentColor"" width=""18"" height=""18"">
                        <path d=""M12,11.36C12.55,11.36 13,10.91 13,10.36V8.36C13,7.81 12.55,7.36 12,7.36C11.45,7.36 11,7.81 11,8.36V10.36C11,10.91 11.45,11.36 12,11.36M12,12.36C10.5,12.36 9.1,12.76 7.9,13.46C7.3,12.86 6.4,12.36 5.5,12.36C3.5,12.36 2,13.86 2,15.86C2,17.86 3.5,19.36 5.5,19.36C6.5,19.36 7.4,18.96 8.1,18.26C9,19.56 10.4,20.36 12,20.36C13.6,20.36 15,19.56 15.9,18.26C16.6,18.96 17.5,19.36 18.5,19.36C20.5,19.36 22,17.86 22,15.86C22,13.86 20.5,12.36 18.5,12.36C17.6,12.36 16.7,12.86 16.1,13.46C14.9,12.76 13.5,12.36 12,12.36Z"" />
                    </svg>";
                case "report":
                    return @"<svg viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2"" width=""18"" height=""18"">
                        <circle cx=""11"" cy=""11"" r=""8""></circle>
                        <line x1=""21"" y1=""21"" x2=""16.65"" y2=""16.65""></line>
                    </svg>";
                case "adoption":
                    return @"<svg viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2"" width=""18"" height=""18"">
                        <path d=""M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z""></path>
                    </svg>";
                default:
                    return @"<svg viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2"" width=""18"" height=""18"">
                        <circle cx=""12"" cy=""12"" r=""10""></circle>
                    </svg>";
            }
        }

        private void CargarTopRefugios()
        {
            try
            {
                var dashboardService = new CN_DashboardService();
                var refugios = dashboardService.ObtenerEstadisticasPorRefugio(5);

                if (refugios.Count > 0)
                {
                    rptTopRefugios.DataSource = refugios;
                    rptTopRefugios.DataBind();
                    pnlSinRefugios.Visible = false;
                }
                else
                {
                    pnlSinRefugios.Visible = true;
                }
            }
            catch (Exception ex)
            {
                pnlSinRefugios.Visible = true;
                System.Diagnostics.Debug.WriteLine("Error cargando top refugios: " + ex.Message);
            }
        }

        private void CargarAdopcionesPorMes()
        {
            try
            {
                var dashboardService = new CN_DashboardService();
                var adopciones = dashboardService.ObtenerAdopcionesPorMes(6);

                if (adopciones.Count > 0 && adopciones.Any(a => a.CantidadAdopciones > 0))
                {
                    _maxAdopciones = adopciones.Max(a => a.CantidadAdopciones);
                    if (_maxAdopciones == 0) _maxAdopciones = 1;

                    rptAdopcionesMes.DataSource = adopciones;
                    rptAdopcionesMes.DataBind();
                    pnlSinAdopciones.Visible = false;
                }
                else
                {
                    pnlSinAdopciones.Visible = true;
                }
            }
            catch (Exception ex)
            {
                pnlSinAdopciones.Visible = true;
                System.Diagnostics.Debug.WriteLine("Error cargando adopciones: " + ex.Message);
            }
        }

        protected void rptTopRefugios_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var pnlAvatar = e.Item.FindControl("pnlAvatarRefugio") as Panel;
                if (pnlAvatar != null)
                {
                    pnlAvatar.Style["background"] = "#27AE60";
                }
            }
        }

        protected string GetBarWidth(object cantidad)
        {
            int valor = Convert.ToInt32(cantidad);
            if (_maxAdopciones == 0) return "0";
            int porcentaje = (int)((double)valor / _maxAdopciones * 100);
            return porcentaje.ToString();
        }
    }
}