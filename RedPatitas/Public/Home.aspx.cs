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
    }
}