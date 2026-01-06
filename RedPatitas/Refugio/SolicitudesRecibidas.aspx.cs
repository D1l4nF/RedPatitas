using CapaNegocios;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RedPatitas.Refugio
{
    public partial class SolicitudesRecibidas2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int idRefugio = (int)Session["idRefugio"];

                CN_AdopcionesService servicio = new CN_AdopcionesService();
                gvSolicitudes.DataSource = servicio.SolicitudesRecibidas(idRefugio);
                gvSolicitudes.DataBind();
            }
        }

        protected void gvSolicitudes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int idSolicitud = int.Parse(e.CommandArgument.ToString());
            int idUsuario = (int)Session["idUsuario"];

            CN_AdopcionesService servicio = new CN_AdopcionesService();

            if (e.CommandName == "Aprobar")
                servicio.Aprobar(idSolicitud, idUsuario);

            if (e.CommandName == "Rechazar")
                servicio.Rechazar(idSolicitud, "Rechazado por refugio", idUsuario);

            Response.Redirect(Request.RawUrl);
        }

    }
}