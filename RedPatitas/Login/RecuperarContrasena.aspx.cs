using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.Login
{
    public partial class RecuperarContrasena : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnEnviar_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim().ToLower();

            if (string.IsNullOrEmpty(email))
            {
                MostrarMensaje("error", "Error", "Por favor ingresa tu correo electrónico.");
                return;
            }

            try
            {
                CN_UsuarioService usuarioService = new CN_UsuarioService();
                string token = usuarioService.GenerarTokenRecuperacion(email);

                // Por seguridad, siempre mostramos el mismo mensaje
                // aunque el email no exista en la base de datos
                if (token != null)
                {
                    // Construir URL base
                    string urlBase = Request.Url.GetLeftPart(UriPartial.Authority);
                    
                    // Enviar email con las instrucciones
                    CN_EmailService emailService = new CN_EmailService();
                    bool enviado = emailService.EnviarEmailRecuperacion(email, token, urlBase);
                    
                    if (!enviado)
                    {
                        System.Diagnostics.Debug.WriteLine("Error al enviar email de recuperación");
                    }
                }

                // Siempre mostramos el mismo mensaje por seguridad
                MostrarMensajeConRedireccion("success", "¡Instrucciones enviadas!", 
                    "Si el correo existe en nuestro sistema, recibirás un email con las instrucciones para restablecer tu contraseña.",
                    "Login.aspx");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error en recuperación: {ex.Message}");
                MostrarMensaje("error", "Error", "Ocurrió un error. Por favor intenta más tarde.");
            }
        }

        private void MostrarMensaje(string tipo, string titulo, string mensaje)
        {
            string script = $@"
                Swal.fire({{
                    icon: '{tipo}',
                    title: '{titulo}',
                    text: '{mensaje}',
                    confirmButtonColor: '#FF8C42'
                }});
            ";
            ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlert", script, true);
        }

        private void MostrarMensajeConRedireccion(string tipo, string titulo, string mensaje, string url)
        {
            string script = $@"
                Swal.fire({{
                    icon: '{tipo}',
                    title: '{titulo}',
                    text: '{mensaje}',
                    confirmButtonColor: '#FF8C42'
                }}).then((result) => {{
                    window.location.href = '{url}';
                }});
            ";
            ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlert", script, true);
        }
    }
}