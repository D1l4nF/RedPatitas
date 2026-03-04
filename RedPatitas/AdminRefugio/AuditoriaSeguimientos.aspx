<%@ Page Title="Bandeja de Seguimientos" Language="C#" MasterPageFile="~/AdminRefugio/AdminRefugio.Master"
    AutoEventWireup="true" CodeBehind="AuditoriaSeguimientos.aspx.cs"
    Inherits="RedPatitas.AdminRefugio.AuditoriaSeguimientos" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
        Bandeja de Entrada de Seguimientos | Refugio
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
        <div class="page-header">
            <h1 class="page-title">📬 Bandeja de Auditoría - Seguimientos Post-Adopción</h1>
            <div class="breadcrumb">Panel > Seguimientos </div>
        </div>
    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

        <style>
            .auditoria-inbox {
                background: #fff;
                padding: 25px;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            }

            .empty-inbox {
                padding: 50px;
                text-align: center;
                color: #888;
            }

            .btn-revisar {
                background: var(--info);
                color: #fff;
                padding: 8px 16px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: bold;
                display: inline-flex;
                align-items: center;
                gap: 5px;
                transition: all 0.3s;
            }

            .btn-revisar:hover {
                background: #0088cc;
                transform: translateY(-2px);
            }
        </style>

        <div class="auditoria-inbox">

            <!-- GridView usando el diseño base de RedPatitas en table-container -->
            <div class="table-container">
                <asp:GridView ID="gvBandejaSeguimientos" runat="server" AutoGenerateColumns="False" CssClass="table"
                    GridLines="None" EmptyDataText="">
                    <Columns>
                        <asp:BoundField DataField="Mascota" HeaderText="Mascota Rescatada" />
                        <asp:BoundField DataField="Adoptante" HeaderText="Nombre del Adoptante" />
                        <asp:BoundField DataField="Etapa" HeaderText="Cita Cumplida" />
                        <asp:BoundField DataField="FechaEnvio" HeaderText="Fecha Envío Satelital"
                            DataFormatString="{0:dd/MM/yyyy HH:mm}" />

                        <asp:TemplateField HeaderText="Acción Requerida">
                            <ItemTemplate>
                                <a href='<%# "VerSeguimiento.aspx?id=" + Eval("IdSeguimiento") %>' class="btn-revisar">
                                    🔍 Analizar Respuestas y Fotos GPS
                                </a>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <div id="divVacioInbox" runat="server" class="empty-inbox" visible="false">
                <h1 style="font-size: 4rem; opacity:0.5; margin:0;">🎉</h1>
                <h3>¡Bandeja Limpia!</h3>
                <p>No tienes seguimientos pendientes de revisión actualmente. Todos los cachorros están a salvo.</p>
            </div>

        </div>

    </asp:Content>