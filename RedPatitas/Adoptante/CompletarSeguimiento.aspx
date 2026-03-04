<%@ Page Title="Completar Seguimiento" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master"
    AutoEventWireup="true" CodeBehind="CompletarSeguimiento.aspx.cs"
    Inherits="RedPatitas.Adoptante.CompletarSeguimiento" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Completar Seguimiento | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">📸 Reporte de Seguimiento en Vivo</h1>
            <div class="breadcrumb">Mis Mascotas > Seguimiento Post-Adopción</div>
        </div>
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

        <!-- Estilos exclusivos de esta página (Formulario Dinámico y Cámara) -->
        <style>
            .seguimiento-container {
                max-width: 800px;
                margin: 0 auto;
                background: #fff;
                border-radius: 12px;
                padding: 30px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            }

            .etapa-header {
                text-align: center;
                margin-bottom: 25px;
                padding-bottom: 15px;
                border-bottom: 2px solid var(--primary-color);
            }

            /* ----- ESTILOS DE LA SECCIÓN DE CÁMARA ----- */
            .camera-section {
                background: #fdf5e6;
                border: 2px dashed var(--primary-color);
                border-radius: 10px;
                padding: 20px;
                text-align: center;
                margin-bottom: 30px;
            }

            .camera-title {
                color: var(--secondary-color);
                margin-bottom: 10px;
                font-size: 1.2rem;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }

            /* Botón gigante de cámara */
            .btn-camera {
                background: var(--primary-color);
                color: white;
                padding: 15px 30px;
                border-radius: 50px;
                font-size: 1.1rem;
                font-weight: bold;
                display: inline-flex;
                align-items: center;
                gap: 10px;
                cursor: pointer;
                transition: all 0.3s;
                border: none;
                position: relative;
                overflow: hidden;
            }

            .btn-camera:hover {
                background: var(--primary-hover);
                transform: scale(1.05);
            }

            /* Ocultar el Input real de Archivo sobre el botón para que sea clickeable */
            .hidden-file-input {
                position: absolute;
                left: 0;
                top: 0;
                opacity: 0;
                width: 100%;
                height: 100%;
                cursor: pointer;
            }

            /* Preview de la foto tomada */
            .photo-preview {
                margin-top: 15px;
                display: none;
                /* Se activa con JS */
                flex-direction: column;
                align-items: center;
            }

            .photo-preview img {
                max-width: 100%;
                max-height: 300px;
                border-radius: 8px;
                border: 3px solid var(--success);
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            }

            /* ----- GEO ESTATUS ----- */
            .geo-status {
                margin-top: 15px;
                padding: 10px;
                border-radius: 6px;
                background: #e8f5e9;
                color: #2e7d32;
                font-weight: bold;
                display: none;
                /* Se activa con JS al obtener GPS */
                align-items: center;
                justify-content: center;
                gap: 8px;
            }
        </style>

        <div class="seguimiento-container">

            <!-- TÍTULO DINÁMICO (C# lo cambiará según si es la etapa 1 o 4) -->
            <div class="etapa-header">
                <h2 id="lblTituloEtapa" runat="server">Cargando Etapa...</h2>
                <p>Por políticas de adopción, necesitamos evidencia fotográfica en tiempo real para constatar el
                    bienestar del animal.</p>
            </div>

            <!-- HIDDEN FIELDS: Aquí JS guardará la latitud y longitud antes del PostBack -->
            <asp:HiddenField ID="hfLatitud" runat="server" />
            <asp:HiddenField ID="hfLongitud" runat="server" />

            <!--  SECCIÓN I: La Foto Obligatoria (HTML5 Capture) -->
            <div class="camera-section">
                <h3 class="camera-title">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="24" height="24">
                        <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z">
                        </path>
                        <circle cx="12" cy="13" r="4"></circle>
                    </svg>
                    Evidencia en Vivo
                </h3>
                <p class="input-hint" style="margin-bottom: 15px;">Tome una foto de su mascota en este instante. La
                    cámara registrará también su ubicación GPS.</p>

                <div class="btn-camera">
                    📸 Abrir Cámara
                    <!-- El atributo capture="environment" fuerza abrir la cámara en el teléfono, no la galería -->
                    <asp:FileUpload ID="fuFotoVivo" runat="server" CssClass="hidden-file-input" accept="image/*"
                        capture="environment" onchange="previewImage(this);" />
                </div>

                <!-- Previsualización + Mensaje de GPS -->
                <div class="photo-preview" id="divPreview">
                    <p style="color:var(--success); font-weight:bold; margin-bottom:5px;">✅ Foto Capturada</p>
                    <img id="imgPreview" src="#" alt="Previsualización" />

                    <div class="geo-status" id="divGeoStatus">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20"
                            height="20">
                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                            <circle cx="12" cy="10" r="3"></circle>
                        </svg>
                        <span>Coordenadas Guardadas Correctamente</span>
                    </div>
                </div>
            </div>


            <!-- SECCIÓN II: PREGUNTAS DINÁMICAS -->

            <!-- PANEL PARA ETAPA 1 y 2 (Adaptación y Rutina) -->
            <asp:Panel ID="pnlEtapaTemprana" runat="server" Visible="false">
                <h3 style="color:var(--secondary-color); margin-bottom:15px;">🐾 Cuestionario de Rutina</h3>

                <div class="form-group">
                    <label>¿Cómo describiría la alimentación en las últimas 72 horas? <span
                            class="required">*</span></label>
                    <asp:DropDownList ID="ddlAlimentacion" runat="server" CssClass="form-control">
                        <asp:ListItem Value="">Seleccione una opción...</asp:ListItem>
                        <asp:ListItem Value="Normal_100">Come toda su ración (100% normal)</asp:ListItem>
                        <asp:ListItem Value="Poco_Ansioso">Come poco (posible ansiedad)</asp:ListItem>
                        <asp:ListItem Value="Casi_Nada">Casi no prueba la comida</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <label>¿Ha notado alguna de estas actitudes? (Puede ser normal en los primeros días)</label>
                    <div style="display:flex; gap:15px; flex-wrap:wrap; margin-top:5px;">
                        <asp:CheckBox ID="chkAgresividad" runat="server" Text=" Agresividad/Gruñidos" />
                        <asp:CheckBox ID="chkDestruccion" runat="server" Text=" Daños en casa (rasguños, mordeduras)" />
                        <asp:CheckBox ID="chkLlantos" runat="server" Text=" Llantos constantes por la noche" />
                    </div>
                </div>

                <div class="form-group">
                    <label>Reporte de Incidencias (Opcional)</label>
                    <asp:TextBox ID="txtIncidencias" runat="server" CssClass="form-control" TextMode="MultiLine"
                        Rows="3" placeholder="Si el animal escapó, vomitó o mordió a alguien, descríbalo aquí..." />
                </div>
            </asp:Panel>

            <!-- PANEL PARA ETAPA 3 (Vacunación Exclusiva) -->
            <asp:Panel ID="pnlEtapaMedia" runat="server" Visible="false">
                <div class="info-card" style="margin-bottom: 20px;">
                    <h4 style="color: var(--warning); margin-bottom:5px;">💉 Control de Vacunación (Requisito
                        Obligatorio)</h4>
                    <p>Han pasado 3 meses. Necesitamos asegurarnos de que la mascota completó sus refuerzos.</p>
                </div>

                <div class="form-group">
                    <label>Adjuntar foto de la Cartilla Veterinaria (Firmada) <span class="required">*</span></label>
                    <!-- Aquí SÍ permitimos archivo de galería (PDF o Foto normal) -->
                    <asp:FileUpload ID="fuCartilla" runat="server" CssClass="form-control" accept="image/*,.pdf" />
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label>Fecha Última Desparasitación</label>
                        <asp:TextBox ID="txtFechaDespara" runat="server" CssClass="form-control" TextMode="Date" />
                    </div>
                    <div class="form-group">
                        <label>Nombre de Clínica Veterinaria</label>
                        <asp:TextBox ID="txtClinica" runat="server" CssClass="form-control"
                            placeholder="Ej: VetPets Sur" />
                    </div>
                </div>
            </asp:Panel>


            <div style="text-align: right; margin-top: 30px;">
                <asp:Button ID="btnEnviarEvaluacion" runat="server" Text="Finalizar y Enviar Reporte 🚀"
                    CssClass="btn-primary" OnClick="btnEnviarEvaluacion_Click"
                    OnClientClick="return validarFormularioGeolocalizado();" />
            </div>

        </div>

        <!-- SCRIPTS EXCLUSIVOS (GPS y Visor) -->
        <script>
            // 1. Mostrar la preview en vivo apenas se toma foto (Base 64 FileReader)
            function previewImage(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();

                    reader.onload = function (e) {
                        // Mostrar div oculto y setear fuente web
                        document.getElementById('divPreview').style.display = 'flex';
                        document.getElementById('imgPreview').src = e.target.result;

                        // 2. Disparar el GPS en el fondo (Pedir permiso al usuario silenciosamente)
                        obtenerCoordenadas();
                    }

                    reader.readAsDataURL(input.files[0]);
                }
            }

            // 3. Sistema de Geoposicionamiento Nativo
            function obtenerCoordenadas() {
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(
                        function (position) {
                            // Éxito: Guardar en HiddenFields de ASP.NET
                            document.getElementById('<%= hfLatitud.ClientID %>').value = position.coords.latitude;
                            document.getElementById('<%= hfLongitud.ClientID %>').value = position.coords.longitude;

                            // Mostrar Badge Verde Brillante
                            document.getElementById('divGeoStatus').style.display = 'flex';
                        },
                        function (error) {
                            // Fracaso: El usuario denegó o desactivó el GPS de su celular
                            Swal.fire({
                                icon: 'warning',
                                title: 'Ubicación Requerida 🚫',
                                text: 'Para validar el reporte, debe autorizar a RedPatitas a usar su GPS al tomar la foto.',
                                confirmButtonColor: '#FF8C42'
                            });
                        },
                        { enableHighAccuracy: true, timeout: 5000 }
                    );
                } else {
                    alert("Geolocalización no está soportada por su navegador.");
                }
            }

            // 4. Validar antes del Submit de C#
            function validarFormularioGeolocalizado() {
                var inputFoto = document.getElementById('<%= fuFotoVivo.ClientID %>');
                var hdLat = document.getElementById('<%= hfLatitud.ClientID %>').value;

                // Regla 1: Tomó foto?
                if (inputFoto.files.length === 0) {
                    Swal.fire('Atención', 'Debe tomar una foto usando el botón antes de enviar.', 'error');
                    return false;
                }

                // Regla 2: El GPS se cargó en un hidden state?
                if (hdLat === "") {
                    Swal.fire('Atención', 'No hemos podido capturar su ubicación GPS. Por favor, asegúrese de tener la ubicación del teléfono encendida e intente tomar la foto nuevamente.', 'warning');
                    return false;
                }

                // Muestra mensaje de carga al servidor porque las fotos son pesadas
                Swal.fire({
                    title: 'Enviando Reporte Seguro...',
                    html: 'Subiendo evidencia fotográfica y GPS.<br>Esto puede demorar unos segundos.',
                    allowOutsideClick: false,
                    didOpen: () => { Swal.showLoading(); }
                });

                return true;
            }
        </script>

    </asp:Content>