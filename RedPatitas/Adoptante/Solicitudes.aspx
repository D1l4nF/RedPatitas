<%@ Page Title="Mis Solicitudes" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true"
    CodeBehind="Solicitudes.aspx.cs" Inherits="RedPatitas.Adoptante.Solicitudes" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Mis Solicitudes | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link href='<%= ResolveUrl("~/Style/dashboard.css") %>' rel="stylesheet" type="text/css" />
        <link href='<%= ResolveUrl("~/Style/pet-cards.css") %>' rel="stylesheet" type="text/css" />
        <style>
            .solicitud-card {
                background: #fff;
                border-radius: 16px;
                padding: 1.5rem;
                margin-bottom: 1rem;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
                display: flex;
                align-items: center;
                gap: 1.5rem;
                transition: all 0.3s ease;
            }

            .solicitud-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            }

            .solicitud-mascota {
                width: 80px;
                height: 80px;
                border-radius: 12px;
                background: linear-gradient(135deg, #FFE8CC 0%, #FFD275 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 2.5rem;
                flex-shrink: 0;
            }

            .solicitud-info {
                flex: 1;
            }

            .solicitud-nombre {
                font-size: 1.25rem;
                font-weight: 700;
                color: #4A3B32;
                margin-bottom: 0.25rem;
            }

            .solicitud-detalle {
                font-size: 0.9rem;
                color: #666;
                margin-bottom: 0.5rem;
            }

            .solicitud-fecha {
                font-size: 0.85rem;
                color: #999;
            }

            .solicitud-estado {
                padding: 0.5rem 1rem;
                border-radius: 20px;
                font-weight: 600;
                font-size: 0.85rem;
                text-align: center;
                min-width: 120px;
            }

            .estado-pendiente {
                background: #FFF3CD;
                color: #856404;
            }

            .estado-aprobada {
                background: #D4EDDA;
                color: #155724;
            }

            .estado-rechazada {
                background: #F8D7DA;
                color: #721C24;
            }

            .estado-enrevision {
                background: #CCE5FF;
                color: #004085;
            }

            .solicitud-actions {
                display: flex;
                gap: 0.5rem;
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">📋 Mis Solicitudes</h1>
            <div class="breadcrumb">Seguimiento de tus solicitudes de adopción</div>
        </div>
    </asp:Content>

    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

        <!-- Summary Cards -->
        <div class="stats-grid" style="margin-bottom: 2rem;">
            <div class="stat-card">
                <div class="stat-icon orange">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="24" height="24">
                        <circle cx="12" cy="12" r="10" />
                        <polyline points="12 6 12 12 16 14" />
                    </svg>
                </div>
                <div class="stat-info">
                    <h3>
                        <asp:Literal ID="litPendientes" runat="server">0</asp:Literal>
                    </h3>
                    <p>Pendientes</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="24" height="24">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                        <polyline points="22 4 12 14.01 9 11.01" />
                    </svg>
                </div>
                <div class="stat-info">
                    <h3>
                        <asp:Literal ID="litAprobadas" runat="server">0</asp:Literal>
                    </h3>
                    <p>Aprobadas</p>
                </div>
            </div>
        </div>

        <!-- Solicitudes List -->
        <asp:Panel ID="pnlSolicitudes" runat="server">
            <asp:Repeater ID="rptSolicitudes" runat="server">
                <ItemTemplate>
                    <div class="solicitud-card">
                        <div class="solicitud-mascota">
                            <%# GetEmojiEspecie(Eval("tbl_Mascotas.tbl_Razas.tbl_Especies.esp_Nombre")?.ToString()) %>
                        </div>
                        <div class="solicitud-info">
                            <div class="solicitud-nombre">
                                <%# Eval("tbl_Mascotas.mas_Nombre") %>
                            </div>
                            <div class="solicitud-detalle">
                                <%# Eval("tbl_Mascotas.tbl_Razas.raz_Nombre") ?? "Mestizo" %> •
                                    <%# Eval("tbl_Mascotas.tbl_Refugios.ref_Nombre") %>
                            </div>
                            <div class="solicitud-fecha">
                                Solicitado el <%# ((DateTime?)Eval("sol_FechaSolicitud"))?.ToString("dd/MM/yyyy") %>
                            </div>
                        </div>
                        <div class="solicitud-estado <%# GetEstadoClass(Eval(" sol_Estado")?.ToString()) %>">
                            <%# GetEstadoTexto(Eval("sol_Estado")?.ToString()) %>
                        </div>
                        <div class="solicitud-actions">
                            <a href='<%# ResolveUrl("~/Adoptante/PerfilMascota.aspx?id=" + Eval("sol_IdMascota")) %>'
                                class="btn-view-pet" style="padding: 0.5rem 1rem; font-size: 0.85rem;">
                                Ver mascota
                            </a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </asp:Panel>

        <!-- Empty State -->
        <asp:Panel ID="pnlVacio" runat="server" Visible="false" CssClass="empty-state">
            <div class="empty-state-icon">📝</div>
            <h3>No tienes solicitudes de adopción</h3>
            <p>Cuando solicites adoptar una mascota, podrás ver el estado de tu solicitud aquí.</p>
            <a href='<%= ResolveUrl("~/Adoptante/Mascotas.aspx") %>' class="btn-view-pet"
                style="margin-top: 1.5rem; display: inline-flex;">
                🔍 Buscar Mascotas
            </a>
        </asp:Panel>
    </asp:Content>