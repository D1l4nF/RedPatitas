<%@ Page Title="Mis Notificaciones" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true" CodeBehind="Notificaciones.aspx.cs" Inherits="RedPatitas.Adoptante.Notificaciones" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* ------------- NOTIFICATIONS REDESIGN ------------- */
        .notif-summary-bar { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1rem; margin-bottom: 2rem; }
        .notif-stat-card { background: white; padding: 1.5rem; border-radius: var(--border-radius); text-align: center; box-shadow: 0 4px 6px rgba(0,0,0,0.02); border: 1px solid #f1f5f9; }
        .notif-stat-value { font-size: 2rem; font-weight: 700; color: var(--primary-color); line-height: 1; margin-bottom: 0.5rem; }
        .notif-stat-label { font-size: 0.85rem; color: #64748b; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }

        .notif-tabs { display: flex; gap: 1rem; margin-bottom: 1.5rem; border-bottom: 2px solid #f1f5f9; padding-bottom: 1px; }
        .notif-tab { background: transparent; border: none; padding: 0.75rem 1.25rem; font-size: 0.95rem; font-weight: 600; color: #64748b; cursor: pointer; position: relative; transition: all 0.2s ease; }
        .notif-tab:hover { color: var(--primary-color); }
        .notif-tab.active { color: var(--primary-color); }
        .notif-tab.active::after { content: ''; position: absolute; bottom: -3px; left: 0; width: 100%; height: 3px; background: var(--primary-color); border-radius: 3px 3px 0 0; }

        .notif-card { padding: 1.25rem; border-radius: var(--border-radius); margin-bottom: 1rem; border-left: 4px solid #e2e8f0; background: white; box-shadow: 0 2px 8px rgba(0,0,0,0.04); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); position: relative; animation: fadeInSlideUp 0.4s ease forwards; opacity: 0; }
        @keyframes fadeInSlideUp { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        .notif-card:hover { box-shadow: 0 8px 16px rgba(0,0,0,0.08); transform: translateY(-2px); }
        .notif-unread { border-left-color: var(--primary-color); background-color: #fffaf6; }

        .notif-icon { font-size: 1.5rem; color: #94a3b8; background: #f1f5f9; width: 48px; height: 48px; border-radius: 50%; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }

        /* Color codes by type */
        .type-aprobada .notif-icon { color: #10b981; background: #d1fae5; }
        .type-aprobada.notif-unread { border-left-color: #10b981; }

        .type-rechazada .notif-icon { color: #ef4444; background: #fee2e2; }
        .type-rechazada.notif-unread { border-left-color: #ef4444; }

        .type-seguimiento .notif-icon { color: #f59e0b; background: #fef3c7; }
        .type-seguimiento.notif-unread { border-left-color: #f59e0b; }

        .type-sistema .notif-icon { color: #3b82f6; background: #dbeafe; }
        .type-sistema.notif-unread { border-left-color: #3b82f6; }

        .notif-title { font-weight: 700; color: var(--secondary-color); font-size: 1.05rem; }
        .notif-time { font-size: 0.85rem; color: #94a3b8; font-weight: 500; display: flex; align-items: center; gap: 0.3rem; }

        .notif-actions-row { display: flex; gap: 0.75rem; margin-top: 1rem; }
        .btn-notif-action { background: transparent; border: 1px solid #e2e8f0; color: #64748b; padding: 0.5rem 1rem; border-radius: 6px; font-weight: 600; font-size: 0.85rem; cursor: pointer; transition: all 0.2s; text-decoration: none; display: inline-flex; align-items: center; gap: 0.5rem; }
        .btn-notif-action:hover { background: #f8fafc; color: var(--secondary-color); text-decoration: none; }
        .btn-notif-action.btn-primary { background: #e0f2fe; color: #0284c7; border-color: #bae6fd; }
        .btn-notif-action.btn-primary:hover { background: #0284c7; color: white; }

        .empty-notif-state { text-align: center; padding: 4rem 2rem; background: white; border-radius: var(--border-radius); border: 2px dashed #e2e8f0; }
        .empty-notif-icon { font-size: 4rem; color: #cbd5e1; margin-bottom: 1.5rem; }
        .empty-notif-title { font-size: 1.25rem; font-weight: 700; color: var(--secondary-color); margin-bottom: 0.5rem; }
        .empty-notif-text { color: #64748b; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="header-section">
        <div>
            <h2>Mis Notificaciones</h2>
            <p>Revisa las últimas novedades sobre tus solicitudes y seguimientos</p>
        </div>
        <div class="header-actions">
            <asp:LinkButton ID="btnMarcarLeidas" runat="server" CssClass="btn-primary-outline" OnClick="btnMarcarLeidas_Click">
                Marcar todas como leídas
            </asp:LinkButton>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Summary Cards -->
    <div class="notif-summary-bar">
        <div class="notif-stat-card">
            <div class="notif-stat-value" id="count-all">0</div>
            <div class="notif-stat-label">Total Recibidas</div>
        </div>
        <div class="notif-stat-card">
            <div class="notif-stat-value" id="count-unread" style="color: #ef4444;">0</div>
            <div class="notif-stat-label">Sin Leer</div>
        </div>
    </div>

    <div class="recent-section" style="padding: 1.5rem; background: white; border-radius: var(--border-radius); box-shadow: 0 4px 6px rgba(0,0,0,0.02); min-height: 500px;">
        
        <!-- Tabs de filtrado -->
        <div class="notif-tabs" id="notif-tabs-container">
            <button type="button" class="notif-tab active" onclick="filterNotifs('all', this)">Todas</button>
            <button type="button" class="notif-tab" onclick="filterNotifs('unread', this)">No Leídas</button>
            <button type="button" class="notif-tab" onclick="filterNotifs('adopcion', this)">Adopciones</button>
            <button type="button" class="notif-tab" onclick="filterNotifs('seguimiento', this)">Seguimientos</button>
        </div>

        <div id="notifs-container">
            <asp:Repeater ID="rptNotificaciones" runat="server" OnItemCommand="rptNotificaciones_ItemCommand">
                <ItemTemplate>
                    <div class='notif-card <%# Convert.ToBoolean(Eval("Leida")) ? "" : "notif-unread" %> <%# GetNotifClass(Eval("Icono") as string, Eval("Titulo") as string) %>' 
                         data-leida='<%# Eval("Leida").ToString().ToLower() %>'
                         data-tipo='<%# GetNotifClass(Eval("Icono") as string, Eval("Titulo") as string) %>'>
                        
                        <div style="display: flex; align-items: flex-start; gap: 15px;">
                            <div class="notif-icon">
                                <i class='<%# Eval("Icono") %>'></i>
                            </div>
                            <div style="flex-grow: 1;">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 5px;">
                                    <span class="notif-title"><%# Eval("Titulo") %></span>
                                    <span class="notif-time"><i class="far fa-clock"></i> <%# Eval("TiempoRelativo") %></span>
                                </div>
                                <p style="margin-bottom: 10px; color: #555; line-height: 1.5;"><%# Eval("Mensaje") %></p>
                                
                                <div class="notif-actions-row">
                                    <asp:LinkButton ID="btnAccion" runat="server" CssClass="btn-notif-action btn-primary"
                                        CommandName="IrAccion" CommandArgument='<%# Eval("IdNotificacion") + "|" + Eval("UrlAccion") %>'
                                        Visible='<%# !string.IsNullOrEmpty(Convert.ToString(Eval("UrlAccion"))) %>'>
                                        <i class="fas fa-external-link-alt"></i> Ver Detalles
                                    </asp:LinkButton>
                                    
                                    <asp:LinkButton ID="btnMarcarLeida" runat="server" CssClass="btn-notif-action"
                                        CommandName="MarcarLeida" CommandArgument='<%# Eval("IdNotificacion") %>'
                                        Visible='<%# !Convert.ToBoolean(Eval("Leida")) %>' ToolTip="Marcar como leída">
                                        <i class="fas fa-check-double"></i> Leída
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </div>
                        <%# Convert.ToBoolean(Eval("Leida")) ? "" : "<div style='position:absolute; top: 1.5rem; right: 1.5rem; width: 8px; height: 8px; border-radius: 50%; background: #ef4444;'></div>" %>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    <div id="noNotifsServer" runat="server" class="empty-notif-state" visible='<%# ((Repeater)Container.Parent).Items.Count == 0 %>'>
                        <div class="empty-notif-icon">
                            <i class="fas fa-bell-slash"></i>
                        </div>
                        <h3 class="empty-notif-title">Todo está al día</h3>
                        <p class="empty-notif-text">No tienes notificaciones en este momento.</p>
                    </div>
                </FooterTemplate>
            </asp:Repeater>
            
            <!-- Empty state for client-side filtering -->
            <div id="empty-state-js" class="empty-notif-state" style="display: none;">
                <div class="empty-notif-icon">
                    <i class="fas fa-search"></i>
                </div>
                <h3 class="empty-notif-title">Sin resultados</h3>
                <p class="empty-notif-text">No hay notificaciones que coincidan con este filtro.</p>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            // Count logic
            const cards = document.querySelectorAll('.notif-card');
            const unreadCount = document.querySelectorAll('.notif-card[data-leida="false"]').length;
            
            document.getElementById('count-all').textContent = cards.length;
            document.getElementById('count-unread').textContent = unreadCount;

            // Apply staggered animations
            cards.forEach((card, index) => {
                card.style.animationDelay = (index * 0.05) + 's';
            });
            
            // Si no hay cards en absoluto desde el servidor, escondemos los tabs
            if(cards.length === 0) {
                document.getElementById('notif-tabs-container').style.display = 'none';
            }
        });

        function filterNotifs(filtro, btn) {
            // Update active tab UI
            document.querySelectorAll('.notif-tab').forEach(t => t.classList.remove('active'));
            btn.classList.add('active');
            
            const cards = document.querySelectorAll('.notif-card');
            let visibleCount = 0;

            cards.forEach(card => {
                let show = false;
                const esLeida = card.getAttribute('data-leida') === 'true';
                const tipo = card.getAttribute('data-tipo');

                if (filtro === 'all') {
                    show = true;
                } else if (filtro === 'unread') {
                    show = !esLeida;
                } else if (filtro === 'adopcion') {
                    show = tipo.includes('aprobada') || tipo.includes('rechazada');
                } else if (filtro === 'seguimiento') {
                    show = tipo.includes('seguimiento');
                }

                card.style.display = show ? 'block' : 'none';
                if(show) visibleCount++;
            });

            // Show/hide empty state 
            const emptyJs = document.getElementById('empty-state-js');
            const serverEmpty = document.getElementById('<%= ((Repeater)rptNotificaciones).ClientID %>_noNotifsServer'); // Fallback if needed
            
            if (cards.length > 0) {
                if (visibleCount === 0) {
                    emptyJs.style.display = 'block';
                } else {
                    emptyJs.style.display = 'none';
                }
            }
        }
    </script>
</asp:Content>
