/**
 * mapas-reportes.js
 * Funciones reutilizables para mapas de reportes RedPatitas
 * Requiere: Leaflet 1.9.4
 */

var MapaReportes = (function () {

    /**
     * Inicializa un mapa Leaflet sobre un elemento HTML dado
     * @param {string} elementId  - ID del div contenedor
     * @param {number} zoom       - Zoom inicial (default 12)
     * @returns {L.Map}
     */
    function inicializarMapa(elementId, zoom) {
        var mapa = L.map(elementId).setView([-0.1807, -78.4678], zoom || 12);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap'
        }).addTo(mapa);
        return mapa;
    }

    /**
     * Crea un icono personalizado emoji para un reporte
     * @param {string} tipo - "Perdida" | "Encontrada"
     * @returns {L.DivIcon}
     */
    function crearIcono(tipo) {
        var esPerdida = tipo === 'Perdida';
        return L.divIcon({
            className: 'custom-marker-reportes',
            html: '<div style="background:' + (esPerdida ? '#e74c3c' : '#27ae60') +
                ';width:32px;height:32px;border-radius:50%;display:flex;align-items:center;' +
                'justify-content:center;color:white;font-size:16px;' +
                'box-shadow:0 2px 8px rgba(0,0,0,0.35);">' +
                (esPerdida ? '😿' : '🐾') + '</div>',
            iconSize: [32, 32],
            iconAnchor: [16, 16],
            popupAnchor: [0, -16]
        });
    }

    /**
     * Crea HTML del popup para un marker de reporte
     * @param {Object} reporte - { Id, Tipo, Nombre, Descripcion, Ubicacion, Fecha }
     * @returns {string}
     */
    function crearPopupHtml(reporte) {
        var esPerdida = reporte.Tipo === 'Perdida';
        return '<div style="min-width:220px;font-family:Inter,sans-serif;">' +
            '<h4 style="margin:0 0 8px;color:' + (esPerdida ? '#c0392b' : '#1e8449') + ';">' +
            (esPerdida ? '🔴 PERDIDA' : '🟢 ENCONTRADA') + '</h4>' +
            '<p style="margin:0 0 4px;"><strong>Mascota:</strong> ' + (reporte.Nombre || 'Sin nombre') + '</p>' +
            '<p style="margin:0 0 4px;"><strong>Ubicación:</strong> ' + (reporte.Ubicacion || '-') + '</p>' +
            '<p style="margin:0 0 8px;"><strong>Fecha:</strong> ' + (reporte.Fecha || '-') + '</p>' +
            '<a href="DetalleReporte.aspx?id=' + reporte.Id + '" ' +
            'style="display:block;background:#1a73e8;color:#fff;text-align:center;' +
            'padding:6px;border-radius:6px;text-decoration:none;font-weight:600;">' +
            'Ver detalle →</a>' +
            '</div>';
    }

    /**
     * Fórmula Haversine — distancia en km entre dos pares de coordenadas
     * @returns {number} Distancia en kilómetros
     */
    function haversineKm(lat1, lng1, lat2, lng2) {
        var R = 6371;
        var dLat = (lat2 - lat1) * Math.PI / 180;
        var dLng = (lng2 - lng1) * Math.PI / 180;
        var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
            Math.sin(dLng / 2) * Math.sin(dLng / 2);
        return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    }

    /**
     * Agrega un círculo semitransparente de "heatmap" sobre cada marker visible
     * @param {L.Map}   map       - El mapa Leaflet
     * @param {Array}   markers   - Array de L.Marker con propiedad .tipoReporte y .latLng
     * @returns {L.LayerGroup}    - El layer group creado (para poder eliminarlo luego)
     */
    function dibujarHeatmap(map, markers) {
        var grupo = L.layerGroup();
        markers.filter(function (m) { return map.hasLayer(m); })
            .forEach(function (marker) {
                var color = marker.tipoReporte === 'Perdida' ? '#e74c3c' : '#27ae60';
                L.circle(marker.latLng, {
                    radius: 400, fillColor: color,
                    fillOpacity: 0.15, color: color, weight: 0
                }).addTo(grupo);
            });
        grupo.addTo(map);
        return grupo;
    }

    /**
     * Geocodificación inversa usando Nominatim (OSM, sin API key)
     * @param {number}   lat      - Latitud
     * @param {number}   lng      - Longitud
     * @param {Function} callback - fn({ display_name, road, city, town, village, state })
     */
    function geocodificacionInversa(lat, lng, callback) {
        var url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=' +
            lat + '&lon=' + lng + '&accept-language=es';
        fetch(url, { headers: { 'Accept-Language': 'es' } })
            .then(function (resp) { return resp.json(); })
            .then(function (data) {
                var addr = data.address || {};
                callback({
                    display_name: data.display_name || '',
                    road: addr.road || addr.pedestrian || addr.footway || '',
                    city: addr.city || addr.town || addr.village || addr.county || '',
                    state: addr.state || '',
                    suburb: addr.suburb || addr.neighbourhood || ''
                });
            })
            .catch(function () { callback(null); });
    }

    // ----------- API pública -----------
    return {
        inicializarMapa: inicializarMapa,
        crearIcono: crearIcono,
        crearPopupHtml: crearPopupHtml,
        haversineKm: haversineKm,
        dibujarHeatmap: dibujarHeatmap,
        geocodificacionInversa: geocodificacionInversa
    };
})();
