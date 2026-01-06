<%@ Page Title="" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true" CodeBehind="SolicitarAdopcion.aspx.cs" Inherits="RedPatitas.Adoptante.SolicitarAdopcion" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     
     <h2>Solicitar Adopción</h2>

    <asp:Label Text="Motivo:" runat="server" /><br />
    <asp:TextBox ID="txtMotivo" runat="server" TextMode="MultiLine" Width="300px" /><br /><br />

    <asp:Button ID="btnSolicitar"
        runat="server"
        Text="Enviar Solicitud"
        OnClick="btnSolicitar_Click" />

    <br /><br />
    <asp:Label ID="lblMensaje" runat="server" />

</asp:Content>







