<%@ Page Title="" Language="C#" MasterPageFile="~/AdminRefugio/AdminRefugio.Master" AutoEventWireup="true"
    CodeBehind="Campanias.aspx.cs" Inherits="RedPatitas.AdminRefugio.Campanias" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Gestión de Campañas | RedPatitas
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <style>
            .campaign-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 1.5rem;
                margin-bottom: 2rem;
            }

            .campaign-card {
                background: white;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                transition: transform 0.2s;
                border: 1px solid #eee;
            }

            .campaign-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
            }

            .campaign-img {
                width: 100%;
                height: 180px;
                object-fit: cover;
            }

            .campaign-body {
                padding: 1.5rem;
            }

            .campaign-title {
                font-size: 1.1rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
                color: var(--text-dark);
            }

            .campaign-meta {
                font-size: 0.9rem;
                color: #666;
                margin-bottom: 0.5rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .campaign-desc {
                font-size: 0.9rem;
                color: #4B5563;
                line-height: 1.5;
                margin-bottom: 1rem;
                display: -webkit-box;
                -webkit-line-clamp: 3;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }

            .status-badge.active {
                background: #D1FAE5;
                color: #059669;
            }

            .status-badge.inactive {
                background: #F3F4F6;
                color: #6B7280;
            }

            /* Form Styles */
            .form-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1.5rem;
                margin-bottom: 1rem;
            }
        </style>
    </asp:Content>
    <asp:Content ID="Content4" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">Campañas y Eventos</h1>
            <div class="breadcrumb">Dashboard / Campañas</div>
        </div>
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

        <asp:Panel ID="pnlLista" runat="server">
            <div class="recent-section">
                <div class="section-header">
                    <h2 class="section-title">Campañas Activas</h2>
                    <asp:Button ID="btnNuevaCampania" runat="server" Text="+ Nueva Campaña" CssClass="quick-action-btn"
                        OnClick="btnNuevaCampania_Click" />
                </div>

                <div class="campaign-grid">
                    <asp:Repeater ID="rptCampanias" runat="server" OnItemCommand="rptCampanias_ItemCommand">
                        <ItemTemplate>
                            <div class="campaign-card">
                                <img src='<%# Eval("cam_ImagenUrl") %>' alt="Imagen Campaña" class="campaign-img"
                                    onerror="this.src='https://via.placeholder.com/300x180'">
                                <div class="campaign-body">
                                    <div style="display:flex; justify-content:space-between; margin-bottom:0.5rem;">
                                        <span
                                            class='status-badge <%# Eval("cam_Estado").ToString() == "Activa" ? "active" : "inactive" %>'>
                                            <%# Eval("cam_Estado") %>
                                        </span>
                                        <small style="color:#666;">
                                            <%# Eval("cam_TipoCampania") %>
                                        </small>
                                    </div>
                                    <h3 class="campaign-title">
                                        <%# Eval("cam_Titulo") %>
                                    </h3>
                                    <div class="campaign-meta">
                                        <i class="far fa-calendar-alt"></i>
                                        <%# Eval("cam_FechaInicio", "{0:dd MMM}" ) %> - <%#
                                                Eval("cam_FechaFin", "{0:dd MMM yyyy}" ) %>
                                    </div>
                                    <div class="campaign-meta">
                                        <i class="fas fa-map-marker-alt"></i>
                                        <%# Eval("cam_Ubicacion") %>
                                    </div>
                                    <p class="campaign-desc">
                                        <%# Eval("cam_Descripcion") %>
                                    </p>

                                    <div class="action-buttons"
                                        style="margin-top:1rem; border-top:1px solid #eee; padding-top:1rem; justify-content:flex-end;">
                                        <asp:LinkButton ID="btnEditar" runat="server" CommandName="Editar"
                                            CommandArgument='<%# Eval("cam_IdCampania") %>'
                                            CssClass="table-action-btn info">
                                            <i class="fas fa-edit"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnEliminar" runat="server" CommandName="Eliminar"
                                            CommandArgument='<%# Eval("cam_IdCampania") %>'
                                            CssClass="table-action-btn reject"
                                            OnClientClick="return confirm('¿Eliminar esta campaña?');">
                                            <i class="fas fa-trash"></i>
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <div id="noData" runat="server" style="padding: 2rem; text-align: center; color: #666; display:none;">
                    No hay campañas registradas.
                </div>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlFormulario" runat="server" Visible="false">
            <div class="recent-section">
                <div class="section-header">
                    <h2 class="section-title">
                        <asp:Literal ID="litTituloFormulario" runat="server">Nueva Campaña</asp:Literal>
                    </h2>
                    <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn-link"
                        OnClick="btnCancelar_Click" style="background:none; border:none; cursor:pointer;" />
                </div>

                <asp:HiddenField ID="hfIdCampania" runat="server" />

                <div class="form-grid">
                    <div class="form-group" style="grid-column: span 2;">
                        <label>Título de la Campaña</label>
                        <asp:TextBox ID="txtTitulo" runat="server" CssClass="form-control"
                            placeholder="Ej. Jornada de Vacunación Gratuita"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvTitulo" runat="server" ControlToValidate="txtTitulo"
                            ErrorMessage="El título es requerido" ForeColor="Red" ValidationGroup="Campania"
                            Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label>Tipo de Campaña</label>
                        <asp:DropDownList ID="ddlTipo" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Adopción" Value="Adopción"></asp:ListItem>
                            <asp:ListItem Text="Vacunación" Value="Vacunación"></asp:ListItem>
                            <asp:ListItem Text="Esterilización" Value="Esterilización"></asp:ListItem>
                            <asp:ListItem Text="Evento Benéfico" Value="Evento"></asp:ListItem>
                            <asp:ListItem Text="Otro" Value="Otro"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <label>Ubicación</label>
                        <asp:TextBox ID="txtUbicacion" runat="server" CssClass="form-control"
                            placeholder="Ej. Parque Central"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label>Fecha Inicio</label>
                        <asp:TextBox ID="txtFechaInicio" runat="server" CssClass="form-control" TextMode="Date">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvFechaInicio" runat="server"
                            ControlToValidate="txtFechaInicio" ErrorMessage="*" ForeColor="Red"
                            ValidationGroup="Campania"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label>Fecha Fin</label>
                        <asp:TextBox ID="txtFechaFin" runat="server" CssClass="form-control" TextMode="Date">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvFechaFin" runat="server" ControlToValidate="txtFechaFin"
                            ErrorMessage="*" ForeColor="Red" ValidationGroup="Campania"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group" style="grid-column: span 2;">
                        <label>Imagen Promocional</label>
                        <asp:FileUpload ID="fuImagen" runat="server" CssClass="form-control" accept="image/*" />
                        <asp:HiddenField ID="hfImagenUrl" runat="server" />
                    </div>

                    <div class="form-group" style="grid-column: span 2;">
                        <label>Descripción</label>
                        <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" TextMode="MultiLine"
                            Rows="4"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label>Estado</label>
                        <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Activa" Value="Activa"></asp:ListItem>
                            <asp:ListItem Text="Inactiva" Value="Inactiva"></asp:ListItem>
                            <asp:ListItem Text="Finalizada" Value="Finalizada"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div style="margin-top: 2rem; display: flex; justify-content: flex-end; gap: 1rem;">
                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar Campaña" CssClass="quick-action-btn"
                        OnClick="btnGuardar_Click" ValidationGroup="Campania" />
                </div>
            </div>
        </asp:Panel>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            .table-action-btn.info {
                background: #DBEAFE;
                color: #2563EB;
            }

            .table-action-btn.info:hover {
                background: #2563EB;
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