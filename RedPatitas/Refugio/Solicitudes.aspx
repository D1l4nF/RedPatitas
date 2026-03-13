<%@ Page Title="" Language="C#" MasterPageFile="~/Refugio/Refugio.Master" AutoEventWireup="true"
    CodeBehind="Solicitudes.aspx.cs" Inherits="RedPatitas.Refugio.Solicitudes" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Solicitudes de Adopción | RedPatitas
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
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
                            <a href='RevisarSolicitud.aspx?id=<%# Eval("sol_IdSolicitud") %>'
                                class="table-action-btn review" title="Revisar Solicitud">
                                <i class="fas fa-search"></i>
                            </a>
                            <asp:LinkButton ID="btnAprobar" runat="server" CommandName="Aprobar"
                                CommandArgument='<%# Eval("sol_IdSolicitud") %>' CssClass="table-action-btn success"
                                ToolTip="Aprobar rápido (sin revisar)"
                                OnClientClick="return confirm('¿Aprobar sin revisar? Se recomienda revisar la solicitud primero.');">
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
                        class="no-data-msg">
                        No hay solicitudes pendientes en este momento.
                    </div>
                </FooterTemplate>
            </asp:Repeater>
        </div>

        <!-- Modal Rechazo -->
        <asp:Panel ID="pnlModalRechazo" runat="server" Visible="false" CssClass="modal-overlay">
            <div class="modal-content">
                <h3 class="modal-rechazo-title">Motivo del Rechazo</h3>
                <p class="modal-rechazo-text">Por favor indica por qué se rechaza esta solicitud. Este
                    mensaje podrá ser visto por el adoptante.</p>

                <asp:HiddenField ID="hfIdSolicitudRechazo" runat="server" />

                <div class="form-group">
                    <asp:TextBox ID="txtMotivoRechazo" runat="server" TextMode="MultiLine" Rows="4"
                        CssClass="form-control" placeholder="Escribe el motivo aquí..."></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvMotivo" runat="server" ControlToValidate="txtMotivoRechazo"
                        ErrorMessage="El motivo es obligatorio" ForeColor="Red" ValidationGroup="Rechazo"
                        Display="Dynamic"></asp:RequiredFieldValidator>
                </div>

                <div class="modal-rechazo-actions">
                    <asp:Button ID="btnCancelarRechazo" runat="server" Text="Cancelar"
                        OnClick="btnCancelarRechazo_Click"
                        CssClass="btn-cancel-rechazo" />
                    <asp:Button ID="btnConfirmarRechazo" runat="server" Text="Rechazar Solicitud"
                        OnClick="btnConfirmarRechazo_Click" CssClass="quick-action-btn btn-confirm-rechazo"
                        ValidationGroup="Rechazo" />
                </div>
            </div>
        </asp:Panel>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </asp:Content>