<%@ Page Title="" Language="C#" MasterPageFile="~/Refugio/Refugio.Master" AutoEventWireup="true" CodeBehind="SolicitudesRecibidas.aspx.cs" Inherits="RedPatitas.Refugio.SolicitudesRecibidas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Solicitudes Recibidas</h2>

    <asp:GridView ID="gvSolicitudes"
        runat="server"
        AutoGenerateColumns="false"
        OnRowCommand="gvSolicitudes_RowCommand">

        <Columns>
            <asp:BoundField DataField="Adoptante" HeaderText="Adoptante" />
            <asp:BoundField DataField="Mascota" HeaderText="Mascota" />
            <asp:BoundField DataField="Estado" HeaderText="Estado" />

            <asp:ButtonField Text="Aprobar" CommandName="Aprobar" />
            <asp:ButtonField Text="Rechazar" CommandName="Rechazar" />
        </Columns>
    </asp:GridView>

    <br />
    <asp:Label ID="lblResultado" runat="server" />
</asp:Content>
