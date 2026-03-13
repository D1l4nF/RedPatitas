using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.AdminRefugio
{
    public partial class HistorialSolicitudes : System.Web.UI.Page
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
                CargarHistorial();
            }
        }

        private void CargarHistorial()
        {
            try
            {
                int idRefugio = Convert.ToInt32(Session["RefugioId"]);
                // Traer TODAS las solicitudes del refugio, que por defecto vienen ordenadas de más reciente a más vieja
                var solicitudes = CN_AdopcionService.SolicitudesRecibidasTodas(idRefugio, "Todas");
                
                if (solicitudes != null && solicitudes.Count > 0)
                {
                    rptHistorial.DataSource = solicitudes;
                    rptHistorial.DataBind();
                }
                else
                {
                    // No hay datos, ocultar repeater y mostrar mensaje en el ItemTemplate o fila
                    // As we are setting a server control inside the table, we'll just manipulate trNoData
                    var trNoData = (System.Web.UI.HtmlControls.HtmlTableRow)Master.FindControl("MainContent").FindControl("trNoData");
                    if (trNoData != null) trNoData.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error CargarHistorial: " + ex.Message);
            }
        }
    }
}
