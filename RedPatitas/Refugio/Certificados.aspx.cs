using System;
using System.Web.UI;
using CapaNegocios;

namespace RedPatitas.Refugio
{
    public partial class Certificados : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarCertificados();
            }
        }

        private void CargarCertificados()
        {
            try
            {
                int idRefugio = Convert.ToInt32(Session["RefugioId"]);
                var listado = CN_CertificadoService.ObtenerCertificadosPorRefugio(idRefugio);
                
                gvCertificados.DataSource = listado;
                gvCertificados.DataBind();
                
                if (listado.Count > 0)
                {
                    gvCertificados.UseAccessibleHeader = true;
                    gvCertificados.HeaderRow.TableSection = System.Web.UI.WebControls.TableRowSection.TableHeader;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar certificados del refugio: " + ex.Message);
            }
        }
    }
}
