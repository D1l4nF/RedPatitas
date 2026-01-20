using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.Login
{
    public partial class Login : System.Web.UI.Page
    {
        CN_UsuarioService objUsuario = new CN_UsuarioService();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtEmail.Text) || string.IsNullOrEmpty(txtPassword.Text))
            {
                MostrarAlerta("warning", "Campos incompletos", "Por favor, complete todos los campos.");
                return;
            }
            
            var resultado = objUsuario.ValidarLogin(txtEmail.Text, txtPassword.Text);
            if (!resultado.Exito)
            {
                // Detectar tipo de error y mostrar alerta apropiada
                if (resultado.Mensaje.Contains("bloqueado"))
                {
                    // Usuario bloqueado
                    string scriptBloqueo = @"
                        Swal.fire({
                            icon: 'error',
                            title: '🔒 Cuenta Bloqueada',
                            html: '<p style=""font-size: 16px;"">Tu cuenta ha sido bloqueada por múltiples intentos fallidos.</p><p style=""font-size: 16px;""><strong>Contacta al administrador</strong> para desbloquear tu cuenta.</p>',
                            confirmButtonColor: '#DC3545',
                            confirmButtonText: 'Entendido'
                        });";
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "alertBloqueo", scriptBloqueo, true);
                }
                else if (resultado.Mensaje.Contains("Intentos Restantes"))
                {
                    // Contraseña incorrecta con intentos restantes
                    string intentos = System.Text.RegularExpressions.Regex.Match(resultado.Mensaje, @"\d+").Value;
                    string iconClass = intentos == "1" ? "error" : "warning";
                    
                    string scriptIntentos = $@"
                        Swal.fire({{
                            icon: '{iconClass}',
                            title: 'Contraseña Incorrecta',
                            html: '<p style=""font-size: 16px;"">La contraseña ingresada no es correcta.</p><p style=""font-size: 18px; color: #DC3545;""><strong>Intentos restantes: {intentos}</strong></p>',
                            confirmButtonColor: '#FF8C42',
                            confirmButtonText: 'Intentar de nuevo'
                        }});";
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "alertIntentos", scriptIntentos, true);
                }
                else if (resultado.Mensaje.Contains("invalidas") || resultado.Mensaje.Contains("inválidas"))
                {
                    // Correo no existe
                    string scriptNoExiste = @"
                        Swal.fire({
                            icon: 'error',
                            title: 'Correo no registrado',
                            html: '<p style=""font-size: 16px;"">El correo electrónico ingresado no está registrado en el sistema.</p><p style=""font-size: 16px;"">¿Deseas <a href=""Registro.aspx"" style=""color: #FF8C42; font-weight: bold;"">crear una cuenta</a>?</p>',
                            confirmButtonColor: '#FF8C42',
                            confirmButtonText: 'Entendido'
                        });";
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "alertNoExiste", scriptNoExiste, true);
                }
                else
                {
                    // Otro tipo de error
                    MostrarAlerta("error", "Error de autenticación", resultado.Mensaje);
                }
                return;
            }
            
            Session["UsuarioId"] = resultado.UsuarioId;
            Session["NombreUsuario"] = resultado.NombreUsuario;
            Session["RolId"] = resultado.RolId;

            if((resultado.RolId == 2 || resultado.RolId == 3) && resultado.RefugioId != null ) 
            {
                Session["RefugioId"] = resultado.RefugioId;
                Session["Ref_Verificado"] = resultado.Ref_Verificado;
            }
            
            // Determinar URL de redirección según rol
            string redirectUrl = "";
            if (resultado.RolId == 1) // SuperAdmin
            {
                redirectUrl = "../Admin/Dashboard.aspx";
            }
            else if (resultado.RolId == 2) // AdminRefugio
            {
                redirectUrl = "../AdminRefugio/Dashboard.aspx";
            }
            else if (resultado.RolId == 3) // Refugio
            {
                redirectUrl = "../Refugio/Dashboard.aspx";
            }
            else if (resultado.RolId == 4) // Adoptante
            {
                redirectUrl = "../Adoptante/Dashboard.aspx";
            }
            else
            {
                MostrarAlerta("error", "Error", "Rol de usuario desconocido.");
                return;
            }
            
            // Mostrar alerta de éxito y redirigir
            string script = $@"
                Swal.fire({{
                    icon: 'success',
                    title: '¡Bienvenido!',
                    text: 'Iniciando sesión...',
                    timer: 1500,
                    showConfirmButton: false
                }}).then(function() {{
                    window.location.href = '{redirectUrl}';
                }});";
            Page.ClientScript.RegisterStartupScript(this.GetType(), "alertSuccess", script, true);
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