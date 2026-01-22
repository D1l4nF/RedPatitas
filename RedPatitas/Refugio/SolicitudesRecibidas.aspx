<%@ Page Title="" Language="C#" MasterPageFile="~/Refugio/Refugio.Master" AutoEventWireup="true" CodeBehind="SolicitudesRecibidas.aspx.cs" Inherits="RedPatitas.Refugio.SolicitudesRecibidas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeader" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
     <h2>Solicitudes recibidas</h2>

    <asp:GridView ID="gvSolicitudes" runat="server" AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="mas_Nombre" HeaderText="Mascota" />
            <asp:BoundField DataField="usu_NombreCompleto" HeaderText="Solicitante" />
            <asp:BoundField DataField="sol_FechaSolicitud" HeaderText="Fecha" />

            <asp:TemplateField HeaderText="Comentario">
                <ItemTemplate>
                    <asp:TextBox ID="txtComentario" runat="server"></asp:TextBox>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Acciones">
                <ItemTemplate>
                    <asp:Button Text="Aprobar" runat="server"
                        CommandArgument='<%# Eval("sol_IdSolicitud") %>'
                        CssClass="btn btn-success"
                        OnClick="btnAprobar_Click" />

                    <asp:Button Text="Rechazar" runat="server"
                        CommandArgument='<%# Eval("sol_IdSolicitud") %>'
                        CssClass="btn btn-danger"
                        OnClick="btnRechazar_Click" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

</asp:Content>
