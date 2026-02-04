using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.Adoptante
{
    public partial class Mascotas : System.Web.UI.Page
    {
        // Lista de IDs de mascotas en favoritos del usuario actual
        protected HashSet<int> FavoritosIds { get; set; } = new HashSet<int>();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificar sesión
            if (Session["UsuarioId"] == null)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }

            // Cargar favoritos del usuario
            CargarFavoritosUsuario();

            if (!IsPostBack)
            {
                CargarMascotas();
            }
        }

        /// <summary>
        /// Carga los IDs de las mascotas que el usuario tiene en favoritos
        /// </summary>
        private void CargarFavoritosUsuario()
        {
            try
            {
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);
                using (var db = new CapaDatos.DataClasses1DataContext())
                {
                    FavoritosIds = new HashSet<int>(
                        db.tbl_Favoritos
                            .Where(f => f.fav_IdUsuario == idUsuario)
                            .Select(f => f.fav_IdMascota)
                    );
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar favoritos: " + ex.Message);
                FavoritosIds = new HashSet<int>();
            }
        }

        /// <summary>
        /// Verifica si una mascota está en los favoritos del usuario
        /// </summary>
        protected bool EsFavorito(object idMascota)
        {
            if (idMascota == null) return false;
            int id = Convert.ToInt32(idMascota);
            return FavoritosIds.Contains(id);
        }

        /// <summary>
        /// Carga todas las mascotas disponibles
        /// </summary>
        private void CargarMascotas()
        {
            try
            {
                var servicio = new CN_MascotaService();
                var mascotas = servicio.ObtenerMascotasDisponibles();

                MostrarMascotas(mascotas);
            }
            catch (Exception ex)
            {
                // Log del error
                System.Diagnostics.Debug.WriteLine("Error al cargar mascotas: " + ex.Message);
                MostrarVacio();
            }
        }

        /// <summary>
        /// Filtra las mascotas según los criterios seleccionados
        /// </summary>
        private void FiltrarMascotas()
        {
            try
            {
                var servicio = new CN_MascotaService();
                
                string especie = ddlEspecie.SelectedValue;
                string edad = ddlEdad.SelectedValue;
                string tamano = ddlTamano.SelectedValue;
                string busqueda = txtBuscar.Text.Trim();

                // Obtener mascotas filtradas
                var mascotas = servicio.FiltrarMascotas(especie, edad, tamano);

                // Filtro adicional por nombre si hay texto de búsqueda
                if (!string.IsNullOrEmpty(busqueda))
                {
                    mascotas = mascotas.Where(m => 
                        m.Nombre.ToLower().Contains(busqueda.ToLower()) ||
                        m.Raza.ToLower().Contains(busqueda.ToLower())
                    ).ToList();
                }

                MostrarMascotas(mascotas);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al filtrar mascotas: " + ex.Message);
                MostrarVacio();
            }
        }

        /// <summary>
        /// Muestra las mascotas en el repeater
        /// </summary>
        private void MostrarMascotas(List<MascotaDTO> mascotas)
        {
            if (mascotas != null && mascotas.Count > 0)
            {
                rptMascotas.DataSource = mascotas;
                rptMascotas.DataBind();

                litConteo.Text = mascotas.Count.ToString();
                pnlMascotas.Visible = true;
                pnlVacio.Visible = false;
            }
            else
            {
                MostrarVacio();
            }
        }

        /// <summary>
        /// Muestra el estado vacío
        /// </summary>
        private void MostrarVacio()
        {
            pnlMascotas.Visible = false;
            pnlVacio.Visible = true;
            litConteo.Text = "0";
        }

        /// <summary>
        /// Evento click del botón filtrar
        /// </summary>
        protected void btnFiltrar_Click(object sender, EventArgs e)
        {
            FiltrarMascotas();
        }

        /// <summary>
        /// Evento click del botón limpiar filtros
        /// </summary>
        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtBuscar.Text = "";
            ddlEspecie.SelectedIndex = 0;
            ddlEdad.SelectedIndex = 0;
            ddlTamano.SelectedIndex = 0;

            CargarMascotas();
        }

        /// <summary>
        /// Maneja los comandos del repeater (Favorito, Adoptar)
        /// </summary>
        protected void rptMascotas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int idMascota = Convert.ToInt32(e.CommandArgument);
            int idUsuario = Convert.ToInt32(Session["UsuarioId"]);

            switch (e.CommandName)
            {
                case "Favorito":
                    AgregarFavorito(idMascota, idUsuario);
                    break;
                case "Adoptar":
                    // Redirigir a la página de solicitud de adopción
                    Response.Redirect($"SolicitudAdopcion.aspx?id={idMascota}");
                    break;
            }
        }

        /// <summary>
        /// Agrega una mascota a favoritos
        /// </summary>
        private void AgregarFavorito(int idMascota, int idUsuario)
        {
            try
            {
                using (var db = new CapaDatos.DataClasses1DataContext())
                {
                    // Verificar si ya está en favoritos
                    var existente = db.tbl_Favoritos.FirstOrDefault(f => 
                        f.fav_IdUsuario == idUsuario && f.fav_IdMascota == idMascota);

                    if (existente == null)
                    {
                        // Agregar a favoritos
                        var nuevoFavorito = new CapaDatos.tbl_Favoritos
                        {
                            fav_IdUsuario = idUsuario,
                            fav_IdMascota = idMascota,
                            fav_FechaAgregado = DateTime.Now
                        };
                        db.tbl_Favoritos.InsertOnSubmit(nuevoFavorito);
                        db.SubmitChanges();

                        // Mostrar mensaje de éxito
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", 
                            "alert('❤️ Mascota agregada a favoritos');", true);
                    }
                    else
                    {
                        // Ya está en favoritos, eliminarlo
                        db.tbl_Favoritos.DeleteOnSubmit(existente);
                        db.SubmitChanges();

                        ClientScript.RegisterStartupScript(this.GetType(), "alert", 
                            "alert('💔 Mascota eliminada de favoritos');", true);
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al gestionar favorito: " + ex.Message);
                ClientScript.RegisterStartupScript(this.GetType(), "alert", 
                    "alert('Error al procesar la solicitud');", true);
            }
        }
    }
}
