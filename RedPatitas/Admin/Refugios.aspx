<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true"
    CodeBehind="Refugios.aspx.cs" Inherits="RedPatitas.Admin.Refugios" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Gestión de Refugios | Admin
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
    </asp:Content>
    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
        <div class="page-header">
            <h1 class="page-title">Gestión de Refugios</h1>
            <div class="breadcrumb">Admin / Refugios</div>
        </div>

        <!-- Estadísticas -->
        <div class="admin-stats">
            <div class="admin-stat-card">
                <div class="stat-icon users">🏠</div>
                <div class="stat-info">
                    <h3>
                        <asp:Literal ID="litTotalRefugios" runat="server" Text="0"></asp:Literal>
                    </h3>
                    <p>Total Refugios</p>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="stat-icon adoptions">✓</div>
                <div class="stat-info">
                    <h3>
                        <asp:Literal ID="litVerificados" runat="server" Text="0"></asp:Literal>
                    </h3>
                    <p>Verificados</p>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="stat-icon reports">⏳</div>
                <div class="stat-info">
                    <h3>
                        <asp:Literal ID="litPendientes" runat="server" Text="0"></asp:Literal>
                    </h3>
                    <p>Pendientes</p>
                </div>
            </div>
        </div>

        <!-- Filtros -->
        <div class="admin-panel" style="margin-bottom: 1.5rem;">
            <div class="panel-header">
                <span class="panel-title">Filtros</span>
            </div>
            <div style="display: flex; gap: 1rem; flex-wrap: wrap; align-items: flex-end;">
                <div>
                    <label
                        style="font-size: 0.8rem; color: var(--text-light); display: block; margin-bottom: 0.25rem;">Estado</label>
                    <asp:DropDownList ID="ddlFiltroVerificado" runat="server" AutoPostBack="true"
                        OnSelectedIndexChanged="ddlFiltroVerificado_SelectedIndexChanged" CssClass="form-control">
                        <asp:ListItem Value="" Text="Todos"></asp:ListItem>
                        <asp:ListItem Value="true" Text="Verificados"></asp:ListItem>
                        <asp:ListItem Value="false" Text="Pendientes"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div>
                    <label
                        style="font-size: 0.8rem; color: var(--text-light); display: block; margin-bottom: 0.25rem;">Buscar</label>
                    <asp:TextBox ID="txtBusqueda" runat="server" placeholder="Nombre o ciudad..."
                        CssClass="form-control"></asp:TextBox>
                </div>
                <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="btn btn-primary"
                    OnClick="btnBuscar_Click" />
            </div>
        </div>

        <!-- Tabla de Refugios -->
        <div class="admin-panel">
            <div class="panel-header">
                <span class="panel-title">Refugios Registrados</span>
            </div>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Refugio</th>
                        <th>Ciudad</th>
                        <th>Email</th>
                        <th>Estado</th>
                        <th>Estadísticas</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptRefugios" runat="server" OnItemCommand="rptRefugios_ItemCommand"
                        OnItemDataBound="rptRefugios_ItemDataBound">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <div class="user-cell">
                                        <asp:Panel ID="pnlAvatar" runat="server" CssClass="user-avatar">
                                            <%# Eval("Iniciales") %>
                                        </asp:Panel>
                                        <div class="user-name">
                                            <%# Eval("Nombre") %>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <%# Eval("Ciudad") %>
                                </td>
                                <td class="user-email">
                                    <%# Eval("Email") %>
                                </td>
                                <td>
                                    <%# (bool)Eval("Verificado")
                                        ? "<span class='status-badge active'>✓ Verificado</span>"
                                        : "<span class='status-badge pending'>Pendiente</span>" %>
                                </td>
                                <td>
                                    <span style="font-size: 0.85rem;">🐾 <%# Eval("TotalMascotas") %> mascotas | 👥 <%#
                                                Eval("TotalUsuarios") %> usuarios</span>
                                </td>
                                <td>
                                    <asp:LinkButton ID="btnVerificar" runat="server" CommandName="Verificar"
                                        CommandArgument='<%# Eval("IdRefugio") %>' CssClass="table-action-btn edit"
                                        Visible='<%# !(bool)Eval("Verificado") %>'>
                                        ✓ Verificar
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnRechazar" runat="server" CommandName="Rechazar"
                                        CommandArgument='<%# Eval("IdRefugio") %>' CssClass="table-action-btn delete"
                                        Visible='<%# (bool)Eval("Verificado") %>'>
                                        ✗ Quitar
                                    </asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>

            <asp:Panel ID="pnlSinResultados" runat="server" Visible="false">
                <div style="text-align: center; padding: 2rem; color: var(--text-light);">
                    <p>No se encontraron refugios.</p>
                </div>
            </asp:Panel>
        </div>
    </asp:Content>