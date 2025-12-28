<%@ Page Title="" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true" CodeBehind="Perfil.aspx.cs" Inherits="RedPatitas.Adoptante.Perfil" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="page-header">
        <h1 class="page-title">Mi Perfil</h1>
        <div class="breadcrumb">Cuenta / Mi Perfil</div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="form-container">
        <!-- Avatar Section -->
        <div class="avatar-section">
            <div class="avatar-large">AD</div>
            <div class="avatar-actions">
                <asp:Button ID="btnCambiarFoto" runat="server" Text="Cambiar Foto" CssClass="btn-secondary" OnClick="btnCambiarFoto_Click" />
                <span class="avatar-hint">JPG, PNG. Máximo 2MB</span>
            </div>
        </div>

        <div class="form-grid">
            <div class="form-group">
                <label for="nombres">Nombres</label>
                <asp:TextBox ID="txtNombres" runat="server" placeholder="Ana"></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="apellidos">Apellidos</label>
                <asp:TextBox ID="txtApellidos" runat="server" placeholder="Lopez"></asp:TextBox>
            </div>
        </div>

        <div class="form-group">
            <label for="email">Correo Electrónico</label>
            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="ana.lopez@email.com"></asp:TextBox>
            <small class="input-hint">El correo electrónico no puede ser modificado</small>
        </div>

        <div class="form-grid">
            <div class="form-group">
                <label for="telefono">Teléfono</label>
                <asp:TextBox ID="txtTelefono" runat="server" TextMode="Phone" placeholder="0999999999"></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="cedula">Cédula</label>
                <asp:TextBox ID="txtCedula" runat="server" placeholder="1234567890"></asp:TextBox>
                <small class="input-hint verified">
                    <svg viewBox="0 0 24 24" fill="none" width="14" height="14">
                        <path d="M20 6L9 17L4 12" stroke="currentColor" stroke-width="2"
                            stroke-linecap="round" stroke-linejoin="round" />
                    </svg>
                    Cuenta verificada
                </small>
            </div>
        </div>

        <div class="form-divider"></div>

        <h3 class="form-section-title">Cambiar Contraseña</h3>

        <div class="form-group">
            <label for="current-password">Contraseña Actual</label>
            <asp:TextBox ID="txtClaveActual" runat="server" TextMode="Password" placeholder="••••••••"></asp:TextBox>
        </div>

        <div class="form-grid">
            <div class="form-group">
                <label for="new-password">Nueva Contraseña</label>
                <asp:TextBox ID="txtNuevaClave" runat="server" TextMode="Password" placeholder="••••••••"></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="confirm-password">Confirmar Contraseña</label>
                <asp:TextBox ID="txtConfirmarClave" runat="server" TextMode="Password" placeholder="••••••••"></asp:TextBox>
            </div>
        </div>

        <div class="form-actions">
            <asp:Button ID="btnGuardar" runat="server" CssClass="btn-primary" Text="Guardar Cambios" OnClick="btnGuardar_Click" />

        </div>
    </div>
</asp:Content>
