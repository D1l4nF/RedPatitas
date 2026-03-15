<%@ Page Title="Actividad del Refugio | RedPatitas" Language="C#" MasterPageFile="~/AdminRefugio/AdminRefugio.Master" AutoEventWireup="true" CodeBehind="Actividad.aspx.cs" Inherits="RedPatitas.AdminRefugio.Actividad" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Actividad | RedPatitas
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="page-header">
        <h1 class="page-title">Historial de Actividad</h1>
        <div class="breadcrumb">Dashboard / Actividad</div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="recent-section">
        <div class="section-header">
            <h2 class="section-title">Registro de Acciones del Staff</h2>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Fecha</th>
                        <th>Miembro del Staff</th>
                        <th>Tipo de Acción</th>
                        <th>Módulo Afectado</th>
                        <th>Detalle/Cambios</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptActividad" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <span class="user-email"><i class="far fa-calendar-alt"></i> <%# Eval("Fecha", "{0:dd/MM/yyyy HH:mm}") %></span>
                                </td>
                                <td>
                                    <div class="user-name">
                                        <i class="fas fa-user-circle"></i> <%# Eval("UsuarioNombre") %>
                                    </div>
                                </td>
                                <td>
                                    <span class='status-badge <%# GetActionClass(Eval("Accion").ToString()) %>'>
                                        <%# TraducirAccion(Eval("Accion").ToString()) %>
                                    </span>
                                </td>
                                <td>
                                    <%# TraducirTabla(Eval("Tabla").ToString()) %>
                                </td>
                                <td>
                                    <%# FormatDetails(Eval("Accion").ToString(), Eval("DetalleNuevo"), Eval("DetallePrevio")) %>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
            
            <asp:Panel ID="pnlNoData" runat="server" Visible="false" CssClass="no-data-msg" style="padding: 2rem; text-align: center; color: #666;">
                No hay registros de actividad todavía.
            </asp:Panel>
        </div>
    </div>
</asp:Content>
