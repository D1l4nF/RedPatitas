<%@ Page Title="" Language="C#" MasterPageFile="~/Public/Public.Master" AutoEventWireup="true"
    CodeBehind="Adopta.aspx.cs" Inherits="RedPatitas.Public.Adopta" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Adopta una Mascota | RedPatitas
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link rel="stylesheet" href="~/Style/public-pages.css" />
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
        <section class="adopta-hero">
            <h1>Encuentra tu Compañero Ideal</h1>
            <p>Cientos de mascotas esperan encontrar un hogar lleno de amor. ¿Estás listo para cambiar una vida?</p>
        </section>

        <!-- Filters -->
        <section class="filters-section">
            <div class="filters-container">
                <div class="search-box">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="8"></circle>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                    </svg>
                    <asp:TextBox ID="txtBuscar" runat="server" placeholder="Buscar por nombre, raza..."
                        CssClass="search-input" />
                </div>

                <!-- Mobile Toggle -->
                <button class="filters-toggle" id="filtersToggle" type="button">
                    <span>⚙️ Filtros</span>
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20" height="20">
                        <polyline points="6 9 12 15 18 9"></polyline>
                    </svg>
                </button>

                <!-- Filter Options -->
                <div class="filters-row" id="filtersRow">
                    <asp:DropDownList ID="ddlTipo" runat="server" CssClass="filter-select" AutoPostBack="true"
                        OnSelectedIndexChanged="Filtros_Changed">
                        <asp:ListItem Value="" Text="Tipo" />
                        <asp:ListItem Value="perro" Text="🐕 Perros" />
                        <asp:ListItem Value="gato" Text="🐱 Gatos" />
                        <asp:ListItem Value="conejo" Text="🐰 Conejos" />
                        <asp:ListItem Value="otro" Text="🐾 Otros" />
                    </asp:DropDownList>
                    <asp:DropDownList ID="ddlEdad" runat="server" CssClass="filter-select" AutoPostBack="true"
                        OnSelectedIndexChanged="Filtros_Changed">
                        <asp:ListItem Value="" Text="Edad" />
                        <asp:ListItem Value="Cachorro" Text="Cachorro" />
                        <asp:ListItem Value="Joven" Text="Joven" />
                        <asp:ListItem Value="Adulto" Text="Adulto" />
                        <asp:ListItem Value="Senior" Text="Senior" />
                    </asp:DropDownList>
                    <asp:DropDownList ID="ddlTamano" runat="server" CssClass="filter-select" AutoPostBack="true"
                        OnSelectedIndexChanged="Filtros_Changed">
                        <asp:ListItem Value="" Text="Tamaño" />
                        <asp:ListItem Value="Pequeño" Text="Pequeño" />
                        <asp:ListItem Value="Mediano" Text="Mediano" />
                        <asp:ListItem Value="Grande" Text="Grande" />
                    </asp:DropDownList>
                </div>

                <span class="results-count">Mostrando <strong>
                        <asp:Literal ID="litCantidad" runat="server">0</asp:Literal>
                    </strong> mascotas</span>
            </div>
        </section>

        <!-- Pets Grid -->
        <section class="pets-section">
            <div class="pets-container">
                <asp:Repeater ID="rptMascotas" runat="server">
                    <HeaderTemplate>
                        <div class="adopta-grid">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="pet-card-adopta">
                            <div class="pet-card-image">
                                <%# Eval("EmojiEspecie") %>
                                    <span class='<%# (bool)Eval("EsNueva") ? "pet-badge new" : "pet-badge" %>'>
                                        <%# (bool)Eval("EsNueva") ? "Nuevo" : "Disponible" %>
                                    </span>
                                    <button class="pet-favorite" aria-label="Agregar a favoritos" type="button">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                            width="18" height="18">
                                            <path
                                                d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                            </path>
                                        </svg>
                                    </button>
                            </div>
                            <div class="pet-card-body">
                                <div class="pet-card-header">
                                    <span class="pet-card-name">
                                        <%# Eval("Nombre") %>
                                    </span>
                                    <span class="pet-card-age">
                                        <%# Eval("EdadFormateada") %>
                                    </span>
                                </div>
                                <p class="pet-card-breed">
                                    <%# Eval("Raza") %> • <%# Eval("Sexo") %>
                                </p>
                                <div class="pet-card-tags">
                                    <%# (bool)Eval("Vacunado") ? "<span class=\" pet-tag\">Vacunado</span>" : "" %>
                                        <%# (bool)Eval("Esterilizado") ? "<span class=\" pet-tag\">Esterilizado</span>"
                                            : "" %>
                                </div>
                                <div class="pet-card-location">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                        <circle cx="12" cy="10" r="3"></circle>
                                    </svg>
                                    <%# Eval("CiudadRefugio") %>
                                </div>
                                <a href='<%# "~/Public/PerfilMascota.aspx?id=" + Eval("IdMascota") %>' runat="server"
                                    class="btn-ver-perfil">Ver Perfil</a>
                            </div>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
            </div>
            </FooterTemplate>
            </asp:Repeater>

            <!-- Empty State -->
            <asp:Panel ID="pnlSinMascotas" runat="server" Visible="false" CssClass="empty-state">
                <div class="empty-state-content">
                    <div class="empty-state-icon">🐾</div>
                    <h3>No hay mascotas disponibles</h3>
                    <p>Por el momento no hay mascotas que coincidan con tu búsqueda. ¡Vuelve pronto!</p>
                </div>
            </asp:Panel>

            <!-- Pagination (placeholder for future implementation) -->
            <asp:Panel ID="pnlPaginacion" runat="server" CssClass="pagination" Visible="false">
                <button class="page-btn" type="button">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16">
                        <polyline points="15 18 9 12 15 6"></polyline>
                    </svg>
                </button>
                <button class="page-btn active" type="button">1</button>
                <button class="page-btn" type="button">2</button>
                <button class="page-btn" type="button">3</button>
                <button class="page-btn" type="button">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16">
                        <polyline points="9 18 15 12 9 6"></polyline>
                    </svg>
                </button>
            </asp:Panel>
            </div>
        </section>

        <script>
            // Mobile filters toggle
            document.getElementById('filtersToggle').addEventListener('click', function () {
                var filtersRow = document.getElementById('filtersRow');
                this.classList.toggle('active');
                filtersRow.classList.toggle('show');
            });
        </script>
    </asp:Content>