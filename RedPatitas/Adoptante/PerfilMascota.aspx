<%@ Page Title="Perfil de Mascota" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true"
    CodeBehind="PerfilMascota.aspx.cs" Inherits="RedPatitas.Adoptante.PerfilMascota" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        <asp:Literal ID="litTitulo" runat="server">Perfil de Mascota</asp:Literal> | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link href='<%= ResolveUrl("~/Style/dashboard.css") %>' rel="stylesheet" type="text/css" />
        <link href='<%= ResolveUrl("~/Style/pet-cards.css") %>' rel="stylesheet" type="text/css" />
        <style>
            /* Ajustes específicos para el perfil dentro del panel */
            .content-wrapper {
                padding-bottom: 100px;
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header"
            style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
            <div>
                <h1 class="page-title">🐾 Perfil de Mascota</h1>
                <div class="breadcrumb">
                    <a href='<%= ResolveUrl("~/Adoptante/Mascotas.aspx") %>'
                        style="color: var(--primary-color); text-decoration: none;">Buscar
                        Mascotas</a>
                    / <asp:Literal ID="litNombreBreadcrumb" runat="server">Mascota</asp:Literal>
                </div>
            </div>
            <a href='<%= ResolveUrl("~/Adoptante/Mascotas.aspx") %>' class="btn-secondary"
                style="display: inline-flex; align-items: center; gap: 0.5rem; padding: 0.6rem 1.25rem; background: #f5f5f5; border-radius: 8px; text-decoration: none; color: #666; font-weight: 500; transition: all 0.3s ease;">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18">
                    <path d="M19 12H5M12 19l-7-7 7-7" />
                </svg>
                Volver
            </a>
        </div>
    </asp:Content>

    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

        <asp:Panel ID="pnlMascota" runat="server">
            <div class="pet-profile-container">

                <!-- Sticky Photo Sidebar (Left) -->
                <aside class="pet-profile-sidebar">
                    <div class="sidebar-photo-wrapper">
                        <!-- Main Pet Image -->
                        <div class="pet-main-image">
                            <asp:Image ID="imgMascota" runat="server" Visible="false" />
                            <asp:Literal ID="litEmojiGrande" runat="server"></asp:Literal>
                        </div>

                        <!-- View All Photos Button -->
                        <button type="button" class="btn-view-gallery" id="openGallery">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                stroke-linecap="round" stroke-linejoin="round" width="20" height="20">
                                <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                <circle cx="8.5" cy="8.5" r="1.5" />
                                <path d="M21 15l-5-5L5 21" />
                            </svg>
                            Ver todas las fotos
                        </button>

                        <!-- Quick Actions -->
                        <div style="display: flex; gap: 0.75rem;">
                            <asp:LinkButton ID="btnFavorito" runat="server" CssClass="btn-view-gallery"
                                style="flex: 1; background: #fff; border: 2px solid #FF6B6B; color: #FF6B6B;"
                                OnClick="btnFavorito_Click">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20"
                                    height="20">
                                    <path
                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                </svg>
                                Favorito
                            </asp:LinkButton>
                        </div>
                    </div>
                </aside>

                <!-- Scrollable Content (Right) -->
                <div class="pet-profile-content">

                    <!-- Pet Header Info -->
                    <section class="profile-section" style="padding: 1.5rem 2rem;">
                        <h1 class="pet-name-main">
                            <asp:Literal ID="litNombre" runat="server">Mascota</asp:Literal>
                        </h1>
                        <div class="pet-meta">
                            <div class="pet-badges">
                                <asp:Panel ID="pnlNuevo" runat="server" Visible="false"
                                    style="padding: 0.4rem 0.85rem; border-radius: 20px; font-weight: 600; font-size: 0.8rem; background: #51CF66; color: #fff;">
                                    ✨ Nuevo
                                </asp:Panel>
                                <span
                                    style="padding: 0.4rem 0.85rem; border-radius: 20px; font-weight: 600; font-size: 0.8rem; background: #FFD275; color: #4A3B32;">
                                    <asp:Literal ID="litEstado" runat="server">Disponible</asp:Literal>
                                </span>
                            </div>
                            <div class="pet-location-badge">
                                <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                                    <path
                                        d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z" />
                                </svg>
                                <span>
                                    <asp:Literal ID="litUbicacion" runat="server">Ubicación</asp:Literal>
                                </span>
                            </div>
                        </div>
                    </section>

                    <!-- Pet Stats Section -->
                    <section class="profile-section">
                        <h2 class="profile-section-title">📋 Mis datos</h2>
                        <div class="stats-grid">
                            <div class="stat-item">
                                <div class="stat-icon blue">
                                    <svg viewBox="0 0 24 24" fill="currentColor" width="26" height="26">
                                        <path
                                            d="M12,11.36C12.55,11.36 13,10.91 13,10.36V8.36C13,7.81 12.55,7.36 12,7.36C11.45,7.36 11,7.81 11,8.36V10.36C11,10.91 11.45,11.36 12,11.36M12,12.36C10.5,12.36 9.1,12.76 7.9,13.46C7.3,12.86 6.4,12.36 5.5,12.36C3.5,12.36 2,13.86 2,15.86C2,17.86 3.5,19.36 5.5,19.36C6.5,19.36 7.4,18.96 8.1,18.26C9,19.56 10.4,20.36 12,20.36C13.6,20.36 15,19.56 15.9,18.26C16.6,18.96 17.5,19.36 18.5,19.36C20.5,19.36 22,17.86 22,15.86C22,13.86 20.5,12.36 18.5,12.36C17.6,12.36 16.7,12.86 16.1,13.46C14.9,12.76 13.5,12.36 12,12.36Z" />
                                    </svg>
                                </div>
                                <div class="stat-info">
                                    <span class="stat-label">Especie / Raza</span>
                                    <div class="stat-value">
                                        <asp:Literal ID="litEspecie" runat="server">Perro</asp:Literal>
                                    </div>
                                    <div class="stat-detail">
                                        <asp:Literal ID="litRaza" runat="server">Mestizo</asp:Literal>
                                    </div>
                                </div>
                            </div>

                            <div class="stat-item">
                                <div class="stat-icon purple">
                                    <svg viewBox="0 0 24 24" fill="currentColor" width="26" height="26">
                                        <path
                                            d="M9 11H7v2h2v-2zm4 0h-2v2h2v-2zm4 0h-2v2h2v-2zm2-7h-1V2h-2v2H8V2H6v2H5c-1.11 0-1.99.9-1.99 2L3 20c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 16H5V9h14v11z" />
                                    </svg>
                                </div>
                                <div class="stat-info">
                                    <span class="stat-label">Edad</span>
                                    <div class="stat-value">
                                        <asp:Literal ID="litEdad" runat="server">Adulto</asp:Literal>
                                    </div>
                                    <div class="stat-detail">
                                        <asp:Literal ID="litEdadDetalle" runat="server"></asp:Literal>
                                    </div>
                                </div>
                            </div>

                            <div class="stat-item">
                                <div class="stat-icon teal">
                                    <svg viewBox="0 0 24 24" fill="currentColor" width="26" height="26">
                                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                        <circle cx="12" cy="7" r="4" />
                                    </svg>
                                </div>
                                <div class="stat-info">
                                    <span class="stat-label">Sexo</span>
                                    <div class="stat-value">
                                        <asp:Literal ID="litSexo" runat="server">Desconocido</asp:Literal>
                                    </div>
                                </div>
                            </div>

                            <div class="stat-item">
                                <div class="stat-icon orange">
                                    <svg viewBox="0 0 24 24" fill="currentColor" width="26" height="26">
                                        <path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z" />
                                    </svg>
                                </div>
                                <div class="stat-info">
                                    <span class="stat-label">Tamaño</span>
                                    <div class="stat-value">
                                        <asp:Literal ID="litTamano" runat="server">Mediano</asp:Literal>
                                    </div>
                                </div>
                            </div>

                            <div class="stat-item">
                                <div class="stat-icon green">
                                    <svg viewBox="0 0 24 24" fill="currentColor" width="26" height="26">
                                        <circle cx="12" cy="12" r="10" fill="none" stroke="currentColor"
                                            stroke-width="2" />
                                        <circle cx="12" cy="12" r="4" />
                                    </svg>
                                </div>
                                <div class="stat-info">
                                    <span class="stat-label">Color</span>
                                    <div class="stat-value">
                                        <asp:Literal ID="litColor" runat="server">--</asp:Literal>
                                    </div>
                                </div>
                            </div>

                            <asp:Panel ID="pnlTemperamento" runat="server" Visible="false" CssClass="stat-item">
                                <div class="stat-icon red">
                                    <svg viewBox="0 0 24 24" fill="currentColor" width="26" height="26">
                                        <path
                                            d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm3.5-9c.83 0 1.5-.67 1.5-1.5S16.33 8 15.5 8 14 8.67 14 9.5s.67 1.5 1.5 1.5zm-7 0c.83 0 1.5-.67 1.5-1.5S9.33 8 8.5 8 7 8.67 7 9.5 7.67 11 8.5 11zm3.5 6.5c2.33 0 4.31-1.46 5.11-3.5H6.89c.8 2.04 2.78 3.5 5.11 3.5z" />
                                    </svg>
                                </div>
                                <div class="stat-info">
                                    <span class="stat-label">Temperamento</span>
                                    <div class="stat-value">
                                        <asp:Literal ID="litTemperamento" runat="server"></asp:Literal>
                                    </div>
                                </div>
                            </asp:Panel>
                        </div>
                    </section>

                    <!-- History Section -->
                    <asp:Panel ID="pnlDescripcion" runat="server" CssClass="profile-section">
                        <h2 class="profile-section-title">📖 Mi historia</h2>
                        <div class="pet-story">
                            <asp:Literal ID="litDescripcion" runat="server"></asp:Literal>
                        </div>
                    </asp:Panel>

                    <!-- Shelter/Owner Section -->
                    <section class="profile-section">
                        <h2 class="profile-section-title">🏠 Refugio</h2>
                        <div class="shelter-info-card">
                            <div class="shelter-avatar">
                                <asp:Literal ID="litRefugioInicial" runat="server">R</asp:Literal>
                            </div>
                            <div class="shelter-details">
                                <h3>
                                    <asp:Literal ID="litRefugioNombre" runat="server">Refugio</asp:Literal>
                                </h3>
                                <p class="shelter-type">
                                    <asp:Literal ID="litRefugioCiudad" runat="server">Ciudad</asp:Literal>
                                </p>
                            </div>
                        </div>
                    </section>

                    <!-- Delivery Information -->
                    <section class="profile-section">
                        <h2 class="profile-section-title">✅ Cómo me entregan</h2>
                        <div class="delivery-grid">
                            <div class="delivery-item">
                                <div class="delivery-icon" id="iconVacunado" runat="server">
                                    <svg viewBox="0 0 24 24" fill="currentColor" width="30" height="30">
                                        <path
                                            d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z" />
                                    </svg>
                                </div>
                                <span class="delivery-label">Vacunado</span>
                            </div>
                            <div class="delivery-item">
                                <div class="delivery-icon" id="iconEsterilizado" runat="server">
                                    <svg viewBox="0 0 24 24" fill="currentColor" width="30" height="30">
                                        <path
                                            d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z" />
                                    </svg>
                                </div>
                                <span class="delivery-label">Esterilizado</span>
                            </div>
                            <div class="delivery-item">
                                <div class="delivery-icon" id="iconDesparasitado" runat="server">
                                    <svg viewBox="0 0 24 24" fill="currentColor" width="30" height="30">
                                        <path
                                            d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z" />
                                    </svg>
                                </div>
                                <span class="delivery-label">Desparasitado</span>
                            </div>
                        </div>
                    </section>

                    <!-- Necesidades Especiales -->
                    <asp:Panel ID="pnlNecesidades" runat="server" Visible="false" CssClass="profile-section">
                        <h2 class="profile-section-title">⚠️ Necesidades Especiales</h2>
                        <div class="pet-story" style="border-left-color: #FF6B6B;">
                            <asp:Literal ID="litNecesidades" runat="server"></asp:Literal>
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </asp:Panel>

        <!-- Empty State when pet not found -->
        <asp:Panel ID="pnlNoEncontrado" runat="server" Visible="false" CssClass="empty-state">
            <div class="empty-state-icon">😿</div>
            <h3>Mascota no encontrada</h3>
            <p>La mascota que buscas no existe o ya no está disponible para adopción.</p>
            <a href='<%= ResolveUrl("~/Adoptante/Mascotas.aspx") %>' class="btn-view-pet"
                style="margin-top: 1rem; display: inline-flex;">
                Ver otras mascotas
            </a>
        </asp:Panel>

        <!-- Sticky CTA Button -->
        <asp:Panel ID="pnlCTA" runat="server" CssClass="sticky-adopt-cta">
            <asp:LinkButton ID="btnAdoptar" runat="server" CssClass="btn-adopt-main" OnClick="btnAdoptar_Click">
                <svg viewBox="0 0 24 24" fill="currentColor" width="26" height="26">
                    <path
                        d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
                </svg>
                ¡Quiero adoptarlo!
            </asp:LinkButton>
        </asp:Panel>

        <!-- Photo Gallery Modal -->
        <div class="modal-overlay" id="galleryModal">
            <div class="modal-content">
                <button type="button" class="modal-close" id="closeModal">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                        stroke-linejoin="round" width="24" height="24">
                        <line x1="18" y1="6" x2="6" y2="18" />
                        <line x1="6" y1="6" x2="18" y2="18" />
                    </svg>
                </button>
                <h2 class="modal-title">Fotos de <asp:Literal ID="litNombreModal" runat="server">Mascota</asp:Literal>
                </h2>
                <div class="modal-gallery">
                    <asp:Repeater ID="rptFotos" runat="server">
                        <ItemTemplate>
                            <div class="modal-photo">
                                <img src='<%# ResolveUrl(Eval("fot_Url")?.ToString()) %>' alt="Foto"
                                    style="width: 100%; height: 100%; object-fit: cover; border-radius: 12px;" />
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlSinFotos" runat="server" CssClass="modal-photo">
                        <asp:Literal ID="litEmojiModal" runat="server"></asp:Literal>
                    </asp:Panel>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            // Modal functionality
            document.addEventListener('DOMContentLoaded', function () {
                const modal = document.getElementById('galleryModal');
                const openBtn = document.getElementById('openGallery');
                const closeBtn = document.getElementById('closeModal');

                if (openBtn) {
                    openBtn.onclick = function () { modal.style.display = 'flex'; };
                }
                if (closeBtn) {
                    closeBtn.onclick = function () { modal.style.display = 'none'; };
                }
                if (modal) {
                    modal.onclick = function (e) {
                        if (e.target === modal) modal.style.display = 'none';
                    };
                }
            });
        </script>
    </asp:Content>