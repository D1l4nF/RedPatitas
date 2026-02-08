<%@ Page Title="Detalle de Reporte" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="DetalleReporte.aspx.cs" Inherits="RedPatitas.Public.DetalleReporte" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        <asp:Literal ID="litTitulo" runat="server" Text="Detalle de Reporte"></asp:Literal> | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
        <asp:HiddenField ID="hfReporteData" runat="server" />

        <div class="detalle-container">
            <!-- Cabecera del reporte -->
            <asp:Panel ID="pnlReporte" runat="server">
                <div class="detalle-header">
                    <a href="MapaExtravios.aspx" class="btn-back">← Volver al Mapa</a>
                    <asp:Panel ID="pnlEstadoBadge" runat="server" CssClass="estado-badge">
                        <asp:Literal ID="litEstado" runat="server"></asp:Literal>
                    </asp:Panel>
                </div>

                <div class="detalle-main">
                    <!-- Info principal -->
                    <div class="detalle-info">
                        <div class="info-card">
                            <asp:Image ID="imgMascota" runat="server" CssClass="foto-mascota" />
                            <div class="mascota-info">
                                <h1 class="mascota-nombre">
                                    <asp:Literal ID="litNombre" runat="server"></asp:Literal>
                                </h1>
                                <span class="tipo-badge perdida">
                                    <asp:Literal ID="litTipoReporte" runat="server"></asp:Literal>
                                </span>
                                <div class="mascota-detalles">
                                    <p><strong>Especie:</strong>
                                        <asp:Literal ID="litEspecie" runat="server"></asp:Literal>
                                    </p>
                                    <p><strong>Raza:</strong>
                                        <asp:Literal ID="litRaza" runat="server"></asp:Literal>
                                    </p>
                                    <p><strong>Color:</strong>
                                        <asp:Literal ID="litColor" runat="server"></asp:Literal>
                                    </p>
                                    <p><strong>Tamaño:</strong>
                                        <asp:Literal ID="litTamano" runat="server"></asp:Literal>
                                    </p>
                                    <p><strong>Sexo:</strong>
                                        <asp:Literal ID="litSexo" runat="server"></asp:Literal>
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="descripcion-section">
                            <h3>📝 Descripción</h3>
                            <p>
                                <asp:Literal ID="litDescripcion" runat="server"></asp:Literal>
                            </p>
                        </div>

                        <asp:Panel ID="pnlCaracteristicas" runat="server" CssClass="descripcion-section"
                            Visible="false">
                            <h3>✨ Características Distintivas</h3>
                            <p>
                                <asp:Literal ID="litCaracteristicas" runat="server"></asp:Literal>
                            </p>
                        </asp:Panel>

                        <div class="contacto-section">
                            <h3>📞 Contacto</h3>
                            <p><strong>Teléfono:</strong>
                                <asp:Literal ID="litTelefono" runat="server"></asp:Literal>
                            </p>
                            <p><strong>Email:</strong>
                                <asp:Literal ID="litEmail" runat="server"></asp:Literal>
                            </p>
                            <p><strong>Última ubicación:</strong>
                                <asp:Literal ID="litUbicacion" runat="server"></asp:Literal>
                            </p>
                        </div>
                    </div>

                    <!-- Mapa pequeño -->
                    <div class="detalle-mapa">
                        <div id="map-small"></div>
                    </div>
                </div>

                <!-- Botón dueño para marcar como reunido -->
                <asp:Panel ID="pnlAccionesDueno" runat="server" Visible="false" CssClass="acciones-dueno">
                    <asp:Button ID="btnMarcarReunido" runat="server" Text="❤️ Marcar como Reunido"
                        CssClass="btn btn-success" OnClick="btnMarcarReunido_Click"
                        OnClientClick="return confirm('¿Confirmas que tu mascota ha sido reunida contigo?');" />
                </asp:Panel>

                <!-- Timeline de avistamientos -->
                <div class="timeline-section">
                    <h2>📍 Historial de Avistamientos</h2>
                    <div class="timeline">
                        <!-- Evento inicial: reporte creado -->
                        <div class="timeline-item inicio">
                            <div class="timeline-marker">📋</div>
                            <div class="timeline-content">
                                <h4>Reporte Creado</h4>
                                <p class="timeline-date">
                                    <asp:Literal ID="litFechaReporte" runat="server"></asp:Literal>
                                </p>
                                <p>
                                    <asp:Literal ID="litUbicacionReporte" runat="server"></asp:Literal>
                                </p>
                            </div>
                        </div>

                        <!-- Avistamientos dinámicos -->
                        <asp:Repeater ID="rptAvistamientos" runat="server">
                            <ItemTemplate>
                                <div class="timeline-item avistamiento">
                                    <div class="timeline-marker">👁️</div>
                                    <div class="timeline-content">
                                        <h4>Avistamiento reportado</h4>
                                        <p class="timeline-date">
                                            <%# Eval("FechaAvistamiento", "{0:dd/MM/yyyy HH:mm}" ) %>
                                        </p>
                                        <p class="timeline-user">Por: <%# Eval("NombreUsuario") %>
                                        </p>
                                        <p>
                                            <%# Eval("Descripcion") %>
                                        </p>
                                        <asp:Panel Visible='<%# !string.IsNullOrEmpty(Eval("Ubicacion").ToString()) %>'
                                            runat="server">
                                            <p class="timeline-location">📍 <%# Eval("Ubicacion") %>
                                            </p>
                                        </asp:Panel>
                                        <asp:Image runat="server" ImageUrl='<%# Eval("FotoUrl") %>'
                                            CssClass="timeline-foto"
                                            Visible='<%# !string.IsNullOrEmpty(Eval("FotoUrl").ToString()) %>' />
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <asp:Panel ID="pnlSinAvistamientos" runat="server" CssClass="sin-avistamientos">
                            <p>Aún no hay avistamientos reportados. ¿Has visto a esta mascota? ¡Ayúdanos registrando un
                                avistamiento!</p>
                        </asp:Panel>
                    </div>
                </div>

                <!-- Formulario para nuevo avistamiento -->
                <div class="nuevo-avistamiento-section">
                    <h2>👁️ ¿Has visto a esta mascota?</h2>
                    <p>Si has visto a esta mascota, por favor ayúdanos completando el siguiente formulario:</p>

                    <div class="form-avistamiento">
                        <div class="form-group">
                            <label for="txtDescripcionAvi">Descripción del avistamiento *</label>
                            <asp:TextBox ID="txtDescripcionAvi" runat="server" TextMode="MultiLine" Rows="3"
                                CssClass="form-control"
                                placeholder="Describe dónde y cuándo viste a la mascota, cómo se veía..."></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvDescripcion" runat="server"
                                ControlToValidate="txtDescripcionAvi" ErrorMessage="La descripción es requerida"
                                CssClass="text-danger" Display="Dynamic" ValidationGroup="Avistamiento">
                            </asp:RequiredFieldValidator>
                        </div>

                        <div class="form-group">
                            <label for="txtUbicacionAvi">Ubicación aproximada</label>
                            <asp:TextBox ID="txtUbicacionAvi" runat="server" CssClass="form-control"
                                placeholder="Ej: Calle 10 con Av. Principal, cerca del parque"></asp:TextBox>
                        </div>

                        <div class="form-row">
                            <div class="form-group half">
                                <label>Selecciona la ubicación en el mapa (opcional)</label>
                                <div id="map-avistamiento"></div>
                                <asp:HiddenField ID="hfLatitud" runat="server" />
                                <asp:HiddenField ID="hfLongitud" runat="server" />
                            </div>
                            <div class="form-group half">
                                <label for="fuFotoAvi">Foto del avistamiento (opcional)</label>
                                <asp:FileUpload ID="fuFotoAvi" runat="server" CssClass="form-control"
                                    accept=".jpg,.jpeg,.png" />
                                <small>Formatos: JPG, PNG. Máximo 2MB</small>
                            </div>
                        </div>

                        <asp:Button ID="btnRegistrarAvistamiento" runat="server" Text="📤 Registrar Avistamiento"
                            CssClass="btn btn-primary" OnClick="btnRegistrarAvistamiento_Click"
                            ValidationGroup="Avistamiento" />
                    </div>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlNoEncontrado" runat="server" Visible="false" CssClass="no-encontrado">
                <div class="empty-icon">🔍</div>
                <h2>Reporte no encontrado</h2>
                <p>El reporte que buscas no existe o ha sido eliminado.</p>
                <a href="MapaExtravios.aspx" class="btn btn-primary">Ver Mapa de Extravíos</a>
            </asp:Panel>
        </div>

        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                var reporteDataField = document.getElementById('<%= hfReporteData.ClientID %>');
                if (!reporteDataField || !reporteDataField.value) return;

                var reporteData = JSON.parse(reporteDataField.value);
                if (!reporteData.Latitud || !reporteData.Longitud) return;

                // Mapa pequeño con ubicación del reporte
                var mapSmall = L.map('map-small').setView([reporteData.Latitud, reporteData.Longitud], 14);
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '© OpenStreetMap'
                }).addTo(mapSmall);

                // Marcador del reporte principal
                var iconoReporte = L.divIcon({
                    className: reporteData.Tipo === 'Perdida' ? 'marker-perdida' : 'marker-encontrada',
                    html: reporteData.Tipo === 'Perdida' ? '😿' : '🐾',
                    iconSize: [40, 40]
                });
                L.marker([reporteData.Latitud, reporteData.Longitud], { icon: iconoReporte }).addTo(mapSmall)
                    .bindPopup('<strong>' + reporteData.Nombre + '</strong><br>Ubicación original');

                // Marcadores de avistamientos
                if (reporteData.Avistamientos && reporteData.Avistamientos.length > 0) {
                    reporteData.Avistamientos.forEach(function (av, idx) {
                        if (av.Latitud && av.Longitud) {
                            var iconoAv = L.divIcon({
                                className: 'marker-avistamiento',
                                html: '👁️',
                                iconSize: [30, 30]
                            });
                            L.marker([av.Latitud, av.Longitud], { icon: iconoAv }).addTo(mapSmall)
                                .bindPopup('Avistamiento #' + (idx + 1));
                        }
                    });
                }

                // Mapa para registrar nuevo avistamiento
                var mapAvi = L.map('map-avistamiento').setView([reporteData.Latitud, reporteData.Longitud], 13);
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '© OpenStreetMap'
                }).addTo(mapAvi);

                var markerAvi = null;
                mapAvi.on('click', function (e) {
                    if (markerAvi) {
                        mapAvi.removeLayer(markerAvi);
                    }
                    markerAvi = L.marker(e.latlng).addTo(mapAvi);
                    document.getElementById('<%= hfLatitud.ClientID %>').value = e.latlng.lat.toFixed(8);
                    document.getElementById('<%= hfLongitud.ClientID %>').value = e.latlng.lng.toFixed(8);
                });
            });
        </script>

        <style>
            .detalle-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 2rem;
            }

            .detalle-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2rem;
            }

            .btn-back {
                color: var(--primary);
                text-decoration: none;
                font-weight: 500;
            }

            .estado-badge {
                padding: 0.5rem 1rem;
                border-radius: 2rem;
                font-weight: 600;
            }

            .estado-badge.activo {
                background: #27AE60;
                color: white;
            }

            .estado-badge.reunido {
                background: #8B5CF6;
                color: white;
            }

            .estado-badge.cerrado {
                background: #6B7280;
                color: white;
            }

            .detalle-main {
                display: grid;
                grid-template-columns: 1fr 400px;
                gap: 2rem;
                margin-bottom: 2rem;
            }

            .info-card {
                display: flex;
                gap: 1.5rem;
                background: var(--bg-secondary);
                border-radius: 1rem;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
            }

            .foto-mascota {
                width: 200px;
                height: 200px;
                object-fit: cover;
                border-radius: 1rem;
            }

            .mascota-nombre {
                font-size: 1.75rem;
                margin: 0 0 0.5rem 0;
            }

            .tipo-badge {
                display: inline-block;
                padding: 0.25rem 0.75rem;
                border-radius: 1rem;
                font-size: 0.875rem;
                font-weight: 600;
            }

            .tipo-badge.perdida {
                background: #E74C3C;
                color: white;
            }

            .tipo-badge.encontrada {
                background: #27AE60;
                color: white;
            }

            .mascota-detalles {
                margin-top: 1rem;
            }

            .mascota-detalles p {
                margin: 0.25rem 0;
                color: var(--text-secondary);
            }

            .descripcion-section,
            .contacto-section {
                background: var(--bg-secondary);
                border-radius: 1rem;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
            }

            .descripcion-section h3,
            .contacto-section h3 {
                margin-top: 0;
            }

            #map-small {
                height: 100%;
                min-height: 400px;
                border-radius: 1rem;
            }

            .acciones-dueno {
                background: linear-gradient(135deg, #8B5CF6 0%, #EC4899 100%);
                padding: 1.5rem;
                border-radius: 1rem;
                text-align: center;
                margin-bottom: 2rem;
            }

            .acciones-dueno .btn-success {
                background: white;
                color: #8B5CF6;
                font-weight: 600;
                padding: 0.75rem 2rem;
                border: none;
                border-radius: 2rem;
                cursor: pointer;
            }

            /* Timeline styles */
            .timeline-section {
                margin: 2rem 0;
            }

            .timeline {
                position: relative;
                padding-left: 2rem;
            }

            .timeline::before {
                content: '';
                position: absolute;
                left: 1rem;
                top: 0;
                bottom: 0;
                width: 2px;
                background: var(--border);
            }

            .timeline-item {
                position: relative;
                margin-bottom: 1.5rem;
                padding-left: 2rem;
            }

            .timeline-marker {
                position: absolute;
                left: -1.5rem;
                width: 2.5rem;
                height: 2.5rem;
                display: flex;
                align-items: center;
                justify-content: center;
                background: var(--bg-secondary);
                border: 2px solid var(--border);
                border-radius: 50%;
                font-size: 1.25rem;
            }

            .timeline-content {
                background: var(--bg-secondary);
                padding: 1rem 1.5rem;
                border-radius: 0.75rem;
            }

            .timeline-content h4 {
                margin: 0 0 0.5rem 0;
            }

            .timeline-date {
                color: var(--text-tertiary);
                font-size: 0.875rem;
                margin: 0.25rem 0;
            }

            .timeline-user {
                color: var(--primary);
                font-size: 0.875rem;
                margin: 0.25rem 0;
            }

            .timeline-location {
                color: var(--text-secondary);
                font-size: 0.875rem;
            }

            .timeline-foto {
                max-width: 200px;
                border-radius: 0.5rem;
                margin-top: 0.5rem;
            }

            .sin-avistamientos {
                text-align: center;
                padding: 2rem;
                background: var(--bg-secondary);
                border-radius: 1rem;
                color: var(--text-secondary);
            }

            /* Formulario avistamiento */
            .nuevo-avistamiento-section {
                background: var(--bg-secondary);
                padding: 2rem;
                border-radius: 1rem;
                margin-top: 2rem;
            }

            .form-avistamiento {
                margin-top: 1.5rem;
            }

            .form-group {
                margin-bottom: 1rem;
            }

            .form-group label {
                display: block;
                margin-bottom: 0.5rem;
                font-weight: 500;
            }

            .form-control {
                width: 100%;
                padding: 0.75rem;
                border: 1px solid var(--border);
                border-radius: 0.5rem;
                background: var(--bg-primary);
                color: var(--text-primary);
            }

            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 1.5rem;
            }

            #map-avistamiento {
                height: 200px;
                border-radius: 0.5rem;
            }

            .no-encontrado {
                text-align: center;
                padding: 4rem;
            }

            .empty-icon {
                font-size: 4rem;
                margin-bottom: 1rem;
            }

            /* Marcadores personalizados */
            .marker-perdida,
            .marker-encontrada,
            .marker-avistamiento {
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
            }

            @media (max-width: 768px) {
                .detalle-main {
                    grid-template-columns: 1fr;
                }

                .info-card {
                    flex-direction: column;
                }

                .form-row {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </asp:Content>