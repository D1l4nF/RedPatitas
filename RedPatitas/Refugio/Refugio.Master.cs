using CapaDatos;
using System;
using System.Linq;
using System.Web.UI;

namespace RedPatitas.Refugio
{
    public partial class Refugio : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UsuarioId"] == null || Session["RolId"] == null)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }
            int rolId = Convert.ToInt32(Session["RolId"]);
            if (rolId != 3)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }

            // Cargar datos del usuario (no del refugio)
            CargarDatosPerfil();
        }

        private void CargarDatosPerfil()
        {
            try
            {
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);

                using (DataClasses1DataContext dc = new DataClasses1DataContext())
                {
                    var usuario = dc.tbl_Usuarios.FirstOrDefault(u => u.usu_IdUsuario == idUsuario);

                    if (usuario != null)
                    {
                        // Mostrar nombre del usuario (no del refugio)
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
            catch (Exception ex)
            {
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