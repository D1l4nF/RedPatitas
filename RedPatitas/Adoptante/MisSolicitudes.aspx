<%@ Page Title="" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" AutoEventWireup="true" CodeBehind="MisSolicitudes.aspx.cs" Inherits="RedPatitas.Adoptante.MisSolicitudes" %>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
      <h2>Mis solicitudes de adopción</h2>

    <asp:GridView 
    ID="gvSolicitudes" 
    runat="server" 
    AutoGenerateColumns="False"
    CssClass="table table-striped table-bordered">

    <Columns>
        <asp:BoundField 
            DataField="NombreMascota" 
            HeaderText="Mascota" />

        <asp:BoundField 
            DataField="sol_FechaSolicitud" 
            HeaderText="Fecha"
            DataFormatString="{0:dd/MM/yyyy}" />

        <asp:BoundField 
            DataField="sol_Estado" 
            HeaderText="Estado" />

        <asp:TemplateField HeaderText="Acción">
            <ItemTemplate>
                <asp:Button 
                    ID="btnCancelar"
                    runat="server"
                    Text="Cancelar"
                    CssClass="btn btn-danger btn-sm"
                    Visible='<%# Eval("sol_Estado").ToString() == "Pendiente" %>'
                    CommandArgument='<%# Eval("sol_IdSolicitud") %>'
                    OnClick="btnCancelar_Click" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>


</asp:Content>
