using System;
using System.Linq;
using System.Web.UI.HtmlControls;
using CapaNegocios;
using CapaDatos;

namespace RedPatitas.Adoptante
{
    public partial class PerfilMascota : System.Web.UI.Page
    {
        private int IdMascota;
        private MascotaDTO mascota;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificar sesión
            if (Session["UsuarioId"] == null)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }

            // Obtener ID de mascota de la URL
            if (!int.TryParse(Request.QueryString["id"], out IdMascota))
            {
                MostrarNoEncontrado();
                return;
            }

            if (!IsPostBack)
            {
                CargarMascota();
            }
        }

        /// <summary>
        /// Carga los datos de la mascota
        /// </summary>
        private void CargarMascota()
        {
            try
            {
                var servicio = new CN_MascotaService();
                mascota = servicio.ObtenerMascotaPorId(IdMascota);

                if (mascota == null)
                {
                    MostrarNoEncontrado();
                    return;
                }

                // Mostrar panel de mascota
                pnlMascota.Visible = true;
                pnlNoEncontrado.Visible = false;
                pnlCTA.Visible = true;

                // Datos básicos
                litTitulo.Text = mascota.Nombre;
                litNombre.Text = mascota.Nombre;
                litNombreBreadcrumb.Text = mascota.Nombre;
                litNombreModal.Text = mascota.Nombre;
                litEstado.Text = mascota.EstadoAdopcion;
                litUbicacion.Text = $"{mascota.NombreRefugio} - {mascota.CiudadRefugio}";

                // Datos detallados
                litEspecie.Text = mascota.Especie;
                litRaza.Text = mascota.Raza;
                litEdad.Text = mascota.EdadFormateada;
                litEdadDetalle.Text = mascota.EdadAproximada;
                litSexo.Text = mascota.Sexo;
                litTamano.Text = mascota.Tamano;
                litColor.Text = !string.IsNullOrEmpty(mascota.Color) ? mascota.Color : "--";

                // Temperamento
                if (!string.IsNullOrEmpty(mascota.Temperamento))
                {
                    pnlTemperamento.Visible = true;
                    litTemperamento.Text = mascota.Temperamento;
                }

                // Descripción
                if (!string.IsNullOrEmpty(mascota.Descripcion))
                {
                    pnlDescripcion.Visible = true;
                    litDescripcion.Text = mascota.Descripcion;
                }
                else
                {
                    pnlDescripcion.Visible = false;
                }

                // Refugio
                litRefugioNombre.Text = mascota.NombreRefugio;
                litRefugioCiudad.Text = mascota.CiudadRefugio;
                litRefugioInicial.Text = mascota.NombreRefugio?.Length > 0 
                    ? mascota.NombreRefugio.Substring(0, 1).ToUpper() 
                    : "R";

                // Foto o emoji
                if (!string.IsNullOrEmpty(mascota.FotoPrincipal))
                {
                    imgMascota.ImageUrl = mascota.FotoPrincipal;
                    imgMascota.Visible = true;
                    litEmojiGrande.Text = "";
                }
                else
                {
                    imgMascota.Visible = false;
                    litEmojiGrande.Text = mascota.EmojiEspecie;
                    litEmojiModal.Text = mascota.EmojiEspecie;
                }

                // Es nueva
                pnlNuevo.Visible = mascota.EsNueva;

                // Condiciones de entrega (vacunado, esterilizado, desparasitado)
                SetDeliveryIconStatus(iconVacunado, mascota.Vacunado);
                SetDeliveryIconStatus(iconEsterilizado, mascota.Esterilizado);
                SetDeliveryIconStatus(iconDesparasitado, mascota.Desparasitado);

                // Necesidades especiales
                if (!string.IsNullOrEmpty(mascota.NecesidadesEspeciales))
                {
                    pnlNecesidades.Visible = true;
                    litNecesidades.Text = mascota.NecesidadesEspeciales;
                }

                // Cargar galería de fotos
                CargarGaleria();

                // Verificar si ya está en favoritos
                VerificarFavorito();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar mascota: " + ex.Message);
                MostrarNoEncontrado();
            }
        }

        /// <summary>
        /// Configura el estilo del icono de entrega según si está activo o no
        /// </summary>
        private void SetDeliveryIconStatus(HtmlGenericControl icon, bool isActive)
        {
            if (isActive)
            {
                icon.Attributes["class"] = "delivery-icon";
            }
            else
            {
                icon.Attributes["class"] = "delivery-icon inactive";
            }
        }

        /// <summary>
        /// Carga la galería de fotos de la mascota
        /// </summary>
        private void CargarGaleria()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var fotos = db.tbl_FotosMascotas
                        .Where(f => f.fot_IdMascota == IdMascota)
                        .OrderBy(f => f.fot_Orden)
                        .ToList();

                    if (fotos.Count > 0)
                    {
                        rptFotos.DataSource = fotos;
                        rptFotos.DataBind();
                        pnlSinFotos.Visible = false;
                    }
                    else
                    {
                        pnlSinFotos.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar galería: " + ex.Message);
            }
        }

        /// <summary>
        /// Verifica si la mascota ya está en favoritos del usuario
        /// </summary>
        private void VerificarFavorito()
        {
            try
            {
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);

                using (var db = new DataClasses1DataContext())
                {
                    bool esFavorito = db.tbl_Favoritos.Any(f => 
                        f.fav_IdUsuario == idUsuario && f.fav_IdMascota == IdMascota);

                    if (esFavorito)
                    {
                        btnFavorito.Style["background"] = "#FF6B6B";
                        btnFavorito.Style["color"] = "#fff";
                        btnFavorito.Text = "<svg viewBox='0 0 24 24' fill='currentColor' width='20' height='20'><path d='M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z'/></svg> ❤️ En Favoritos";
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al verificar favorito: " + ex.Message);
            }
        }

        /// <summary>
        /// Muestra el panel de mascota no encontrada
        /// </summary>
        private void MostrarNoEncontrado()
        {
            pnlMascota.Visible = false;
            pnlNoEncontrado.Visible = true;
            pnlCTA.Visible = false;
        }

        /// <summary>
        /// Evento click del botón favorito
        /// </summary>
        protected void btnFavorito_Click(object sender, EventArgs e)
        {
            try
            {
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);
                IdMascota = int.Parse(Request.QueryString["id"]);

                using (var db = new DataClasses1DataContext())
                {
                    var existente = db.tbl_Favoritos.FirstOrDefault(f => 
                        f.fav_IdUsuario == idUsuario && f.fav_IdMascota == IdMascota);

                    if (existente == null)
                    {
                        // Agregar a favoritos
                        var nuevoFavorito = new tbl_Favoritos
                        {
                            fav_IdUsuario = idUsuario,
                            fav_IdMascota = IdMascota,
                            fav_FechaAgregado = DateTime.Now
                        };
                        db.tbl_Favoritos.InsertOnSubmit(nuevoFavorito);
                        db.SubmitChanges();

                        ClientScript.RegisterStartupScript(this.GetType(), "alert", 
                            "alert('❤️ Mascota agregada a favoritos');", true);
                    }
                    else
                    {
                        // Eliminar de favoritos
                        db.tbl_Favoritos.DeleteOnSubmit(existente);
                        db.SubmitChanges();

                        ClientScript.RegisterStartupScript(this.GetType(), "alert", 
                            "alert('💔 Mascota eliminada de favoritos');", true);
                    }
                }

                // Recargar página para actualizar estado
                Response.Redirect(Request.RawUrl);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al gestionar favorito: " + ex.Message);
            }
        }

        /// <summary>
        /// Evento click del botón adoptar
        /// </summary>
        protected void btnAdoptar_Click(object sender, EventArgs e)
        {
            IdMascota = int.Parse(Request.QueryString["id"]);
            Response.Redirect($"SolicitudAdopcion.aspx?id={IdMascota}");
        }
    }
}
