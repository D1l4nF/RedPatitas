<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Registro.aspx.cs" Inherits="RedPatitas.Login.Registro" %>

    <!DOCTYPE html>

    <html lang="es">

    <head runat="server">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Registro en el Sistema de Adopción de Mascotas">
        <title>Registrarse - RedPatitas</title>
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
                <div class="login-card" style="max-width: 600px;">
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
                        <h1>Crear Cuenta</h1>
                        <p class="subtitle">Únete a nuestra comunidad de amantes de las mascotas</p>
                    </div>


                    <!-- Selector de Tipo de Cuenta -->
                    <div class="form-group">
                        <label>Tipo de Cuenta</label>
                        <div class="role-selector">
                            <div class="role-option" id="optUsuario" onclick="selectRole('Usuario')">
                                <asp:RadioButton ID="rbUsuario" runat="server" GroupName="TipoCuenta" Checked="true" />
                                <div class="role-card">
                                    <svg viewBox="0 0 24 24" fill="none" width="32" height="32">
                                        <circle cx="12" cy="8" r="4" stroke="currentColor" stroke-width="2" />
                                        <path d="M4 20C4 17 8 15 12 15C16 15 20 17 20 20" stroke="currentColor"
                                            stroke-width="2" stroke-linecap="round" />
                                    </svg>
                                    <span class="role-title">Usuario Normal</span>
                                    <span class="role-desc">Adopta, publica y reporta mascotas</span>
                                </div>
                            </div>
                            <div class="role-option" id="optRefugio" onclick="selectRole('Refugio')">
                                <asp:RadioButton ID="rbRefugio" runat="server" GroupName="TipoCuenta" />
                                <div class="role-card">
                                    <svg viewBox="0 0 24 24" fill="none" width="32" height="32">
                                        <path d="M3 9L12 2L21 9V20C21 21 20 22 19 22H5C4 22 3 21 3 20V9Z"
                                            stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                        <path d="M9 22V12H15V22" stroke="currentColor" stroke-width="2"
                                            stroke-linecap="round" stroke-linejoin="round" />
                                    </svg>
                                    <span class="role-title">Fundación / Refugio</span>
                                    <span class="role-desc">Gestiona múltiples mascotas (requiere verificación)</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Campos personales - Solo para Adoptante -->
                    <div id="camposPersonales">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                            <div class="form-group">
                                <label for="txtNombres">Nombres</label>
                                <div class="input-wrapper">
                                    <asp:TextBox ID="txtNombres" runat="server" CssClass="form-control"
                                        placeholder="Ej. Juan" />
                                </div>
                                <asp:RequiredFieldValidator ID="rfvNombres" runat="server"
                                    ControlToValidate="txtNombres" ErrorMessage="Ingresa tu nombre"
                                    CssClass="error-message" Display="Dynamic" Enabled="false" />
                            </div>
                            <div class="form-group">
                                <label for="txtApellidos">Apellidos</label>
                                <div class="input-wrapper">
                                    <asp:TextBox ID="txtApellidos" runat="server" CssClass="form-control"
                                        placeholder="Ej. Pérez" />
                                </div>
                                <asp:RequiredFieldValidator ID="rfvApellidos" runat="server"
                                    ControlToValidate="txtApellidos" ErrorMessage="Ingresa tu apellido"
                                    CssClass="error-message" Display="Dynamic" Enabled="false" />
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="txtEmail">Correo Electrónico</label>
                        <div class="input-wrapper">
                            <svg class="input-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path
                                    d="M4 4H20C21.1 4 22 4.9 22 6V18C22 19.1 21.1 20 20 20H4C2.9 20 2 19.1 2 18V6C2 4.9 2.9 4 4 4Z"
                                    stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                    stroke-linejoin="round" />
                                <path d="M22 6L12 13L2 6" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                    stroke-linejoin="round" />
                            </svg>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"
                                placeholder="tu@email.com" />
                        </div>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="Ingresa tu correo" CssClass="error-message" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                            ErrorMessage="Ingresa un correo válido" CssClass="error-message" Display="Dynamic" />
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                        <div class="form-group">
                            <label for="txtPassword">Contraseña</label>
                            <div class="input-wrapper has-toggle">
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"
                                    placeholder="••••••••" />
                                <button type="button" class="password-toggle" onclick="togglePassword('txtPassword')"
                                    aria-label="Mostrar contraseña">
                                    <svg class="icon-eye" id="eye-txtPassword" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor" stroke-width="2">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                        <circle cx="12" cy="12" r="3"></circle>
                                    </svg>
                                    <svg class="icon-eye-off" id="eyeoff-txtPassword" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor" stroke-width="2" style="display: none;">
                                        <path
                                            d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24">
                                        </path>
                                        <line x1="1" y1="1" x2="23" y2="23"></line>
                                    </svg>
                                </button>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                                ErrorMessage="Ingresa una contraseña" CssClass="error-message" Display="Dynamic" />
                            <div class="password-strength" id="passwordStrength">
                                <div class="strength-bar"></div>
                                <div class="strength-bar"></div>
                                <div class="strength-bar"></div>
                                <div class="strength-bar"></div>
                            </div>
                            <div class="strength-text" id="strengthText"></div>
                        </div>
                        <div class="form-group">
                            <label for="txtConfirmPassword">Confirmar Contraseña</label>
                            <div class="input-wrapper has-toggle">
                                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control"
                                    TextMode="Password" placeholder="••••••••" />
                                <button type="button" class="password-toggle"
                                    onclick="togglePassword('txtConfirmPassword')" aria-label="Mostrar contraseña">
                                    <svg class="icon-eye" id="eye-txtConfirmPassword" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor" stroke-width="2">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                        <circle cx="12" cy="12" r="3"></circle>
                                    </svg>
                                    <svg class="icon-eye-off" id="eyeoff-txtConfirmPassword" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="2" style="display: none;">
                                        <path
                                            d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24">
                                        </path>
                                        <line x1="1" y1="1" x2="23" y2="23"></line>
                                    </svg>
                                </button>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server"
                                ControlToValidate="txtConfirmPassword" ErrorMessage="Confirma tu contraseña"
                                CssClass="error-message" Display="Dynamic" />
                            <asp:CompareValidator ID="cvPassword" runat="server" ControlToValidate="txtConfirmPassword"
                                ControlToCompare="txtPassword" ErrorMessage="Las contraseñas no coinciden"
                                CssClass="error-message" Display="Dynamic" />
                        </div>
                    </div>

                    <!-- Nota informativa sobre verificación (solo para Adoptante) -->
                    <div class="info-banner" id="bannerAdoptante">
                        <svg viewBox="0 0 24 24" fill="none" width="20" height="20">
                            <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2" />
                            <path d="M12 8V12M12 16H12.01" stroke="currentColor" stroke-width="2"
                                stroke-linecap="round" />
                        </svg>
                        <span>La verificación de identidad se realizará cuando desees publicar o adoptar una
                            mascota.</span>
                    </div>

                    <!-- Campos adicionales para Refugio (ocultos por defecto) -->
                    <div id="camposRefugio" style="display: none;">
                        <div class="form-group">
                            <label for="txtNombreRefugio">Nombre del Refugio *</label>
                            <div class="input-wrapper">
                                <asp:TextBox ID="txtNombreRefugio" runat="server" CssClass="form-control"
                                    placeholder="Ej. Refugio Patitas Felices" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="txtDescripcionRefugio">Descripción del Refugio</label>
                            <div class="input-wrapper">
                                <asp:TextBox ID="txtDescripcionRefugio" runat="server" CssClass="form-control"
                                    TextMode="MultiLine" Rows="3"
                                    placeholder="Cuéntanos sobre tu refugio, su misión y trabajo..." />
                            </div>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                            <div class="form-group">
                                <label for="txtTelefonoRefugio">Teléfono del Refugio *</label>
                                <div class="input-wrapper">
                                    <asp:TextBox ID="txtTelefonoRefugio" runat="server" CssClass="form-control"
                                        placeholder="Ej. 0999999999" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="txtCiudadRefugio">Ciudad *</label>
                                <div class="input-wrapper">
                                    <asp:TextBox ID="txtCiudadRefugio" runat="server" CssClass="form-control"
                                        placeholder="Ej. Quito" />
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="txtDireccionRefugio">Dirección del Refugio *</label>
                            <div class="input-wrapper">
                                <asp:TextBox ID="txtDireccionRefugio" runat="server" CssClass="form-control"
                                    placeholder="Ej. Av. Principal N12-34 y Calle Secundaria" />
                            </div>
                        </div>

                        <!-- Banner informativo al final -->
                        <div class="info-banner"
                            style="background: linear-gradient(135deg, rgba(139, 69, 19, 0.1), rgba(210, 105, 30, 0.15)); border-color: rgba(139, 69, 19, 0.2);">
                            <svg viewBox="0 0 24 24" fill="none" width="20" height="20">
                                <path d="M3 9L12 2L21 9V20C21 21 20 22 19 22H5C4 22 3 21 3 20V9Z" stroke="currentColor"
                                    stroke-width="2" />
                                <path d="M9 22V12H15V22" stroke="currentColor" stroke-width="2" />
                            </svg>
                            <span>Los refugios requieren verificación por parte del administrador antes de poder
                                publicar mascotas.</span>
                        </div>
                    </div>

                    <div class="form-options">
                        <label class="checkbox-container">
                            <asp:CheckBox ID="chkTerminos" runat="server" />
                            <span class="checkmark"></span>
                            <span class="checkbox-label" style="font-size: 0.85rem;">Acepto los <a href="#"
                                    style="color: var(--primary-color);">Términos y Condiciones</a></span>
                        </label>
                    </div>

                    <asp:Label ID="lblMensaje" runat="server" CssClass="message" Visible="false" />

                    <asp:Button ID="btnRegistrar" runat="server" Text="Crear Cuenta" CssClass="btn-primary"
                        OnClick="btnRegistrar_Click" />

                    <p class="signup-link">
                        ¿Ya tienes una cuenta? <a href="~/Login/Login.aspx" runat="server">Inicia Sesión</a>
                    </p>

                </div>

                <div class="background-decoration">
                    <svg class="paw-print" style="left: 5%; bottom: 10%; width: 70px;" viewBox="0 0 24 24"
                        fill="currentColor">
                        <path
                            d="M12,11.36C12.55,11.36 13,10.91 13,10.36V8.36C13,7.81 12.55,7.36 12,7.36C11.45,7.36 11,7.81 11,8.36V10.36C11,10.91 11.45,11.36 12,11.36M12,12.36C10.5,12.36 9.1,12.76 7.9,13.46C7.3,12.86 6.4,12.36 5.5,12.36C3.5,12.36 2,13.86 2,15.86C2,17.86 3.5,19.36 5.5,19.36C6.5,19.36 7.4,18.96 8.1,18.26C9,19.56 10.4,20.36 12,20.36C13.6,20.36 15,19.56 15.9,18.26C16.6,18.96 17.5,19.36 18.5,19.36C20.5,19.36 22,17.86 22,15.86C22,13.86 20.5,12.36 18.5,12.36C17.6,12.36 16.7,12.86 16.1,13.46C14.9,12.76 13.5,12.36 12,12.36M5.5,13.36C6.9,13.36 8,14.46 8,15.86C8,17.26 6.9,18.36 5.5,18.36C4.1,18.36 3,17.26 3,15.86C3,14.46 4.1,13.36 5.5,13.36M18.5,13.36C19.9,13.36 21,14.46 21,15.86C21,17.26 19.9,18.36 18.5,18.36C17.1,18.36 16,17.26 16,15.86C16,14.46 17.1,13.36 18.5,13.36M12,13.36C13.9,13.36 15.5,14.76 15.5,16.56C15.5,18.36 13.9,19.76 12,19.76C10.1,19.76 8.5,18.36 8.5,16.56C8.5,14.76 10.1,13.36 12,13.36M8,6.36C8.55,6.36 9,5.91 9,5.36V3.36C9,2.81 8.55,2.36 8,2.36C7.45,2.36 7,2.81 7,3.36V5.36C7,5.91 7.45,6.36 8,6.36M16,6.36C16.55,6.36 17,5.91 17,5.36V3.36C17,2.81 16.55,2.36 16,2.36C15.45,2.36 15,2.81 15,3.36V5.36C15,5.91 15.45,6.36 16,6.36Z" />
                    </svg>
                    <svg class="paw-print" style="right: 10%; top: 20%; width: 50px; animation-delay: 2s;"
                        viewBox="0 0 24 24" fill="currentColor">
                        <path
                            d="M12,11.36C12.55,11.36 13,10.91 13,10.36V8.36C13,7.81 12.55,7.36 12,7.36C11.45,7.36 11,7.81 11,8.36V10.36C11,10.91 11.45,11.36 12,11.36M12,12.36C10.5,12.36 9.1,12.76 7.9,13.46C7.3,12.86 6.4,12.36 5.5,12.36C3.5,12.36 2,13.86 2,15.86C2,17.86 3.5,19.36 5.5,19.36C6.5,19.36 7.4,18.96 8.1,18.26C9,19.56 10.4,20.36 12,20.36C13.6,20.36 15,19.56 15.9,18.26C16.6,18.96 17.5,19.36 18.5,19.36C20.5,19.36 22,17.86 22,15.86C22,13.86 20.5,12.36 18.5,12.36C17.6,12.36 16.7,12.86 16.1,13.46C14.9,12.76 13.5,12.36 12,12.36M5.5,13.36C6.9,13.36 8,14.46 8,15.86C8,17.26 6.9,18.36 5.5,18.36C4.1,18.36 3,17.26 3,15.86C3,14.46 4.1,13.36 5.5,13.36M18.5,13.36C19.9,13.36 21,14.46 21,15.86C21,17.26 19.9,18.36 18.5,18.36C17.1,18.36 16,17.26 16,15.86C16,14.46 17.1,13.36 18.5,13.36M12,13.36C13.9,13.36 15.5,14.76 15.5,16.56C15.5,18.36 13.9,19.76 12,19.76C10.1,19.76 8.5,18.36 8.5,16.56C8.5,14.76 10.1,13.36 12,13.36M8,6.36C8.55,6.36 9,5.91 9,5.36V3.36C9,2.81 8.55,2.36 8,2.36C7.45,2.36 7,2.81 7,3.36V5.36C7,5.91 7.45,6.36 8,6.36M16,6.36C16.55,6.36 17,5.91 17,5.36V3.36C17,2.81 16.55,2.36 16,2.36C15.45,2.36 15,2.81 15,3.36V5.36C15,5.91 15.45,6.36 16,6.36Z" />
                    </svg>
                </div>
            </div>
            <script>

                // Password strength indicator
                document.addEventListener('DOMContentLoaded', function () {
                    var passwordInput = document.getElementById('<%= txtPassword.ClientID %>');
                    var strengthBars = document.querySelectorAll('.strength-bar');
                    var strengthText = document.getElementById('strengthText');

                    if (passwordInput) {
                        passwordInput.addEventListener('input', function () {
                            var value = this.value;
                            var strength = 0;

                            if (value.length >= 8) strength++;
                            if (/[a-z]/.test(value) && /[A-Z]/.test(value)) strength++;
                            if (/\d/.test(value)) strength++;
                            if (/[^a-zA-Z0-9]/.test(value)) strength++;

                            strengthBars.forEach(function (bar, i) {
                                bar.className = 'strength-bar';
                                if (i < strength) {
                                    if (strength <= 1) bar.classList.add('weak');
                                    else if (strength <= 2) bar.classList.add('medium');
                                    else bar.classList.add('strong');
                                }
                            });

                            var texts = ['', 'Débil', 'Regular', 'Buena', 'Excelente'];
                            strengthText.textContent = value ? texts[strength] : '';
                        });
                    }
                });

                // Password visibility toggle
                function togglePassword(fieldId) {
                    var input = document.getElementById(fieldId.indexOf('txt') === 0
                        ? document.getElementById('<%= txtPassword.ClientID %>').id
                        : fieldId);

                    // Get the actual input element using ASP.NET ClientID
                    if (fieldId === 'txtPassword') {
                        input = document.getElementById('<%= txtPassword.ClientID %>');
                    } else if (fieldId === 'txtConfirmPassword') {
                        input = document.getElementById('<%= txtConfirmPassword.ClientID %>');
                    }

                    var eyeIcon = document.getElementById('eye-' + fieldId);
                    var eyeOffIcon = document.getElementById('eyeoff-' + fieldId);

                    if (input.type === 'password') {
                        input.type = 'text';
                        eyeIcon.style.display = 'none';
                        eyeOffIcon.style.display = 'block';
                    } else {
                        input.type = 'password';
                        eyeIcon.style.display = 'block';
                        eyeOffIcon.style.display = 'none';
                    }
                }

                // Role selector functionality
                function selectRole(role) {
                    var rbUsuario = document.getElementById('<%= rbUsuario.ClientID %>');
                    var rbRefugio = document.getElementById('<%= rbRefugio.ClientID %>');
                    var camposRefugio = document.getElementById('camposRefugio');
                    var camposPersonales = document.getElementById('camposPersonales');
                    var bannerAdoptante = document.getElementById('bannerAdoptante');

                    if (role === 'Usuario') {
                        rbUsuario.checked = true;
                        document.getElementById('optUsuario').classList.add('selected');
                        document.getElementById('optRefugio').classList.remove('selected');
                        // Mostrar campos personales, ocultar campos de refugio
                        camposPersonales.style.display = 'block';
                        camposRefugio.style.display = 'none';
                        bannerAdoptante.style.display = 'flex';
                    } else {
                        rbRefugio.checked = true;
                        document.getElementById('optRefugio').classList.add('selected');
                        document.getElementById('optUsuario').classList.remove('selected');
                        // Ocultar campos personales, mostrar campos de refugio
                        camposPersonales.style.display = 'none';
                        camposRefugio.style.display = 'block';
                        bannerAdoptante.style.display = 'none';
                    }
                }

                // Initialize role selection on page load
                document.addEventListener('DOMContentLoaded', function () {
                    var rbUsuario = document.getElementById('<%= rbUsuario.ClientID %>');
                    var camposRefugio = document.getElementById('camposRefugio');
                    var camposPersonales = document.getElementById('camposPersonales');
                    var bannerAdoptante = document.getElementById('bannerAdoptante');

                    if (rbUsuario && rbUsuario.checked) {
                        document.getElementById('optUsuario').classList.add('selected');
                        camposPersonales.style.display = 'block';
                        camposRefugio.style.display = 'none';
                        bannerAdoptante.style.display = 'flex';
                    } else {
                        document.getElementById('optRefugio').classList.add('selected');
                        camposPersonales.style.display = 'none';
                        camposRefugio.style.display = 'block';
                        bannerAdoptante.style.display = 'none';
                    }

                    // Attach validation to register button
                    var btnRegistrar = document.getElementById('<%= btnRegistrar.ClientID %>');
                    if (btnRegistrar) {
                        btnRegistrar.addEventListener('click', function (e) {
                            if (!validarRegistro()) {
                                e.preventDefault();
                                return false;
                            }
                        });
                    }
                });

                // Form validation with SweetAlert2
                function validarRegistro() {
                    var email = document.getElementById('<%= txtEmail.ClientID %>').value.trim();
                    var password = document.getElementById('<%= txtPassword.ClientID %>').value;
                    var confirmPassword = document.getElementById('<%= txtConfirmPassword.ClientID %>').value;
                    var chkTerminos = document.getElementById('<%= chkTerminos.ClientID %>');
                    var rbRefugio = document.getElementById('<%= rbRefugio.ClientID %>');
                    var esRefugio = rbRefugio && rbRefugio.checked;
                    var errores = [];

                    // Validar campos personales solo si es Adoptante
                    if (!esRefugio) {
                        var nombres = document.getElementById('<%= txtNombres.ClientID %>').value.trim();
                        var apellidos = document.getElementById('<%= txtApellidos.ClientID %>').value.trim();

                        if (nombres === '') {
                            errores.push('Ingresa tu nombre');
                        }
                        if (apellidos === '') {
                            errores.push('Ingresa tu apellido');
                        }
                    }

                    if (email === '') {
                        errores.push('Ingresa el correo electrónico');
                    } else if (!isValidEmail(email)) {
                        errores.push('Ingresa un correo electrónico válido');
                    }

                    if (password === '') {
                        errores.push('Ingresa una contraseña');
                    } else if (password.length < 8) {
                        errores.push('La contraseña debe tener al menos 8 caracteres');
                    }

                    if (confirmPassword === '') {
                        errores.push('Confirma tu contraseña');
                    } else if (password !== confirmPassword) {
                        errores.push('Las contraseñas no coinciden');
                    }

                    // Validar campos de Refugio si está seleccionado
                    if (esRefugio) {
                        var nombreRefugio = document.getElementById('<%= txtNombreRefugio.ClientID %>').value.trim();
                        var telefonoRefugio = document.getElementById('<%= txtTelefonoRefugio.ClientID %>').value.trim();
                        var ciudadRefugio = document.getElementById('<%= txtCiudadRefugio.ClientID %>').value.trim();
                        var direccionRefugio = document.getElementById('<%= txtDireccionRefugio.ClientID %>').value.trim();
                        if (nombreRefugio === '') {
                            errores.push('Ingresa el nombre del refugio');
                        }
                        if (telefonoRefugio === '') {
                            errores.push('Ingresa el teléfono del refugio');
                        }
                        if (ciudadRefugio === '') {
                            errores.push('Ingresa la ciudad del refugio');
                        }
                        if (direccionRefugio === '') {
                            errores.push('Ingresa la dirección del refugio');
                        }
                    }

                    if (!chkTerminos.checked) {
                        errores.push('Debes aceptar los términos y condiciones');
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
            </script>
        </form>
    </body>

    </html>