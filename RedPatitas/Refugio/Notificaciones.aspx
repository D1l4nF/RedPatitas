<%@ Page Title="Notificaciones del Refugio" Language="C#" MasterPageFile="~/Refugio/Refugio.Master" AutoEventWireup="true" CodeBehind="Notificaciones.aspx.cs" Inherits="RedPatitas.Refugio.Notificaciones" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="header-section">
        <div>
            <h2>Notificaciones del Refugio</h2>
            <p>Avisos sobre nuevas solicitudes y pruebas de seguimiento</p>
        </div>
        <div class="header-actions">
            <asp:LinkButton ID="btnMarcarLeidas" runat="server" CssClass="btn-primary-outline" OnClick="btnMarcarLeidas_Click">
                Marcar todas como leídas
            </asp:LinkButton>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="recent-section">
        <asp:Repeater ID="rptNotificaciones" runat="server" OnItemCommand="rptNotificaciones_ItemCommand">
            <ItemTemplate>
                <div class='notif-card <%# Convert.ToBoolean(Eval("Leida")) ? "" : "notif-unread" %>'>
                    <div style="display: flex; align-items: flex-start; gap: 15px;">
                        <div class="notif-icon">
                            <i class='<%# Eval("Icono") %>'></i>
                        </div>
                        <div style="flex-grow: 1;">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 5px;">
                                <span class="notif-title"><%# Eval("Titulo") %></span>
                                <span class="notif-time"><%# Eval("TiempoRelativo") %></span>
                            </div>
                            <p style="margin-bottom: 10px; color: #555;"><%# Eval("Mensaje") %></p>
                            
                            <asp:LinkButton ID="btnAccion" runat="server" CssClass="filter-btn active"
                                CommandName="IrAccion" CommandArgument='<%# Eval("IdNotificacion") + "|" + Eval("UrlAccion") %>'
                                Visible='<%# !string.IsNullOrEmpty(Convert.ToString(Eval("UrlAccion"))) %>'>
                                Ver Detalles
                            </asp:LinkButton>
                            
                            <asp:LinkButton ID="btnMarcarLeida" runat="server" CssClass="filter-btn" style="background: transparent; color: #777; border: none;"
                                CommandName="MarcarLeida" CommandArgument='<%# Eval("IdNotificacion") %>'
                                Visible='<%# !Convert.ToBoolean(Eval("Leida")) %>'>
                                Marcar leída
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
            <FooterTemplate>
                <div runat="server" class="text-center p-4" style="color: #777; text-align: center; margin-top: 2rem;" visible='<%# rptNotificaciones.Items.Count == 0 %>'>
                    No hay notificaciones para el refugio.
                </div>
            </FooterTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
