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

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarSolicitudes();
            }
        }

        private void CargarSolicitudes()
        {
            try
            {
                object raw = Session["IdUsuario"] ?? Session["UsuarioId"];
                if (raw == null || !int.TryParse(raw.ToString(), out int idUsuario))
                {
                    Response.Redirect("~/Login.aspx");
                    return;
                }

                var solicitudes = CN_AdopcionService.MisSolicitudes(idUsuario);

                // Forzar datos de prueba para ver si es problema de datos
                if (solicitudes == null || solicitudes.Count == 0)
                {
                    // Crear datos dummy para probar si el GridView se renderiza
                    var datosDummy = new List<dynamic>
            {
                new {
                    NombreMascota = "Rex",
                    sol_FechaSolicitud = DateTime.Now,
                    sol_Estado = "Pendiente",
                    sol_IdSolicitud = 999
                }
            };

                    gvSolicitudes.DataSource = datosDummy;
                }
                else
                {
                    gvSolicitudes.DataSource = solicitudes;
                }

                gvSolicitudes.DataBind();

                System.Diagnostics.Debug.WriteLine($"GridView Filas: {gvSolicitudes.Rows.Count}");
            }
            catch (Exception ex)
            {
                
                Label lblError = new Label();
                lblError.Text = $"Error: {ex.Message}";
                lblError.CssClass = "alert alert-danger";
                this.Form.Controls.Add(lblError);

                System.Diagnostics.Debug.WriteLine($"ERROR en CargarSolicitudes: {ex.ToString()}");
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            int idSolicitud = int.Parse(((System.Web.UI.WebControls.Button)sender).CommandArgument);

            CN_AdopcionService.Rechazar(idSolicitud, "Cancelada por el usuario");
            CargarSolicitudes();
        }
    }
}