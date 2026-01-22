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

                    case "RevisarRefugio":
                        if (!string.IsNullOrEmpty(e.CommandArgument.ToString()))
                        {
                            int idRefugioVerif = int.Parse(e.CommandArgument.ToString());
                            CargarDetalleRefugioParaVerificar(idRefugioVerif);
                        }
                        break;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en comando: " + ex.Message);
            }
        }

        private void CargarDetalleRefugioParaVerificar(int idRefugio)
        {
            var detalle = _usuarioService.ObtenerDetalleRefugio(idRefugio);
            if (detalle != null)
            {
                hdnRefugioVerificarId.Value = detalle.IdRefugio.ToString();
                
                // Cargar datos en controles
                litNombreRefugioVerif.Text = detalle.Nombre;
                
                string ubicacion = detalle.Ciudad;
                string direccionAdicional = detalle.Direccion;

                // Si no hay dirección pero sí coordenadas, recuperar desde API (Nominatim)
                if (string.IsNullOrEmpty(direccionAdicional) && detalle.Latitud.HasValue && detalle.Longitud.HasValue)
                {
                    direccionAdicional = ObtenerDireccionDesdeCoordenadas(detalle.Latitud.Value, detalle.Longitud.Value);
                }

                if (!string.IsNullOrEmpty(direccionAdicional))
                {
                    ubicacion += " - " + direccionAdicional;
                    litDireccionRefugioVerif.Text = direccionAdicional;
                    litDireccionRefugioVerif.Visible = true;
                }
                else
                {
                    litDireccionRefugioVerif.Visible = false; // Ocultar si no hay
                }

                litCiudadRefugioVerif.Text = ubicacion;
                
                litTelefonoRefugioVerif.Text = detalle.Telefono;
                litDescripcionRefugioVerif.Text = detalle.Descripcion;
                litMascotasRefugioVerif.Text = detalle.CantidadMascotas.ToString();
                litFechaRefugioVerif.Text = detalle.FechaRegistro?.ToString("dd/MM/yyyy") ?? "Desconocido";
                
                if (!string.IsNullOrEmpty(detalle.FotoUrl))
                    imgRefugioVerif.ImageUrl = detalle.FotoUrl;
                else
                    imgRefugioVerif.ImageUrl = "~/Images/default-shelter.png";

                // Lógica de botones y estado
                if (detalle.Verificado)
                {
                    pnlEstadoVerificado.Visible = true;
                    btnAprobarVerificacion.Visible = false;
                    btnQuitarVerificacion.Visible = true;
                }
                else
                {
                    pnlEstadoVerificado.Visible = false;
                    btnAprobarVerificacion.Visible = true;
                    btnQuitarVerificacion.Visible = false;
                }

                pnlModalVerificar.CssClass = "modal-overlay active";
            }
        }

        private string ObtenerDireccionDesdeCoordenadas(decimal lat, decimal lon)
        {
            try
            {
                // Nominatim API (OpenStreetMap) - Requiere User-Agent
                string url = $"https://nominatim.openstreetmap.org/reverse?format=json&lat={lat}&lon={lon}&zoom=18&addressdetails=1";
                using (var client = new System.Net.WebClient())
                {
                    client.Headers.Add("User-Agent", "RedPatitasAdmin/1.0 (admin@redpatitas.com)");
                    client.Encoding = System.Text.Encoding.UTF8;
                    string json = client.DownloadString(url);
                    
                    var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                    var result = serializer.Deserialize<Dictionary<string, object>>(json);
                    
                    if (result != null && result.ContainsKey("display_name"))
                    {
                        // Limpiar un poco la dirección (tomar solo los primeros componentes relevantes si es muy larga)
                        string fullAddress = result["display_name"].ToString();
                        return fullAddress; 
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error geocoding: " + ex.Message);
            }
            return null;
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

        protected void btnCerrarVerificar_Click(object sender, EventArgs e)
        {
            pnlModalVerificar.CssClass = "modal-overlay";
            hdnRefugioVerificarId.Value = "";
        }

        protected void btnAprobarVerificacion_Click(object sender, EventArgs e)
        {
            if (int.TryParse(hdnRefugioVerificarId.Value, out int idRefugio))
            {
                _usuarioService.VerificarRefugioDeUsuario(idRefugio, true);
                pnlModalVerificar.CssClass = "modal-overlay"; // Cerrar modal
                CargarUsuarios(); // Recargar tabla
            }
        }

        protected void btnQuitarVerificacion_Click(object sender, EventArgs e)
        {
            if (int.TryParse(hdnRefugioVerificarId.Value, out int idRefugio))
            {
                _usuarioService.VerificarRefugioDeUsuario(idRefugio, false); // false para quitar
                pnlModalVerificar.CssClass = "modal-overlay"; // Cerrar modal
                CargarUsuarios(); // Recargar tabla
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