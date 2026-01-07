using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.Public
{
    public partial class PerfilMascota : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int idMascota = 0;
                if (int.TryParse(Request.QueryString["id"], out idMascota))
                {
                    CargarMascota(idMascota);
                }
                else
                {
                    MostrarNoEncontrado();
                }
            }
        }

        private void CargarMascota(int idMascota)
        {
            try
            {
                CN_MascotaService mascotaService = new CN_MascotaService();
                MascotaDTO mascota = mascotaService.ObtenerMascotaPorId(idMascota);

                if (mascota == null)
                {
                    MostrarNoEncontrado();
                    return;
                }

                // Título de la página
                litTitulo.Text = mascota.Nombre + " - Perfil de Mascota";

                // Emoji principal
                litEmoji.Text = mascota.EmojiEspecie;
                litThumb1.Text = mascota.EmojiEspecie;

                // Estado
                litEstado.Text = mascota.EstadoAdopcion ?? "Disponible";

                // Información básica
                litNombre.Text = mascota.Nombre;
                litNombre2.Text = mascota.Nombre;
                litRaza.Text = mascota.Raza;

                // Tags
                litTagEspecie.Text = mascota.EmojiEspecie + " " + mascota.Especie;
                litTagEdad.Text = "📅 " + mascota.EdadFormateada;
                litTagTamano.Text = "⚖️ " + mascota.Tamano;
                litTagSexo.Text = (mascota.Sexo == "Macho" ? "♂️ " : "♀️ ") + mascota.Sexo;
                litTagUbicacion.Text = "📍 " + mascota.CiudadRefugio;

                // Descripción
                litDescripcion.Text = !string.IsNullOrEmpty(mascota.Descripcion) 
                    ? mascota.Descripcion 
                    : "Esta adorable mascota está esperando un hogar lleno de amor. ¡Conócela!";

                // Estado de salud
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

                // Refugio
                litRefugioNombre.Text = mascota.NombreRefugio;
                litRefugioCiudad.Text = mascota.CiudadRefugio;
                
                // Iniciales del refugio
                string iniciales = "";
                string[] palabras = mascota.NombreRefugio.Split(' ');
                foreach (string palabra in palabras)
                {
                    if (!string.IsNullOrEmpty(palabra))
                        iniciales += palabra[0].ToString().ToUpper();
                    if (iniciales.Length >= 2) break;
                }
                litRefugioInicial.Text = iniciales;

                pnlMascota.Visible = true;
                pnlNoEncontrado.Visible = false;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar mascota: " + ex.Message);
                MostrarNoEncontrado();
            }
        }

        private void MostrarNoEncontrado()
        {
            pnlMascota.Visible = false;
            pnlNoEncontrado.Visible = true;
        }
    }
}