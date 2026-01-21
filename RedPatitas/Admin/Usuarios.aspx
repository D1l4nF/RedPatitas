<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true"
    CodeBehind="Usuarios.aspx.cs" Inherits="RedPatitas.Admin.Usuarios" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Gestión de Usuarios | Admin
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
    </asp:Content>
    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
        <div class="page-header">
            <h1 class="page-title">Gestión de Usuarios</h1>
            <div class="breadcrumb">Admin / Usuarios</div>
        </div>

        <!-- Filtros -->
        <div class="admin-panel" style="margin-bottom: 1.5rem;">
            <div class="panel-header">
                <span class="panel-title">Filtros</span>
            </div>
            <div style="display: flex; gap: 1rem; flex-wrap: wrap; align-items: flex-end;">
                <div>
                    <label
                        style="font-size: 0.8rem; color: var(--text-light); display: block; margin-bottom: 0.25rem;">Rol</label>
                    <asp:DropDownList ID="ddlFiltroRol" runat="server" AutoPostBack="true"
                        OnSelectedIndexChanged="ddlFiltroRol_SelectedIndexChanged" CssClass="form-control">
                        <asp:ListItem Value="0" Text="Todos los roles"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div>
                    <label
                        style="font-size: 0.8rem; color: var(--text-light); display: block; margin-bottom: 0.25rem;">Estado</label>
                    <asp:DropDownList ID="ddlFiltroEstado" runat="server" AutoPostBack="true"
                        OnSelectedIndexChanged="ddlFiltroEstado_SelectedIndexChanged" CssClass="form-control">
                        <asp:ListItem Value="" Text="Todos"></asp:ListItem>
                        <asp:ListItem Value="true" Text="Activos"></asp:ListItem>
                        <asp:ListItem Value="false" Text="Inactivos"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div>
                    <label
                        style="font-size: 0.8rem; color: var(--text-light); display: block; margin-bottom: 0.25rem;">Buscar</label>
                    <asp:TextBox ID="txtBusqueda" runat="server" placeholder="Nombre o email..."
                        CssClass="form-control"></asp:TextBox>
                </div>
                <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="btn btn-primary"
                    OnClick="btnBuscar_Click" />
            </div>
        </div>

        <!-- Tabla de Usuarios -->
        <div class="admin-panel">
            <div class="panel-header">
                <span class="panel-title">Usuarios Registrados</span>
            </div>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Usuario</th>
                        <th>Rol</th>
                        <th>Refugio</th>
                        <th>Estado</th>
                        <th>Último Acceso</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptUsuarios" runat="server" OnItemCommand="rptUsuarios_ItemCommand"
                        OnItemDataBound="rptUsuarios_ItemDataBound">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <div class="user-cell">
                                        <asp:Panel ID="pnlAvatar" runat="server" CssClass="user-avatar">
                                            <%# Eval("Iniciales") %>
                                        </asp:Panel>
                                        <div>
                                            <div class="user-name">
                                                <%# Eval("NombreCompleto") %>
                                            </div>
                                            <div class="user-email">
                                                <%# Eval("Email") %>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class='status-badge <%# GetRolBadgeClass((int)Eval("IdRol")) %>'>
                                        <%# Eval("NombreRol") %>
                                    </span>
                                </td>
                                <td>
                                    <%# Eval("NombreRefugio") %>
                                </td>
                                <td>
                                    <%# (bool)Eval("Bloqueado")
                                        ? "<span class='status-badge inactive'>🔒 Bloqueado</span>" :
                                        ((bool)Eval("Estado") ? "<span class='status-badge active'>Activo</span>"
                                        : "<span class='status-badge inactive'>Inactivo</span>" ) %>
                                </td>
                                <td>
                                    <%# Eval("UltimoAcceso") !=null ?
                                        ((DateTime)Eval("UltimoAcceso")).ToString("dd/MM/yyyy HH:mm") : "Nunca" %>
                                </td>
                                <td>
                                    <asp:LinkButton ID="btnCambiarEstado" runat="server" CommandName="CambiarEstado"
                                        CommandArgument='<%# Eval("IdUsuario") + "," + Eval("Estado") %>'
                                        CssClass='<%# (bool)Eval("Estado") ? "table-action-btn delete" : "table-action-btn edit" %>'
                                        ToolTip='<%# (bool)Eval("Estado") ? "Desactivar" : "Activar" %>'>
                                        <%# (bool)Eval("Estado") ? "Desactivar" : "Activar" %>
                                    </asp:LinkButton>

                                    <asp:LinkButton ID="btnDesbloquear" runat="server" CommandName="Desbloquear"
                                        CommandArgument='<%# Eval("IdUsuario") %>' CssClass="table-action-btn edit"
                                        Visible='<%# (bool)Eval("Bloqueado") %>' ToolTip="Desbloquear cuenta">
                                        🔓 Desbloquear
                                    </asp:LinkButton>

                                    <asp:LinkButton ID="btnAsignarRefugio" runat="server" CommandName="AsignarRefugio"
                                        CommandArgument='<%# Eval("IdUsuario") + "," + Eval("IdRol") %>'
                                        CssClass="table-action-btn edit"
                                        Visible='<%# (int)Eval("IdRol") == 2 || (int)Eval("IdRol") == 3 %>'
                                        ToolTip="Asignar a refugio">
                                        🏠 Asignar
                                    </asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>

            <asp:Panel ID="pnlSinResultados" runat="server" Visible="false">
                <div style="text-align: center; padding: 2rem; color: var(--text-light);">
                    <p>No se encontraron usuarios con los filtros seleccionados.</p>
                </div>
            </asp:Panel>
        </div>

        <!-- Modal para Asignar Refugio -->
        <asp:Panel ID="pnlModalAsignar" runat="server" CssClass="modal-overlay">
            <div class="modal">
                <div class="modal-title">Asignar Usuario a Refugio</div>
                <div class="modal-message">
                    <asp:HiddenField ID="hdnUsuarioId" runat="server" />
                    <p style="margin-bottom: 1rem;">Selecciona el refugio:</p>
                    <asp:DropDownList ID="ddlRefugios" runat="server" CssClass="form-control" style="width: 100%;">
                    </asp:DropDownList>
                </div>
                <div class="modal-actions">
                    <asp:Button ID="btnCancelarAsignar" runat="server" Text="Cancelar" CssClass="modal-btn secondary"
                        OnClick="btnCancelarAsignar_Click" />
                    <asp:Button ID="btnConfirmarAsignar" runat="server" Text="Asignar" CssClass="modal-btn primary"
                        OnClick="btnConfirmarAsignar_Click" />
                </div>
            </div>
        </asp:Panel>

        <asp:Label ID="lblMensaje" runat="server" Visible="false"></asp:Label>
    </asp:Content>