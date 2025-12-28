using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.Login
{
    public partial class Registro : System.Web.UI.Page
    {
        CN_UsuarioService objUsuario = new CN_UsuarioService();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            bool esRefugio = rbRefugio.Checked;

            // Validación del lado del servidor - campos comunes
            if (string.IsNullOrEmpty(txtEmail.Text.Trim()) ||
                string.IsNullOrEmpty(txtPassword.Text) ||
                string.IsNullOrEmpty(txtConfirmPassword.Text))
            {
                MostrarAlerta("warning", "Campos incompletos", "Por favor, complete todos los campos.");
                return;
            }

            // Validar campos personales solo para Adoptante
            if (!esRefugio)
            {
                if (string.IsNullOrEmpty(txtNombres.Text.Trim()) ||
                    string.IsNullOrEmpty(txtApellidos.Text.Trim()))
                {
                    MostrarAlerta("warning", "Campos incompletos", "Por favor, ingresa tu nombre y apellido.");
                    return;
                }
            }

            // Validar campos de Refugio
            if (esRefugio)
            {
                if (string.IsNullOrEmpty(txtNombreRefugio.Text.Trim()) ||
                    string.IsNullOrEmpty(txtTelefonoRefugio.Text.Trim()) ||
                    string.IsNullOrEmpty(txtCiudadRefugio.Text.Trim()) ||
                    string.IsNullOrEmpty(txtDireccionRefugio.Text.Trim()))
                {
                    MostrarAlerta("warning", "Campos incompletos", "Por favor, complete todos los campos del refugio.");
                    return;
                }
            }

            if (txtPassword.Text != txtConfirmPassword.Text)
            {
                MostrarAlerta("error", "Error", "Las contraseñas no coinciden.");
                return;
            }

            if (txtPassword.Text.Length < 8)
            {
                MostrarAlerta("error", "Error", "La contraseña debe tener al menos 8 caracteres.");
                return;
            }

            if (!chkTerminos.Checked)
            {
                MostrarAlerta("warning", "Términos y condiciones", "Debes aceptar los términos y condiciones.");
                return;
            }

            try
            {
                if (esRefugio)
                {
                    // Datos del refugio
                    string nombreRefugio = txtNombreRefugio.Text.Trim();
                    string descripcionRefugio = txtDescripcionRefugio.Text.Trim();
                    string telefonoRefugio = txtTelefonoRefugio.Text.Trim();
                    string ciudadRefugio = txtCiudadRefugio.Text.Trim();
                    string direccionRefugio = txtDireccionRefugio.Text.Trim();
                    string emailRefugio = txtEmail.Text.Trim();
                    string password = txtPassword.Text;

                    var resultado = objUsuario.RegistrarRefugio(
                        nombreRefugio, descripcionRefugio, telefonoRefugio,
                        ciudadRefugio, direccionRefugio, emailRefugio, password);

                    if (!resultado.Exito)
                    {
                        MostrarAlerta("error", "Error", resultado.Mensaje);
                        return;
                    }
                    
                    string script = @"
                        Swal.fire({
                            icon: 'success',
                            title: '¡Solicitud enviada!',
                            html: '<p style=""font-size: 16px;"">Tu solicitud de registro como refugio ha sido enviada.</p><p style=""font-size: 16px;""><strong>Un administrador verificará tu información</strong> y te notificaremos cuando esté aprobada.</p>',
                            showConfirmButton: true,
                            confirmButtonColor: '#FF8C42',
                            confirmButtonText: 'Entendido'
                        }).then(function() {
                            window.location.href = 'Login.aspx';
                        });";
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "alertSuccess", script, true);
                }
                else
                {
                    // Registro de adoptante (rol 4)
                    string nombres = txtNombres.Text.Trim();
                    string apellidos = txtApellidos.Text.Trim();
                    string email = txtEmail.Text.Trim();
                    string password = txtPassword.Text;

                    var resultado = objUsuario.RegistrarAdoptante(nombres, apellidos, email, password);

                    if (!resultado.Exito)
                    {
                        MostrarAlerta("error", "Error", resultado.Mensaje);
                        return;
                    }
                    
                    string script = @"
                        Swal.fire({
                            icon: 'success',
                            title: '¡Cuenta creada!',
                            html: '<p style=""font-size: 16px;"">Tu cuenta ha sido creada exitosamente.</p><p style=""font-size: 16px;"">Redirigiendo al inicio de sesión...</p>',
                            timer: 2500,
                            showConfirmButton: false
                        }).then(function() {
                            window.location.href = 'Login.aspx';
                        });";
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "alertSuccess", script, true);
                }
            }
            catch (Exception ex)
            {
                MostrarAlerta("error", "Error", "Ocurrió un error al crear la cuenta: " + ex.Message);
            }
        }

        private void MostrarAlerta(string icon, string title, string text)
        {
            string script = $@"
                Swal.fire({{
                    icon: '{icon}',
                    title: '{title}',
                    html: '<p style=""font-size: 16px;"">{text}</p>',
                    confirmButtonColor: '#FF8C42'
                }});";
            Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", script, true);
        }
    }
}