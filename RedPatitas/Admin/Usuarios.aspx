<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true"
    CodeBehind="Usuarios.aspx.cs" Inherits="RedPatitas.Admin.Usuarios" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Gestión de Usuarios | Admin
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
    </asp:Content>
    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
        <div class="page-header">
            <h1 class="page-title">Gestión de Usuarios</h1>
            <div class="breadcrumb">Admin / Usuarios</div>
        </div>

        <!-- Filtros -->
        <div class="admin-panel" style="margin-bottom: 1.5rem;">
            <div class="panel-header">
                <span class="panel-title">Filtros</span>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <div style="display: flex; gap: 1rem; flex-wrap: wrap; align-items: flex-end;">
                <div>
                    <label
                        style="font-size: 0.8rem; color: var(--text-light); display: block; margin-bottom: 0.25rem;">Rol</label>
                    <asp:DropDownList ID="ddlFiltroRol" runat="server" AutoPostBack="true"
                        OnSelectedIndexChanged="ddlFiltroRol_SelectedIndexChanged" CssClass="form-control">
                        <asp:ListItem Value="0" Text="Todos los roles"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div>
                    <label
                        style="font-size: 0.8rem; color: var(--text-light); display: block; margin-bottom: 0.25rem;">Estado</label>
                    <asp:DropDownList ID="ddlFiltroEstado" runat="server" AutoPostBack="true"
                        OnSelectedIndexChanged="ddlFiltroEstado_SelectedIndexChanged" CssClass="form-control">
                        <asp:ListItem Value="" Text="Todos"></asp:ListItem>
                        <asp:ListItem Value="true" Text="Activos"></asp:ListItem>
                        <asp:ListItem Value="false" Text="Inactivos"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div>
                    <label
                        style="font-size: 0.8rem; color: var(--text-light); display: block; margin-bottom: 0.25rem;">Buscar</label>
                    <asp:TextBox ID="txtBusqueda" runat="server" placeholder="Nombre o email..."
                        CssClass="form-control"></asp:TextBox>
                </div>
                <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="btn btn-primary"
                    OnClick="btnBuscar_Click" />
            </div>
        </div>

        <!-- Tabla de Usuarios -->
        <div class="admin-panel">
            <div class="panel-header">
                <span class="panel-title">Usuarios Registrados</span>
            </div>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Usuario</th>
                        <th>Rol</th>
                        <th>Refugio</th>
                        <th>Estado</th>
                        <th>Último Acceso</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptUsuarios" runat="server" OnItemCommand="rptUsuarios_ItemCommand"
                        OnItemDataBound="rptUsuarios_ItemDataBound">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <div class="user-cell">
                                        <asp:Panel ID="pnlAvatar" runat="server" CssClass="user-avatar">
                                            <%# Eval("Iniciales") %>
                                        </asp:Panel>
                                        <div>
                                            <div class="user-name">
                                                <%# Eval("NombreCompleto") %>
                                            </div>
                                            <div class="user-email">
                                                <%# Eval("Email") %>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class='status-badge <%# GetRolBadgeClass((int)Eval("IdRol")) %>'>
                                        <%# Eval("NombreRol") %>
                                    </span>
                                </td>
                                <td>
                                    <%# Eval("NombreRefugio") %>
                                </td>
                                <td>
                                    <%# (bool)Eval("Bloqueado")
                                        ? "<span class='status-badge inactive'>🔒 Bloqueado</span>" :
                                        ((bool)Eval("Estado") ? "<span class='status-badge active'>Activo</span>"
                                        : "<span class='status-badge inactive'>Inactivo</span>" ) %>
                                </td>
                                <td>
                                    <%# Eval("UltimoAcceso") !=null ?
                                        ((DateTime)Eval("UltimoAcceso")).ToString("dd/MM/yyyy HH:mm") : "Nunca" %>
                                </td>
                                <td>
                                    <asp:LinkButton ID="btnCambiarEstado" runat="server" CommandName="CambiarEstado"
                                        CommandArgument='<%# Eval("IdUsuario") + "," + Eval("Estado") %>'
                                        CssClass='<%# (bool)Eval("Estado") ? "table-action-btn delete" : "table-action-btn edit" %>'
                                        ToolTip='<%# (bool)Eval("Estado") ? "Desactivar" : "Activar" %>'>
                                        <%# (bool)Eval("Estado") ? "Desactivar" : "Activar" %>
                                    </asp:LinkButton>

                                    <asp:LinkButton ID="btnDesbloquear" runat="server" CommandName="Desbloquear"
                                        CommandArgument='<%# Eval("IdUsuario") %>' CssClass="table-action-btn edit"
                                        Visible='<%# (bool)Eval("Bloqueado") %>' ToolTip="Desbloquear cuenta">
                                        🔓 Desbloquear
                                    </asp:LinkButton>

                                    <!-- Botón Asignar (Para Adoptantes o Personal de Refugio) -->
                                    <asp:LinkButton ID="btnAsignarRefugio" runat="server" CommandName="AsignarRefugio"
                                        CommandArgument='<%# Eval("IdUsuario") + "," + Eval("IdRol") %>'
                                        CssClass="table-action-btn edit"
                                        Visible='<%# (int)Eval("IdRol") == 3 || (int)Eval("IdRol") == 4 %>'
                                        ToolTip="Asignar a refugio">
                                        🏠 Asignar
                                    </asp:LinkButton>

                                    <!-- Botón Verificar (Solo para AdminRefugio - Abre Modal) -->
                                    <asp:LinkButton ID="btnRevisar" runat="server" CommandName="RevisarRefugio"
                                        CommandArgument='<%# Eval("IdRefugio") %>' CssClass="table-action-btn success"
                                        Visible='<%# (int)Eval("IdRol") == 2 && Eval("IdRefugio") != null %>'
                                        ToolTip="Gestionar Verificación">
                                        <%# (bool)Eval("RefugioVerificado") ? "📝 Gestionar" : "✅ Revisar" %>
                                    </asp:LinkButton>

                                    <!-- Indicador Verificado -->
                                    <span class="status-badge success"
                                        style='<%# (int)Eval("IdRol") == 2 && (bool)Eval("RefugioVerificado") ? "display:inline-block; font-size: 0.75rem;" : "display:none;" %>'>
                                        <!-- Indicador Verificado -->
                                        <span class="status-badge success"
                                            style='<%# (int)Eval("IdRol") == 2 && (bool)Eval("RefugioVerificado") ? "display:inline-block; font-size: 0.75rem;" : "display:none;" %>'>
                                            ✓ Verificado
                                        </span>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>

            <asp:Panel ID="pnlSinResultados" runat="server" Visible="false">
                <div style="text-align: center; padding: 2rem; color: var(--text-light);">
                    <p>No se encontraron usuarios con los filtros seleccionados.</p>
                </div>
            </asp:Panel>
        </div>

        <!-- Modal para Asignar Refugio -->
        <asp:Panel ID="pnlModalAsignar" runat="server" CssClass="modal-overlay">
            <div class="modal">
                <div class="modal-title">Asignar Usuario a Refugio</div>
                <div class="modal-message">
                    <asp:HiddenField ID="hdnUsuarioId" runat="server" />
                    <p style="margin-bottom: 1rem;">Selecciona el refugio:</p>
                    <asp:DropDownList ID="ddlRefugios" runat="server" CssClass="form-control" style="width: 100%;">
                    </asp:DropDownList>
                </div>
                <div class="modal-actions">
                    <asp:Button ID="btnCancelarAsignar" runat="server" Text="Cancelar" CssClass="modal-btn secondary"
                        OnClick="btnCancelarAsignar_Click" />
                    <asp:Button ID="btnConfirmarAsignar" runat="server" Text="Asignar" CssClass="modal-btn primary"
                        OnClick="btnConfirmarAsignar_Click" />
                </div>
            </div>
        </asp:Panel>

        <!-- Modal para Verificar Refugio -->
        <asp:Panel ID="pnlModalVerificar" runat="server" CssClass="modal-overlay">
            <div class="modal" style="max-width: 600px;">
                <div class="modal-title">Verificación de Refugio</div>
                <div class="modal-message" style="text-align: left;">
                    <asp:HiddenField ID="hdnRefugioVerificarId" runat="server" />

                    <div style="display: flex; gap: 1rem; margin-bottom: 1rem;">
                        <asp:Image ID="imgRefugioVerif" runat="server" CssClass="avatar" Width="80px" Height="80px"
                            style="border-radius: 8px; object-fit: cover; background: #eee;" />
                        <div>
                            <h3 style="margin: 0; font-size: 1.2rem; color: #333;">
                                <asp:Literal ID="litNombreRefugioVerif" runat="server" />
                            </h3>
                            <p style="margin: 5px 0; color: #666; font-size: 0.9rem;">
                                📍
                                <asp:Literal ID="litCiudadRefugioVerif" runat="server" /> -
                                <asp:Literal ID="litDireccionRefugioVerif" runat="server" />
                            </p>
                            <p style="margin: 0; color: #666; font-size: 0.9rem;">
                                📞
                                <asp:Literal ID="litTelefonoRefugioVerif" runat="server" />
                            </p>
                        </div>
                    </div>

                    <div style="background: #f9f9f9; padding: 10px; border-radius: 6px; margin-bottom: 1rem;">
                        <span style="font-weight: 600; font-size: 0.85rem; color: #555;">Descripción:</span>
                        <p style="margin: 5px 0; font-size: 0.9rem; line-height: 1.4;">
                            <asp:Literal ID="litDescripcionRefugioVerif" runat="server" />
                        </p>
                    </div>

                    <div style="display: flex; justify-content: space-between; font-size: 0.85rem; color: #666;">
                        <span>Mascotas Registradas: <b>
                                <asp:Literal ID="litMascotasRefugioVerif" runat="server" />
                            </b></span>
                        <span>Registrado: <b>
                                <asp:Literal ID="litFechaRefugioVerif" runat="server" />
                            </b></span>
                    </div>

                    <asp:Panel ID="pnlEstadoVerificado" runat="server" Visible="false"
                        style="margin-top: 15px; padding: 10px; background: #d1fae5; color: #065f46; border-radius: 6px; text-align: center;">
                        ✅ Este refugio ya está verificado
                    </asp:Panel>
                </div>

                <div class="modal-actions" style="justify-content: space-between;">
                    <asp:Button ID="btnCerrarVerificar" runat="server" Text="Cerrar" CssClass="modal-btn secondary"
                        OnClick="btnCerrarVerificar_Click" />

                    <div style="display: flex; gap: 10px;">
                        <asp:Button ID="btnQuitarVerificacion" runat="server" Text="Quitar Verificación"
                            CssClass="modal-btn delete" OnClick="btnQuitarVerificacion_Click" Visible="false"
                            OnClientClick="return confirmAction('¿Quitar verificación?', 'El refugio perderá su estado verificado.', 'warning');" />

                        <asp:Button ID="btnAprobarVerificacion" runat="server" Text="Aprobar Verificación"
                            CssClass="modal-btn primary" OnClick="btnAprobarVerificacion_Click" Visible="false"
                            OnClientClick="return confirmAction('¿Aprobar Refugio?', 'El refugio aparecerá como verificado en la plataforma.', 'success');" />
                    </div>
                </div>
            </div>
        </asp:Panel>

        <script>
            function confirmAction(title, text, icon) {
                event.preventDefault(); // Prevenir postback inmediato
                const btn = event.target; // El botón que disparó el evento

                Swal.fire({
                    title: title,
                    text: text,
                    icon: icon,
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Sí, confirmar',
                    cancelButtonText: 'Cancelar'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Crear postback manual si confirmó
                        __doPostBack(btn.name, '');
                    }
                });
                return false;
            }
        </script>

        <asp:Label ID="lblMensaje" runat="server" Visible="false"></asp:Label>
    </asp:Content>