using System;
using System.Web.UI;
using CapaDatos;
using System.Linq;

namespace RedPatitas.Adoptante
{
    public partial class ReportarMascota : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificar sesión
            if (Session["UsuarioId"] == null)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Precargar email del usuario si está disponible
                try
                {
                    int idUsuario = Convert.ToInt32(Session["UsuarioId"]);
                    using (var db = new DataClasses1DataContext())
                    {
                        var usuario = db.tbl_Usuarios.FirstOrDefault(u => u.usu_IdUsuario == idUsuario);
                        if (usuario != null)
                        {
                            txtEmail.Text = usuario.usu_Email;
                            txtTelefono.Text = usuario.usu_Telefono;
                        }
                    }
                }
                catch { }
            }
        }

        /// <summary>
        /// Envía el reporte de mascota
        /// </summary>
        protected void btnEnviar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);
                string tipoReporte = rbPerdida.Checked ? "Perdida" : "Encontrada";

                using (var db = new DataClasses1DataContext())
                {
                    var reporte = new tbl_ReportesMascotas
                    {
                        rep_IdUsuario = idUsuario,
                        rep_TipoReporte = tipoReporte,
                        rep_NombreMascota = txtNombre.Text.Trim(),
                        rep_IdEspecie = !string.IsNullOrEmpty(ddlEspecie.SelectedValue) 
                            ? int.Parse(ddlEspecie.SelectedValue) 
                            : (int?)null,
                        rep_Raza = txtRaza.Text.Trim(),
                        rep_Color = txtColor.Text.Trim(),
                        rep_Tamano = ddlTamano.SelectedValue,
                        rep_Sexo = !string.IsNullOrEmpty(ddlSexo.SelectedValue) 
                            ? ddlSexo.SelectedValue[0] 
                            : (char?)null,
                        rep_EdadAproximada = ddlEdad.SelectedValue,
                        rep_Descripcion = txtDescripcion.Text.Trim(),
                        rep_UbicacionUltima = txtUbicacion.Text.Trim(),
                        rep_Ciudad = txtCiudad.Text.Trim(),
                        rep_TelefonoContacto = txtTelefono.Text.Trim(),
                        rep_EmailContacto = txtEmail.Text.Trim(),
                        rep_Estado = "Reportado",
                        rep_FechaReporte = DateTime.Now
                    };

                    // Coordenadas del mapa
                    if (!string.IsNullOrEmpty(hfLatitud.Value) && !string.IsNullOrEmpty(hfLongitud.Value))
                    {
                        reporte.rep_Latitud = decimal.Parse(hfLatitud.Value, System.Globalization.CultureInfo.InvariantCulture);
                        reporte.rep_Longitud = decimal.Parse(hfLongitud.Value, System.Globalization.CultureInfo.InvariantCulture);
                    }

                    // Fecha del evento
                    if (!string.IsNullOrEmpty(txtFecha.Text))
                    {
                        reporte.rep_FechaEvento = DateTime.Parse(txtFecha.Text);
                    }

                    db.tbl_ReportesMascotas.InsertOnSubmit(reporte);
                    db.SubmitChanges();

                    // Mostrar mensaje de éxito
                    pnlMensaje.Visible = true;
                    pnlMensaje.CssClass = "alert alert-success";
                    lblMensaje.Text = "✅ ¡Reporte enviado exitosamente! Gracias por ayudar a reunir mascotas con sus familias.";
                    lblMensaje.ForeColor = System.Drawing.Color.Green;

                    // Limpiar formulario
                    LimpiarFormulario();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al enviar reporte: " + ex.Message);
                pnlMensaje.Visible = true;
                lblMensaje.Text = "❌ Error al enviar el reporte. Por favor intenta de nuevo.";
                lblMensaje.ForeColor = System.Drawing.Color.Red;
            }
        }

        /// <summary>
        /// Limpia el formulario después de enviar
        /// </summary>
        private void LimpiarFormulario()
        {
            txtNombre.Text = "";
            ddlEspecie.SelectedIndex = 0;
            txtRaza.Text = "";
            txtColor.Text = "";
            ddlTamano.SelectedIndex = 0;
            ddlSexo.SelectedIndex = 0;
            ddlEdad.SelectedIndex = 0;
            txtDescripcion.Text = "";
            txtUbicacion.Text = "";
            txtCiudad.Text = "";
            txtFecha.Text = "";
            hfLatitud.Value = "";
            hfLongitud.Value = "";
            rbPerdida.Checked = true;
            rbEncontrada.Checked = false;
        }
    }
}
