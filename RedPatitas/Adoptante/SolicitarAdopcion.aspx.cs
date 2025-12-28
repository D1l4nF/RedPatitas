using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;
namespace RedPatitas.Adoptante
{
    public partial class SolicitarAdopcion : System.Web.UI.Page
    {
        CN_AdopcionesService servicio = new CN_AdopcionesService();

        protected void Page_Load(object sender, EventArgs e)
        {


        }

        protected void btnSolicitar_Click(object sender, EventArgs e)
        {
            int idMascota = int.Parse(Request.QueryString["idMascota"]);
            int idUsuario = 1;

            servicio.SolicitarAdopcion(idMascota, idUsuario);
            Response.Redirect("MisSolicitudes.aspx");
        }

    }
}