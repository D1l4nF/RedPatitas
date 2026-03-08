<%@ Page Title="Detalle de Reporte" Language="C#" MasterPageFile="~/Public/Public.Master" AutoEventWireup="true"
    CodeBehind="DetalleReporte.aspx.cs" Inherits="RedPatitas.Public.DetalleReporte" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Detalle de Reporte | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
        <style>
            /* ── Layout general ── */
            .detalle-page {
                max-width: 960px;
                margin: 0 auto;
                padding: 100px 1rem 3rem;
            }

            /* ── Botón volver ── */
            .btn-volver {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 10px 20px;
                background: #fff;
                color: #ff6b35;
                border: 2px solid #ff6b35;
                border-radius: 10px;
                font-family: inherit;
                font-size: 0.9rem;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.25s;
                margin-bottom: 1.25rem;
            }

            .btn-volver:hover {
                background: #ff6b35;
                color: #fff;
                transform: translateX(-3px);
            }

            /* ── Card principal ── */
            .detalle-hero {
                background: #fff;
                border-radius: 16px;
                padding: 2rem 2rem 1.5rem;
                box-shadow: 0 2px 16px rgba(0, 0, 0, 0.08);
                margin-bottom: 1.5rem;
                overflow: hidden;
            }

            /* ── Tipo badge ── */
            .tipo-badge {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 8px 18px;
                border-radius: 20px;
                font-weight: 700;
                font-size: 0.9rem;
                margin-bottom: 1rem;
            }

            .tipo-perdida {
                background: linear-gradient(135deg, #fde8e8, #fbd5d5);
                color: #c0392b;
            }

            .tipo-encontrada {
                background: linear-gradient(135deg, #e8f8ef, #d4efdf);
                color: #1e8449;
            }

            /* ── Estado badge ── */
            .estado-badge {
                display: inline-block;
                padding: 4px 14px;
                border-radius: 12px;
                font-size: 0.78rem;
                font-weight: 700;
                background: #fff3e0;
                color: #ff6b35;
                margin-left: 10px;
                vertical-align: middle;
                letter-spacing: 0.3px;
            }

            /* ── Nombre mascota ── */
            .nombre-mascota {
                margin: 0 0 1rem;
                font-size: 1.8rem;
                color: #222;
                font-weight: 800;
            }

            /* ── Galería ── */
            .foto-galeria {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 12px;
                margin: 1.25rem 0 1.5rem;
            }

            .foto-galeria img {
                width: 100%;
                aspect-ratio: 1;
                object-fit: cover;
                border-radius: 12px;
                cursor: pointer;
                transition: transform 0.25s, box-shadow 0.25s;
                border: 2px solid transparent;
            }

            .foto-galeria img:hover {
                transform: scale(1.03);
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.18);
                border-color: #ff6b35;
            }

            .sin-foto-box {
                display: flex;
                align-items: center;
                justify-content: center;
                background: #f5f5f5;
                border-radius: 12px;
                height: 200px;
                margin: 1rem 0;
                color: #aaa;
                font-size: 0.9rem;
            }

            /* ── Sección info ── */
            .section-divider {
                border: none;
                border-top: 1px solid #f0f0f0;
                margin: 1.5rem 0;
            }

            .section-label {
                font-size: 0.82rem;
                color: #ff6b35;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.8px;
                margin-bottom: 0.75rem;
                display: flex;
                align-items: center;
                gap: 6px;
            }

            .info-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 1.25rem;
            }

            @media (max-width: 600px) {
                .info-grid {
                    grid-template-columns: 1fr;
                }

                .detalle-page {
                    padding: 90px 0.75rem 2rem;
                }

                .detalle-hero {
                    padding: 1.25rem;
                }

                .nombre-mascota {
                    font-size: 1.4rem;
                }
            }

            .info-item {
                background: #fafafa;
                padding: 12px 16px;
                border-radius: 10px;
                border-left: 3px solid #ff6b35;
            }

            .info-item label {
                font-size: 0.72rem;
                color: #999;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                display: block;
                margin-bottom: 3px;
            }

            .info-item span {
                font-size: 1rem;
                color: #222;
                font-weight: 600;
            }

            /* ── Descripción ── */
            .descripcion-text {
                margin: 0;
                line-height: 1.75;
                color: #444;
                font-size: 0.95rem;
                background: #fafafa;
                padding: 1rem 1.25rem;
                border-radius: 10px;
                border-left: 3px solid #e0e0e0;
            }

            /* ── Mapa mini ── */
            .mapa-section-title {
                margin: 0 0 0.5rem;
                font-size: 1.1rem;
                color: #222;
                font-weight: 700;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .mapa-ubicacion-text {
                font-size: 0.88rem;
                color: #666;
                margin: 0 0 0.75rem;
            }

            .mapa-mini {
                height: 280px;
                border-radius: 12px;
                border: 2px solid #f0f0f0;
                overflow: hidden;
            }

            /* ── Contacto ── */
            .contacto-box {
                background: linear-gradient(135deg, #fff8f3 0%, #fff5ed 100%);
                border: 1px solid #ffe0cc;
                border-radius: 14px;
                padding: 1.5rem;
                margin-top: 1.5rem;
            }

            .contacto-title {
                margin: 0 0 1rem;
                font-size: 1.1rem;
                color: #222;
                font-weight: 700;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .contacto-box .info-item {
                background: #fff;
                border-left-color: #ff6b35;
            }

            .contacto-box .info-item a {
                color: #ff6b35;
                text-decoration: none;
                font-weight: 600;
            }

            .contacto-box .info-item a:hover {
                text-decoration: underline;
            }

            /* ── Login aviso ── */
            .login-aviso {
                background: linear-gradient(135deg, #fff8e1, #fff3cd);
                border: 1px solid #ffe082;
                border-radius: 12px;
                padding: 1.25rem 1.5rem;
                font-size: 0.9rem;
                color: #795500;
                margin-top: 1.5rem;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .login-aviso a {
                color: #ff6b35;
                font-weight: 700;
                text-decoration: none;
            }

            .login-aviso a:hover {
                text-decoration: underline;
            }

            /* ── Botón avistamiento ── */
            .btn-avistamiento {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 12px 28px;
                background: linear-gradient(135deg, #27ae60, #2ecc71);
                color: #fff;
                border-radius: 12px;
                font-family: inherit;
                font-size: 0.95rem;
                font-weight: 700;
                text-decoration: none;
                margin-top: 1.25rem;
                box-shadow: 0 4px 14px rgba(39, 174, 96, 0.3);
                transition: all 0.25s;
            }

            .btn-avistamiento:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(39, 174, 96, 0.4);
            }

            /* ── Avistamientos ── */
            .avistamientos-card {
                background: #fff;
                border-radius: 16px;
                padding: 2rem;
                box-shadow: 0 2px 16px rgba(0, 0, 0, 0.08);
                margin-bottom: 2rem;
            }

            .avistamientos-title {
                margin: 0 0 1.25rem;
                font-size: 1.2rem;
                color: #222;
                font-weight: 700;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .avistamientos-count {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                background: #ff6b35;
                color: #fff;
                width: 26px;
                height: 26px;
                border-radius: 50%;
                font-size: 0.82rem;
                font-weight: 700;
            }

            .avistamiento-item {
                border-left: 3px solid #ff6b35;
                padding: 1rem 1rem 1rem 1.25rem;
                margin-bottom: 0.75rem;
                background: #fafafa;
                border-radius: 0 10px 10px 0;
                transition: background 0.2s;
            }

            .avistamiento-item:hover {
                background: #f5f5f5;
            }

            .avistamiento-item:last-child {
                margin-bottom: 0;
            }

            .avistamiento-ubicacion {
                font-weight: 700;
                color: #333;
                display: flex;
                align-items: center;
                gap: 4px;
            }

            .avistamiento-fecha {
                font-size: 0.8rem;
                color: #999;
            }

            .avistamiento-desc {
                margin: 6px 0 0;
                color: #555;
                font-size: 0.9rem;
                line-height: 1.5;
            }

            .sin-avistamientos {
                text-align: center;
                padding: 2rem;
                color: #aaa;
            }

            .sin-avistamientos svg {
                display: block;
                margin: 0 auto 0.75rem;
                opacity: 0.3;
            }

            /* ── No encontrado ── */
            .no-encontrado {
                text-align: center;
                padding: 5rem 2rem;
                margin-top: 100px;
            }

            .no-encontrado h2 {
                color: #333;
                margin: 1rem 0 0.5rem;
            }

            .no-encontrado p {
                color: #888;
                margin-bottom: 1.5rem;
            }

            .no-encontrado a {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                background: #ff6b35;
                color: #fff;
                padding: 12px 24px;
                border-radius: 10px;
                text-decoration: none;
                font-weight: 700;
                transition: background 0.2s;
            }

            .no-encontrado a:hover {
                background: #e65100;
            }

            /* ── Actions bar ── */
            .actions-bar {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-top: 1.5rem;
                flex-wrap: wrap;
            }

            .btn-share {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 10px 20px;
                background: #f0f0f0;
                color: #555;
                border: none;
                border-radius: 10px;
                font-family: inherit;
                font-size: 0.88rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s;
            }

            .btn-share:hover {
                background: #e2e2e2;
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

        <asp:Panel ID="pnlNoEncontrado" runat="server" Visible="false">
            <div class="no-encontrado">
                <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#ccc" stroke-width="1.5">
                    <circle cx="11" cy="11" r="8" />
                    <line x1="21" y1="21" x2="16.65" y2="16.65" />
                </svg>
                <h2>Reporte no encontrado</h2>
                <p>El reporte que buscas no existe o fue eliminado.</p>
                <a href="MapaExtravios.aspx">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2.5">
                        <line x1="19" y1="12" x2="5" y2="12" />
                        <polyline points="12 19 5 12 12 5" />
                    </svg>
                    Ver mapa de reportes
                </a>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlDetalle" runat="server">
            <div class="detalle-page">

                <!-- ══ Botón volver al mapa ══ -->
                <a href="MapaExtravios.aspx" class="btn-volver">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2.5">
                        <line x1="19" y1="12" x2="5" y2="12" />
                        <polyline points="12 19 5 12 12 5" />
                    </svg>
                    Volver al Mapa
                </a>

                <!-- ══ Card principal ══ -->
                <div class="detalle-hero">

                    <asp:Literal ID="litTipoBadge" runat="server"></asp:Literal>

                    <h1 class="nombre-mascota">
                        <asp:Literal ID="litNombreMascota" runat="server">Sin nombre</asp:Literal>
                        <asp:Literal ID="litEstadoBadge" runat="server"></asp:Literal>
                    </h1>

                    <!-- Galería de fotos -->
                    <asp:Panel ID="pnlFotos" runat="server">
                        <div class="foto-galeria">
                            <asp:Repeater ID="rptFotos" runat="server">
                                <ItemTemplate>
                                    <img src='<%# ResolveUrl(Eval("fore_Url").ToString()) %>' alt="Foto de la mascota"
                                        onerror="this.style.display='none'" onclick="verFotoGrande(this.src)" />
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </asp:Panel>

                    <!-- Si no hay fotos, mostrar placeholder -->
                    <asp:Panel ID="pnlSinFoto" runat="server" Visible="false">
                        <div class="sin-foto-box">
                            <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#ccc" stroke-width="1.5"
                                style="margin-right:8px;">
                                <rect x="3" y="3" width="18" height="18" rx="2" />
                                <circle cx="8.5" cy="8.5" r="1.5" />
                                <polyline points="21 15 16 10 5 21" />
                            </svg>
                            Sin fotografías disponibles
                        </div>
                    </asp:Panel>

                    <hr class="section-divider" />

                    <!-- ── Datos de la mascota ── -->
                    <div class="section-label">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2">
                            <path
                                d="M12,11.36C12.55,11.36 13,10.91 13,10.36V8.36C13,7.81 12.55,7.36 12,7.36C11.45,7.36 11,7.81 11,8.36V10.36C11,10.91 11.45,11.36 12,11.36" />
                        </svg>
                        Información de la Mascota
                    </div>

                    <div class="info-grid">
                        <div class="info-item">
                            <label>Especie</label>
                            <span>
                                <asp:Literal ID="litEspecie" runat="server">-</asp:Literal>
                            </span>
                        </div>
                        <div class="info-item">
                            <label>Color</label>
                            <span>
                                <asp:Literal ID="litColor" runat="server">-</asp:Literal>
                            </span>
                        </div>
                        <div class="info-item">
                            <label>Tamaño</label>
                            <span>
                                <asp:Literal ID="litTamano" runat="server">-</asp:Literal>
                            </span>
                        </div>
                        <div class="info-item">
                            <label>Sexo</label>
                            <span>
                                <asp:Literal ID="litSexo" runat="server">-</asp:Literal>
                            </span>
                        </div>
                        <div class="info-item">
                            <label>Edad aproximada</label>
                            <span>
                                <asp:Literal ID="litEdad" runat="server">-</asp:Literal>
                            </span>
                        </div>
                        <div class="info-item">
                            <label>Fecha del evento</label>
                            <span>
                                <asp:Literal ID="litFecha" runat="server">-</asp:Literal>
                            </span>
                        </div>
                    </div>

                    <hr class="section-divider" />

                    <!-- ── Descripción ── -->
                    <div class="section-label">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2">
                            <line x1="17" y1="10" x2="3" y2="10" />
                            <line x1="21" y1="6" x2="3" y2="6" />
                            <line x1="21" y1="14" x2="3" y2="14" />
                            <line x1="17" y1="18" x2="3" y2="18" />
                        </svg>
                        Descripción
                    </div>
                    <p class="descripcion-text">
                        <asp:Literal ID="litDescripcion" runat="server"></asp:Literal>
                    </p>

                    <!-- ── Mapa de ubicación ── -->
                    <asp:Panel ID="pnlMapa" runat="server">
                        <hr class="section-divider" />
                        <div class="section-label">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
                                <circle cx="12" cy="10" r="3" />
                            </svg>
                            Última ubicación conocida
                        </div>
                        <p class="mapa-ubicacion-text">
                            <asp:Literal ID="litUbicacion" runat="server"></asp:Literal>
                        </p>
                        <div id="mapaDetalle" class="mapa-mini"></div>
                        <asp:HiddenField ID="hfLatDetalle" runat="server" />
                        <asp:HiddenField ID="hfLngDetalle" runat="server" />
                    </asp:Panel>

                    <!-- ── Contacto ── -->
                    <asp:Panel ID="pnlContacto" runat="server">
                        <hr class="section-divider" />
                        <div class="contacto-box">
                            <div class="contacto-title">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#ff6b35"
                                    stroke-width="2">
                                    <path
                                        d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z" />
                                </svg>
                                Datos de Contacto
                            </div>
                            <div class="info-grid">
                                <div class="info-item">
                                    <label>Teléfono</label>
                                    <span>
                                        <asp:HyperLink ID="lnkTelefono" runat="server">
                                            <asp:Literal ID="litTelefono" runat="server"></asp:Literal>
                                        </asp:HyperLink>
                                    </span>
                                </div>
                                <div class="info-item">
                                    <label>Email</label>
                                    <span>
                                        <asp:Literal ID="litEmail" runat="server"></asp:Literal>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnlLoginAviso" runat="server" Visible="false">
                        <div class="login-aviso">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                                <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                            </svg>
                            <span><a href="~/Login/Login.aspx" runat="server">Inicia sesión</a>
                                para ver los datos de contacto del reportante.</span>
                        </div>
                    </asp:Panel>

                    <!-- ── Acciones ── -->
                    <div class="actions-bar">
                        <asp:Panel ID="pnlBtnAvistamiento" runat="server" Visible="false">
                            <asp:HyperLink ID="lnkAvistamiento" runat="server" CssClass="btn-avistamiento">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                                    <circle cx="12" cy="12" r="3" />
                                </svg>
                                Registrar Avistamiento
                            </asp:HyperLink>
                        </asp:Panel>

                        <button type="button" class="btn-share" onclick="compartirReporte()">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <circle cx="18" cy="5" r="3" />
                                <circle cx="6" cy="12" r="3" />
                                <circle cx="18" cy="19" r="3" />
                                <line x1="8.59" y1="13.51" x2="15.42" y2="17.49" />
                                <line x1="15.41" y1="6.51" x2="8.59" y2="10.49" />
                            </svg>
                            Compartir
                        </button>
                    </div>

                    <asp:HiddenField ID="hiddenIdReporte" runat="server" />
                </div>

                <!-- ══ Avistamientos ══ -->
                <div class="avistamientos-card">
                    <div class="avistamientos-title">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#ff6b35" stroke-width="2">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                            <circle cx="12" cy="12" r="3" />
                        </svg>
                        Avistamientos
                        <span class="avistamientos-count">
                            <asp:Literal ID="litTotalAvistamientos" runat="server">0</asp:Literal>
                        </span>
                    </div>

                    <asp:Panel ID="pnlSinAvistamientos" runat="server">
                        <div class="sin-avistamientos">
                            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#ddd"
                                stroke-width="1.5">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                                <circle cx="12" cy="12" r="3" />
                            </svg>
                            <p>Aún no hay avistamientos registrados.<br />¿Viste a esta mascota? Ayúdanos reportándolo.
                            </p>
                        </div>
                    </asp:Panel>

                    <asp:Repeater ID="rptAvistamientos" runat="server">
                        <ItemTemplate>
                            <div class="avistamiento-item">
                                <div
                                    style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:6px; margin-bottom:4px;">
                                    <span class="avistamiento-ubicacion">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2" style="flex-shrink:0;">
                                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
                                            <circle cx="12" cy="10" r="3" />
                                        </svg>
                                        <%# System.Web.HttpUtility.HtmlEncode((Eval("avi_Ubicacion") ?? "" ).ToString())
                                            %>
                                    </span>
                                    <span class="avistamiento-fecha">
                                        <%# Eval("avi_FechaReporte") !=null ?
                                            ((DateTime)Eval("avi_FechaReporte")).ToString("dd/MM/yyyy HH:mm") : "" %>
                                    </span>
                                </div>
                                <p class="avistamiento-desc">
                                    <%# System.Web.HttpUtility.HtmlEncode((Eval("avi_Descripcion") ?? "" ).ToString())
                                        %>
                                </p>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

            </div>
        </asp:Panel>

        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        <script type="text/javascript">
            document.addEventListener('DOMContentLoaded', function () {
                var latEl = document.getElementById('<%= hfLatDetalle.ClientID %>');
                var lngEl = document.getElementById('<%= hfLngDetalle.ClientID %>');

                if (latEl && lngEl) {
                    var lat = latEl.value;
                    var lng = lngEl.value;

                    if (lat && lng) {
                        var mapa = L.map('mapaDetalle').setView([parseFloat(lat), parseFloat(lng)], 15);
                        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                            attribution: '&copy; OpenStreetMap'
                        }).addTo(mapa);

                        var icon = L.divIcon({
                            className: 'custom-marker',
                            html: '<div style="background:#e74c3c;width:36px;height:36px;border-radius:50%;' +
                                'display:flex;align-items:center;justify-content:center;font-size:18px;' +
                                'box-shadow:0 3px 10px rgba(0,0,0,0.35);border:3px solid #fff;">📍</div>',
                            iconSize: [36, 36], iconAnchor: [18, 18]
                        });
                        L.marker([parseFloat(lat), parseFloat(lng)], { icon: icon }).addTo(mapa);
                    }
                }
            });

            function verFotoGrande(src) {
                Swal.fire({
                    imageUrl: src,
                    imageAlt: 'Foto mascota',
                    showConfirmButton: false,
                    showCloseButton: true,
                    background: 'rgba(0,0,0,0.92)',
                    imageWidth: '90%',
                    imageHeight: 'auto',
                    customClass: { popup: 'swal-foto-popup' }
                });
            }

            function compartirReporte() {
                var url = window.location.href;
                if (navigator.share) {
                    navigator.share({
                        title: document.title,
                        text: '¿Has visto a esta mascota? Ayúdanos a encontrarla.',
                        url: url
                    });
                } else {
                    navigator.clipboard.writeText(url).then(function () {
                        Swal.fire({
                            icon: 'success',
                            title: '¡Enlace copiado!',
                            text: 'Comparte el enlace para ayudar a encontrar esta mascota.',
                            timer: 2500,
                            showConfirmButton: false,
                            toast: true,
                            position: 'top-end'
                        });
                    });
                }
            }
        </script>
    </asp:Content>