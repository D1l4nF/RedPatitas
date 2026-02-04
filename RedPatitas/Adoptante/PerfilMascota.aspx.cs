using System;
using System.Linq;
using System.Web.UI.WebControls;
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

                // Título y Meta
                litTitulo.Text = mascota.Nombre + " - Perfil de Mascota";

                // Emoji y Galería
                litEmoji.Text = mascota.EmojiEspecie;
                litThumb1.Text = mascota.EmojiEspecie;

                // Estado
                litEstado.Text = mascota.EstadoAdopcion ?? "Disponible";

                // Información básica
                litNombre.Text = mascota.Nombre;
                litNombre2.Text = mascota.Nombre;
                litRaza.Text = mascota.Raza;

                // Tags (Formatting to match Public)
                litTagEspecie.Text = mascota.EmojiEspecie + " " + mascota.Especie;
                litTagEdad.Text = "📅 " + mascota.EdadFormateada;
                litTagTamano.Text = "⚖️ " + mascota.Tamano;
                litTagSexo.Text = (mascota.Sexo == "Macho" ? "♂️ " : "♀️ ") + mascota.Sexo;
                litTagUbicacion.Text = "📍 " + mascota.CiudadRefugio;

                // Descripción
                litDescripcion.Text = !string.IsNullOrEmpty(mascota.Descripcion) 
                    ? mascota.Descripcion 
                    : "Esta adorable mascota está esperando un hogar lleno de amor. ¡Conócela!";

                // Estado de salud (Panels instead of Icons)
                pnlVacunado.Visible = mascota.Vacunado;
                pnlEsterilizado.Visible = mascota.Esterilizado;
                pnlDesparasitado.Visible = mascota.Desparasitado;

                // Temperamento
                if (!string.IsNullOrEmpty(mascota.Temperamento))
                {
                    pnlTemperamento.Visible = true;
                    string[] caracteristicas = mascota.Temperamento.Split(',');
                    string html = "";
                    foreach (string carac in caracteristicas)
                    {
                        html += "<span class=\"char-tag\">" + carac.Trim() + "</span>";
                    }
                    litTemperamento.Text = html;
                }
                else 
                {
                    pnlTemperamento.Visible = false;
                }

                // Refugio
                litRefugioNombre.Text = mascota.NombreRefugio;
                litRefugioCiudad.Text = mascota.CiudadRefugio;
                
                // Iniciales del refugio
                string iniciales = "";
                if (!string.IsNullOrEmpty(mascota.NombreRefugio))
                {
                    string[] palabras = mascota.NombreRefugio.Split(' ');
                    foreach (string palabra in palabras)
                    {
                        if (!string.IsNullOrEmpty(palabra))
                            iniciales += palabra[0].ToString().ToUpper();
                        if (iniciales.Length >= 2) break;
                    }
                }
                litRefugioInicial.Text = iniciales;

                // Verificar favorito (Logic kept from Adoptante)
                VerificarFavorito();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar mascota: " + ex.Message);
                MostrarNoEncontrado();
            }
        }

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
                        btnFavorito.CssClass += " active";
                        // Note: SVG fill is handled via CSS .active class in public styles usually, 
                        // but here we might need to swap the icon if strictly server side.
                        // For now we rely on CSS 'active' class styling.
                        btnFavorito.Attributes["style"] = "color: #E74C3C;"; // Force color just in case
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al verificar favorito: " + ex.Message);
            }
        }

        private void MostrarNoEncontrado()
        {
            pnlMascota.Visible = false;
            pnlNoEncontrado.Visible = true;
        }

        protected void btnFavorito_Click(object sender, EventArgs e)
        {
            try
            {
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);
                // Ensure IdMascota is set
                 if (!int.TryParse(Request.QueryString["id"], out IdMascota)) return;

                using (var db = new DataClasses1DataContext())
                {
                    var existente = db.tbl_Favoritos.FirstOrDefault(f => 
                        f.fav_IdUsuario == idUsuario && f.fav_IdMascota == IdMascota);

                    if (existente == null)
                    {
                        var nuevoFavorito = new tbl_Favoritos
                        {
                            fav_IdUsuario = idUsuario,
                            fav_IdMascota = IdMascota,
                            fav_FechaAgregado = DateTime.Now
                        };
                        db.tbl_Favoritos.InsertOnSubmit(nuevoFavorito);
                        db.SubmitChanges();
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('❤️ Mascota agregada a favoritos');", true);
                    }
                    else
                    {
                        db.tbl_Favoritos.DeleteOnSubmit(existente);
                        db.SubmitChanges();
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('💔 Mascota eliminada de favoritos');", true);
                    }
                }
                Response.Redirect(Request.RawUrl);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al gestionar favorito: " + ex.Message);
            }
        }

        protected void btnAdoptar_Click(object sender, EventArgs e)
        {
            if (int.TryParse(Request.QueryString["id"], out IdMascota))
            {
                 Response.Redirect($"SolicitudAdopcion.aspx?id={IdMascota}");
            }
        }
    }
}
