<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="RedPatitas.Login.Login" %>

    <!DOCTYPE html>

    <html lang="es">

    <head runat="server">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Ingreso al Sistema de Adopción de Mascotas">
        <title>Iniciar Sesión - RedPatitas</title>
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
                <a href="../Public/Home.aspx" class="back-to-home">← Volver al inicio</a>
                <div class="login-card">
                    <div class="login-header">
                        <a href="../Public/Home.aspx" class="logo-container" title="Ir al inicio">
                            <div class="logo-icon">
                                <!-- Paw Icon -->
                                <svg viewBox="0 0 24 24" fill="currentColor" width="32" height="32">
                                    <path
                                        d="M12,11.36C12.55,11.36 13,10.91 13,10.36V8.36C13,7.81 12.55,7.36 12,7.36C11.45,7.36 11,7.81 11,8.36V10.36C11,10.91 11.45,11.36 12,11.36M12,12.36C10.5,12.36 9.1,12.76 7.9,13.46C7.3,12.86 6.4,12.36 5.5,12.36C3.5,12.36 2,13.86 2,15.86C2,17.86 3.5,19.36 5.5,19.36C6.5,19.36 7.4,18.96 8.1,18.26C9,19.56 10.4,20.36 12,20.36C13.6,20.36 15,19.56 15.9,18.26C16.6,18.96 17.5,19.36 18.5,19.36C20.5,19.36 22,17.86 22,15.86C22,13.86 20.5,12.36 18.5,12.36C17.6,12.36 16.7,12.86 16.1,13.46C14.9,12.76 13.5,12.36 12,12.36M5.5,13.36C6.9,13.36 8,14.46 8,15.86C8,17.26 6.9,18.36 5.5,18.36C4.1,18.36 3,17.26 3,15.86C3,14.46 4.1,13.36 5.5,13.36M18.5,13.36C19.9,13.36 21,14.46 21,15.86C21,17.26 19.9,18.36 18.5,18.36C17.1,18.36 16,17.26 16,15.86C16,14.46 17.1,13.36 18.5,13.36M12,13.36C13.9,13.36 15.5,14.76 15.5,16.56C15.5,18.36 13.9,19.76 12,19.76C10.1,19.76 8.5,18.36 8.5,16.56C8.5,14.76 10.1,13.36 12,13.36M8,6.36C8.55,6.36 9,5.91 9,5.36V3.36C9,2.81 8.55,2.36 8,2.36C7.45,2.36 7,2.81 7,3.36V5.36C7,5.91 7.45,6.36 8,6.36M16,6.36C16.55,6.36 17,5.91 17,5.36V3.36C17,2.81 16.55,2.36 16,2.36C15.45,2.36 15,2.81 15,3.36V5.36C15,5.91 15.45,6.36 16,6.36Z" />
                                </svg>
                            </div>
                        </a>
                        <h1>Bienvenido de nuevo</h1>
                        <p class="subtitle">Ingresa tus datos para acceder al sistema</p>
                    </div>

                    <asp:Panel ID="pnlLogin" runat="server" DefaultButton="btnLogin">
                        <div class="form-group">
                            <label for="txtEmail">Correo Electrónico</label>
                            <div class="input-wrapper">
                                <!-- Email Icon -->
                                <svg class="input-icon" viewBox="0 0 24 24" fill="none"
                                    xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                    <path
                                        d="M4 4H20C21.1 4 22 4.9 22 6V18C22 19.1 21.1 20 20 20H4C2.9 20 2 19.1 2 18V6C2 4.9 2.9 4 4 4Z"
                                        stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                        stroke-linejoin="round" />
                                    <path d="M22 6L12 13L2 6" stroke="currentColor" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round" />
                                </svg>
                                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="tu@email.com"
                                    CssClass="form-control" ClientIDMode="Static" required aria-required="true">
                                </asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="txtPassword">Contraseña</label>
                            <div class="input-wrapper has-toggle">
                                <!-- Lock Icon -->
                                <svg class="input-icon" viewBox="0 0 24 24" fill="none"
                                    xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2" stroke="currentColor"
                                        stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                                    <path
                                        d="M7 11V7C7 5.67392 7.52678 4.40215 8.46447 3.46447C9.40215 2.52678 10.6739 2 12 2C13.3261 2 14.5979 2.52678 15.5355 3.46447C16.4732 4.40215 17 5.67392 17 7V11"
                                        stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                        stroke-linejoin="round" />
                                </svg>
                                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="••••••••"
                                    CssClass="form-control" ClientIDMode="Static" required aria-required="true">
                                </asp:TextBox>
                                <button type="button" class="password-toggle" data-target="txtPassword"
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

                        <div class="form-options">
                            <label class="checkbox-container">
                                <input type="checkbox" id="remember" name="remember">
                                <span class="checkmark"></span>
                                <span class="checkbox-label">Recordarme</span>
                            </label>
                            <a href="~/Login/RecuperarContrasena.aspx" runat="server" class="forgot-password">¿Olvidaste
                                tu contraseña?</a>
                        </div>

                        <asp:LinkButton ID="btnLogin" runat="server" CssClass="btn-primary" OnClick="btnLogin_Click">
                            <span class="btn-text">Ingresar</span>
                        </asp:LinkButton>
                    </asp:Panel>
                    <p class="signup-link">
                        ¿Aún no tienes cuenta? <a href="~/Login/Registro.aspx" runat="server">Regístrate aquí</a>
                    </p>
                </div>

                <div class="background-decoration">
                    <!-- Decorative Paw Prints -->
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

            // Form validation with SweetAlert2
            function validarLogin() {
                var email = document.getElementById('txtEmail').value.trim();
                var password = document.getElementById('txtPassword').value.trim();
                var errores = [];

                if (email === '') {
                    errores.push('Ingresa tu correo electrónico');
                } else if (!isValidEmail(email)) {
                    errores.push('Ingresa un correo electrónico válido');
                }

                if (password === '') {
                    errores.push('Ingresa tu contraseña');
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

            function isValidEmail(email) {
                var regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                return regex.test(email);
            }

            // Attach validation to login button
            document.addEventListener('DOMContentLoaded', function () {
                var btnLogin = document.getElementById('<%= btnLogin.ClientID %>');
                if (btnLogin) {
                    btnLogin.addEventListener('click', function (e) {
                        if (!validarLogin()) {
                            e.preventDefault();
                            return false;
                        }
                    });
                }
            });
        </script>
    </body>

    </html>