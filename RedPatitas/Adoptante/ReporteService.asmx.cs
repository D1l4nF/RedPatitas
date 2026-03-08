using System;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;
using CapaDatos;

namespace RedPatitas.Adoptante
{
    /// <summary>
    /// Servicio web para operaciones AJAX del módulo de reportes
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ScriptService]
    public class ReporteService : WebService
    {
        /// <summary>
        /// Cambia el estado de un reporte (validando que el usuario sea el dueño)
        /// </summary>
        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object CambiarEstadoReporte(int idReporte, string nuevoEstado)
        {
            if (Session["UsuarioId"] == null)
                return new { success = false, message = "No autenticado" };

            int idUsuario = Convert.ToInt32(Session["UsuarioId"]);
            string[] estadosValidos = { "Reportado", "EnBusqueda", "Avistado", "Reunido", "SinResolver" };

            if (!Array.Exists(estadosValidos, s => s == nuevoEstado))
                return new { success = false, message = "Estado inválido" };

            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var reporte = db.tbl_ReportesMascotas
                        .FirstOrDefault(r => r.rep_IdReporte == idReporte
                                          && r.rep_IdUsuario == idUsuario);

                    if (reporte == null)
                        return new { success = false, message = "Reporte no encontrado o sin permiso" };

                    string estadoAnterior = reporte.rep_Estado;
                    reporte.rep_Estado = nuevoEstado;

                    if (nuevoEstado == "Reunido" || nuevoEstado == "SinResolver")
                        reporte.rep_FechaCierre = DateTime.Now;

                    db.SubmitChanges();

                    return new
                    {
                        success = true,
                        message = "Estado actualizado a: " + nuevoEstado,
                        estadoAnterior = estadoAnterior,
                        estadoNuevo = nuevoEstado
                    };
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en CambiarEstadoReporte: " + ex.Message);
                return new { success = false, message = "Error al actualizar el estado" };
            }
        }

        /// <summary>
        /// Obtiene reportes cercanos usando cálculo Haversine en memoria
        /// </summary>
        [WebMethod(EnableSession = false)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object ObtenerReportesCercanos(double latitud, double longitud, double radioKm)
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var candidatos = db.tbl_ReportesMascotas
                        .Where(r => r.rep_Latitud != null && r.rep_Longitud != null
                                 && r.rep_Estado != "Reunido"
                                 && r.rep_Estado != "SinResolver")
                        .Select(r => new
                        {
                            r.rep_IdReporte,
                            r.rep_TipoReporte,
                            r.rep_NombreMascota,
                            r.rep_Estado,
                            r.rep_Ciudad,
                            Lat = (double)r.rep_Latitud,
                            Lng = (double)r.rep_Longitud,
                            Fecha = r.rep_FechaReporte.HasValue
                                    ? r.rep_FechaReporte.Value.ToString("dd/MM/yyyy") : ""
                        }).ToList();

                    var resultado = candidatos
                        .Select(r => new
                        {
                            r.rep_IdReporte,
                            r.rep_TipoReporte,
                            r.rep_NombreMascota,
                            r.rep_Estado,
                            r.rep_Ciudad,
                            r.Fecha,
                            DistanciaKm = Haversine(latitud, longitud, r.Lat, r.Lng)
                        })
                        .Where(r => r.DistanciaKm <= radioKm)
                        .OrderBy(r => r.DistanciaKm)
                        .Select(r => new
                        {
                            id          = r.rep_IdReporte,
                            tipo        = r.rep_TipoReporte,
                            nombre      = r.rep_NombreMascota ?? "Sin nombre",
                            estado      = r.rep_Estado,
                            ciudad      = r.rep_Ciudad,
                            fecha       = r.Fecha,
                            distanciaKm = Math.Round(r.DistanciaKm, 2)
                        }).ToList();

                    return new { success = true, total = resultado.Count, data = resultado };
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en ObtenerReportesCercanos: " + ex.Message);
                return new { success = false, message = "Error al buscar reportes cercanos" };
            }
        }

        /// <summary>
        /// Marca una notificación como leída
        /// </summary>
        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object MarcarNotificacionLeida(int idNotificacion)
        {
            if (Session["UsuarioId"] == null)
                return new { success = false };

            int idUsuario = Convert.ToInt32(Session["UsuarioId"]);

            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var notif = db.tbl_Notificaciones
                        .FirstOrDefault(n => n.not_IdNotificacion == idNotificacion
                                          && n.not_IdUsuario == idUsuario);

                    if (notif == null) return new { success = false };

                    notif.not_Leida = true;
                    notif.not_FechaLectura = DateTime.Now;
                    db.SubmitChanges();
                    return new { success = true };
                }
            }
            catch
            {
                return new { success = false };
            }
        }

        // --- Helper Haversine ---
        private static double Haversine(double lat1, double lng1, double lat2, double lng2)
        {
            const double R = 6371.0;
            double dLat = ToRad(lat2 - lat1);
            double dLng = ToRad(lng2 - lng1);
            double a = Math.Sin(dLat / 2) * Math.Sin(dLat / 2) +
                       Math.Cos(ToRad(lat1)) * Math.Cos(ToRad(lat2)) *
                       Math.Sin(dLng / 2) * Math.Sin(dLng / 2);
            return R * 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
        }

        private static double ToRad(double deg) => deg * Math.PI / 180.0;
    }
}
