<%@ Page Title="" Language="C#" MasterPageFile="~/AdminRefugio/AdminRefugio.Master" AutoEventWireup="true" CodeBehind="Perfil.aspx.cs" Inherits="RedPatitas.AdminRefugio.Perfil" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Perfil Refugio | RedPatitas
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="page-header">
        <h1 class="page-title">Mi Perfil</h1>
        <div class="breadcrumb">Cuenta / Mi Perfil</div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="form-container">
        <!-- Logo Section -->
        <div class="avatar-section">
            <div class="avatar-large">
                <asp:Literal ID="litIniciales" runat="server">RE</asp:Literal>
            </div>
            <div class="avatar-actions">
                <asp:Button ID="btnCambiarLogo" runat="server" Text="Cambiar Logo" CssClass="btn-secondary" OnClick="btnCambiarLogo_Click" />
                <span class="avatar-hint">JPG, PNG. Máximo 2MB</span>
            </div>
        </div>

        <!-- Datos del Refugio -->
        <div class="form-group">
            <label for="txtNombreRefugio">Nombre del Refugio</label>
            <asp:TextBox ID="txtNombreRefugio" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div class="form-group">
            <label for="txtDescripcion">Descripción</label>
            <asp:TextBox ID="txtDescripcion" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control"></asp:TextBox>
        </div>

        <div class="form-grid">
            <div class="form-group">
                <label for="txtTelefono">Teléfono</label>
                <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtCiudad">Ciudad</label>
                <asp:TextBox ID="txtCiudad" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
        </div>

        <div class="form-group">
            <label for="txtDireccion">Dirección</label>
            <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div class="form-group">
            <label for="txtEmail">Correo Electrónico</label>
            <asp:TextBox ID="txtEmail" runat="server" Enabled="false" CssClass="form-control"></asp:TextBox>
            <small class="input-hint">El correo electrónico no puede ser modificado</small>
        </div>

        <div class="form-divider"></div>

        <h3 class="form-section-title">Cambiar Contraseña</h3>

        <div class="form-group">
            <label for="txtClaveActual">Contraseña Actual</label>
            <asp:TextBox ID="txtClaveActual" runat="server" TextMode="Password" CssClass="form-control" placeholder="••••••••"></asp:TextBox>
        </div>

        <div class="form-grid">
            <div class="form-group">
                <label for="txtNuevaClave">Nueva Contraseña</label>
                <asp:TextBox ID="txtNuevaClave" runat="server" TextMode="Password" CssClass="form-control" placeholder="••••••••"></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtConfirmarClave">Confirmar Contraseña</label>
                <asp:TextBox ID="txtConfirmarClave" runat="server" TextMode="Password" CssClass="form-control" placeholder="••••••••"></asp:TextBox>
            </div>
        </div>

        <div class="form-actions">
            <asp:Button ID="btnGuardar" runat="server" CssClass="btn-primary" Text="Guardar Cambios" OnClick="btnGuardar_Click" />
        </div>
    </div>
</asp:Content>
