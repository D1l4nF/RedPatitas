<%@ Page Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true" CodeBehind="MascotasDisponibles.aspx.cs"
    Inherits="RedPatitas.Adoptante.MascotasDisponibles" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
    <link href="~/Style/mascotas.css" rel="stylesheet" />
</asp:Content>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h2>Mascotas Disponibles</h2>

    <div class="filtros">
        <asp:DropDownList ID="ddlEspecie" runat="server">
            <asp:ListItem Text="Todas" />
            <asp:ListItem Text="Perro" />
            <asp:ListItem Text="Gato" />
        </asp:DropDownList>

        <asp:DropDownList ID="ddlUbicacion" runat="server">
            <asp:ListItem Text="Todas" />
            <asp:ListItem Text="Quito" />
            <asp:ListItem Text="Guayaquil" />
        </asp:DropDownList>

        <asp:Button ID="btnFiltrar" runat="server" Text="Filtrar" />
    </div>

    <asp:Repeater ID="rptMascotas" runat="server">
        <ItemTemplate>
            <div class="card">
                <h3><%# Eval("Nombre") %></h3>
                <p>Especie: <%# Eval("Especie") %></p>
                <p>Ubicación: <%# Eval("Ubicacion") %></p>

                <asp:Button runat="server" Text="Solicitar Adopción" />
            </div>
        </ItemTemplate>
    </asp:Repeater>

</asp:Content>
