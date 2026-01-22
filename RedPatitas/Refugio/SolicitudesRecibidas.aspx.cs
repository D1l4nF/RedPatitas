using CapaNegocios;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RedPatitas.Refugio
{
    public partial class SolicitudesRecibidas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarSolicitudes();
            }
        }

        private void CargarSolicitudes()
        {
            int idRefugio = (int)Session["IdRefugio"];

            gvSolicitudes.DataSource = CN_AdopcionService.SolicitudesRecibidas(idRefugio);
            gvSolicitudes.DataBind();
        }

        protected void btnAprobar_Click(object sender, EventArgs e)
        {
            int idSolicitud = int.Parse(((System.Web.UI.WebControls.Button)sender).CommandArgument);
            CN_AdopcionService.Aprobar(idSolicitud);
            CargarSolicitudes();
        }

        protected void btnRechazar_Click(object sender, EventArgs e)
        {
            int idSolicitud = int.Parse(((System.Web.UI.WebControls.Button)sender).CommandArgument);
            CN_AdopcionService.Rechazar(idSolicitud, "Rechazada por el refugio");
            CargarSolicitudes();
        }
    }

}