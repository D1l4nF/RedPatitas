<%@ Page Title="Mis Reportes" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true"
    CodeBehind="MisReportes.aspx.cs" Inherits="RedPatitas.Adoptante.MisReportes" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Mis Reportes | RedPatitas
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link href='<%= ResolveUrl("~/Style/dashboard.css") %>' rel="stylesheet" type="text/css" />
        <style>
            .reportes-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
                gap: 1.5rem;
                margin-top: 1.5rem;
            }

            .reporte-card {
                background: var(--bg-card, #fff);
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                border-left: 4px solid #ccc;
                transition: transform 0.2s, box-shadow 0.2s;
            }

            .reporte-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
            }

            .reporte-card.perdida {
                border-left-color: #e74c3c;
            }

            .reporte-card.encontrada {
                border-left-color: #27ae60;
            }

            .reporte-foto {
                width: 100%;
                height: 170px;
                background: #f0f0f0;
                overflow: hidden;
                flex-shrink: 0;
            }

            .reporte-foto img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                display: block;
            }

            .reporte-foto-placeholder {
                display: flex;
                align-items: center;
                justify-content: center;
                height: 100%;
                font-size: 3.5rem;
                color: #ccc;
            }

            .reporte-body {
                padding: 1.25rem 1.5rem 1.5rem;
            }

            .reporte-badge {
                display: inline-flex;
                align-items: center;
                gap: 4px;
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 0.78rem;
                font-weight: 600;
            }

            .badge-perdida {
                background: #fde8e8;
                color: #c0392b;
            }

            .badge-encontrada {
                background: #e8f8ef;
                color: #1e8449;
            }

            .badge-estado {
                background: #e8f0fe;
                color: #1a73e8;
            }

            .reporte-title {
                font-size: 1.1rem;
                font-weight: 600;
                margin: 0.75rem 0 0.5rem;
                color: #1a1a2e;
            }

            .reporte-meta {
                font-size: 0.85rem;
                color: #666;
                display: flex;
                flex-direction: column;
                gap: 4px;
            }

            .reporte-actions {
                display: flex;
                gap: 0.5rem;
                margin-top: 1rem;
                flex-wrap: wrap;
            }

            .btn-sm {
                padding: 6px 14px;
                border-radius: 8px;
                font-size: 0.82rem;
                text-decoration: none;
                cursor: pointer;
                border: none;
                font-weight: 500;
                display: inline-block;
            }

            .btn-detail {
                background: #1a73e8;
                color: #fff;
            }

            .btn-detail:hover {
                background: #1557b0;
                color: #fff;
            }

            .btn-close-report {
                background: #e74c3c;
                color: #fff;
            }

            .btn-reunido {
                background: #27ae60;
                color: #fff;
            }

            .empty-state {
                text-align: center;
                padding: 4rem 2rem;
            }

            .empty-state h3 {
                font-size: 1.3rem;
                color: #333;
                margin-bottom: 0.5rem;
            }

            .filters-bar {
                display: flex;
                gap: 0.75rem;
                flex-wrap: wrap;
                margin-bottom: 1rem;
                align-items: center;
            }

            .filter-btn {
                padding: 8px 18px;
                border-radius: 20px;
                border: 2px solid #ddd;
                background: #fff;
                cursor: pointer;
                font-size: 0.85rem;
                font-weight: 500;
                transition: all 0.2s;
            }

            .filter-btn.active {
                border-color: #1a73e8;
                background: #1a73e8;
                color: #fff;
            }

            .filter-btn:hover:not(.active) {
                border-color: #1a73e8;
                color: #1a73e8;
            }

            .top-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 1rem;
                margin-bottom: 0.5rem;
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">🐾 Mis Reportes</h1>
            <div class="breadcrumb">Gestiona tus reportes de mascotas perdidas y encontradas</div>
        </div>
    </asp:Content>

    <asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

        <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="form-group">
            <asp:Label ID="lblMensaje" runat="server"></asp:Label>
        </asp:Panel>

        <div class="top-bar">
            <div class="filters-bar">
                <button type="button" class="filter-btn active" onclick="filtrarReportes('todos', this)">Todos</button>
                <button type="button" class="filter-btn" onclick="filtrarReportes('Perdida', this)">😿 Perdidos</button>
                <button type="button" class="filter-btn" onclick="filtrarReportes('Encontrada', this)">🐾
                    Encontrados</button>
                <button type="button" class="filter-btn" onclick="filtrarReportes('activos', this)">🔍 Activos</button>
                <button type="button" class="filter-btn" onclick="filtrarReportes('cerrados', this)">✅ Cerrados</button>
            </div>
            <a href="ReportarMascota.aspx" class="btn-primary"
                style="text-decoration:none; padding:10px 20px; border-radius:10px; display:inline-flex; align-items:center; gap:6px;">
                ➕ Nuevo Reporte
            </a>
        </div>

        <%-- Grid de reportes --%>
            <div class="reportes-grid" id="reportesGrid">
                <asp:Repeater ID="rptReportes" runat="server" OnItemCommand="rptReportes_ItemCommand">
                    <ItemTemplate>
                        <div class='reporte-card <%# (Eval("rep_TipoReporte") ?? "").ToString().ToLower() %>'
                            data-tipo='<%# Eval("rep_TipoReporte") %>' data-estado='<%# Eval("rep_Estado") %>'>

                            <%-- Foto principal --%>
                                <div class="reporte-foto">
                                    <%# ObtenerHtmlFoto(Eval("FotoPrincipal")) %>
                                </div>

                                <div class="reporte-body">
                                    <%-- Badges tipo + estado --%>
                                        <div style="display:flex; gap:8px; flex-wrap:wrap;">
                                            <span
                                                class='reporte-badge <%# ((Eval("rep_TipoReporte") ?? "").ToString() == "Perdida") ? "badge-perdida" : "badge-encontrada" %>'>
                                                <%# ((Eval("rep_TipoReporte") ?? "" ).ToString()=="Perdida" )
                                                    ? "😿 PERDIDA" : "🐾 ENCONTRADA" %>
                                            </span>
                                            <span class="reporte-badge badge-estado">
                                                <%# Eval("rep_Estado") %>
                                            </span>
                                        </div>

                                        <%-- Nombre --%>
                                            <div class="reporte-title">
                                                <%# string.IsNullOrEmpty((Eval("rep_NombreMascota") ?? "" ).ToString())
                                                    ? "Sin nombre" : Eval("rep_NombreMascota").ToString() %>
                                            </div>

                                            <%-- Meta info --%>
                                                <div class="reporte-meta">
                                                    <span>🐕 <%# Eval("EspecieNombre") %>
                                                            <%# !string.IsNullOrEmpty((Eval("rep_Color") ?? ""
                                                                ).ToString()) ? " · " + Eval("rep_Color") : "" %></span>
                                                    <span>📍 <%# string.IsNullOrEmpty((Eval("rep_Ciudad") ?? ""
                                                            ).ToString()) ? "Ubicación no especificada" :
                                                            Eval("rep_Ciudad").ToString() %></span>
                                                    <span>📅 <%# Eval("rep_FechaReporte") !=null ?
                                                            ((DateTime)Eval("rep_FechaReporte")).ToString("dd/MM/yyyy")
                                                            : "" %></span>
                                                    <span>👁 <asp:Literal ID="litAvist" runat="server"
                                                            Text='<%# Eval("TotalAvistamientos") %>'></asp:Literal>
                                                        avistamiento(s)</span>
                                                </div>

                                                <%-- Acciones --%>
                                                    <div class="reporte-actions">
                                                        <a href='<%# ResolveUrl("~/Adoptante/DetalleReporte.aspx?id=" + Eval("rep_IdReporte")) %>'
                                                            class="btn-sm btn-detail">📋 Ver Detalle</a>

                                                        <asp:LinkButton ID="btnMarcarReunido" runat="server"
                                                            CommandName="MarcarReunido"
                                                            CommandArgument='<%# Eval("rep_IdReporte") %>'
                                                            CssClass="btn-sm btn-reunido"
                                                            Visible='<%# ((Eval("rep_Estado") ?? "").ToString() != "Reunido") && ((Eval("rep_Estado") ?? "").ToString() != "SinResolver") %>'>
                                                            ✅ ¡Reunido!
                                                        </asp:LinkButton>

                                                        <asp:LinkButton ID="btnCerrar" runat="server"
                                                            CommandName="CerrarSinResolver"
                                                            CommandArgument='<%# Eval("rep_IdReporte") %>'
                                                            CssClass="btn-sm btn-close-report"
                                                            Visible='<%# ((Eval("rep_Estado") ?? "").ToString() != "Reunido") && ((Eval("rep_Estado") ?? "").ToString() != "SinResolver") %>'>
                                                            ❌ Cerrar
                                                        </asp:LinkButton>
                                                    </div>
                                </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
                <div class="empty-state">
                    <div style="font-size:4rem; margin-bottom:1rem;">🐾</div>
                    <h3>Aún no tienes reportes</h3>
                    <p style="color:#666; margin-bottom:1.5rem;">Cuando reportes una mascota perdida o encontrada,
                        aparecerá aquí.</p>
                    <a href="ReportarMascota.aspx" class="btn-primary"
                        style="text-decoration:none; padding:12px 24px; border-radius:10px; display:inline-block;">
                        ➕ Hacer mi primer reporte
                    </a>
                </div>
            </asp:Panel>

            <script type="text/javascript">
                function filtrarReportes(filtro, btn) {
                    document.querySelectorAll('.filter-btn').forEach(function (b) { b.classList.remove('active'); });
                    btn.classList.add('active');

                    var tarjetas = document.querySelectorAll('.reporte-card');
                    tarjetas.forEach(function (card) {
                        var tipo = card.getAttribute('data-tipo');
                        var estado = card.getAttribute('data-estado');
                        var cerrados = ['Reunido', 'SinResolver'];
                        var mostrar = false;

                        if (filtro === 'todos') mostrar = true;
                        else if (filtro === 'Perdida' && tipo === 'Perdida') mostrar = true;
                        else if (filtro === 'Encontrada' && tipo === 'Encontrada') mostrar = true;
                        else if (filtro === 'activos' && !cerrados.includes(estado)) mostrar = true;
                        else if (filtro === 'cerrados' && cerrados.includes(estado)) mostrar = true;

                        card.style.display = mostrar ? '' : 'none';
                    });
                }

                document.addEventListener('DOMContentLoaded', function () {

                    // Confirmación SweetAlert para botón "¡Reunido!"
                    document.querySelectorAll('[id*="btnMarcarReunido"]').forEach(function (btn) {
                        btn.addEventListener('click', function (e) {
                            e.preventDefault();
                            e.stopPropagation();
                            var btnRef = this;
                            Swal.fire({
                                title: '¿Mascota reunida?',
                                text: '¿Confirmas que tu mascota ya fue reunida con su familia?',
                                icon: 'question',
                                showCancelButton: true,
                                confirmButtonColor: '#27ae60',
                                cancelButtonColor: '#aaa',
                                confirmButtonText: '✅ Sí, fue reunida',
                                cancelButtonText: 'Cancelar'
                            }).then(function (result) {
                                if (result.isConfirmed) {
                                    __doPostBack(btnRef.name, '');
                                }
                            });
                        });
                    });

                    // Confirmación SweetAlert para botón "Cerrar"
                    document.querySelectorAll('[id*="btnCerrar"]').forEach(function (btn) {
                        btn.addEventListener('click', function (e) {
                            e.preventDefault();
                            e.stopPropagation();
                            var btnRef = this;
                            Swal.fire({
                                title: '¿Cerrar reporte?',
                                text: 'El reporte quedará marcado como "Sin Resolver".',
                                icon: 'warning',
                                showCancelButton: true,
                                confirmButtonColor: '#e74c3c',
                                cancelButtonColor: '#aaa',
                                confirmButtonText: 'Sí, cerrar',
                                cancelButtonText: 'Cancelar'
                            }).then(function (result) {
                                if (result.isConfirmed) {
                                    __doPostBack(btnRef.name, '');
                                }
                            });
                        });
                    });
                });
            </script>
    </asp:Content>