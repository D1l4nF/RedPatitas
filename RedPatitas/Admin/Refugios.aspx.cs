using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.Admin
{
    public partial class Refugios : System.Web.UI.Page
    {
        private CN_AdminRefugioService _refugioService = new CN_AdminRefugioService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarEstadisticas();
                CargarRefugios();
            }
        }

        private void CargarEstadisticas()
        {
            try
            {
                var stats = _refugioService.ObtenerEstadisticasRefugios();
                litTotalRefugios.Text = stats.Total.ToString();
                litVerificados.Text = stats.Verificados.ToString();
                litPendientes.Text = stats.Pendientes.ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cargando estadísticas: " + ex.Message);
            }
        }

        private void CargarRefugios()
        {
            try
            {
                bool? filtroVerificado = null;
                if (!string.IsNullOrEmpty(ddlFiltroVerificado.SelectedValue))
                {
                    filtroVerificado = bool.Parse(ddlFiltroVerificado.SelectedValue);
                }

                string busqueda = txtBusqueda.Text.Trim();

                var refugios = _refugioService.ObtenerTodosRefugios(filtroVerificado, busqueda);

                if (refugios.Count > 0)
                {
                    rptRefugios.DataSource = refugios;
                    rptRefugios.DataBind();
                    pnlSinResultados.Visible = false;
                }
                else
                {
                    rptRefugios.DataSource = null;
                    rptRefugios.DataBind();
                    pnlSinResultados.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cargando refugios: " + ex.Message);
                pnlSinResultados.Visible = true;
            }
        }

        protected void ddlFiltroVerificado_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarRefugios();
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            CargarRefugios();
        }

        protected void rptRefugios_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                int idRefugio = int.Parse(e.CommandArgument.ToString());

                switch (e.CommandName)
                {
                    case "Verificar":
                        _refugioService.VerificarRefugio(idRefugio);
                        break;

                    case "Rechazar":
                        _refugioService.RechazarRefugio(idRefugio);
                        break;
                }

                CargarEstadisticas();
                CargarRefugios();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en comando: " + ex.Message);
            }
        }

        protected void rptRefugios_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var refugio = e.Item.DataItem as CN_AdminRefugioService.RefugioAdmin;
                if (refugio != null)
                {
                    var pnlAvatar = e.Item.FindControl("pnlAvatar") as Panel;
                    if (pnlAvatar != null)
                    {
                        pnlAvatar.Style["background"] = refugio.Verificado ? "#27AE60" : "#F39C12";
                    }
                }
            }
        }
    }
}