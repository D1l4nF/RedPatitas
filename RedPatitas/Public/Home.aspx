<%@ Page Title="" Language="C#" MasterPageFile="~/Public/Public.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="RedPatitas.Public.Home" %>

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
                    <span class="floating-pet" style="--delay: 0s; --x: 0; --y: 0;">🐕</span>
                    <span class="floating-pet" style="--delay: 0.5s; --x: 60px; --y: -20px;">🐱</span>
                    <span class="floating-pet" style="--delay: 1s; --x: -40px; --y: 30px;">🐰</span>
                    <span class="floating-pet" style="--delay: 1.5s; --x: 80px; --y: 40px;">🐦</span>
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
            <div class="pets-grid">
                <div class="pet-card">
                    <div class="pet-image">🐕</div>
                    <div class="pet-info">
                        <h3 class="pet-name">Max</h3>
                        <p class="pet-details">Golden Retriever • 2 años • Juguetón y cariñoso</p>
                        <a href="~/Public/MascotaPerfil.aspx" runat="server" class="btn-view-profile">Ver perfil</a>
                    </div>
                </div>
                <div class="pet-card">
                    <div class="pet-image">🐈</div>
                    <div class="pet-info">
                        <h3 class="pet-name">Luna</h3>
                        <p class="pet-details">Gata Siamesa • 1 año • Tranquila y elegante</p>
                        <a href="~/Public/MascotaPerfil.aspx" runat="server" class="btn-view-profile">Ver perfil</a>
                    </div>
                </div>
                <div class="pet-card">
                    <div class="pet-image">🐕</div>
                    <div class="pet-info">
                        <h3 class="pet-name">Rocky</h3>
                        <p class="pet-details">Bulldog • 3 años • Amigable y protector</p>
                        <a href="~/Public/MascotaPerfil.aspx" runat="server" class="btn-view-profile">Ver perfil</a>
                    </div>
                </div>
                <div class="pet-card">
                    <div class="pet-image">🐰</div>
                    <div class="pet-info">
                        <h3 class="pet-name">Milo</h3>
                        <p class="pet-details">Conejo Holandes • 6 meses • Tierno y activo</p>
                        <a href="~/Public/MascotaPerfil.aspx" runat="server" class="btn-view-profile">Ver perfil</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

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
                            "Adoptamos a Luna hace 6 meses y ha cambiado nuestras vidas. El proceso fue fácil y el equipo
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
                            "Gracias a RedPatitas encontré a mi perrito Max después de 3 días perdido. La comunidad es
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
                            "Como refugio, RedPatitas nos ha ayudado a encontrar hogares para más de 50 mascotas. Es una
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
            <p class="cta-subtitle">Miles de mascotas esperan encontrar una familia. Tú puedes ser esa familia.</p>
            <div class="cta-actions">
                <a href="~/Public/Adopta.aspx" runat="server" class="btn btn-cta-primary">
                    <svg viewBox="0 0 24 24" fill="currentColor" width="22" height="22">
                        <path
                            d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
                    </svg>
                    Adoptar Ahora
                </a>
                <a href="~/Login/Registro.aspx" runat="server" class="btn btn-cta-secondary">Crear Cuenta Gratis</a>
            </div>
        </div>
    </section>
</asp:Content>
