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

            /* Estilos para subida de fotos */
            .photo-upload-box {
                position: relative;
                aspect-ratio: 1;
                border: 2px dashed #ddd;
                border-radius: 12px;
                background: #fafafa;
                cursor: pointer;
                overflow: hidden;
                transition: all 0.2s ease;
            }

            .photo-upload-box:hover {
                border-color: var(--primary-color);
                background: #fff5f0;
            }

            .photo-placeholder {
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                color: #aaa;
                font-size: 0.85rem;
                text-align: center;
                padding: 0.5rem;
            }

            .photo-placeholder i {
                font-size: 2rem;
                margin-bottom: 0.5rem;
                color: #ccc;
            }

            .photo-placeholder small {
                font-size: 0.7rem;
                color: #bbb;
            }

            .photo-input {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                opacity: 0;
                cursor: pointer;
            }

            .photo-preview {
                width: 100%;
                height: 100%;
            }

            .photo-preview img,
            .preview-img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .preview-client {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                display: none;
            }

            .preview-client img {
                width: 100%;
                height: 100%;
                object-fit: cover;
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
                </div>

                <!-- Sección de Fotos de la Mascota -->
                <div class="form-group" style="margin-top: 1.5rem;">
                    <label style="font-size: 1rem; margin-bottom: 0.5rem;">📸 Fotos de la Mascota <span
                            style="color: #888; font-weight: 400;">(Foto principal requerida)</span></label>
                    <div
                        style="display: grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap: 1rem; margin-top: 0.75rem;">

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