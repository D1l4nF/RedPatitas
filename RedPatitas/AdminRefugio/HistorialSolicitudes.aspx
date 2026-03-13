<%@ Page Title="" Language="C#" MasterPageFile="~/AdminRefugio/AdminRefugio.Master" AutoEventWireup="true" CodeBehind="HistorialSolicitudes.aspx.cs" Inherits="RedPatitas.AdminRefugio.HistorialSolicitudes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Historial de Solicitudes | RedPatitas
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <!-- No inline styles, using estilos-paneles.css which is included in Master Page -->
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="container-centered">
        <div class="page-header">
            <h1 class="page-title">Historial de Solicitudes</h1>
            <div class="breadcrumb">Dashboard / Historial de Solicitudes</div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-centered">
        <div class="recent-section">
            <div class="section-header">
                <h2 class="section-title">Todas las Solicitudes Recibidas</h2>
            </div>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Solicitante</th>
                            <th>Mascota</th>
                            <th>Fecha</th>
                            <th>Estado</th>
                            <th>Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptHistorial" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <div class="pet-cell">
                                            <div class="avatar avatar-dynamic">
                                                <i class="fas fa-user"></i>
                                            </div>
                                            <div>
                                                <div class="user-name">
                                                    <%# Eval("NombreAdoptante") %> <%# Eval("ApellidoAdoptante") %>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="pet-cell">
                                            <img src='<%# Eval("FotoMascota") %>' alt="Mascota" class="pet-img" onerror="this.src='https://via.placeholder.com/40'" />
                                            <div>
                                                <div class="user-name">
                                                    <%# Eval("NombreMascota") %>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="role-badge">
                                            <%# Eval("sol_FechaSolicitud", "{0:dd/MM/yyyy HH:mm}") %>
                                        </span>
                                    </td>
                                    <td>
                                        <span class='status-badge <%# string.Equals(Eval("Estado").ToString(), "Aprobada", StringComparison.OrdinalIgnoreCase) ? "available" : (string.Equals(Eval("Estado").ToString(), "Rechazada", StringComparison.OrdinalIgnoreCase) ? "reject" : "pending") %>'>
                                            <%# Eval("Estado") %>
                                        </span>
                                    </td>
                                    <td>
                                        <a href='RevisarSolicitud.aspx?id=<%# Eval("sol_IdSolicitud") %>' class="btn-link">
                                            <i class="fas fa-search"></i> Ver Detalles
                                        </a>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                        
                        <tr id="trNoData" runat="server" visible="false">
                            <td colspan="5" style="text-align: center; color: #666; padding: 2rem;">
                                No se han recibido solicitudes todavía.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
