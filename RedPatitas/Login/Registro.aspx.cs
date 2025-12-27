using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RedPatitas.Login
{
    public partial class Registro : System.Web.UI.Page
    {
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
                    // Datos del refugio (sin datos personales)
                    string nombreRefugio = txtNombreRefugio.Text.Trim();
                    string descripcionRefugio = txtDescripcionRefugio.Text.Trim();
                    string telefonoRefugio = txtTelefonoRefugio.Text.Trim();
                    string ciudadRefugio = txtCiudadRefugio.Text.Trim();
                    string direccionRefugio = txtDireccionRefugio.Text.Trim();
                    string emailRefugio = txtEmail.Text.Trim();
                    string password = txtPassword.Text;

                    // TODO: Implementar registro de refugio
                    // 1. Crear el refugio en tbl_Refugios:
                    //    - ref_Nombre = nombreRefugio
                    //    - ref_Descripcion = descripcionRefugio
                    //    - ref_Telefono = telefonoRefugio
                    //    - ref_Ciudad = ciudadRefugio
                    //    - ref_Direccion = direccionRefugio
                    //    - ref_Email = emailRefugio
                    //    - ref_Verificado = 0 (pendiente de verificación)
                    //
                    // 2. Crear cuenta de usuario para el refugio:
                    //    - usu_IdRol = 3 (Refugio) - o 2 (AdminRefugio) depende del flujo
                    //    - usu_Nombre = nombreRefugio (usar nombre del refugio)
                    //    - usu_Apellido = "" (vacío o null)
                    //    - usu_Email = emailRefugio
                    //    - usu_Contrasena = password (hasheado)
                    //    - usu_IdRefugio = ID del refugio creado
                    
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

                    // TODO: Implementar registro de adoptante
                    // Crear usuario con usu_IdRol = 4 (Adoptante), usu_IdRefugio = NULL
                    
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
            catch (Exception)
            {
                MostrarAlerta("error", "Error", "Ocurrió un error al crear la cuenta.");
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