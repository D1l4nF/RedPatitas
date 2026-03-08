<%@ Page Title="Registrar Avistamiento" Language="C#" MasterPageFile="~/Public/Public.Master" AutoEventWireup="true"
    CodeBehind="RegistrarAvistamiento.aspx.cs" Inherits="RedPatitas.Public.RegistrarAvistamiento" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Registrar Avistamiento | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link rel="stylesheet" href="~/Style/estilos-publicos.css" />
        <link rel="stylesheet" href="~/Style/forms.css" />
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

        <section class="report-hero">
            <h1>👁 Registrar Avistamiento</h1>
            <p>¿Viste a esta mascota? Tu avistamiento puede ayudar a reunirla con su familia.</p>
        </section>

        <section class="report-section">
            <div class="report-container" style="max-width:640px;">
                <div class="report-form-card">

                    <!-- Info del reporte -->
                    <asp:Panel ID="pnlInfoReporte" runat="server">
                        <div style="background:#f8f9fa; border-radius:10px; padding:1rem 1.5rem;
                                margin-bottom:1.5rem; border-left:4px solid #1a73e8;">
                            <h3 style="margin:0 0 0.5rem;">
                                <asp:Literal ID="litNombreReporte" runat="server"></asp:Literal>
                            </h3>
                            <p style="margin:0; color:#666; font-size:0.9rem;">
                                <asp:Literal ID="litInfoReporte" runat="server"></asp:Literal>
                            </p>
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="form-group">
                        <asp:Label ID="lblMensaje" runat="server"></asp:Label>
                    </asp:Panel>

                    <asp:HiddenField ID="hfIdReporte" runat="server" />

                    <div class="form-group">
                        <label>📍 ¿Dónde lo viste? *</label>
                        <asp:TextBox ID="txtUbicacion" runat="server" CssClass="form-control"
                            placeholder="Ej: Parque El Ejido, junto a la fuente"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvUbicacion" runat="server" ControlToValidate="txtUbicacion"
                            ErrorMessage="La ubicación es requerida" ForeColor="Red" Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <label>🗓 Fecha y hora del avistamiento *</label>
                        <asp:TextBox ID="txtFechaAvistamiento" runat="server" CssClass="form-control"
                            TextMode="DateTimeLocal"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvFecha" runat="server"
                            ControlToValidate="txtFechaAvistamiento" ErrorMessage="La fecha es requerida"
                            ForeColor="Red" Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <label>🗺 Marca en el mapa dónde lo viste (opcional)</label>
                        <div id="mapAvistamiento"
                            style="height:220px; border-radius:10px; margin-bottom:8px; border:1px solid #ddd;"></div>
                        <asp:HiddenField ID="hfLat" runat="server" />
                        <asp:HiddenField ID="hfLng" runat="server" />
                        <p style="font-size:0.82rem; color:#888; margin:0;">
                            📍 Clic en el mapa para marcar la ubicación exacta
                        </p>
                    </div>

                    <div class="form-group">
                        <label>📝 Descripción del avistamiento *</label>
                        <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" TextMode="MultiLine"
                            Rows="4"
                            placeholder="¿En qué dirección iba? ¿Cómo estaba? ¿Estaba solo? Cualquier detalle ayuda...">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvDescripcion" runat="server"
                            ControlToValidate="txtDescripcion" ErrorMessage="La descripción es requerida"
                            ForeColor="Red" Display="Dynamic" />
                    </div>

                    <div class="form-actions">
                        <asp:Button ID="btnEnviar" runat="server" Text="👁 Enviar Avistamiento" CssClass="btn-primary"
                            OnClick="btnEnviar_Click" />
                        <a href="javascript:history.back()" class="btn-secondary">Cancelar</a>
                    </div>

                </div>
            </div>
        </section>

        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        <script type="text/javascript">
            document.addEventListener('DOMContentLoaded', function () {
                var map = L.map('mapAvistamiento').setView([-0.1807, -78.4678], 13);
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '© OpenStreetMap'
                }).addTo(map);

                var marker;
                map.on('click', function (e) {
                    if (marker) map.removeLayer(marker);
                    marker = L.marker(e.latlng).addTo(map);
                    document.getElementById('<%= hfLat.ClientID %>').value = e.latlng.lat;
                    document.getElementById('<%= hfLng.ClientID %>').value = e.latlng.lng;
                });

                // Fecha default: ahora
                var dtInput = document.getElementById('<%= txtFechaAvistamiento.ClientID %>');
                if (dtInput && !dtInput.value) {
                    var now = new Date();
                    now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
                    dtInput.value = now.toISOString().slice(0, 16);
                }
            });
        </script>
    </asp:Content>