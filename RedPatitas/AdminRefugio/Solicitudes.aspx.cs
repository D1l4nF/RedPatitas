using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.AdminRefugio
{
    public partial class Solicitudes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["RefugioId"] == null)
                {
                    Response.Redirect("~/Login/Login.aspx");
                    return;
                }
                CargarSolicitudes();
            }
        }

        private void CargarSolicitudes()
        {
            try
            {
                int idRefugio = Convert.ToInt32(Session["RefugioId"]);
                // Usamos el método existente en CN_AdopcionService que devuelve lista de vw_SolicitudesCompleta
                var solicitudes = CN_AdopcionService.SolicitudesRecibidas(idRefugio);
                rptSolicitudes.DataSource = solicitudes;
                rptSolicitudes.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error CargarSolicitudes: " + ex.Message);
            }
        }

        protected void rptSolicitudes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Aprobar")
            {
                int idSolicitud = Convert.ToInt32(e.CommandArgument);
                try
                {
                    CN_AdopcionService.Aprobar(idSolicitud);
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Solicitud aprobada con éxito. La mascota ha sido marcada como Adoptada.');", true);
                    CargarSolicitudes();
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Error al aprobar solicitud.');", true);
                    System.Diagnostics.Debug.WriteLine("Error Aprobar: " + ex.Message);
                }
            }
            else if (e.CommandName == "Rechazar")
            {
                // Abrir modal de rechazo
                string idSolicitud = e.CommandArgument.ToString();
                hfIdSolicitudRechazo.Value = idSolicitud;
                txtMotivoRechazo.Text = "";
                pnlModalRechazo.Visible = true;
            }
        }

        protected void btnCancelarRechazo_Click(object sender, EventArgs e)
        {
            pnlModalRechazo.Visible = false;
        }

        protected void btnConfirmarRechazo_Click(object sender, EventArgs e)
        {
            try
            {
                int idSolicitud = Convert.ToInt32(hfIdSolicitudRechazo.Value);
                string motivo = txtMotivoRechazo.Text.Trim();

                CN_AdopcionService.Rechazar(idSolicitud, motivo);

                pnlModalRechazo.Visible = false;
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Solicitud rechazada.');", true);
                CargarSolicitudes();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error Rechazar: " + ex.Message);
            }
        }
    }
}
