using CapaDatos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RedPatitas.Admin
{
    public partial class Admin : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UsuarioId"] == null || Session["RolId"] == null)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }
            int rolId = Convert.ToInt32(Session["RolId"]);
            if (rolId != 1)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }
            // 2. CARGAR DATOS DEL USUARIO (FOTO Y NOMBRE)
            if (!IsPostBack)
            {
                CargarDatosPerfil();
            }
        }
        private void CargarDatosPerfil()
        {
            try
            {
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);

                // Usamos el contexto de LINQ to SQL para buscar al usuario
                using (DataClasses1DataContext dc = new DataClasses1DataContext())
                {
                    var usuario = dc.tbl_Usuarios.FirstOrDefault(u => u.usu_IdUsuario == idUsuario);

                    if (usuario != null)
                    {
                        // Poner el nombre en la etiqueta
                        lblNombreUsuario.Text = usuario.usu_Nombre + " " + usuario.usu_Apellido;

                        // Poner la foto (Verificamos si tiene URL en la BD)
                        if (!string.IsNullOrEmpty(usuario.usu_FotoUrl))
                        {
                            imgPerfilUsuario.ImageUrl = usuario.usu_FotoUrl;
                        }
                        else
                        {
                            // Si no tiene foto, ponemos una por defecto
                            imgPerfilUsuario.ImageUrl = "https://cdn-icons-png.flaticon.com/512/149/149071.png";
                        }
                    }
                }
            }
            catch (Exception)
            {
                // Si falla algo, dejamos la imagen por defecto
            }
        
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            if (Session["UsuarioId"] != null)
            {
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);
                CapaNegocios.CN_AuditoriaService.RegistrarAccion(idUsuario, "LOGOUT", "tbl_Usuarios");
            }

            Session.Clear();
            Session.Abandon();
            Session.RemoveAll();
            Response.Redirect("~/Login/Login.aspx");
        }
    }
}