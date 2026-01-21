<%@ Page Title="Inicio" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true"
    CodeBehind="Dashboard.aspx.cs" Inherits="RedPatitas.Adoptante.Dashboard" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Inicio | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link href='<%= ResolveUrl("~/Style/dashboard.css") %>' rel="stylesheet" type="text/css" />
        <link href='<%= ResolveUrl("~/Style/pet-cards.css") %>' rel="stylesheet" type="text/css" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
    </asp:Content>

    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

        <div class="content-wrapper">
            <div class="page-header-internal">
                <h1 class="page-title">Bienvenido/a, <asp:Literal ID="litNombreUsuario" runat="server">Usuario
                    </asp:Literal>
                </h1>
                <div class="breadcrumb">Encuentra a tu compañero ideal</div>
            </div>

            <!-- Stats Cards -->
            <div class="stats-grid">
                <a href="Favoritos.aspx" style="text-decoration: none;">
                    <div class="stat-card" style="cursor: pointer; transition: all 0.3s ease;">
                        <div class="stat-icon green">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                stroke-linecap="round" stroke-linejoin="round" width="24" height="24">
                                <path
                                    d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                </path>
                            </svg>
                        </div>
                        <div class="stat-info">
                            <h3>
                                <asp:Literal ID="litFavoritos" runat="server">0</asp:Literal>
                            </h3>
                            <p>Favoritos</p>
                        </div>
                    </div>
                </a>
                <a href="Solicitudes.aspx" style="text-decoration: none;">
                    <div class="stat-card orange" style="cursor: pointer; transition: all 0.3s ease;">
                        <div class="stat-icon orange">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                stroke-linecap="round" stroke-linejoin="round" width="24" height="24">
                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                <polyline points="14 2 14 8 20 8"></polyline>
                                <line x1="16" y1="13" x2="8" y2="13"></line>
                                <line x1="16" y1="17" x2="8" y2="17"></line>
                                <polyline points="10 9 9 9 8 9"></polyline>
                            </svg>
                        </div>
                        <div class="stat-info">
                            <h3>
                                <asp:Literal ID="litSolicitudes" runat="server">0</asp:Literal>
                            </h3>
                            <p>Solicitudes</p>
                        </div>
                    </div>
                </a>
            </div>

            <!-- Mascotas Recomendadas -->
            <div class="recent-section">
                <div class="section-header">
                    <h2 class="section-title">🐾 Recomendados para ti</h2>
                    <a href='<%= ResolveUrl("~/Adoptante/Mascotas.aspx") %>' class="btn-link">Ver más</a>
                </div>

                <asp:Panel ID="pnlMascotas" runat="server">
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Mascota</th>
                                    <th>Raza</th>
                                    <th>Ubicación</th>
                                    <th>Acción</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptMascotas" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <div class="pet-cell">
                                                    <div class="pet-img"
                                                        style="background: linear-gradient(135deg, #FFE8CC 0%, #FFD275 100%); display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                                                        <%# Eval("EmojiEspecie") %>
                                                    </div>
                                                    <span>
                                                        <%# Eval("Nombre") %>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <%# Eval("Raza") %>
                                            </td>
                                            <td>
                                                <%# Eval("NombreRefugio") %>
                                            </td>
                                            <td>
                                                <a href='<%# ResolveUrl("~/Adoptante/PerfilMascota.aspx?id=" + Eval("IdMascota")) %>'
                                                    class="btn-link">Ver Perfil</a>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlSinMascotas" runat="server" Visible="false"
                    style="text-align: center; padding: 3rem; background: #fff; border-radius: 12px;">
                    <div style="font-size: 4rem; margin-bottom: 1rem;">🐾</div>
                    <h3 style="color: #4A3B32; margin-bottom: 0.5rem;">No hay mascotas disponibles</h3>
                    <p style="color: #666;">Vuelve pronto, ¡nuevas mascotas llegan cada día!</p>
                </asp:Panel>
            </div>

            <!-- Quick Actions -->
            <div class="recent-section" style="margin-top: 2rem;">
                <div class="section-header">
                    <h2 class="section-title">⚡ Acciones rápidas</h2>
                </div>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
                    <a href='<%= ResolveUrl("~/Adoptante/Mascotas.aspx") %>' class="quick-action-card"
                        style="display: flex; align-items: center; gap: 1rem; padding: 1.25rem; background: #fff; border-radius: 12px; text-decoration: none; color: inherit; transition: all 0.3s ease; box-shadow: 0 2px 8px rgba(0,0,0,0.06);">
                        <div
                            style="width: 50px; height: 50px; background: #FFF0E6; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                            🔍
                        </div>
                        <div>
                            <strong style="color: #4A3B32;">Buscar Mascotas</strong>
                            <p style="font-size: 0.85rem; color: #666; margin: 0;">Encuentra tu compañero</p>
                        </div>
                    </a>
                    <a href='<%= ResolveUrl("~/Adoptante/Favoritos.aspx") %>' class="quick-action-card"
                        style="display: flex; align-items: center; gap: 1rem; padding: 1.25rem; background: #fff; border-radius: 12px; text-decoration: none; color: inherit; transition: all 0.3s ease; box-shadow: 0 2px 8px rgba(0,0,0,0.06);">
                        <div
                            style="width: 50px; height: 50px; background: #FFE6E6; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                            ❤️
                        </div>
                        <div>
                            <strong style="color: #4A3B32;">Mis Favoritos</strong>
                            <p style="font-size: 0.85rem; color: #666; margin: 0;">Tus mascotas guardadas</p>
                        </div>
                    </a>
                    <a href='<%= ResolveUrl("~/Adoptante/Perfil.aspx") %>' class="quick-action-card"
                        style="display: flex; align-items: center; gap: 1rem; padding: 1.25rem; background: #fff; border-radius: 12px; text-decoration: none; color: inherit; transition: all 0.3s ease; box-shadow: 0 2px 8px rgba(0,0,0,0.06);">
                        <div
                            style="width: 50px; height: 50px; background: #E6F0FF; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                            👤
                        </div>
                        <div>
                            <strong style="color: #4A3B32;">Mi Perfil</strong>
                            <p style="font-size: 0.85rem; color: #666; margin: 0;">Editar mis datos</p>
                        </div>
                    </a>
                </div>
            </div>
        </div>

        <style>
            .quick-action-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12) !important;
            }

            .stat-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
            }
        </style>
    </asp:Content>