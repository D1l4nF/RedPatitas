<%@ Page Title="Mis Seguimientos" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true"
    CodeBehind="MisSeguimientos.aspx.cs" Inherits="RedPatitas.Adoptante.MisSeguimientos" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Mis Seguimientos | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">📅 Cronograma de Seguimiento</h1>
            <div class="breadcrumb">Panel > Mis Mascotas > Seguimientos</div>
        </div>
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
        <style>
            .timeline-container {
                max-width: 900px;
                margin: 0 auto;
                background: #fff;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            }

            .timeline-mascota-info {
                display: flex;
                align-items: center;
                gap: 15px;
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 2px solid #eee;
            }

            .timeline-mascota-info img {
                width: 60px;
                height: 60px;
                border-radius: 50%;
                object-fit: cover;
                border: 3px solid var(--primary-color);
            }

            /* DISEÑO TIPO TIMELINE VERTICAL */
            .timeline {
                position: relative;
                padding-left: 30px;
            }

            .timeline::before {
                content: '';
                position: absolute;
                left: 0;
                top: 0;
                bottom: 0;
                width: 2px;
                background: #e0e0e0;
            }

            .timeline-item {
                position: relative;
                margin-bottom: 30px;
                background: #fdfdfd;
                border: 1px solid #eee;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.02);
            }

            .timeline-item::before {
                content: '';
                position: absolute;
                left: -36px;
                top: 20px;
                width: 14px;
                height: 14px;
                border-radius: 50%;
                background: var(--primary-color);
                border: 3px solid #fff;
                box-shadow: 0 0 0 2px var(--primary-color);
            }

            /* Estados de colores */
            .item-aprobado {
                border-left: 4px solid var(--success);
            }

            .item-aprobado::before {
                background: var(--success);
                box-shadow: 0 0 0 2px var(--success);
            }

            .item-pendiente {
                border-left: 4px solid #ccc;
                opacity: 0.7;
            }

            .item-pendiente::before {
                background: #ccc;
                box-shadow: 0 0 0 2px #ccc;
            }

            .item-disponible {
                border-left: 4px solid var(--primary-color);
            }

            .item-rechazado {
                border-left: 4px solid var(--error);
                background: #fff5f5;
            }

            .item-rechazado::before {
                background: var(--error);
                box-shadow: 0 0 0 2px var(--error);
            }

            .item-enviado {
                border-left: 4px solid var(--info);
            }

            .item-enviado::before {
                background: var(--info);
                box-shadow: 0 0 0 2px var(--info);
            }


            .timeline-header {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
                align-items: center;
            }

            .timeline-title {
                font-size: 1.1rem;
                font-weight: bold;
                color: var(--secondary-color);
            }

            .timeline-date {
                font-size: 0.85rem;
                color: #777;
                background: #f0f0f0;
                padding: 4px 10px;
                border-radius: 20px;
            }

            .timeline-body {
                color: #555;
                font-size: 0.95rem;
                margin-bottom: 15px;
            }

            .status-badge {
                display: inline-block;
                padding: 4px 10px;
                border-radius: 4px;
                font-size: 0.85rem;
                font-weight: bold;
            }

            .btn-accion-timeline {
                display: inline-block;
                margin-top: 10px;
                padding: 8px 20px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: bold;
                transition: all 0.3s;
            }

            .badge-aprobado {
                background: #e8f5e9;
                color: #2e7d32;
            }

            .badge-pendiente {
                background: #f5f5f5;
                color: #757575;
            }

            .badge-disponible {
                background: #fff3e0;
                color: #e65100;
                animation: pulse 2s infinite;
            }

            .badge-rechazado {
                background: #ffebee;
                color: #c62828;
            }

            .badge-enviado {
                background: #e3f2fd;
                color: #1565c0;
            }

            @keyframes pulse {
                0% {
                    box-shadow: 0 0 0 0 rgba(255, 140, 66, 0.4);
                }

                70% {
                    box-shadow: 0 0 0 6px rgba(255, 140, 66, 0);
                }

                100% {
                    box-shadow: 0 0 0 0 rgba(255, 140, 66, 0);
                }
            }
        </style>

        <div class="timeline-container">

            <div class="timeline-mascota-info">
                <asp:Image ID="imgMascota" runat="server"
                    ImageUrl="https://ui-avatars.com/api/?name=Mis+Mascotas&background=FF8C42&color=fff&size=150" />
                <div>
                    <h2 style="margin:0; color:var(--secondary-color);" id="lblNombreMascota" runat="server">Mascota
                    </h2>
                    <span style="color:#666;">Documenta el proceso de adaptación de tu mascota en su nuevo hogar y
                        aseguremos que todo esté perfecto. </span>
                </div>
            </div>

            <div class="timeline">
                <asp:Repeater ID="rpSeguimientos" runat="server" OnItemDataBound="rpSeguimientos_ItemDataBound">
                    <ItemTemplate>
                        <!-- El CSS Class cambiará dinámicamente desde el Backend -->
                        <div class="timeline-item <%# Eval(" CssClassContainer") %>">
                            <div class="timeline-header">
                                <div class="timeline-title">
                                    <%# Eval("Titulo") %> - 🐾 <%# Eval("NombreMascota") %>
                                </div>
                                <div class="timeline-date">🗓️ Programado para: <%#
                                        Eval("FechaProgramada", "{0:dd/MM/yyyy}" ) %>
                                </div>
                            </div>

                            <div class="timeline-body">
                                <%# Eval("MensajeExplicativo") %>
                            </div>

                            <div>
                                <span class="status-badge <%# Eval(" CssClassBadge") %>">
                                    Estado: <%# Eval("Estado") %>
                                </span>
                            </div>

                            <!-- Botón para llenar formulario, solo visible si está Disponible o Rechazado -->
                            <asp:HyperLink ID="lnkCompletar" runat="server"
                                NavigateUrl='<%# "~/Adoptante/CompletarSeguimiento.aspx?id=" + Eval("IdSeguimiento") %>'
                                CssClass="btn-primary btn-accion-timeline"
                                Visible='<%# Convert.ToBoolean(Eval("MostrarBoton")) %>'>
                                📸 Completar Reporte Ahora
                            </asp:HyperLink>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <div id="divVacio" runat="server" visible="false" class="empty-state" style="border:none;">
                    <div class="empty-state-icon" style="font-size: 3rem;">🐾</div>
                    <h3 style="color:var(--primary-color);">Aún no tienes mascotas en seguimiento</h3>
                    <p style="color:#666;">Cuando tu solicitud de adopción sea aprobada, aquí podrás documentar cómo le
                        va a tu mascota.</p>
                </div>
            </div>
        </div>
    </asp:Content>