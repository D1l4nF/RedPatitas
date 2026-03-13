<%@ Page Title="" Language="C#" MasterPageFile="~/Refugio/Refugio.Master" AutoEventWireup="true"
    CodeBehind="Dashboard.aspx.cs" Inherits="RedPatitas.Refugio.Dashboard" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Panel Refugio | RedPatitas
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </asp:Content>
    <asp:Content ID="Content4" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">Panel del Refugio</h1>
            <div class="breadcrumb">Dashboard / Administración</div>
        </div>
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
        <!-- Stats Grid -->
        <div class="stats-grid stats-grid-4">
            <!-- Solicitudes -->
            <div class="stat-card">
                <div class="stat-icon purple">
                    <i class="fas fa-envelope"></i>
                </div>
                <div class="stat-info">
                    <h3>
                        <asp:Literal ID="litSolicitudesPendientes" runat="server">0</asp:Literal>
                    </h3>
                    <p>Solicitudes Pendientes</p>
                    <div class="trend" id="divTrendSolicitudes" runat="server">
                        <small>
                            <asp:Literal ID="litTrendSolicitudes" runat="server">0%</asp:Literal>
                        </small>
                    </div>
                </div>
            </div>

            <!-- Mascotas -->
            <div class="stat-card">
                <div class="stat-icon orange">
                    <i class="fas fa-paw"></i>
                </div>
                <div class="stat-info">
                    <h3>
                        <asp:Literal ID="litMisMascotasPublicadas" runat="server">0</asp:Literal>
                    </h3>
                    <p>Mis Mascotas (Publicadas)</p>
                    <div class="trend" id="divTrendMascotas" runat="server">
                        <small>
                            <asp:Literal ID="litTrendMascotas" runat="server">0%</asp:Literal>
                        </small>
                    </div>
                </div>
            </div>

            <!-- Adopciones -->
            <div class="stat-card">
                <div class="stat-icon green">
                    <i class="fas fa-heart"></i>
                </div>
                <div class="stat-info">
                    <h3>
                        <asp:Literal ID="litMisAdopcionesExitosas" runat="server">0</asp:Literal>
                    </h3>
                    <p>Mis Adopciones Exitosas</p>
                    <div class="trend" id="divTrendAdopciones" runat="server">
                        <small>
                            <asp:Literal ID="litTrendAdopciones" runat="server">0%</asp:Literal>
                        </small>
                    </div>
                </div>
            </div>

            <!-- Reportes -->
            <div class="stat-card">
                <div class="stat-icon blue">
                    <i class="fas fa-file-alt"></i>
                </div>
                <div class="stat-info">
                    <h3>
                        <asp:Literal ID="litReportesActivos" runat="server">0</asp:Literal>
                    </h3>
                    <p>Reportes Activos</p>
                    <div class="trend" id="divTrendReportes" runat="server">
                        <small>
                            <asp:Literal ID="litTrendReportes" runat="server">0%</asp:Literal>
                        </small>
                    </div>
                </div>
            </div>
        </div>

        <div class="dashboard-grid">
            <!-- Solicitudes Recientes -->
            <div class="recent-section">
                <div class="section-header">
                    <h2 class="section-title">Últimas Solicitudes</h2>
                    <a href="Solicitudes.aspx" class="btn-link">Ver Todas</a>
                </div>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Solicitante</th>
                                <th>Detalle</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptSolicitudesRecientes" runat="server">
                                <ItemTemplate>
                                    <tr onclick='window.location="RevisarSolicitud.aspx?id=<%# Eval("IdSolicitud") %>"' style="cursor: pointer;">
                                        <td>
                                            <div class="pet-cell">
                                                <div class="avatar avatar-dynamic">
                                                    <i class="fas fa-paw"></i>
                                                </div>
                                                <div>
                                                    <div class="user-name">
                                                        <%# Eval("NombreAdoptante") %>
                                                    </div>
                                                    <div class="user-email">
                                                        Mascota: <%# Eval("NombreMascota") %>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="role-badge">
                                                <%# Eval("TiempoRelativo") %>
                                            </span>
                                        </td>
                                        <td>
                                            <span
                                                class='status-badge <%# string.Equals(Eval("Estado").ToString(), "Aprobado", StringComparison.OrdinalIgnoreCase) ? "available" : "pending" %>'>
                                                <%# Eval("Estado") %>
                                            </span>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Actividad Reciente -->
            <div class="recent-section activity-section">
                <div class="section-header">
                    <h2 class="section-title">Actividad Reciente</h2>
                </div>
                <div class="activity-list">
                    <asp:Repeater ID="rptActividadReciente" runat="server">
                        <ItemTemplate>
                            <div class="activity-item">
                                <div class='activity-icon <%# GetActivityClass((string)Eval("Tipo")) %>'>
                                    <i class='<%# GetActivityIcon((string)Eval("Tipo")) %>'></i>
                                </div>
                                <div class="activity-content">
                                    <p><strong>
                                            <%# Eval("Titulo") %>
                                        </strong></p>
                                    <p>
                                        <%# Eval("Descripcion") %>
                                    </p>
                                    <span class="activity-time">
                                        <%# Eval("TiempoRelativo") %>
                                    </span>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </asp:Content>