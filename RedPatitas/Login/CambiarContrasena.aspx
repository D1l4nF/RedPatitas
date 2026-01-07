<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CambiarContrasena.aspx.cs"
    Inherits="RedPatitas.Login.CambiarContrasena" %>

    <!DOCTYPE html>

    <html lang="es">

    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Cambiar contraseña del Sistema de Adopción de Mascotas">
        <title>Cambiar Contraseña - RedPatitas</title>
        <link rel="stylesheet" href="~/Style/auth.css">
        <link rel="stylesheet" href="~/Style/ux-components.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">
        <!-- SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>

    <body>
        <form id="form1" runat="server">
            <div class="container">
                <div class="login-card">
                    <div class="login-header">
                        <div class="logo-container">
                            <div class="logo-icon">
                                <!-- Paw Icon -->
                                <svg viewBox="0 0 24 24" fill="currentColor" width="32" height="32">
                                    <path
                                        d="M12,11.36C12.55,11.36 13,10.91 13,10.36V8.36C13,7.81 12.55,7.36 12,7.36C11.45,7.36 11,7.81 11,8.36V10.36C11,10.91 11.45,11.36 12,11.36M12,12.36C10.5,12.36 9.1,12.76 7.9,13.46C7.3,12.86 6.4,12.36 5.5,12.36C3.5,12.36 2,13.86 2,15.86C2,17.86 3.5,19.36 5.5,19.36C6.5,19.36 7.4,18.96 8.1,18.26C9,19.56 10.4,20.36 12,20.36C13.6,20.36 15,19.56 15.9,18.26C16.6,18.96 17.5,19.36 18.5,19.36C20.5,19.36 22,17.86 22,15.86C22,13.86 20.5,12.36 18.5,12.36C17.6,12.36 16.7,12.86 16.1,13.46C14.9,12.76 13.5,12.36 12,12.36M5.5,13.36C6.9,13.36 8,14.46 8,15.86C8,17.26 6.9,18.36 5.5,18.36C4.1,18.36 3,17.26 3,15.86C3,14.46 4.1,13.36 5.5,13.36M18.5,13.36C19.9,13.36 21,14.46 21,15.86C21,17.26 19.9,18.36 18.5,18.36C17.1,18.36 16,17.26 16,15.86C16,14.46 17.1,13.36 18.5,13.36M12,13.36C13.9,13.36 15.5,14.76 15.5,16.56C15.5,18.36 13.9,19.76 12,19.76C10.1,19.76 8.5,18.36 8.5,16.56C8.5,14.76 10.1,13.36 12,13.36M8,6.36C8.55,6.36 9,5.91 9,5.36V3.36C9,2.81 8.55,2.36 8,2.36C7.45,2.36 7,2.81 7,3.36V5.36C7,5.91 7.45,6.36 8,6.36M16,6.36C16.55,6.36 17,5.91 17,5.36V3.36C17,2.81 16.55,2.36 16,2.36C15.45,2.36 15,2.81 15,3.36V5.36C15,5.91 15.45,6.36 16,6.36Z" />
                                </svg>
                            </div>
                        </div>
                        <h1>Nueva Contraseña</h1>
                        <p class="subtitle">
                            <asp:Literal ID="litEmail" runat="server"></asp:Literal>
                        </p>
                    </div>

                    <!-- Panel de token inválido -->
                    <asp:Panel ID="pnlTokenInvalido" runat="server" Visible="false">
                        <div style="text-align: center; padding: 20px;">
                            <svg viewBox="0 0 24 24" fill="none" stroke="#e74c3c" stroke-width="2" width="64"
                                height="64" style="margin-bottom: 16px;">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="15" y1="9" x2="9" y2="15"></line>
                                <line x1="9" y1="9" x2="15" y2="15"></line>
                            </svg>
                            <h2 style="color: #e74c3c; margin-bottom: 8px;">Enlace Inválido</h2>
                            <p style="color: #666; margin-bottom: 20px;">El enlace ha expirado o ya fue utilizado.</p>
                            <a href="RecuperarContrasena.aspx" class="btn-primary"
                                style="display: inline-block; text-decoration: none;">
                                <span class="btn-text">Solicitar Nuevo Enlace</span>
                            </a>
                        </div>
                    </asp:Panel>

                    <!-- Panel de cambio de contraseña -->
                    <asp:Panel ID="pnlCambiarContrasena" runat="server" DefaultButton="btnCambiar">
                        <asp:HiddenField ID="hfToken" runat="server" />

                        <div class="form-group">
                            <label for="txtNuevaContrasena">Nueva Contraseña</label>
                            <div class="input-wrapper has-toggle">
                                <!-- Lock Icon -->
                                <svg class="input-icon" viewBox="0 0 24 24" fill="none"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2" stroke="currentColor"
                                        stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                                    <path
                                        d="M7 11V7C7 5.67392 7.52678 4.40215 8.46447 3.46447C9.40215 2.52678 10.6739 2 12 2C13.3261 2 14.5979 2.52678 15.5355 3.46447C16.4732 4.40215 17 5.67392 17 7V11"
                                        stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                        stroke-linejoin="round" />
                                </svg>
                                <asp:TextBox ID="txtNuevaContrasena" runat="server" TextMode="Password"
                                    placeholder="Mínimo 8 caracteres" CssClass="form-control" ClientIDMode="Static">
                                </asp:TextBox>
                                <button type="button" class="password-toggle" data-target="txtNuevaContrasena"
                                    aria-label="Mostrar contraseña">
                                    <svg class="icon-eye" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                        <circle cx="12" cy="12" r="3"></circle>
                                    </svg>
                                    <svg class="icon-eye-off" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2" style="display: none;">
                                        <path
                                            d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24">
                                        </path>
                                        <line x1="1" y1="1" x2="23" y2="23"></line>
                                    </svg>
                                </button>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="txtConfirmarContrasena">Confirmar Contraseña</label>
                            <div class="input-wrapper has-toggle">
                                <!-- Lock Icon -->
                                <svg class="input-icon" viewBox="0 0 24 24" fill="none"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2" stroke="currentColor"
                                        stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                                    <path
                                        d="M7 11V7C7 5.67392 7.52678 4.40215 8.46447 3.46447C9.40215 2.52678 10.6739 2 12 2C13.3261 2 14.5979 2.52678 15.5355 3.46447C16.4732 4.40215 17 5.67392 17 7V11"
                                        stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                        stroke-linejoin="round" />
                                </svg>
                                <asp:TextBox ID="txtConfirmarContrasena" runat="server" TextMode="Password"
                                    placeholder="Repite tu contraseña" CssClass="form-control" ClientIDMode="Static">
                                </asp:TextBox>
                                <button type="button" class="password-toggle" data-target="txtConfirmarContrasena"
                                    aria-label="Mostrar contraseña">
                                    <svg class="icon-eye" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                        <circle cx="12" cy="12" r="3"></circle>
                                    </svg>
                                    <svg class="icon-eye-off" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2" style="display: none;">
                                        <path
                                            d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24">
                                        </path>
                                        <line x1="1" y1="1" x2="23" y2="23"></line>
                                    </svg>
                                </button>
                            </div>
                        </div>

                        <asp:LinkButton ID="btnCambiar" runat="server" CssClass="btn-primary"
                            OnClick="btnCambiar_Click">
                            <span class="btn-text">Cambiar Contraseña</span>
                        </asp:LinkButton>
                    </asp:Panel>

                    <p class="signup-link">
                        <a href="~/Login/Login.aspx" runat="server">Volver al Inicio de Sesión</a>
                    </p>
                </div>

                <div class="background-decoration">
                    <svg class="paw-print" style="left: 10%; top: 10%; width: 60px;" viewBox="0 0 24 24"
                        fill="currentColor">
                        <path
                            d="M12,11.36C12.55,11.36 13,10.91 13,10.36V8.36C13,7.81 12.55,7.36 12,7.36C11.45,7.36 11,7.81 11,8.36V10.36C11,10.91 11.45,11.36 12,11.36M12,12.36C10.5,12.36 9.1,12.76 7.9,13.46C7.3,12.86 6.4,12.36 5.5,12.36C3.5,12.36 2,13.86 2,15.86C2,17.86 3.5,19.36 5.5,19.36C6.5,19.36 7.4,18.96 8.1,18.26C9,19.56 10.4,20.36 12,20.36C13.6,20.36 15,19.56 15.9,18.26C16.6,18.96 17.5,19.36 18.5,19.36C20.5,19.36 22,17.86 22,15.86C22,13.86 20.5,12.36 18.5,12.36C17.6,12.36 16.7,12.86 16.1,13.46C14.9,12.76 13.5,12.36 12,12.36M5.5,13.36C6.9,13.36 8,14.46 8,15.86C8,17.26 6.9,18.36 5.5,18.36C4.1,18.36 3,17.26 3,15.86C3,14.46 4.1,13.36 5.5,13.36M18.5,13.36C19.9,13.36 21,14.46 21,15.86C21,17.26 19.9,18.36 18.5,18.36C17.1,18.36 16,17.26 16,15.86C16,14.46 17.1,13.36 18.5,13.36M12,13.36C13.9,13.36 15.5,14.76 15.5,16.56C15.5,18.36 13.9,19.76 12,19.76C10.1,19.76 8.5,18.36 8.5,16.56C8.5,14.76 10.1,13.36 12,13.36M8,6.36C8.55,6.36 9,5.91 9,5.36V3.36C9,2.81 8.55,2.36 8,2.36C7.45,2.36 7,2.81 7,3.36V5.36C7,5.91 7.45,6.36 8,6.36M16,6.36C16.55,6.36 17,5.91 17,5.36V3.36C17,2.81 16.55,2.36 16,2.36C15.45,2.36 15,2.81 15,3.36V5.36C15,5.91 15.45,6.36 16,6.36Z" />
                    </svg>
                    <svg class="paw-print" style="right: 15%; bottom: 15%; width: 80px; animation-delay: 5s;"
                        viewBox="0 0 24 24" fill="currentColor">
                        <path
                            d="M12,11.36C12.55,11.36 13,10.91 13,10.36V8.36C13,7.81 12.55,7.36 12,7.36C11.45,7.36 11,7.81 11,8.36V10.36C11,10.91 11.45,11.36 12,11.36M12,12.36C10.5,12.36 9.1,12.76 7.9,13.46C7.3,12.86 6.4,12.36 5.5,12.36C3.5,12.36 2,13.86 2,15.86C2,17.86 3.5,19.36 5.5,19.36C6.5,19.36 7.4,18.96 8.1,18.26C9,19.56 10.4,20.36 12,20.36C13.6,20.36 15,19.56 15.9,18.26C16.6,18.96 17.5,19.36 18.5,19.36C20.5,19.36 22,17.86 22,15.86C22,13.86 20.5,12.36 18.5,12.36C17.6,12.36 16.7,12.86 16.1,13.46C14.9,12.76 13.5,12.36 12,12.36M5.5,13.36C6.9,13.36 8,14.46 8,15.86C8,17.26 6.9,18.36 5.5,18.36C4.1,18.36 3,17.26 3,15.86C3,14.46 4.1,13.36 5.5,13.36M18.5,13.36C19.9,13.36 21,14.46 21,15.86C21,17.26 19.9,18.36 18.5,18.36C17.1,18.36 16,17.26 16,15.86C16,14.46 17.1,13.36 18.5,13.36M12,13.36C13.9,13.36 15.5,14.76 15.5,16.56C15.5,18.36 13.9,19.76 12,19.76C10.1,19.76 8.5,18.36 8.5,16.56C8.5,14.76 10.1,13.36 12,13.36M8,6.36C8.55,6.36 9,5.91 9,5.36V3.36C9,2.81 8.55,2.36 8,2.36C7.45,2.36 7,2.81 7,3.36V5.36C7,5.91 7.45,6.36 8,6.36M16,6.36C16.55,6.36 17,5.91 17,5.36V3.36C17,2.81 16.55,2.36 16,2.36C15.45,2.36 15,2.81 15,3.36V5.36C15,5.91 15.45,6.36 16,6.36Z" />
                    </svg>
                </div>
            </div>
        </form>
        <script>
            // Password toggle functionality
            document.querySelectorAll('.password-toggle').forEach(btn => {
                btn.addEventListener('click', function () {
                    const targetId = this.getAttribute('data-target');
                    const input = document.getElementById(targetId);
                    const eyeIcon = this.querySelector('.icon-eye');
                    const eyeOffIcon = this.querySelector('.icon-eye-off');

                    if (input.type === 'password') {
                        input.type = 'text';
                        eyeIcon.style.display = 'none';
                        eyeOffIcon.style.display = 'block';
                    } else {
                        input.type = 'password';
                        eyeIcon.style.display = 'block';
                        eyeOffIcon.style.display = 'none';
                    }
                });
            });

            // Form validation
            function validarCambioContrasena() {
                var nuevaContrasena = document.getElementById('txtNuevaContrasena').value;
                var confirmarContrasena = document.getElementById('txtConfirmarContrasena').value;
                var errores = [];

                if (nuevaContrasena === '') {
                    errores.push('Ingresa tu nueva contraseña');
                } else if (nuevaContrasena.length < 8) {
                    errores.push('La contraseña debe tener al menos 8 caracteres');
                }

                if (confirmarContrasena === '') {
                    errores.push('Confirma tu contraseña');
                } else if (nuevaContrasena !== confirmarContrasena) {
                    errores.push('Las contraseñas no coinciden');
                }

                if (errores.length > 0) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Campos incompletos',
                        html: errores.map(e => '• ' + e).join('<br>'),
                        confirmButtonColor: '#FF8C42'
                    });
                    return false;
                }

                return true;
            }

            // Attach validation to button
            document.addEventListener('DOMContentLoaded', function () {
                var btnCambiar = document.getElementById('<%= btnCambiar.ClientID %>');
                if (btnCambiar) {
                    btnCambiar.addEventListener('click', function (e) {
                        if (!validarCambioContrasena()) {
                            e.preventDefault();
                            return false;
                        }
                    });
                }
            });
        </script>
    </body>

    </html>