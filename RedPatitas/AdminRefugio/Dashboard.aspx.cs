using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.AdminRefugio
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
                // 1. Cargar Estadísticas Generales
                var stats = _dashboardService.ObtenerEstadisticasGenerales();

                // Totales
                litTotalUsuarios.Text = stats.TotalUsuarios.ToString();
                litTotalMascotas.Text = stats.TotalMascotas.ToString();
                litTotalAdopciones.Text = stats.AdopcionesExitosas.ToString();
                litTotalReportes.Text = stats.ReportesActivos.ToString();

                // Tendencias
                litTrendUsuarios.Text = stats.TendenciaUsuarios;
                litTrendMascotas.Text = stats.TendenciaMascotas;
                litTrendAdopciones.Text = stats.TendenciaAdopciones;
                litTrendReportes.Text = stats.TendenciaReportes;

                // Estilos para tendencias (verde si sube lo bueno, rojo si baja, etc.)
                AplicarEstiloTendencia(divTrendUsuarios, stats.TendenciaUsuarios);
                AplicarEstiloTendencia(divTrendMascotas, stats.TendenciaMascotas);
                AplicarEstiloTendencia(divTrendAdopciones, stats.TendenciaAdopciones);

                // Para reportes, subir es "malo" generalmente, pero depende de la interpretación.
                // Usaremos lógica estándar por ahora.
                AplicarEstiloTendencia(divTrendReportes, stats.TendenciaReportes);


                // 2. Cargar Usuarios Recientes
                var usuariosRecientes = _dashboardService.ObtenerUsuariosRecientes(5);
                rptUsuariosRecientes.DataSource = usuariosRecientes;
                rptUsuariosRecientes.DataBind();

                // 3. Cargar Actividad Reciente
                var actividadReciente = _dashboardService.ObtenerActividadReciente(6);
                rptActividadReciente.DataSource = actividadReciente;
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
                div.Attributes["class"] = "trend up";
                div.Style.Add("color", "#27AE60");
            }
            else if (tendencia.Contains("↓"))
            {
                div.Attributes["class"] = "trend down";
                div.Style.Add("color", "#E74C3C");
            }
            else
            {
                div.Attributes["class"] = "trend neutral";
                div.Style.Add("color", "#7F8C8D");
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