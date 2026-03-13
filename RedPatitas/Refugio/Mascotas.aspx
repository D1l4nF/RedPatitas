<%@ Page Title="" Language="C#" MasterPageFile="~/Refugio/Refugio.Master" AutoEventWireup="true"
    CodeBehind="Mascotas.aspx.cs" Inherits="RedPatitas.Refugio.Mascotas" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Gestión de Mascotas | RedPatitas
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">

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
                                            onerror="this.src='../Images/Default/default-pet.png'">
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
                                class="no-data-msg">
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
                    <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn-link btn-cancel-admin"
                        OnClick="btnCancelar_Click" />
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
                </div>

                <!-- Sección de Fotos de la Mascota -->
                <div class="form-group" style="margin-top: 1.5rem;">
                    <label class="fotos-title">📸 Fotos de la Mascota <span
                            class="fotos-subtitle">(Foto principal requerida)</span></label>
                    <div class="fotos-grid">

                        <!-- Foto 1 - Principal -->
                        <div class="photo-upload-box" id="photoBox1">
                            <div class="photo-preview" id="previewFoto1" runat="server">
                                <asp:Image ID="imgPreview1" runat="server" CssClass="preview-img" Visible="false" />
                            </div>
                            <div class="photo-placeholder" id="placeholder1">
                                <i class="fas fa-star" style="color: #FFD700;"></i>
                                <span>Principal</span>
                                <small>(portada)</small>
                            </div>
                            <asp:FileUpload ID="fuFoto1" runat="server" CssClass="photo-input" accept="image/*"
                                onchange="previewMascotaImage(this, 1)" />
                        </div>

                        <!-- Foto 2 -->
                        <div class="photo-upload-box" id="photoBox2">
                            <div class="photo-preview" id="previewFoto2" runat="server">
                                <asp:Image ID="imgPreview2" runat="server" CssClass="preview-img" Visible="false" />
                            </div>
                            <div class="photo-placeholder" id="placeholder2">
                                <i class="fas fa-camera"></i>
                                <span>Foto 2</span>
                                <small>(perfil)</small>
                            </div>
                            <asp:FileUpload ID="fuFoto2" runat="server" CssClass="photo-input" accept="image/*"
                                onchange="previewMascotaImage(this, 2)" />
                        </div>

                        <!-- Foto 3 -->
                        <div class="photo-upload-box" id="photoBox3">
                            <div class="photo-preview" id="previewFoto3" runat="server">
                                <asp:Image ID="imgPreview3" runat="server" CssClass="preview-img" Visible="false" />
                            </div>
                            <div class="photo-placeholder" id="placeholder3">
                                <i class="fas fa-camera"></i>
                                <span>Foto 3</span>
                                <small>(cuerpo)</small>
                            </div>
                            <asp:FileUpload ID="fuFoto3" runat="server" CssClass="photo-input" accept="image/*"
                                onchange="previewMascotaImage(this, 3)" />
                        </div>
                    </div>
                    <asp:HiddenField ID="hfFotoUrl1" runat="server" />
                    <asp:HiddenField ID="hfFotoUrl2" runat="server" />
                    <asp:HiddenField ID="hfFotoUrl3" runat="server" />

                    <div class="form-group">
                        <label>Descripción</label>
                        <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" TextMode="MultiLine"
                            Rows="3"></asp:TextBox>
                    </div>

                    <div class="form-group" style="margin-top: 1rem; flex-direction: row; gap: 2rem;">
                        <label class="checkbox-label">
                            <asp:CheckBox ID="chkVacunado" runat="server" /> Vacunado
                        </label>
                        <label class="checkbox-label">
                            <asp:CheckBox ID="chkEsterilizado" runat="server" /> Esterilizado
                        </label>
                        <label class="checkbox-label">
                            <asp:CheckBox ID="chkDesparasitado" runat="server" /> Desparasitado
                        </label>
                    </div>

                    <div class="submit-container">
                        <asp:Button ID="btnGuardar" runat="server" Text="Guardar Mascota" CssClass="quick-action-btn"
                            OnClick="btnGuardar_Click" ValidationGroup="Mascota" />
                    </div>
                </div> <!-- Closing form-grid or recent-section -->
            </div> <!-- Closing recent-section -->
        </asp:Panel>

        <!-- FontAwesome for Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <script type="text/javascript">
            function previewMascotaImage(input, num) {
                var box = document.getElementById('photoBox' + num);
                var placeholder = document.getElementById('placeholder' + num);

                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        // Crear o actualizar preview
                        var existingPreview = box.querySelector('.preview-client');
                        if (!existingPreview) {
                            existingPreview = document.createElement('div');
                            existingPreview.className = 'preview-client';
                            existingPreview.innerHTML = '<img src="" alt="Preview" />';
                            box.insertBefore(existingPreview, placeholder);
                        }
                        existingPreview.querySelector('img').src = e.target.result;
                        existingPreview.style.display = 'block';
                        placeholder.style.display = 'none';
                    };
                    reader.readAsDataURL(input.files[0]);
                }
            }
        </script>
    </asp:Content>