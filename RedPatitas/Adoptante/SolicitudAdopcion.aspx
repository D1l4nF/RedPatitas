<%@ Page Title="Solicitud de Adopción" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master"
    AutoEventWireup="true" CodeBehind="SolicitudAdopcion.aspx.cs" Inherits="RedPatitas.Adoptante.SolicitudAdopcion" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Solicitud de Adopción | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link href='<%= ResolveUrl("~/Style/dashboard.css") %>' rel="stylesheet" type="text/css" />
        <link href='<%= ResolveUrl("~/Style/pet-cards.css") %>' rel="stylesheet" type="text/css" />
        <style>
            .solicitud-container {
                max-width: 900px;
                margin: 0 auto;
            }

            .pet-summary-card {
                background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
                border-radius: 16px;
                padding: 1.5rem;
                display: flex;
                gap: 1.5rem;
                align-items: center;
                margin-bottom: 2rem;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
                border: 1px solid #eee;
            }

            .pet-summary-image {
                width: 120px;
                height: 120px;
                border-radius: 12px;
                object-fit: cover;
                border: 3px solid #fff;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }

            .pet-summary-emoji {
                width: 120px;
                height: 120px;
                border-radius: 12px;
                background: linear-gradient(135deg, #FFD275 0%, #FFC107 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 3.5rem;
            }

            .pet-summary-info h2 {
                font-size: 1.5rem;
                color: var(--secondary-color);
                margin-bottom: 0.5rem;
            }

            .pet-summary-details {
                display: flex;
                flex-wrap: wrap;
                gap: 1rem;
                color: var(--text-light);
                font-size: 0.9rem;
            }

            .pet-summary-details span {
                display: flex;
                align-items: center;
                gap: 0.35rem;
            }

            .form-section {
                background: #fff;
                border-radius: 16px;
                padding: 2rem;
                margin-bottom: 1.5rem;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            }

            .form-section-title {
                font-size: 1.15rem;
                font-weight: 700;
                color: var(--secondary-color);
                margin-bottom: 1.5rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .form-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 1.25rem;
            }

            .form-group {
                margin-bottom: 1.25rem;
            }

            .form-group label {
                display: block;
                font-weight: 600;
                margin-bottom: 0.5rem;
                color: var(--secondary-color);
                font-size: 0.9rem;
            }

            .form-control {
                width: 100%;
                padding: 0.85rem 1rem;
                border: 2px solid #e9ecef;
                border-radius: 10px;
                font-family: inherit;
                font-size: 0.95rem;
                transition: all 0.2s ease;
                background: #fafafa;
            }

            .form-control:focus {
                outline: none;
                border-color: var(--primary-color);
                background: #fff;
                box-shadow: 0 0 0 4px rgba(46, 204, 113, 0.1);
            }

            .form-control::placeholder {
                color: #adb5bd;
            }

            textarea.form-control {
                min-height: 120px;
                resize: vertical;
            }

            .checkbox-group {
                display: flex;
                flex-wrap: wrap;
                gap: 1.5rem;
            }

            .checkbox-item {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                cursor: pointer;
            }

            .checkbox-item input[type="checkbox"] {
                width: 20px;
                height: 20px;
                accent-color: var(--primary-color);
            }

            .radio-group {
                display: flex;
                flex-wrap: wrap;
                gap: 0.75rem;
            }

            .radio-item {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.75rem 1rem;
                border: 2px solid #e9ecef;
                border-radius: 10px;
                cursor: pointer;
                transition: all 0.2s ease;
                background: #fafafa;
            }

            .radio-item:hover {
                border-color: var(--primary-color);
                background: #fff;
            }

            .radio-item input[type="radio"] {
                accent-color: var(--primary-color);
            }

            .radio-item.selected {
                border-color: var(--primary-color);
                background: linear-gradient(135deg, #D5F5E3 0%, #E8F8F5 100%);
            }

            .conditional-field {
                margin-top: 1rem;
                padding: 1rem;
                background: #f8f9fa;
                border-radius: 10px;
                border-left: 4px solid var(--primary-color);
            }

            .range-slider {
                width: 100%;
                margin-top: 0.5rem;
            }

            .range-value {
                display: inline-block;
                padding: 0.35rem 0.75rem;
                background: var(--primary-color);
                color: white;
                border-radius: 20px;
                font-weight: 600;
                font-size: 0.85rem;
                margin-left: 0.5rem;
            }

            .form-actions {
                display: flex;
                gap: 1rem;
                justify-content: flex-end;
                margin-top: 1.5rem;
                padding-top: 1.5rem;
                border-top: 1px solid #eee;
            }

            .btn-submit {
                padding: 1rem 2.5rem;
                background: linear-gradient(135deg, var(--primary-color) 0%, #27AE60 100%);
                color: white;
                border: none;
                border-radius: 12px;
                font-weight: 700;
                font-size: 1rem;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .btn-submit:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(46, 204, 113, 0.3);
            }

            .btn-cancel {
                padding: 1rem 2rem;
                background: #f5f5f5;
                color: #666;
                border: none;
                border-radius: 12px;
                font-weight: 600;
                font-size: 1rem;
                cursor: pointer;
                text-decoration: none;
                transition: all 0.2s ease;
            }

            .btn-cancel:hover {
                background: #eee;
            }

            .alert {
                padding: 1rem 1.5rem;
                border-radius: 12px;
                margin-bottom: 1.5rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .alert-warning {
                background: linear-gradient(135deg, #FFF8E1, #FFECB3);
                border: 1px solid #FFD54F;
                color: #856404;
            }

            .alert-error {
                background: linear-gradient(135deg, #FFEBEE, #FFCDD2);
                border: 1px solid #EF9A9A;
                color: #C62828;
            }

            .alert-info {
                background: linear-gradient(135deg, #E3F2FD, #BBDEFB);
                border: 1px solid #90CAF9;
                color: #1565C0;
            }

            .required-mark {
                color: #E74C3C;
                margin-left: 2px;
            }

            .input-hint {
                font-size: 0.8rem;
                color: var(--text-light);
                margin-top: 0.35rem;
            }

            @media (max-width: 600px) {
                .pet-summary-card {
                    flex-direction: column;
                    text-align: center;
                }

                .form-actions {
                    flex-direction: column;
                }

                .btn-submit,
                .btn-cancel {
                    width: 100%;
                    justify-content: center;
                }
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header"
            style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
            <div>
                <h1 class="page-title">📝 Solicitud de Adopción</h1>
                <div class="breadcrumb">
                    <a href='<%= ResolveUrl("~/Adoptante/Mascotas.aspx") %>'
                        style="color: var(--primary-color); text-decoration: none;">Buscar Mascotas</a>
                    / <asp:Literal ID="litNombreBreadcrumb" runat="server">Mascota</asp:Literal>
                    / Solicitar Adopción
                </div>
            </div>
            <a href='<%= ResolveUrl("~/Adoptante/PerfilMascota.aspx?id=" + Request.QueryString["id"]) %>'
                class="btn-cancel">
                ← Volver al perfil
            </a>
        </div>
    </asp:Content>

    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
        <div class="solicitud-container">

            <!-- Alerta de perfil incompleto -->
            <asp:Panel ID="pnlPerfilIncompleto" runat="server" Visible="false" CssClass="alert alert-warning">
                <svg viewBox="0 0 24 24" fill="currentColor" width="24" height="24">
                    <path
                        d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z" />
                </svg>
                <div>
                    <strong>¡Completa tu perfil primero!</strong><br />
                    Necesitas tener tu cédula y teléfono registrados para solicitar una adopción.
                    <a href='<%= ResolveUrl("~/Adoptante/Perfil.aspx") %>'
                        style="color: inherit; font-weight: 600; margin-left: 0.5rem;">
                        Completar Perfil →
                    </a>
                </div>
            </asp:Panel>

            <!-- Alerta de solicitud existente -->
            <asp:Panel ID="pnlSolicitudExistente" runat="server" Visible="false" CssClass="alert alert-info">
                <svg viewBox="0 0 24 24" fill="currentColor" width="24" height="24">
                    <path
                        d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z" />
                </svg>
                <div>
                    <strong>Ya tienes una solicitud pendiente para esta mascota.</strong><br />
                    Puedes ver el estado de tu solicitud en "Mis Solicitudes".
                    <a href='<%= ResolveUrl("~/Adoptante/Solicitudes.aspx") %>'
                        style="color: inherit; font-weight: 600; margin-left: 0.5rem;">
                        Ver Mis Solicitudes →
                    </a>
                </div>
            </asp:Panel>

            <!-- Alerta de error -->
            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-error">
                <svg viewBox="0 0 24 24" fill="currentColor" width="24" height="24">
                    <path
                        d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z" />
                </svg>
                <asp:Literal ID="litError" runat="server"></asp:Literal>
            </asp:Panel>

            <!-- Resumen de la mascota -->
            <asp:Panel ID="pnlFormulario" runat="server">
                <div class="pet-summary-card">
                    <asp:Image ID="imgMascota" runat="server" CssClass="pet-summary-image" Visible="false" />
                    <asp:Panel ID="pnlEmoji" runat="server" CssClass="pet-summary-emoji">
                        <asp:Literal ID="litEmoji" runat="server">🐾</asp:Literal>
                    </asp:Panel>
                    <div class="pet-summary-info">
                        <h2>
                            <asp:Literal ID="litNombreMascota" runat="server">Mascota</asp:Literal>
                        </h2>
                        <div class="pet-summary-details">
                            <span>🐾 <asp:Literal ID="litEspecie" runat="server">Especie</asp:Literal></span>
                            <span>📍 <asp:Literal ID="litUbicacion" runat="server">Ubicación</asp:Literal></span>
                            <span>🎂 <asp:Literal ID="litEdad" runat="server">Edad</asp:Literal></span>
                        </div>
                    </div>
                </div>

                <!-- Sección 1: Motivación -->
                <div class="form-section">
                    <h3 class="form-section-title">
                        💝 ¿Por qué quieres adoptar?
                    </h3>

                    <div class="form-group">
                        <label for="txtMotivo">Cuéntanos tu motivación para adoptar<span
                                class="required-mark">*</span></label>
                        <asp:TextBox ID="txtMotivo" runat="server" CssClass="form-control" TextMode="MultiLine"
                            placeholder="Ej: Siempre he querido tener una mascota para darle un hogar lleno de amor...">
                        </asp:TextBox>
                        <div class="input-hint">Explica por qué deseas adoptar a esta mascota en particular.</div>
                        <asp:RequiredFieldValidator ID="rfvMotivo" runat="server" ControlToValidate="txtMotivo"
                            ErrorMessage="Este campo es requerido" ForeColor="Red" Display="Dynamic">
                        </asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label for="txtExperiencia">Experiencia con mascotas</label>
                        <asp:TextBox ID="txtExperiencia" runat="server" CssClass="form-control" TextMode="MultiLine"
                            placeholder="Ej: He tenido perros durante 10 años, actualmente tengo un gato...">
                        </asp:TextBox>
                        <div class="input-hint">Describe tu experiencia previa cuidando animales.</div>
                    </div>
                </div>

                <!-- Sección 2: Vivienda -->
                <div class="form-section">
                    <h3 class="form-section-title">
                        🏠 Tu vivienda
                    </h3>

                    <div class="form-group">
                        <label>Tipo de vivienda<span class="required-mark">*</span></label>
                        <div class="radio-group">
                            <label class="radio-item">
                                <asp:RadioButton ID="rbCasa" runat="server" GroupName="TipoVivienda" />
                                🏡 Casa
                            </label>
                            <label class="radio-item">
                                <asp:RadioButton ID="rbApartamento" runat="server" GroupName="TipoVivienda" />
                                🏢 Apartamento
                            </label>
                            <label class="radio-item">
                                <asp:RadioButton ID="rbFinca" runat="server" GroupName="TipoVivienda" />
                                🌳 Finca
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="checkbox-item">
                            <asp:CheckBox ID="chkPatioJardin" runat="server" />
                            🌿 ¿Tienes patio o jardín?
                        </label>
                    </div>
                </div>

                <!-- Sección 3: Situación familiar -->
                <div class="form-section">
                    <h3 class="form-section-title">
                        👨‍👩‍👧‍👦 Situación familiar
                    </h3>

                    <div class="form-grid">
                        <div class="form-group">
                            <label class="checkbox-item">
                                <asp:CheckBox ID="chkOtrasMascotas" runat="server" onclick="toggleOtrasMascotas()" />
                                🐕 ¿Tienes otras mascotas actualmente?
                            </label>
                            <asp:Panel ID="pnlOtrasMascotas" runat="server" CssClass="conditional-field"
                                Style="display: none;">
                                <label>Describe tus otras mascotas:</label>
                                <asp:TextBox ID="txtOtrasMascotas" runat="server" CssClass="form-control"
                                    placeholder="Ej: Un perro labrador de 3 años, muy sociable..."></asp:TextBox>
                            </asp:Panel>
                        </div>

                        <div class="form-group">
                            <label class="checkbox-item">
                                <asp:CheckBox ID="chkNinos" runat="server" onclick="toggleNinos()" />
                                👶 ¿Hay niños en casa?
                            </label>
                            <asp:Panel ID="pnlNinos" runat="server" CssClass="conditional-field" Style="display: none;">
                                <label>Edades de los niños:</label>
                                <asp:TextBox ID="txtEdadesNinos" runat="server" CssClass="form-control"
                                    placeholder="Ej: 5 años, 8 años"></asp:TextBox>
                            </asp:Panel>
                        </div>
                    </div>
                </div>

                <!-- Sección 4: Disponibilidad -->
                <div class="form-section">
                    <h3 class="form-section-title">
                        ⏰ Tiempo y recursos
                    </h3>

                    <div class="form-grid">
                        <div class="form-group">
                            <label>Horas al día que pasas en casa<span class="required-mark">*</span></label>
                            <asp:DropDownList ID="ddlHorasEnCasa" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">Selecciona una opción</asp:ListItem>
                                <asp:ListItem Value="1">Menos de 4 horas</asp:ListItem>
                                <asp:ListItem Value="4">4-6 horas</asp:ListItem>
                                <asp:ListItem Value="6">6-8 horas</asp:ListItem>
                                <asp:ListItem Value="8">8-10 horas</asp:ListItem>
                                <asp:ListItem Value="10">Más de 10 horas</asp:ListItem>
                                <asp:ListItem Value="24">Trabajo desde casa</asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvHoras" runat="server" ControlToValidate="ddlHorasEnCasa"
                                InitialValue="" ErrorMessage="Selecciona una opción" ForeColor="Red" Display="Dynamic">
                            </asp:RequiredFieldValidator>
                        </div>

                        <div class="form-group">
                            <label>Rango de ingresos mensuales</label>
                            <asp:DropDownList ID="ddlIngresos" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">Prefiero no decir</asp:ListItem>
                                <asp:ListItem Value="<500">Menos de $500</asp:ListItem>
                                <asp:ListItem Value="500-1000">$500 - $1,000</asp:ListItem>
                                <asp:ListItem Value="1000-2000">$1,000 - $2,000</asp:ListItem>
                                <asp:ListItem Value=">2000">Más de $2,000</asp:ListItem>
                            </asp:DropDownList>
                            <div class="input-hint">Esta información nos ayuda a verificar que puedas cubrir gastos
                                veterinarios.</div>
                        </div>
                    </div>
                </div>

                <!-- Sección 5: Compromiso -->
                <div class="form-section">
                    <h3 class="form-section-title">
                        ✅ Compromiso
                    </h3>

                    <div class="form-group">
                        <label class="checkbox-item">
                            <asp:CheckBox ID="chkAceptaVisita" runat="server" Checked="true" />
                            📋 Acepto recibir una visita de seguimiento después de la adopción
                        </label>
                        <div class="input-hint" style="margin-left: 28px;">
                            El refugio puede realizar visitas para verificar el bienestar de la mascota.
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="txtComentarios">Comentarios adicionales</label>
                        <asp:TextBox ID="txtComentarios" runat="server" CssClass="form-control" TextMode="MultiLine"
                            placeholder="Cualquier información adicional que quieras compartir con el refugio...">
                        </asp:TextBox>
                    </div>
                </div>

                <!-- Acciones -->
                <div class="form-actions">
                    <a href='<%= ResolveUrl("~/Adoptante/PerfilMascota.aspx?id=" + Request.QueryString["id"]) %>'
                        class="btn-cancel">
                        Cancelar
                    </a>
                    <asp:Button ID="btnEnviar" runat="server" CssClass="btn-submit" Text="💝 Enviar Solicitud"
                        OnClick="btnEnviar_Click" />
                </div>
            </asp:Panel>

        </div>

        <script type="text/javascript">
            function toggleOtrasMascotas() {
                var chk = document.getElementById('<%= chkOtrasMascotas.ClientID %>');
                var pnl = document.getElementById('<%= pnlOtrasMascotas.ClientID %>');
                pnl.style.display = chk.checked ? 'block' : 'none';
            }

            function toggleNinos() {
                var chk = document.getElementById('<%= chkNinos.ClientID %>');
                var pnl = document.getElementById('<%= pnlNinos.ClientID %>');
                pnl.style.display = chk.checked ? 'block' : 'none';
            }

            // Efecto visual para radio buttons
            document.addEventListener('DOMContentLoaded', function () {
                var radioItems = document.querySelectorAll('.radio-item');
                radioItems.forEach(function (item) {
                    var radio = item.querySelector('input[type="radio"]');
                    if (radio) {
                        radio.addEventListener('change', function () {
                            // Quitar clase selected de todos
                            document.querySelectorAll('.radio-item').forEach(function (r) {
                                r.classList.remove('selected');
                            });
                            // Agregar clase al seleccionado
                            if (this.checked) {
                                item.classList.add('selected');
                            }
                        });
                    }
                });
            });
        </script>
    </asp:Content>