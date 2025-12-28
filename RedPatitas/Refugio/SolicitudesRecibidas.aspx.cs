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
                gvSolicitudes.DataSource = new[]
                {
            new { Adoptante = "Ana Díaz", Mascota = "Firulais", Estado = "Pendiente" },
            new { Adoptante = "Carlos Pérez", Mascota = "Luna", Estado = "Pendiente" }
        };

                gvSolicitudes.DataBind();
            }
        }

        protected void gvSolicitudes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Aprobar")
                lblResultado.Text = "Solicitud APROBADA correctamente.";

            if (e.CommandName == "Rechazar")
                lblResultado.Text = "Solicitud RECHAZADA.";
        }

    }
}