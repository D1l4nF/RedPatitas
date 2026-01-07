<%@ Page Title="" Language="C#" MasterPageFile="~/Public/Public.Master" AutoEventWireup="true" CodeBehind="404.aspx.cs"
    Inherits="RedPatitas.Public._404" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Página No Encontrada | RedPatitas
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
        <link rel="stylesheet" href="~/Style/public-pages.css" />
    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
        <div class="error-page">
            <div class="error-content">
                <div class="error-illustration">🐾</div>
                <div class="error-code">404</div>
                <h1 class="error-title">¡Ups! Página no encontrada</h1>
                <p class="error-message">
                    Parece que esta mascota se escapó... La página que buscas no existe o fue movida a otro lugar.
                </p>
                <div class="error-actions">
                    <a href="~/Public/Home.aspx" runat="server" class="btn-home">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20"
                            height="20">
                            <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                            <polyline points="9 22 9 12 15 12 15 22"></polyline>
                        </svg>
                        Ir al Inicio
                    </a>
                    <a href="javascript:history.back()" class="btn-back">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20"
                            height="20">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                        </svg>
                        Volver Atrás
                    </a>
                </div>

                <div class="suggestions">
                    <h3>¿Buscabas algo de esto?</h3>
                    <div class="suggestion-links">
                        <a href="~/Public/Adopta.aspx" runat="server">Adoptar mascota</a>
                        <a href="~/Public/Reportar.aspx" runat="server">Reportar mascota</a>
                        <a href="~/Public/FAQ.aspx" runat="server">Ayuda / FAQ</a>
                        <a href="~/Public/Contacto.aspx" runat="server">Contacto</a>
                    </div>
                </div>
            </div>
        </div>
    </asp:Content>