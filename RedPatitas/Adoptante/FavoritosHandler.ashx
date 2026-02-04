<%@ WebHandler Language="C#" Class="FavoritosHandler" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.Data.SqlClient;

public class FavoritosHandler : IHttpHandler
{
    private const string ConnectionString = "Data Source=.;Initial Catalog=RedPatitas;Integrated Security=True;Encrypt=True;TrustServerCertificate=True";
    
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        
        try
        {
            int idMascota = 0;
            int idUsuario = 0;
            
            int.TryParse(context.Request["idMascota"], out idMascota);
            int.TryParse(context.Request["idUsuario"], out idUsuario);
            
            if (idMascota == 0 || idUsuario == 0)
            {
                WriteResponse(context, false, false, "Parametros invalidos");
                return;
            }
            
            using (var conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                
                // Verificar si existe
                string checkSql = "SELECT COUNT(*) FROM tbl_Favoritos WHERE fav_IdUsuario = @idUsuario AND fav_IdMascota = @idMascota";
                bool existe = false;
                
                using (var cmd = new SqlCommand(checkSql, conn))
                {
                    cmd.Parameters.AddWithValue("@idUsuario", idUsuario);
                    cmd.Parameters.AddWithValue("@idMascota", idMascota);
                    existe = (int)cmd.ExecuteScalar() > 0;
                }
                
                bool esFavorito;
                string mensaje;
                
                if (!existe)
                {
                    // Agregar a favoritos
                    string insertSql = "INSERT INTO tbl_Favoritos (fav_IdUsuario, fav_IdMascota, fav_FechaAgregado) VALUES (@idUsuario, @idMascota, @fecha)";
                    using (var cmd = new SqlCommand(insertSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@idUsuario", idUsuario);
                        cmd.Parameters.AddWithValue("@idMascota", idMascota);
                        cmd.Parameters.AddWithValue("@fecha", DateTime.Now);
                        cmd.ExecuteNonQuery();
                    }
                    esFavorito = true;
                    mensaje = "Mascota agregada a favoritos";
                }
                else
                {
                    // Eliminar de favoritos
                    string deleteSql = "DELETE FROM tbl_Favoritos WHERE fav_IdUsuario = @idUsuario AND fav_IdMascota = @idMascota";
                    using (var cmd = new SqlCommand(deleteSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@idUsuario", idUsuario);
                        cmd.Parameters.AddWithValue("@idMascota", idMascota);
                        cmd.ExecuteNonQuery();
                    }
                    esFavorito = false;
                    mensaje = "Mascota eliminada de favoritos";
                }
                
                WriteResponse(context, true, esFavorito, mensaje);
            }
        }
        catch (Exception ex)
        {
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
