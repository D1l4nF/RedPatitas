<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RecuperarContrasena.aspx.cs"
    Inherits="RedPatitas.Login.RecuperarContrasena" %>

    <!DOCTYPE html>

    <html lang="es">

    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Recuperar contraseña del Sistema de Adopción de Mascotas">
        <title>Recuperar Contraseña - RedPatitas</title>
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
                        <h1>Recuperar Contraseña</h1>
                        <p class="subtitle">Ingresa tu correo electrónico para restablecer tu contraseña</p>
                    </div>

                    <asp:Panel ID="pnlRecuperar" runat="server" DefaultButton="btnEnviar">
                        <div class="form-group">
                            <label for="txtEmail">Correo Electrónico</label>
                            <div class="input-wrapper">
                                <!-- Email Icon -->
                                <svg class="input-icon" viewBox="0 0 24 24" fill="none"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <path
                                        d="M4 4H20C21.1 4 22 4.9 22 6V18C22 19.1 21.1 20 20 20H4C2.9 20 2 19.1 2 18V6C2 4.9 2.9 4 4 4Z"
                                        stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                        stroke-linejoin="round" />
                                    <path d="M22 6L12 13L2 6" stroke="currentColor" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round" />
                                </svg>
                                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="tu@email.com"
                                    CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                            </div>
                        </div>

                        <asp:LinkButton ID="btnEnviar" runat="server" CssClass="btn-primary" OnClick="btnEnviar_Click">
                            <span class="btn-text">Enviar Instrucciones</span>
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
            // Form validation with SweetAlert2
            function validarRecuperacion() {
                var email = document.getElementById('txtEmail').value.trim();

                if (email === '') {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Campo requerido',
                        text: 'Ingresa tu correo electrónico',
                        confirmButtonColor: '#FF8C42'
                    });
                    return false;
                }

                if (!isValidEmail(email)) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Correo inválido',
                        text: 'Ingresa un correo electrónico válido',
                        confirmButtonColor: '#FF8C42'
                    });
                    return false;
                }

                return true;
            }

            function isValidEmail(email) {
                var regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                return regex.test(email);
            }

            // Attach validation to submit button
            document.addEventListener('DOMContentLoaded', function () {
                var btnEnviar = document.getElementById('<%= btnEnviar.ClientID %>');
                if (btnEnviar) {
                    btnEnviar.addEventListener('click', function (e) {
                        if (!validarRecuperacion()) {
                            e.preventDefault();
                            return false;
                        }
                    });
                }
            });
        </script>
    </body>

    </html>