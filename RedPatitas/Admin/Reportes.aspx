<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true"
    CodeBehind="Reportes.aspx.cs" Inherits="RedPatitas.Admin.Reportes" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Reportes | Admin
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
    </asp:Content>
    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
        <div class="page-header" style="display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h1 class="page-title">Reportes del Sistema</h1>
                <div class="breadcrumb">Admin / Reportes</div>
            </div>
            <asp:Button ID="btnExportarExcel" runat="server" Text="📥 Exportar Excel" CssClass="btn-add"
                OnClick="btnExportarExcel_Click" />
        </div>

        <!-- Resumen General -->
        <div class="admin-stats">
            <div class="admin-stat-card">
                <div class="stat-icon users">👥</div>
                <div class="stat-info">
                    <h3>
                        <asp:Literal ID="litTotalUsuarios" runat="server" Text="0"></asp:Literal>
                    </h3>
                    <p>Usuarios Totales</p>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="stat-icon pets">🏠</div>
                <div class="stat-info">
                    <h3>
                        <asp:Literal ID="litTotalRefugios" runat="server" Text="0"></asp:Literal>
                    </h3>
                    <p>Refugios Activos</p>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="stat-icon adoptions">🐾</div>
                <div class="stat-info">
                    <h3>
                        <asp:Literal ID="litTotalMascotas" runat="server" Text="0"></asp:Literal>
                    </h3>
                    <p>Mascotas Registradas</p>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="stat-icon reports">❤️</div>
                <div class="stat-info">
                    <h3>
                        <asp:Literal ID="litTotalAdopciones" runat="server" Text="0"></asp:Literal>
                    </h3>
                    <p>Adopciones Realizadas</p>
                </div>
            </div>
        </div>

        <div class="admin-grid" style="margin-top: 1.5rem;">
            <!-- Usuarios por Rol -->
            <div class="admin-panel">
                <div class="panel-header">
                    <h2 class="panel-title">👥 Usuarios por Rol</h2>
                </div>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Rol</th>
                            <th>Cantidad</th>
                            <th>Porcentaje</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptUsuariosPorRol" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><span class='status-badge <%# Eval("ClaseBadge") %>'>
                                            <%# Eval("NombreRol") %>
                                        </span></td>
                                    <td><strong>
                                            <%# Eval("Cantidad") %>
                                        </strong></td>
                                    <td>
                                        <%# Eval("Porcentaje") %>%
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>

            <!-- Mascotas por Estado -->
            <div class="admin-panel">
                <div class="panel-header">
                    <h2 class="panel-title">🐾 Mascotas por Estado</h2>
                </div>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Estado</th>
                            <th>Cantidad</th>
                            <th>Porcentaje</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptMascotasPorEstado" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><span class='status-badge <%# Eval("ClaseBadge") %>'>
                                            <%# Eval("Estado") %>
                                        </span></td>
                                    <td><strong>
                                            <%# Eval("Cantidad") %>
                                        </strong></td>
                                    <td>
                                        <%# Eval("Porcentaje") %>%
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Adopciones por Mes -->
        <div class="admin-panel" style="margin-top: 1.5rem;">
            <div class="panel-header">
                <h2 class="panel-title">📊 Adopciones Mensuales (Últimos 12 meses)</h2>
            </div>
            <div style="padding: 1rem;">
                <asp:Repeater ID="rptAdopcionesMensuales" runat="server">
                    <ItemTemplate>
                        <div style="display: flex; align-items: center; margin-bottom: 0.5rem;">
                            <span style="width: 80px; font-weight: 500; font-size: 0.85rem;">
                                <%# Eval("NombreMes") %>
                                    <%# Eval("Anio") %>
                            </span>
                            <div
                                style="flex: 1; background: #F0F0F0; border-radius: 4px; height: 20px; margin: 0 0.75rem; overflow: hidden;">
                                <div
                                    style='height: 100%; background: linear-gradient(90deg, #27AE60, #2ECC71); border-radius: 4px; width: <%# Eval("PorcentajeBarra") %>%;'>
                                </div>
                            </div>
                            <span style="width: 40px; font-weight: 600; text-align: right;">
                                <%# Eval("CantidadAdopciones") %>
                            </span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <!-- Reportes de Mascotas Perdidas -->
        <div class="admin-panel" style="margin-top: 1.5rem;">
            <div class="panel-header">
                <h2 class="panel-title">🔍 Estadísticas de Mascotas Perdidas</h2>
                <a href="MascotasPerdidas.aspx" class="btn btn-secondary">Ver Lista →</a>
            </div>
            <div class="admin-stats" style="margin: 0; padding: 1rem;">
                <div class="admin-stat-card" style="flex: 1; margin: 0.5rem;">
                    <div class="stat-icon reports">📋</div>
                    <div class="stat-info">
                        <h3>
                            <asp:Literal ID="litReportesTotales" runat="server" Text="0"></asp:Literal>
                        </h3>
                        <p>Total Reportes</p>
                    </div>
                </div>
                <div class="admin-stat-card" style="flex: 1; margin: 0.5rem;">
                    <div class="stat-icon" style="background: #E74C3C;">🔴</div>
                    <div class="stat-info">
                        <h3>
                            <asp:Literal ID="litReportesPerdidas" runat="server" Text="0"></asp:Literal>
                        </h3>
                        <p>Mascotas Perdidas</p>
                    </div>
                </div>
                <div class="admin-stat-card" style="flex: 1; margin: 0.5rem;">
                    <div class="stat-icon" style="background: #27AE60;">🟢</div>
                    <div class="stat-info">
                        <h3>
                            <asp:Literal ID="litReportesEncontradas" runat="server" Text="0"></asp:Literal>
                        </h3>
                        <p>Mascotas Encontradas</p>
                    </div>
                </div>
                <div class="admin-stat-card" style="flex: 1; margin: 0.5rem;">
                    <div class="stat-icon" style="background: #8B5CF6;">❤️</div>
                    <div class="stat-info">
                        <h3>
                            <asp:Literal ID="litReportesReunidas" runat="server" Text="0"></asp:Literal>
                        </h3>
                        <p>Reunidas con Dueño</p>
                    </div>
                </div>
                <div class="admin-stat-card" style="flex: 1; margin: 0.5rem;">
                    <div class="stat-icon users">👀</div>
                    <div class="stat-info">
                        <h3>
                            <asp:Literal ID="litTotalAvistamientos" runat="server" Text="0"></asp:Literal>
                        </h3>
                        <p>Avistamientos</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Top 5 Refugios -->
        <div class="admin-panel" style="margin-top: 1.5rem;">
            <div class="panel-header">
                <h2 class="panel-title">🏆 Top 5 Refugios por Adopciones</h2>
            </div>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Refugio</th>
                        <th>Mascotas</th>
                        <th>Adoptadas</th>
                        <th>Tasa Éxito</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptTopRefugios" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td><strong>
                                        <%# Container.ItemIndex + 1 %>
                                    </strong></td>
                                <td>
                                    <div class="user-cell">
                                        <div class="user-avatar" style="background: #27AE60;">
                                            <%# Eval("Iniciales") %>
                                        </div>
                                        <span class="user-name">
                                            <%# Eval("NombreRefugio") %>
                                        </span>
                                    </div>
                                </td>
                                <td>
                                    <%# Eval("TotalMascotas") %>
                                </td>
                                <td><span class="status-badge active">
                                        <%# Eval("MascotasAdoptadas") %>
                                    </span></td>
                                <td>
                                    <%# Eval("TasaExito") %>%
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlSinRefugios" runat="server" Visible="false">
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 20px; color: #888;">No hay datos de
                                refugios</td>
                        </tr>
                    </asp:Panel>
                </tbody>
            </table>
        </div>
    </asp:Content>