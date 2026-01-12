<%@ Page Title="" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true" CodeBehind="Perfil.aspx.cs" Inherits="RedPatitas.Adoptante.Perfil" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Mi Perfil
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Ajuste para que la imagen ASP se vea redonda igual que el div original */
        .avatar-img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            background-color: var(--accent-color, #ddd);
            border: 4px solid white;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="page-header">
        <h1 class="page-title">Mi Perfil</h1>
        <div class="breadcrumb">Cuenta / Mi Perfil</div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="form-container">
        
        <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="form-group">
            <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>
        </asp:Panel>

        <div class="avatar-section">
            <asp:Image ID="imgFotoActual" runat="server" CssClass="avatar-img" ImageUrl="~/Images/default-user.png" />
            
            <div class="avatar-actions">
                <asp:FileUpload ID="fuFotoPerfil" runat="server" CssClass="btn-secondary" accept=".jpg,.png,.jpeg" />
                <span class="avatar-hint">JPG, PNG. Máximo 2MB</span>
            </div>
        </div>

        <div class="form-grid">
            <div class="form-group">
                <label for="txtNombre">Nombre</label>
                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Ej: Jaime"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
            </div>
            <div class="form-group">
                <label for="txtApellido">Apellido</label>
                <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control" placeholder="Ej: Peralvo"></asp:TextBox>
            </div>
        </div>

        <div class="form-group">
            <label for="txtEmail">Correo Electrónico</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" Enabled="false"></asp:TextBox>
            <small class="input-hint">El correo electrónico no puede ser modificado</small>
        </div>

        <div class="form-grid">
            <div class="form-group">
                <label for="txtTelefono">Teléfono</label>
                <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" TextMode="Phone"></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtCedula">Cédula</label>
                <asp:TextBox ID="txtCedula" runat="server" CssClass="form-control"></asp:TextBox>
                <small class="input-hint verified" style="color:#27AE60; display:flex; align-items:center; gap:5px;">
                    <svg viewBox="0 0 24 24" fill="none" width="14" height="14"><path d="M20 6L9 17L4 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg>
                    Identificación
                </small>
            </div>
        </div>

        <div class="form-group">
            <label for="txtDireccion">Dirección</label>
            <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox>
        </div>

        <div class="form-divider"></div>

        <h3 class="form-section-title">Cambiar Contraseña</h3>
        <div class="form-group">
            <label>Nueva Contraseña (Opcional)</label>
            <asp:TextBox ID="txtNuevaClave" runat="server" CssClass="form-control" TextMode="Password" placeholder="••••••••"></asp:TextBox>
        </div>

        <div class="form-actions">
            <asp:Button ID="btnGuardar" runat="server" CssClass="btn-primary" Text="Guardar Cambios" OnClick="btnGuardar_Click" />
        </div>
    </div>
</asp:Content>