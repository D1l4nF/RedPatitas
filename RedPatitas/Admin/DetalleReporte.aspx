<%@ Page Title="Detalle de Reporte" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true"
    CodeBehind="DetalleReporte.aspx.cs" Inherits="RedPatitas.Admin.DetalleReporte" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Detalle de Reporte | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link href='<%= ResolveUrl("~/Style/dashboard.css") %>' rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
        <style>
            .detalle-container {
                max-width: 900px;
                margin: 0 auto;
            }

            .detalle-hero {
                background: var(--bg-card, #fff);
                border-radius: 16px;
                padding: 2rem;
                box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
                margin-bottom: 2rem;
            }

            .tipo-badge {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 6px 16px;
                border-radius: 20px;
                font-weight: 700;
                font-size: 0.9rem;
                margin-bottom: 1rem;
            }

            .tipo-perdida {
                background: #fde8e8;
                color: #c0392b;
            }

            .tipo-encontrada {
                background: #e8f8ef;
                color: #1e8449;
            }

            .estado-badge {
                display: inline-block;
                padding: 4px 12px;
                border-radius: 12px;
                font-size: 0.8rem;
                font-weight: 600;
                background: #e8f0fe;
                color: #1a73e8;
                margin-left: 8px;
                vertical-align: middle;
            }

            .foto-galeria {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
                gap: 12px;
                margin: 1.5rem 0;
            }

            .foto-galeria img {
                width: 100%;
                aspect-ratio: 1;
                object-fit: cover;
                border-radius: 10px;
                cursor: pointer;
                transition: transform 0.2s;
            }

            .foto-galeria img:hover {
                transform: scale(1.04);
            }

            .info-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 1.5rem;
                margin: 1.5rem 0;
            }

            @media (max-width: 600px) {
                .info-grid {
                    grid-template-columns: 1fr;
                }
            }

            .info-item label {
                font-size: 0.78rem;
                color: #888;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                display: block;
                margin-bottom: 4px;
            }

            .info-item span {
                font-size: 1rem;
                color: #222;
                font-weight: 500;
            }

            .mapa-mini {
                width: 100%;
                height: 250px;
                border-radius: 12px;
                margin: 1rem 0;
                border: 1px solid #e0e0e0;
                position: relative;
                z-index: 1;
            }

            .contacto-box {
                background: #f8f9fa;
                border-radius: 12px;
                padding: 1.5rem;
                margin: 1.5rem 0;
            }

            .avistamientos-section {
                background: var(--bg-card, #fff);
                border-radius: 16px;
                padding: 2rem;
                box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
                margin-bottom: 2rem;
            }

            .avistamiento-item {
                border-left: 3px solid #1a73e8;
                padding: 1rem 1rem 1rem 1.25rem;
                margin-bottom: 1rem;
                background: #f8f9fa;
                border-radius: 0 8px 8px 0;
            }

            .login-aviso {
                background: #fff3cd;
                border-radius: 10px;
                padding: 1rem 1.5rem;
                font-size: 0.9rem;
                color: #856404;
                margin-top: 1rem;
            }

            .no-encontrado {
                text-align: center;
                padding: 4rem 2rem;
            }

            .btn-back {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 8px 16px;
                border-radius: 8px;
                background: #f0f0f0;
                color: #333;
                text-decoration: none;
                font-weight: 500;
                margin-bottom: 1.5rem;
                font-size: 0.9rem;
                transition: background 0.2s;
            }

            .btn-back:hover {
                background: #e0e0e0;
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">📋 Detalle del Reporte</h1>
            <div class="breadcrumb">
                <a href="MascotasPerdidas.aspx" style="color:inherit; text-decoration:none;">Mascotas Perdidas</a>
                &rsaquo; Detalle
            </div>
        </div>
    </asp:Content>

    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

        <%-- HiddenFields fuera de paneles ocultos para que siempre se rendericen --%>


        <div class="detalle-container">
            <a href="MascotasPerdidas.aspx" class="btn-back">&#8592; Volver a Mascotas Perdidas</a>

            <asp:Panel ID="pnlNoEncontrado" runat="server" Visible="false">
                <div class="no-encontrado">
                    <div style="font-size:4rem;">🔍</div>
                    <h2>Reporte no encontrado</h2>
                    <p style="color:#666; margin-bottom:1.5rem;">El reporte que buscas no existe o fue eliminado.</p>
                    <a href="MascotasPerdidas.aspx" class="btn-primary"
                        style="text-decoration:none; padding:10px 24px; border-radius:10px; display:inline-block;">
                        Ver mascotas perdidas
                    </a>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlDetalle" runat="server">

                <%-- Card principal --%>
                    <div class="detalle-hero">
                        <asp:Literal ID="litTipoBadge" runat="server"></asp:Literal>

                        <h1 style="margin:0 0 0.5rem; font-size:1.8rem;">
                            <asp:Literal ID="litNombreMascota" runat="server">Sin nombre</asp:Literal>
                            <asp:Literal ID="litEstadoBadge" runat="server"></asp:Literal>
                        </h1>

                        <%-- ═══════════ VISTA LECTURA ═══════════ --%>
                        <asp:Panel ID="pnlVistaLectura" runat="server">

                        <%-- Galería de fotos --%>
                            <asp:Panel ID="pnlFotos" runat="server">
                                <div class="foto-galeria">
                                    <asp:Repeater ID="rptFotos" runat="server">
                                        <ItemTemplate>
                                            <img src='<%# ResolveUrl(Eval("fore_Url").ToString()) %>'
                                                alt="Foto de la mascota" onclick="verFotoGrande(this.src)" />
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </asp:Panel>

                            <%-- Datos de la mascota --%>
                                <div class="info-grid">
                                    <div class="info-item">
                                        <label>🐾 Especie</label>
                                        <span>
                                            <asp:Literal ID="litEspecie" runat="server">-</asp:Literal>
                                        </span>
                                    </div>
                                    <div class="info-item">
                                        <label>🎨 Color</label>
                                        <span>
                                            <asp:Literal ID="litColor" runat="server">-</asp:Literal>
                                        </span>
                                    </div>
                                    <div class="info-item">
                                        <label>📏 Tamaño</label>
                                        <span>
                                            <asp:Literal ID="litTamano" runat="server">-</asp:Literal>
                                        </span>
                                    </div>
                                    <div class="info-item">
                                        <label>⚧ Sexo</label>
                                        <span>
                                            <asp:Literal ID="litSexo" runat="server">-</asp:Literal>
                                        </span>
                                    </div>
                                    <div class="info-item">
                                        <label>🎂 Edad aproximada</label>
                                        <span>
                                            <asp:Literal ID="litEdad" runat="server">-</asp:Literal>
                                        </span>
                                    </div>
                                    <div class="info-item">
                                        <label>📅 Fecha del evento</label>
                                        <span>
                                            <asp:Literal ID="litFecha" runat="server">-</asp:Literal>
                                        </span>
                                    </div>
                                </div>

                                <%-- Descripción --%>
                                    <div style="margin-top:1rem;">
                                        <label
                                            style="font-size:0.78rem;color:#888;font-weight:600;text-transform:uppercase;letter-spacing:0.5px;display:block;margin-bottom:6px;">
                                            📋 Descripción
                                        </label>
                                        <p style="margin:0;line-height:1.7;color:#333;">
                                            <asp:Literal ID="litDescripcion" runat="server"></asp:Literal>
                                        </p>
                                    </div>

                                    <%-- Mapa de ubicación --%>
                                        <asp:Panel ID="pnlMapa" runat="server">
                                            <h3 style="margin:1.5rem 0 0.5rem;">📍 Última ubicación conocida</h3>
                                            <p style="font-size:0.9rem;color:#666;margin:0 0 0.5rem;">
                                                <asp:Literal ID="litUbicacion" runat="server"></asp:Literal>
                                            </p>
                                            <div id="mapaDetalle" class="mapa-mini"></div>
                                            <asp:HiddenField ID="hfLatDetalle" runat="server" />
                                            <asp:HiddenField ID="hfLngDetalle" runat="server" />
                                        </asp:Panel>

                                        <%-- Datos de contacto --%>
                                            <asp:Panel ID="pnlContacto" runat="server">
                                                <div class="contacto-box">
                                                    <h3 style="margin:0 0 1rem;">📞 Datos de contacto</h3>
                                                    <div class="info-grid">
                                                        <div class="info-item">
                                                            <label>Teléfono</label>
                                                            <span>
                                                                <asp:HyperLink ID="lnkTelefono" runat="server">
                                                                    <asp:Literal ID="litTelefono" runat="server">
                                                                    </asp:Literal>
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
                                                    🔒 <a href='<%= ResolveUrl("~/Login/Login.aspx") %>'>Inicia
                                                        sesión</a>
                                                    para ver los datos de contacto del reportante.
                                                </div>
                                            </asp:Panel>

                                            <%-- Botón registrar avistamiento --%>
                                                <asp:Panel ID="pnlBtnAvistamiento" runat="server" Visible="false">
                                                    <asp:HyperLink ID="lnkAvistamiento" runat="server"
                                                        CssClass="btn-primary"
                                                        style="display:inline-block; text-decoration:none; padding:12px 24px; border-radius:10px; margin-top:1rem;">
                                                        👁 Registrar Avistamiento
                                                    </asp:HyperLink>
                                                </asp:Panel>

                                                <asp:HiddenField ID="hiddenIdReporte" runat="server" />

                        </asp:Panel>



                    </div>

                    <%-- Avistamientos --%>
                        <div class="avistamientos-section">
                            <h2 style="margin:0 0 1.5rem;">
                                👁 Avistamientos
                                (<asp:Literal ID="litTotalAvistamientos" runat="server">0</asp:Literal>)
                            </h2>

                            <asp:Panel ID="pnlSinAvistamientos" runat="server">
                                <p style="color:#888; text-align:center; padding:2rem;">
                                    Aún no hay avistamientos registrados.
                                </p>
                            </asp:Panel>

                            <asp:Repeater ID="rptAvistamientos" runat="server">
                                <ItemTemplate>
                                    <div class="avistamiento-item">
                                        <div
                                            style="display:flex; justify-content:space-between; margin-bottom:6px; flex-wrap:wrap; gap:4px;">
                                            <strong>📍 <%# System.Web.HttpUtility.HtmlEncode((Eval("avi_Ubicacion")
                                                    ?? "" ).ToString()) %></strong>
                                            <span style="font-size:0.82rem; color:#888;">
                                                <%# Eval("avi_FechaReporte") !=null ?
                                                    ((DateTime)Eval("avi_FechaReporte")).ToString("dd/MM/yyyy HH:mm")
                                                    : "" %>
                                            </span>
                                        </div>
                                        <p style="margin:0; color:#555; font-size:0.92rem;">
                                            <%# System.Web.HttpUtility.HtmlEncode((Eval("avi_Descripcion") ?? ""
                                                ).ToString()) %>
                                        </p>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>

            </asp:Panel>
        </div>

        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        <script src='<%= ResolveUrl("~/Js/mapas-reportes.js") %>'></script>
        <script type="text/javascript">
            document.addEventListener('DOMContentLoaded', function () {
                var lat = document.getElementById('<%= hfLatDetalle.ClientID %>').value;
                var lng = document.getElementById('<%= hfLngDetalle.ClientID %>').value;

                if (lat && lng) {
                    var mapa = L.map('mapaDetalle').setView([parseFloat(lat), parseFloat(lng)], 15);
                    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                        attribution: '© OpenStreetMap'
                    }).addTo(mapa);

                    var icon = L.divIcon({
                        className: 'custom-marker',
                        html: '<div style="background:#e74c3c;width:36px;height:36px;border-radius:50%;' +
                            'display:flex;align-items:center;justify-content:center;font-size:18px;' +
                            'box-shadow:0 2px 8px rgba(0,0,0,0.4);">📍</div>',
                        iconSize: [36, 36], iconAnchor: [18, 18]
                    });
                    L.marker([parseFloat(lat), parseFloat(lng)], { icon: icon }).addTo(mapa);
                    
                    setTimeout(function() { mapa.invalidateSize(); }, 300);
                } else {
                    var mapaDiv = document.getElementById('mapaDetalle');
                    if (mapaDiv) mapaDiv.style.display = 'none';
                }
            });

            function verFotoGrande(src) {
                Swal.fire({
                    imageUrl: src, imageAlt: 'Foto mascota',
                    showConfirmButton: false, showCloseButton: true,
                    background: 'rgba(0,0,0,0.9)',
                    imageWidth: '90%', imageHeight: 'auto'
                });
            }


        </script>
    </asp:Content>