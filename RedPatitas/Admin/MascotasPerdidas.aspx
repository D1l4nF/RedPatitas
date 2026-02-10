<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true"
    CodeBehind="MascotasPerdidas.aspx.cs" Inherits="RedPatitas.Admin.MascotasPerdidas" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Mascotas Perdidas | Admin
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
    </asp:Content>
    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
        <div class="page-header">
            <h1 class="page-title">Reportes de Mascotas Perdidas</h1>
            <div class="breadcrumb">Admin / Mascotas Perdidas</div>
        </div>

        <!-- Estadísticas -->
        <div class="admin-stats">
            <div class="admin-stat-card">
                <div class="stat-icon reports">🔍</div>
                <div class="stat-info">
                    <h3>
                        <asp:Literal ID="litTotalReportes" runat="server" Text="0"></asp:Literal>
                    </h3>
                    <p>Total Reportes</p>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="stat-icon pets">🐕</div>
                <div class="stat-info">
                    <h3>
                        <asp:Literal ID="litPerdidas" runat="server" Text="0"></asp:Literal>
                    </h3>
                    <p>Mascotas Perdidas</p>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="stat-icon adoptions">🐾</div>
                <div class="stat-info">
                    <h3>
                        <asp:Literal ID="litEncontradas" runat="server" Text="0"></asp:Literal>
                    </h3>
                    <p>Mascotas Encontradas</p>
                </div>
            </div>
            <div class="admin-stat-card">
                <div class="stat-icon users">❤️</div>
                <div class="stat-info">
                    <h3>
                        <asp:Literal ID="litReunidas" runat="server" Text="0"></asp:Literal>
                    </h3>
                    <p>Reunidas con Dueño</p>
                </div>
            </div>
        </div>

        <!-- Filtros -->
        <div class="admin-panel" style="margin-bottom: 1.5rem;">
            <div class="filter-row">
                <div class="form-group">
                    <label>Tipo de Reporte</label>
                    <asp:DropDownList ID="ddlTipo" runat="server" AutoPostBack="true"
                        OnSelectedIndexChanged="Filtros_Changed" CssClass="form-control">
                        <asp:ListItem Value="">-- Todos --</asp:ListItem>
                        <asp:ListItem Value="Perdida">Perdida</asp:ListItem>
                        <asp:ListItem Value="Encontrada">Encontrada</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>Estado</label>
                    <asp:DropDownList ID="ddlEstado" runat="server" AutoPostBack="true"
                        OnSelectedIndexChanged="Filtros_Changed" CssClass="form-control">
                        <asp:ListItem Value="">-- Todos --</asp:ListItem>
                        <asp:ListItem Value="Reportado">Reportado</asp:ListItem>
                        <asp:ListItem Value="EnBusqueda">En Búsqueda</asp:ListItem>
                        <asp:ListItem Value="Avistado">Avistado</asp:ListItem>
                        <asp:ListItem Value="Encontrado">Encontrado</asp:ListItem>
                        <asp:ListItem Value="Reunido">Reunido</asp:ListItem>
                        <asp:ListItem Value="SinResolver">Sin Resolver</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>Buscar</label>
                    <asp:TextBox ID="txtBusqueda" runat="server" placeholder="Nombre, ciudad..."
                        CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>&nbsp;</label>
                    <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="btn btn-primary"
                        OnClick="Filtros_Changed" />
                </div>
            </div>
        </div>

        <!-- Lista de Reportes -->
        <div class="admin-panel">
            <div class="panel-header">
                <h2 class="panel-title">📋 Reportes Activos</h2>
            </div>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Mascota</th>
                        <th>Tipo</th>
                        <th>Ciudad</th>
                        <th>Fecha</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptReportes" runat="server" OnItemCommand="rptReportes_ItemCommand">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <div class="user-cell">
                                        <div class="user-avatar"
                                            style='background: <%# Eval("TipoReporte").ToString() == "Perdida" ? "#E74C3C" : "#27AE60" %>;'>
                                            <%# Eval("TipoReporte").ToString()=="Perdida" ? "🔍" : "✓" %>
                                        </div>
                                        <div>
                                            <strong>
                                                <%# Eval("NombreMascota") ?? "Sin nombre" %>
                                            </strong><br />
                                            <small>
                                                <%# Eval("Especie") %> - <%# Eval("Raza") ?? "Desconocida" %>
                                            </small>
                                        </div>
                                    </div>
                                </td>
                                <td><span
                                        class='status-badge <%# Eval("TipoReporte").ToString() == "Perdida" ? "inactive" : "active" %>'>
                                        <%# Eval("TipoReporte") %>
                                    </span></td>
                                <td>
                                    <%# Eval("Ciudad") ?? "-" %>
                                </td>
                                <td>
                                    <%# Eval("FechaReporte", "{0:dd/MM/yyyy}" ) %>
                                </td>
                                <td><span class='status-badge <%# GetEstadoBadgeClass(Eval("Estado").ToString()) %>'>
                                        <%# Eval("Estado") %>
                                    </span></td>
                                <td>
                                    <a href='../Public/DetalleReporte.aspx?id=<%# Eval("IdReporte") %>'
                                        class="table-action-btn edit" target="_blank" title="Ver en página pública">
                                        👁️ Ver
                                    </a>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlSinReportes" runat="server" Visible="false">
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 2rem; color: #888;">No se encontraron
                                reportes</td>
                        </tr>
                    </asp:Panel>
                </tbody>
            </table>
        </div>
    </asp:Content>