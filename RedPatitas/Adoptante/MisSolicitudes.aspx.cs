using CapaNegocios;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RedPatitas.Adoptante
{
    public partial class MisSolicitudes : System.Web.UI.Page
    {
        CN_AdopcionesService servicio = new CN_AdopcionesService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int idUsuario = Convert.ToInt32(Session["idUsuario"]);
                CargarSolicitudes(idUsuario);
            }
        }

        private void CargarSolicitudes(int idUsuario)
        {
            gvSolicitudes.DataSource = servicio.HistorialSolicitudes(idUsuario);
            gvSolicitudes.DataBind();
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int idSolicitud = Convert.ToInt32(btn.CommandArgument);

            servicio.CancelarSolicitud(idSolicitud);

            int idUsuario = Convert.ToInt32(Session["idUsuario"]);
            CargarSolicitudes(idUsuario);
        }
    }
}