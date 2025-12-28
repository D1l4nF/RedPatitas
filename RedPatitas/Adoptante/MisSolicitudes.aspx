<%@ Page Title="" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true" CodeBehind="MisSolicitudes.aspx.cs" Inherits="RedPatitas.Adoptante.MisSolicitudes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h2>Mis Solicitudes de Adopción</h2>

    <asp:GridView ID="gvSolicitudes"
        runat="server"
        AutoGenerateColumns="true" />

</asp:Content>
