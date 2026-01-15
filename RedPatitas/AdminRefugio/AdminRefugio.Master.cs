using CapaDatos;
using System;
using System.Linq;
using System.Web.UI;

namespace RedPatitas.AdminRefugio
{
    public partial class AdminRefugio : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UsuarioId"] == null || Session["RolId"] == null)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }
            int rolId = Convert.ToInt32(Session["RolId"]);
            if (rolId != 2)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }

            if (Session["Ref_Verificado"] != null)
            {
                bool? verificado = (bool?)Session["Ref_Verificado"];
                pnlVerificacion.Visible = verificado == false;
            }
            if (pnlVerificacion.Visible)
            {
                lnkMascotas.Enabled = false;
                lnkMascotas.CssClass = "nav-link disabled";
                lnkMascotas.ToolTip = "Disponible después de la verificación";
                lnkSolicitudes.Enabled = false;
                lnkSolicitudes.CssClass = "nav-link disabled";
                lnkSolicitudes.ToolTip = "Disponible después de la verificación";
                lnkCampanias.Enabled = false;
                lnkCampanias.CssClass = "nav-link disabled";
                lnkCampanias.ToolTip = "Disponible después de la verificación";
                lnkUsuarios.Enabled = false;
                lnkUsuarios.CssClass = "nav-link disabled";
                lnkUsuarios.ToolTip = "Disponible después de la verificación";
            }

            // Cargar datos siempre (no solo en !IsPostBack)
            CargarDatosPerfil();
        }

        private void CargarDatosPerfil()
        {
            try
            {
                // Intentar obtener RefugioId de la sesión primero
                int? refugioId = null;
                if (Session["RefugioId"] != null)
                {
                    refugioId = Convert.ToInt32(Session["RefugioId"]);
                }

                using (DataClasses1DataContext dc = new DataClasses1DataContext())
                {
                    // Si no hay RefugioId en sesión, buscar en BD
                    if (!refugioId.HasValue)
                    {
                        int idUsuario = Convert.ToInt32(Session["UsuarioId"]);
                        var usuario = dc.tbl_Usuarios.FirstOrDefault(u => u.usu_IdUsuario == idUsuario);
                        if (usuario != null && usuario.usu_IdRefugio.HasValue)
                        {
                            refugioId = usuario.usu_IdRefugio.Value;
                            Session["RefugioId"] = refugioId;
                        }
                    }

                    if (refugioId.HasValue)
                    {
                        var refugio = dc.tbl_Refugios.FirstOrDefault(r => r.ref_IdRefugio == refugioId.Value);
                        if (refugio != null)
                        {
                            lblNombreUsuario.Text = refugio.ref_Nombre ?? "Refugio";

                            if (!string.IsNullOrEmpty(refugio.ref_LogoUrl))
                            {
                                imgPerfilUsuario.ImageUrl = refugio.ref_LogoUrl;
                            }
                            else
                            {
                                imgPerfilUsuario.ImageUrl = "https://cdn-icons-png.flaticon.com/512/3047/3047928.png";
                            }
                        }
                        else
                        {
                            lblNombreUsuario.Text = "Refugio";
                            imgPerfilUsuario.ImageUrl = "https://cdn-icons-png.flaticon.com/512/3047/3047928.png";
                        }
                    }
                    else
                    {
                        // Usuario no tiene refugio asociado - mostrar nombre del usuario
                        int idUsuario = Convert.ToInt32(Session["UsuarioId"]);
                        var usuario = dc.tbl_Usuarios.FirstOrDefault(u => u.usu_IdUsuario == idUsuario);
                        if (usuario != null)
                        {
                            lblNombreUsuario.Text = usuario.usu_Nombre + " " + usuario.usu_Apellido;
                            if (!string.IsNullOrEmpty(usuario.usu_FotoUrl))
                            {
                                imgPerfilUsuario.ImageUrl = usuario.usu_FotoUrl;
                            }
                            else
                            {
                                imgPerfilUsuario.ImageUrl = "https://cdn-icons-png.flaticon.com/512/149/149071.png";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Si falla algo, mostrar valores por defecto
                lblNombreUsuario.Text = "Usuario";
                System.Diagnostics.Debug.WriteLine("Error CargarDatosPerfil: " + ex.Message);
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Session.RemoveAll();
            Response.Redirect("~/Login/Login.aspx");
        }
    }
}