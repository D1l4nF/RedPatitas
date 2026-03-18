<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VerCertificado.aspx.cs" Inherits="RedPatitas.VerCertificado" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <title>Vista de Certificado | RedPatitas</title>
    
    <link href="/Style/estilos-paneles.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Great+Vibes&family=Playfair+Display:ital,wght@0,700;1,400&display=swap" rel="stylesheet">
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <style>
        body {
            background-color: #f3f4f6;
            margin: 0;
            padding: 2rem;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
            font-family: 'Inter', system-ui, -apple-system, sans-serif;
        }
        .standalone-wrapper {
            width: 100%;
            max-width: 1000px;
        }
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            background: white;
            padding: 1rem 1.5rem;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }
        .btn-back {
            color: #4F46E5;
            text-decoration: none;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .btn-back:hover { text-decoration: underline; }
        .action-btns {
            display: flex;
            gap: 1rem;
        }
        .btn-action {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.6rem 1.25rem;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: all 0.2s;
        }
        .btn-action.pdf { background: #4F46E5; color: white; }
        .btn-action.pdf:hover { background: #4338ca; }
        .btn-action.print { background: white; color: #4F46E5; border: 1px solid #4F46E5; }
        .btn-action.print:hover { background: #f5f3ff; }
        
        @media print {
            body { padding: 0; background: white; }
            .top-bar { display: none !important; }
            .standalone-wrapper { max-width: none; }
            .certificate-container { margin: 0; box-shadow: none; border-width: 6px; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="standalone-wrapper">
            <asp:Panel ID="pnlCertificadoExito" runat="server">
                <div class="top-bar">
                    <a href="javascript:history.back()" class="btn-back">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                        Volver
                    </a>
                    <div class="action-btns">
                        <button type="button" class="btn-action pdf" onclick="descargarPDF()">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="12" y1="18" x2="12" y2="12"></line><line x1="9" y1="15" x2="15" y2="15"></line></svg>
                            Descargar PDF
                        </button>
                        <button type="button" class="btn-action print" onclick="window.print()">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 6 2 18 2 18 9"></polyline><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path><rect x="6" y="14" width="12" height="8"></rect></svg>
                            Imprimir
                        </button>
                    </div>
                </div>

                <div id="certificadoDOM" class="certificate-container">
                    <div class="certificate-inner">
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

            <asp:Panel ID="pnlError" runat="server" Visible="false">
                <div style="background:white; padding:3rem; border-radius:12px; text-align:center; box-shadow:0 10px 15px -3px rgba(0,0,0,0.1);">
                    <div style="background:#FEE2E2; color:#DC2626; width:80px; height:80px; border-radius:50%; display:flex; align-items:center; justify-content:center; margin:0 auto 1.5rem;">
                        <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
                    </div>
                    <h2 style="color:#111827; margin-bottom:1rem;">Certificado no encontrado</h2>
                    <p style="color:#4B5563; margin-bottom:2rem;">El certificado de adopción que intentas visualizar no existe o no tienes permisos para verlo.</p>
                    <a href="javascript:history.back()" style="background:#4F46E5; color:white; text-decoration:none; padding:0.75rem 1.5rem; border-radius:8px; font-weight:600;">Regresar al Panel</a>
                </div>
            </asp:Panel>
        </div>

        <script>
            window.jsPDF = window.jspdf.jsPDF;

            async function descargarPDF() {
                Swal.fire({
                    title: 'Generando PDF',
                    text: 'Por favor espera...',
                    allowOutsideClick: false,
                    didOpen: () => { Swal.showLoading(); }
                });

                try {
                    const element = document.getElementById('certificadoDOM');
                    const canvas = await html2canvas(element, { scale: 2, useCORS: true, backgroundColor: '#ffffff' });
                    const imgData = canvas.toDataURL('image/png');
                    
                    const pdf = new jsPDF({ orientation: 'landscape', unit: 'mm', format: 'a4' });
                    const pdfWidth = pdf.internal.pageSize.getWidth();
                    const pdfHeight = (canvas.height * pdfWidth) / canvas.width;
                    pdf.addImage(imgData, 'PNG', 0, 0, pdfWidth, pdfHeight);
                    
                    const elCodigo = document.querySelector('.certificate-code');
                    const texto = elCodigo ? elCodigo.innerText : '';
                    let codigo = '';
                    if (texto.includes('|')) {
                        codigo = texto.split('|')[0].replace('Código:', '').trim();
                    }
                    const fileName = codigo ? `Certificado_${codigo}.pdf` : `Certificado_Adopcion.pdf`;
                    
                    pdf.save(fileName);
                    
                    Swal.fire({ icon: 'success', title: '¡Descarga completa!', text: 'Tu certificado se ha descargado correctamente.', timer: 2000, showConfirmButton: false });
                } catch (error) {
                    console.error('Error generando PDF:', error);
                    Swal.fire({ icon: 'error', title: 'Error', text: 'Ocurrió un problema al generar el PDF.' });
                }
            }
        </script>
    </form>
</body>
</html>
