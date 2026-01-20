<%@ Page Title="Inicio" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="RedPatitas.Adoptante.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Inicio | RedPatitas
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <link href='<%= ResolveUrl("~/Style/dashboard.css") %>' rel="stylesheet" type="text/css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
    </asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

    <div class="content-wrapper">
        <div class="page-header-internal">
            <h1 class="page-title">Bienvenido/a, <asp:Literal ID="litNombreUsuario" runat="server">Usuario</asp:Literal></h1>
            <div class="breadcrumb">Encuentra a tu compañero ideal</div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon green">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="24" height="24">
                        <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                    </svg>
                </div>
                <div class="stat-info">
                    <h3>0</h3> <p>Favoritos</p>
                </div>
            </div>
            <div class="stat-card orange">
                <div class="stat-icon orange">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="24" height="24">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                        <polyline points="14 2 14 8 20 8"></polyline>
                        <line x1="16" y1="13" x2="8" y2="13"></line>
                        <line x1="16" y1="17" x2="8" y2="17"></line>
                        <polyline points="10 9 9 9 8 9"></polyline>
                    </svg>
                </div>
                <div class="stat-info">
                    <h3>0</h3>
                    <p>Solicitudes</p>
                </div>
            </div>
        </div>

        <div class="recent-section">
            <div class="section-header">
                <h2 class="section-title">Recomendados para ti</h2>
                <a href="Mascotas.aspx" class="btn-link">Ver más</a>
            </div>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Mascota</th>
                            <th>Raza</th>
                            <th>Ubicación</th>
                            <th>Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <div class="pet-cell">
                                    <div class="pet-img" style="background-color: #eee;"></div>
                                    <span>Toby</span>
                                </div>
                            </td>
                            <td>Beagle</td>
                            <td>Refugio Central</td>
                            <td><a href="#" class="btn-link">Ver Perfil</a></td>
                        </tr>
                        <tr>
                            <td>
                                <div class="pet-cell">
                                    <div class="pet-img" style="background-color: #eee;"></div>
                                    <span>Nala</span>
                                </div>
                            </td>
                            <td>Gato Común</td>
                            <td>Refugio Esperanza</td>
                            <td><a href="#" class="btn-link">Ver Perfil</a></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>