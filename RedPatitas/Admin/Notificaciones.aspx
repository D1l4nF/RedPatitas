<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true"
    CodeBehind="Notificaciones.aspx.cs" Inherits="RedPatitas.Admin.Notificaciones" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Notificaciones | Admin
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
    </asp:Content>
    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
        <div class="page-header" style="display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h1 class="page-title">Notificaciones a Refugios</h1>
                <div class="breadcrumb">Admin / Notificaciones</div>
            </div>
            <asp:Button ID="btnNuevaNotificacion" runat="server" Text="+ Nueva Notificación" CssClass="btn-add"
                OnClick="btnNuevaNotificacion_Click" />
        </div>

        <!-- Formulario Nueva Notificación -->
        <asp:Panel ID="pnlFormulario" runat="server" Visible="false" CssClass="admin-panel"
            style="margin-bottom: 1.5rem;">
            <div class="panel-header">
                <h2 class="panel-title">📧 Enviar Notificación</h2>
            </div>
            <div style="padding: 1rem;">
                <div class="form-row">
                    <div class="form-group">
                        <label>Destinatarios</label>
                        <asp:DropDownList ID="ddlDestinatarios" runat="server">
                            <asp:ListItem Value="todos">Todos los Refugios</asp:ListItem>
                            <asp:ListItem Value="verificados">Solo Verificados</asp:ListItem>
                            <asp:ListItem Value="pendientes">Solo Pendientes de Verificación</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>Tipo de Notificación</label>
                        <asp:DropDownList ID="ddlTipo" runat="server">
                            <asp:ListItem Value="info">ℹ️ Informativa</asp:ListItem>
                            <asp:ListItem Value="alerta">⚠️ Alerta</asp:ListItem>
                            <asp:ListItem Value="urgente">🚨 Urgente</asp:ListItem>
                            <asp:ListItem Value="mantenimiento">🔧 Mantenimiento</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="form-group">
                    <label>Título</label>
                    <asp:TextBox ID="txtTitulo" runat="server" placeholder="Título de la notificación"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Mensaje</label>
                    <asp:TextBox ID="txtMensaje" runat="server" TextMode="MultiLine" Rows="4"
                        placeholder="Escriba el mensaje..."></asp:TextBox>
                </div>
                <asp:Button ID="btnEnviar" runat="server" Text="📤 Enviar Notificación" CssClass="btn-add"
                    OnClick="btnEnviar_Click" />
                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="table-action-btn"
                    OnClick="btnCancelar_Click" />
                <asp:Label ID="lblMensaje" runat="server" Visible="false" style="margin-left: 1rem;"></asp:Label>
            </div>
        </asp:Panel>

        <!-- Historial de Notificaciones -->
        <div class="admin-panel">
            <div class="panel-header">
                <h2 class="panel-title">📋 Historial de Notificaciones</h2>
            </div>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Fecha</th>
                        <th>Tipo</th>
                        <th>Título</th>
                        <th>Destinatarios</th>
                        <th>Enviado por</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptNotificaciones" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <%# Eval("Fecha", "{0:dd/MM/yyyy HH:mm}" ) %>
                                </td>
                                <td><span class='status-badge <%# GetTipoBadgeClass(Eval("Tipo").ToString()) %>'>
                                        <%# GetTipoIcono(Eval("Tipo").ToString()) %>
                                    </span></td>
                                <td><strong>
                                        <%# Eval("Titulo") %>
                                    </strong><br /><small style="color:#888;">
                                        <%# Eval("Mensaje") %>
                                    </small></td>
                                <td>
                                    <%# Eval("Destinatarios") %>
                                </td>
                                <td>
                                    <%# Eval("EnviadoPor") %>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlSinNotificaciones" runat="server" Visible="false">
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 2rem; color: #888;">No hay
                                notificaciones enviadas</td>
                        </tr>
                    </asp:Panel>
                </tbody>
            </table>
        </div>
    </asp:Content>