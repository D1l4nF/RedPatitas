using System;
using System.Web.UI;
using CapaNegocios;

namespace RedPatitas
{
    public partial class VerCertificado : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Solo AdminRefugio(2), Refugio(3) y SuperAdmin(1) pueden entrar libremente a VER cualquier certificado.
                // Adoptante(4) puede entrar solo si es suyo, pero MiCertificado.aspx es su página principal.
                // Igual permitiremos Rol 4 aquí con verificación, para que sea un visor universal.
                if (Session["UsuarioId"] == null || Session["RolId"] == null)
                {
                    Response.Redirect("~/Login/Login.aspx");
                    return;
                }

                int rolId = Convert.ToInt32(Session["RolId"]);
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);
                string idSolicitudParam = Request.QueryString["id"];

                if (!string.IsNullOrEmpty(idSolicitudParam) && int.TryParse(idSolicitudParam, out int idSolicitud))
                {
                    CargarCertificado(idSolicitud, idUsuario, rolId);
                }
                else
                {
                    MostrarError();
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

                // Si es adoptante (4), validar que sea SU certificado
                if (rolId == 4 && solicitud.IdAdoptante != idUsuarioLogueado)
                {
                    MostrarError();
                    return;
                }

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
                System.Diagnostics.Debug.WriteLine("Error al cargar VerCertificado: " + ex.Message);
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
