<%@ Page Title="" Language="C#" MasterPageFile="~/AdminRefugio/AdminRefugio.Master" AutoEventWireup="true"
    CodeBehind="Usuarios.aspx.cs" Inherits="RedPatitas.AdminRefugio.Usuarios" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Gestión de Personal | RedPatitas
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <style>
            .user-card {
                background: white;
                border-radius: 12px;
                padding: 1rem;
                display: flex;
                align-items: center;
                gap: 1rem;
                border: 1px solid #eee;
                margin-bottom: 1rem;
            }

            .user-avatar {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                background: #EFF6FF;
                color: #2563EB;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.25rem;
                font-weight: 600;
            }

            .user-info {
                flex: 1;
            }

            .user-name {
                font-weight: 600;
                color: var(--text-dark);
                margin: 0;
                font-size: 1rem;
            }

            .user-email {
                color: #666;
                font-size: 0.875rem;
                margin: 0;
            }

            .form-grid {
                display: grid;
                gap: 1rem;
            }
        </style>
    </asp:Content>
    <asp:Content ID="Content4" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">Personal del Refugio</h1>
            <div class="breadcrumb">Dashboard / Usuarios</div>
        </div>
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 2rem; align-items: start;">

            <!-- Lista de Usuarios -->
            <div class="recent-section">
                <div class="section-header">
                    <h2 class="section-title">Equipo de Trabajo</h2>
                </div>

                <asp:Repeater ID="rptUsuarios" runat="server" OnItemCommand="rptUsuarios_ItemCommand">
                    <ItemTemplate>
                        <div class="user-card">
                            <div class="user-avatar">
                                <%# Eval("usu_Nombre").ToString().Substring(0,1).ToUpper() %>
                            </div>
                            <div class="user-info">
                                <h3 class="user-name">
                                    <%# Eval("usu_Nombre") %>
                                        <%# Eval("usu_Apellido") %>
                                </h3>
                                <p class="user-email">
                                    <%# Eval("usu_Email") %>
                                </p>
                                <span
                                    style='font-size:0.8rem; color:<%# (bool)Eval("usu_Bloqueado") ? "red" : "green" %>'>
                                    <%# (bool)Eval("usu_Bloqueado") ? "Bloqueado" : "Activo" %>
                                </span>
                            </div>
                            <div class="actions">
                                <asp:LinkButton ID="btnBloquear" runat="server"
                                    CommandName='<%# (bool)Eval("usu_Bloqueado") ? "Desbloquear" : "Bloquear" %>'
                                    CommandArgument='<%# Eval("usu_IdUsuario") %>'
                                    CssClass='<%# (bool)Eval("usu_Bloqueado") ? "table-action-btn success" : "table-action-btn reject" %>'
                                    ToolTip='<%# (bool)Eval("usu_Bloqueado") ? "Desbloquear Acceso" : "Bloquear Acceso" %>'
                                    OnClientClick="return confirm('¿Estás seguro de cambiar el estado de este usuario?');">
                                    <i class='fas <%# (bool)Eval("usu_Bloqueado") ? "fa-unlock" : "fa-lock" %>'></i>
                                </asp:LinkButton>
                            </div>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        <div id="noData" runat="server" visible='<%# ((Repeater)Container.Parent).Items.Count == 0 %>'
                            style="padding: 1rem; text-align: center; color: #666;">
                            No hay personal registrado además de ti.
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
            </div>

            <!-- Formulario Nuevo Usuario -->
            <div class="recent-section">
                <div class="section-header">
                    <h2 class="section-title">Agregar Personal</h2>
                </div>
                <div class="form-grid">
                    <div class="form-group">
                        <label>Nombre</label>
                        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Nombre">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre"
                            ErrorMessage="*" ForeColor="Red" ValidationGroup="NuevoUser"></asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group">
                        <label>Apellido</label>
                        <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control" placeholder="Apellido">
                        </asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"
                            placeholder="correo@ejemplo.com"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="*" ForeColor="Red" ValidationGroup="NuevoUser"></asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group">
                        <label>Contraseña Temporal</label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPass" runat="server" ControlToValidate="txtPassword"
                            ErrorMessage="*" ForeColor="Red" ValidationGroup="NuevoUser"></asp:RequiredFieldValidator>
                    </div>

                    <asp:Button ID="btnRegistrar" runat="server" Text="Registrar Usuario" CssClass="quick-action-btn"
                        OnClick="btnRegistrar_Click" ValidationGroup="NuevoUser" />
                </div>
            </div>
        </div>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            .table-action-btn.success {
                background: #D1FAE5;
                color: #059669;
            }

            .table-action-btn.reject {
                background: #FEE2E2;
                color: #DC2626;
            }
        </style>
    </asp:Content>