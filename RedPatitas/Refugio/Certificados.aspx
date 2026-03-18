<%@ Page Title="Gesti&oacute;n de Certificados" Language="C#" MasterPageFile="~/Refugio/Refugio.Master" AutoEventWireup="true" CodeBehind="Certificados.aspx.cs" Inherits="RedPatitas.Refugio.Certificados" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Datatables para la grilla -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" />
    <link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.bootstrap5.min.css" />
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/responsive.bootstrap5.min.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="page-header">
        <h2 class="page-title">Certificados Emitidos</h2>
        <div class="breadcrumb">Panel / Mascotas / Certificados</div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="recent-section">
        <div class="section-header">
            <h3 class="section-title">Todos los certificados del refugio</h3>
        </div>

        <div class="table-container">
            <asp:GridView ID="gvCertificados" runat="server" AutoGenerateColumns="False" 
                CssClass="table table-striped table-hover dt-responsive nowrap" 
                GridLines="None"
                EmptyDataText="No hay certificados emitidos en este refugio."
                DataKeyNames="IdSolicitud">
                <Columns>
                    <asp:BoundField DataField="CodigoCertificado" HeaderText="C&oacute;digo" />
                    
                    <asp:TemplateField HeaderText="Mascota">
                        <ItemTemplate>
                            <div class="pet-cell">
                                <div class="pet-info">
                                    <span class="pet-name" style="font-weight:600;"><%# Eval("NombreMascota") %></span>
                                    <span class="pet-details" style="display:block; font-size:0.8rem; color:#666;">
                                        <%# Eval("EspecieMascota") %> - <%# Eval("RazaMascota") %>
                                    </span>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Adoptante">
                        <ItemTemplate>
                            <div class="pet-cell">
                                <div>
                                    <span style="font-weight:500;"><%# Eval("NombreAdoptante") %></span>
                                    <span style="display:block; font-size:0.8rem; color:#666;">
                                        C.I. <%# Eval("CedulaAdoptante") %>
                                    </span>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="FechaEmision" HeaderText="Fecha Emisi&oacute;n" DataFormatString="{0:dd/MM/yyyy}" />
                    
                    <asp:TemplateField HeaderText="Estado">
                        <ItemTemplate>
                            <span class="status-badge available"><%# Eval("Estado") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Acciones">
                        <ItemTemplate>
                            <a href='<%# ResolveUrl("~/VerCertificado.aspx?id=" + Eval("IdSolicitud")) %>' 
                               class="table-action-btn edit" 
                               target="_blank" 
                               title="Ver Certificado">
                                <i class="fas fa-external-link-alt"></i> Ver
                            </a>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <!-- Inicialización de DataTable (igual que Solicitudes) -->
    <script>
        $(document).ready(function () {
            $('#<%= gvCertificados.ClientID %>').DataTable({
                responsive: true,
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'
                },
                columnDefs: [
                    { responsivePriority: 1, targets: 0 },
                    { responsivePriority: 2, targets: -1 }
                ],
                order: [[3, 'desc']] // Ordenar por fecha desc
            });
        });
    </script>
</asp:Content>
