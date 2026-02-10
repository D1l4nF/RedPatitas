<%@ Page Title="Mapa de Mascotas Perdidas" Language="C#" MasterPageFile="~/Public/Public.Master" AutoEventWireup="true"
    CodeBehind="MapaExtravios.aspx.cs" Inherits="RedPatitas.Public.MapaExtravios" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Mapa de Extravíos | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
        <script src="https://unpkg.com/leaflet.heat/dist/leaflet-heat.js"></script>
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
        <section class="map-hero">
            <h1>🗺️ Mapa de Mascotas Perdidas y Encontradas</h1>
            <p>Explora el mapa para ayudar a reunir mascotas con sus familias</p>
            <div class="stats-bar">
                <div class="stat-item">
                    <div class="stat-number">
                        <asp:Literal ID="litPerdidas" runat="server">0</asp:Literal>
                    </div>
                    <div class="stat-label">Mascotas Perdidas</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">
                        <asp:Literal ID="litEncontradas" runat="server">0</asp:Literal>
                    </div>
                    <div class="stat-label">Mascotas Encontradas</div>
                </div>
            </div>
        </section>

        <div class="map-container">
            <!-- Filtros -->
            <div class="map-filters">
                <div class="filter-group">
                    <label>Mostrar:</label>
                    <asp:DropDownList ID="ddlFiltroTipo" runat="server" CssClass="form-control" AutoPostBack="false"
                        onchange="filtrarMarcadores()">
                        <asp:ListItem Value="todos" Text="Todas" Selected="True" />
                        <asp:ListItem Value="Perdida" Text="🔴 Solo Perdidas" />
                        <asp:ListItem Value="Encontrada" Text="🟢 Solo Encontradas" />
                    </asp:DropDownList>
                </div>
                <div class="filter-group">
                    <label><input type="checkbox" id="chkHeatmap" onchange="toggleHeatmap()" /> Mapa de Calor</label>
                </div>
                <div class="filter-group">
                    <a href="ReportarMascota.aspx" class="btn-map-action">+ Reportar Mascota</a>
                </div>
            </div>

            <!-- Mapa -->
            <div id="mapExtravios"></div>

            <!-- Leyenda -->
            <div class="legend">
                <h4>📍 Leyenda</h4>
                <div class="legend-item">
                    <span class="legend-marker marker-lost"></span>
                    <span>Mascota Perdida - ¡Ayuda a encontrarla!</span>
                </div>
                <div class="legend-item">
                    <span class="legend-marker marker-found"></span>
                    <span>Mascota Encontrada - ¿Reconoces al dueño?</span>
                </div>
            </div>
        </div>

        <!-- Hidden field con datos JSON de reportes -->
        <asp:HiddenField ID="hfReportesJson" runat="server" />

        <!-- Leaflet JS -->
        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        <script type="text/javascript">
            var map;
            var marcadores = [];
            var reportesData = [];
            var heatLayer = null;
            var heatmapActivo = false;

            document.addEventListener('DOMContentLoaded', function () {
                // Inicializar mapa centrado en Quito
                map = L.map('mapExtravios').setView([-0.1807, -78.4678], 12);

                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '© OpenStreetMap'
                }).addTo(map);

                // Obtener datos de reportes desde el servidor
                var jsonData = document.getElementById('<%= hfReportesJson.ClientID %>').value;
                if (jsonData && jsonData.trim() !== '' && jsonData !== '[]') {
                    reportesData = JSON.parse(jsonData);
                    cargarMarcadores(reportesData);
                }
            });

            function cargarMarcadores(reportes) {
                // Limpiar marcadores anteriores
                marcadores.forEach(function (m) { map.removeLayer(m); });
                marcadores = [];

                reportes.forEach(function (reporte) {
                    if (reporte.Latitud && reporte.Longitud) {
                        // Icono personalizado según tipo
                        var iconColor = reporte.Tipo === 'Perdida' ? 'red' : 'green';
                        var emoji = reporte.Tipo === 'Perdida' ? '😿' : '🐾';

                        var customIcon = L.divIcon({
                            className: 'custom-marker',
                            html: '<div style="background:' + (reporte.Tipo === 'Perdida' ? '#e74c3c' : '#27ae60') +
                                ';width:30px;height:30px;border-radius:50%;display:flex;align-items:center;justify-content:center;color:white;font-size:14px;box-shadow:0 2px 5px rgba(0,0,0,0.3);">' +
                                emoji + '</div>',
                            iconSize: [30, 30],
                            iconAnchor: [15, 15]
                        });

                        var marker = L.marker([reporte.Latitud, reporte.Longitud], { icon: customIcon })
                            .bindPopup(
                                '<div style="min-width:200px;">' +
                                '<h4 style="margin:0 0 8px 0;">' + (reporte.Tipo === 'Perdida' ? '🔴 PERDIDA' : '🟢 ENCONTRADA') + '</h4>' +
                                '<p style="margin:0 0 5px 0;"><strong>Nombre:</strong> ' + (reporte.Nombre || 'Desconocido') + '</p>' +
                                '<p style="margin:0 0 5px 0;"><strong>Descripción:</strong> ' + (reporte.Descripcion || 'Sin descripción') + '</p>' +
                                '<p style="margin:0 0 5px 0;"><strong>Ubicación:</strong> ' + (reporte.Ubicacion || 'No especificada') + '</p>' +
                                '<p style="margin:0 0 5px 0;"><strong>Fecha:</strong> ' + (reporte.Fecha || 'No especificada') + '</p>' +
                                '<p style="margin:0 0 10px 0;"><strong>Contacto:</strong> ' + (reporte.Telefono || 'No disponible') + '</p>' +
                                '<a href="DetalleReporte.aspx?id=' + reporte.Id + '" style="display:inline-block;padding:6px 12px;background:#6C63FF;color:white;text-decoration:none;border-radius:5px;font-size:12px;">Ver Detalles →</a>' +
                                '</div>'
                            );

                        marker.tipoReporte = reporte.Tipo;
                        marcadores.push(marker);
                        marker.addTo(map);
                    }
                });

                // Ajustar vista si hay marcadores
                if (marcadores.length > 0) {
                    var group = new L.featureGroup(marcadores);
                    map.fitBounds(group.getBounds().pad(0.1));
                }
            }

            function filtrarMarcadores() {
                var filtro = document.getElementById('<%= ddlFiltroTipo.ClientID %>').value;

                marcadores.forEach(function (marker) {
                    if (filtro === 'todos' || marker.tipoReporte === filtro) {
                        if (!map.hasLayer(marker) && !heatmapActivo) {
                            marker.addTo(map);
                        }
                    } else {
                        map.removeLayer(marker);
                    }
                });

                // Actualizar heatmap si está activo
                if (heatmapActivo) {
                    actualizarHeatmap(filtro);
                }
            }

            function toggleHeatmap() {
                heatmapActivo = document.getElementById('chkHeatmap').checked;
                var filtro = document.getElementById('<%= ddlFiltroTipo.ClientID %>').value;

                if (heatmapActivo) {
                    // Ocultar marcadores y mostrar heatmap
                    marcadores.forEach(function (m) { map.removeLayer(m); });
                    actualizarHeatmap(filtro);
                } else {
                    // Mostrar marcadores y quitar heatmap
                    if (heatLayer) {
                        map.removeLayer(heatLayer);
                        heatLayer = null;
                    }
                    filtrarMarcadores();
                }
            }

            function actualizarHeatmap(filtro) {
                if (heatLayer) {
                    map.removeLayer(heatLayer);
                }

                var heatData = reportesData
                    .filter(function (r) {
                        return (filtro === 'todos' || r.Tipo === filtro) && r.Latitud && r.Longitud;
                    })
                    .map(function (r) {
                        return [r.Latitud, r.Longitud, 1];
                    });

                if (heatData.length > 0) {
                    heatLayer = L.heatLayer(heatData, {
                        radius: 25,
                        blur: 15,
                        maxZoom: 17,
                        gradient: { 0.4: 'yellow', 0.65: 'orange', 1: 'red' }
                    }).addTo(map);
                }
            }
        </script>
    </asp:Content>