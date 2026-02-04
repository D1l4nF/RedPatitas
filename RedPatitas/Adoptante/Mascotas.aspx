<%@ Page Title="Buscar Mascotas" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true"
    CodeBehind="Mascotas.aspx.cs" Inherits="RedPatitas.Adoptante.Mascotas" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Buscar Mascotas | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link href='<%= ResolveUrl("~/Style/estilos-publicos.css") %>' rel="stylesheet" type="text/css" />
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">🐾 Buscar Mascotas</h1>
            <div class="breadcrumb">Encuentra a tu compañero ideal</div>
        </div>
    </asp:Content>

    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

        <!-- Search & Filters Section -->
        <section class="filters-section">
            <div class="filters-container">
                <div class="search-box">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="8"></circle>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                    </svg>
                    <asp:TextBox ID="txtBuscar" runat="server" CssClass="search-input"
                        placeholder="Buscar por nombre..."></asp:TextBox>
                </div>

                <div class="filters-row">
                    <div class="filter-group">
                        <asp:DropDownList ID="ddlEspecie" runat="server" CssClass="filter-select">
                            <asp:ListItem Value="">Especie (Todas)</asp:ListItem>
                            <asp:ListItem Value="Perro">🐕 Perro</asp:ListItem>
                            <asp:ListItem Value="Gato">🐱 Gato</asp:ListItem>
                            <asp:ListItem Value="Conejo">🐰 Conejo</asp:ListItem>
                            <asp:ListItem Value="Ave">🐦 Ave</asp:ListItem>
                            <asp:ListItem Value="Hámster">🐹 Hámster</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="filter-group">
                        <asp:DropDownList ID="ddlEdad" runat="server" CssClass="filter-select">
                            <asp:ListItem Value="">Edad (Todas)</asp:ListItem>
                            <asp:ListItem Value="Cachorro">Cachorro</asp:ListItem>
                            <asp:ListItem Value="Joven">Joven</asp:ListItem>
                            <asp:ListItem Value="Adulto">Adulto</asp:ListItem>
                            <asp:ListItem Value="Senior">Senior</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="filter-group">
                        <asp:DropDownList ID="ddlTamano" runat="server" CssClass="filter-select">
                            <asp:ListItem Value="">Tamaño (Todos)</asp:ListItem>
                            <asp:ListItem Value="Pequeño">Pequeño</asp:ListItem>
                            <asp:ListItem Value="Mediano">Mediano</asp:ListItem>
                            <asp:ListItem Value="Grande">Grande</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <asp:Button ID="btnFiltrar" runat="server" Text="Filtrar" CssClass="btn-filter"
                        OnClick="btnFiltrar_Click" />
                </div>
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
                        <div class="pet-card-adopta">
                            <div class="pet-card-image">
                                <asp:Panel ID="pnlFoto" runat="server"
                                    Visible='<%# !string.IsNullOrEmpty(Convert.ToString(Eval("FotoPrincipal"))) %>'>
                                    <img src='<%# ResolveUrl(Convert.ToString(Eval("FotoPrincipal"))) %>'
                                        alt='<%# Eval("Nombre") %>' />
                                </asp:Panel>
                                <asp:Panel ID="pnlEmoji" runat="server" CssClass="pet-card-emoji"
                                    Visible='<%# string.IsNullOrEmpty(Convert.ToString(Eval("FotoPrincipal"))) %>'>
                                    <div class="pet-emoji">
                                        <%# Eval("EmojiEspecie") %>
                                    </div>
                                </asp:Panel>

                                <span class='<%# (bool)Eval("EsNueva") ? "pet-badge nuevo" : "pet-badge disponible" %>'>
                                    <%# (bool)Eval("EsNueva") ? "Nuevo" : "Disponible" %>
                                </span>

                                <a href="javascript:void(0);"
                                    class='<%# EsFavorito(Eval("IdMascota")) ? "pet-favorite active" : "pet-favorite" %>'
                                    data-id='<%# Eval("IdMascota") %>'
                                    onclick='toggleFavorito(this, <%# Eval("IdMascota") %>)'
                                    title='<%# EsFavorito(Eval("IdMascota")) ? "Quitar de favoritos" : "Agregar a favoritos" %>'>
                                    <svg viewBox="0 0 24 24"
                                        fill='<%# EsFavorito(Eval("IdMascota")) ? "currentColor" : "none" %>'
                                        stroke="currentColor" stroke-width="2" width="20" height="20">
                                        <path
                                            d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                    </svg>
                                </a>
                            </div>

                            <div class="pet-card-body">
                                <div class="pet-card-header">
                                    <h3>
                                        <%# Eval("Nombre") %>
                                    </h3>
                                    <span class="pet-age">
                                        <%# Eval("EdadFormateada") %>
                                    </span>
                                </div>
                                <p class="pet-breed">
                                    <%# Eval("Raza") %> • <%# Eval("Sexo") %>
                                </p>
                                <div class="pet-tags">
                                    <%# (bool)Eval("Vacunado") ? "<span class=\" pet-tag\">Vacunado</span>" : "" %>
                                        <%# (bool)Eval("Esterilizado") ? "<span class=\" pet-tag\">Esterilizado</span>"
                                            : "" %>
                                </div>
                                <div class="pet-location">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                        <circle cx="12" cy="10" r="3"></circle>
                                    </svg>
                                    <%# Eval("CiudadRefugio") %>
                                </div>
                                <a href='<%# ResolveUrl("~/Adoptante/PerfilMascota.aspx?id=" + Eval("IdMascota")) %>'
                                    class="btn-ver-perfil">Ver Perfil</a>
                            </div>
                        </div>
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
            // ID del usuario actual (pasado desde el servidor)
            var usuarioId = <%= Session["UsuarioId"] != null ? Session["UsuarioId"].ToString() : "0" %>;

            // Función para alternar favorito con AJAX
            function toggleFavorito(btn, idMascota) {
                // Cambiar estado visual inmediatamente para mejor UX
                var isActive = btn.classList.contains('active');
                var svg = btn.querySelector('svg');

                // Actualizar UI inmediatamente (optimistic update)
                btn.classList.toggle('active');
                if (svg) {
                    svg.setAttribute('fill', isActive ? 'none' : 'currentColor');
                }
                btn.title = isActive ? 'Agregar a favoritos' : 'Quitar de favoritos';

                // Llamar al handler
                var url = '<%= ResolveUrl("~/Adoptante/FavoritosHandler.ashx") %>?idMascota=' + idMascota + '&idUsuario=' + usuarioId;
                fetch(url, {
                    method: 'GET'
                })
                    .then(response => response.json())
                    .then(result => {
                        if (result.success) {
                            // Mostrar notificación con SweetAlert
                            const Toast = Swal.mixin({
                                toast: true,
                                position: 'top-end',
                                showConfirmButton: false,
                                timer: 2000,
                                timerProgressBar: true,
                                didOpen: (toast) => {
                                    toast.addEventListener('mouseenter', Swal.stopTimer);
                                    toast.addEventListener('mouseleave', Swal.resumeTimer);
                                }
                            });

                            Toast.fire({
                                icon: result.isFavorite ? 'success' : 'info',
                                title: result.isFavorite ? '❤️ ' + result.message : '💔 ' + result.message
                            });
                        } else {
                            // Revertir cambio visual si hubo error
                            btn.classList.toggle('active');
                            if (svg) {
                                svg.setAttribute('fill', isActive ? 'currentColor' : 'none');
                            }
                            btn.title = isActive ? 'Quitar de favoritos' : 'Agregar a favoritos';

                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: result.message,
                                confirmButtonColor: '#FF8C42'
                            });
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        // Revertir cambio visual si hubo error
                        btn.classList.toggle('active');
                        if (svg) {
                            svg.setAttribute('fill', isActive ? 'currentColor' : 'none');
                        }

                        Swal.fire({
                            icon: 'error',
                            title: 'Error de conexión',
                            text: 'No se pudo procesar la solicitud',
                            confirmButtonColor: '#FF8C42'
                        });
                    });
            }

            // Animación de entrada para las tarjetas
            document.addEventListener('DOMContentLoaded', function () {
                const cards = document.querySelectorAll('.pet-card-adopta');
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