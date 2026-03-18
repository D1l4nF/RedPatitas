<%@ Page Title="Mi Certificado" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true" CodeBehind="MiCertificado.aspx.cs" Inherits="RedPatitas.Adoptante.MiCertificado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Import Google Fonts for the Certificate -->
    <link href="https://fonts.googleapis.com/css2?family=Great+Vibes&family=Playfair+Display:ital,wght@0,700;1,400&display=swap" rel="stylesheet">
    
    <!-- Scripts para PDF -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    
    <!-- SweetAlert2 para mensajes -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="page-header">
        <h2 class="page-title">Certificado de Adopción</h2>
        <div class="breadcrumb">Panel / Mis Solicitudes / Mi Certificado</div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Contenedor principal que se puede ocultar si hay error -->
    <asp:Panel ID="pnlCertificadoExito" runat="server">
        <div class="certificate-actions">
            <!-- Botones de Acción (PDF / Imprimir) -->
            <button type="button" class="btn-download-pdf" onclick="descargarPDF()">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="12" y1="18" x2="12" y2="12"></line><line x1="9" y1="15" x2="15" y2="15"></line></svg>
                Descargar PDF
            </button>
            <button type="button" class="btn-print-cert" onclick="window.print()">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 6 2 18 2 18 9"></polyline><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path><rect x="6" y="14" width="12" height="8"></rect></svg>
                Imprimir
            </button>
        </div>

        <!-- El elemento del Certificado real a capturar -->
        <div id="certificadoDOM" class="certificate-container">
            <div class="certificate-inner">
                <!-- Esquinas decorativas -->
                <div class="certificate-decoration cert-tl"></div>
                <div class="certificate-decoration cert-tr"></div>
                <div class="certificate-decoration cert-bl"></div>
                <div class="certificate-decoration cert-br"></div>
                
                <div class="certificate-header">
                    <h1>Certificado de Adopción</h1>
                    <h3>Otorgado con amor y responsabilidad</h3>
                </div>
                
                <div class="certificate-body">
                    <div class="certificate-text">Este certificado oficial confirma que</div>
                    <div class="certificate-name">
                        <asp:Literal ID="litNombreAdoptante" runat="server"></asp:Literal>
                    </div>
                    
                    <div class="certificate-text">Ha adoptado formalmente a</div>
                    <div class="certificate-pet">
                        <asp:Literal ID="litNombreMascota" runat="server"></asp:Literal>
                    </div>
                    
                    <div class="certificate-details">
                        <span><strong>Especie:</strong> <asp:Literal ID="litEspecie" runat="server"></asp:Literal></span>
                        <span><strong>Raza:</strong> <asp:Literal ID="litRaza" runat="server"></asp:Literal></span>
                    </div>
                    
                    <div class="certificate-text" style="margin-top: 1.5rem;">
                        Asumiendo el compromiso de brindarle un hogar seguro, 
                        atención veterinaria y amor por el resto de su vida, 
                        honrando la confianza depositada por el refugio.
                    </div>
                </div>
                
                <div class="certificate-footer">
                    <div class="cert-signature">
                        <div class="cert-line"></div>
                        <div><asp:Literal ID="litNombreRefugio" runat="server"></asp:Literal></div>
                        <div style="font-size:0.8rem; color:#888;">Refugio Responsable</div>
                    </div>
                    
                    <div class="cert-seal">
                        <span>RedPatitas</span>
                        <strong>Oficial</strong>
                        <span>Adopción</span>
                    </div>
                    
                    <div class="cert-signature">
                        <div class="cert-line"></div>
                        <div><asp:Literal ID="litFirmaAdoptante" runat="server"></asp:Literal></div>
                        <div style="font-size:0.8rem; color:#888;">Firma del Adoptante</div>
                    </div>
                </div>
                
                <div class="certificate-code">
                    Código: <asp:Literal ID="litCodigo" runat="server"></asp:Literal> | Emitido: <asp:Literal ID="litFechaEmision" runat="server"></asp:Literal>
                </div>
            </div>
        </div>
    </asp:Panel>

    <!-- Panel de Error (Si no encuentra el certificado) -->
    <asp:Panel ID="pnlError" runat="server" Visible="false">
        <div class="cert-error">
            <h2>Certificado no encontrado</h2>
            <p>No pudimos encontrar el certificado de adopción solicitado. Asegúrate de que la adopción haya sido aprobada o intenta acceder desde la sección "Mis Solicitudes".</p>
            <a href="Solicitudes.aspx" class="btn-verify" style="text-decoration:none; display:inline-block;">Volver a Mis Solicitudes</a>
        </div>
    </asp:Panel>

    <script>
        window.jsPDF = window.jspdf.jsPDF;

        async function descargarPDF() {
            // Mostrar estado de carga usando SweetAlert2
            Swal.fire({
                title: 'Generando PDF',
                text: 'Por favor espera...',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            try {
                const element = document.getElementById('certificadoDOM');
                
                // Usar html2canvas para renderizar el DOM a imagen
                const canvas = await html2canvas(element, {
                    scale: 2, // Mejor resolución
                    useCORS: true,
                    backgroundColor: '#ffffff'
                });

                const imgData = canvas.toDataURL('image/png');
                
                // Configurar jsPDF apaisado (landscape)
                // A4 en mm: 297 x 210
                const pdf = new jsPDF({
                    orientation: 'landscape',
                    unit: 'mm',
                    format: 'a4'
                });

                const pdfWidth = pdf.internal.pageSize.getWidth();
                const pdfHeight = (canvas.height * pdfWidth) / canvas.width;

                pdf.addImage(imgData, 'PNG', 0, 0, pdfWidth, pdfHeight);
                
                // Obtener nombre dinámico si existe la variable global, sino genérico
                const codigo = document.querySelector('.certificate-code').innerText.split('|')[0].replace('Código: ', '').trim();
                const fileName = codigo ? `Certificado_${codigo}.pdf` : `Certificado_Adopcion.pdf`;
                
                pdf.save(fileName);
                
                Swal.fire({
                    icon: 'success',
                    title: '¡Descarga completa!',
                    text: 'Tu certificado se ha descargado correctamente.',
                    timer: 2000,
                    showConfirmButton: false
                });

            } catch (error) {
                console.error('Error generando PDF:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Ocurrió un problema al generar el PDF.'
                });
            }
        }
    </script>
</asp:Content>
