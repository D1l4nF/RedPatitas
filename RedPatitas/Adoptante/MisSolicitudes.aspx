<%@ Page Title="" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true" CodeBehind="MisSolicitudes.aspx.cs" Inherits="RedPatitas.Adoptante.MisSolicitudes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h2>Mis Solicitudes de Adopción</h2>

<asp:GridView ID="gvSolicitudes"
    runat="server"
    AutoGenerateColumns="false"
    CssClass="table table-striped"
    EmptyDataText="No tienes solicitudes registradas">

    <Columns>

        <asp:BoundField 
            DataField="mas_Nombre"
            HeaderText="Mascota" />

        <asp:BoundField 
            DataField="mas_Especie"
            HeaderText="Especie" />

        <asp:BoundField 
            DataField="sol_Estado"
            HeaderText="Estado" />

        <asp:BoundField 
            DataField="sol_FechaSolicitud"
            HeaderText="Fecha"
            DataFormatString="{0:dd/MM/yyyy}" />

        <asp:TemplateField HeaderText="Acciones">
            <ItemTemplate>
                <asp:Button 
                    ID="btnCancelar"
                    runat="server"
                    Text="Cancelar"
                    CssClass="btn btn-danger btn-sm"
                    CommandArgument='<%# Eval("sol_IdSolicitud") %>'
                    Visible='<%# Eval("sol_Estado").ToString() == "Pendiente" %>'
                    OnClick="btnCancelar_Click" />
            </ItemTemplate>
        </asp:TemplateField>

    </Columns>
</asp:GridView>
</asp:Content>
