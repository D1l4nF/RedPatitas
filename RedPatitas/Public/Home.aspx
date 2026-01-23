<%@ Page Title="" Language="C#" MasterPageFile="~/Public/Public.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs"
    Inherits="RedPatitas.Public.Home" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        RedPatitas - Una red que une hogares y corazones
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
        <section class="hero" id="inicio">
            <div class="hero-container">
                <div class="hero-content">
                    <h1 class="hero-title">Una red que une hogares y corazones</h1>
                    <p class="hero-subtitle">
                        Conectamos mascotas con familias que les darán amor y cuidado para toda la vida
                    </p>
                    <div class="hero-actions">
                        <a href="~/Public/Adopta.aspx" runat="server" class="btn btn-primary">
                            <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
                                <path
                                    d="M12,11.36C12.55,11.36 13,10.91 13,10.36V8.36C13,7.81 12.55,7.36 12,7.36C11.45,7.36 11,7.81 11,8.36V10.36C11,10.91 11.45,11.36 12,11.36M12,12.36C10.5,12.36 9.1,12.76 7.9,13.46C7.3,12.86 6.4,12.36 5.5,12.36C3.5,12.36 2,13.86 2,15.86C2,17.86 3.5,19.36 5.5,19.36C6.5,19.36 7.4,18.96 8.1,18.26C9,19.56 10.4,20.36 12,20.36C13.6,20.36 15,19.56 15.9,18.26C16.6,18.96 17.5,19.36 18.5,19.36C20.5,19.36 22,17.86 22,15.86C22,13.86 20.5,12.36 18.5,12.36C17.6,12.36 16.7,12.86 16.1,13.46C14.9,12.76 13.5,12.36 12,12.36Z" />
                            </svg>
                            Adoptar
                        </a>
                        <a href="~/Public/registro.aspx" runat="server" class="btn btn-secondary">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                stroke-linecap="round" stroke-linejoin="round" width="20" height="20">
                                <path d="M12 5v14M5 12h14" />
                            </svg>
                            Publicar Mascota
                        </a>
                    </div>
                </div>
                <div class="hero-image">
                    <div class="hero-pets-illustration">
                        <span class="floating-pet" style="--delay: 0s; --x: 0; --y: -40px;">🐕</span>
                        <span class="floating-pet" style="--delay: 0.5s; --x: 100px; --y: -20px;">🐱</span>
                        <span class="floating-pet" style="--delay: 1s; --x: -20px; --y: 60px;">🐰</span>
                        <span class="floating-pet" style="--delay: 1.5s; --x: 80px; --y: 80px;">🐦</span>
                    </div>
                </div>
            </div>
        </section>
        <!-- Impact Section -->
        <section class="impact">
            <div class="impact-container">
                <h2 class="section-title">Impacto Social</h2>
                <div class="impact-grid">
                    <div class="impact-card">
                        <div class="impact-icon">🐾</div>
                        <div class="impact-number">1,247</div>
                        <div class="impact-label">Mascotas adoptadas</div>
                    </div>
                    <div class="impact-card">
                        <div class="impact-icon">🏠</div>
                        <div class="impact-number">892</div>
                        <div class="impact-label">Hogares felices</div>
                    </div>
                    <div class="impact-card">
                        <div class="impact-icon">🤝</div>
                        <div class="impact-number">34</div>
                        <div class="impact-label">Refugios aliados</div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Featured Pets Section -->
        <section class="featured-pets">
            <div class="featured-container">
                <h2 class="section-title">Mascotas Destacadas</h2>
                <asp:Repeater ID="rptMascotasDestacadas" runat="server">
                    <HeaderTemplate>
                        <div class="pets-grid">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="pet-card">
                            <div class="pet-image">
                                <%# Eval("EmojiEspecie") %>
                            </div>
                            <div class="pet-info">
                                <h3 class="pet-name">
                                    <%# Eval("Nombre") %>
                                </h3>
                                <p class="pet-details">
                                    <%# Eval("Raza") %> • <%# Eval("EdadFormateada") %> • <%# Eval("Sexo") %>
                                </p>
                                <a href='<%# "~/Public/PerfilMascota.aspx?id=" + Eval("IdMascota") %>' runat="server"
                                    class="btn-view-profile">Ver perfil</a>
                            </div>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
            </div>
            </FooterTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlSinMascotasHome" runat="server" Visible="false" CssClass="no-pets-message"
                style="text-align: center; padding: 2rem;">
                <p style="color: #999;">Próximamente tendremos mascotas disponibles. ¡Vuelve pronto!</p>
            </asp:Panel>
        </section>

        <!-- Allied Shelters Section -->
        <section id="aliados" class="allied-shelters" style="background: #FFF8F0; padding: 4rem 1rem;">
            <div class="container" style="max-width: 1200px; margin: 0 auto; text-align: center;">
                <h2 class="section-title">Nuestros Aliados</h2>
                <asp:Repeater ID="rptAliados" runat="server">
                    <HeaderTemplate>
                        <div class="allies-grid"
                            style="display: flex; justify-content: center; flex-wrap: wrap; gap: 2rem; align-items: center;">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="ally-card" onclick="showShelterModal(this)" data-id='<%# Eval("IdRefugio") %>'
                            data-nombre='<%# HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("Nombre"))) %>'
                            data-ciudad='<%# HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("Ciudad"))) %>'
                            data-descripcion='<%# HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("Descripcion"))) %>'
                            data-telefono='<%# HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("Telefono"))) %>'
                            data-direccion='<%# HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("Direccion"))) %>'
                            data-lat='<%# Eval("Latitud") %>' data-lon='<%# Eval("Longitud") %>'
                            data-logo='<%# ResolveUrl(Convert.ToString(Eval("LogoUrl"))) %>'
                            data-email='<%# HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("Email"))) %>'
                            data-anio='<%# Eval("AnioFundacion") %>' data-adoptadas='<%# Eval("MascotasAdoptadas") %>'
                            data-disponibles='<%# Eval("MascotasDisponibles") %>'
                            data-facebook='<%# HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("FacebookUrl"))) %>'
                            data-instagram='<%# HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("InstagramUrl"))) %>'
                            data-horario='<%# HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("HorarioAtencion"))) %>'
                            data-donacion='<%# HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("CuentaDonacion"))) %>'
                            style="background: white; padding: 1.5rem; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); transition: transform 0.3s; width: 180px; display: flex; flex-direction: column; align-items: center; gap: 0.5rem; cursor: pointer;">
                            <img src='<%# ResolveUrl(Convert.ToString(Eval("LogoUrl"))) %>' alt='<%# Eval("Nombre") %>'
                                style="width: 80px; height: 80px; object-fit: contain; border-radius: 50%; background: #f9f9f9;"
                                onerror="this.src='../Images/default-shelter.png'" />
                            <h4 style="font-size: 0.9rem; color: #4A3B32; margin: 0;">
                                <%# Eval("Nombre") %>
                            </h4>
                            <span style="font-size: 0.8rem; color: #999;">
                                <%# Eval("Ciudad") %>
                            </span>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
            </div>
            </FooterTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlSinAliados" runat="server" Visible="false">
                <p style="color: #999;">Sé el primer refugio aliado de nuestra red.</p>
            </asp:Panel>
            </div>
        </section>

        <!-- Shelter Detail Modal (Premium Design) -->
        <style>
            @keyframes modalSlideIn {
                from {
                    opacity: 0;
                    transform: scale(0.95) translateY(20px);
                }

                to {
                    opacity: 1;
                    transform: scale(1) translateY(0);
                }
            }

            .ally-modal-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.7);
                backdrop-filter: blur(4px);
                z-index: 9999;
                align-items: center;
                justify-content: center;
                overflow-y: auto;
                padding: 1rem;
            }

            .ally-modal-content {
                background: #fff;
                border-radius: 20px;
                width: 95%;
                max-width: 480px;
                position: relative;
                animation: modalSlideIn 0.35s cubic-bezier(0.16, 1, 0.3, 1);
                box-shadow: 0 25px 60px rgba(0, 0, 0, 0.3);
                max-height: 90vh;
                overflow-y: auto;
            }

            .ally-modal-close {
                position: absolute;
                top: 12px;
                right: 12px;
                background: rgba(255, 255, 255, 0.9);
                border: none;
                font-size: 1.3rem;
                cursor: pointer;
                width: 36px;
                height: 36px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 10;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
                transition: transform 0.2s;
            }

            .ally-modal-close:hover {
                transform: scale(1.1);
            }

            .ally-modal-header {
                background: linear-gradient(135deg, #FF8C42 0%, #FF6B35 50%, #E85D25 100%);
                padding: 1.25rem 1.25rem 1rem;
                text-align: center;
                color: white;
                border-radius: 20px 20px 0 0;
            }

            .ally-modal-logo {
                width: 70px;
                height: 70px;
                border-radius: 50%;
                object-fit: cover;
                background: white;
                border: 3px solid rgba(255, 255, 255, 0.4);
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            }

            .ally-modal-stats {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 10px;
                padding: 0.75rem 1.25rem;
                background: #FDFAF8;
            }

            .ally-stat-card {
                text-align: center;
                padding: 0.6rem 0.5rem;
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            }

            .ally-stat-icon {
                font-size: 1.2rem;
            }

            .ally-stat-number {
                font-size: 1.4rem;
                font-weight: 700;
            }

            .ally-stat-label {
                font-size: 0.65rem;
                color: #888;
                text-transform: uppercase;
            }

            .ally-modal-body {
                padding: 0.75rem 1.25rem 1rem;
            }

            .ally-info-card {
                background: #f9f9f9;
                border-radius: 10px;
                padding: 0.6rem 0.8rem;
                margin-bottom: 0.75rem;
            }

            .ally-info-row {
                display: flex;
                gap: 8px;
                align-items: center;
                padding: 5px 0;
                font-size: 0.85rem;
                color: #444;
                border-bottom: 1px solid rgba(0, 0, 0, 0.04);
            }

            .ally-info-row:last-child {
                border-bottom: none;
            }

            .ally-info-icon {
                width: 20px;
                text-align: center;
                flex-shrink: 0;
            }

            .ally-social-links {
                display: flex;
                justify-content: center;
                gap: 10px;
                margin-bottom: 0.75rem;
            }

            .ally-social-btn {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                text-decoration: none;
                transition: transform 0.2s;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
            }

            .ally-social-btn:hover {
                transform: scale(1.1);
            }

            .ally-social-btn svg {
                width: 20px;
                height: 20px;
            }

            .ally-social-btn.facebook {
                background: #4267B2;
            }

            .ally-social-btn.facebook svg {
                fill: white;
            }

            .ally-social-btn.instagram {
                background: linear-gradient(45deg, #f09433, #dc2743, #bc1888);
            }

            .ally-social-btn.instagram svg {
                fill: white;
            }

            .ally-social-btn.whatsapp {
                background: #25D366;
            }

            .ally-social-btn.whatsapp svg {
                fill: white;
            }

            .ally-social-btn.facebook {
                background: linear-gradient(135deg, #4267B2, #3b5998);
            }

            .ally-social-btn.instagram {
                background: linear-gradient(45deg, #f09433, #e6683c, #dc2743, #cc2366, #bc1888);
            }

            .ally-social-btn.whatsapp {
                background: linear-gradient(135deg, #25D366, #128C7E);
            }

            .ally-action-btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 6px;
                padding: 10px 16px;
                border-radius: 10px;
                font-weight: 600;
                font-size: 0.85rem;
                text-decoration: none;
                transition: all 0.2s;
                flex: 1;
            }

            .ally-action-btn.primary {
                background: linear-gradient(135deg, #FF8C42, #FF6B35);
                color: white;
            }

            .ally-action-btn.secondary {
                background: linear-gradient(135deg, #27AE60, #219150);
                color: white;
            }

            .ally-action-btn.donate {
                background: linear-gradient(135deg, #E74C3C, #C0392B);
                color: white;
            }

            .ally-action-btn:hover {
                transform: translateY(-2px);
                opacity: 0.95;
            }

            .ally-action-buttons {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
            }
        </style>

        <div id="allyModal" class="ally-modal-overlay">
            <div class="ally-modal-content">
                <!-- Close Button -->
                <button type="button" onclick="closeAllyModal()" class="ally-modal-close">&times;</button>

                <!-- Header -->
                <div class="ally-modal-header">
                    <img id="modalLogo" src="" alt="Logo" class="ally-modal-logo" />
                    <h2 id="modalName" style="margin: 0.5rem 0 0.15rem; font-size: 1.25rem; font-weight: 700;">Nombre
                        Refugio</h2>
                    <span id="modalCity" style="font-size: 0.85rem;">📍 Ciudad</span>
                    <span id="modalYear" style="display: block; font-size: 0.75rem; opacity: 0.85; margin-top: 2px;">🏛️
                        Desde 2026</span>
                </div>

                <!-- Statistics -->
                <div class="ally-modal-stats">
                    <div class="ally-stat-card">
                        <div class="ally-stat-icon">🏠</div>
                        <div class="ally-stat-number" id="statAdoptadas" style="color: #27AE60;">0</div>
                        <div class="ally-stat-label">Adoptadas</div>
                    </div>
                    <div class="ally-stat-card">
                        <div class="ally-stat-icon">🐾</div>
                        <div class="ally-stat-number" id="statDisponibles" style="color: #3498DB;">0</div>
                        <div class="ally-stat-label">En espera</div>
                    </div>
                </div>

                <!-- Body -->
                <div class="ally-modal-body">
                    <!-- Description -->
                    <p id="modalDesc" style="color: #555; line-height: 1.5; margin: 0 0 0.6rem; font-size: 0.85rem;">
                    </p>

                    <!-- Contact Info Card -->
                    <div class="ally-info-card">
                        <div class="ally-info-row">
                            <span class="ally-info-icon">📍</span>
                            <span id="modalAddress" style="flex: 1;">Dirección</span>
                        </div>
                        <div class="ally-info-row">
                            <span class="ally-info-icon">📞</span>
                            <span id="modalPhone">Teléfono</span>
                        </div>
                        <div id="emailRow" class="ally-info-row" style="display: none;">
                            <span class="ally-info-icon">✉️</span>
                            <a id="modalEmail" href="" style="color: #FF8C42; text-decoration: none;">email</a>
                        </div>
                        <div id="horarioRow" class="ally-info-row" style="display: none;">
                            <span class="ally-info-icon">🕐</span>
                            <span id="modalHorario">Horario</span>
                        </div>
                    </div>

                    <!-- Social Links -->
                    <div id="socialLinks" class="ally-social-links" style="display: none;">
                        <a id="btnFacebook" href="#" target="_blank" title="Facebook" class="ally-social-btn facebook"
                            style="display: none;">
                            <svg viewBox="0 0 24 24">
                                <path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z" />
                            </svg>
                        </a>
                        <a id="btnInstagram" href="#" target="_blank" title="Instagram"
                            class="ally-social-btn instagram" style="display: none;">
                            <svg viewBox="0 0 24 24">
                                <rect x="2" y="2" width="20" height="20" rx="5" ry="5" />
                                <circle cx="12" cy="12" r="4" fill="none" stroke="#fff" stroke-width="2" />
                                <circle cx="17.5" cy="6.5" r="1.5" fill="#fff" />
                            </svg>
                        </a>
                        <a id="btnWhatsApp" href="#" target="_blank" title="WhatsApp" class="ally-social-btn whatsapp"
                            style="display: none;">
                            <svg viewBox="0 0 24 24">
                                <path
                                    d="M12 2C6.48 2 2 6.48 2 12c0 1.85.5 3.58 1.37 5.07L2 22l4.93-1.37C8.42 21.5 10.15 22 12 22c5.52 0 10-4.48 10-10S17.52 2 12 2zm5.46 14.12c-.23.64-1.34 1.23-1.85 1.31-.48.07-.95.14-3.05-.64-2.54-1-4.15-3.61-4.28-3.78-.12-.17-1.01-1.34-1.01-2.56 0-1.22.64-1.82.87-2.07.23-.25.5-.31.67-.31h.48c.15 0 .36-.06.56.43.2.49.7 1.71.76 1.83.06.12.1.27.02.43-.08.16-.12.26-.24.4l-.37.43c-.12.12-.25.26-.11.51.14.25.64 1.05 1.37 1.7.94.84 1.74 1.1 1.99 1.22.25.12.39.1.54-.06.14-.16.62-.72.79-.97.17-.25.33-.21.56-.12.23.09 1.44.68 1.69.8.25.12.41.18.47.28.06.1.06.58-.17 1.22z" />
                            </svg>
                        </a>
                    </div>

                    <!-- Action Buttons -->
                    <div class="ally-action-buttons">
                        <a id="btnMascotas" href="#" class="ally-action-btn primary">🐕 Ver Mascotas</a>
                        <a id="btnMaps" href="#" target="_blank" class="ally-action-btn secondary">🗺️ Cómo llegar</a>
                        <a id="btnDonar" href="#" target="_blank" class="ally-action-btn donate"
                            style="display: none;">❤️ Donar</a>
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            // Expose function globally
            window.showShelterModal = function (card) {
                try {
                    const modal = document.getElementById('allyModal');
                    if (!modal) return;

                    // Basic fields
                    document.getElementById('modalLogo').src = card.dataset.logo || '../Images/default-shelter.png';
                    document.getElementById('modalName').innerText = card.dataset.nombre || 'Refugio';
                    document.getElementById('modalCity').innerText = '📍 ' + (card.dataset.ciudad || 'Ciudad no especificada');
                    document.getElementById('modalDesc').innerText = card.dataset.descripcion || 'Sin descripción disponible.';
                    document.getElementById('modalAddress').innerText = card.dataset.direccion || 'No registrada';
                    document.getElementById('modalPhone').innerText = card.dataset.telefono || 'No registrado';

                    // Year of foundation
                    const yearEl = document.getElementById('modalYear');
                    if (card.dataset.anio && card.dataset.anio !== '') {
                        yearEl.innerText = '🏛️ Desde ' + card.dataset.anio;
                        yearEl.style.display = 'block';
                    } else {
                        yearEl.style.display = 'none';
                    }

                    // Statistics
                    document.getElementById('statAdoptadas').innerText = card.dataset.adoptadas || '0';
                    document.getElementById('statDisponibles').innerText = card.dataset.disponibles || '0';

                    // Email
                    const emailRow = document.getElementById('emailRow');
                    const emailLink = document.getElementById('modalEmail');
                    if (card.dataset.email && card.dataset.email.trim() !== '') {
                        emailLink.href = 'mailto:' + card.dataset.email;
                        emailLink.innerText = card.dataset.email;
                        emailRow.style.display = 'flex';
                    } else {
                        emailRow.style.display = 'none';
                    }

                    // Horario
                    const horarioRow = document.getElementById('horarioRow');
                    if (card.dataset.horario && card.dataset.horario.trim() !== '') {
                        document.getElementById('modalHorario').innerText = card.dataset.horario;
                        horarioRow.style.display = 'flex';
                    } else {
                        horarioRow.style.display = 'none';
                    }

                    // Social Links
                    const socialLinks = document.getElementById('socialLinks');
                    const btnFacebook = document.getElementById('btnFacebook');
                    const btnInstagram = document.getElementById('btnInstagram');
                    const btnWhatsApp = document.getElementById('btnWhatsApp');
                    let hasSocial = false;

                    // Facebook
                    if (card.dataset.facebook && card.dataset.facebook.trim() !== '') {
                        btnFacebook.href = card.dataset.facebook;
                        btnFacebook.style.display = 'flex';
                        hasSocial = true;
                    } else {
                        btnFacebook.style.display = 'none';
                    }

                    // Instagram
                    if (card.dataset.instagram && card.dataset.instagram.trim() !== '') {
                        btnInstagram.href = card.dataset.instagram;
                        btnInstagram.style.display = 'flex';
                        hasSocial = true;
                    } else {
                        btnInstagram.style.display = 'none';
                    }

                    // WhatsApp (from phone number)
                    if (card.dataset.telefono && card.dataset.telefono.trim() !== '') {
                        // Clean phone: remove spaces, dashes, parentheses
                        let cleanPhone = card.dataset.telefono.replace(/[\s\-\(\)]/g, '');
                        // Remove leading 0 if present and add country code if needed
                        if (cleanPhone.startsWith('0')) {
                            cleanPhone = '593' + cleanPhone.substring(1); // Ecuador default
                        } else if (!cleanPhone.startsWith('+') && !cleanPhone.startsWith('593')) {
                            cleanPhone = '593' + cleanPhone;
                        }
                        cleanPhone = cleanPhone.replace('+', '');
                        btnWhatsApp.href = 'https://wa.me/' + cleanPhone;
                        btnWhatsApp.style.display = 'flex';
                        hasSocial = true;
                    } else {
                        btnWhatsApp.style.display = 'none';
                    }

                    socialLinks.style.display = hasSocial ? 'flex' : 'none';

                    // Ver Mascotas button
                    const btnMascotas = document.getElementById('btnMascotas');
                    if (card.dataset.id) {
                        btnMascotas.href = 'Adopta.aspx?refugio=' + card.dataset.id;
                    } else {
                        btnMascotas.href = 'Adopta.aspx';
                    }

                    // Google Maps link
                    const btnMaps = document.getElementById('btnMaps');
                    let mapsUrl = 'https://www.google.com/maps/search/?api=1&query=';
                    if (card.dataset.lat && card.dataset.lon && card.dataset.lat.trim() !== '') {
                        let lat = card.dataset.lat.replace(',', '.');
                        let lon = card.dataset.lon.replace(',', '.');
                        mapsUrl = 'https://www.google.com/maps/dir/?api=1&destination=' + lat + ',' + lon;
                    } else {
                        let addressString = (card.dataset.direccion || '') + ', ' + (card.dataset.ciudad || '');
                        mapsUrl += encodeURIComponent(addressString);
                    }
                    btnMaps.href = mapsUrl;

                    // Donation button
                    const btnDonar = document.getElementById('btnDonar');
                    if (card.dataset.donacion && card.dataset.donacion.trim() !== '') {
                        btnDonar.href = card.dataset.donacion;
                        btnDonar.style.display = 'flex';
                    } else {
                        btnDonar.style.display = 'none';
                    }

                    // Show modal
                    modal.style.setProperty('display', 'flex', 'important');
                    document.body.style.overflow = 'hidden'; // Prevent background scroll

                } catch (e) {
                    console.error('Error showing modal:', e);
                }
            }

            function closeAllyModal() {
                const modal = document.getElementById('allyModal');
                if (modal) {
                    modal.style.display = 'none';
                    document.body.style.overflow = ''; // Restore scroll
                }
            }

            // Close on outside click
            document.addEventListener('click', function (event) {
                const modal = document.getElementById('allyModal');
                if (event.target === modal) {
                    closeAllyModal();
                }
            });

            // Close on Escape key
            document.addEventListener('keydown', function (event) {
                if (event.key === 'Escape') {
                    closeAllyModal();
                }
            });
        </script>



        <!-- Lost & Found Section -->
        <section class="lost-found">
            <div class="lost-found-container">
                <div class="lost-found-content">
                    <h2 class="lost-found-title">¿Perdiste o Encontraste una Mascota?</h2>
                    <p class="lost-found-desc">
                        Nuestra comunidad ayuda a reunir mascotas perdidas con sus familias. Publica
                        un reporte y miles de personas podrán ayudarte.
                    </p>
                    <div class="lost-found-actions">
                        <a href="~/Public/Reportar.aspx" runat="server" class="btn btn-lost">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20"
                                height="20">
                                <circle cx="11" cy="11" r="8"></circle>
                                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                            </svg>
                            Reportar Mascota Perdida
                        </a>
                        <a href="~/Public/Reportar.aspx" runat="server" class="btn btn-found">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20"
                                height="20">
                                <path
                                    d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                </path>
                            </svg>
                            Reportar Mascota Encontrada
                        </a>
                    </div>
                </div>
                <div class="lost-found-illustration">
                    <span class="lf-emoji">🔍</span>
                    <span class="lf-emoji secondary">🐕</span>
                </div>
            </div>
        </section>

        <!-- Testimonials Section -->
        <section class="testimonials">
            <div class="testimonials-container">
                <h2 class="section-title">Historias de Éxito</h2>
                <div class="testimonials-grid">
                    <div class="testimonial-card">
                        <div class="testimonial-content">
                            <p>
                                "Adoptamos a Luna hace 6 meses y ha cambiado nuestras vidas. El proceso fue
                                fácil y el
                                equipo
                                de RedPatitas nos acompañó en todo momento."
                            </p>
                        </div>
                        <div class="testimonial-author">
                            <div class="author-avatar">MG</div>
                            <div class="author-info">
                                <span class="author-name">María González</span>
                                <span class="author-pet">Adoptó a Luna 🐱</span>
                            </div>
                        </div>
                    </div>
                    <div class="testimonial-card">
                        <div class="testimonial-content">
                            <p>
                                "Gracias a RedPatitas encontré a mi perrito Max después de 3 días perdido. La
                                comunidad
                                es
                                increíble y muy solidaria."
                            </p>
                        </div>
                        <div class="testimonial-author">
                            <div class="author-avatar">CR</div>
                            <div class="author-info">
                                <span class="author-name">Carlos Ruiz</span>
                                <span class="author-pet">Reencontró a Max 🐕</span>
                            </div>
                        </div>
                    </div>
                    <div class="testimonial-card">
                        <div class="testimonial-content">
                            <p>
                                "Como refugio, RedPatitas nos ha ayudado a encontrar hogares para más de 50
                                mascotas. Es
                                una
                                herramienta indispensable."
                            </p>
                        </div>
                        <div class="testimonial-author">
                            <div class="author-avatar">RE</div>
                            <div class="author-info">
                                <span class="author-name">Refugio Esperanza</span>
                                <span class="author-pet">Refugio Aliado 🏠</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- How to Help Section -->
        <section class="how-to-help" id="ayuda">
            <div class="help-container">
                <h2 class="help-title">¿Cómo Ayudar?</h2>
                <div class="help-grid">
                    <div class="help-card">
                        <div class="help-icon">🙋‍♀️</div>
                        <h3 class="help-card-title">Voluntariado</h3>
                        <p class="help-description">
                            Únete a nuestro equipo y ayuda a cuidar, pasear y socializar a las
                            mascotas en espera de un hogar.
                        </p>
                    </div>
                    <div class="help-card">
                        <div class="help-icon">💝</div>
                        <h3 class="help-card-title">Donar</h3>
                        <p class="help-description">
                            Tu donación ayuda a cubrir gastos médicos, alimento y cuidados
                            esenciales para las mascotas.
                        </p>
                    </div>
                    <div class="help-card">
                        <div class="help-icon">📢</div>
                        <h3 class="help-card-title">Difundir</h3>
                        <p class="help-description">
                            Comparte nuestras publicaciones en redes sociales y ayuda a que más
                            mascotas encuentren hogar.
                        </p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Final CTA Section -->
        <section class="final-cta">
            <div class="cta-container">
                <h2 class="cta-title">¿Listo para Cambiar una Vida?</h2>
                <p class="cta-subtitle">Miles de mascotas esperan encontrar una familia. Tú puedes ser esa
                    familia.</p>
                <div class="cta-actions">
                    <a href="~/Public/Adopta.aspx" runat="server" class="btn btn-cta-primary">
                        <svg viewBox="0 0 24 24" fill="currentColor" width="22" height="22">
                            <path
                                d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
                        </svg>
                        Adoptar Ahora
                    </a>
                    <a href="~/Login/Registro.aspx" runat="server" class="btn btn-cta-secondary">Crear Cuenta
                        Gratis</a>
                </div>
            </div>
        </section>

        <!-- Shelter Detail Modal -->
        <div id="allyModal" class="modal-overlay"
            style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center;">
            <div class="modal-content"
                style="background: white; border-radius: 16px; width: 90%; max-width: 500px; padding: 2rem; position: relative; animation: slideIn 0.3s ease; box-shadow: 0 10px 30px rgba(0,0,0,0.2);">
                <button type="button" onclick="closeAllyModal()"
                    style="position: absolute; top: 1rem; right: 1rem; background: none; border: none; font-size: 1.5rem; cursor: pointer;">&times;</button>

                <div style="text-align: center; margin-bottom: 1.5rem;">
                    <img id="modalLogo" src="" alt="Logo"
                        style="width: 100px; height: 100px; border-radius: 50%; object-fit: contain; background: #f9f9f9; margin-bottom: 1rem;" />
                    <h2 id="modalName" style="color: #4A3B32; margin-bottom: 0.5rem;">Nombre Refugio</h2>
                    <span id="modalCity" style="color: #FF8C42; font-weight: 600;">Ciudad</span>
                </div>

                <div style="margin-bottom: 2rem;">
                    <p id="modalDesc" style="color: #666; line-height: 1.6; margin-bottom: 1rem;">Descripción...</p>
                    <div style="display: flex; gap: 0.5rem; color: #444; margin-bottom: 0.5rem;">
                        <strong>📍 Dirección:</strong> <span id="modalAddress">Dirección...</span>
                    </div>
                    <div style="display: flex; gap: 0.5rem; color: #444;">
                        <strong>📞 Teléfono:</strong> <span id="modalPhone">099...</span>
                    </div>
                </div>

                <a id="btnMaps" href="#" target="_blank" class="btn-primary"
                    style="display: block; width: 100%; text-align: center; padding: 1rem; background: #27AE60; color: white; text-decoration: none; border-radius: 8px; font-weight: 600;">
                    🗺️ Cómo llegar (Google Maps)
                </a>
            </div>
        </div>

    </asp:Content>