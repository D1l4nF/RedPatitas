<%@ Page Title="" Language="C#" MasterPageFile="~/Refugio/Refugio.Master" AutoEventWireup="true" CodeBehind="SolicitudesRecibidas.aspx.cs" Inherits="RedPatitas.Refugio.SolicitudesRecibidas2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    
    <h2>Solicitudes Recibidas</h2>

<asp:GridView 
    ID="gvSolicitudes"
    runat="server"
    AutoGenerateColumns="false"
    OnRowCommand="gvSolicitudes_RowCommand"
    CssClass="table table-striped">

    <Columns>

        <!-- Adoptante -->
        <asp:BoundField 
            DataField="tbl_Usuarios.usu_Nombre"
            HeaderText="Adoptante" />

        <!-- Mascota -->
        <asp:BoundField 
            DataField="tbl_Mascotas.mas_Nombre"
            HeaderText="Mascota" />

        <!-- Estado -->
        <asp:BoundField 
            DataField="sol_Estado"
            HeaderText="Estado" />

        <!-- Acciones -->
        <asp:TemplateField HeaderText="Acciones">
            <ItemTemplate>

                <asp:Button
                    runat="server"
                    Text="Aprobar"
                    CommandName="Aprobar"
                    CommandArgument='<%# Eval("sol_IdSolicitud") %>'
                    CssClass="btn btn-success btn-sm"
                    Visible='<%# Eval("sol_Estado").ToString() == "Pendiente" %>' />

                <asp:Button
                    runat="server"
                    Text="Rechazar"
                    CommandName="Rechazar"
                    CommandArgument='<%# Eval("sol_IdSolicitud") %>'
                    CssClass="btn btn-danger btn-sm"
                    Visible='<%# Eval("sol_Estado").ToString() == "Pendiente" %>' />

            </ItemTemplate>
        </asp:TemplateField>

    </Columns>
</asp:GridView>

    <br />
    <asp:Label ID="lblResultado" runat="server" />

</asp:Content>
