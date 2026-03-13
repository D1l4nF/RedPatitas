using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.Refugio
{
    public partial class Solicitudes : System.Web.UI.Page
    {
        private string FiltroActual
        {
            get { return ViewState["FiltroEstado"] as string ?? "Todas"; }
            set { ViewState["FiltroEstado"] = value; }
        }

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
                string filtro = FiltroActual;

                var solicitudes = CN_AdopcionService.SolicitudesRecibidasTodas(idRefugio, filtro);
                rptSolicitudes.DataSource = solicitudes;
                rptSolicitudes.DataBind();

                // Actualizar estilos de las tabs
                ActualizarTabsActivas(filtro);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error CargarSolicitudes: " + ex.Message);
            }
        }

        protected void btnFiltro_Click(object sender, EventArgs e)
        {
            var btn = (LinkButton)sender;
            FiltroActual = btn.CommandArgument;
            CargarSolicitudes();
        }

        private void ActualizarTabsActivas(string filtro)
        {
            btnFiltroTodas.CssClass = "filter-tab" + (filtro == "Todas" ? " active" : "");
            btnFiltroPendientes.CssClass = "filter-tab" + (filtro == "Pendiente" ? " active" : "");
            btnFiltroAprobadas.CssClass = "filter-tab" + (filtro == "Aprobada" ? " active" : "");
            btnFiltroRechazadas.CssClass = "filter-tab" + (filtro == "Rechazada" ? " active" : "");
        }

        protected string GetEstadoClass(string estado)
        {
            switch (estado)
            {
                case "Pendiente": return "pending";
                case "Aprobada": return "available";
                case "Rechazada": return "rejected";
                default: return "pending";
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
                    string script = "Swal.fire({ title: '¡Aprobada!', text: 'Solicitud aprobada con éxito. La mascota ha sido marcada como Adoptada.', icon: 'success', confirmButtonColor: '#0D9488' });";
                    ScriptManager.RegisterStartupScript(this, GetType(), "swal-apr", script, true);
                    CargarSolicitudes();
                }
                catch (Exception ex)
                {
                    string script = "Swal.fire({ title: 'Error', text: 'Error al aprobar solicitud.', icon: 'error', confirmButtonColor: '#0D9488' });";
                    ScriptManager.RegisterStartupScript(this, GetType(), "swal-err-apr", script, true);
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
                string script = "Swal.fire({ title: 'Rechazada', text: 'Solicitud rechazada.', icon: 'info', confirmButtonColor: '#0D9488' });";
                ScriptManager.RegisterStartupScript(this, GetType(), "swal-rej", script, true);
                CargarSolicitudes();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error Rechazar: " + ex.Message);
            }
        }
    }
}
