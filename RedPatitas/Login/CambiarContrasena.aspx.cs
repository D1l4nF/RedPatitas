using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.Login
{
    public partial class CambiarContrasena : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string token = Request.QueryString["token"];

                if (string.IsNullOrEmpty(token))
                {
                    MostrarTokenInvalido();
                    return;
                }

                CN_UsuarioService usuarioService = new CN_UsuarioService();
                
                if (!usuarioService.ValidarToken(token))
                {
                    MostrarTokenInvalido();
                    return;
                }

                // Token válido - mostrar formulario
                hfToken.Value = token;
                string email = usuarioService.ObtenerEmailPorToken(token);
                if (!string.IsNullOrEmpty(email))
                {
                    // Ocultar parcialmente el email (ej: u***@email.com)
                    litEmail.Text = "Ingresa tu nueva contraseña para: " + OcultarEmail(email);
                }
            }
        }

        protected void btnCambiar_Click(object sender, EventArgs e)
        {
            string token = hfToken.Value;
            string nuevaContrasena = txtNuevaContrasena.Text;
            string confirmarContrasena = txtConfirmarContrasena.Text;

            // Validaciones
            if (string.IsNullOrEmpty(nuevaContrasena) || string.IsNullOrEmpty(confirmarContrasena))
            {
                MostrarMensaje("error", "Error", "Por favor completa todos los campos.");
                return;
            }

            if (nuevaContrasena.Length < 8)
            {
                MostrarMensaje("error", "Contraseña muy corta", "La contraseña debe tener al menos 8 caracteres.");
                return;
            }

            if (nuevaContrasena != confirmarContrasena)
            {
                MostrarMensaje("error", "Error", "Las contraseñas no coinciden.");
                return;
            }

            try
            {
                CN_UsuarioService usuarioService = new CN_UsuarioService();
                var resultado = usuarioService.CambiarContrasenaConToken(token, nuevaContrasena);

                if (resultado.Exito)
                {
                    MostrarMensajeConRedireccion("success", "¡Contraseña actualizada!", 
                        "Ya puedes iniciar sesión con tu nueva contraseña.", "Login.aspx");
                }
                else
                {
                    MostrarMensaje("error", "Error", resultado.Mensaje);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error al cambiar contraseña: {ex.Message}");
                MostrarMensaje("error", "Error", "Ocurrió un error. Por favor intenta más tarde.");
            }
        }

        private void MostrarTokenInvalido()
        {
            pnlCambiarContrasena.Visible = false;
            pnlTokenInvalido.Visible = true;
        }

        private string OcultarEmail(string email)
        {
            if (string.IsNullOrEmpty(email)) return "";
            
            int indexArroba = email.IndexOf('@');
            if (indexArroba <= 1) return email;

            string parte1 = email.Substring(0, 1);
            string parte2 = email.Substring(indexArroba);
            return parte1 + "***" + parte2;
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
