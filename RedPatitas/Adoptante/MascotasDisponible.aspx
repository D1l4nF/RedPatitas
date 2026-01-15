<%@ Page Title="" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true" CodeBehind="MascotasDisponible.aspx.cs" Inherits="RedPatitas.Adoptante.MascotasDisponible" %>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <!-- Título -->
        <div class="row mb-4">
            <div class="col-12">
                <h2 class="display-6"><i class="fas fa-paw text-primary"></i> Mascotas en Adopción</h2>
                <p class="text-muted">Encuentra a tu nuevo compañero de vida</p>
            </div>
        </div>
        
        <!-- Panel de Filtros -->
        <div class="card mb-4 border-0 shadow-sm">
            <div class="card-header bg-primary text-white py-3">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fas fa-filter me-2"></i>Filtrar Mascotas</h5>
                    <asp:Button ID="btnLimpiarFiltros" runat="server" 
                        Text="Limpiar Filtros" 
                        CssClass="btn btn-light btn-sm"
                        OnClick="btnLimpiarFiltros_Click" />
                </div>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <!-- Fila 1 -->
                    <div class="col-md-6 col-lg-3">
                        <label class="form-label fw-bold"><i class="fas fa-dog me-1"></i>Especie</label>
                        <asp:DropDownList ID="ddlEspecie" runat="server" 
                            CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlEspecie_SelectedIndexChanged">
                            <asp:ListItem Value="todas" Text="Todas las especies"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    
                    <div class="col-md-6 col-lg-3">
                        <label class="form-label fw-bold"><i class="fas fa-map-marker-alt me-1"></i>Ubicación</label>
                        <asp:DropDownList ID="ddlUbicacion" runat="server" 
                            CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlUbicacion_SelectedIndexChanged">
                            <asp:ListItem Value="todas" Text="Todas las ubicaciones"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    
                    <div class="col-md-6 col-lg-3">
                        <label class="form-label fw-bold"><i class="fas fa-expand-alt me-1"></i>Tamaño</label>
                        <asp:DropDownList ID="ddlTamano" runat="server" 
                            CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlTamano_SelectedIndexChanged">
                            <asp:ListItem Value="todos" Text="Todos los tamaños"></asp:ListItem>
                            <asp:ListItem Value="Pequeño" Text="Pequeño"></asp:ListItem>
                            <asp:ListItem Value="Mediano" Text="Mediano"></asp:ListItem>
                            <asp:ListItem Value="Grande" Text="Grande"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    
                    <div class="col-md-6 col-lg-3">
                        <label class="form-label fw-bold"><i class="fas fa-venus-mars me-1"></i>Sexo</label>
                        <asp:DropDownList ID="ddlSexo" runat="server" 
                            CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlSexo_SelectedIndexChanged">
                            <asp:ListItem Value="todos" Text="Ambos sexos"></asp:ListItem>
                            <asp:ListItem Value="M" Text="Macho"></asp:ListItem>
                            <asp:ListItem Value="F" Text="Hembra"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    
                    <!-- Fila 2 -->
                    <div class="col-md-6 col-lg-3">
                        <label class="form-label fw-bold"><i class="fas fa-birthday-cake me-1"></i>Edad</label>
                        <asp:DropDownList ID="ddlEdadAproximada" runat="server" 
                            CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlEdadAproximada_SelectedIndexChanged">
                            <asp:ListItem Value="todas" Text="Todas las edades"></asp:ListItem>
                            <asp:ListItem Value="Cachorro" Text="Cachorro"></asp:ListItem>
                            <asp:ListItem Value="Adulto" Text="Adulto"></asp:ListItem>
                            <asp:ListItem Value="Senior" Text="Senior"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    
                    <!-- Checkboxes de salud -->
                    <div class="col-md-6 col-lg-3 d-flex align-items-end">
                        <div class="form-check">
                            <asp:CheckBox ID="chkEsterilizado" runat="server" 
                                CssClass="form-check-input" AutoPostBack="true" OnCheckedChanged="chkEsterilizado_CheckedChanged" />
                            <label class="form-check-label fw-bold" for="chkEsterilizado">
                                <i class="fas fa-stethoscope me-1"></i>Esterilizado
                            </label>
                        </div>
                    </div>
                    
                    <div class="col-md-6 col-lg-3 d-flex align-items-end">
                        <div class="form-check">
                            <asp:CheckBox ID="chkVacunado" runat="server" 
                                CssClass="form-check-input" AutoPostBack="true" OnCheckedChanged="chkVacunado_CheckedChanged" />
                            <label class="form-check-label fw-bold" for="chkVacunado">
                                <i class="fas fa-syringe me-1"></i>Vacunado
                            </label>
                        </div>
                    </div>
                    
                    <!-- Contador de resultados -->
                    <div class="col-md-6 col-lg-3">
                        <div class="alert alert-light border mb-0 text-center">
                            <i class="fas fa-search me-2"></i>
                            <strong id="lblContador" runat="server">0</strong> mascotas encontradas
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Resultados -->
        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4" id="panelMascotas" runat="server">
            <!-- Las mascotas se cargarán aquí dinámicamente -->
        </div>

        <!-- Mensaje si no hay resultados -->
        <div class="text-center py-5" id="panelNoResultados" runat="server" visible="false">
            <div class="card border-warning">
                <div class="card-body py-5">
                    <i class="fas fa-search fa-4x text-warning mb-3"></i>
                    <h4 class="text-warning">No se encontraron mascotas</h4>
                    <p class="text-muted mb-4">Prueba ajustando los filtros de búsqueda</p>
                    <asp:Button ID="btnVerTodas" runat="server" 
                        Text="Ver todas las mascotas" 
                        CssClass="btn btn-warning"
                        OnClick="btnVerTodas_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
