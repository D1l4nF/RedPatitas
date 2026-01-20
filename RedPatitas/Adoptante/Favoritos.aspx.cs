using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using CapaDatos;
using CapaNegocios;

namespace RedPatitas.Adoptante
{
    public partial class Favoritos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificar sesión
            if (Session["UsuarioId"] == null)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CargarFavoritos();
            }
        }

        /// <summary>
        /// Carga las mascotas favoritas del usuario
        /// </summary>
        private void CargarFavoritos()
        {
            try
            {
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);

                using (var db = new DataClasses1DataContext())
                {
                    // Obtener IDs de mascotas favoritas
                    var idsFavoritos = db.tbl_Favoritos
                        .Where(f => f.fav_IdUsuario == idUsuario)
                        .Select(f => f.fav_IdMascota)
                        .ToList();

                    if (idsFavoritos.Count > 0)
                    {
                        // Obtener todas las mascotas disponibles
                        var servicio = new CN_MascotaService();
                        var todasMascotas = servicio.ObtenerMascotasDisponibles();

                        // Filtrar solo las favoritas
                        var favoritas = todasMascotas
                            .Where(m => idsFavoritos.Contains(m.IdMascota))
                            .ToList();

                        if (favoritas.Count > 0)
                        {
                            rptFavoritos.DataSource = favoritas;
                            rptFavoritos.DataBind();

                            litConteo.Text = favoritas.Count.ToString();
                            pnlFavoritos.Visible = true;
                            pnlVacio.Visible = false;
                        }
                        else
                        {
                            MostrarVacio();
                        }
                    }
                    else
                    {
                        MostrarVacio();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar favoritos: " + ex.Message);
                MostrarVacio();
            }
        }

        /// <summary>
        /// Muestra el estado vacío
        /// </summary>
        private void MostrarVacio()
        {
            pnlFavoritos.Visible = false;
            pnlVacio.Visible = true;
            litConteo.Text = "0";
        }

        /// <summary>
        /// Maneja los comandos del repeater
        /// </summary>
        protected void rptFavoritos_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int idMascota = Convert.ToInt32(e.CommandArgument);
            int idUsuario = Convert.ToInt32(Session["UsuarioId"]);

            switch (e.CommandName)
            {
                case "Quitar":
                    QuitarFavorito(idMascota, idUsuario);
                    break;
                case "Adoptar":
                    Response.Redirect($"SolicitudAdopcion.aspx?id={idMascota}");
                    break;
            }
        }

        /// <summary>
        /// Quita una mascota de favoritos
        /// </summary>
        private void QuitarFavorito(int idMascota, int idUsuario)
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var favorito = db.tbl_Favoritos.FirstOrDefault(f => 
                        f.fav_IdUsuario == idUsuario && f.fav_IdMascota == idMascota);

                    if (favorito != null)
                    {
                        db.tbl_Favoritos.DeleteOnSubmit(favorito);
                        db.SubmitChanges();
                    }
                }

                // Recargar lista
                CargarFavoritos();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al quitar favorito: " + ex.Message);
            }
        }
    }
}
