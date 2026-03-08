<%@ Page Title="Reportar Mascota" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true"
    CodeBehind="ReportarMascota.aspx.cs" Inherits="RedPatitas.Adoptante.ReportarMascota" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Reportar Mascota | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link href='<%= ResolveUrl("~/Style/dashboard.css") %>' rel="stylesheet" type="text/css" />
        <link href='<%= ResolveUrl("~/Style/forms.css") %>' rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">🚨 Reportar Mascota</h1>
            <div class="breadcrumb">Ayúdanos a reunir mascotas con sus familias</div>
        </div>
    </asp:Content>

    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

        <div class="form-container" style="max-width: 800px;">

            <!-- Mensaje de resultado -->
            <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="form-group">
                <asp:Label ID="lblMensaje" runat="server"></asp:Label>
            </asp:Panel>

            <!-- Tipo de Reporte -->
            <div class="form-group">
                <label>¿Qué deseas reportar?</label>
                <div style="display: flex; gap: 1rem; margin-top: 0.5rem;">
                    <asp:RadioButton ID="rbPerdida" runat="server" GroupName="TipoReporte" Text=" Mascota Perdida"
                        Checked="true" CssClass="radio-option" />
                    <asp:RadioButton ID="rbEncontrada" runat="server" GroupName="TipoReporte" Text=" Mascota Encontrada"
                        CssClass="radio-option" />
                </div>
            </div>

            <div class="form-divider"></div>

            <h3 class="form-section-title">📋 Datos de la mascota</h3>

            <div class="form-grid">
                <div class="form-group">
                    <label>Nombre de la mascota</label>
                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control"
                        placeholder="Ej: Max (si lo conoces)"></asp:TextBox>
                    <small class="input-hint">Opcional si es mascota encontrada</small>
                </div>
                <div class="form-group">
                    <label>Especie *</label>
                    <asp:DropDownList ID="ddlEspecie" runat="server" CssClass="form-control">
                        <asp:ListItem Value="">Selecciona...</asp:ListItem>
                        <asp:ListItem Value="1">Perro</asp:ListItem>
                        <asp:ListItem Value="2">Gato</asp:ListItem>
                        <asp:ListItem Value="3">Conejo</asp:ListItem>
                        <asp:ListItem Value="4">Ave</asp:ListItem>
                        <asp:ListItem Value="5">Hámster</asp:ListItem>
                        <asp:ListItem Value="6">Otro</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvEspecie" runat="server" ControlToValidate="ddlEspecie"
                        InitialValue="" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="form-grid">
                <div class="form-group">
                    <label>Raza (aproximada)</label>
                    <select id="ddlRazaDinamico" class="form-control"
                        onchange="document.getElementById('<%= txtRaza.ClientID %>').value = this.value;">
                        <option value="">Selecciona la especie primero...</option>
                    </select>
                    <asp:TextBox ID="txtRaza" runat="server" CssClass="form-control" style="display:none;" />
                </div>
                <div class="form-group">
                    <label>Color</label>
                    <asp:TextBox ID="txtColor" runat="server" CssClass="form-control"
                        placeholder="Ej: Negro con manchas blancas"></asp:TextBox>
                </div>
            </div>

            <div class="form-grid">
                <div class="form-group">
                    <label>Tamaño</label>
                    <asp:DropDownList ID="ddlTamano" runat="server" CssClass="form-control">
                        <asp:ListItem Value="">No sé</asp:ListItem>
                        <asp:ListItem Value="Pequeño">Pequeño</asp:ListItem>
                        <asp:ListItem Value="Mediano">Mediano</asp:ListItem>
                        <asp:ListItem Value="Grande">Grande</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>Sexo</label>
                    <asp:DropDownList ID="ddlSexo" runat="server" CssClass="form-control">
                        <asp:ListItem Value="">No sé</asp:ListItem>
                        <asp:ListItem Value="M">Macho</asp:ListItem>
                        <asp:ListItem Value="F">Hembra</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <div class="form-group">
                <label>Edad aproximada</label>
                <asp:DropDownList ID="ddlEdad" runat="server" CssClass="form-control">
                    <asp:ListItem Value="">No sé</asp:ListItem>
                    <asp:ListItem Value="Cachorro">Cachorro</asp:ListItem>
                    <asp:ListItem Value="Joven">Joven</asp:ListItem>
                    <asp:ListItem Value="Adulto">Adulto</asp:ListItem>
                    <asp:ListItem Value="Senior">Senior</asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="form-group">
                <label>Descripción y características distintivas *</label>
                <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"
                    placeholder="Describe la mascota: collar, marcas especiales, comportamiento..."></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvDescripcion" runat="server" ControlToValidate="txtDescripcion"
                    ErrorMessage="Por favor describe la mascota" ForeColor="Red"></asp:RequiredFieldValidator>
            </div>

            <div class="form-divider"></div>

            <h3 class="form-section-title">📍 Ubicación</h3>

            <div class="form-group">
                <label>Última ubicación conocida *</label>
                <asp:TextBox ID="txtUbicacion" runat="server" CssClass="form-control"
                    placeholder="Ej: Parque La Carolina, Quito"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvUbicacion" runat="server" ControlToValidate="txtUbicacion"
                    ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label>Ciudad</label>
                <asp:TextBox ID="txtCiudad" runat="server" CssClass="form-control" placeholder="Ej: Quito">
                </asp:TextBox>
            </div>

            <div class="form-group">
                <label>Marca la ubicación en el mapa</label>
                <div id="mapReporte"
                    style="height: 250px; border-radius: 8px; margin-bottom: 10px; border: 1px solid #ddd;"></div>
                <asp:HiddenField ID="hfLatitud" runat="server" />
                <asp:HiddenField ID="hfLongitud" runat="server" />
            </div>

            <div class="form-group">
                <label>Fecha del evento</label>
                <asp:TextBox ID="txtFecha" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                <small class="input-hint">¿Cuándo se perdió o encontró la mascota?</small>
            </div>

            <div class="form-divider"></div>

            <h3 class="form-section-title">📞 Contacto</h3>

            <div class="form-grid">
                <div class="form-group">
                    <label>Teléfono de contacto *</label>
                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" placeholder="Ej: 0999123456">
                    </asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvTelefono" runat="server" ControlToValidate="txtTelefono"
                        ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                </div>
                <div class="form-group">
                    <label>Email de contacto</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"
                        placeholder="Ej: correo@ejemplo.com"></asp:TextBox>
                </div>
            </div>
            <div class="form-divider"></div>
            <h3 class="form-section-title">📷 Fotos de la mascota</h3>
            <div id="uploadArea"
                style="border:2px dashed #ccc;border-radius:10px;padding:2rem;text-align:center;cursor:pointer;transition:border-color 0.2s;"
                onmouseenter="this.style.borderColor='#1a73e8'" onmouseleave="this.style.borderColor='#ccc'">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="48" height="48">
                    <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4" />
                    <polyline points="17 8 12 3 7 8" />
                    <line x1="12" y1="3" x2="12" y2="15" />
                </svg>
                <p style="margin:0.5rem 0 0;">Arrastra imágenes aquí o <span
                        style="color:#1a73e8;text-decoration:underline;">selecciona archivos</span></p>
                <small style="color:#888;">JPG, PNG &middot; Máximo 5 fotos &middot; 5 MB cada una</small>
                <asp:FileUpload ID="fuFotos" runat="server" AllowMultiple="true" accept="image/jpeg,image/png"
                    style="display:none;" />
            </div>
            <div id="fotosPreview" style="display:flex;flex-wrap:wrap;gap:10px;margin-top:1rem;"></div>
            <script type="text/javascript">
                var archivosSeleccionados = [];
                document.getElementById('uploadArea').addEventListener('click', function (e) { if (e.target.tagName !== 'INPUT') document.getElementById('<%= fuFotos.ClientID %>').click(); });
                document.getElementById('<%= fuFotos.ClientID %>').addEventListener('change', function () {
                    Array.from(this.files).forEach(function (file) {
                        if (archivosSeleccionados.length >= 5) { Swal.fire({ icon: 'warning', title: 'Límite alcanzado', text: 'Máximo 5 fotos.' }); return; }
                        if (file.size > 5 * 1024 * 1024) { Swal.fire({ icon: 'warning', title: 'Archivo muy grande', text: file.name + ' supera 5 MB.' }); return; }
                        archivosSeleccionados.push(file);
                    });
                    actualizarPreview();
                });
                function actualizarPreview() { var c = document.getElementById('fotosPreview'); c.innerHTML = ''; archivosSeleccionados.forEach(function (file, idx) { var r = new FileReader(); r.onload = function (ev) { var d = document.createElement('div'); d.style.cssText = 'position:relative;width:100px;height:100px;'; d.innerHTML = '<img src="' + ev.target.result + '" style="width:100px;height:100px;object-fit:cover;border-radius:8px;"/><button type="button" onclick="eliminarFoto(' + idx + ')" style="position:absolute;top:-6px;right:-6px;background:#e74c3c;color:#fff;border:none;border-radius:50%;width:22px;height:22px;cursor:pointer;font-size:12px;line-height:1;">✕</button>'; c.appendChild(d); }; r.readAsDataURL(file); }); }
                function eliminarFoto(idx) { archivosSeleccionados.splice(idx, 1); actualizarPreview(); }
            </script>


            <div class="form-actions">
                <asp:Button ID="btnEnviar" runat="server" Text="📤 Enviar Reporte" CssClass="btn-primary"
                    OnClick="btnEnviar_Click" />
                <a href="Dashboard.aspx" class="btn-secondary">Cancelar</a>
            </div>
        </div>

        <!-- Leaflet JS + librería reutilizable -->
        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        <script src='<%= ResolveUrl("~/Js/mapas-reportes.js") %>'></script>
        <script type="text/javascript">
            document.addEventListener('DOMContentLoaded', function () {
                var map = L.map('mapReporte').setView([-0.1807, -78.4678], 13);

                // Lógica de Razas Dinámicas
                var razasPorEspecie = {
                    "1": ["Mestizo", "Labrador", "Golden Retriever", "Pastor Alemán", "Bulldog", "Pug", "Beagle", "Poodle/Caniche", "Chihuahua", "Husky", "Otro"], // Perro
                    "2": ["Mestizo", "Siamés", "Persa", "Angora", "Bengala", "Sphynx", "Maine Coon", "Otro"], // Gato
                    "3": ["Mestizo", "Cabeza de León", "Belier", "Angora", "Otro"], // Conejo
                    "4": ["Perico", "Loro", "Canario", "Cacatúa", "Otro"], // Ave
                    "5": ["Ruso", "Sirio", "Roborowski", "Otro"], // Hamster
                    "6": ["Otro"] // Otro
                };

                var ddlEspecie = document.getElementById('<%= ddlEspecie.ClientID %>');
                var ddlRaza = document.getElementById('ddlRazaDinamico');
                var txtRaza = document.getElementById('<%= txtRaza.ClientID %>');

                function actualizarRazas() {
                    var especieSel = ddlEspecie.value;
                    ddlRaza.innerHTML = '<option value="">Selecciona una raza...</option>';

                    if (razasPorEspecie[especieSel]) {
                        razasPorEspecie[especieSel].forEach(function (raza) {
                            var opt = document.createElement("option");
                            opt.value = raza;
                            opt.textContent = raza;
                            ddlRaza.appendChild(opt);
                        });
                    }
                    if (txtRaza.value) {
                        var exists = Array.from(ddlRaza.options).some(o => o.value === txtRaza.value);
                        if (exists) ddlRaza.value = txtRaza.value;
                        else {
                            var opt = document.createElement("option");
                            opt.value = txtRaza.value; opt.textContent = txtRaza.value;
                            ddlRaza.appendChild(opt); ddlRaza.value = txtRaza.value;
                        }
                    }
                }

                if (ddlEspecie) {
                    ddlEspecie.addEventListener('change', function () {
                        txtRaza.value = '';
                        actualizarRazas();
                    });
                    actualizarRazas();
                }

                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '&copy; OpenStreetMap'
                }).addTo(map);

                var marker = null;
                function actualizarPosicion(latlng) {
                    if (marker) {
                        map.removeLayer(marker);
                    }
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

                    marker.on('dragend', function (e) {
                        actualizarPosicion(e.target.getLatLng());
                    });

                    // 4) Geocodificación inversa inmediata (sin tooltip esperando)
                    MapaReportes.geocodificacionInversa(latlng.lat, latlng.lng, function (addr) {
                        if (!addr) return;
                        var ubicacion = [addr.road, addr.suburb].filter(Boolean).join(', ');
                        if (!ubicacion) ubicacion = addr.display_name.split(',').slice(0, 2).join(',').trim();

                        var txtUbicacion = document.getElementById('<%= txtUbicacion.ClientID %>');
                        var txtCiudad = document.getElementById('<%= txtCiudad.ClientID %>');
                        if (txtUbicacion) txtUbicacion.value = ubicacion;
                        if (txtCiudad) txtCiudad.value = addr.city || '';
                    });
                }

                map.on('click', function (e) {
                    actualizarPosicion(e.latlng);
                });

                // Indicador de ayuda sobre el mapa
                var infoDiv = L.control({ position: 'bottomleft' });
                infoDiv.onAdd = function () {
                    var div = L.DomUtil.create('div');
                    div.style.cssText = 'background:rgba(255,255,255,0.9);padding:6px 10px;' +
                        'border-radius:8px;font-size:0.8rem;color:#333;' +
                        'box-shadow:0 1px 4px rgba(0,0,0,0.2);';
                    div.innerHTML = '🖱️ Haz clic en el mapa para seleccionar la ubicación';
                    return div;
                };
                infoDiv.addTo(map);
            });
        </script>
    </asp:Content>