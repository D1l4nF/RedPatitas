<%@ Page Title="" Language="C#" MasterPageFile="~/Refugio/Refugio.Master" AutoEventWireup="true"
    CodeBehind="Mascotas.aspx.cs" Inherits="RedPatitas.Refugio.Mascotas" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Mis Mascotas | RedPatitas
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link href='<%= ResolveUrl("~/Style/pet-cards.css") %>' rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2rem;
            }

            .page-title {
                font-size: 1.5rem;
                font-weight: 700;
                color: #1f2937;
            }

            .btn-primary {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.75rem 1.5rem;
                background: linear-gradient(135deg, var(--primary-color), var(--primary-hover));
                color: white;
                border: none;
                border-radius: 10px;
                font-weight: 500;
                cursor: pointer;
                text-decoration: none;
                transition: transform 0.2s, box-shadow 0.2s;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(255, 140, 66, 0.3);
            }

            /* Form Panel - Modern Modal Style */
            .form-panel {
                background: white;
                border-radius: 20px;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
                margin-bottom: 2rem;
                overflow: hidden;
            }

            .form-header {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-hover) 100%);
                color: white;
                padding: 1.5rem 2rem;
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .form-header-icon {
                width: 50px;
                height: 50px;
                background: rgba(255, 255, 255, 0.2);
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
            }

            .form-header h2 {
                margin: 0;
                font-size: 1.35rem;
                font-weight: 600;
            }

            .form-header p {
                margin: 0;
                opacity: 0.9;
                font-size: 0.9rem;
            }

            .form-body {
                padding: 2rem;
            }

            .form-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 1.25rem;
            }

            .form-group {
                display: flex;
                flex-direction: column;
                gap: 0.5rem;
            }

            .form-group label {
                font-weight: 600;
                color: #374151;
                font-size: 0.85rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .form-group label i {
                color: var(--primary-color);
                font-size: 0.9rem;
            }

            .form-group input,
            .form-group select,
            .form-group textarea {
                padding: 0.85rem 1rem;
                border: 2px solid #e5e7eb;
                border-radius: 12px;
                font-size: 0.95rem;
                transition: all 0.2s;
                background: #fafafa;
            }

            .form-group input:focus,
            .form-group select:focus,
            .form-group textarea:focus {
                outline: none;
                border-color: var(--primary-color);
                background: white;
                box-shadow: 0 0 0 4px rgba(255, 140, 66, 0.1);
            }

            .form-group.full-width {
                grid-column: span 2;
            }

            .form-section-title {
                font-size: 0.9rem;
                font-weight: 700;
                color: var(--primary-color);
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 0.5rem;
                padding-bottom: 0.5rem;
                border-bottom: 2px solid #f3f4f6;
                grid-column: span 2;
            }

            .checkbox-group {
                display: flex;
                gap: 2rem;
                align-items: center;
                padding: 1rem;
                background: #f8f9fa;
                border-radius: 12px;
            }

            .checkbox-group label {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                cursor: pointer;
                font-weight: 500;
            }

            .form-actions {
                display: flex;
                gap: 1rem;
                justify-content: flex-end;
                margin-top: 1.5rem;
                padding-top: 1.5rem;
                border-top: 2px solid #f3f4f6;
            }

            .btn-secondary {
                padding: 0.85rem 1.75rem;
                background: #f3f4f6;
                color: #374151;
                border: none;
                border-radius: 12px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s;
            }

            .btn-secondary:hover {
                background: #e5e7eb;
            }

            .file-upload-wrapper {
                border: 2px dashed #d1d5db;
                border-radius: 12px;
                padding: 1.5rem;
                text-align: center;
                background: #fafafa;
                cursor: pointer;
                transition: all 0.2s;
            }

            .file-upload-wrapper:hover {
                border-color: var(--primary-color);
                background: var(--primary-light);
            }

            .file-upload-wrapper i {
                font-size: 2rem;
                color: var(--primary-color);
                margin-bottom: 0.5rem;
            }

            /* Override pet-cards for admin actions */
            .admin-pet-actions {
                display: flex;
                gap: 0.5rem;
                padding-top: 0.75rem;
                border-top: 1px solid #f0f0f0;
            }

            .admin-pet-actions a,
            .admin-pet-actions button {
                flex: 1;
                padding: 0.6rem;
                text-align: center;
                border-radius: 8px;
                font-size: 0.85rem;
                font-weight: 500;
                text-decoration: none;
                transition: all 0.2s;
                border: none;
                cursor: pointer;
            }

            .btn-admin-edit {
                background: #f3f4f6;
                color: #374151;
            }

            .btn-admin-edit:hover {
                background: #e5e7eb;
            }

            .btn-admin-delete {
                background: #fee2e2;
                color: #dc2626;
            }

            .btn-admin-delete:hover {
                background: #fecaca;
            }

            /* Empty State */
            .empty-state {
                text-align: center;
                padding: 4rem 2rem;
                background: white;
                border-radius: 16px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            }

            .empty-state i {
                font-size: 4rem;
                color: #d1d5db;
                margin-bottom: 1rem;
            }

            .empty-state h3 {
                color: #374151;
                margin-bottom: 0.5rem;
            }

            .empty-state p {
                color: #9ca3af;
                margin-bottom: 1.5rem;
            }

            @media (max-width: 768px) {
                .form-grid {
                    grid-template-columns: 1fr;
                }

                .form-group.full-width {
                    grid-column: span 1;
                }
            }
        </style>
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">🐾 Mis Mascotas</h1>
            <asp:Button ID="btnNuevaMascota" runat="server" Text="+ Nueva Mascota" CssClass="btn-primary"
                OnClick="btnNuevaMascota_Click" />
        </div>
    </asp:Content>
    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

        <!-- Form Panel (Hidden by default) -->
        <asp:Panel ID="pnlFormulario" runat="server" Visible="false" CssClass="form-panel">
            <div class="form-header">
                <div class="form-header-icon">🐾</div>
                <div>
                    <h2>
                        <asp:Literal ID="litTituloForm" runat="server">Nueva Mascota</asp:Literal>
                    </h2>
                    <p>Completa la información de la mascota</p>
                </div>
            </div>
            <asp:HiddenField ID="hfIdMascota" runat="server" Value="0" />

            <div class="form-body">
                <div class="form-grid">
                    <div class="form-section-title">📋 Información Básica</div>

                    <div class="form-group">
                        <label><i class="fas fa-tag"></i> Nombre *</label>
                        <asp:TextBox ID="txtNombre" runat="server" placeholder="Ej: Max, Luna, Coco..." MaxLength="100">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre"
                            ErrorMessage="Nombre requerido" ForeColor="Red" Display="Dynamic" ValidationGroup="mascota">
                        </asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-paw"></i> Especie *</label>
                        <asp:DropDownList ID="ddlEspecie" runat="server" AutoPostBack="true"
                            OnSelectedIndexChanged="ddlEspecie_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-dog"></i> Raza</label>
                        <asp:DropDownList ID="ddlRaza" runat="server"></asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-venus-mars"></i> Sexo</label>
                        <asp:DropDownList ID="ddlSexo" runat="server">
                            <asp:ListItem Value="" Text="-- Seleccionar --"></asp:ListItem>
                            <asp:ListItem Value="M" Text="Macho"></asp:ListItem>
                            <asp:ListItem Value="H" Text="Hembra"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="form-section-title">📊 Características</div>

                    <div class="form-group">
                        <label><i class="fas fa-birthday-cake"></i> Edad Aproximada</label>
                        <asp:DropDownList ID="ddlEdad" runat="server">
                            <asp:ListItem Value="" Text="-- Seleccionar --"></asp:ListItem>
                            <asp:ListItem Value="Cachorro" Text="Cachorro"></asp:ListItem>
                            <asp:ListItem Value="Joven" Text="Joven"></asp:ListItem>
                            <asp:ListItem Value="Adulto" Text="Adulto"></asp:ListItem>
                            <asp:ListItem Value="Senior" Text="Senior"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-ruler-combined"></i> Tamaño</label>
                        <asp:DropDownList ID="ddlTamano" runat="server">
                            <asp:ListItem Value="" Text="-- Seleccionar --"></asp:ListItem>
                            <asp:ListItem Value="Pequeño" Text="Pequeño"></asp:ListItem>
                            <asp:ListItem Value="Mediano" Text="Mediano"></asp:ListItem>
                            <asp:ListItem Value="Grande" Text="Grande"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-palette"></i> Color</label>
                        <asp:TextBox ID="txtColor" runat="server" placeholder="Ej: Marrón con blanco"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-images"></i> Fotos</label>
                        <div class="file-upload-wrapper">
                            <i class="fas fa-cloud-upload-alt"></i>
                            <asp:FileUpload ID="fuFoto" runat="server" AllowMultiple="true" />
                            <p style="margin: 0.5rem 0 0; color: #6b7280; font-size: 0.85rem;">JPG, PNG, GIF (Máx. 5MB)
                            </p>
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label><i class="fas fa-align-left"></i> Descripción</label>
                        <asp:TextBox ID="txtDescripcion" runat="server" TextMode="MultiLine" Rows="3"
                            placeholder="Describe la personalidad, historia y características especiales...">
                        </asp:TextBox>
                    </div>

                    <div class="form-group full-width">
                        <div class="checkbox-group">
                            <asp:CheckBox ID="chkVacunado" runat="server" Text=" 💉 Vacunado" />
                            <asp:CheckBox ID="chkEsterilizado" runat="server" Text=" ✂️ Esterilizado" />
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn-secondary"
                        OnClick="btnCancelar_Click" CausesValidation="false" />
                    <asp:Button ID="btnGuardar" runat="server" Text="💾 Guardar Mascota" CssClass="btn-primary"
                        OnClick="btnGuardar_Click" ValidationGroup="mascota" />
                </div>
            </div>
        </asp:Panel>

        <!-- Pets Grid using pet-cards.css -->
        <asp:Panel ID="pnlLista" runat="server">
            <div class="pets-grid">
                <asp:Repeater ID="rptMascotas" runat="server" OnItemCommand="rptMascotas_ItemCommand">
                    <ItemTemplate>
                        <div class="pet-card">
                            <!-- Image Section -->
                            <div class="pet-card-image">
                                <asp:Image ID="imgMascota" runat="server"
                                    ImageUrl='<%# ResolveFotoUrl(Eval("FotoPrincipal")) %>'
                                    AlternateText='<%# Eval("Nombre") %>'
                                    onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                <div class="pet-card-emoji" style="display: none;">
                                    <%# GetEmojiByEspecie(Eval("Especie").ToString()) %>
                                </div>

                                <!-- Badge -->
                                <div class="pet-badges">
                                    <span class="pet-badge <%# GetBadgeClass(Eval(" EstadoAdopcion").ToString()) %>">
                                        <%# Eval("EstadoAdopcion") %>
                                    </span>
                                </div>
                            </div>

                            <!-- Content Section -->
                            <div class="pet-card-content">
                                <div class="pet-card-header">
                                    <h3 class="pet-card-name">
                                        <%# Eval("Nombre") %>
                                    </h3>
                                    <span class="pet-card-species">
                                        <%# GetEmojiByEspecie(Eval("Especie").ToString()) %>
                                    </span>
                                </div>

                                <div class="pet-card-details">
                                    <span class="pet-detail-tag">
                                        <i class="fas fa-venus-mars"></i>
                                        <%# Eval("Sexo") %>
                                    </span>
                                    <span class="pet-detail-tag">
                                        <i class="fas fa-ruler"></i>
                                        <%# Eval("Tamano") %>
                                    </span>
                                    <span class="pet-detail-tag">
                                        <i class="fas fa-birthday-cake"></i>
                                        <%# Eval("EdadAproximada") %>
                                    </span>
                                </div>

                                <div class="pet-card-location">
                                    <i class="fas fa-paw"></i>
                                    <span>
                                        <%# Eval("Raza") %>
                                    </span>
                                </div>

                                <!-- Admin Actions -->
                                <div class="admin-pet-actions">
                                    <asp:LinkButton ID="btnEditar" runat="server" CssClass="btn-admin-edit"
                                        CommandName="Editar" CommandArgument='<%# Eval("IdMascota") %>'>
                                        <i class="fas fa-edit"></i> Editar
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnEliminar" runat="server" CssClass="btn-admin-delete"
                                        CommandName="Eliminar" CommandArgument='<%# Eval("IdMascota") %>'
                                        OnClientClick="return confirm('¿Estás seguro de eliminar esta mascota?');">
                                        <i class="fas fa-trash"></i> Eliminar
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </asp:Panel>

        <!-- Empty State -->
        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-paw"></i>
                <h3>No tienes mascotas registradas</h3>
                <p>Registra tu primera mascota para comenzar a recibir solicitudes de adopción.</p>
                <asp:Button ID="btnPrimeraMascota" runat="server" Text="+ Registrar Primera Mascota"
                    CssClass="btn-primary" OnClick="btnNuevaMascota_Click" />
            </div>
        </asp:Panel>

        <asp:Label ID="lblMensaje" runat="server" Visible="false"></asp:Label>
    </asp:Content>