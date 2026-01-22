using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.Admin
{
    public partial class Usuarios : System.Web.UI.Page
    {
        private CN_AdminUsuarioService _usuarioService = new CN_AdminUsuarioService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarFiltros();
                CargarUsuarios();
                CargarRefugios();
            }
        }

        private void CargarFiltros()
        {
            try
            {
                // Cargar roles en dropdown
                var roles = _usuarioService.ObtenerRoles();
                foreach (var rol in roles)
                {
                    ddlFiltroRol.Items.Add(new ListItem(rol.Nombre, rol.IdRol.ToString()));
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cargando filtros: " + ex.Message);
            }
        }

        private void CargarRefugios()
        {
            try
            {
                var refugios = _usuarioService.ObtenerRefugiosParaAsignar();
                ddlRefugios.Items.Clear();
                ddlRefugios.Items.Add(new ListItem("-- Sin asignar --", ""));
                foreach (var refugio in refugios)
                {
                    string nombre = refugio.Verificado ? refugio.Nombre : $"{refugio.Nombre} (No verificado)";
                    ddlRefugios.Items.Add(new ListItem(nombre, refugio.IdRefugio.ToString()));
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cargando refugios: " + ex.Message);
            }
        }

        private void CargarUsuarios()
        {
            try
            {
                // Obtener filtros
                int? filtroRol = null;
                if (int.TryParse(ddlFiltroRol.SelectedValue, out int rol) && rol > 0)
                {
                    filtroRol = rol;
                }

                bool? filtroEstado = null;
                if (!string.IsNullOrEmpty(ddlFiltroEstado.SelectedValue))
                {
                    filtroEstado = bool.Parse(ddlFiltroEstado.SelectedValue);
                }

                string busqueda = txtBusqueda.Text.Trim();

                // Obtener usuarios
                var usuarios = _usuarioService.ObtenerTodosUsuarios(filtroRol, filtroEstado, busqueda);

                if (usuarios.Count > 0)
                {
                    rptUsuarios.DataSource = usuarios;
                    rptUsuarios.DataBind();
                    pnlSinResultados.Visible = false;
                }
                else
                {
                    rptUsuarios.DataSource = null;
                    rptUsuarios.DataBind();
                    pnlSinResultados.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cargando usuarios: " + ex.Message);
                pnlSinResultados.Visible = true;
            }
        }

        protected void ddlFiltroRol_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarUsuarios();
        }

        protected void ddlFiltroEstado_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarUsuarios();
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            CargarUsuarios();
        }

        protected void rptUsuarios_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                switch (e.CommandName)
                {
                    case "CambiarEstado":
                        var argsEstado = e.CommandArgument.ToString().Split(',');
                        int idUsuarioEstado = int.Parse(argsEstado[0]);
                        bool estadoActual = bool.Parse(argsEstado[1]);
                        _usuarioService.CambiarEstadoUsuario(idUsuarioEstado, !estadoActual);
                        CargarUsuarios();
                        break;

                    case "Desbloquear":
                        int idUsuarioDesbloquear = int.Parse(e.CommandArgument.ToString());
                        _usuarioService.DesbloquearUsuario(idUsuarioDesbloquear);
                        CargarUsuarios();
                        break;

                    case "AsignarRefugio":
                        var argsRefugio = e.CommandArgument.ToString().Split(',');
                        hdnUsuarioId.Value = argsRefugio[0];
                        pnlModalAsignar.CssClass = "modal-overlay active";
                        break;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en comando: " + ex.Message);
            }
        }

        protected void rptUsuarios_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var usuario = e.Item.DataItem as CN_AdminUsuarioService.UsuarioAdmin;
                if (usuario != null)
                {
                    var pnlAvatar = e.Item.FindControl("pnlAvatar") as Panel;
                    if (pnlAvatar != null)
                    {
                        // Colores según el rol
                        string color = GetRolColor(usuario.IdRol);
                        pnlAvatar.Style["background"] = color;
                    }
                }
            }
        }

        protected void btnCancelarAsignar_Click(object sender, EventArgs e)
        {
            pnlModalAsignar.CssClass = "modal-overlay";
            hdnUsuarioId.Value = "";
        }

        protected void btnConfirmarAsignar_Click(object sender, EventArgs e)
        {
            try
            {
                int idUsuario = int.Parse(hdnUsuarioId.Value);
                int? idRefugio = null;
                
                if (!string.IsNullOrEmpty(ddlRefugios.SelectedValue))
                {
                    idRefugio = int.Parse(ddlRefugios.SelectedValue);
                }

                _usuarioService.AsignarUsuarioARefugio(idUsuario, idRefugio);
                
                pnlModalAsignar.CssClass = "modal-overlay";
                hdnUsuarioId.Value = "";
                CargarUsuarios();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error asignando refugio: " + ex.Message);
            }
        }

        protected string GetRolBadgeClass(int idRol)
        {
            switch (idRol)
            {
                case 1: return "danger";   // SuperAdmin
                case 2: return "warning";  // AdminRefugio
                case 3: return "info";     // Refugio
                case 4: return "success";  // Adoptante
                default: return "";
            }
        }

        private string GetRolColor(int idRol)
        {
            switch (idRol)
            {
                case 1: return "#E74C3C";  // SuperAdmin - Rojo
                case 2: return "#F39C12";  // AdminRefugio - Naranja
                case 3: return "#3498DB";  // Refugio - Azul
                case 4: return "#27AE60";  // Adoptante - Verde
                default: return "#95A5A6";
            }
        }
    }
}