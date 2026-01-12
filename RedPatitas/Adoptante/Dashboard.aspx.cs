using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaDatos; // Asegúrate de que esto no dé error, sino agrega la referencia

namespace RedPatitas.Adoptante
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Seguridad básica: Si no hay usuario, mandar al login
                if (Session["UsuarioId"] == null)
                {
                    Response.Redirect("~/Login/Login.aspx");
                    return;
                }

                CargarDatosUsuario();
            }
        }

        private void CargarDatosUsuario()
        {
            try
            {
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);

                using (DataClasses1DataContext dc = new DataClasses1DataContext())
                {
                    var usuario = dc.tbl_Usuarios.FirstOrDefault(u => u.usu_IdUsuario == idUsuario);

                    if (usuario != null)
                    {
                        // Ponemos solo el primer nombre para que sea más personal
                        // Si el nombre es "Jaime Peralvo", split[0] toma "Jaime"
                        string primerNombre = usuario.usu_Nombre.Split(' ')[0];
                        litNombreUsuario.Text = primerNombre;
                    }
                }
            }
            catch (Exception)
            {
                // Si falla algo, mostramos un genérico
                litNombreUsuario.Text = "Amigo";
            }
        }
    }
}