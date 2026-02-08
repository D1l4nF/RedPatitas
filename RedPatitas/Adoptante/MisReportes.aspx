<%@ Page Title="Mis Reportes" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true"
    CodeBehind="MisReportes.aspx.cs" Inherits="RedPatitas.Adoptante.MisReportes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Mis Reportes | RedPatitas
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="page-header">
        <h1 class="page-title">📋 Mis Reportes de Mascotas</h1>
        <div class="breadcrumb">Gestiona tus reportes de mascotas perdidas o encontradas</div>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Estadísticas del usuario -->
    <div class="admin-stats">
        <div class="admin-stat-card">
            <div class="stat-icon reports">🔴</div>
            <div class="stat-info">
                <h3><asp:Literal ID="litMisPerdidas" runat="server" Text="0"></asp:Literal></h3>
                <p>Mis Mascotas Perdidas</p>
            </div>
        </div>
        <div class="admin-stat-card">
            <div class="stat-icon active">🟢</div>
            <div class="stat-info">
                <h3><asp:Literal ID="litMisEncontradas" runat="server" Text="0"></asp:Literal></h3>
                <p>Mascotas Encontradas</p>
            </div>
        </div>
        <div class="admin-stat-card">
            <div class="stat-icon users">👀</div>
            <div class="stat-info">
                <h3><asp:Literal ID="litAvistamientos" runat="server" Text="0"></asp:Literal></h3>
                <p>Avistamientos Recibidos</p>
            </div>
        </div>
        <div class="admin-stat-card">
            <div class="stat-icon success">❤️</div>
            <div class="stat-info">
                <h3><asp:Literal ID="litReunidas" runat="server" Text="0"></asp:Literal></h3>
                <p>Reunidas con Dueño</p>
            </div>
        </div>
    </div>

    <!-- Lista de mis reportes -->
    <div class="admin-panel">
        <div class="panel-header">
            <h2 class="panel-title">📋 Mis Reportes</h2>
            <a href="ReportarMascota.aspx" class="btn btn-primary">➕ Nuevo Reporte</a>
        </div>

        <asp:Panel ID="pnlReportes" runat="server">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Mascota</th>
                        <th>Tipo</th>
                        <th>Ciudad</th>
                        <th>Fecha</th>
                        <th>Estado</th>
                        <th>Avistamientos</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptReportes" runat="server" OnItemCommand="rptReportes_ItemCommand">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <div class="user-cell">
                                        <div class="user-avatar"
                                            style="background: <%# Eval("TipoReporte").ToString() == "Perdida" ? "#E74C3C" : "#27AE60" %>;">
                                            <%# Eval("TipoReporte").ToString() == "Perdida" ? "😿" : "🐾" %>
                                        </div>
                                        <div class="user-info">
                                            <span class="user-name"><%# Eval("NombreMascota") %></span>
                                            <span class="user-email"><%# Eval("Especie") %></span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class='status-badge <%# Eval("TipoReporte").ToString() == "Perdida" ? "inactive" : "active" %>'>
                                        <%# Eval("TipoReporte") %>
                                    </span>
                                </td>
                                <td><%# Eval("Ciudad") ?? "-" %></td>
                                <td><%# Eval("FechaReporte", "{0:dd/MM/yyyy}") %></td>
                                <td>
                                    <span class='status-badge <%# GetEstadoBadgeClass(Eval("Estado").ToString()) %>'>
                                        <%# Eval("Estado") %>
                                    </span>
                                </td>
                                <td>
                                    <span class="badge-count" style="<%# Convert.ToInt32(Eval("CantidadAvistamientos")) > 0 ? "background: #27AE60; color: white;" : "" %>">
                                        <%# Eval("CantidadAvistamientos") %>
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <asp:LinkButton ID="btnVer" runat="server" CommandName="Ver"
                                            CommandArgument='<%# Eval("IdReporte") %>' CssClass="btn-action view"
                                            ToolTip="Ver Detalle">
                                            👁️
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnReunido" runat="server" CommandName="Reunido"
                                            CommandArgument='<%# Eval("IdReporte") %>' CssClass="btn-action approve"
                                            ToolTip="Marcar como Reunido"
                                            Visible='<%# Eval("Estado").ToString() != "Reunido" && Eval("Estado").ToString() != "SinResolver" %>'>
                                            ❤️
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnCerrar" runat="server" CommandName="Cerrar"
                                            CommandArgument='<%# Eval("IdReporte") %>' CssClass="btn-action delete"
                                            ToolTip="Cerrar sin Resolver"
                                            Visible='<%# Eval("Estado").ToString() != "Reunido" && Eval("Estado").ToString() != "SinResolver" %>'
                                            OnClientClick="return confirm('¿Cerrar este reporte sin resolver?');">
                                            ❌
                                        </asp:LinkButton>
                                    </div>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </asp:Panel>

        <asp:Panel ID="pnlSinReportes" runat="server" Visible="false" CssClass="empty-state">
            <div class="empty-icon">📭</div>
            <h3>No tienes reportes</h3>
            <p>Aún no has reportado ninguna mascota perdida o encontrada.</p>
            <a href="ReportarMascota.aspx" class="btn btn-primary">➕ Crear mi primer reporte</a>
        </asp:Panel>
    </div>

    <style>
        .badge-count {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 24px;
            height: 24px;
            padding: 0 8px;
            border-radius: 12px;
            background: var(--bg-tertiary);
            font-size: 0.875rem;
            font-weight: 600;
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem;
        }
        
        .empty-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
        }
        
        .empty-state h3 {
            margin-bottom: 0.5rem;
            color: var(--text-primary);
        }
        
        .empty-state p {
            color: var(--text-secondary);
            margin-bottom: 1.5rem;
        }
    </style>
</asp:Content>
