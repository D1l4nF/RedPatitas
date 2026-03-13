using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.Refugio
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private CN_DashboardService _dashboardService = new CN_DashboardService();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Validar sesión
            if (Session["UsuarioId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CargarDatosDashboard();
            }
        }

        private void CargarDatosDashboard()
        {
            try
            {
                if (Session["RefugioId"] == null) return;
                int idRefugio = Convert.ToInt32(Session["RefugioId"]);

                // 1. Cargar Estadísticas del Refugio
                var stats = _dashboardService.ObtenerEstadisticasRefugioStaff(idRefugio);

                // Totales
                litSolicitudesPendientes.Text = stats.SolicitudesPendientes.ToString();
                litMisMascotasPublicadas.Text = stats.MisMascotasPublicadas.ToString();
                litMisAdopcionesExitosas.Text = stats.MisAdopcionesExitosas.ToString();
                litReportesActivos.Text = stats.ReportesActivos.ToString();

                // Tendencias
                litTrendSolicitudes.Text = stats.TendenciaSolicitudes;
                litTrendMascotas.Text = stats.TendenciaMascotas;
                litTrendAdopciones.Text = stats.TendenciaAdopciones;
                litTrendReportes.Text = stats.TendenciaReportes;

                // Estilos para tendencias
                AplicarEstiloTendencia(divTrendSolicitudes, stats.TendenciaSolicitudes);
                AplicarEstiloTendencia(divTrendMascotas, stats.TendenciaMascotas);
                AplicarEstiloTendencia(divTrendAdopciones, stats.TendenciaAdopciones);
                AplicarEstiloTendencia(divTrendReportes, stats.TendenciaReportes);


                // 2. Cargar Solicitudes Recientes
                var solicitudesRecientes = _dashboardService.ObtenerSolicitudesRecientesRefugio(idRefugio, 5);
                rptSolicitudesRecientes.DataSource = solicitudesRecientes;
                rptSolicitudesRecientes.DataBind();

                // 3. Cargar Actividad Reciente (aquí podríamos filtrar por refugio si hubiese método,
                // de momento usamos el general o lo omitimos, o en CN_DashboardService modificarlo luego.
                // Como es Staff, no debe ver la genérica global. Así que la vaciamos o usamos la global sin datos confidenciales).
                // Optaremos por usar la global genérica si no filtra cosas secretas, aunque lo ideal es filtrar.
                // Para mantenerlo seguro, evitamos mostrar reportes ajenos o lo comentamos.
                // Para simplificar, la removemos del staff o usamos una vacia temporal.
                rptActividadReciente.DataSource = new List<object>(); // TODO: Implementar actividad de Staff
                rptActividadReciente.DataBind();

            }
            catch (Exception ex)
            {
                // Manejar error silenciosamente o mostrar mensaje genérico
                System.Diagnostics.Debug.WriteLine("Error cargando dashboard: " + ex.Message);
            }
        }

        private void AplicarEstiloTendencia(System.Web.UI.HtmlControls.HtmlGenericControl div, string tendencia)
        {
            if (string.IsNullOrEmpty(tendencia)) return;

            if (tendencia.Contains("↑"))
            {
                div.Attributes["class"] = "trend trend-up";
            }
            else if (tendencia.Contains("↓"))
            {
                div.Attributes["class"] = "trend trend-down";
            }
            else
            {
                div.Attributes["class"] = "trend trend-neutral";
            }
        }

        // Métodos Helper para el Repeater
        public string GetActivityIcon(string tipo)
        {
            switch (tipo?.ToLower())
            {
                case "user": return "fas fa-user";
                case "pet": return "fas fa-paw";
                case "adoption": return "fas fa-heart";
                case "report": return "fas fa-exclamation-circle";
                default: return "fas fa-bell";
            }
        }

        public string GetActivityClass(string tipo)
        {
            switch (tipo?.ToLower())
            {
                case "user": return "info";
                case "pet": return "warning";
                case "adoption": return "success"; // Verde para adopciones
                case "report": return "warning"; // Naranja/Rojo para reportes
                default: return "info";
            }
        }
    }
}