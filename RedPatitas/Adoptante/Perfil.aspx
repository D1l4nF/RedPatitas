<%@ Page Title="" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true"
    CodeBehind="Perfil.aspx.cs" Inherits="RedPatitas.Adoptante.Perfil" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Mi Perfil
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <!-- Leaflet CSS -->
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
        <style>
            /* Ajuste para que la imagen ASP se vea redonda igual que el div original */
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
    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">Mi Perfil</h1>
            <div class="breadcrumb">Cuenta / Mi Perfil</div>
        </div>
    </asp:Content>
    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
        <div class="form-container">

            <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="form-group">
                <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>
            </asp:Panel>

            <div class="avatar-section">
                <asp:Image ID="imgFotoActual" runat="server" CssClass="avatar-img"
                    ImageUrl="~/Images/default-user.png" />

                <div class="avatar-actions">
                    <asp:FileUpload ID="fuFotoPerfil" runat="server" CssClass="btn-secondary" accept=".jpg,.png,.jpeg"
                        onchange="previewImage(this)" />
                    <span class="avatar-hint">JPG, PNG. Máximo 2MB</span>
                </div>
            </div>

            <div class="form-grid">
                <div class="form-group">
                    <label for="txtNombre">Nombre</label>
                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Ej: Jaime">
                    </asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre"
                        ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                </div>
                <div class="form-group">
                    <label for="txtApellido">Apellido</label>
                    <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control" placeholder="Ej: Peralvo">
                    </asp:TextBox>
                </div>
            </div>

            <div class="form-group">
                <label for="txtEmail">Correo Electrónico</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" Enabled="false">
                </asp:TextBox>
                <small class="input-hint">El correo electrónico no puede ser modificado</small>
            </div>

            <div class="form-grid">
                <div class="form-group">
                    <label for="txtTelefono">Teléfono</label>
                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" TextMode="Phone"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label for="txtCedula">Cédula</label>
                    <asp:TextBox ID="txtCedula" runat="server" CssClass="form-control"></asp:TextBox>
                    <small class="input-hint verified"
                        style="color:#27AE60; display:flex; align-items:center; gap:5px;">
                        <svg viewBox="0 0 24 24" fill="none" width="14" height="14">
                            <path d="M20 6L9 17L4 12" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                stroke-linejoin="round" />
                        </svg>
                        Identificación
                    </small>
                </div>
            </div>

            <div class="form-group">
                <label>Ubicación</label>

                <div class="form-grid" style="margin-bottom: 15px;">
                    <div class="form-group">
                        <label for="txtCiudad">Ciudad</label>
                        <asp:TextBox ID="txtCiudad" runat="server" CssClass="form-control" placeholder="Ej: Quito">
                        </asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtDireccion">Dirección / Calles</label>
                        <div class="input-with-button" style="display: flex; gap: 10px;">
                            <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control"
                                placeholder="Ej: Av. Amazonas y Naciones Unidas"></asp:TextBox>
                            <button type="button" class="btn-secondary" onclick="buscarDireccion()"
                                style="padding: 0 15px; white-space: nowrap;">
                                🔍 Buscar
                            </button>
                        </div>
                    </div>
                </div>

                <div id="mapPerfil"
                    style="height: 300px; border-radius: 8px; margin-bottom: 10px; border: 1px solid #ddd;"></div>
                <asp:HiddenField ID="hfLatitud" runat="server" />
                <asp:HiddenField ID="hfLongitud" runat="server" />
                <p style="font-size: 0.85rem; color: #666; margin-bottom: 10px;">
                    📍 Haz clic en el mapa para obtener la dirección automáticamente, o escribe la dirección y pulsa
                    "Buscar" para ubicarte en el mapa.
                </p>
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
                    OnClick="btnGuardar_Click" />
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

        <!-- Leaflet JS -->
        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        <script type="text/javascript">
            // Toggle mostrar/ocultar contraseña
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

            // Validar que las contraseñas coincidan en tiempo real
            function validarContrasenasCoinciden() {
                var nueva = document.getElementById('<%= txtNuevaClave.ClientID %>').value;
                var confirmar = document.getElementById('<%= txtConfirmarClave.ClientID %>').value;
                var lblMatch = document.getElementById('lblPasswordMatch');
                var lblOk = document.getElementById('lblPasswordOk');

                // Si ambos campos están vacíos, ocultar mensajes
                if (nueva === '' && confirmar === '') {
                    lblMatch.style.display = 'none';
                    lblOk.style.display = 'none';
                    verificarCambios();
                    return;
                }

                // Si hay algo en nueva pero confirmar está vacía
                if (nueva !== '' && confirmar === '') {
                    lblMatch.style.display = 'none';
                    lblOk.style.display = 'none';
                    document.getElementById('<%= btnGuardar.ClientID %>').disabled = true;
                    return;
                }

                // Comparar contraseñas
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

            // Variables para almacenar valores originales
            var valoresOriginales = {};

            // Función para guardar valores originales
            function guardarValoresOriginales() {
                valoresOriginales = {
                    nombre: document.getElementById('<%= txtNombre.ClientID %>').value,
                    apellido: document.getElementById('<%= txtApellido.ClientID %>').value,
                    telefono: document.getElementById('<%= txtTelefono.ClientID %>').value,
                    cedula: document.getElementById('<%= txtCedula.ClientID %>').value,
                    ciudad: document.getElementById('<%= txtCiudad.ClientID %>').value,
                    latitud: document.getElementById('<%= hfLatitud.ClientID %>').value,
                    longitud: document.getElementById('<%= hfLongitud.ClientID %>').value
                };
            }

            // Función para verificar si hay cambios
            function verificarCambios() {
                var btnGuardar = document.getElementById('<%= btnGuardar.ClientID %>');
                var nueva = document.getElementById('<%= txtNuevaClave.ClientID %>').value;
                var confirmar = document.getElementById('<%= txtConfirmarClave.ClientID %>').value;

                // Si las contraseñas no coinciden, mantener deshabilitado
                if (nueva !== '' && nueva !== confirmar) {
                    btnGuardar.disabled = true;
                    return;
                }

                // Verificar cambios en campos de texto
                var hayCambios =
                    document.getElementById('<%= txtNombre.ClientID %>').value !== valoresOriginales.nombre ||
                    document.getElementById('<%= txtApellido.ClientID %>').value !== valoresOriginales.apellido ||
                    document.getElementById('<%= txtTelefono.ClientID %>').value !== valoresOriginales.telefono ||
                    document.getElementById('<%= txtCedula.ClientID %>').value !== valoresOriginales.cedula ||
                    document.getElementById('<%= txtCiudad.ClientID %>').value !== valoresOriginales.ciudad ||
                    document.getElementById('<%= hfLatitud.ClientID %>').value !== valoresOriginales.latitud ||
                    document.getElementById('<%= hfLongitud.ClientID %>').value !== valoresOriginales.longitud ||
                    nueva !== ''; // También si hay nueva contraseña

                // Verificar si se seleccionó una foto
                var fotoInput = document.getElementById('<%= fuFotoPerfil.ClientID %>');
                if (fotoInput && fotoInput.files && fotoInput.files.length > 0) {
                    hayCambios = true;
                }

                btnGuardar.disabled = !hayCambios;
            }

            // Esperar a que el DOM esté listo
            document.addEventListener('DOMContentLoaded', function () {
                // Deshabilitar botón de guardar al inicio
                document.getElementById('<%= btnGuardar.ClientID %>').disabled = true;

                // Guardar valores originales
                guardarValoresOriginales();

                // Agregar listeners a todos los campos editables
                var campos = ['<%= txtNombre.ClientID %>', '<%= txtApellido.ClientID %>',
                    '<%= txtTelefono.ClientID %>', '<%= txtCedula.ClientID %>',
                    '<%= txtCiudad.ClientID %>', '<%= txtDireccion.ClientID %>'];

                campos.forEach(function (id) {
                    var campo = document.getElementById(id);
                    if (campo) {
                        campo.addEventListener('input', verificarCambios);
                    }
                });

                // Listener para el campo de foto
                var fotoInput = document.getElementById('<%= fuFotoPerfil.ClientID %>');
                if (fotoInput) {
                    fotoInput.addEventListener('change', verificarCambios);
                }

                initMap();
            });

            var map, marker;

            function initMap() {
                // Coordenadas guardadas o por defecto (Quito)
                var latGuardada = document.getElementById('<%= hfLatitud.ClientID %>').value;
                var lngGuardada = document.getElementById('<%= hfLongitud.ClientID %>').value;

                var lat = latGuardada ? parseFloat(latGuardada) : -0.1807;
                var lng = lngGuardada ? parseFloat(lngGuardada) : -78.4678;
                var zoom = latGuardada ? 16 : 13;

                // Inicializar mapa
                map = L.map('mapPerfil').setView([lat, lng], zoom);

                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '© OpenStreetMap'
                }).addTo(map);

                // Si hay coordenadas guardadas, mostrar marcador
                if (latGuardada && lngGuardada) {
                    marker = L.marker([lat, lng], { draggable: true }).addTo(map);

                    // Si se arrastra el marcador existente
                    marker.on('dragend', function (e) {
                        actualizarPosicion(e.target.getLatLng());
                    });
                }

                // Click en el mapa para colocar marcador
                map.on('click', function (e) {
                    actualizarPosicion(e.latlng);
                });
            }

            function actualizarPosicion(latlng) {
                if (marker) map.removeLayer(marker);
                marker = L.marker(latlng, { draggable: true }).addTo(map);

                // Actualizar HiddenFields
                document.getElementById('<%= hfLatitud.ClientID %>').value = latlng.lat;
                document.getElementById('<%= hfLongitud.ClientID %>').value = latlng.lng;

                // Evento dragend para el nuevo marcador
                marker.on('dragend', function (e) {
                    actualizarPosicion(e.target.getLatLng());
                });

                // Reverse Geocoding (Obtener dirección desde coordenadas)
                obtenerDireccion(latlng.lat, latlng.lng);

                verificarCambios();
            }

            function obtenerDireccion(lat, lng) {
                // Usar Nominatim API (OpenStreetMap)
                var url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}`;

                fetch(url, {
                    headers: {
                        'User-Agent': 'RedPatitas/1.0' // Es buena práctica identificarse
                    }
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data && data.address) {
                            // Llenar ciudad
                            var ciudad = data.address.city || data.address.town || data.address.village || data.address.county || "";
                            document.getElementById('<%= txtCiudad.ClientID %>').value = ciudad;

                            // Llenar dirección (calle)
                            var calle = data.address.road || "";
                            var numero = data.address.house_number || "";
                            var barrio = data.address.suburb || "";

                            var direccionCompleta = calle;
                            if (numero) direccionCompleta += " " + numero;
                            if (barrio && barrio !== ciudad) direccionCompleta += ", " + barrio;

                            document.getElementById('<%= txtDireccion.ClientID %>').value = direccionCompleta;

                            // Verificar cambios de nuevo porque cambiamos valores programáticamente
                            verificarCambios();
                        }
                    })
                    .catch(error => console.error('Error en geocoding:', error));
            }

            function buscarDireccion() {
                var ciudad = document.getElementById('<%= txtCiudad.ClientID %>').value;
                var direccion = document.getElementById('<%= txtDireccion.ClientID %>').value;

                if (!direccion && !ciudad) return;

                var query = direccion;
                if (ciudad) query += ", " + ciudad;
                // Preferir Ecuador si no se especifica
                if (!query.toLowerCase().includes("ecuador")) query += ", Ecuador";

                var url = `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(query)}`;

                fetch(url, {
                    headers: {
                        'User-Agent': 'RedPatitas/1.0'
                    }
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data && data.length > 0) {
                            var lat = parseFloat(data[0].lat);
                            var lon = parseFloat(data[0].lon);
                            var latlng = L.latLng(lat, lon);

                            map.setView(latlng, 16);
                            actualizarPosicion(latlng); // Esto pondrá el marcador y actualizará hidden fields
                        } else {
                            alert("No se encontró la dirección. Intenta ser más específico.");
                        }
                    })
                    .catch(error => console.error('Error en búsqueda:', error));
            }
        </script>
    </asp:Content>