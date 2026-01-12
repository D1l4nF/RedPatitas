<%@ Page Title="Inicio" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="RedPatitas.Adoptante.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Inicio | RedPatitas
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    </asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="dashboard-grid">
        
        <div class="welcome-banner">
            <div class="welcome-content">
                <h1>Hola, <asp:Literal ID="litNombreUsuario" runat="server">Usuario</asp:Literal>! 🐾</h1>
                <p>Miles de colitas están esperando conocerte. Hoy es un buen día para cambiar una vida para siempre.</p>
                <a href="Mascotas.aspx" class="btn-white">Explorar Mascotas</a>
            </div>
            
            <svg class="banner-decoration" width="220" height="220" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12,11.36C12.55,11.36 13,10.91 13,10.36V8.36C13,7.81 12.55,7.36 12,7.36C11.45,7.36 11,7.81 11,8.36V10.36C11,10.91 11.45,11.36 12,11.36M12,12.36C10.5,12.36 9.1,12.76 7.9,13.46C7.3,12.86 6.4,12.36 5.5,12.36C3.5,12.36 2,13.86 2,15.86C2,17.86 3.5,19.36 5.5,19.36C6.5,19.36 7.4,18.96 8.1,18.26C9,19.56 10.4,20.36 12,20.36C13.6,20.36 15,19.56 15.9,18.26C16.6,18.96 17.5,19.36 18.5,19.36C20.5,19.36 22,17.86 22,15.86C22,13.86 20.5,12.36 18.5,12.36C17.6,12.36 16.7,12.86 16.1,13.46C14.9,12.76 13.5,12.36 12,12.36M5.5,13.36C6.9,13.36 8,14.46 8,15.86C8,17.26 6.9,18.36 5.5,18.36C4.1,18.36 3,17.26 3,15.86C3,14.46 4.1,13.36 5.5,13.36M18.5,13.36C19.9,13.36 21,14.46 21,15.86C21,17.26 19.9,18.36 18.5,18.36C17.1,18.36 16,17.26 16,15.86C16,14.46 17.1,13.36 18.5,13.36M12,13.36C13.9,13.36 15.5,14.76 15.5,16.56C15.5,18.36 13.9,19.76 12,19.76C10.1,19.76 8.5,18.36 8.5,16.56C8.5,14.76 10.1,13.36 12,13.36M8,6.36C8.55,6.36 9,5.91 9,5.36V3.36C9,2.81 8.55,2.36 8,2.36C7.45,2.36 7,2.81 7,3.36V5.36C7,5.91 7.45,6.36 8,6.36M16,6.36C16.55,6.36 17,5.91 17,5.36V3.36C17,2.81 16.55,2.36 16,2.36C15.45,2.36 15,2.81 15,3.36V5.36C15,5.91 15.45,6.36 16,6.36Z" />
            </svg>
        </div>

        <div class="stats-grid">
            
            <div class="stat-card orange">
                <div class="stat-icon">
                    <svg viewBox="0 0 24 24" fill="none" width="32" height="32" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                </div>
                <div class="stat-info">
                    <span class="stat-number">0</span>
                    <span class="stat-label">Solicitudes Activas</span>
                </div>
            </div>

            <div class="stat-card green">
                <div class="stat-icon">
                    <svg viewBox="0 0 24 24" fill="none" width="32" height="32" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                </div>
                <div class="stat-info">
                    <span class="stat-number">0</span>
                    <span class="stat-label">Mascotas Favoritas</span>
                </div>
            </div>

            <div class="stat-card blue">
                <div class="stat-icon">
                    <svg viewBox="0 0 24 24" fill="none" width="32" height="32" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"></path><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
                </div>
                <div class="stat-info">
                    <span class="stat-number">?</span>
                    <span class="stat-label">Ayuda y Soporte</span>
                </div>
            </div>
        </div>

        <div>
            <h3 class="section-title">Nuevos Amigos Agregados</h3>
            
            <div class="empty-state">
                <div class="empty-state-icon">🐶</div>
                <h3 class="empty-state-title">Aún no hay recomendaciones</h3>
                <p class="empty-state-desc">Estamos buscando las mascotas perfectas para ti. Mientras tanto, puedes explorar todo nuestro catálogo.</p>
                <a href="Mascotas.aspx" class="empty-state-action">Buscar Mascotas</a>
            </div>
        </div>

    </div>
</asp:Content>