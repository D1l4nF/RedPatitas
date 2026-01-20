<%@ Page Title="Mis Favoritos" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true"
    CodeBehind="Favoritos.aspx.cs" Inherits="RedPatitas.Adoptante.Favoritos" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Mis Favoritos | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link href='<%= ResolveUrl("~/Style/dashboard.css") %>' rel="stylesheet" type="text/css" />
        <link href='<%= ResolveUrl("~/Style/pet-cards.css") %>' rel="stylesheet" type="text/css" />
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">❤️ Mis Favoritos</h1>
            <div class="breadcrumb">Mascotas que te han robado el corazón</div>
        </div>
    </asp:Content>

    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

        <!-- Results Header -->
        <div class="results-header" style="margin-bottom: 1.5rem;">
            <p class="results-count">
                Tienes <strong>
                    <asp:Literal ID="litConteo" runat="server">0</asp:Literal>
                </strong> mascotas en favoritos
            </p>
            <a href='<%= ResolveUrl("~/Adoptante/Mascotas.aspx") %>' class="btn-filter"
                style="display: inline-flex; align-items: center; gap: 0.5rem; text-decoration: none;">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                Buscar más mascotas
            </a>
        </div>

        <!-- Favorites Grid -->
        <asp:Panel ID="pnlFavoritos" runat="server" CssClass="pets-grid">
            <asp:Repeater ID="rptFavoritos" runat="server" OnItemCommand="rptFavoritos_ItemCommand">
                <ItemTemplate>
                    <article class="pet-card">
                        <div class="pet-card-image">
                            <asp:Panel ID="pnlFoto" runat="server"
                                Visible='<%# !string.IsNullOrEmpty(Eval("FotoPrincipal")?.ToString()) %>'>
                                <img src='<%# ResolveUrl(Eval("FotoPrincipal")?.ToString()) %>'
                                    alt='<%# Eval("Nombre") %>' />
                            </asp:Panel>
                            <asp:Panel ID="pnlEmoji" runat="server" CssClass="pet-card-emoji"
                                Visible='<%# string.IsNullOrEmpty(Eval("FotoPrincipal")?.ToString()) %>'>
                                <%# Eval("EmojiEspecie") %>
                            </asp:Panel>

                            <!-- Remove from Favorites Button -->
                            <asp:LinkButton ID="btnQuitarFavorito" runat="server" CssClass="pet-favorite-btn active"
                                CommandName="Quitar" CommandArgument='<%# Eval("IdMascota") %>'
                                ToolTip="Quitar de favoritos">
                                <svg viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="2">
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
                                    <%# Eval("NombreRefugio") %>
                                </span>
                            </div>

                            <div class="pet-card-actions">
                                <a href='<%# ResolveUrl("~/Adoptante/PerfilMascota.aspx?id=" + Eval("IdMascota")) %>'
                                    class="btn-view-pet">
                                    Ver Perfil
                                </a>
                                <asp:LinkButton ID="btnAdoptar" runat="server" CssClass="btn-adopt-quick"
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
            <div class="empty-state-icon">💔</div>
            <h3>No tienes favoritos aún</h3>
            <p>Explora las mascotas disponibles y guarda tus favoritas haciendo clic en el corazón.</p>
            <a href='<%= ResolveUrl("~/Adoptante/Mascotas.aspx") %>' class="btn-view-pet"
                style="margin-top: 1.5rem; display: inline-flex;">
                🔍 Buscar Mascotas
            </a>
        </asp:Panel>
    </asp:Content>