using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.Public
{
    public partial class Adopta : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarMascotas();
            }
        }

        /// <summary>
        /// Carga las mascotas disponibles para adopción
        /// </summary>
        private void CargarMascotas()
        {
            try
            {
                CN_MascotaService mascotaService = new CN_MascotaService();
                List<MascotaDTO> mascotas = mascotaService.ObtenerMascotasDisponibles();

                if (mascotas != null && mascotas.Count > 0)
                {
                    rptMascotas.DataSource = mascotas;
                    rptMascotas.DataBind();
                    litCantidad.Text = mascotas.Count.ToString();
                    pnlSinMascotas.Visible = false;
                }
                else
                {
                    rptMascotas.DataSource = null;
                    rptMascotas.DataBind();
                    litCantidad.Text = "0";
                    pnlSinMascotas.Visible = true;
                }
            }
            catch (Exception ex)
            {
                // Log error y mostrar mensaje amigable
                System.Diagnostics.Debug.WriteLine("Error al cargar mascotas: " + ex.Message);
                pnlSinMascotas.Visible = true;
                litCantidad.Text = "0";
            }
        }

        /// <summary>
        /// Evento cuando cambian los filtros
        /// </summary>
        protected void Filtros_Changed(object sender, EventArgs e)
        {
            AplicarFiltros();
        }

        /// <summary>
        /// Aplica los filtros seleccionados
        /// </summary>
        private void AplicarFiltros()
        {
            try
            {
                string tipo = ddlTipo.SelectedValue;
                string edad = ddlEdad.SelectedValue;
                string tamano = ddlTamano.SelectedValue;

                CN_MascotaService mascotaService = new CN_MascotaService();
                List<MascotaDTO> mascotas;

                // Si hay algún filtro activo, usar el método de filtrado
                if (!string.IsNullOrEmpty(tipo) || !string.IsNullOrEmpty(edad) || !string.IsNullOrEmpty(tamano))
                {
                    mascotas = mascotaService.FiltrarMascotas(tipo, edad, tamano);
                }
                else
                {
                    mascotas = mascotaService.ObtenerMascotasDisponibles();
                }

                if (mascotas != null && mascotas.Count > 0)
                {
                    rptMascotas.DataSource = mascotas;
                    rptMascotas.DataBind();
                    litCantidad.Text = mascotas.Count.ToString();
                    pnlSinMascotas.Visible = false;
                }
                else
                {
                    rptMascotas.DataSource = null;
                    rptMascotas.DataBind();
                    litCantidad.Text = "0";
                    pnlSinMascotas.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al filtrar mascotas: " + ex.Message);
                pnlSinMascotas.Visible = true;
                litCantidad.Text = "0";
            }
        }
    }
}