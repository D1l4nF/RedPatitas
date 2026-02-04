using System;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;

namespace RedPatitas.Adoptante
{
    /// <summary>
    /// Servicio web para operaciones AJAX en el panel de adoptante
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ScriptService]
    public class AdoptanteService : WebService
    {
        /// <summary>
        /// Alterna el estado de favorito de una mascota para el usuario actual
        /// </summary>
        /// <param name="idMascota">ID de la mascota</param>
        /// <param name="idUsuario">ID del usuario</param>
        /// <returns>Objeto con resultado: { success, isFavorite, message }</returns>
        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object ToggleFavorito(int idMascota, int idUsuario)
        {
            try
            {
                using (var db = new CapaDatos.DataClasses1DataContext())
                {
                    // Verificar si ya está en favoritos
                    var existente = db.tbl_Favoritos.FirstOrDefault(f =>
                        f.fav_IdUsuario == idUsuario && f.fav_IdMascota == idMascota);

                    bool esFavorito;
                    string mensaje;

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
                        
                        esFavorito = true;
                        mensaje = "Mascota agregada a favoritos";
                    }
                    else
                    {
                        // Eliminar de favoritos
                        db.tbl_Favoritos.DeleteOnSubmit(existente);
                        db.SubmitChanges();
                        
                        esFavorito = false;
                        mensaje = "Mascota eliminada de favoritos";
                    }

                    return new { success = true, isFavorite = esFavorito, message = mensaje };
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en ToggleFavorito: " + ex.Message);
                return new { success = false, isFavorite = false, message = "Error al procesar la solicitud" };
            }
        }
    }
}
