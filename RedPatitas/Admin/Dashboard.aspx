<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true"
    CodeBehind="Dashboard.aspx.cs" Inherits="RedPatitas.Admin.Dashboard" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
        <div class="content-wrapper">
            <div class="page-header">
                <h1 class="page-title">Dashboard Administrador</h1>
                <div class="breadcrumb">Panel / Resumen General</div>
            </div>

            <!-- Stats -->
            <div class="admin-stats">
                <div class="admin-stat-card">
                    <div class="stat-icon users">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="28"
                            height="28">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                        </svg>
                    </div>
                    <div class="stat-info">
                        <h3>
                            <asp:Literal ID="litTotalUsuarios" runat="server" Text="0"></asp:Literal>
                        </h3>
                        <p>Usuarios Registrados</p>
                        <span class="stat-trend">
                            <asp:Literal ID="litTendenciaUsuarios" runat="server" Text=""></asp:Literal>
                        </span>
                    </div>
                </div>
                <div class="admin-stat-card">
                    <div class="stat-icon pets">
                        <svg viewBox="0 0 24 24" fill="currentColor" width="28" height="28">
                            <path
                                d="M12,11.36C12.55,11.36 13,10.91 13,10.36V8.36C13,7.81 12.55,7.36 12,7.36C11.45,7.36 11,7.81 11,8.36V10.36C11,10.91 11.45,11.36 12,11.36M12,12.36C10.5,12.36 9.1,12.76 7.9,13.46C7.3,12.86 6.4,12.36 5.5,12.36C3.5,12.36 2,13.86 2,15.86C2,17.86 3.5,19.36 5.5,19.36C6.5,19.36 7.4,18.96 8.1,18.26C9,19.56 10.4,20.36 12,20.36C13.6,20.36 15,19.56 15.9,18.26C16.6,18.96 17.5,19.36 18.5,19.36C20.5,19.36 22,17.86 22,15.86C22,13.86 20.5,12.36 18.5,12.36C17.6,12.36 16.7,12.86 16.1,13.46C14.9,12.76 13.5,12.36 12,12.36Z" />
                        </svg>
                    </div>
                    <div class="stat-info">
                        <h3>
                            <asp:Literal ID="litTotalMascotas" runat="server" Text="0"></asp:Literal>
                        </h3>
                        <p>Mascotas Publicadas</p>
                        <span class="stat-trend">
                            <asp:Literal ID="litTendenciaMascotas" runat="server" Text=""></asp:Literal>
                        </span>
                    </div>
                </div>
                <div class="admin-stat-card">
                    <div class="stat-icon reports">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="28"
                            height="28">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                    </div>
                    <div class="stat-info">
                        <h3>
                            <asp:Literal ID="litReportesActivos" runat="server" Text="0"></asp:Literal>
                        </h3>
                        <p>Reportes Activos</p>
                        <span class="stat-trend">
                            <asp:Literal ID="litTendenciaReportes" runat="server" Text=""></asp:Literal>
                        </span>
                    </div>
                </div>
                <div class="admin-stat-card">
                    <div class="stat-icon adoptions">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="28"
                            height="28">
                            <path
                                d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                            </path>
                        </svg>
                    </div>
                    <div class="stat-info">
                        <h3>
                            <asp:Literal ID="litAdopcionesExitosas" runat="server" Text="0"></asp:Literal>
                        </h3>
                        <p>Adopciones Exitosas</p>
                        <span class="stat-trend">
                            <asp:Literal ID="litTendenciaAdopciones" runat="server" Text=""></asp:Literal>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Grid -->
            <div class="admin-grid">
                <div class="admin-panel">
                    <div class="panel-header">
                        <h2 class="panel-title">Usuarios Recientes</h2>
                        <a href="Usuarios.aspx" class="panel-action">Ver todos →</a>
                    </div>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Usuario</th>
                                <th>Rol</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptUsuariosRecientes" runat="server"
                                OnItemDataBound="rptUsuariosRecientes_ItemDataBound">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <div class="user-cell">
                                                <asp:Panel ID="pnlAvatar" runat="server" CssClass="user-avatar">
                                                    <%# Eval("Iniciales") %>
                                                </asp:Panel>
                                                <div>
                                                    <div class="user-name">
                                                        <%# Eval("Nombre") %>
                                                            <%# Eval("Apellido") %>
                                                    </div>
                                                    <div class="user-email">
                                                        <%# Eval("Email") %>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <%# Eval("Rol") %>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblEstado" runat="server"
                                                CssClass='<%# (bool)Eval("EstadoActivo") ? "status-badge active" : "status-badge inactive" %>'
                                                Text='<%# (bool)Eval("EstadoActivo") ? "Activo" : "Inactivo" %>'>
                                            </asp:Label>
                                        </td>
                                        <td>
                                            <a href='Usuarios.aspx' class="table-action-btn edit">Ver</a>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                            <asp:Panel ID="pnlSinUsuarios" runat="server" Visible="false">
                                <tr>
                                    <td colspan="4" style="text-align: center; padding: 20px; color: #888;">No hay
                                        usuarios registrados aún
                                    </td>
                                </tr>
                            </asp:Panel>
                        </tbody>
                    </table>
                </div>

                <div class="admin-panel">
                    <div class="panel-header">
                        <h2 class="panel-title">Actividad Reciente</h2>
                    </div>
                    <div class="activity-list">
                        <asp:Repeater ID="rptActividadReciente" runat="server"
                            OnItemDataBound="rptActividadReciente_ItemDataBound">
                            <ItemTemplate>
                                <div class="activity-item">
                                    <asp:Panel ID="pnlIcono" runat="server" CssClass="activity-icon">
                                        <asp:Literal ID="litIcono" runat="server"></asp:Literal>
                                    </asp:Panel>
                                    <div class="activity-content">
                                        <p>
                                            <%# Eval("Titulo") %>: <strong>
                                                    <%# Eval("Descripcion") %>
                                                </strong>
                                        </p>
                                        <span>
                                            <%# Eval("TiempoRelativo") %>
                                        </span>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Panel ID="pnlSinActividad" runat="server" Visible="false">
                            <div class="activity-item">
                                <div class="activity-icon user">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                        width="18" height="18">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <line x1="12" y1="8" x2="12" y2="12"></line>
                                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                    </svg>
                                </div>
                                <div class="activity-content">
                                    <p>Sin actividad reciente</p>
                                    <span>El sistema está listo</span>
                                </div>
                            </div>
                        </asp:Panel>
                    </div>
                </div>
            </div>

            <!-- Sección de Métricas Detalladas -->
            <div class="admin-grid" style="margin-top: 1.5rem;">
                <!-- Top Refugios por Mascotas -->
                <div class="admin-panel">
                    <div class="panel-header">
                        <h2 class="panel-title">🏠 Top Refugios por Mascotas</h2>
                        <a href="Refugios.aspx" class="panel-action">Ver todos →</a>
                    </div>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Refugio</th>
                                <th>Disponibles</th>
                                <th>Adoptadas</th>
                                <th>Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptTopRefugios" runat="server"
                                OnItemDataBound="rptTopRefugios_ItemDataBound">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <div class="user-cell">
                                                <asp:Panel ID="pnlAvatarRefugio" runat="server" CssClass="user-avatar">
                                                    <%# Eval("Iniciales") %>
                                                </asp:Panel>
                                                <span class="user-name">
                                                    <%# Eval("NombreRefugio") %>
                                                </span>
                                            </div>
                                        </td>
                                        <td><span class="status-badge active">
                                                <%# Eval("MascotasDisponibles") %>
                                            </span></td>
                                        <td><span class="status-badge pending">
                                                <%# Eval("MascotasAdoptadas") %>
                                            </span></td>
                                        <td><strong>
                                                <%# Eval("TotalMascotas") %>
                                            </strong></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                            <asp:Panel ID="pnlSinRefugios" runat="server" Visible="false">
                                <tr>
                                    <td colspan="4" style="text-align: center; padding: 20px; color: #888;">No hay
                                        refugios con mascotas</td>
                                </tr>
                            </asp:Panel>
                        </tbody>
                    </table>
                </div>

                <!-- Adopciones por Mes -->
                <div class="admin-panel">
                    <div class="panel-header">
                        <h2 class="panel-title">📊 Adopciones por Mes</h2>
                    </div>
                    <div style="padding: 1rem;">
                        <asp:Repeater ID="rptAdopcionesMes" runat="server">
                            <ItemTemplate>
                                <div style="display: flex; align-items: center; margin-bottom: 0.75rem;">
                                    <span style="width: 40px; font-weight: 500; font-size: 0.85rem;">
                                        <%# Eval("NombreMes") %>
                                    </span>
                                    <div
                                        style="flex: 1; background: #F0F0F0; border-radius: 4px; height: 24px; margin: 0 0.75rem; overflow: hidden;">
                                        <div
                                            style='height: 100%; background: linear-gradient(90deg, #FF6B35, #FF8A50); border-radius: 4px; width: <%# GetBarWidth(Eval("CantidadAdopciones")) %>%;'>
                                        </div>
                                    </div>
                                    <span style="width: 30px; font-weight: 600; text-align: right;">
                                        <%# Eval("CantidadAdopciones") %>
                                    </span>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Panel ID="pnlSinAdopciones" runat="server" Visible="false">
                            <p style="text-align: center; color: #888; padding: 1rem;">Sin adopciones en los últimos
                                meses</p>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>

    </asp:Content>