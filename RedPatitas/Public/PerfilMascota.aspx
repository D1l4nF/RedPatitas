<%@ Page Title="" Language="C#" MasterPageFile="~/Public/Public.Master" AutoEventWireup="true"
    CodeBehind="PerfilMascota.aspx.cs" Inherits="RedPatitas.Public.PerfilMascota" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        <asp:Literal ID="litTitulo" runat="server">Perfil de Mascota</asp:Literal> | RedPatitas
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <meta name="description" content="Conoce a esta mascota en busca de un hogar lleno de amor." />
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
        <div class="pet-profile">
            <section class="profile-hero">
                <div class="profile-container">
                    <!-- Back Link -->
                    <a href="~/Public/Adopta.aspx" runat="server" class="back-link">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20"
                            height="20">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                        </svg>
                        Volver a la búsqueda
                    </a>

                    <!-- Pet Not Found Panel -->
                    <asp:Panel ID="pnlNoEncontrado" runat="server" Visible="false" CssClass="empty-state">
                        <div class="empty-state-icon">🐾</div>
                        <h2>Mascota no encontrada</h2>
                        <p>La mascota que buscas no existe o ya no está disponible.</p>
                        <a href="~/Public/Adopta.aspx" runat="server" class="btn-adopt-large"
                            style="max-width: 300px; margin: 1rem auto;">
                            Ver mascotas disponibles
                        </a>
                    </asp:Panel>

                    <!-- Pet Detail Panel -->
                    <asp:Panel ID="pnlMascota" runat="server" Visible="true">
                        <div class="pet-detail-grid">
                            <!-- Gallery -->
                            <div class="pet-gallery">
                                <div class="gallery-main">
                                    <span class="status-chip">
                                        <asp:Literal ID="litEstado" runat="server">Disponible</asp:Literal>
                                    </span>
                                    <div class="pet-emoji">
                                        <asp:Literal ID="litEmoji" runat="server">🐕</asp:Literal>
                                    </div>
                                    <button class="favorite-btn" id="favoriteBtn" type="button">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                            width="24" height="24">
                                            <path
                                                d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                            </path>
                                        </svg>
                                    </button>
                                </div>
                                <div class="gallery-thumbnails">
                                    <div class="thumbnail active">
                                        <asp:Literal ID="litThumb1" runat="server">🐕</asp:Literal>
                                    </div>
                                </div>
                            </div>

                            <!-- Pet Info -->
                            <div class="pet-info">
                                <div class="pet-header">
                                    <div>
                                        <h1 class="pet-name">
                                            <asp:Literal ID="litNombre" runat="server">Nombre</asp:Literal>
                                        </h1>
                                        <p class="pet-breed">
                                            <asp:Literal ID="litRaza" runat="server">Raza</asp:Literal>
                                        </p>
                                    </div>
                                </div>

                                <div class="pet-tags">
                                    <span class="tag">
                                        <asp:Literal ID="litTagEspecie" runat="server">🐕 Perro</asp:Literal>
                                    </span>
                                    <span class="tag">
                                        <asp:Literal ID="litTagEdad" runat="server">📅 2 años</asp:Literal>
                                    </span>
                                    <span class="tag">
                                        <asp:Literal ID="litTagTamano" runat="server">⚖️ Mediano</asp:Literal>
                                    </span>
                                    <span class="tag">
                                        <asp:Literal ID="litTagSexo" runat="server">♂️ Macho</asp:Literal>
                                    </span>
                                    <span class="tag">
                                        <asp:Literal ID="litTagUbicacion" runat="server">📍 Ecuador</asp:Literal>
                                    </span>
                                </div>

                                <div class="pet-description">
                                    <h3 class="section-title">Sobre <asp:Literal ID="litNombre2" runat="server">esta
                                            mascota</asp:Literal>
                                    </h3>
                                    <p>
                                        <asp:Literal ID="litDescripcion" runat="server">Descripción de la mascota.
                                        </asp:Literal>
                                    </p>
                                </div>

                                <div class="pet-health">
                                    <h3 class="section-title">Estado de Salud</h3>
                                    <div class="health-tags">
                                        <asp:Panel ID="pnlVacunado" runat="server" Visible="false">
                                            <span class="health-tag positive">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2" width="16" height="16">
                                                    <polyline points="20 6 9 17 4 12"></polyline>
                                                </svg>
                                                Vacunado
                                            </span>
                                        </asp:Panel>
                                        <asp:Panel ID="pnlEsterilizado" runat="server" Visible="false">
                                            <span class="health-tag positive">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2" width="16" height="16">
                                                    <polyline points="20 6 9 17 4 12"></polyline>
                                                </svg>
                                                Esterilizado
                                            </span>
                                        </asp:Panel>
                                        <asp:Panel ID="pnlDesparasitado" runat="server" Visible="false">
                                            <span class="health-tag positive">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2" width="16" height="16">
                                                    <polyline points="20 6 9 17 4 12"></polyline>
                                                </svg>
                                                Desparasitado
                                            </span>
                                        </asp:Panel>
                                    </div>
                                </div>

                                <asp:Panel ID="pnlTemperamento" runat="server" Visible="false"
                                    CssClass="pet-characteristics">
                                    <h3 class="section-title">¿Cómo soy?</h3>
                                    <div class="characteristics-grid">
                                        <asp:Literal ID="litTemperamento" runat="server"></asp:Literal>
                                    </div>
                                </asp:Panel>

                                <div class="pet-shelter">
                                    <h3 class="section-title">Publicado por</h3>
                                    <div class="shelter-card">
                                        <div class="shelter-avatar">
                                            <asp:Literal ID="litRefugioInicial" runat="server">RE</asp:Literal>
                                        </div>
                                        <div class="shelter-info">
                                            <span class="shelter-name">
                                                <asp:Literal ID="litRefugioNombre" runat="server">Refugio</asp:Literal>
                                            </span>
                                            <span class="shelter-location">📍 <asp:Literal ID="litRefugioCiudad"
                                                    runat="server">Ecuador</asp:Literal></span>
                                        </div>
                                    </div>
                                </div>

                                <div class="pet-cta">
                                    <a href="~/Login/Login.aspx" runat="server" class="btn-adopt-large">
                                        <svg viewBox="0 0 24 24" fill="currentColor" width="24" height="24">
                                            <path
                                                d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
                                        </svg>
                                        ¡Quiero adoptarlo!
                                    </a>
                                    <p class="cta-hint">
                                        ¿Ya tienes cuenta? <a href="~/Login/Login.aspx" runat="server">Inicia sesión</a>
                                        para solicitar la adopción
                                    </p>
                                    <button class="btn-secondary-outline" type="button" onclick="compartir()">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                            width="20" height="20">
                                            <path d="M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8"></path>
                                            <polyline points="16 6 12 2 8 6"></polyline>
                                            <line x1="12" y1="2" x2="12" y2="15"></line>
                                        </svg>
                                        Compartir
                                    </button>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                </div>
            </section>
        </div>

        <script>
            // Favorite button toggle
            var favoriteBtn = document.getElementById('favoriteBtn');
            if (favoriteBtn) {
                favoriteBtn.addEventListener('click', function () {
                    this.classList.toggle('active');
                    var svg = this.querySelector('svg');
                    if (this.classList.contains('active')) {
                        svg.setAttribute('fill', '#E74C3C');
                        this.style.color = '#E74C3C';
                    } else {
                        svg.setAttribute('fill', 'none');
                        this.style.color = '#999';
                    }
                });
            }

            // Share function
            function compartir() {
                if (navigator.share) {
                    navigator.share({
                        title: document.title,
                        url: window.location.href
                    });
                } else {
                    // Fallback: copiar URL
                    navigator.clipboard.writeText(window.location.href);
                    alert('¡Enlace copiado al portapapeles!');
                }
            }
        </script>
    </asp:Content>