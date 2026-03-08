using System;
using System.IO;
using System.Linq;
using System.Web;

namespace RedPatitas.Adoptante
{
    public class ReporteFotoHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            int idFoto;
            if (!int.TryParse(context.Request["id"], out idFoto))
            {
                context.Response.StatusCode = 400;
                return;
            }

            try
            {
                using (var db = new CapaDatos.DataClasses1DataContext())
                {
                    var foto = db.tbl_FotosReportes
                        .FirstOrDefault(f => f.fore_IdFoto == idFoto);

                    if (foto == null)
                    {
                        context.Response.StatusCode = 404;
                        return;
                    }

                    // Resolver ruta física desde URL relativa (~/)
                    string rutaRelativa = foto.fore_Url.Replace("~/", "").Replace("~\\", "");
                    string rutaFisica = context.Server.MapPath("~/" + rutaRelativa);

                    if (!File.Exists(rutaFisica))
                    {
                        context.Response.StatusCode = 404;
                        return;
                    }

                    string ext = Path.GetExtension(rutaFisica).ToLower();
                    string contentType = ext == ".png" ? "image/png" : "image/jpeg";

                    // Cachear por 1 hora
                    context.Response.Cache.SetExpires(DateTime.Now.AddHours(1));
                    context.Response.Cache.SetCacheability(HttpCacheability.Public);
                    context.Response.ContentType = contentType;
                    context.Response.TransmitFile(rutaFisica);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en ReporteFotoHandler: " + ex.Message);
                context.Response.StatusCode = 500;
            }
        }

        public bool IsReusable { get { return false; } }
    }
}
