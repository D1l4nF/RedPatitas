<%@ Page Title="" Language="C#" MasterPageFile="~/Public/Public.Master" AutoEventWireup="true"
    CodeBehind="Reportar.aspx.cs" Inherits="RedPatitas.Public.Reportar" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Reportar Mascota | RedPatitas
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link rel="stylesheet" href="~/Style/public-pages.css" />
        <link rel="stylesheet" href="~/Style/forms.css" />
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
        <style>
            .btn-mi-ubicacion {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 8px 16px;
                background: #ff6b35;
                color: #fff;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-family: inherit;
                font-size: 0.85rem;
                font-weight: 600;
                transition: background 0.2s;
                margin-top: 6px;
            }

            .btn-mi-ubicacion:hover {
                background: #e65100;
            }

            .privacy-notice {
                background: #fff8e1;
                border-left: 3px solid #f9a825;
                border-radius: 8px;
                padding: 0.75rem 1rem;
                font-size: 0.82rem;
                color: #6d5300;
                margin-bottom: 1rem;
                display: flex;
                align-items: flex-start;
                gap: 8px;
                line-height: 1.5;
            }
        </style>
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
        <section class="report-hero">
            <h1>🔍 Reportar Mascota Perdida o Encontrada</h1>
            <p>
                Sabemos lo difícil que es este momento. Completa el formulario con la mayor cantidad de detalles posible
                y nuestra comunidad te ayudará a reunirte con tu mascota.
            </p>
        </section>

        <!-- Report Form -->
        <section class="report-section">
            <div class="report-container">
                <div class="report-form-card">
                    <!-- Optional Account Banner -->
                    <div class="account-banner">
                        <span class="account-banner-icon">💡</span>
                        <div class="account-banner-content">
                            <h4>¿Ya tienes cuenta?</h4>
                            <p>Inicia sesión para dar seguimiento a tu reporte y recibir notificaciones.</p>
                            <a href="~/Login/Login.aspx" runat="server">Iniciar sesión →</a>
                        </div>
                    </div>

                    <!-- Report Type -->
                    <div class="report-type-selector">
                        <div class="report-type-option">
                            <asp:RadioButton ID="rbPerdida" runat="server" GroupName="TipoReporte" Checked="true" />
                            <div class="report-type-card lost">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="40"
                                    height="40">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>
                                <span class="report-type-title">Mascota Perdida</span>
                                <span class="report-type-desc">Perdí a mi mascota</span>
                            </div>
                        </div>
                        <div class="report-type-option">
                            <asp:RadioButton ID="rbEncontrada" runat="server" GroupName="TipoReporte" />
                            <div class="report-type-card found">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="40"
                                    height="40">
                                    <path
                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                    </path>
                                </svg>
                                <span class="report-type-title">Mascota Encontrada</span>
                                <span class="report-type-desc">Encontré una mascota</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-divider"></div>

                    <!-- Pet Info Section -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
                                <path
                                    d="M12,11.36C12.55,11.36 13,10.91 13,10.36V8.36C13,7.81 12.55,7.36 12,7.36C11.45,7.36 11,7.81 11,8.36V10.36C11,10.91 11.45,11.36 12,11.36M12,12.36C10.5,12.36 9.1,12.76 7.9,13.46C7.3,12.86 6.4,12.36 5.5,12.36C3.5,12.36 2,13.86 2,15.86C2,17.86 3.5,19.36 5.5,19.36C6.5,19.36 7.4,18.96 8.1,18.26C9,19.56 10.4,20.36 12,20.36C13.6,20.36 15,19.56 15.9,18.26C16.6,18.96 17.5,19.36 18.5,19.36C20.5,19.36 22,17.86 22,15.86C22,13.86 20.5,12.36 18.5,12.36C17.6,12.36 16.7,12.86 16.1,13.46C14.9,12.76 13.5,12.36 12,12.36Z" />
                            </svg>
                            Información de la Mascota
                        </h3>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="ddlTipoAnimal">Tipo de Animal *</label>
                                <asp:DropDownList ID="ddlTipoAnimal" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="" Text="Seleccionar..." />
                                    <asp:ListItem Value="perro" Text="🐕 Perro" />
                                    <asp:ListItem Value="gato" Text="🐱 Gato" />
                                    <asp:ListItem Value="otro" Text="🐰 Otro" />
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvTipoAnimal" runat="server"
                                    ControlToValidate="ddlTipoAnimal" ErrorMessage="Selecciona el tipo de animal"
                                    CssClass="text-danger" Display="Dynamic" />
                            </div>
                            <div class="form-group">
                                <label for="txtNombreMascota">Nombre (si se conoce)</label>
                                <asp:TextBox ID="txtNombreMascota" runat="server" CssClass="form-control"
                                    placeholder="Ej. Max" />
                            </div>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="txtRaza">Raza (aproximada)</label>
                                <asp:TextBox ID="txtRaza" runat="server" CssClass="form-control" style="display:none;"
                                    placeholder="Ej. Labrador, Mestizo" />
                                <select id="ddlRazaDinamico" class="form-control"
                                    onchange="document.getElementById('<%= txtRaza.ClientID %>').value = this.value">
                                    <option value="">Selecciona la especie primero</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="txtColor">Color / Características</label>
                                <asp:TextBox ID="txtColor" runat="server" CssClass="form-control"
                                    placeholder="Ej. Blanco con manchas café" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="txtDescripcion">Descripción detallada *</label>
                            <asp:TextBox ID="txtDescripcion" runat="server" TextMode="MultiLine" Rows="4"
                                CssClass="form-control"
                                placeholder="Describe la mascota: tamaño, características distintivas, collar, comportamiento, etc." />
                            <asp:RequiredFieldValidator ID="rfvDescripcion" runat="server"
                                ControlToValidate="txtDescripcion" ErrorMessage="La descripción es requerida"
                                CssClass="text-danger" Display="Dynamic" />
                        </div>
                    </div>

                    <div class="form-divider"></div>

                    <!-- Location Section -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20"
                                height="20">
                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                <circle cx="12" cy="10" r="3"></circle>
                            </svg>
                            Ubicación
                        </h3>

                        <div class="form-group">
                            <label>Marca en el mapa dónde ocurrió *</label>
                            <div id="map"></div>
                            <asp:HiddenField ID="hfLatitud" runat="server" />
                            <asp:HiddenField ID="hfLongitud" runat="server" />
                            <div style="display:flex; align-items:center; gap:12px; flex-wrap:wrap; margin-top:4px;">
                                <p class="map-hint" style="margin:0;">📍 Haz clic en el mapa para marcar la ubicación
                                    exacta</p>
                                <button type="button" class="btn-mi-ubicacion" id="btnMiUbicacion"
                                    onclick="usarMiUbicacion()">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
                                        <circle cx="12" cy="10" r="3" />
                                    </svg>
                                    Usar mi ubicación actual
                                </button>
                            </div>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="txtDireccion">Dirección / Referencia *</label>
                                <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control"
                                    placeholder="Ej. Parque La Carolina, cerca de la fuente" />
                                <asp:RequiredFieldValidator ID="rfvDireccion" runat="server"
                                    ControlToValidate="txtDireccion" ErrorMessage="La dirección es requerida"
                                    CssClass="text-danger" Display="Dynamic" />
                            </div>
                            <div class="form-group">
                                <label for="txtCiudad">Ciudad</label>
                                <asp:TextBox ID="txtCiudad" runat="server" CssClass="form-control"
                                    placeholder="Ej. Quito" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="txtFecha">Fecha del evento *</label>
                            <asp:TextBox ID="txtFecha" runat="server" TextMode="Date" CssClass="form-control" />
                            <asp:RequiredFieldValidator ID="rfvFecha" runat="server" ControlToValidate="txtFecha"
                                ErrorMessage="La fecha es requerida" CssClass="text-danger" Display="Dynamic" />
                        </div>
                    </div>

                    <div class="form-divider"></div>

                    <!-- Photos Section -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20"
                                height="20">
                                <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                <polyline points="21 15 16 10 5 21"></polyline>
                            </svg>
                            Fotografías
                        </h3>

                        <div class="image-upload-area" id="uploadArea">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="48"
                                height="48">
                                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                <polyline points="17 8 12 3 7 8"></polyline>
                                <line x1="12" y1="3" x2="12" y2="15"></line>
                            </svg>
                            <p>Arrastra imágenes aquí o <span>selecciona archivos</span></p>
                            <small>JPG, PNG. Máximo 5MB por imagen</small>
                            <asp:FileUpload ID="fuImagenes" runat="server" AllowMultiple="true" accept="image/*"
                                CssClass="hidden-upload" />
                        </div>
                    </div>

                    <div class="form-divider"></div>

                    <!-- Contact Section -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20"
                                height="20">
                                <path
                                    d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z">
                                </path>
                            </svg>
                            Datos de Contacto
                        </h3>

                        <div class="privacy-notice">
                            <span style="font-size:1.1rem;">🔓</span>
                            <span>Tu teléfono y correo serán visibles en el reporte para que las personas que vean tu
                                publicación puedan contactarte directamente si tienen información.</span>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="txtNombreContacto">Tu Nombre *</label>
                                <asp:TextBox ID="txtNombreContacto" runat="server" CssClass="form-control"
                                    placeholder="Ingresa tu nombre" />
                                <asp:RequiredFieldValidator ID="rfvNombreContacto" runat="server"
                                    ControlToValidate="txtNombreContacto" ErrorMessage="El nombre es requerido"
                                    CssClass="text-danger" Display="Dynamic" />
                            </div>
                            <div class="form-group">
                                <label for="txtTelefono">Teléfono de Contacto *</label>
                                <asp:TextBox ID="txtTelefono" runat="server" TextMode="Phone" CssClass="form-control"
                                    placeholder="Ej. 0991234567" />
                                <asp:RequiredFieldValidator ID="rfvTelefono" runat="server"
                                    ControlToValidate="txtTelefono" ErrorMessage="El teléfono es requerido"
                                    CssClass="text-danger" Display="Dynamic" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="txtEmail">Email (opcional)</label>
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control"
                                placeholder="tu@email.com" />
                            <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                                ValidationExpression="^[\w\.-]+@[\w\.-]+\.\w+$" ErrorMessage="Ingresa un email válido"
                                CssClass="text-danger" Display="Dynamic" />
                        </div>

                        <!-- Optional: Create Account -->
                        <div class="create-account-option">
                            <asp:CheckBox ID="chkCrearCuenta" runat="server" />
                            <label for="chkCrearCuenta">
                                <strong>Crear una cuenta</strong> para dar seguimiento a mi reporte, recibir
                                notificaciones y gestionar futuros reportes.
                            </label>
                        </div>
                    </div>

                    <div class="form-divider"></div>

                    <!-- Submit -->
                    <asp:Button ID="btnPublicarReporte" runat="server" Text="Publicar mi reporte y pedir ayuda"
                        CssClass="btn-submit" OnClick="btnPublicarReporte_Click" />

                    <asp:Label ID="lblMensaje" runat="server" CssClass="mensaje-resultado" Visible="false" />
                </div>
            </div>
        </section>

        <script>
            // Clic en área de upload → abre el file input
            document.getElementById('uploadArea').addEventListener('click', function () {
                document.getElementById('<%= fuImagenes.ClientID %>').click();
            });

            // Preview de imágenes seleccionadas
            document.getElementById('<%= fuImagenes.ClientID %>').addEventListener('change', function () {
                var files = this.files;
                var hint = document.querySelector('.map-hint');
                document.querySelectorAll('.img-preview-thumb').forEach(function (el) { el.remove(); });
                var area = document.getElementById('uploadArea');
                for (var i = 0; i < Math.min(files.length, 5); i++) {
                    var reader = new FileReader();
                    (function (file) {
                        reader.onload = function (e) {
                            var img = document.createElement('img');
                            img.src = e.target.result;
                            img.className = 'img-preview-thumb';
                            img.style.cssText = 'width:70px;height:70px;object-fit:cover;border-radius:8px;margin:4px;';
                            area.appendChild(img);
                        };
                        reader.readAsDataURL(file);
                    })(files[i]);
                }
            });
        </script>

        <!-- Leaflet JS + librería reutilizable -->
        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        <script src='<%= ResolveUrl("~/Js/mapas-reportes.js") %>'></script>
        <script>
            // Initialize map centered on Quito
            var map = L.map('map').setView([-0.1807, -78.4678], 13);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; OpenStreetMap'
            }).addTo(map);

            // Lógica de Razas Dinámicas
            var razasPorEspeciePub = {
                "perro": ["Mestizo", "Labrador", "Golden Retriever", "Pastor Alemán", "Bulldog", "Pug", "Beagle", "Poodle/Caniche", "Chihuahua", "Husky", "Otro"],
                "gato": ["Mestizo", "Siamés", "Persa", "Angora", "Bengala", "Sphynx", "Maine Coon", "Otro"],
                "otro": ["Mestizo", "Conejo", "Ave", "Hamster", "Otro"]
            };

            var ddlEspeciePub = document.getElementById('<%= ddlTipoAnimal.ClientID %>');
            var ddlRazaPub = document.getElementById('ddlRazaDinamico');
            var txtRazaPub = document.getElementById('<%= txtRaza.ClientID %>');

            function actualizarRazasPub() {
                var especieSel = ddlEspeciePub ? ddlEspeciePub.value.toLowerCase() : "";
                ddlRazaPub.innerHTML = '<option value="">Selecciona una raza...</option>';
                if (razasPorEspeciePub[especieSel]) {
                    razasPorEspeciePub[especieSel].forEach(function (r) {
                        var o = document.createElement("option");
                        o.value = r; o.textContent = r;
                        ddlRazaPub.appendChild(o);
                    });
                }
                if (txtRazaPub && txtRazaPub.value) {
                    var exists = Array.from(ddlRazaPub.options).some(o => o.value === txtRazaPub.value);
                    if (exists) ddlRazaPub.value = txtRazaPub.value;
                    else {
                        var o = document.createElement("option");
                        o.value = txtRazaPub.value; o.textContent = txtRazaPub.value;
                        ddlRazaPub.appendChild(o); ddlRazaPub.value = txtRazaPub.value;
                    }
                }
            }

            if (ddlEspeciePub) {
                ddlEspeciePub.addEventListener('change', function () {
                    if (txtRazaPub) txtRazaPub.value = '';
                    actualizarRazasPub();
                });
                actualizarRazasPub();
            }

            var marker = null;
            var mapHint = document.querySelector('.map-hint');

            function actualizarPosicion(latlng) {
                if (marker) map.removeLayer(marker);
                marker = L.marker(latlng, {
                    draggable: true,
                    icon: L.divIcon({
                        className: '',
                        html: '<div style="background:#e74c3c;width:32px;height:32px;border-radius:50%;' +
                            'display:flex;align-items:center;justify-content:center;' +
                            'font-size:18px;box-shadow:0 2px 8px rgba(0,0,0,0.4);">📍</div>',
                        iconSize: [32, 32], iconAnchor: [16, 32]
                    })
                }).addTo(map);

                document.getElementById('<%= hfLatitud.ClientID %>').value = latlng.lat;
                document.getElementById('<%= hfLongitud.ClientID %>').value = latlng.lng;

                // Indicador visual: mapa marcado ✅
                if (mapHint) {
                    mapHint.innerHTML = '✅ Ubicación marcada. Puedes arrastrar el pin para ajustar.';
                    mapHint.style.color = '#27ae60';
                }

                marker.on('dragend', function (e) { actualizarPosicion(e.target.getLatLng()); });

                // Geocodificación inversa para autocompletar dirección
                if (typeof MapaReportes !== 'undefined' && MapaReportes.geocodificacionInversa) {
                    MapaReportes.geocodificacionInversa(latlng.lat, latlng.lng, function (addr) {
                        if (!addr) return;
                        var ubicacion = [addr.road, addr.suburb].filter(Boolean).join(', ');
                        if (!ubicacion) ubicacion = addr.display_name.split(',').slice(0, 2).join(',').trim();
                        var txtDir = document.getElementById('<%= txtDireccion.ClientID %>');
                        if (txtDir && !txtDir.value) txtDir.value = ubicacion;
                    });
                }
            }

            map.on('click', function (e) { actualizarPosicion(e.latlng); });

            // ── Botón "Usar mi ubicación actual" ──
            function usarMiUbicacion() {
                var btn = document.getElementById('btnMiUbicacion');
                if (!navigator.geolocation) {
                    Swal.fire({ icon: 'error', title: 'No disponible', text: 'Tu navegador no soporta geolocalización.' });
                    return;
                }
                btn.disabled = true;
                btn.innerHTML = '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg> Ubicando...';
                navigator.geolocation.getCurrentPosition(function (pos) {
                    var latlng = { lat: pos.coords.latitude, lng: pos.coords.longitude };
                    map.setView([latlng.lat, latlng.lng], 15);
                    actualizarPosicion(latlng);
                    btn.disabled = false;
                    btn.innerHTML = '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg> Ubicación detectada';
                    // Auto-fill ciudad via geocodificación inversa
                    if (typeof MapaReportes !== 'undefined' && MapaReportes.geocodificacionInversa) {
                        MapaReportes.geocodificacionInversa(latlng.lat, latlng.lng, function (addr) {
                            if (!addr) return;
                            var txtCiudad = document.getElementById('<%= txtCiudad.ClientID %>');
                            if (txtCiudad && !txtCiudad.value && addr.city) txtCiudad.value = addr.city;
                        });
                    }
                }, function () {
                    btn.disabled = false;
                    btn.innerHTML = '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg> Usar mi ubicación actual';
                    Swal.fire({ icon: 'warning', title: 'Sin acceso', text: 'Permite el acceso a tu ubicación en el navegador.' });
                });
            }
            // Exponer al scope global para onclick
            window.usarMiUbicacion = usarMiUbicacion;

            // ── Validación del submit con SweetAlert ────────────────────────────
            var btnSubmit = document.getElementById('<%= btnPublicarReporte.ClientID %>');
            if (btnSubmit) {
                btnSubmit.addEventListener('click', function (e) {
                    var lat = document.getElementById('<%= hfLatitud.ClientID %>').value;
                    var tipoAnimal = document.getElementById('<%= ddlTipoAnimal.ClientID %>').value;
                    var descripcion = document.getElementById('<%= txtDescripcion.ClientID %>').value.trim();
                    var direccion = document.getElementById('<%= txtDireccion.ClientID %>').value.trim();
                    var telefono = document.getElementById('<%= txtTelefono.ClientID %>').value.trim();
                    var nombre = document.getElementById('<%= txtNombreContacto.ClientID %>').value.trim();

                    var errores = [];
                    if (!tipoAnimal) errores.push('• Selecciona el tipo de animal');
                    if (!descripcion) errores.push('• Escribe una descripción de la mascota');
                    if (!direccion) errores.push('• Escribe la dirección o referencia');
                    if (!nombre) errores.push('• Ingresa tu nombre de contacto');
                    if (!telefono) errores.push('• Ingresa tu teléfono de contacto');
                    if (!lat) errores.push('• Marca la ubicación en el mapa (haz clic sobre el mapa)');

                    if (errores.length > 0) {
                        e.preventDefault();
                        e.stopPropagation();
                        Swal.fire({
                            icon: 'warning',
                            title: 'Faltan datos',
                            html: '<div style="text-align:left;line-height:1.8;">' + errores.join('<br>') + '</div>',
                            confirmButtonText: 'Entendido',
                            confirmButtonColor: '#ff6b35'
                        });
                        return false;
                    }
                }, true); // useCapture = true para interceptar antes del validator
            }

            // Fecha por defecto: hoy
            var fechaInput = document.getElementById('<%= txtFecha.ClientID %>');
            if (fechaInput && !fechaInput.value) {
                fechaInput.value = new Date().toISOString().split('T')[0];
            }

            // Efecto visual al seleccionar tipo de reporte
            document.querySelectorAll('.report-type-option').forEach(function (option) {
                option.addEventListener('click', function () {
                    var radio = this.querySelector('input[type="radio"]');
                    if (radio) radio.checked = true;
                });
            });
        </script>
    </asp:Content>