<%@ Page Title="Revisar Solicitud" Language="C#" MasterPageFile="~/AdminRefugio/AdminRefugio.Master"
    AutoEventWireup="true" CodeBehind="RevisarSolicitud.aspx.cs" Inherits="RedPatitas.AdminRefugio.RevisarSolicitud" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Revisar Solicitud de Adopción | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            .review-container {
                max-width: 900px;
                margin: 0 auto;
            }

            .back-btn {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.75rem 1.25rem;
                background: #f5f5f5;
                color: #666;
                border-radius: 10px;
                text-decoration: none;
                font-weight: 600;
                margin-bottom: 1.5rem;
                transition: all 0.2s;
            }

            .back-btn:hover {
                background: #eee;
                color: #333;
            }

            /* Header */
            .solicitud-header {
                background: linear-gradient(135deg, #FF8C42 0%, #FF6B35 100%);
                border-radius: 16px;
                padding: 2rem;
                color: white;
                display: flex;
                gap: 1.5rem;
                align-items: center;
                margin-bottom: 1.5rem;
                box-shadow: 0 4px 20px rgba(255, 107, 53, 0.3);
            }

            .mascota-img {
                width: 100px;
                height: 100px;
                border-radius: 12px;
                object-fit: cover;
                border: 3px solid rgba(255, 255, 255, 0.3);
            }

            .mascota-emoji {
                width: 100px;
                height: 100px;
                border-radius: 12px;
                background: rgba(255, 255, 255, 0.2);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 3rem;
            }

            .solicitud-header-info h2 {
                margin: 0 0 0.5rem 0;
                font-size: 1.5rem;
            }

            .solicitud-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 1rem;
                font-size: 0.9rem;
                opacity: 0.9;
            }

            .solicitud-meta span {
                display: flex;
                align-items: center;
                gap: 0.35rem;
            }

            /* Sección Evaluable */
            .eval-section {
                background: white;
                border-radius: 16px;
                margin-bottom: 1.5rem;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                overflow: hidden;
            }

            .eval-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 1rem 1.5rem;
                background: linear-gradient(135deg, #f8f9fa 0%, #fff 100%);
                border-bottom: 2px solid #f0f0f0;
            }

            .eval-title {
                font-size: 1.1rem;
                font-weight: 700;
                color: #4A3B32;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .eval-weight {
                background: #FF8C42;
                color: white;
                padding: 0.35rem 0.75rem;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 700;
            }

            .eval-content {
                padding: 1.5rem;
            }

            .info-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 1rem;
                margin-bottom: 1rem;
            }

            .info-item {
                padding: 0.75rem 1rem;
                background: #f9f9f9;
                border-radius: 8px;
                border-left: 3px solid #FF8C42;
            }

            .info-label {
                font-size: 0.7rem;
                color: #888;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 0.25rem;
            }

            .info-value {
                font-size: 0.95rem;
                color: #333;
                font-weight: 500;
            }

            .info-value.good {
                color: #27AE60;
            }

            .info-value.warning {
                color: #F39C12;
            }

            .info-value.bad {
                color: #E74C3C;
            }

            .text-block {
                background: #f9f9f9;
                border-radius: 8px;
                padding: 1rem;
                line-height: 1.6;
                color: #555;
                font-style: italic;
                margin-bottom: 1rem;
            }

            /* Evaluación inline */
            .eval-box {
                background: linear-gradient(135deg, #FFF8E1 0%, #FFFDE7 100%);
                border: 2px solid #FFD54F;
                border-radius: 12px;
                padding: 1rem 1.25rem;
                margin-top: 1rem;
            }

            .eval-suggestion {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                margin-bottom: 0.75rem;
                font-size: 0.9rem;
                color: #856404;
            }

            .eval-suggestion i {
                color: #F9A825;
            }

            .suggested-score {
                font-weight: 700;
                background: #FFC107;
                color: #333;
                padding: 0.15rem 0.5rem;
                border-radius: 4px;
            }

            .eval-input-row {
                display: flex;
                align-items: center;
                gap: 1rem;
                flex-wrap: wrap;
            }

            .eval-input-row label {
                font-weight: 600;
                color: #333;
            }

            .score-slider-container {
                flex: 1;
                min-width: 200px;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .score-slider {
                flex: 1;
                height: 8px;
                -webkit-appearance: none;
                background: linear-gradient(90deg, #E74C3C 0%, #F39C12 50%, #27AE60 100%);
                border-radius: 4px;
                outline: none;
            }

            .score-slider::-webkit-slider-thumb {
                -webkit-appearance: none;
                width: 24px;
                height: 24px;
                background: white;
                border: 3px solid #FF8C42;
                border-radius: 50%;
                cursor: pointer;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
            }

            .score-value {
                min-width: 45px;
                text-align: center;
                font-size: 1.5rem;
                font-weight: 800;
                color: #4A3B32;
            }

            /* Fotos Grid */
            .photos-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
                gap: 0.75rem;
                margin-top: 1rem;
            }

            .photo-card {
                aspect-ratio: 1;
                border-radius: 8px;
                overflow: hidden;
                cursor: pointer;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }

            .photo-card img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.2s;
            }

            .photo-card:hover img {
                transform: scale(1.1);
            }

            .no-photos {
                color: #999;
                font-style: italic;
                padding: 1rem;
                text-align: center;
                background: #f9f9f9;
                border-radius: 8px;
            }

            /* Puntaje Total */
            .total-card {
                background: white;
                border-radius: 16px;
                padding: 2rem;
                text-align: center;
                margin-bottom: 1.5rem;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            }

            .total-label {
                font-size: 0.9rem;
                color: #888;
                text-transform: uppercase;
                letter-spacing: 1px;
                margin-bottom: 0.5rem;
            }

            .total-score {
                font-size: 4rem;
                font-weight: 800;
                line-height: 1;
                margin-bottom: 0.5rem;
            }

            .total-score.excellent {
                color: #27AE60;
            }

            .total-score.good {
                color: #2ECC71;
            }

            .total-score.warning {
                color: #F39C12;
            }

            .total-score.danger {
                color: #E74C3C;
            }

            .total-status {
                font-size: 1.1rem;
                font-weight: 600;
                padding: 0.5rem 1.5rem;
                border-radius: 25px;
                display: inline-block;
            }

            .total-status.excellent {
                background: #D5F5E3;
                color: #1E8449;
            }

            .total-status.good {
                background: #D5F5E3;
                color: #27AE60;
            }

            .total-status.warning {
                background: #FEF9E7;
                color: #D68910;
            }

            .total-status.danger {
                background: #FDEDEC;
                color: #C0392B;
            }

            /* Botones de acción */
            .actions-row {
                display: flex;
                gap: 1rem;
                justify-content: center;
                flex-wrap: wrap;
            }

            .btn-action {
                padding: 1rem 2.5rem;
                border: none;
                border-radius: 12px;
                font-weight: 700;
                font-size: 1.1rem;
                cursor: pointer;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                transition: all 0.2s;
            }

            .btn-approve {
                background: linear-gradient(135deg, #27AE60 0%, #2ECC71 100%);
                color: white;
            }

            .btn-approve:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(39, 174, 96, 0.4);
            }

            .btn-reject {
                background: linear-gradient(135deg, #E74C3C 0%, #C0392B 100%);
                color: white;
            }

            .btn-reject:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(231, 76, 60, 0.4);
            }

            /* Modal */
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0, 0, 0, 0.5);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 9999;
            }

            .modal-content {
                background: white;
                border-radius: 16px;
                padding: 2rem;
                max-width: 500px;
                width: 95%;
            }

            .modal-textarea {
                width: 100%;
                min-height: 120px;
                padding: 1rem;
                border: 2px solid #e0e0e0;
                border-radius: 10px;
                font-family: inherit;
                font-size: 0.95rem;
                resize: vertical;
                margin-bottom: 0.5rem;
            }

            .modal-actions {
                display: flex;
                gap: 1rem;
                justify-content: flex-end;
                margin-top: 1rem;
            }

            .btn-cancel {
                padding: 0.75rem 1.5rem;
                background: #f5f5f5;
                color: #666;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
            }

            /* Alertas */
            .alert {
                padding: 1rem 1.5rem;
                border-radius: 10px;
                margin-bottom: 1.5rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .alert-error {
                background: #FEE2E2;
                color: #991B1B;
                border: 1px solid #FECACA;
            }

            .alert-success {
                background: #D1FAE5;
                color: #065F46;
                border: 1px solid #A7F3D0;
            }

            /* Solo info (sin evaluación) */
            .info-only .eval-weight {
                display: none;
            }

            .info-only .eval-box {
                display: none;
            }

            @media (max-width: 768px) {
                .solicitud-header {
                    flex-direction: column;
                    text-align: center;
                }

                .eval-header {
                    flex-direction: column;
                    gap: 0.5rem;
                }

                .actions-row {
                    flex-direction: column;
                }

                .btn-action {
                    width: 100%;
                    justify-content: center;
                }
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content4" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">📋 Revisar Solicitud de Adopción</h1>
            <div class="breadcrumb">Dashboard / Solicitudes / Revisar</div>
        </div>
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
        <div class="review-container">

            <a href="Solicitudes.aspx" class="back-btn">
                <i class="fas fa-arrow-left"></i> Volver a Solicitudes
            </a>

            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <asp:Literal ID="litError" runat="server"></asp:Literal>
            </asp:Panel>

            <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <asp:Literal ID="litSuccess" runat="server"></asp:Literal>
            </asp:Panel>

            <asp:Panel ID="pnlContenido" runat="server">

                <!-- Header -->
                <div class="solicitud-header">
                    <asp:Image ID="imgMascota" runat="server" CssClass="mascota-img" Visible="false" />
                    <asp:Panel ID="pnlEmoji" runat="server" CssClass="mascota-emoji">
                        <asp:Literal ID="litEmoji" runat="server">🐾</asp:Literal>
                    </asp:Panel>
                    <div class="solicitud-header-info">
                        <h2>Solicitud para <asp:Literal ID="litNombreMascota" runat="server">Mascota</asp:Literal>
                        </h2>
                        <div class="solicitud-meta">
                            <span><i class="fas fa-user"></i>
                                <asp:Literal ID="litNombreAdoptante" runat="server"></asp:Literal>
                            </span>
                            <span><i class="fas fa-calendar"></i>
                                <asp:Literal ID="litFechaSolicitud" runat="server"></asp:Literal>
                            </span>
                            <span><i class="fas fa-tag"></i>
                                <asp:Literal ID="litEstado" runat="server">Pendiente</asp:Literal>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- SECCIÓN 1: Datos del Adoptante (solo info) -->
                <div class="eval-section info-only">
                    <div class="eval-header">
                        <div class="eval-title"><i class="fas fa-user-circle"></i> Datos del Adoptante</div>
                    </div>
                    <div class="eval-content">
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">Nombre Completo</div>
                                <div class="info-value">
                                    <asp:Literal ID="litAdoptanteNombre" runat="server"></asp:Literal>
                                </div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Cédula</div>
                                <div class="info-value">
                                    <asp:Literal ID="litAdoptanteCedula" runat="server"></asp:Literal>
                                </div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Teléfono</div>
                                <div class="info-value">
                                    <asp:Literal ID="litAdoptanteTelefono" runat="server"></asp:Literal>
                                </div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Email</div>
                                <div class="info-value">
                                    <asp:Literal ID="litAdoptanteEmail" runat="server"></asp:Literal>
                                </div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Ciudad</div>
                                <div class="info-value">
                                    <asp:Literal ID="litAdoptanteCiudad" runat="server"></asp:Literal>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SECCIÓN 2: Motivación -->
                <div class="eval-section">
                    <div class="eval-header">
                        <div class="eval-title"><i class="fas fa-heart"></i> Motivación para Adoptar</div>
                        <span class="eval-weight">Peso: 15%</span>
                    </div>
                    <div class="eval-content">
                        <div class="text-block">
                            "<asp:Literal ID="litMotivacion" runat="server">No especificada</asp:Literal>"
                        </div>
                        <div class="eval-box">
                            <div class="eval-suggestion">
                                <i class="fas fa-lightbulb"></i>
                                <span>Puntaje sugerido: <span class="suggested-score"
                                        id="sugMotivacion">5</span>/10</span>
                                <span style="margin-left: 0.5rem; color: #666; font-size: 0.85rem;"
                                    id="sugMotivacionReason">(texto básico)</span>
                            </div>
                            <div class="eval-input-row">
                                <label>Tu evaluación:</label>
                                <div class="score-slider-container">
                                    <input type="range" class="score-slider" id="scoreMotivacion" name="scoreMotivacion"
                                        min="1" max="10" value="5"
                                        oninput="actualizarPuntaje(this, 'valMotivacion'); calcularTotal();">
                                    <span class="score-value" id="valMotivacion">5</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SECCIÓN 3: Experiencia -->
                <div class="eval-section">
                    <div class="eval-header">
                        <div class="eval-title"><i class="fas fa-paw"></i> Experiencia con Mascotas</div>
                        <span class="eval-weight">Peso: 15%</span>
                    </div>
                    <div class="eval-content">
                        <div class="text-block">
                            "<asp:Literal ID="litExperiencia" runat="server">No especificada</asp:Literal>"
                        </div>
                        <div class="eval-box">
                            <div class="eval-suggestion">
                                <i class="fas fa-lightbulb"></i>
                                <span>Puntaje sugerido: <span class="suggested-score"
                                        id="sugExperiencia">5</span>/10</span>
                                <span style="margin-left: 0.5rem; color: #666; font-size: 0.85rem;"
                                    id="sugExperienciaReason"></span>
                            </div>
                            <div class="eval-input-row">
                                <label>Tu evaluación:</label>
                                <div class="score-slider-container">
                                    <input type="range" class="score-slider" id="scoreExperiencia"
                                        name="scoreExperiencia" min="1" max="10" value="5"
                                        oninput="actualizarPuntaje(this, 'valExperiencia'); calcularTotal();">
                                    <span class="score-value" id="valExperiencia">5</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SECCIÓN 4: Vivienda -->
                <div class="eval-section">
                    <div class="eval-header">
                        <div class="eval-title"><i class="fas fa-home"></i> Vivienda y Espacio</div>
                        <span class="eval-weight">Peso: 30%</span>
                    </div>
                    <div class="eval-content">
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">Tipo de Vivienda</div>
                                <div class="info-value">
                                    <asp:Literal ID="litTipoVivienda" runat="server"></asp:Literal>
                                </div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">¿Tiene Patio/Jardín?</div>
                                <div class="info-value">
                                    <asp:Literal ID="litPatioJardin" runat="server"></asp:Literal>
                                </div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Horas en Casa</div>
                                <div class="info-value">
                                    <asp:Literal ID="litHorasEnCasa" runat="server"></asp:Literal>
                                </div>
                            </div>
                        </div>

                        <!-- Fotos de vivienda -->
                        <asp:Panel ID="pnlFotos" runat="server" Visible="false">
                            <h4 style="margin: 1rem 0 0.5rem 0; color: #666;"><i class="fas fa-camera"></i> Fotos de
                                Vivienda</h4>
                            <asp:Repeater ID="rptFotos" runat="server">
                                <HeaderTemplate>
                                    <div class="photos-grid">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <div class="photo-card" onclick="window.open('<%# Eval(" fos_Url") %>', '_blank')">
                                        <img src='<%# Eval("fos_Url") %>' alt='<%# Eval("fos_TipoFoto") %>' />
                                    </div>
                                </ItemTemplate>
                                <FooterTemplate>
                    </div>
                    </FooterTemplate>
                    </asp:Repeater>
            </asp:Panel>
            <asp:Panel ID="pnlSinFotos" runat="server" CssClass="no-photos">
                <i class="fas fa-image"></i> El adoptante no ha subido fotos de su vivienda
            </asp:Panel>

            <div class="eval-box">
                <div class="eval-suggestion">
                    <i class="fas fa-lightbulb"></i>
                    <span>Puntaje sugerido: <span class="suggested-score" id="sugVivienda">7</span>/10</span>
                    <span style="margin-left: 0.5rem; color: #666; font-size: 0.85rem;" id="sugViviendaReason"></span>
                </div>
                <div class="eval-input-row">
                    <label>Tu evaluación:</label>
                    <div class="score-slider-container">
                        <input type="range" class="score-slider" id="scoreVivienda" name="scoreVivienda" min="1"
                            max="10" value="7" oninput="actualizarPuntaje(this, 'valVivienda'); calcularTotal();">
                        <span class="score-value" id="valVivienda">7</span>
                    </div>
                </div>
            </div>
        </div>
        </div>

        <!-- SECCIÓN 5: Situación Familiar -->
        <div class="eval-section">
            <div class="eval-header">
                <div class="eval-title"><i class="fas fa-users"></i> Compatibilidad Familiar</div>
                <span class="eval-weight">Peso: 10%</span>
            </div>
            <div class="eval-content">
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">¿Otras Mascotas?</div>
                        <div class="info-value">
                            <asp:Literal ID="litOtrasMascotas" runat="server"></asp:Literal>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">¿Niños en Casa?</div>
                        <div class="info-value">
                            <asp:Literal ID="litNinos" runat="server"></asp:Literal>
                        </div>
                    </div>
                </div>
                <asp:Panel ID="pnlDetallesOtrasMascotas" runat="server" Visible="false">
                    <div class="info-item" style="margin-top: 0.5rem;">
                        <div class="info-label">Detalle de Otras Mascotas</div>
                        <div class="info-value">
                            <asp:Literal ID="litDetalleOtrasMascotas" runat="server"></asp:Literal>
                        </div>
                    </div>
                </asp:Panel>
                <asp:Panel ID="pnlEdadesNinos" runat="server" Visible="false">
                    <div class="info-item" style="margin-top: 0.5rem;">
                        <div class="info-label">Edades de los Niños</div>
                        <div class="info-value">
                            <asp:Literal ID="litEdadesNinos" runat="server"></asp:Literal>
                        </div>
                    </div>
                </asp:Panel>

                <div class="eval-box">
                    <div class="eval-suggestion">
                        <i class="fas fa-lightbulb"></i>
                        <span>Puntaje sugerido: <span class="suggested-score" id="sugFamilia">7</span>/10</span>
                        <span style="margin-left: 0.5rem; color: #666; font-size: 0.85rem;"
                            id="sugFamiliaReason"></span>
                    </div>
                    <div class="eval-input-row">
                        <label>Tu evaluación:</label>
                        <div class="score-slider-container">
                            <input type="range" class="score-slider" id="scoreFamilia" name="scoreFamilia" min="1"
                                max="10" value="7" oninput="actualizarPuntaje(this, 'valFamilia'); calcularTotal();">
                            <span class="score-value" id="valFamilia">7</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- SECCIÓN 6: Estabilidad Económica -->
        <div class="eval-section">
            <div class="eval-header">
                <div class="eval-title"><i class="fas fa-wallet"></i> Estabilidad Económica</div>
                <span class="eval-weight">Peso: 15%</span>
            </div>
            <div class="eval-content">
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Ingresos Mensuales</div>
                        <div class="info-value">
                            <asp:Literal ID="litIngresos" runat="server"></asp:Literal>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">¿Acepta Visitas de Seguimiento?</div>
                        <div class="info-value">
                            <asp:Literal ID="litAceptaVisita" runat="server"></asp:Literal>
                        </div>
                    </div>
                </div>

                <div class="eval-box">
                    <div class="eval-suggestion">
                        <i class="fas fa-lightbulb"></i>
                        <span>Puntaje sugerido: <span class="suggested-score" id="sugEconomia">6</span>/10</span>
                        <span style="margin-left: 0.5rem; color: #666; font-size: 0.85rem;"
                            id="sugEconomiaReason"></span>
                    </div>
                    <div class="eval-input-row">
                        <label>Tu evaluación:</label>
                        <div class="score-slider-container">
                            <input type="range" class="score-slider" id="scoreEconomia" name="scoreEconomia" min="1"
                                max="10" value="6" oninput="actualizarPuntaje(this, 'valEconomia'); calcularTotal();">
                            <span class="score-value" id="valEconomia">6</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Comentarios adicionales -->
        <asp:Panel ID="pnlComentarios" runat="server" Visible="false" CssClass="eval-section info-only">
            <div class="eval-header">
                <div class="eval-title"><i class="fas fa-comment"></i> Comentarios Adicionales del Adoptante</div>
            </div>
            <div class="eval-content">
                <div class="text-block">
                    "<asp:Literal ID="litComentarios" runat="server"></asp:Literal>"
                </div>
            </div>
        </asp:Panel>

        <!-- PUNTAJE TOTAL -->
        <div class="total-card">
            <div class="total-label">PUNTAJE TOTAL PONDERADO</div>
            <div class="total-score excellent" id="totalScoreDisplay">0</div>
            <div class="total-status excellent" id="totalStatusDisplay">Evalúa las secciones</div>
        </div>

        <!-- Hidden Fields -->
        <asp:HiddenField ID="hfIdSolicitud" runat="server" />
        <asp:HiddenField ID="hfPuntajeTotal" runat="server" />
        <asp:HiddenField ID="hfEvaluaciones" runat="server" />

        <!-- Datos para JavaScript -->
        <asp:HiddenField ID="hfTipoVivienda" runat="server" />
        <asp:HiddenField ID="hfTienePatio" runat="server" />
        <asp:HiddenField ID="hfHorasEnCasa" runat="server" />
        <asp:HiddenField ID="hfIngresos" runat="server" />
        <asp:HiddenField ID="hfOtrasMascotas" runat="server" />
        <asp:HiddenField ID="hfTieneNinos" runat="server" />
        <asp:HiddenField ID="hfTextoMotivacion" runat="server" />
        <asp:HiddenField ID="hfTextoExperiencia" runat="server" />

        <!-- Botones de Acción -->
        <div class="actions-row">
            <asp:Button ID="btnAprobar" runat="server" CssClass="btn-action btn-approve" Text="✅ Aprobar Adopción"
                OnClick="btnAprobar_Click"
                OnClientClick="return prepararEnvio() && confirm('¿Aprobar esta adopción? La mascota pasará a estado ADOPTADO.');" />
            <asp:Button ID="btnRechazar" runat="server" CssClass="btn-action btn-reject" Text="❌ Rechazar Solicitud"
                OnClick="btnRechazar_Click" OnClientClick="return prepararEnvio();" />
        </div>

        </asp:Panel>

        <!-- Modal Rechazo -->
        <asp:Panel ID="pnlModalRechazo" runat="server" Visible="false" CssClass="modal-overlay">
            <div class="modal-content">
                <h3 style="margin-bottom: 1rem;"><i class="fas fa-comment-alt"></i> Motivo del Rechazo</h3>
                <p style="color: #666; margin-bottom: 1rem;">Esta información será enviada al adoptante.</p>
                <asp:TextBox ID="txtMotivoRechazo" runat="server" CssClass="modal-textarea" TextMode="MultiLine"
                    placeholder="Escribe el motivo del rechazo..."></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvMotivo" runat="server" ControlToValidate="txtMotivoRechazo"
                    ErrorMessage="El motivo es requerido" ForeColor="Red" ValidationGroup="Rechazo" Display="Dynamic">
                </asp:RequiredFieldValidator>
                <div class="modal-actions">
                    <asp:Button ID="btnCancelarRechazo" runat="server" Text="Cancelar" CssClass="btn-cancel"
                        OnClick="btnCancelarRechazo_Click" CausesValidation="false" />
                    <asp:Button ID="btnConfirmarRechazo" runat="server" Text="Confirmar Rechazo"
                        CssClass="btn-action btn-reject" OnClick="btnConfirmarRechazo_Click"
                        ValidationGroup="Rechazo" />
                </div>
            </div>
        </asp:Panel>
        </div>

        <script type="text/javascript">
            // Pesos de cada criterio
            var pesos = {
                motivacion: 15,
                experiencia: 15,
                vivienda: 30,
                familia: 10,
                economia: 15
            };

            document.addEventListener('DOMContentLoaded', function () {
                calcularSugerencias();
                calcularTotal();
            });

            function actualizarPuntaje(slider, displayId) {
                document.getElementById(displayId).innerText = slider.value;
            }

            function calcularSugerencias() {
                // Obtener datos de los hidden fields
                var tipoVivienda = document.getElementById('<%= hfTipoVivienda.ClientID %>').value.toLowerCase();
                var tienePatio = document.getElementById('<%= hfTienePatio.ClientID %>').value === 'true';
                var horasEnCasa = parseInt(document.getElementById('<%= hfHorasEnCasa.ClientID %>').value) || 0;
                var ingresos = document.getElementById('<%= hfIngresos.ClientID %>').value;
                var otrasMascotas = document.getElementById('<%= hfOtrasMascotas.ClientID %>').value === 'true';
                var tieneNinos = document.getElementById('<%= hfTieneNinos.ClientID %>').value === 'true';
                var textoMotivacion = document.getElementById('<%= hfTextoMotivacion.ClientID %>').value;
                var textoExperiencia = document.getElementById('<%= hfTextoExperiencia.ClientID %>').value;

                // === MOTIVACIÓN ===
                var sugMot = 5, reasonMot = "(texto básico)";
                if (textoMotivacion.length > 150) {
                    sugMot = 9; reasonMot = "(texto muy detallado y completo)";
                } else if (textoMotivacion.length > 80) {
                    sugMot = 7; reasonMot = "(buena explicación)";
                } else if (textoMotivacion.length > 30) {
                    sugMot = 5; reasonMot = "(explicación básica)";
                } else {
                    sugMot = 3; reasonMot = "(muy poco detalle)";
                }
                document.getElementById('sugMotivacion').innerText = sugMot;
                document.getElementById('sugMotivacionReason').innerText = reasonMot;
                document.getElementById('scoreMotivacion').value = sugMot;
                document.getElementById('valMotivacion').innerText = sugMot;

                // === EXPERIENCIA ===
                var sugExp = 5, reasonExp = "";
                var expLower = textoExperiencia.toLowerCase();
                if (expLower.includes('años') || expLower.includes('año')) {
                    var match = expLower.match(/(\d+)\s*años?/);
                    if (match) {
                        var years = parseInt(match[1]);
                        if (years >= 5) { sugExp = 10; reasonExp = "(" + years + " años de experiencia = excelente)"; }
                        else if (years >= 3) { sugExp = 8; reasonExp = "(" + years + " años de experiencia)"; }
                        else { sugExp = 6; reasonExp = "(" + years + " años de experiencia)"; }
                    } else {
                        sugExp = 7; reasonExp = "(menciona experiencia)";
                    }
                } else if (textoExperiencia.length > 50) {
                    sugExp = 6; reasonExp = "(describe experiencia)";
                } else if (textoExperiencia.length > 10) {
                    sugExp = 5; reasonExp = "(poca información)";
                } else {
                    sugExp = 3; reasonExp = "(sin experiencia indicada)";
                }
                document.getElementById('sugExperiencia').innerText = sugExp;
                document.getElementById('sugExperienciaReason').innerText = reasonExp;
                document.getElementById('scoreExperiencia').value = sugExp;
                document.getElementById('valExperiencia').innerText = sugExp;

                // === VIVIENDA ===
                var sugViv = 5, reasonViv = "";
                if (tipoVivienda.includes('finca')) {
                    sugViv = 10; reasonViv = "(finca = espacio ideal)";
                } else if (tipoVivienda.includes('casa') && tienePatio) {
                    sugViv = 9; reasonViv = "(casa con patio = excelente)";
                } else if (tipoVivienda.includes('casa')) {
                    sugViv = 7; reasonViv = "(casa sin patio)";
                } else if (tipoVivienda.includes('apartamento') || tipoVivienda.includes('departamento')) {
                    sugViv = tienePatio ? 6 : 4;
                    reasonViv = tienePatio ? "(apartamento con terraza)" : "(apartamento - espacio limitado)";
                } else {
                    sugViv = 5; reasonViv = "(tipo no especificado)";
                }
                // Ajuste por horas en casa
                if (horasEnCasa >= 10) sugViv = Math.min(10, sugViv + 1);
                else if (horasEnCasa <= 4) sugViv = Math.max(1, sugViv - 1);

                document.getElementById('sugVivienda').innerText = sugViv;
                document.getElementById('sugViviendaReason').innerText = reasonViv;
                document.getElementById('scoreVivienda').value = sugViv;
                document.getElementById('valVivienda').innerText = sugViv;

                // === FAMILIA ===
                var sugFam = 8, reasonFam = "";
                if (!otrasMascotas && !tieneNinos) {
                    sugFam = 10; reasonFam = "(sin complicaciones familiares)";
                } else if (otrasMascotas && !tieneNinos) {
                    sugFam = 8; reasonFam = "(tiene mascotas - puede ser positivo para compañía)";
                } else if (!otrasMascotas && tieneNinos) {
                    sugFam = 7; reasonFam = "(tiene niños - verificar compatibilidad)";
                } else {
                    sugFam = 6; reasonFam = "(mascotas y niños - requiere evaluación)";
                }
                document.getElementById('sugFamilia').innerText = sugFam;
                document.getElementById('sugFamiliaReason').innerText = reasonFam;
                document.getElementById('scoreFamilia').value = sugFam;
                document.getElementById('valFamilia').innerText = sugFam;

                // === ECONOMÍA ===
                var sugEco = 5, reasonEco = "";
                if (ingresos.includes('>2000') || ingresos.includes('2000')) {
                    sugEco = 10; reasonEco = "(ingresos altos)";
                } else if (ingresos.includes('1000')) {
                    sugEco = 8; reasonEco = "(ingresos medios-altos)";
                } else if (ingresos.includes('500')) {
                    sugEco = 6; reasonEco = "(ingresos medios)";
                } else if (ingresos.includes('<500')) {
                    sugEco = 4; reasonEco = "(ingresos bajos - puede ser difícil)";
                } else {
                    sugEco = 5; reasonEco = "(no especificado)";
                }
                document.getElementById('sugEconomia').innerText = sugEco;
                document.getElementById('sugEconomiaReason').innerText = reasonEco;
                document.getElementById('scoreEconomia').value = sugEco;
                document.getElementById('valEconomia').innerText = sugEco;
            }

            function calcularTotal() {
                var scores = {
                    motivacion: parseInt(document.getElementById('scoreMotivacion').value) || 0,
                    experiencia: parseInt(document.getElementById('scoreExperiencia').value) || 0,
                    vivienda: parseInt(document.getElementById('scoreVivienda').value) || 0,
                    familia: parseInt(document.getElementById('scoreFamilia').value) || 0,
                    economia: parseInt(document.getElementById('scoreEconomia').value) || 0
                };

                // Calcular total ponderado
                var sumaPesos = pesos.motivacion + pesos.experiencia + pesos.vivienda + pesos.familia + pesos.economia;
                var totalPonderado =
                    (scores.motivacion / 10 * pesos.motivacion) +
                    (scores.experiencia / 10 * pesos.experiencia) +
                    (scores.vivienda / 10 * pesos.vivienda) +
                    (scores.familia / 10 * pesos.familia) +
                    (scores.economia / 10 * pesos.economia);

                var puntajeFinal = (totalPonderado / sumaPesos) * 100;

                // Actualizar display
                var scoreDisplay = document.getElementById('totalScoreDisplay');
                var statusDisplay = document.getElementById('totalStatusDisplay');

                scoreDisplay.innerText = puntajeFinal.toFixed(1);

                // Clases según puntaje
                scoreDisplay.className = 'total-score';
                statusDisplay.className = 'total-status';

                if (puntajeFinal >= 80) {
                    scoreDisplay.classList.add('excellent');
                    statusDisplay.classList.add('excellent');
                    statusDisplay.innerText = '✅ EXCELENTE - APTO PARA ADOPCIÓN';
                } else if (puntajeFinal >= 65) {
                    scoreDisplay.classList.add('good');
                    statusDisplay.classList.add('good');
                    statusDisplay.innerText = '✅ BUENO - APTO PARA ADOPCIÓN';
                } else if (puntajeFinal >= 50) {
                    scoreDisplay.classList.add('warning');
                    statusDisplay.classList.add('warning');
                    statusDisplay.innerText = '⚠️ REGULAR - REQUIERE CONSIDERACIÓN';
                } else {
                    scoreDisplay.classList.add('danger');
                    statusDisplay.classList.add('danger');
                    statusDisplay.innerText = '❌ NO RECOMENDADO';
                }

                // Guardar en hidden field
                document.getElementById('<%= hfPuntajeTotal.ClientID %>').value = puntajeFinal.toFixed(2);
            }

            function prepararEnvio() {
                var evaluaciones = [
                    { criterio: 'Motivación', puntaje: document.getElementById('scoreMotivacion').value, peso: 15 },
                    { criterio: 'Experiencia', puntaje: document.getElementById('scoreExperiencia').value, peso: 15 },
                    { criterio: 'Vivienda', puntaje: document.getElementById('scoreVivienda').value, peso: 30 },
                    { criterio: 'Familia', puntaje: document.getElementById('scoreFamilia').value, peso: 10 },
                    { criterio: 'Economía', puntaje: document.getElementById('scoreEconomia').value, peso: 15 }
                ];
                document.getElementById('<%= hfEvaluaciones.ClientID %>').value = JSON.stringify(evaluaciones);
                return true;
            }
        </script>
    </asp:Content>