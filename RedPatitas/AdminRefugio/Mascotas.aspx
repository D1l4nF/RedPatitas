<%@ Page Title="" Language="C#" MasterPageFile="~/AdminRefugio/AdminRefugio.Master" AutoEventWireup="true"
    CodeBehind="Mascotas.aspx.cs" Inherits="RedPatitas.AdminRefugio.Mascotas" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Gestión de Mascotas | RedPatitas
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <style>
            .form-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1.5rem;
                margin-bottom: 2rem;
            }

            .form-group {
                display: flex;
                flex-direction: column;
                gap: 0.5rem;
            }

            .form-group label {
                font-weight: 600;
                color: var(--secondary-color);
                font-size: 0.9rem;
            }

            .form-control {
                padding: 0.75rem;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-family: inherit;
            }

            .btn-toolbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1.5rem;
            }
        </style>
    </asp:Content>
    <asp:Content ID="Content4" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">Gestión de Mascotas</h1>
            <div class="breadcrumb">Dashboard / Mascotas</div>
        </div>
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
        <asp:Panel ID="pnlLista" runat="server">
            <div class="recent-section">
                <div class="section-header">
                    <h2 class="section-title">Listado de Mascotas</h2>
                    <asp:Button ID="btnNuevaMascota" runat="server" Text="+ Nueva Mascota" CssClass="quick-action-btn"
                        OnClick="btnNuevaMascota_Click" />
                </div>

                <div class="table-container">
                    <asp:Repeater ID="rptMascotas" runat="server" OnItemCommand="rptMascotas_ItemCommand">
                        <HeaderTemplate>
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Mascota</th>
                                        <th>Especie/Raza</th>
                                        <th>Edad</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <div class="pet-cell">
                                        <img src='<%# Eval("FotoPrincipal") %>' alt="Foto" class="pet-img"
                                            onerror="this.src='https://via.placeholder.com/40'">
                                        <span>
                                            <%# Eval("Nombre") %>
                                        </span>
                                    </div>
                                </td>
                                <td>
                                    <%# Eval("Especie") %> - <%# Eval("Raza") %>
                                </td>
                                <td>
                                    <%# Eval("EdadFormateada") %>
                                </td>
                                <td>
                                    <span
                                        class='status-badge <%# Eval("EstadoAdopcion").ToString() == "Disponible" ? "available" : "pending" %>'>
                                        <%# Eval("EstadoAdopcion") %>
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <asp:LinkButton ID="btnEditar" runat="server" CommandName="Editar"
                                            CommandArgument='<%# Eval("IdMascota") %>' CssClass="table-action-btn info"
                                            ToolTip="Editar">
                                            <i class="fas fa-edit"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnEliminar" runat="server" CommandName="Eliminar"
                                            CommandArgument='<%# Eval("IdMascota") %>'
                                            CssClass="table-action-btn reject" ToolTip="Eliminar"
                                            OnClientClick="return confirm('¿Estás seguro de eliminar esta mascota?');">
                                            <i class="fas fa-trash"></i>
                                        </asp:LinkButton>
                                    </div>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </tbody>
                            </table>
                            <div id="noData" runat="server"
                                visible='<%# ((Repeater)Container.Parent).Items.Count == 0 %>'
                                style="padding: 2rem; text-align: center; color: #666;">
                                No hay mascotas registradas.
                            </div>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlFormulario" runat="server" Visible="false">
            <div class="recent-section">
                <div class="section-header">
                    <h2 class="section-title">
                        <asp:Literal ID="litTituloFormulario" runat="server">Nueva Mascota</asp:Literal>
                    </h2>
                    <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn-link"
                        OnClick="btnCancelar_Click" style="background:none; border:none; cursor:pointer;" />
                </div>

                <asp:HiddenField ID="hfIdMascota" runat="server" />

                <div class="form-grid">
                    <div class="form-group">
                        <label>Nombre</label>
                        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control"
                            placeholder="Nombre de la mascota"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre"
                            ErrorMessage="El nombre es requerido" ForeColor="Red" Display="Dynamic"
                            ValidationGroup="Mascota"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label>Especie</label>
                        <asp:DropDownList ID="ddlEspecie" runat="server" CssClass="form-control" AutoPostBack="true"
                            OnSelectedIndexChanged="ddlEspecie_SelectedIndexChanged">
                         
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <label>Raza</label>
                        <asp:DropDownList ID="ddlRaza" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Seleccione Especie primero" Value=""></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <label>Edad (Meses)</label>
                        <asp:TextBox ID="txtEdad" runat="server" CssClass="form-control" TextMode="Number"
                            placeholder="0"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label>Sexo</label>
                        <asp:DropDownList ID="ddlSexo" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Macho" Value="M"></asp:ListItem>
                            <asp:ListItem Text="Hembra" Value="F"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <label>Tamaño</label>
                        <asp:DropDownList ID="ddlTamano" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Pequeño" Value="Pequeño"></asp:ListItem>
                            <asp:ListItem Text="Mediano" Value="Mediano"></asp:ListItem>
                            <asp:ListItem Text="Grande" Value="Grande"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <label>Color</label>
                        <asp:TextBox ID="txtColor" runat="server" CssClass="form-control" placeholder="Ej. Café, Negro">
                        </asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label>Subir Foto Principal</label>
                        <asp:FileUpload ID="fuFoto" runat="server" CssClass="form-control" accept="image/*" />
                        <asp:HiddenField ID="hfFotoUrl" runat="server" />
                    </div>
                </div>

                <div class="form-group">
                    <label>Descripción</label>
                    <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" TextMode="MultiLine"
                        Rows="3"></asp:TextBox>
                </div>

                <div class="form-group" style="margin-top: 1rem; flex-direction: row; gap: 2rem;">
                    <label style="display:flex; align-items:center; gap:0.5rem; cursor:pointer;">
                        <asp:CheckBox ID="chkVacunado" runat="server" /> Vacunado
                    </label>
                    <label style="display:flex; align-items:center; gap:0.5rem; cursor:pointer;">
                        <asp:CheckBox ID="chkEsterilizado" runat="server" /> Esterilizado
                    </label>
                    <label style="display:flex; align-items:center; gap:0.5rem; cursor:pointer;">
                        <asp:CheckBox ID="chkDesparasitado" runat="server" /> Desparasitado
                    </label>
                </div>

                <div style="margin-top: 2rem; display: flex; justify-content: flex-end; gap: 1rem;">
                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar Mascota" CssClass="quick-action-btn"
                        OnClick="btnGuardar_Click" ValidationGroup="Mascota" />
                </div>
            </div>
        </asp:Panel>

        <!-- FontAwesome for Icons -->
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
        </style>
    </asp:Content>