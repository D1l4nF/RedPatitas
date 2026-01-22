<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true"
    CodeBehind="Auditoria.aspx.cs" Inherits="RedPatitas.Admin.Auditoria" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Auditoría | Admin
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
    </asp:Content>
    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
        <div class="page-header">
            <h1 class="page-title">Historial de Auditoría</h1>
            <div class="breadcrumb">Admin / Auditoría</div>
        </div>

        <!-- Filtros -->
        <div class="admin-panel" style="margin-bottom: 1.5rem;">
            <div class="form-row">
                <div class="form-group">
                    <label>Filtrar por Acción</label>
                    <asp:DropDownList ID="ddlAccion" runat="server" AutoPostBack="true"
                        OnSelectedIndexChanged="Filtros_Changed">
                        <asp:ListItem Value="">-- Todas --</asp:ListItem>
                        <asp:ListItem Value="LOGIN">Login</asp:ListItem>
                        <asp:ListItem Value="LOGOUT">Logout</asp:ListItem>
                        <asp:ListItem Value="INSERT">Creación</asp:ListItem>
                        <asp:ListItem Value="UPDATE">Actualización</asp:ListItem>
                        <asp:ListItem Value="DELETE">Eliminación</asp:ListItem>
                        <asp:ListItem Value="CUENTA_BLOQUEADA">Cuenta Bloqueada</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>Filtrar por Tabla</label>
                    <asp:DropDownList ID="ddlTabla" runat="server" AutoPostBack="true"
                        OnSelectedIndexChanged="Filtros_Changed">
                        <asp:ListItem Value="">-- Todas --</asp:ListItem>
                        <asp:ListItem Value="tbl_Usuarios">Usuarios</asp:ListItem>
                        <asp:ListItem Value="tbl_Mascotas">Mascotas</asp:ListItem>
                        <asp:ListItem Value="tbl_Refugios">Refugios</asp:ListItem>
                        <asp:ListItem Value="tbl_SolicitudesAdopcion">Solicitudes</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>Fecha Desde</label>
                    <asp:TextBox ID="txtFechaDesde" runat="server" TextMode="Date" AutoPostBack="true"
                        OnTextChanged="Filtros_Changed"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Fecha Hasta</label>
                    <asp:TextBox ID="txtFechaHasta" runat="server" TextMode="Date" AutoPostBack="true"
                        OnTextChanged="Filtros_Changed"></asp:TextBox>
                </div>
            </div>
        </div>

        <!-- Tabla de Logs -->
        <div class="admin-panel">
            <div class="panel-header">
                <h2 class="panel-title">📋 Registros de Actividad</h2>
                <asp:Label ID="lblTotal" runat="server" CssClass="panel-action"></asp:Label>
            </div>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Fecha/Hora</th>
                        <th>Usuario</th>
                        <th>Acción</th>
                        <th>Tabla</th>
                        <th>IP</th>
                        <th>Detalles</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptAuditoria" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <%# Eval("Fecha", "{0:dd/MM/yyyy HH:mm}" ) %>
                                </td>
                                <td>
                                    <div class="user-cell">
                                        <div class="user-avatar" style="background: #3498DB;">
                                            <%# Eval("Iniciales") %>
                                        </div>
                                        <span>
                                            <%# Eval("NombreUsuario") %>
                                        </span>
                                    </div>
                                </td>
                                <td><span class='status-badge <%# GetAccionBadgeClass(Eval("Accion").ToString()) %>'>
                                        <%# Eval("Accion") %>
                                    </span></td>
                                <td>
                                    <%# Eval("Tabla") %>
                                </td>
                                <td><small>
                                        <%# Eval("DireccionIP") %>
                                    </small></td>
                                <td><small style="color:#888;">
                                        <%# Eval("Descripcion") %>
                                    </small></td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlSinRegistros" runat="server" Visible="false">
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 2rem; color: #888;">No se encontraron
                                registros con los filtros seleccionados</td>
                        </tr>
                    </asp:Panel>
                </tbody>
            </table>
        </div>
    </asp:Content>