<%@ Page Title="" Language="C#" MasterPageFile="~/AdminRefugio/AdminRefugio.Master" AutoEventWireup="true"
    CodeBehind="Estadisticas.aspx.cs" Inherits="RedPatitas.AdminRefugio.Estadisticas" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Estadísticas y KPIs | RedPatitas
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            /* KPI Dashboard Styles */
            .kpi-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1.5rem;
            }

            .kpi-header h2 {
                font-size: 1.5rem;
                font-weight: 600;
                color: #1f2937;
            }

            .date-filter {
                display: flex;
                gap: 0.5rem;
                align-items: center;
                background: white;
                padding: 0.5rem 1rem;
                border-radius: 8px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            }

            .date-filter span {
                color: #6b7280;
                font-size: 0.875rem;
            }

            /* KPI Cards Grid */
            .kpi-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 1.5rem;
                margin-bottom: 2rem;
            }

            .kpi-card {
                background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
                padding: 1.5rem;
                border-radius: 16px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                border: 1px solid #e5e7eb;
                position: relative;
                overflow: hidden;
                transition: transform 0.2s, box-shadow 0.2s;
            }

            .kpi-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            }

            .kpi-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, var(--accent-color), var(--accent-light));
            }

            .kpi-card.teal {
                --accent-color: #0d9488;
                --accent-light: #14b8a6;
            }

            .kpi-card.blue {
                --accent-color: #3b82f6;
                --accent-light: #60a5fa;
            }

            .kpi-card.purple {
                --accent-color: #8b5cf6;
                --accent-light: #a78bfa;
            }

            .kpi-card.amber {
                --accent-color: #f59e0b;
                --accent-light: #fbbf24;
            }

            .kpi-card.emerald {
                --accent-color: #10b981;
                --accent-light: #34d399;
            }

            .kpi-card.rose {
                --accent-color: #f43f5e;
                --accent-light: #fb7185;
            }

            .kpi-icon {
                width: 48px;
                height: 48px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.25rem;
                color: white;
                margin-bottom: 1rem;
                background: linear-gradient(135deg, var(--accent-color), var(--accent-light));
            }

            .kpi-value {
                font-size: 2rem;
                font-weight: 700;
                color: #1f2937;
                line-height: 1.2;
            }

            .kpi-label {
                color: #6b7280;
                font-size: 0.875rem;
                font-weight: 500;
                margin-top: 0.25rem;
            }

            .kpi-trend {
                display: flex;
                align-items: center;
                gap: 0.25rem;
                font-size: 0.75rem;
                margin-top: 0.75rem;
                padding: 0.25rem 0.5rem;
                border-radius: 6px;
                width: fit-content;
            }

            .kpi-trend.up {
                background: #d1fae5;
                color: #059669;
            }

            .kpi-trend.down {
                background: #fee2e2;
                color: #dc2626;
            }

            .kpi-trend.neutral {
                background: #f3f4f6;
                color: #6b7280;
            }

            /* Charts Grid */
            .charts-grid {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 1.5rem;
                margin-bottom: 2rem;
            }

            .chart-card {
                background: white;
                border-radius: 16px;
                padding: 1.5rem;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                border: 1px solid #e5e7eb;
            }

            .chart-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1.5rem;
            }

            .chart-title {
                font-size: 1.1rem;
                font-weight: 600;
                color: #1f2937;
            }

            .chart-subtitle {
                color: #6b7280;
                font-size: 0.8rem;
            }

            /* Performance Indicators */
            .performance-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 1.5rem;
                margin-bottom: 2rem;
            }

            .performance-card {
                background: white;
                border-radius: 16px;
                padding: 1.5rem;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                border: 1px solid #e5e7eb;
            }

            .performance-header {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                margin-bottom: 1rem;
            }

            .performance-icon {
                width: 40px;
                height: 40px;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1rem;
            }

            .performance-title {
                font-weight: 600;
                color: #1f2937;
            }

            .progress-bar-container {
                height: 8px;
                background: #e5e7eb;
                border-radius: 4px;
                overflow: hidden;
                margin-top: 0.75rem;
            }

            .progress-bar {
                height: 100%;
                border-radius: 4px;
                transition: width 0.5s ease;
            }

            .progress-bar.teal {
                background: linear-gradient(90deg, #0d9488, #14b8a6);
            }

            .progress-bar.blue {
                background: linear-gradient(90deg, #3b82f6, #60a5fa);
            }

            .progress-bar.amber {
                background: linear-gradient(90deg, #f59e0b, #fbbf24);
            }

            .metric-value {
                font-size: 1.5rem;
                font-weight: 700;
                color: #1f2937;
            }

            .metric-subtitle {
                color: #6b7280;
                font-size: 0.8rem;
            }

            /* Activity Timeline */
            .activity-section {
                background: white;
                border-radius: 16px;
                padding: 1.5rem;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                border: 1px solid #e5e7eb;
            }

            .activity-item {
                display: flex;
                gap: 1rem;
                padding: 1rem 0;
                border-bottom: 1px solid #f3f4f6;
            }

            .activity-item:last-child {
                border-bottom: none;
            }

            .activity-dot {
                width: 10px;
                height: 10px;
                border-radius: 50%;
                margin-top: 5px;
            }

            .activity-dot.success {
                background: #10b981;
            }

            .activity-dot.warning {
                background: #f59e0b;
            }

            .activity-dot.info {
                background: #3b82f6;
            }

            .activity-content strong {
                color: #1f2937;
            }

            .activity-time {
                color: #9ca3af;
                font-size: 0.75rem;
                margin-top: 0.25rem;
            }

            @media (max-width: 1200px) {
                .kpi-grid {
                    grid-template-columns: repeat(2, 1fr);
                }

                .charts-grid {
                    grid-template-columns: 1fr;
                }

                .performance-grid {
                    grid-template-columns: 1fr;
                }
            }

            @media (max-width: 768px) {
                .kpi-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </asp:Content>
    <asp:Content ID="Content4" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">📊 Panel de Estadísticas y KPIs</h1>
            <div class="breadcrumb">Dashboard / Estadísticas / Monitoreo</div>
        </div>
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

        <!-- KPI Header -->
        <div class="kpi-header">
            <h2>Indicadores Clave de Desempeño</h2>
            <div class="date-filter">
                <i class="fas fa-calendar-alt" style="color: #6b7280;"></i>
                <span>Últimos 6 meses</span>
            </div>
        </div>

        <!-- Main KPI Cards -->
        <div class="kpi-grid">
            <!-- Total Mascotas -->
            <div class="kpi-card teal">
                <div class="kpi-icon"><i class="fas fa-paw"></i></div>
                <div class="kpi-value">
                    <asp:Literal ID="litTotalMascotas" runat="server">0</asp:Literal>
                </div>
                <div class="kpi-label">Total Mascotas Registradas</div>
                <div class="kpi-trend up"><i class="fas fa-arrow-up"></i>
                    <asp:Literal ID="litTrendMascotas" runat="server">+5</asp:Literal> este mes
                </div>
            </div>

            <!-- Adopciones Exitosas -->
            <div class="kpi-card emerald">
                <div class="kpi-icon"><i class="fas fa-heart"></i></div>
                <div class="kpi-value">
                    <asp:Literal ID="litTotalAdopciones" runat="server">0</asp:Literal>
                </div>
                <div class="kpi-label">Adopciones Exitosas</div>
                <div class="kpi-trend up"><i class="fas fa-arrow-up"></i>
                    <asp:Literal ID="litTrendAdopciones" runat="server">+12%</asp:Literal> vs mes anterior
                </div>
            </div>

            <!-- Solicitudes Pendientes -->
            <div class="kpi-card amber">
                <div class="kpi-icon"><i class="fas fa-clock"></i></div>
                <div class="kpi-value">
                    <asp:Literal ID="litSolicitudesPendientes" runat="server">0</asp:Literal>
                </div>
                <div class="kpi-label">Solicitudes Pendientes</div>
                <div class="kpi-trend neutral"><i class="fas fa-minus"></i> Por revisar</div>
            </div>

            <!-- Tasa de Éxito -->
            <div class="kpi-card purple">
                <div class="kpi-icon"><i class="fas fa-chart-line"></i></div>
                <div class="kpi-value">
                    <asp:Literal ID="litTasaExito" runat="server">0</asp:Literal>%
                </div>
                <div class="kpi-label">Tasa de Adopción</div>
                <div class="kpi-trend up"><i class="fas fa-arrow-up"></i> Excelente rendimiento</div>
            </div>
        </div>

        <!-- Charts Section -->
        <div class="charts-grid">
            <!-- Adoptions Over Time Chart -->
            <div class="chart-card">
                <div class="chart-header">
                    <div>
                        <div class="chart-title">Tendencia de Adopciones</div>
                        <div class="chart-subtitle">Evolución de adopciones en los últimos 6 meses</div>
                    </div>
                </div>
                <canvas id="chartAdopciones" height="120"></canvas>
            </div>

            <!-- Species Distribution Chart -->
            <div class="chart-card">
                <div class="chart-header">
                    <div>
                        <div class="chart-title">Distribución por Especie</div>
                        <div class="chart-subtitle">Mascotas disponibles actualmente</div>
                    </div>
                </div>
                <canvas id="chartEspecies" height="200"></canvas>
            </div>
        </div>

        <!-- Performance Metrics -->
        <h2 style="font-size: 1.25rem; font-weight: 600; color: #1f2937; margin-bottom: 1rem;">Métricas de Rendimiento
        </h2>
        <div class="performance-grid">
            <!-- Tiempo Promedio de Respuesta -->
            <div class="performance-card">
                <div class="performance-header">
                    <div class="performance-icon" style="background: #dbeafe; color: #3b82f6;">
                        <i class="fas fa-stopwatch"></i>
                    </div>
                    <div class="performance-title">Tiempo de Respuesta</div>
                </div>
                <div class="metric-value">
                    <asp:Literal ID="litTiempoRespuesta" runat="server">2.5</asp:Literal> días
                </div>
                <div class="metric-subtitle">Promedio para responder solicitudes</div>
                <div class="progress-bar-container">
                    <div class="progress-bar blue" style="width: 75%;"></div>
                </div>
            </div>

            <!-- Ocupación del Refugio -->
            <div class="performance-card">
                <div class="performance-header">
                    <div class="performance-icon" style="background: #ccfbf1; color: #0d9488;">
                        <i class="fas fa-home"></i>
                    </div>
                    <div class="performance-title">Capacidad del Refugio</div>
                </div>
                <div class="metric-value">
                    <asp:Literal ID="litCapacidad" runat="server">65</asp:Literal>%
                </div>
                <div class="metric-subtitle">Ocupación actual estimada</div>
                <div class="progress-bar-container">
                    <div class="progress-bar teal" id="progressCapacidad" runat="server" style="width: 65%;"></div>
                </div>
            </div>

            <!-- Meta de Adopciones -->
            <div class="performance-card">
                <div class="performance-header">
                    <div class="performance-icon" style="background: #fef3c7; color: #f59e0b;">
                        <i class="fas fa-bullseye"></i>
                    </div>
                    <div class="performance-title">Meta Mensual</div>
                </div>
                <div class="metric-value">
                    <asp:Literal ID="litMetaProgreso" runat="server">8</asp:Literal>/<asp:Literal ID="litMetaTotal"
                        runat="server">10</asp:Literal>
                </div>
                <div class="metric-subtitle">Adopciones este mes vs meta</div>
                <div class="progress-bar-container">
                    <div class="progress-bar amber" id="progressMeta" runat="server" style="width: 80%;"></div>
                </div>
            </div>
        </div>

        <!-- Additional Metrics Row -->
        <div class="charts-grid" style="grid-template-columns: 1fr 1fr;">
            <!-- Estado de Mascotas -->
            <div class="chart-card">
                <div class="chart-header">
                    <div class="chart-title">Estado de Mascotas</div>
                </div>
                <canvas id="chartEstados" height="150"></canvas>
            </div>

            <!-- Actividad Reciente -->
            <div class="activity-section">
                <div class="chart-header">
                    <div class="chart-title">Actividad Reciente</div>
                </div>
                <asp:Repeater ID="rptActividad" runat="server">
                    <ItemTemplate>
                        <div class="activity-item">
                            <div class='activity-dot <%# Eval("TipoClase") %>'></div>
                            <div class="activity-content">
                                <div><strong>
                                        <%# Eval("Titulo") %>
                                    </strong></div>
                                <div class="activity-time">
                                    <%# Eval("Tiempo") %>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <div id="noActivity" runat="server" visible="false"
                    style="text-align: center; padding: 2rem; color: #9ca3af;">
                    No hay actividad reciente
                </div>
            </div>
        </div>

        <!-- HiddenFields para pasar datos al JS -->
        <asp:HiddenField ID="hfLabelsAdopciones" runat="server" />
        <asp:HiddenField ID="hfDataAdopciones" runat="server" />
        <asp:HiddenField ID="hfLabelsEspecies" runat="server" />
        <asp:HiddenField ID="hfDataEspecies" runat="server" />
        <asp:HiddenField ID="hfLabelsEstados" runat="server" />
        <asp:HiddenField ID="hfDataEstados" runat="server" />

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Datos Adopciones
                const labelsAdopciones = document.getElementById('<%= hfLabelsAdopciones.ClientID %>').value.split(',').filter(x => x);
                const dataAdopciones = document.getElementById('<%= hfDataAdopciones.ClientID %>').value.split(',').map(Number).filter(x => !isNaN(x));

                // Datos Especies
                const labelsEspecies = document.getElementById('<%= hfLabelsEspecies.ClientID %>').value.split(',').filter(x => x);
                const dataEspecies = document.getElementById('<%= hfDataEspecies.ClientID %>').value.split(',').map(Number).filter(x => !isNaN(x));

                // Datos Estados
                const labelsEstados = document.getElementById('<%= hfLabelsEstados.ClientID %>').value.split(',').filter(x => x);
                const dataEstados = document.getElementById('<%= hfDataEstados.ClientID %>').value.split(',').map(Number).filter(x => !isNaN(x));

                // Chart Adopciones - Line Chart con área
                new Chart(document.getElementById('chartAdopciones'), {
                    type: 'line',
                    data: {
                        labels: labelsAdopciones.length ? labelsAdopciones : ['Sin datos'],
                        datasets: [{
                            label: 'Adopciones',
                            data: dataAdopciones.length ? dataAdopciones : [0],
                            borderColor: '#10b981',
                            backgroundColor: 'rgba(16, 185, 129, 0.1)',
                            borderWidth: 3,
                            fill: true,
                            tension: 0.4,
                            pointBackgroundColor: '#10b981',
                            pointBorderColor: '#fff',
                            pointBorderWidth: 2,
                            pointRadius: 5
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: { display: false }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: { stepSize: 1 },
                                grid: { color: '#f3f4f6' }
                            },
                            x: {
                                grid: { display: false }
                            }
                        }
                    }
                });

                // Chart Especies - Doughnut
                new Chart(document.getElementById('chartEspecies'), {
                    type: 'doughnut',
                    data: {
                        labels: labelsEspecies.length ? labelsEspecies : ['Sin datos'],
                        datasets: [{
                            data: dataEspecies.length ? dataEspecies : [1],
                            backgroundColor: ['#0d9488', '#3b82f6', '#f59e0b', '#8b5cf6', '#f43f5e', '#6b7280'],
                            borderWidth: 0,
                            hoverOffset: 10
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: true,
                        cutout: '65%',
                        plugins: {
                            legend: {
                                position: 'bottom',
                                labels: {
                                    padding: 15,
                                    usePointStyle: true
                                }
                            }
                        }
                    }
                });

                // Chart Estados - Horizontal Bar
                new Chart(document.getElementById('chartEstados'), {
                    type: 'bar',
                    data: {
                        labels: labelsEstados.length ? labelsEstados : ['Disponible', 'En Proceso', 'Adoptado'],
                        datasets: [{
                            label: 'Mascotas',
                            data: dataEstados.length ? dataEstados : [0, 0, 0],
                            backgroundColor: ['#10b981', '#f59e0b', '#3b82f6'],
                            borderRadius: 8,
                            barThickness: 30
                        }]
                    },
                    options: {
                        indexAxis: 'y',
                        responsive: true,
                        plugins: {
                            legend: { display: false }
                        },
                        scales: {
                            x: {
                                beginAtZero: true,
                                grid: { color: '#f3f4f6' }
                            },
                            y: {
                                grid: { display: false }
                            }
                        }
                    }
                });
            });
        </script>
    </asp:Content>