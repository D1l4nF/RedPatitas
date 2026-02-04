using System;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

namespace RedPatitas.Adoptante
{
    public class FavoritosHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            
            try
            {
                // Leer parámetros
                int idMascota = 0;
                int idUsuario = 0;
                
                int.TryParse(context.Request["idMascota"], out idMascota);
                int.TryParse(context.Request["idUsuario"], out idUsuario);
                
                if (idMascota == 0 || idUsuario == 0)
                {
                    WriteResponse(context, false, false, "Parámetros inválidos");
                    return;
                }
                
                using (var db = new CapaDatos.DataClasses1DataContext())
                {
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
                    
                    WriteResponse(context, true, esFavorito, mensaje);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en FavoritosHandler: " + ex.Message);
                WriteResponse(context, false, false, "Error: " + ex.Message);
            }
        }
        
        private void WriteResponse(HttpContext context, bool success, bool isFavorite, string message)
        {
            var serializer = new JavaScriptSerializer();
            var response = new { success = success, isFavorite = isFavorite, message = message };
            context.Response.Write(serializer.Serialize(response));
        }
        
        public bool IsReusable
        {
            get { return false; }
        }
    }
}
