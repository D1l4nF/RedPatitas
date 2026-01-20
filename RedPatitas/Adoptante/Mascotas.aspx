<%@ Page Title="Buscar Mascotas" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true"
    CodeBehind="Mascotas.aspx.cs" Inherits="RedPatitas.Adoptante.Mascotas" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Buscar Mascotas | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link href='<%= ResolveUrl("~/Style/dashboard.css") %>' rel="stylesheet" type="text/css" />
        <link href='<%= ResolveUrl("~/Style/pet-cards.css") %>' rel="stylesheet" type="text/css" />
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">🐾 Buscar Mascotas</h1>
            <div class="breadcrumb">Encuentra a tu compañero ideal</div>
        </div>
    </asp:Content>

    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

        <!-- Search & Filters Section -->
        <section class="search-section">
            <div class="search-container">
                <div class="search-input-wrapper">
                    <label>Buscar por nombre</label>
                    <asp:TextBox ID="txtBuscar" runat="server" CssClass="search-input"
                        placeholder="Escribe el nombre de una mascota..."></asp:TextBox>
                </div>

                <div class="filter-group">
                    <label>Especie</label>
                    <asp:DropDownList ID="ddlEspecie" runat="server" CssClass="filter-select">
                        <asp:ListItem Value="">Todas</asp:ListItem>
                        <asp:ListItem Value="Perro">🐕 Perro</asp:ListItem>
                        <asp:ListItem Value="Gato">🐱 Gato</asp:ListItem>
                        <asp:ListItem Value="Conejo">🐰 Conejo</asp:ListItem>
                        <asp:ListItem Value="Ave">🐦 Ave</asp:ListItem>
                        <asp:ListItem Value="Hámster">🐹 Hámster</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="filter-group">
                    <label>Edad</label>
                    <asp:DropDownList ID="ddlEdad" runat="server" CssClass="filter-select">
                        <asp:ListItem Value="">Todas</asp:ListItem>
                        <asp:ListItem Value="Cachorro">Cachorro</asp:ListItem>
                        <asp:ListItem Value="Joven">Joven</asp:ListItem>
                        <asp:ListItem Value="Adulto">Adulto</asp:ListItem>
                        <asp:ListItem Value="Senior">Senior</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="filter-group">
                    <label>Tamaño</label>
                    <asp:DropDownList ID="ddlTamano" runat="server" CssClass="filter-select">
                        <asp:ListItem Value="">Todos</asp:ListItem>
                        <asp:ListItem Value="Pequeño">Pequeño</asp:ListItem>
                        <asp:ListItem Value="Mediano">Mediano</asp:ListItem>
                        <asp:ListItem Value="Grande">Grande</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <asp:Button ID="btnFiltrar" runat="server" Text="🔍 Buscar" CssClass="btn-filter"
                    OnClick="btnFiltrar_Click" />
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn-clear"
                    OnClick="btnLimpiar_Click" CausesValidation="false" />
            </div>
        </section>

        <!-- Results Section -->
        <section class="results-section">
            <div class="results-header">
                <p class="results-count">
                    Mostrando <strong>
                        <asp:Literal ID="litConteo" runat="server">0</asp:Literal>
                    </strong> mascotas disponibles
                </p>
            </div>

            <!-- Pets Grid -->
            <asp:Panel ID="pnlMascotas" runat="server" CssClass="pets-grid">
                <asp:Repeater ID="rptMascotas" runat="server" OnItemCommand="rptMascotas_ItemCommand">
                    <ItemTemplate>
                        <article class="pet-card">
                            <div class="pet-card-image">
                                <%-- Mostrar foto o emoji --%>
                                    <asp:Panel ID="pnlFoto" runat="server"
                                        Visible='<%# !string.IsNullOrEmpty(Convert.ToString(Eval("FotoPrincipal"))) %>'>
                                        <img src='<%# ResolveUrl(Convert.ToString(Eval("FotoPrincipal"))) %>'
                                            alt='<%# Eval("Nombre") %>' />
                                    </asp:Panel>
                                    <asp:Panel ID="pnlEmoji" runat="server" CssClass="pet-card-emoji"
                                        Visible='<%# string.IsNullOrEmpty(Convert.ToString(Eval("FotoPrincipal"))) %>'>
                                        <%# Eval("EmojiEspecie") %>
                                    </asp:Panel>

                                    <%-- Badges --%>
                                        <div class="pet-badges">
                                            <asp:Panel ID="pnlNuevo" runat="server" CssClass="pet-badge pet-badge-new"
                                                Visible='<%# (bool)Eval("EsNueva") %>'>
                                                ✨ Nuevo
                                            </asp:Panel>
                                        </div>

                                        <%-- Favorite Button --%>
                                            <asp:LinkButton ID="btnFavorito" runat="server" CssClass="pet-favorite-btn"
                                                CommandName="Favorito" CommandArgument='<%# Eval("IdMascota") %>'
                                                ToolTip="Agregar a favoritos">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2">
                                                    <path
                                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                                </svg>
                                            </asp:LinkButton>
                            </div>

                            <div class="pet-card-content">
                                <div class="pet-card-header">
                                    <h3 class="pet-card-name">
                                        <%# Eval("Nombre") %>
                                    </h3>
                                    <span class="pet-card-species">
                                        <%# Eval("EmojiEspecie") %>
                                    </span>
                                </div>

                                <div class="pet-card-details">
                                    <span class="pet-detail-tag">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <circle cx="12" cy="12" r="10" />
                                            <polyline points="12 6 12 12 16 14" />
                                        </svg>
                                        <%# Eval("EdadFormateada") %>
                                    </span>
                                    <span class="pet-detail-tag">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                            <circle cx="12" cy="7" r="4" />
                                        </svg>
                                        <%# Eval("Sexo") %>
                                    </span>
                                    <span class="pet-detail-tag">📏 <%# Eval("Tamano") %></span>
                                </div>

                                <div class="pet-card-location">
                                    <svg viewBox="0 0 24 24" fill="currentColor">
                                        <path
                                            d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z" />
                                    </svg>
                                    <span>
                                        <%# Eval("NombreRefugio") %> - <%# Eval("CiudadRefugio") %>
                                    </span>
                                </div>

                                <div class="pet-card-actions">
                                    <a href='<%# ResolveUrl("~/Adoptante/PerfilMascota.aspx?id=" + Eval("IdMascota")) %>'
                                        class="btn-view-pet">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                            width="18" height="18">
                                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                                            <circle cx="12" cy="12" r="3" />
                                        </svg>
                                        Ver Perfil
                                    </a>
                                    <asp:LinkButton ID="btnAdoptarRapido" runat="server" CssClass="btn-adopt-quick"
                                        CommandName="Adoptar" CommandArgument='<%# Eval("IdMascota") %>'
                                        ToolTip="Solicitar adopción">
                                        <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
                                            <path
                                                d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
                                        </svg>
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </article>
                    </ItemTemplate>
                </asp:Repeater>
            </asp:Panel>

            <!-- Empty State -->
            <asp:Panel ID="pnlVacio" runat="server" Visible="false" CssClass="empty-state">
                <div class="empty-state-icon">🐾</div>
                <h3>No encontramos mascotas</h3>
                <p>Intenta cambiar los filtros de búsqueda o vuelve más tarde. ¡Nuevas mascotas llegan cada día!</p>
            </asp:Panel>
        </section>

        <script type="text/javascript">
            // Animación de entrada para las tarjetas
            document.addEventListener('DOMContentLoaded', function () {
                const cards = document.querySelectorAll('.pet-card');
                cards.forEach((card, index) => {
                    card.style.opacity = '0';
                    card.style.transform = 'translateY(20px)';
                    setTimeout(() => {
                        card.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
                        card.style.opacity = '1';
                        card.style.transform = 'translateY(0)';
                    }, index * 100);
                });
            });
        </script>
    </asp:Content>