<%@ Page Language="C#" AutoEventWireup="true" %>

    <!DOCTYPE html>
    <html lang="es">

    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Página No Encontrada | RedPatitas</title>
        <link rel="stylesheet" href="~/Style/landing.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" href="~/Style/public-pages.css">
    </head>

    <body class="page-404">
        <form id="form1" runat="server">
            <!-- Header -->
            <header class="header" id="header">
                <div class="header-container">
                    <a href="~/Public/Home.aspx" runat="server" class="logo">
                        <svg viewBox="0 0 24 24" fill="currentColor" width="32" height="32">
                            <path
                                d="M12,11.36C12.55,11.36 13,10.91 13,10.36V8.36C13,7.81 12.55,7.36 12,7.36C11.45,7.36 11,7.81 11,8.36V10.36C11,10.91 11.45,11.36 12,11.36M12,12.36C10.5,12.36 9.1,12.76 7.9,13.46C7.3,12.86 6.4,12.36 5.5,12.36C3.5,12.36 2,13.86 2,15.86C2,17.86 3.5,19.36 5.5,19.36C6.5,19.36 7.4,18.96 8.1,18.26C9,19.56 10.4,20.36 12,20.36C13.6,20.36 15,19.56 15.9,18.26C16.6,18.96 17.5,19.36 18.5,19.36C20.5,19.36 22,17.86 22,15.86C22,13.86 20.5,12.36 18.5,12.36C17.6,12.36 16.7,12.86 16.1,13.46C14.9,12.76 13.5,12.36 12,12.36Z" />
                        </svg>
                        RedPatitas
                    </a>
                    <nav class="nav" id="nav">
                        <ul class="nav-links">
                            <li><a href="~/Public/Home.aspx" runat="server" class="nav-link">Inicio</a></li>
                            <li><a href="~/Public/Adopta.aspx" runat="server" class="nav-link">Adopta</a></li>
                            <li><a href="~/Public/Reportar.aspx" runat="server" class="nav-link">Reportar</a></li>
                            <li><a href="~/Public/FAQ.aspx" runat="server" class="nav-link">Ayuda</a></li>
                        </ul>
                        <a href="~/Login/Login.aspx" runat="server" class="btn-login">Ingresar</a>
                    </nav>
                    <div class="menu-toggle" id="menuToggle">
                        <span></span><span></span><span></span>
                    </div>
                </div>
            </header>

            <!-- Error Content -->
            <main class="error-page">
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
            </main>

            <!-- Footer -->
            <footer class="footer" style="padding: 1.5rem 2rem;">
                <div class="footer-container">
                    <div class="footer-bottom" style="border-top: none; padding-top: 0;">
                        <p>&copy; 2025 RedPatitas. Todos los derechos reservados.</p>
                    </div>
                </div>
            </footer>
        </form>

        <script>
            document.getElementById('menuToggle').addEventListener('click', () => {
                document.getElementById('nav').classList.toggle('active');
                document.getElementById('menuToggle').classList.toggle('active');
            });
        </script>
    </body>

    </html>