<%@ Page Title="Mapa de Mascotas Perdidas" Language="C#" MasterPageFile="~/Public/Public.Master" AutoEventWireup="true"
    CodeBehind="MapaExtravios.aspx.cs" Inherits="RedPatitas.Public.MapaExtravios" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Mapa de Extravíos | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
        <style>
            /* ── Layout general ── */
            .mapa-page {
                max-width: 1200px;
                margin: 0 auto;
                padding: 100px 1rem 3rem;
                /* 100px top padding for fixed header */
            }

            .page-title {
                text-align: center;
                margin-bottom: 1.5rem;
                color: #222;
                font-size: 1.8rem;
            }

            .page-title span {
                color: #ff6b35;
            }

            /* ── Filtros ── */
            .filters-bar {
                display: flex;
                gap: 0.75rem;
                flex-wrap: wrap;
                align-items: flex-end;
                padding: 1rem 1.25rem;
                background: #fff;
                border-radius: 14px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.07);
                margin-bottom: 0.75rem;
            }

            .filter-group {
                display: flex;
                flex-direction: column;
                gap: 3px;
            }

            .filter-group label {
                font-size: 0.7rem;
                color: #888;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .filter-control {
                padding: 8px 12px;
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                font-family: inherit;
                font-size: 0.88rem;
                background: #fafafa;
                min-width: 130px;
                transition: border-color 0.2s;
            }

            .filter-control:focus {
                border-color: #ff6b35;
                outline: none;
                background: #fff;
            }

            .search-input {
                padding: 8px 12px 8px 36px;
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                font-family: inherit;
                font-size: 0.88rem;
                background: #fafafa url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%23999' stroke-width='2'%3E%3Ccircle cx='11' cy='11' r='8'/%3E%3Cline x1='21' y1='21' x2='16.65' y2='16.65'/%3E%3C/svg%3E") 10px center no-repeat;
                min-width: 200px;
                transition: border-color 0.2s;
            }

            .search-input:focus {
                border-color: #ff6b35;
                outline: none;
                background-color: #fff;
            }

            .btn-icon {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 8px 16px;
                border: none;
                border-radius: 8px;
                font-family: inherit;
                font-size: 0.88rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s;
            }

            .btn-geo {
                background: #ff6b35;
                color: #fff;
            }

            .btn-geo:hover {
                background: #e65100;
            }

            .btn-heat {
                background: #fff;
                border: 1px solid #ddd;
                color: #555;
            }

            .btn-heat.active {
                background: #ff6b35;
                color: #fff;
                border-color: #ff6b35;
            }

            /* ── Contador ── */
            .results-counter {
                padding: 0.5rem 0;
                font-size: 0.88rem;
                color: #666;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .results-counter strong {
                color: #ff6b35;
            }

            /* ── Mapa ── */
            #mapExtravios {
                height: calc(70vh - 60px);
                min-height: 420px;
                border-radius: 14px;
                box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
                position: relative;
                z-index: 1;
            }

            /* ── Leyenda flotante ── */
            .map-legend {
                position: absolute;
                bottom: 16px;
                left: 16px;
                z-index: 1000;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(8px);
                border-radius: 10px;
                padding: 10px 16px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.12);
                display: flex;
                gap: 16px;
                align-items: center;
                font-size: 0.82rem;
            }

            .legend-dot {
                width: 12px;
                height: 12px;
                border-radius: 50%;
                display: inline-block;
                margin-right: 5px;
            }

            .legend-dot.lost {
                background: #e74c3c;
            }

            .legend-dot.found {
                background: #27ae60;
            }

            /* ── Sin marcadores ── */
            .pnl-no-markers {
                display: none;
                text-align: center;
                padding: 1.25rem;
                background: linear-gradient(135deg, #fff3cd 0%, #ffeeba 100%);
                border-radius: 10px;
                margin-top: 0.5rem;
                font-size: 0.88rem;
                color: #856404;
            }

            /* ── Mini lista recientes ── */
            .recent-section {
                margin-top: 2rem;
            }

            .recent-section h2 {
                font-size: 1.2rem;
                margin-bottom: 1rem;
                color: #222;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .recent-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 1rem;
            }

            .recent-card {
                background: #fff;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.07);
                display: flex;
                transition: transform 0.2s, box-shadow 0.2s;
                cursor: pointer;
                text-decoration: none;
                color: inherit;
            }

            .recent-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
            }

            .recent-card-img {
                width: 100px;
                min-height: 100px;
                object-fit: cover;
                background: #f0f0f0;
                flex-shrink: 0;
            }

            .recent-card-body {
                padding: 0.8rem 1rem;
                flex: 1;
                display: flex;
                flex-direction: column;
                gap: 4px;
            }

            .recent-card-title {
                font-weight: 700;
                font-size: 0.95rem;
                color: #222;
            }

            .recent-card-meta {
                font-size: 0.82rem;
                color: #888;
            }

            .recent-tipo-badge {
                display: inline-block;
                padding: 2px 10px;
                border-radius: 10px;
                font-size: 0.72rem;
                font-weight: 700;
            }

            .badge-perdida {
                background: #fde8e8;
                color: #c0392b;
            }

            .badge-encontrada {
                background: #e8f8ef;
                color: #1e8449;
            }

            /* ── CTA flotante ── */
            .cta-float {
                position: fixed;
                bottom: 28px;
                right: 28px;
                z-index: 9999;
                background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
                color: #fff;
                padding: 14px 24px;
                border-radius: 50px;
                text-decoration: none;
                font-weight: 700;
                font-size: 0.95rem;
                box-shadow: 0 4px 20px rgba(39, 174, 96, 0.4);
                display: flex;
                align-items: center;
                gap: 8px;
                transition: transform 0.2s, box-shadow 0.2s;
            }

            .cta-float:hover {
                transform: translateY(-2px) scale(1.03);
                box-shadow: 0 6px 28px rgba(39, 174, 96, 0.5);
            }

            /* ── Panel sin reportes ── */
            .empty-panel {
                text-align: center;
                padding: 2rem;
                color: #888;
            }

            /* ── Stats compactos ── */
            .stats-inline {
                display: flex;
                gap: 1.5rem;
                align-items: center;
            }

            .stat-pill {
                display: flex;
                align-items: center;
                gap: 6px;
                font-size: 0.85rem;
                font-weight: 600;
            }

            .stat-pill .num {
                font-size: 1.1rem;
            }

            .stat-pill.lost .num {
                color: #e74c3c;
            }

            .stat-pill.found .num {
                color: #27ae60;
            }

            /* ── Mapapositioning ── */
            .map-wrapper {
                position: relative;
            }

            @media (max-width: 768px) {
                #mapExtravios {
                    height: 55vh;
                    min-height: 320px;
                }

                .filters-bar {
                    padding: 0.75rem;
                }

                .search-input {
                    min-width: 100%;
                }

                .cta-float {
                    bottom: 16px;
                    right: 16px;
                    padding: 12px 18px;
                    font-size: 0.88rem;
                }

                .recent-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

        <div class="mapa-page">
            <h1 class="page-title">Mapa de <span>Extravíos</span> y <span>Encuentros</span></h1>

            <!-- ══ Filtros ══ -->
            <div class="filters-bar">
                <div class="filter-group">
                    <label>Tipo</label>
                    <asp:DropDownList ID="ddlFiltroTipo" runat="server" CssClass="filter-control" AutoPostBack="false"
                        onchange="aplicarFiltros()">
                        <asp:ListItem Value="todos" Text="Todos" Selected="True" />
                        <asp:ListItem Value="Perdida" Text="Perdidas" />
                        <asp:ListItem Value="Encontrada" Text="Encontradas" />
                    </asp:DropDownList>
                </div>

                <div class="filter-group">
                    <label>Fecha</label>
                    <select id="ddlFiltroFecha" class="filter-control" onchange="aplicarFiltros()">
                        <option value="todos">Siempre</option>
                        <option value="hoy">Hoy</option>
                        <option value="semana">Esta semana</option>
                        <option value="mes">Este mes</option>
                    </select>
                </div>

                <div class="filter-group">
                    <label>Especie</label>
                    <select id="ddlFiltroEspecie" class="filter-control" onchange="aplicarFiltros()">
                        <option value="todos">Todas</option>
                        <option value="Perro">Perro</option>
                        <option value="Gato">Gato</option>
                        <option value="otro">Otro</option>
                    </select>
                </div>

                <div class="filter-group" style="flex:1; min-width:180px;">
                    <label>Buscar ubicación</label>
                    <input type="text" id="txtBuscarUbicacion" class="search-input"
                        placeholder="Ej. Parque La Carolina, Quito"
                        onkeydown="if(event.key==='Enter'){event.preventDefault();buscarUbicacion();}" />
                </div>

                <div class="filter-group" style="flex-direction:row; gap:6px; align-items:flex-end;">
                    <button type="button" id="btnCercaDeMi" class="btn-icon btn-geo" onclick="buscarCercaDeMi()">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2">
                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
                            <circle cx="12" cy="10" r="3" />
                        </svg>
                        Cerca de mí
                    </button>
                </div>

                <div class="filter-group" id="divRadio" style="display:none;">
                    <label>Radio</label>
                    <select id="ddlRadio" class="filter-control" onchange="filtrarPorRadio()" style="min-width:90px;">
                        <option value="3">3 km</option>
                        <option value="5" selected>5 km</option>
                        <option value="10">10 km</option>
                        <option value="0">Todos</option>
                    </select>
                </div>

                <div style="margin-left:auto; display:flex; gap:6px; align-items:flex-end;">
                    <button type="button" id="btnHeatmap" class="btn-icon btn-heat" onclick="toggleHeatmap()">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2">
                            <path
                                d="M12 2c-5.33 4.55-8 8.48-8 11.8 0 4.98 3.8 8.2 8 8.2s8-3.22 8-8.2c0-3.32-2.67-7.25-8-11.8z" />
                        </svg>
                        Calor
                    </button>
                </div>
            </div>

            <!-- ══ Stats + Contador ══ -->
            <div class="results-counter">
                <div class="stats-inline">
                    <div class="stat-pill lost">
                        <span class="legend-dot lost"></span>
                        <span class="num">
                            <asp:Literal ID="litPerdidas" runat="server">0</asp:Literal>
                        </span>
                        <span>perdidas</span>
                    </div>
                    <div class="stat-pill found">
                        <span class="legend-dot found"></span>
                        <span class="num">
                            <asp:Literal ID="litEncontradas" runat="server">0</asp:Literal>
                        </span>
                        <span>encontradas</span>
                    </div>
                </div>
                <span style="margin-left:auto;" id="spanContador">Cargando mapa...</span>
            </div>

            <!-- ══ Mapa ══ -->
            <div class="map-wrapper">
                <div id="mapExtravios"></div>
                <!-- Leyenda flotante -->
                <div class="map-legend">
                    <span><span class="legend-dot lost"></span> Perdida</span>
                    <span><span class="legend-dot found"></span> Encontrada</span>
                </div>
            </div>

            <!-- Sin marcadores -->
            <div id="pnlSinMarcadores" class="pnl-no-markers">
                No hay mascotas con ubicación GPS para mostrar. Los reportes sin coordenadas aparecen abajo.
            </div>

            <!-- ══ Mini lista recientes ══ -->
            <div class="recent-section">
                <h2>
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10" />
                        <polyline points="12 6 12 12 16 14" />
                    </svg>
                    Reportes Recientes
                </h2>

                <asp:Panel ID="pnlSinReportes" runat="server" Visible="false">
                    <div class="empty-panel">
                        <p>No hay reportes publicados aún. ¿Perdiste o encontraste una mascota?</p>
                        <a href="Reportar.aspx" style="color:#ff6b35; font-weight:600;">Publicar reporte →</a>
                    </div>
                </asp:Panel>

                <div class="recent-grid">
                    <asp:Repeater ID="rptListaReportes" runat="server">
                        <ItemTemplate>
                            <a class="recent-card" href='DetalleReporte.aspx?id=<%# Eval("Id") %>'>
                                <img class="recent-card-img"
                                    src='<%# !string.IsNullOrEmpty(Eval("FotoPrincipal").ToString()) ? ResolveUrl(Eval("FotoPrincipal").ToString()) : ResolveUrl("~/Images/Default/default-pet.png") %>'
                                    onerror="this.src='/Images/Default/default-pet.png'" />
                                <div class="recent-card-body">
                                    <div style="display:flex; justify-content:space-between; align-items:center;">
                                        <span class="recent-card-title">
                                            <%# System.Web.HttpUtility.HtmlEncode(Eval("Nombre").ToString()) %>
                                        </span>
                                        <span
                                            class='recent-tipo-badge <%# Eval("Tipo").ToString()=="Perdida" ? "badge-perdida" : "badge-encontrada" %>'>
                                            <%# Eval("Tipo").ToString()=="Perdida" ? "PERDIDA" : "ENCONTRADA" %>
                                        </span>
                                    </div>
                                    <span class="recent-card-meta">
                                        <%# System.Web.HttpUtility.HtmlEncode(Eval("Especie").ToString()) %>
                                    </span>
                                    <span class="recent-card-meta">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2" style="vertical-align:-2px;">
                                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
                                            <circle cx="12" cy="10" r="3" />
                                        </svg>
                                        <%# System.Web.HttpUtility.HtmlEncode(Eval("Ubicacion").ToString()) %>
                                    </span>
                                    <span class="recent-card-meta">
                                        <%# Eval("Fecha") %>
                                    </span>
                                </div>
                            </a>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>

        <!-- ══ CTA Flotante ══ -->
        <a href="Reportar.aspx" class="cta-float">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <line x1="12" y1="5" x2="12" y2="19" />
                <line x1="5" y1="12" x2="19" y2="12" />
            </svg>
            Reportar Mascota
        </a>

        <!-- HiddenField JSON -->
        <asp:HiddenField ID="hfReportesJson" runat="server" />

        <!-- ══ Scripts ══ -->
        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        <script src='<%= ResolveUrl("~/Js/mapas-reportes.js") %>'></script>
        <script type="text/javascript">
            var map, marcadores = [], reportesData = [];
            var heatmapLayer = null, heatmapActivo = false, miUbicacion = null;

            document.addEventListener('DOMContentLoaded', function () {
                map = L.map('mapExtravios').setView([-0.1807, -78.4678], 12);
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '&copy; OpenStreetMap'
                }).addTo(map);

                var jsonData = document.getElementById('<%= hfReportesJson.ClientID %>').value;
                if (jsonData && jsonData.trim() !== '' && jsonData !== '[]') {
                    reportesData = JSON.parse(jsonData);
                    cargarMarcadores(reportesData);
                }

                actualizarContador();
                if (marcadores.length === 0) {
                    document.getElementById('pnlSinMarcadores').style.display = 'block';
                }
            });

            function resolveUrl(tilde) {
                if (!tilde) return '';
                return tilde.replace('~/', '<%= ResolveUrl("~/") %>');
            }

            function cargarMarcadores(reportes) {
                marcadores.forEach(function (m) { map.removeLayer(m); });
                marcadores = [];

                reportes.forEach(function (r) {
                    if (!r.Latitud || !r.Longitud) return;

                    var esPerdida = r.Tipo === 'Perdida';
                    var icon = L.divIcon({
                        className: 'custom-marker',
                        html: '<div style="background:' + (esPerdida ? '#e74c3c' : '#27ae60') +
                            ';width:34px;height:34px;border-radius:50%;display:flex;align-items:center;' +
                            'justify-content:center;color:#fff;font-size:16px;font-weight:700;' +
                            'box-shadow:0 2px 8px rgba(0,0,0,0.35);border:2px solid #fff;">' +
                            (esPerdida ? '😿' : '🐾') + '</div>',
                        iconSize: [34, 34], iconAnchor: [17, 17], popupAnchor: [0, -17]
                    });

                    var fotoHtml = '<img src="' + (r.FotoPrincipal ? resolveUrl(r.FotoPrincipal) : resolveUrl('~/Images/Default/default-pet.png')) + '" ' +
                        'style="width:100%;height:120px;object-fit:cover;border-radius:8px;margin-bottom:8px;" ' +
                        'onerror="this.src=\'' + resolveUrl('~/Images/Default/default-pet.png') + '\'" />';

                    var popup =
                        '<div style="min-width:240px;max-width:280px;font-family:Inter,sans-serif;">' +
                        fotoHtml +
                        '<h4 style="margin:0 0 6px;color:' + (esPerdida ? '#c0392b' : '#1e8449') + ';">' +
                        (esPerdida ? '🔴 PERDIDA' : '🟢 ENCONTRADA') + '</h4>' +
                        '<p style="margin:0 0 3px;font-size:0.92rem;"><strong>' + (r.Nombre || 'Sin nombre') + '</strong></p>' +
                        (r.Especie ? '<p style="margin:0 0 3px;font-size:0.82rem;color:#666;">🐾 ' + r.Especie + '</p>' : '') +
                        '<p style="margin:0 0 3px;font-size:0.82rem;color:#666;">📍 ' + (r.Ubicacion || '-') + '</p>' +
                        '<p style="margin:0 0 8px;font-size:0.82rem;color:#888;">📅 ' + (r.Fecha || '-') + '</p>' +
                        '<a href="DetalleReporte.aspx?id=' + r.Id + '" ' +
                        'style="display:block;background:#ff6b35;color:#fff;text-align:center;' +
                        'padding:8px;border-radius:8px;text-decoration:none;font-weight:600;font-size:0.9rem;">Ver Detalle →</a></div>';

                    var marker = L.marker([r.Latitud, r.Longitud], { icon: icon }).bindPopup(popup);
                    marker.tipoReporte = r.Tipo;
                    marker.especie = r.Especie || '';
                    marker.latLng = [r.Latitud, r.Longitud];
                    marker.fechaISO = r.FechaISO ? new Date(r.FechaISO) : new Date();
                    marcadores.push(marker);
                    marker.addTo(map);
                });

                if (marcadores.length > 0) {
                    var group = new L.featureGroup(marcadores);
                    map.fitBounds(group.getBounds().pad(0.1));
                }
                if (heatmapActivo) actualizarHeatmap();
            }

            function aplicarFiltros() {
                var fTipo = document.getElementById('<%= ddlFiltroTipo.ClientID %>').value;
                var fFecha = document.getElementById('ddlFiltroFecha').value;
                var fEspecie = document.getElementById('ddlFiltroEspecie').value;
                var ahora = new Date();
                var visibles = 0;

                marcadores.forEach(function (m) {
                    var ok = true;
                    if (fTipo !== 'todos' && m.tipoReporte !== fTipo) ok = false;
                    if (ok && fEspecie !== 'todos') {
                        if (fEspecie === 'otro') {
                            if (m.especie === 'Perro' || m.especie === 'Gato') ok = false;
                        } else if (m.especie !== fEspecie) ok = false;
                    }
                    if (ok && fFecha !== 'todos') {
                        var diff = (ahora - m.fechaISO) / (1000 * 60 * 60 * 24);
                        if (fFecha === 'hoy' && diff > 1) ok = false;
                        if (fFecha === 'semana' && diff > 7) ok = false;
                        if (fFecha === 'mes' && diff > 30) ok = false;
                    }
                    if (ok) { if (!map.hasLayer(m)) m.addTo(map); visibles++; }
                    else { map.removeLayer(m); }
                });

                actualizarContador();
                if (heatmapActivo) actualizarHeatmap();
            }

            function actualizarContador() {
                var vis = marcadores.filter(function (m) { return map.hasLayer(m); }).length;
                var txt = 'Mostrando <strong>' + vis + '</strong> mascota' + (vis !== 1 ? 's' : '') + ' en el mapa';
                document.getElementById('spanContador').innerHTML = txt;
            }

            // ── Búsqueda por ubicación ──
            function buscarUbicacion() {
                var q = document.getElementById('txtBuscarUbicacion').value.trim();
                if (!q) return;
                fetch('https://nominatim.openstreetmap.org/search?format=json&q=' + encodeURIComponent(q) + '&limit=1&accept-language=es')
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        if (data.length > 0) {
                            var lat = parseFloat(data[0].lat), lng = parseFloat(data[0].lon);
                            map.setView([lat, lng], 14);
                        } else {
                            Swal.fire({ icon: 'info', title: 'No encontrado', text: 'No se encontró esa ubicación. Intenta con otro término.' });
                        }
                    }).catch(function () {
                        Swal.fire({ icon: 'error', title: 'Error', text: 'No se pudo buscar la ubicación.' });
                    });
            }

            // ── Geolocalización ──
            function buscarCercaDeMi() {
                if (!navigator.geolocation) {
                    Swal.fire({ icon: 'error', title: 'No disponible', text: 'Tu navegador no soporta geolocalización.' });
                    return;
                }
                var btn = document.getElementById('btnCercaDeMi');
                btn.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg> Ubicando...';
                btn.disabled = true;

                navigator.geolocation.getCurrentPosition(function (pos) {
                    miUbicacion = { lat: pos.coords.latitude, lng: pos.coords.longitude };
                    btn.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg> ✓ Ubicado';
                    btn.disabled = false;
                    document.getElementById('divRadio').style.display = '';

                    if (map._miPos) map.removeLayer(map._miPos);
                    map._miPos = L.circleMarker([miUbicacion.lat, miUbicacion.lng], {
                        radius: 10, fillColor: '#ff6b35', color: '#fff', weight: 3, fillOpacity: 0.9
                    }).bindPopup('<strong>📍 Tu ubicación</strong>').addTo(map);
                    map.setView([miUbicacion.lat, miUbicacion.lng], 14);
                    filtrarPorRadio();
                }, function () {
                    btn.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg> Cerca de mí';
                    btn.disabled = false;
                    Swal.fire({ icon: 'warning', title: 'Sin acceso', text: 'Permite el acceso a tu ubicación para usar esta función.' });
                });
            }

            function filtrarPorRadio() {
                if (!miUbicacion) return;
                var radio = parseFloat(document.getElementById('ddlRadio').value);
                marcadores.forEach(function (m) {
                    if (radio === 0) { m.addTo(map); return; }
                    var dist = MapaReportes.haversineKm(miUbicacion.lat, miUbicacion.lng, m.latLng[0], m.latLng[1]);
                    if (dist <= radio) { if (!map.hasLayer(m)) m.addTo(map); }
                    else { map.removeLayer(m); }
                });
                actualizarContador();
            }

            // ── Heatmap ──
            function toggleHeatmap() {
                heatmapActivo = !heatmapActivo;
                var btn = document.getElementById('btnHeatmap');
                btn.classList.toggle('active', heatmapActivo);
                if (heatmapActivo) actualizarHeatmap();
                else if (heatmapLayer) { map.removeLayer(heatmapLayer); heatmapLayer = null; }
            }

            function actualizarHeatmap() {
                if (heatmapLayer) { map.removeLayer(heatmapLayer); heatmapLayer = null; }
                if (!heatmapActivo) return;
                var grupo = L.layerGroup();
                marcadores.filter(function (m) { return map.hasLayer(m); })
                    .forEach(function (m) {
                        var c = m.tipoReporte === 'Perdida' ? '#e74c3c' : '#27ae60';
                        L.circle(m.latLng, { radius: 400, fillColor: c, fillOpacity: 0.15, color: c, weight: 0 }).addTo(grupo);
                    });
                heatmapLayer = grupo;
                grupo.addTo(map);
            }
        </script>
    </asp:Content>