<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true"
    CodeBehind="Configuracion.aspx.cs" Inherits="RedPatitas.Admin.Configuracion" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Configuración | Admin
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
    </asp:Content>
    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
        <div class="page-header">
            <h1 class="page-title">Configuración del Sistema</h1>
            <div class="breadcrumb">Admin / Configuración</div>
        </div>

        <!-- Tabs -->
        <div class="config-tabs">
            <asp:LinkButton ID="tabCriterios" runat="server" CssClass="config-tab active" OnClick="tabCriterios_Click">
                📋 Criterios de Evaluación</asp:LinkButton>
            <asp:LinkButton ID="tabEspecies" runat="server" CssClass="config-tab" OnClick="tabEspecies_Click">🐾
                Especies y Razas</asp:LinkButton>
            <asp:LinkButton ID="tabSeguridad" runat="server" CssClass="config-tab" OnClick="tabSeguridad_Click">🔒
                Seguridad</asp:LinkButton>
        </div>

        <!-- Sección: Criterios de Evaluación -->
        <asp:Panel ID="pnlCriterios" runat="server" CssClass="config-section active">
            <div class="admin-panel">
                <div class="panel-header">
                    <h2 class="panel-title">Criterios de Evaluación de Adopciones</h2>
                </div>

                <!-- Formulario Agregar/Editar -->
                <div style="background: #F9F9F9; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                    <asp:HiddenField ID="hdnCriterioId" runat="server" Value="0" />
                    <div class="form-row">
                        <div class="form-group">
                            <label>Nombre del Criterio</label>
                            <asp:TextBox ID="txtCriterioNombre" runat="server"
                                placeholder="Ej: Experiencia con mascotas"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>Peso (%)</label>
                            <asp:TextBox ID="txtCriterioPeso" runat="server" TextMode="Number" placeholder="Ej: 20">
                            </asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>Puntaje Máximo</label>
                            <asp:TextBox ID="txtCriterioPuntaje" runat="server" TextMode="Number" Text="10">
                            </asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Descripción</label>
                        <asp:TextBox ID="txtCriterioDescripcion" runat="server" TextMode="MultiLine" Rows="2"
                            placeholder="Descripción del criterio..."></asp:TextBox>
                    </div>
                    <asp:Button ID="btnGuardarCriterio" runat="server" Text="Guardar Criterio" CssClass="btn-add"
                        OnClick="btnGuardarCriterio_Click" />
                    <asp:Button ID="btnCancelarCriterio" runat="server" Text="Cancelar" CssClass="table-action-btn"
                        OnClick="btnCancelarCriterio_Click" Visible="false" />
                </div>

                <!-- Lista de Criterios -->
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Orden</th>
                            <th>Nombre</th>
                            <th>Peso</th>
                            <th>Puntaje Máx</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptCriterios" runat="server" OnItemCommand="rptCriterios_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <%# Eval("Orden") %>
                                    </td>
                                    <td><strong>
                                            <%# Eval("Nombre") %>
                                        </strong><br /><small style="color:#888;">
                                            <%# Eval("Descripcion") %>
                                        </small></td>
                                    <td>
                                        <%# Eval("Peso") %>%
                                    </td>
                                    <td>
                                        <%# Eval("PuntajeMaximo") %>
                                    </td>
                                    <td><span class='status-badge <%# (bool)Eval("Estado") ? "active" : "inactive" %>'>
                                            <%# (bool)Eval("Estado") ? "Activo" : "Inactivo" %>
                                        </span></td>
                                    <td>
                                        <asp:LinkButton ID="btnEditar" runat="server" CommandName="Editar"
                                            CommandArgument='<%# Eval("IdCriterio") %>'
                                            CssClass="table-action-btn edit">Editar</asp:LinkButton>
                                        <asp:LinkButton ID="btnEliminar" runat="server" CommandName="Eliminar"
                                            CommandArgument='<%# Eval("IdCriterio") %>'
                                            CssClass="table-action-btn delete"
                                            OnClientClick="return confirm('¿Eliminar este criterio?');">Eliminar
                                        </asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </asp:Panel>

        <!-- Sección: Especies y Razas -->
        <asp:Panel ID="pnlEspecies" runat="server" CssClass="config-section">
            <div class="admin-grid">
                <!-- Especies -->
                <div class="admin-panel">
                    <div class="panel-header">
                        <h2 class="panel-title">🐕 Especies</h2>
                    </div>
                    <div style="background: #F9F9F9; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                        <asp:HiddenField ID="hdnEspecieId" runat="server" Value="0" />
                        <div class="form-group">
                            <label>Nombre de Especie</label>
                            <asp:TextBox ID="txtEspecieNombre" runat="server" placeholder="Ej: Perro"></asp:TextBox>
                        </div>
                        <asp:Button ID="btnGuardarEspecie" runat="server" Text="Guardar" CssClass="btn-add"
                            OnClick="btnGuardarEspecie_Click" />
                    </div>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Especie</th>
                                <th>Razas</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptEspecies" runat="server" OnItemCommand="rptEspecies_ItemCommand">
                                <ItemTemplate>
                                    <tr>
                                        <td><strong>
                                                <%# Eval("Nombre") %>
                                            </strong></td>
                                        <td>
                                            <%# Eval("TotalRazas") %> razas
                                        </td>
                                        <td>
                                            <asp:LinkButton ID="btnEditarEspecie" runat="server" CommandName="Editar"
                                                CommandArgument='<%# Eval("IdEspecie") %>'
                                                CssClass="table-action-btn edit">Editar</asp:LinkButton>
                                            <asp:LinkButton ID="btnEliminarEspecie" runat="server"
                                                CommandName="Eliminar" CommandArgument='<%# Eval("IdEspecie") %>'
                                                CssClass="table-action-btn delete"
                                                OnClientClick="return confirm('¿Eliminar esta especie?');">Eliminar
                                            </asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>

                <!-- Razas -->
                <div class="admin-panel">
                    <div class="panel-header">
                        <h2 class="panel-title">🐾 Razas</h2>
                    </div>
                    <div style="background: #F9F9F9; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                        <asp:HiddenField ID="hdnRazaId" runat="server" Value="0" />
                        <div class="form-group">
                            <label>Especie</label>
                            <asp:DropDownList ID="ddlEspecieRaza" runat="server" CssClass="form-control">
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <label>Nombre de Raza</label>
                            <asp:TextBox ID="txtRazaNombre" runat="server" placeholder="Ej: Labrador"></asp:TextBox>
                        </div>
                        <asp:Button ID="btnGuardarRaza" runat="server" Text="Guardar" CssClass="btn-add"
                            OnClick="btnGuardarRaza_Click" />
                    </div>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Raza</th>
                                <th>Especie</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptRazas" runat="server" OnItemCommand="rptRazas_ItemCommand">
                                <ItemTemplate>
                                    <tr>
                                        <td><strong>
                                                <%# Eval("Nombre") %>
                                            </strong></td>
                                        <td>
                                            <%# Eval("NombreEspecie") %>
                                        </td>
                                        <td>
                                            <asp:LinkButton ID="btnEditarRaza" runat="server" CommandName="Editar"
                                                CommandArgument='<%# Eval("IdRaza") %>'
                                                CssClass="table-action-btn edit">Editar</asp:LinkButton>
                                            <asp:LinkButton ID="btnEliminarRaza" runat="server" CommandName="Eliminar"
                                                CommandArgument='<%# Eval("IdRaza") %>'
                                                CssClass="table-action-btn delete"
                                                OnClientClick="return confirm('¿Eliminar esta raza?');">Eliminar
                                            </asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </asp:Panel>

        <!-- Sección: Seguridad -->
        <asp:Panel ID="pnlSeguridad" runat="server" CssClass="config-section">
            <div class="admin-panel">
                <div class="panel-header">
                    <h2 class="panel-title">Configuración de Seguridad</h2>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Intentos máximos antes de bloqueo</label>
                        <asp:TextBox ID="txtIntentosMaximos" runat="server" TextMode="Number" Text="3"></asp:TextBox>
                        <small style="color:#888;">Número de intentos fallidos de login antes de bloquear la
                            cuenta</small>
                    </div>
                    <div class="form-group">
                        <label>Tiempo de expiración de token (horas)</label>
                        <asp:TextBox ID="txtExpiracionToken" runat="server" TextMode="Number" Text="24"></asp:TextBox>
                        <small style="color:#888;">Tiempo en horas que dura válido un token de recuperación</small>
                    </div>
                </div>
                <div class="form-group">
                    <label>Longitud mínima de contraseña</label>
                    <asp:TextBox ID="txtLongitudPassword" runat="server" TextMode="Number" Text="6"></asp:TextBox>
                </div>
                <asp:Button ID="btnGuardarSeguridad" runat="server" Text="Guardar Configuración" CssClass="btn-add"
                    OnClick="btnGuardarSeguridad_Click" />
                <asp:Label ID="lblMensajeSeguridad" runat="server" Visible="false" style="margin-left: 1rem;">
                </asp:Label>
            </div>
        </asp:Panel>

        <script type="text/javascript">
            // Script simple para mostrar tabs sin postback (opcional, ya se maneja server-side)
        </script>
    </asp:Content>