<%@ Page Title="" Language="C#" MasterPageFile="~/AdminRefugio/AdminRefugio.Master" AutoEventWireup="true"
    CodeBehind="Campanias.aspx.cs" Inherits="RedPatitas.AdminRefugio.Campanias" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Gestión de Campañas | RedPatitas
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <style>
            .campaign-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 1.5rem;
                margin-bottom: 2rem;
            }

            .campaign-card {
                background: white;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                transition: transform 0.2s;
                border: 1px solid #eee;
            }

            .campaign-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
            }

            .campaign-img {
                width: 100%;
                height: 180px;
                object-fit: cover;
            }

            .campaign-body {
                padding: 1.5rem;
            }

            .campaign-title {
                font-size: 1.1rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
                color: var(--text-dark);
            }

            .campaign-meta {
                font-size: 0.9rem;
                color: #666;
                margin-bottom: 0.5rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .campaign-desc {
                font-size: 0.9rem;
                color: #4B5563;
                line-height: 1.5;
                margin-bottom: 1rem;
                display: -webkit-box;
                -webkit-line-clamp: 3;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }

            .status-badge.active {
                background: #D1FAE5;
                color: #059669;
            }

            .status-badge.inactive {
                background: #F3F4F6;
                color: #6B7280;
            }

            /* Form Styles */
            .form-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1.5rem;
                margin-bottom: 1rem;
            }
        </style>
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    </asp:Content>
    <asp:Content ID="Content4" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">Campañas y Eventos</h1>
            <div class="breadcrumb">Dashboard / Campañas</div>
        </div>
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

        <asp:Panel ID="pnlLista" runat="server">
            <div class="recent-section">
                <div class="section-header">
                    <h2 class="section-title">Campañas Activas</h2>
                    <asp:Button ID="btnNuevaCampania" runat="server" Text="+ Nueva Campaña" CssClass="quick-action-btn"
                        OnClick="btnNuevaCampania_Click" />
                </div>

                <div class="campaign-grid">
                    <asp:Repeater ID="rptCampanias" runat="server" OnItemCommand="rptCampanias_ItemCommand">
                        <ItemTemplate>
                            <div class="campaign-card">
                                <img src='<%# Eval("cam_ImagenUrl") %>' alt="Imagen Campaña" class="campaign-img"
                                    onerror="this.src='https://via.placeholder.com/300x180'">
                                <div class="campaign-body">
                                    <div style="display:flex; justify-content:space-between; margin-bottom:0.5rem;">
                                        <span
                                            class='status-badge <%# Eval("cam_Estado").ToString() == "Activa" ? "active" : "inactive" %>'>
                                            <%# Eval("cam_Estado") %>
                                        </span>
                                        <small style="color:#666;">
                                            <%# Eval("cam_TipoCampania") %>
                                        </small>
                                    </div>
                                    <h3 class="campaign-title">
                                        <%# Eval("cam_Titulo") %>
                                    </h3>
                                    <div class="campaign-meta">
                                        <i class="far fa-calendar-alt"></i>
                                        <%# Eval("cam_FechaInicio", "{0:dd MMM}" ) %> - <%#
                                                Eval("cam_FechaFin", "{0:dd MMM yyyy}" ) %>
                                    </div>
                                    <div class="campaign-meta">
                                        <i class="fas fa-map-marker-alt"></i>
                                        <%# Eval("cam_Ubicacion") %>
                                    </div>
                                    <p class="campaign-desc">
                                        <%# Eval("cam_Descripcion") %>
                                    </p>

                                    <div class="action-buttons"
                                        style="margin-top:1rem; border-top:1px solid #eee; padding-top:1rem; justify-content:flex-end;">
                                        <asp:LinkButton ID="btnEditar" runat="server" CommandName="Editar"
                                            CommandArgument='<%# Eval("cam_IdCampania") %>'
                                            CssClass="table-action-btn info">
                                            <i class="fas fa-edit"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnEliminar" runat="server" CommandName="Eliminar"
                                            CommandArgument='<%# Eval("cam_IdCampania") %>'
                                            CssClass="table-action-btn reject"
                                            OnClientClick="return confirm('¿Eliminar esta campaña?');">
                                            <i class="fas fa-trash"></i>
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <div id="noData" runat="server" style="padding: 2rem; text-align: center; color: #666; display:none;">
                    No hay campañas registradas.
                </div>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlFormulario" runat="server" Visible="false">
            <div class="recent-section">
                <div class="section-header">
                    <h2 class="section-title">
                        <asp:Literal ID="litTituloFormulario" runat="server">Nueva Campaña</asp:Literal>
                    </h2>
                    <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn-link"
                        OnClick="btnCancelar_Click" style="background:none; border:none; cursor:pointer;" />
                </div>

                <asp:HiddenField ID="hfIdCampania" runat="server" />

                <div class="form-grid">
                    <div class="form-group" style="grid-column: span 2;">
                        <label>Título de la Campaña</label>
                        <asp:TextBox ID="txtTitulo" runat="server" CssClass="form-control"
                            placeholder="Ej. Jornada de Vacunación Gratuita"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvTitulo" runat="server" ControlToValidate="txtTitulo"
                            ErrorMessage="El título es requerido" ForeColor="Red" ValidationGroup="Campania"
                            Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label>Tipo de Campaña</label>
                        <asp:DropDownList ID="ddlTipo" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Adopción" Value="Adopción"></asp:ListItem>
                            <asp:ListItem Text="Vacunación" Value="Vacunación"></asp:ListItem>
                            <asp:ListItem Text="Esterilización" Value="Esterilización"></asp:ListItem>
                            <asp:ListItem Text="Evento Benéfico" Value="Evento"></asp:ListItem>
                            <asp:ListItem Text="Otro" Value="Otro"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="form-group" style="grid-column: span 2;">
                        <label>Ubicación</label>
                        <div class="input-with-button" style="display: flex; gap: 10px; margin-bottom: 10px;">
                            <asp:TextBox ID="txtUbicacion" runat="server" CssClass="form-control" style="flex: 1;"
                                placeholder="Ej: La Carolina, Quito"></asp:TextBox>
                            <button type="button" class="btn-secondary" onclick="buscarDireccionCampania()"
                                style="padding: 0 15px; white-space: nowrap;">
                                🔍 Buscar
                            </button>
                        </div>
                        <div id="mapCampania" style="height: 300px; border-radius: 8px; border: 1px solid #ddd; display: none;"></div>
                        <p style="font-size: 0.85rem; color: #666; margin-top: 5px;">
                            📍 Haz clic en el mapa para fijar la ubicación, o escribe la dirección y pulsa "Buscar".
                        </p>
                    </div>

                    <div class="form-group">
                        <label>Fecha Inicio</label>
                        <asp:TextBox ID="txtFechaInicio" runat="server" CssClass="form-control" TextMode="Date">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvFechaInicio" runat="server"
                            ControlToValidate="txtFechaInicio" ErrorMessage="*" ForeColor="Red"
                            ValidationGroup="Campania"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label>Fecha Fin</label>
                        <asp:TextBox ID="txtFechaFin" runat="server" CssClass="form-control" TextMode="Date">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvFechaFin" runat="server" ControlToValidate="txtFechaFin"
                            ErrorMessage="*" ForeColor="Red" ValidationGroup="Campania"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group" style="grid-column: span 2;">
                        <label>Imagen Promocional</label>
                        <!-- Vista Previa de Imagen Actual -->
                        <div id="divPreviewFotoActual" style="margin-bottom: 15px; display: none;">
                            <label style="color:#666; font-size:0.9rem;">Imagen actual de la campaña:</label><br />
                            <img id="imgFotoActual" src="" style="max-width:300px; max-height:200px; border-radius:8px; object-fit:cover; margin-top:5px; border:1px solid #ddd;" />
                        </div>
                        
                        <label id="lblActionImage">Subir o Cambiar Imagen (Opcional si ya existe)</label>
                        <asp:FileUpload ID="fuImagen" runat="server" CssClass="form-control" accept="image/*" onchange="previewNewImage(this)" />
                        
                        <!-- Vista Previa Recién Subida -->
                        <div id="divNewImagePreview" style="margin-top: 10px; display:none;">
                            <label style="color:#666; font-size:0.9rem;">Vista previa de nueva imagen a subir:</label><br />
                            <img id="imgNewPreview" src="" style="max-width:300px; max-height:200px; border-radius:8px; object-fit:cover; border:1px solid #ddd;" />
                        </div>
                        
                        <asp:HiddenField ID="hfImagenUrl" runat="server" />
                    </div>

                    <div class="form-group" style="grid-column: span 2;">
                        <label>Descripción</label>
                        <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" TextMode="MultiLine"
                            Rows="4"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label>Estado</label>
                        <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Activa" Value="Activa"></asp:ListItem>
                            <asp:ListItem Text="Inactiva" Value="Inactiva"></asp:ListItem>
                            <asp:ListItem Text="Finalizada" Value="Finalizada"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div style="margin-top: 2rem; display: flex; justify-content: flex-end; gap: 1rem;">
                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar Campaña" CssClass="quick-action-btn"
                        OnClick="btnGuardar_Click" ValidationGroup="Campania" />
                </div>
            </div>
        </asp:Panel>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            .table-action-btn.info {
                background: #DBEAFE;
                color: #2563EB;
            }

            .table-action-btn.info:hover {
                background: #2563EB;
                color: white;
            }

            .table-action-btn.reject {
                background: #FEE2E2;
                color: #DC2626;
            }

            .table-action-btn.reject:hover {
                background: #DC2626;
                color: white;
            }
        </style>
        <script type="text/javascript">
            // FOTO PREVIEW HANDLING
            function previewNewImage(input) {
                var previewDiv = document.getElementById('divNewImagePreview');
                var imgPreview = document.getElementById('imgNewPreview');
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function(e) {
                        imgPreview.src = e.target.result;
                        previewDiv.style.display = 'block';
                    }
                    reader.readAsDataURL(input.files[0]);
                } else {
                    previewDiv.style.display = 'none';
                }
            }

            function setupImagePreview() {
                var hfUrl = document.getElementById('<%= hfImagenUrl.ClientID %>');
                var currentPreviewDiv = document.getElementById('divPreviewFotoActual');
                var imgFotoActual = document.getElementById('imgFotoActual');

                if (hfUrl && hfUrl.value && hfUrl.value.trim() !== '') {
                    imgFotoActual.src = hfUrl.value;
                    currentPreviewDiv.style.display = 'block';
                } else {
                    currentPreviewDiv.style.display = 'none';
                }
            }

            // MAP HANDLING
            var mapCampania, markerCampania;
            
            function initMapCampania() {
                // Remove map if exists because panel can be hidden/shown via UpdatePanels or JS
                const mapContainer = document.getElementById('mapCampania');
                mapContainer.style.display = 'block';
                
                if (mapCampania) {
                    mapCampania.remove();
                }

                var lat = -0.1807;
                var lng = -78.4678;
                var zoom = 12;

                mapCampania = L.map('mapCampania').setView([lat, lng], zoom);

                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '© OpenStreetMap'
                }).addTo(mapCampania);

                // Check text input if we should geocode it initially
                var currentAddress = document.getElementById('<%= txtUbicacion.ClientID %>').value;
                if(currentAddress && currentAddress.trim() !== '') {
                    buscarDireccionCampania(true);
                }

                mapCampania.on('click', function (e) {
                    actualizarPosicionCampania(e.latlng);
                });
                
                setTimeout(function(){ mapCampania.invalidateSize(); }, 500);
            }

            function actualizarPosicionCampania(latlng) {
                if (markerCampania) mapCampania.removeLayer(markerCampania);
                markerCampania = L.marker(latlng, { draggable: true }).addTo(mapCampania);

                markerCampania.on('dragend', function (e) {
                    actualizarPosicionCampania(e.target.getLatLng());
                });

                obtenerDireccionCampania(latlng.lat, latlng.lng);
            }

            function obtenerDireccionCampania(lat, lng) {
                var url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}`;

                fetch(url, { headers: { 'User-Agent': 'RedPatitas/1.0' } })
                    .then(response => response.json())
                    .then(data => {
                        if (data && data.address) {
                            var ciudad = data.address.city || data.address.town || data.address.village || data.address.county || "";
                            var calle = data.address.road || "";
                            var numero = data.address.house_number || "";
                            var barrio = data.address.suburb || "";

                            var direccionCompleta = calle;
                            if (numero) direccionCompleta += " " + numero;
                            if (barrio && barrio !== ciudad) direccionCompleta += ", " + barrio;
                            if (ciudad) direccionCompleta += ", " + ciudad;

                            document.getElementById('<%= txtUbicacion.ClientID %>').value = direccionCompleta;
                        }
                    })
                    .catch(error => console.error('Error en geocoding:', error));
            }

            function buscarDireccionCampania(isInit = false) {
                var direccion = document.getElementById('<%= txtUbicacion.ClientID %>').value;
                if (!direccion) return;

                var url = `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(direccion + ', Ecuador')}&limit=1`;

                fetch(url, { headers: { 'User-Agent': 'RedPatitas/1.0' } })
                    .then(response => response.json())
                    .then(data => {
                        if (data && data.length > 0) {
                            var lat = parseFloat(data[0].lat);
                            var lon = parseFloat(data[0].lon);
                            var latlng = L.latLng(lat, lon);

                            mapCampania.setView(latlng, 15);
                            
                            if (markerCampania) mapCampania.removeLayer(markerCampania);
                            markerCampania = L.marker(latlng, { draggable: true }).addTo(mapCampania);
                            
                            markerCampania.on('dragend', function (e) {
                                actualizarPosicionCampania(e.target.getLatLng());
                            });
                        } else if (!isInit) {
                            alert("No se encontró la dirección en el mapa. Intenta ajustar el texto.");
                        }
                    })
                    .catch(error => console.error('Error en búsqueda:', error));
            }

            // Bind events on page load / form visible
            var pnlFormVisible = '<%= pnlFormulario.Visible %>';
            document.addEventListener("DOMContentLoaded", function () {
                var pnl = document.getElementById('<%= pnlFormulario.ClientID %>');
                if (pnl && pnlFormVisible === 'True') {
                    setupImagePreview();
                    initMapCampania();
                }
            });
            
            // To ensure map initializes properly if shown via PostBack (ASP.NET lifecycle)
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            if (prm != null) {
                prm.add_endRequest(function (sender, e) {
                    var isVisible = document.getElementById('<%= pnlFormulario.ClientID %>') !== null;
                    if (isVisible) {
                        setupImagePreview();
                        initMapCampania();
                    }
                });
            }
        </script>
    </asp:Content>