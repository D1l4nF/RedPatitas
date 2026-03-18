using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.Public
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarMascotasDestacadas();
                CargarRefugiosAliados();
                CargarCampaniasHome();
                CargarImpactoSocial();
            }
        }
        

        /// <summary>
        /// Carga las mascotas destacadas (las primeras 4 disponibles)
        /// </summary>
        private void CargarMascotasDestacadas()
        {
            try
            {
                CN_MascotaService mascotaService = new CN_MascotaService();
                List<MascotaDTO> mascotas = mascotaService.ObtenerMascotasDisponibles();

                // Tomar solo las primeras 4 mascotas para destacadas
                if (mascotas != null && mascotas.Count > 0)
                {
                    var mascotasDestacadas = mascotas.Take(4).ToList();
                    rptMascotasDestacadas.DataSource = mascotasDestacadas;
                    rptMascotasDestacadas.DataBind();
                    pnlSinMascotasHome.Visible = false;
                }
                else
                {
                    rptMascotasDestacadas.DataSource = null;
                    rptMascotasDestacadas.DataBind();
                    pnlSinMascotasHome.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar mascotas destacadas: " + ex.Message);
                pnlSinMascotasHome.Visible = true;
            }
        }

        private void CargarRefugiosAliados()
        {
            try
            {
                var refugioService = new CN_RefugioService();
                var aliados = refugioService.ObtenerRefugiosAliados();

                if (aliados != null && aliados.Count > 0)
                {
                    rptAliados.DataSource = aliados;
                    rptAliados.DataBind();
                    pnlSinAliados.Visible = false;
                }
                else
                {
                    pnlSinAliados.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar aliados: " + ex.Message);
            }
        }

        private void CargarCampaniasHome()
        {
            try
            {
                CN_CampaniaService campaniaService = new CN_CampaniaService();
                var campanias = campaniaService.ObtenerCampaniasActivas(3);

                if (campanias != null && campanias.Count > 0)
                {
                    rptCampanas.DataSource = campanias;
                    rptCampanas.DataBind();
                    pnlSinCampanas.Visible = false;
                }
                else
                {
                    rptCampanas.DataSource = null;
                    rptCampanas.DataBind();
                    pnlSinCampanas.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar campañas en Home: " + ex.Message);
                pnlSinCampanas.Visible = true;
            }
        }

        private void CargarImpactoSocial()
        {
            try
            {
                CN_DashboardService dashboardService = new CN_DashboardService();
                var impacto = dashboardService.ObtenerImpactoSocialGeneral();

                // Format numbers with thousands separator (e.g., 1,247). We add "+" if greater than 0 to make it look active.
                litMascotasAdoptadas.Text = $"<span class=\"counter\" data-target=\"{impacto.MascotasAdoptadas}\">0</span>{(impacto.MascotasAdoptadas > 0 ? "+" : "")}";
                litHogaresFelices.Text = $"<span class=\"counter\" data-target=\"{impacto.HogaresFelices}\">0</span>{(impacto.HogaresFelices > 0 ? "+" : "")}";
                litRefugiosAliados.Text = $"<span class=\"counter\" data-target=\"{impacto.RefugiosAliados}\">0</span>";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar impacto social: " + ex.Message);
                // Si falla, los literales mantienen tu valor por defecto.
            }
        }
    }
}