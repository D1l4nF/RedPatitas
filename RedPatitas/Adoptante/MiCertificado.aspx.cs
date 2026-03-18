using System;
using System.Web.UI;
using CapaNegocios;

namespace RedPatitas.Adoptante
{
    public partial class MiCertificado : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Verificar sesión
                int rolId = Convert.ToInt32(Session["RolId"]);
                if (Session["UsuarioId"] == null || Session["RolId"] == null || (rolId != 4 && rolId != 2 && rolId != 3))
                {
                    Response.Redirect("~/Login/Login.aspx");
                    return;
                }

                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);
                string idSolicitudParam = Request.QueryString["id"];

                if (!string.IsNullOrEmpty(idSolicitudParam) && int.TryParse(idSolicitudParam, out int idSolicitud))
                {
                    CargarCertificado(idSolicitud, idUsuario, rolId);
                }
                else
                {
                    if (rolId != 4)
                    {
                        Response.Redirect("~/Login/Login.aspx");
                        return;
                    }
                    CargarCertificadoReciente(idUsuario);
                }
            }
        }

        private void CargarCertificado(int idSolicitud, int idUsuarioLogueado, int rolId)
        {
            try
            {
                var solicitud = CN_AdopcionService.ObtenerSolicitudPorId(idSolicitud);
                if (solicitud == null || solicitud.Estado != "Aprobada")
                {
                    MostrarError();
                    return;
                }

                // Si es adoptante (4), validar que sea SU solicitud. Si es admin (2, 3), dejar pasar.
                if (rolId == 4 && solicitud.IdAdoptante != idUsuarioLogueado)
                {
                    MostrarError();
                    return;
                }

                // Obtener el certificado
                var certificado = CN_CertificadoService.ObtenerCertificadoPorSolicitud(idSolicitud);
                if (certificado != null)
                {
                    pnlCertificadoExito.Visible = true;
                    pnlError.Visible = false;

                    litNombreAdoptante.Text = certificado.NombreAdoptante;
                    litNombreMascota.Text = certificado.NombreMascota;
                    litEspecie.Text = certificado.EspecieMascota;
                    litRaza.Text = certificado.RazaMascota;
                    
                    litNombreRefugio.Text = certificado.NombreRefugio;
                    litFirmaAdoptante.Text = certificado.NombreAdoptante;
                    
                    litCodigo.Text = certificado.CodigoCertificado;
                    litFechaEmision.Text = certificado.FechaEmision?.ToString("dd 'de' MMMM 'de' yyyy");
                }
                else
                {
                    MostrarError();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar certificado: " + ex.Message);
                MostrarError();
            }
        }

        private void CargarCertificadoReciente(int idUsuarioLogueado)
        {
            try
            {
                var certificado = CN_CertificadoService.ObtenerCertificadoMasRecientePorAdoptante(idUsuarioLogueado);
                if (certificado != null)
                {
                    pnlCertificadoExito.Visible = true;
                    pnlError.Visible = false;

                    litNombreAdoptante.Text = certificado.NombreAdoptante;
                    litNombreMascota.Text = certificado.NombreMascota;
                    litEspecie.Text = certificado.EspecieMascota;
                    litRaza.Text = certificado.RazaMascota;
                    
                    litNombreRefugio.Text = certificado.NombreRefugio;
                    litFirmaAdoptante.Text = certificado.NombreAdoptante;
                    
                    litCodigo.Text = certificado.CodigoCertificado;
                    litFechaEmision.Text = certificado.FechaEmision?.ToString("dd 'de' MMMM 'de' yyyy");
                }
                else
                {
                    MostrarError();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar certificado reciente: " + ex.Message);
                MostrarError();
            }
        }

        private void MostrarError()
        {
            pnlCertificadoExito.Visible = false;
            pnlError.Visible = true;
        }
    }
}
