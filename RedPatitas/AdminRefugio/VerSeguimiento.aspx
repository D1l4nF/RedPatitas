<%@ Page Title="Auditoría de Seguimiento" Language="C#" MasterPageFile="~/AdminRefugio/AdminRefugio.Master"
    AutoEventWireup="true" CodeBehind="VerSeguimiento.aspx.cs" Inherits="RedPatitas.AdminRefugio.VerSeguimiento" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Auditoría de Seguimiento | Panel Refugio
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">🔍 Auditoría de Seguimiento GPS</h1>
            <div class="breadcrumb">Panel del Refugio > Adopciones > Ver Reporte</div>
        </div>
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

        <!-- CSS DE LEAFLET PARA EL MAPA -->
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />

        <style>
            .auditoria-container {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 25px;
                max-width: 1200px;
                margin: 0 auto;
            }

            .panel-evidencia,
            .panel-evaluacion {
                background: #fff;
                border-radius: 12px;
                padding: 25px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            }

            .section-title {
                color: var(--secondary-color);
                border-bottom: 2px solid #eee;
                padding-bottom: 10px;
                margin-bottom: 20px;
                font-size: 1.2rem;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            /* ----- FOTO EN VIVO ----- */
            .foto-container {
                width: 100%;
                height: 350px;
                border-radius: 8px;
                overflow: hidden;
                background: #f5f5f5;
                display: flex;
                align-items: center;
                justify-content: center;
                border: 2px solid #ddd;
                margin-bottom: 20px;
            }

            .foto-container img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                cursor: pointer;
                transition: transform 0.3s;
            }

            .foto-container img:hover {
                transform: scale(1.02);
            }

            /* ----- MAPA GPS ----- */
            #mapa-gps {
                width: 100%;
                height: 300px;
                border-radius: 8px;
                border: 2px solid var(--primary-color);
            }

            /* ----- RESULTADOS (ETIQUETAS DINÁMICAS) ----- */
            .respuesta-item {
                background: #f9f9f9;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 10px;
                border-left: 4px solid var(--primary-color);
            }

            .respuesta-pregunta {
                font-size: 0.9rem;
                color: #666;
                margin-bottom: 5px;
                font-weight: bold;
            }

            .respuesta-valor {
                font-size: 1.1rem;
                color: var(--secondary-color);
            }

            /* ----- BOTONES DE DECISIÓN ----- */
            .botones-accion {
                display: flex;
                gap: 15px;
                margin-top: 30px;
                justify-content: flex-end;
                padding-top: 20px;
                border-top: 1px solid #eee;
            }

            .btn-aprobar {
                background: var(--success);
                color: white;
                padding: 12px 25px;
                border-radius: 6px;
                border: none;
                font-weight: bold;
                cursor: pointer;
            }

            .btn-rechazar {
                background: var(--warning);
                color: white;
                padding: 12px 25px;
                border-radius: 6px;
                border: none;
                font-weight: bold;
                cursor: pointer;
            }

            .btn-sos {
                background: var(--error);
                color: white;
                padding: 12px 25px;
                border-radius: 6px;
                border: none;
                font-weight: bold;
                cursor: pointer;
            }

            /* Responsive: apilar en celulares */
            @media (max-width: 768px) {
                .auditoria-container {
                    grid-template-columns: 1fr;
                }

                .botones-accion {
                    flex-direction: column;
                }
            }
        </style>

        <div class="auditoria-container">

            <!-- PANEL IZQUIERDO: EVIDENCIAS FÍSICAS -->
            <div class="panel-evidencia">
                <h2 class="section-title">📸 Evidencia Física y Satelital</h2>

                <!-- Etiqueta oculta para que C# pase las coordenadas a JavaScript -->
                <asp:HiddenField ID="hfLatitudGPS" runat="server" />
                <asp:HiddenField ID="hfLongitudGPS" runat="server" />

                <!-- Foto Tomada -->
                <div class="foto-container" onclick="abrirFotoGrande()">
                    <asp:Image ID="imgEvidenciaEnVivo" runat="server" AlternateText="Foto de Seguimiento" />
                </div>

                <!-- Botón descargar PDF/Cartilla (Si aplica, oculto por defecto) -->
                <asp:Panel ID="pnlDescargaObligatoria" runat="server" Visible="false" style="margin-bottom: 20px;">
                    <asp:HyperLink ID="lnkDescargarEvidenciaExtra" runat="server" CssClass="btn-link" Target="_blank"
                        style="display:inline-block; padding:10px; background:#e3f2fd; border-radius:6px;">
                        📄 Ver Cartilla de Vacunación Adjunta
                    </asp:HyperLink>
                </asp:Panel>

                <h3 style="margin: 15px 0 10px 0; font-size:1rem;">📍 Ubicación GPS al momento de la captura:</h3>
                <!-- El Mapa de Leaflet -->
                <div id="mapa-gps"></div>

            </div>

            <!-- PANEL DERECHO: FORMULARIO Y DECISIÓN -->
            <div class="panel-evaluacion">
                <h2 class="section-title" id="lblEtapaTitulo" runat="server">📋 Cuestionario - (Etapa)</h2>

                <p style="color:#777; margin-bottom:20px;">El sistema ha extraído las siguientes respuestas del usuario:
                </p>

                <!-- Aquí el DataList repetirá como un bucle el Diccionario que armamos en el CodeBehind (C#) -->
                <asp:Repeater ID="rpRespuestasDinamicas" runat="server">
                    <ItemTemplate>
                        <div class="respuesta-item">
                            <div class="respuesta-pregunta">
                                <%# Eval("Key") %>
                            </div>
                            <div class="respuesta-valor">
                                <strong>
                                    <%# Eval("Value") %>
                                </strong>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <div class="form-group" style="margin-top: 30px;">
                    <label>Comentarios de Auditoría (Privados para el refugio) <span class="required">*</span></label>
                    <asp:TextBox ID="txtComentariosRevisor" runat="server" TextMode="MultiLine" Rows="4"
                        CssClass="form-control"
                        placeholder="Escriba aquí los motivos si rechaza, o sus anotaciones de conformidad." />
                </div>

                <!-- BOTONES -->
                <div class="botones-accion">
                    <asp:Button ID="btnAlertaMaltrato" runat="server" Text="🚨 Revocar / Lista Negra" CssClass="btn-sos"
                        OnClick="btnAlertaMaltrato_Click" OnClientClick="return confirmarDecomiso();" />

                    <asp:Button ID="btnRechazar" runat="server" Text="⚠️ Rechazar y Pedir que Repita"
                        CssClass="btn-rechazar" OnClick="btnRechazar_Click" />

                    <asp:Button ID="btnAprobar" runat="server" Text="✅ Aprobar Seguimiento" CssClass="btn-aprobar"
                        OnClick="btnAprobar_Click" />
                </div>
            </div>

        </div>

        <!-- SCRIPT DEL MAPA Y SWEETALERT -->
        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {

                // 1. Obtener coordenadas incrustadas por C# usando los campos ocultos
                var latStr = document.getElementById('<%= hfLatitudGPS.ClientID %>').value;
                var lonStr = document.getElementById('<%= hfLongitudGPS.ClientID %>').value;

                // Arreglar casos donde C# traiga comas en lugar de puntos (1.0 vs 1,0)
                latStr = latStr.replace(',', '.');
                lonStr = lonStr.replace(',', '.');

                var lat = parseFloat(latStr);
                var lon = parseFloat(lonStr);

                // 2. Iniciar el mapa centrado en las coordenadas del Adoptante
                if (!isNaN(lat) && !isNaN(lon)) {
                    var map = L.map('mapa-gps').setView([lat, lon], 15);

                    // Capa satelital gratuita de OpenStreetMap
                    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                        maxZoom: 19,
                        attribution: '© RedPatitas OpenStreetMap'
                    }).addTo(map);

                    // Colocar el Ping Rojo donde se tomó la foto 📸
                    var IconoRojo = L.icon({
                        iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png',
                        shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
                        iconSize: [25, 41],
                        iconAnchor: [12, 41],
                        popupAnchor: [1, -34],
                        shadowSize: [41, 41]
                    });

                    L.marker([lat, lon], { icon: IconoRojo }).addTo(map)
                        .bindPopup("<b>📍 Captura Realizada Aquí</b>")
                        .openPopup();
                } else {
                    document.getElementById('mapa-gps').innerHTML = "<br><br><center style='color:red;'>⚠️ Error: El reporte no cuenta con coordenadas válidas.</center>";
                }
            });

            // 3. Confirmación Segura antes de Decomisar a una familia
            function confirmarDecomiso() {
                var comentario = document.getElementById('<%= txtComentariosRevisor.ClientID %>').value;
                if (comentario === "") {
                    Swal.fire('Comentario Obligatorio', 'Debes escribir el motivo exacto del decomiso o maltrato antes de aplicar la Lista Negra.', 'error');
                    return false;
                }

                Swal.fire({
                    title: '¿Revocar Adopción Definitivamente?',
                    text: "Estás a punto de anular el contrato de adopción. La cuenta del adoptante quedará BOQUEADA en el sistema por maltrato. Esta acción requiere recuperar el animal físicamente.",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#E74C3C',
                    cancelButtonColor: '#95a5a6',
                    confirmButtonText: 'Sí, aplicar Revocación Física',
                    cancelButtonText: 'Cancelar'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Simular click en el botón invisible para saltar el prompt
                        __doPostBack('<%= btnAlertaMaltrato.UniqueID %>', '');
                    }
                })

                return false; // Pausamos el PostBack automático para dejar que SweetAlert2 decida arriba
            }

            // 4. Mostrar foto en grande si el Admin quiere inspeccionarla
            function abrirFotoGrande() {
                var imagenSrc = document.getElementById('<%= imgEvidenciaEnVivo.ClientID %>').src;
                Swal.fire({
                    imageUrl: imagenSrc,
                    imageAlt: 'Reporte Fotográfico',
                    width: 800,
                    padding: '3em',
                    background: '#fff',
                    showConfirmButton: false,
                    html: '<i>Cerrar tocando fuera de la imagen</i>'
                })
            }
        </script>
    </asp:Content>