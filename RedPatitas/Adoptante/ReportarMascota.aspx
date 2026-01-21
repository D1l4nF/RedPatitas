<%@ Page Title="Reportar Mascota" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true"
    CodeBehind="ReportarMascota.aspx.cs" Inherits="RedPatitas.Adoptante.ReportarMascota" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Reportar Mascota | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link href='<%= ResolveUrl("~/Style/dashboard.css") %>' rel="stylesheet" type="text/css" />
        <link href='<%= ResolveUrl("~/Style/forms.css") %>' rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">🚨 Reportar Mascota</h1>
            <div class="breadcrumb">Ayúdanos a reunir mascotas con sus familias</div>
        </div>
    </asp:Content>

    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

        <div class="form-container" style="max-width: 800px;">

            <!-- Mensaje de resultado -->
            <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="form-group">
                <asp:Label ID="lblMensaje" runat="server"></asp:Label>
            </asp:Panel>

            <!-- Tipo de Reporte -->
            <div class="form-group">
                <label>¿Qué deseas reportar?</label>
                <div style="display: flex; gap: 1rem; margin-top: 0.5rem;">
                    <asp:RadioButton ID="rbPerdida" runat="server" GroupName="TipoReporte" Text=" 😿 Mascota Perdida"
                        Checked="true" CssClass="radio-option" />
                    <asp:RadioButton ID="rbEncontrada" runat="server" GroupName="TipoReporte"
                        Text=" 🐾 Mascota Encontrada" CssClass="radio-option" />
                </div>
            </div>

            <div class="form-divider"></div>

            <h3 class="form-section-title">📋 Datos de la mascota</h3>

            <div class="form-grid">
                <div class="form-group">
                    <label>Nombre de la mascota</label>
                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control"
                        placeholder="Ej: Max (si lo conoces)"></asp:TextBox>
                    <small class="input-hint">Opcional si es mascota encontrada</small>
                </div>
                <div class="form-group">
                    <label>Especie *</label>
                    <asp:DropDownList ID="ddlEspecie" runat="server" CssClass="form-control">
                        <asp:ListItem Value="">Selecciona...</asp:ListItem>
                        <asp:ListItem Value="1">🐕 Perro</asp:ListItem>
                        <asp:ListItem Value="2">🐱 Gato</asp:ListItem>
                        <asp:ListItem Value="3">🐰 Conejo</asp:ListItem>
                        <asp:ListItem Value="4">🐦 Ave</asp:ListItem>
                        <asp:ListItem Value="5">🐹 Hámster</asp:ListItem>
                        <asp:ListItem Value="6">🐾 Otro</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvEspecie" runat="server" ControlToValidate="ddlEspecie"
                        InitialValue="" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="form-grid">
                <div class="form-group">
                    <label>Raza (aproximada)</label>
                    <asp:TextBox ID="txtRaza" runat="server" CssClass="form-control"
                        placeholder="Ej: Labrador, Mestizo, Siamés"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Color</label>
                    <asp:TextBox ID="txtColor" runat="server" CssClass="form-control"
                        placeholder="Ej: Negro con manchas blancas"></asp:TextBox>
                </div>
            </div>

            <div class="form-grid">
                <div class="form-group">
                    <label>Tamaño</label>
                    <asp:DropDownList ID="ddlTamano" runat="server" CssClass="form-control">
                        <asp:ListItem Value="">No sé</asp:ListItem>
                        <asp:ListItem Value="Pequeño">Pequeño</asp:ListItem>
                        <asp:ListItem Value="Mediano">Mediano</asp:ListItem>
                        <asp:ListItem Value="Grande">Grande</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>Sexo</label>
                    <asp:DropDownList ID="ddlSexo" runat="server" CssClass="form-control">
                        <asp:ListItem Value="">No sé</asp:ListItem>
                        <asp:ListItem Value="M">Macho</asp:ListItem>
                        <asp:ListItem Value="F">Hembra</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <div class="form-group">
                <label>Edad aproximada</label>
                <asp:DropDownList ID="ddlEdad" runat="server" CssClass="form-control">
                    <asp:ListItem Value="">No sé</asp:ListItem>
                    <asp:ListItem Value="Cachorro">Cachorro</asp:ListItem>
                    <asp:ListItem Value="Joven">Joven</asp:ListItem>
                    <asp:ListItem Value="Adulto">Adulto</asp:ListItem>
                    <asp:ListItem Value="Senior">Senior</asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="form-group">
                <label>Descripción y características distintivas *</label>
                <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"
                    placeholder="Describe la mascota: collar, marcas especiales, comportamiento..."></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvDescripcion" runat="server" ControlToValidate="txtDescripcion"
                    ErrorMessage="Por favor describe la mascota" ForeColor="Red"></asp:RequiredFieldValidator>
            </div>

            <div class="form-divider"></div>

            <h3 class="form-section-title">📍 Ubicación</h3>

            <div class="form-group">
                <label>Última ubicación conocida *</label>
                <asp:TextBox ID="txtUbicacion" runat="server" CssClass="form-control"
                    placeholder="Ej: Parque La Carolina, Quito"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvUbicacion" runat="server" ControlToValidate="txtUbicacion"
                    ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label>Ciudad</label>
                <asp:TextBox ID="txtCiudad" runat="server" CssClass="form-control" placeholder="Ej: Quito">
                </asp:TextBox>
            </div>

            <div class="form-group">
                <label>Marca la ubicación en el mapa</label>
                <div id="mapReporte"
                    style="height: 250px; border-radius: 8px; margin-bottom: 10px; border: 1px solid #ddd;"></div>
                <asp:HiddenField ID="hfLatitud" runat="server" />
                <asp:HiddenField ID="hfLongitud" runat="server" />
                <p style="font-size: 0.85rem; color: #666;">📍 Haz clic en el mapa para marcar la ubicación exacta</p>
            </div>

            <div class="form-group">
                <label>Fecha del evento</label>
                <asp:TextBox ID="txtFecha" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                <small class="input-hint">¿Cuándo se perdió o encontró la mascota?</small>
            </div>

            <div class="form-divider"></div>

            <h3 class="form-section-title">📞 Contacto</h3>

            <div class="form-grid">
                <div class="form-group">
                    <label>Teléfono de contacto *</label>
                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" placeholder="Ej: 0999123456">
                    </asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvTelefono" runat="server" ControlToValidate="txtTelefono"
                        ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                </div>
                <div class="form-group">
                    <label>Email de contacto</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"
                        placeholder="Ej: correo@ejemplo.com"></asp:TextBox>
                </div>
            </div>

            <div class="form-actions">
                <asp:Button ID="btnEnviar" runat="server" Text="📤 Enviar Reporte" CssClass="btn-primary"
                    OnClick="btnEnviar_Click" />
                <a href="Dashboard.aspx" class="btn-secondary">Cancelar</a>
            </div>
        </div>

        <!-- Leaflet JS -->
        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        <script type="text/javascript">
            document.addEventListener('DOMContentLoaded', function () {
                // Coordenadas por defecto (Quito)
                var lat = -0.1807;
                var lng = -78.4678;

                var map = L.map('mapReporte').setView([lat, lng], 13);

                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '© OpenStreetMap'
                }).addTo(map);

                var marker;

                // Click en el mapa para colocar marcador
                map.on('click', function (e) {
                    if (marker) map.removeLayer(marker);
                    marker = L.marker(e.latlng).addTo(map);

                    document.getElementById('<%= hfLatitud.ClientID %>').value = e.latlng.lat;
                    document.getElementById('<%= hfLongitud.ClientID %>').value = e.latlng.lng;
                });
            });
        </script>
    </asp:Content>