<%@ Page Title="" Language="C#" MasterPageFile="~/AdminRefugio/AdminRefugio.Master" AutoEventWireup="true"
    CodeBehind="Perfil.aspx.cs" Inherits="RedPatitas.AdminRefugio.Perfil" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Perfil Refugio | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link rel="stylesheet" href="~/Style/forms.css" />
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
        <style>
            .avatar-img {
                width: 100px;
                height: 100px;
                border-radius: 50%;
                object-fit: cover;
                background-color: var(--accent-color, #ddd);
                border: 4px solid white;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
        </style>
        <script type="text/javascript">
            function previewImage(input) {
                var imgPreview = document.getElementById('<%= imgFotoActual.ClientID %>');
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        imgPreview.src = e.target.result;
                    };
                    reader.readAsDataURL(input.files[0]);
                }
            }
        </script>
    </asp:Content>

    <asp:Content ID="Content4" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">Mi Perfil</h1>
            <div class="breadcrumb">Cuenta / Mi Perfil</div>
        </div>
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
        <div class="form-container">
            <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="form-group">
                <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>
            </asp:Panel>

            <!-- Sección de Logo del Refugio -->
            <div class="avatar-section">
                <asp:Image ID="imgFotoActual" runat="server" CssClass="avatar-img"
                    ImageUrl="~/Images/default-refugio.png" />
                <div class="avatar-actions">
                    <asp:FileUpload ID="fuFotoPerfil" runat="server" CssClass="btn-secondary" accept=".jpg,.png,.jpeg"
                        onchange="previewImage(this)" />
                    <span class="avatar-hint">Logo del refugio. JPG, PNG. Máximo 2MB</span>
                </div>
            </div>

            <!-- Datos del Refugio -->
            <h3 class="form-section-title">Datos del Refugio</h3>

            <div class="form-group">
                <label for="txtNombreRefugio">Nombre del Refugio</label>
                <asp:TextBox ID="txtNombreRefugio" runat="server" CssClass="form-control"
                    placeholder="Ej: Refugio Esperanza"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvNombreRefugio" runat="server" ControlToValidate="txtNombreRefugio"
                    ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label for="txtDescripcion">Descripción</label>
                <asp:TextBox ID="txtDescripcion" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control"
                    placeholder="Describe brevemente tu refugio..."></asp:TextBox>
            </div>

            <div class="form-grid">
                <div class="form-group">
                    <label for="txtTelefono">Teléfono</label>
                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" TextMode="Phone"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label for="txtCiudad">Ciudad</label>
                    <asp:TextBox ID="txtCiudad" runat="server" CssClass="form-control" placeholder="Ej: Quito">
                    </asp:TextBox>
                </div>
            </div>

            <div class="form-group">
                <label for="txtDireccion">Dirección</label>
                <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control"
                    placeholder="Ej: Av. Principal 123"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Ubicación en el Mapa</label>
                <div id="mapPerfil"
                    style="height: 250px; border-radius: 8px; margin-bottom: 10px; border: 1px solid #ddd;"></div>
                <asp:HiddenField ID="hfLatitud" runat="server" />
                <asp:HiddenField ID="hfLongitud" runat="server" />
                <p style="font-size: 0.85rem; color: #666; margin-bottom: 10px;">📍 Haz clic en el mapa para marcar la
                    ubicación del refugio</p>
            </div>

            <div class="form-group">
                <label for="txtEmail">Correo Electrónico</label>
                <asp:TextBox ID="txtEmail" runat="server" Enabled="false" CssClass="form-control"></asp:TextBox>
                <small class="input-hint">El correo electrónico no puede ser modificado</small>
            </div>

            <div class="form-divider"></div>

            <h3 class="form-section-title">Cambiar Contraseña</h3>
            <small class="input-hint" style="display: block; margin-bottom: 15px;">Deja estos campos vacíos si no deseas
                cambiar tu contraseña</small>

            <div class="form-group">
                <label>Contraseña Actual</label>
                <div class="password-wrapper">
                    <asp:TextBox ID="txtClaveActual" runat="server" CssClass="form-control password-input"
                        TextMode="Password" placeholder="••••••••"></asp:TextBox>
                    <button type="button" class="toggle-password" onclick="togglePassword(this)">
                        <svg class="eye-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                            width="20" height="20">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                            <circle cx="12" cy="12" r="3"></circle>
                        </svg>
                    </button>
                </div>
            </div>

            <div class="form-grid">
                <div class="form-group">
                    <label>Nueva Contraseña</label>
                    <div class="password-wrapper">
                        <asp:TextBox ID="txtNuevaClave" runat="server" CssClass="form-control password-input"
                            TextMode="Password" placeholder="••••••••" onkeyup="validarContrasenasCoinciden()">
                        </asp:TextBox>
                        <button type="button" class="toggle-password" onclick="togglePassword(this)">
                            <svg class="eye-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                width="20" height="20">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                <circle cx="12" cy="12" r="3"></circle>
                            </svg>
                        </button>
                    </div>
                </div>
                <div class="form-group">
                    <label>Confirmar Nueva Contraseña</label>
                    <div class="password-wrapper">
                        <asp:TextBox ID="txtConfirmarClave" runat="server" CssClass="form-control password-input"
                            TextMode="Password" placeholder="••••••••" onkeyup="validarContrasenasCoinciden()">
                        </asp:TextBox>
                        <button type="button" class="toggle-password" onclick="togglePassword(this)">
                            <svg class="eye-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                width="20" height="20">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                <circle cx="12" cy="12" r="3"></circle>
                            </svg>
                        </button>
                    </div>
                </div>
            </div>
            <span id="lblPasswordMatch" style="color: red; font-size: 0.85rem; display: none;">❌ Las contraseñas no
                coinciden</span>
            <span id="lblPasswordOk" style="color: green; font-size: 0.85rem; display: none;">✓ Las contraseñas
                coinciden</span>
            <asp:Label ID="lblErrorClave" runat="server" ForeColor="Red" Visible="false"></asp:Label>

            <div class="form-actions">
                <asp:Button ID="btnGuardar" runat="server" CssClass="btn-primary" Text="Guardar Cambios"
                    OnClick="btnGuardar_Click" CausesValidation="false" />
            </div>
        </div>

        <style>
            .password-wrapper {
                position: relative;
                display: flex;
                align-items: center;
            }

            .password-wrapper .password-input {
                flex: 1;
                padding-right: 45px;
            }

            .toggle-password {
                position: absolute;
                right: 10px;
                background: none;
                border: none;
                cursor: pointer;
                padding: 5px;
                color: #666;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .toggle-password:hover {
                color: #333;
            }

            .btn-primary:disabled {
                background: #ccc;
                cursor: not-allowed;
                opacity: 0.6;
            }
        </style>

        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        <script type="text/javascript">
            function togglePassword(btn) {
                var input = btn.parentElement.querySelector('.password-input');
                if (input.type === 'password') {
                    input.type = 'text';
                    btn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20" height="20"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>';
                } else {
                    input.type = 'password';
                    btn.innerHTML = '<svg class="eye-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20" height="20"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>';
                }
            }

            function validarContrasenasCoinciden() {
                var nueva = document.getElementById('<%= txtNuevaClave.ClientID %>').value;
                var confirmar = document.getElementById('<%= txtConfirmarClave.ClientID %>').value;
                var lblMatch = document.getElementById('lblPasswordMatch');
                var lblOk = document.getElementById('lblPasswordOk');

                if (nueva === '' && confirmar === '') {
                    lblMatch.style.display = 'none';
                    lblOk.style.display = 'none';
                    verificarCambios();
                    return;
                }

                if (nueva !== '' && confirmar === '') {
                    lblMatch.style.display = 'none';
                    lblOk.style.display = 'none';
                    document.getElementById('<%= btnGuardar.ClientID %>').disabled = true;
                    return;
                }

                if (nueva !== confirmar) {
                    lblMatch.style.display = 'inline';
                    lblOk.style.display = 'none';
                    document.getElementById('<%= btnGuardar.ClientID %>').disabled = true;
                } else {
                    lblMatch.style.display = 'none';
                    lblOk.style.display = 'inline';
                    verificarCambios();
                }
            }

            var valoresOriginales = {};

            function guardarValoresOriginales() {
                valoresOriginales = {
                    nombreRefugio: document.getElementById('<%= txtNombreRefugio.ClientID %>').value,
                    descripcion: document.getElementById('<%= txtDescripcion.ClientID %>').value,
                    telefono: document.getElementById('<%= txtTelefono.ClientID %>').value,
                    ciudad: document.getElementById('<%= txtCiudad.ClientID %>').value,
                    direccion: document.getElementById('<%= txtDireccion.ClientID %>').value,
                    latitud: document.getElementById('<%= hfLatitud.ClientID %>').value,
                    longitud: document.getElementById('<%= hfLongitud.ClientID %>').value
                };
            }

            function verificarCambios() {
                var btnGuardar = document.getElementById('<%= btnGuardar.ClientID %>');
                var nueva = document.getElementById('<%= txtNuevaClave.ClientID %>').value;
                var confirmar = document.getElementById('<%= txtConfirmarClave.ClientID %>').value;

                if (nueva !== '' && nueva !== confirmar) {
                    btnGuardar.disabled = true;
                    return;
                }

                var hayCambios =
                    document.getElementById('<%= txtNombreRefugio.ClientID %>').value !== valoresOriginales.nombreRefugio ||
                    document.getElementById('<%= txtDescripcion.ClientID %>').value !== valoresOriginales.descripcion ||
                    document.getElementById('<%= txtTelefono.ClientID %>').value !== valoresOriginales.telefono ||
                    document.getElementById('<%= txtCiudad.ClientID %>').value !== valoresOriginales.ciudad ||
                    document.getElementById('<%= txtDireccion.ClientID %>').value !== valoresOriginales.direccion ||
                    document.getElementById('<%= hfLatitud.ClientID %>').value !== valoresOriginales.latitud ||
                    document.getElementById('<%= hfLongitud.ClientID %>').value !== valoresOriginales.longitud ||
                    nueva !== '';

                var fotoInput = document.getElementById('<%= fuFotoPerfil.ClientID %>');
                if (fotoInput && fotoInput.files && fotoInput.files.length > 0) {
                    hayCambios = true;
                }

                btnGuardar.disabled = !hayCambios;
            }

            document.addEventListener('DOMContentLoaded', function () {
                document.getElementById('<%= btnGuardar.ClientID %>').disabled = true;
                guardarValoresOriginales();

                var campos = ['<%= txtNombreRefugio.ClientID %>', '<%= txtDescripcion.ClientID %>',
                    '<%= txtTelefono.ClientID %>', '<%= txtCiudad.ClientID %>', '<%= txtDireccion.ClientID %>'];
                campos.forEach(function (id) {
                    var campo = document.getElementById(id);
                    if (campo) {
                        campo.addEventListener('input', verificarCambios);
                    }
                });

                var fotoInput = document.getElementById('<%= fuFotoPerfil.ClientID %>');
                if (fotoInput) {
                    fotoInput.addEventListener('change', verificarCambios);
                }

                // Mapa
                var latGuardada = document.getElementById('<%= hfLatitud.ClientID %>').value;
                var lngGuardada = document.getElementById('<%= hfLongitud.ClientID %>').value;

                var lat = latGuardada ? parseFloat(latGuardada) : -0.1807;
                var lng = lngGuardada ? parseFloat(lngGuardada) : -78.4678;
                var zoom = latGuardada ? 15 : 13;

                var map = L.map('mapPerfil').setView([lat, lng], zoom);

                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '© OpenStreetMap'
                }).addTo(map);

                var marker;

                if (latGuardada && lngGuardada) {
                    marker = L.marker([lat, lng]).addTo(map);
                }

                map.on('click', function (e) {
                    if (marker) map.removeLayer(marker);
                    marker = L.marker(e.latlng).addTo(map);

                    document.getElementById('<%= hfLatitud.ClientID %>').value = e.latlng.lat;
                    document.getElementById('<%= hfLongitud.ClientID %>').value = e.latlng.lng;
                    verificarCambios();
                });
            });
        </script>
    </asp:Content>