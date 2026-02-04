<%@ Page Title="Mis Favoritos" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true"
    CodeBehind="Favoritos.aspx.cs" Inherits="RedPatitas.Adoptante.Favoritos" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Mis Favoritos | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link href='<%= ResolveUrl("~/Style/estilos-publicos.css") %>' rel="stylesheet" type="text/css" />
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

                            <span class="pet-badge disponible">Favorito ❤️</span>

                            <a href="javascript:void(0);" class="pet-favorite active" data-id='<%# Eval("IdMascota") %>'
                                onclick="quitarFavorito(this, <%# Eval(" IdMascota") %>)" title="Quitar de favoritos">
                                <svg viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="2"
                                    width="20" height="20">
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
                                <%# Eval("EmojiEspecie") %>
                                    <%# Eval("Sexo") %> • <%# Eval("Tamano") %>
                            </p>
                            <div class="pet-location">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16"
                                    height="16">
                                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                    <circle cx="12" cy="10" r="3"></circle>
                                </svg>
                                <%# Eval("NombreRefugio") %>
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
            <div class="empty-state-icon">💔</div>
            <h3>No tienes favoritos aún</h3>
            <p>Explora las mascotas disponibles y guarda tus favoritas haciendo clic en el corazón.</p>
            <a href='<%= ResolveUrl("~/Adoptante/Mascotas.aspx") %>' class="btn-view-pet"
                style="margin-top: 1.5rem; display: inline-flex;">
                🔍 Buscar Mascotas
            </a>
        </asp:Panel>

        <script type="text/javascript">
            var usuarioId = <%= Session["UsuarioId"] != null ? Session["UsuarioId"].ToString() : "0" %>;

            function quitarFavorito(btn, idMascota) {
                var card = btn.closest('.pet-card-adopta');

                // Llamar al handler
                var url = '<%= ResolveUrl("~/Adoptante/FavoritosHandler.ashx") %>?idMascota=' + idMascota + '&idUsuario=' + usuarioId;
                fetch(url, { method: 'GET' })
                    .then(response => response.json())
                    .then(result => {
                        if (result.success && !result.isFavorite) {
                            // Mostrar toast
                            const Toast = Swal.mixin({
                                toast: true,
                                position: 'top-end',
                                showConfirmButton: false,
                                timer: 2000,
                                timerProgressBar: true
                            });

                            Toast.fire({
                                icon: 'info',
                                title: '💔 ' + result.message
                            });

                            // Animar y remover la tarjeta
                            card.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
                            card.style.opacity = '0';
                            card.style.transform = 'scale(0.8)';
                            setTimeout(() => {
                                card.remove();
                                // Actualizar contador
                                var countEl = document.querySelector('.results-count strong');
                                if (countEl) {
                                    var count = parseInt(countEl.textContent) - 1;
                                    countEl.textContent = count;
                                    if (count === 0) {
                                        location.reload();
                                    }
                                }
                            }, 300);
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: result.message || 'Error al quitar de favoritos',
                                confirmButtonColor: '#FF8C42'
                            });
                        }
                    })
                    .catch(error => {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error de conexión',
                            text: 'No se pudo procesar la solicitud',
                            confirmButtonColor: '#FF8C42'
                        });
                    });
            }
        </script>
    </asp:Content>