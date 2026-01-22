<%@ Page Title="" Language="C#" MasterPageFile="~/AdminRefugio/AdminRefugio.Master" AutoEventWireup="true"
    CodeBehind="Solicitudes.aspx.cs" Inherits="RedPatitas.AdminRefugio.Solicitudes" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Solicitudes de Adopción | RedPatitas
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <style>
            .request-card {
                background: white;
                border-radius: 12px;
                padding: 1.5rem;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                margin-bottom: 1rem;
                border: 1px solid #eee;
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 1rem;
            }

            .request-info {
                display: flex;
                gap: 1rem;
                align-items: center;
            }

            .request-img {
                width: 80px;
                height: 80px;
                border-radius: 8px;
                object-fit: cover;
            }

            .request-details h4 {
                margin: 0 0 0.5rem 0;
                color: var(--text-dark);
                font-size: 1.1rem;
            }

            .request-meta {
                font-size: 0.9rem;
                color: #666;
                display: flex;
                flex-direction: column;
                gap: 0.25rem;
            }

            .badge-pending {
                background: #FEF3C7;
                color: #D97706;
                padding: 0.25rem 0.75rem;
                border-radius: 99px;
                font-size: 0.8rem;
                font-weight: 600;
            }

            /* Modal Styles */
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 1000;
            }

            .modal-content {
                background: white;
                padding: 2rem;
                border-radius: 12px;
                width: 100%;
                max-width: 500px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
        </style>
    </asp:Content>
    <asp:Content ID="Content4" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">Solicitudes de Adopción</h1>
            <div class="breadcrumb">Dashboard / Solicitudes</div>
        </div>
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

        <div class="recent-section">
            <div class="section-header">
                <h2 class="section-title">Solicitudes Pendientes</h2>
            </div>

            <asp:Repeater ID="rptSolicitudes" runat="server" OnItemCommand="rptSolicitudes_ItemCommand">
                <ItemTemplate>
                    <div class="request-card">
                        <div class="request-info">
                            <img src='<%# Eval("FotoMascota") %>' alt="Mascota" class="request-img"
                                onerror="this.src='https://via.placeholder.com/80'">
                            <div class="request-details">
                                <h4>
                                    <%# Eval("NombreMascota") %>
                                </h4>
                                <div class="request-meta">
                                    <span><i class="fas fa-user"></i> Adoptante: <%# Eval("NombreAdoptante") %>
                                            <%# Eval("ApellidoAdoptante") %></span>
                                    <span><i class="far fa-calendar"></i> Fecha: <%#
                                            Eval("sol_FechaSolicitud", "{0:dd/MM/yyyy}" ) %></span>
                                </div>
                            </div>
                        </div>

                        <div class="action-buttons">
                            <asp:LinkButton ID="btnAprobar" runat="server" CommandName="Aprobar"
                                CommandArgument='<%# Eval("sol_IdSolicitud") %>' CssClass="table-action-btn success"
                                ToolTip="Aprobar"
                                OnClientClick="return confirm('¿Aprobar esta solicitud? La mascota pasará a estado Adoptado.');">
                                <i class="fas fa-check"></i>
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnRechazar" runat="server" CommandName="Rechazar"
                                CommandArgument='<%# Eval("sol_IdSolicitud") %>' CssClass="table-action-btn reject"
                                ToolTip="Rechazar">
                                <i class="fas fa-times"></i>
                            </asp:LinkButton>
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    <div id="noData" runat="server" visible='<%# ((Repeater)Container.Parent).Items.Count == 0 %>'
                        style="padding: 2rem; text-align: center; color: #666;">
                        No hay solicitudes pendientes en este momento.
                    </div>
                </FooterTemplate>
            </asp:Repeater>
        </div>

        <!-- Modal Rechazo -->
        <asp:Panel ID="pnlModalRechazo" runat="server" Visible="false" CssClass="modal-overlay">
            <div class="modal-content">
                <h3 style="margin-bottom: 1rem;">Motivo del Rechazo</h3>
                <p style="color: #666; margin-bottom: 1rem;">Por favor indica por qué se rechaza esta solicitud. Este
                    mensaje podrá ser visto por el adoptante.</p>

                <asp:HiddenField ID="hfIdSolicitudRechazo" runat="server" />

                <div class="form-group">
                    <asp:TextBox ID="txtMotivoRechazo" runat="server" TextMode="MultiLine" Rows="4"
                        CssClass="form-control" placeholder="Escribe el motivo aquí..."></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvMotivo" runat="server" ControlToValidate="txtMotivoRechazo"
                        ErrorMessage="El motivo es obligatorio" ForeColor="Red" ValidationGroup="Rechazo"
                        Display="Dynamic"></asp:RequiredFieldValidator>
                </div>

                <div style="margin-top: 1.5rem; display: flex; justify-content: flex-end; gap: 1rem;">
                    <asp:Button ID="btnCancelarRechazo" runat="server" Text="Cancelar"
                        OnClick="btnCancelarRechazo_Click"
                        style="background: none; border: none; cursor: pointer; color: #666;" />
                    <asp:Button ID="btnConfirmarRechazo" runat="server" Text="Rechazar Solicitud"
                        OnClick="btnConfirmarRechazo_Click" CssClass="quick-action-btn"
                        style="background-color: #EF4444;" ValidationGroup="Rechazo" />
                </div>
            </div>
        </asp:Panel>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            .table-action-btn.success {
                background: #D1FAE5;
                color: #059669;
            }

            .table-action-btn.success:hover {
                background: #059669;
                color: white;
            }

            .table-action-btn.reject {
                background: #FEE2E2;
                color: #DC2626;
            }

            .table-action-btn.reject:hover {
                background: #DC2626;
                color: white;
            }
        </style>
    </asp:Content>