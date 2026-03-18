using System;
using System.Collections.Generic;
using System.Linq;
using CapaDatos;

namespace CapaNegocios
{
    public static class CN_NotificacionService
    {
        public static bool Crear(int idUsuario, string titulo, string mensaje, string tipo, string urlAccion = null, string icono = null)
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    tbl_Notificaciones notificacion = new tbl_Notificaciones
                    {
                        not_IdUsuario = idUsuario,
                        not_Titulo = titulo,
                        not_Mensaje = mensaje,
                        not_Tipo = tipo,
                        not_Icono = icono,
                        not_UrlAccion = urlAccion,
                        not_Leida = false,
                        not_FechaCreacion = DateTime.Now
                    };

                    db.tbl_Notificaciones.InsertOnSubmit(notificacion);
                    db.SubmitChanges();
                    return true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al crear notificación: " + ex.Message);
                return false;
            }
        }

        public static List<NotificacionDTO> ObtenerPorUsuario(int idUsuario, bool soloNoLeidas = false)
        {
            using (var db = new DataClasses1DataContext())
            {
                var query = db.tbl_Notificaciones.Where(n => n.not_IdUsuario == idUsuario);
                
                if (soloNoLeidas)
                {
                    query = query.Where(n => n.not_Leida == false);
                }

                return query.OrderByDescending(n => n.not_FechaCreacion)
                            .Select(n => new NotificacionDTO
                            {
                                IdNotificacion = n.not_IdNotificacion,
                                Titulo = n.not_Titulo,
                                Mensaje = n.not_Mensaje,
                                Tipo = n.not_Tipo,
                                Icono = n.not_Icono,
                                UrlAccion = n.not_UrlAccion,
                                Leida = n.not_Leida ?? false,
                                FechaCreacion = n.not_FechaCreacion
                            }).ToList();
            }
        }

        public static int ContarNoLeidas(int idUsuario)
        {
            using (var db = new DataClasses1DataContext())
            {
                return db.tbl_Notificaciones.Count(n => n.not_IdUsuario == idUsuario && n.not_Leida == false);
            }
        }

        // GENERAR NOTIFICACIONES DE SEGUIMIENTOS PENDIENTES
        public static void GenerarNotificacionesSeguimientoPendientes(int idUsuario)
        {
            using (var db = new DataClasses1DataContext())
            {
                // Buscar seguimientos pendientes cuya fecha programada es <= hoy + 3 días
                var seguimientosProximos = (from s in db.tbl_SeguimientosAdopcion
                                            join sol in db.tbl_SolicitudesAdopcion on s.seg_IdSolicitud equals sol.sol_IdSolicitud
                                            join m in db.tbl_Mascotas on sol.sol_IdMascota equals m.mas_IdMascota
                                            where sol.sol_IdUsuario == idUsuario 
                                                  && s.seg_Estado == "Pendiente" 
                                                  && s.seg_FechaProgramada <= DateTime.Now.AddDays(3)
                                            select new { s.seg_IdSeguimiento, s.seg_FechaProgramada, m.mas_Nombre }).ToList();

                foreach (var seg in seguimientosProximos)
                {
                    // Verificar si ya se notificó sobre este seguimiento recientemente
                    bool yaNotificado = db.tbl_Notificaciones.Any(n => 
                        n.not_UrlAccion.Contains("/Adoptante/MisSeguimientos.aspx")
                        && n.not_IdUsuario == idUsuario 
                        && n.not_Titulo.Contains("Seguimiento Pendiente")
                        && n.not_FechaCreacion >= DateTime.Now.AddDays(-3));

                    if (!yaNotificado)
                    {
                        string dias = (seg.seg_FechaProgramada.Date - DateTime.Now.Date).Days <= 0 ? "hoy" : "pronto";
                        Crear(
                            idUsuario,
                            "Seguimiento Pendiente",
                            $"Recuerda que debes llenar el formulario de seguimiento de {seg.mas_Nombre} {dias}.",
                            "Seguimiento",
                            "/Adoptante/MisSeguimientos.aspx",
                            "fas fa-calendar-check"
                        );
                    }
                }
            }
        }

        public static bool MarcarComoLeida(int idNotificacion)
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var noti = db.tbl_Notificaciones.FirstOrDefault(n => n.not_IdNotificacion == idNotificacion);
                    if (noti != null)
                    {
                        noti.not_Leida = true;
                        noti.not_FechaLectura = DateTime.Now;
                        db.SubmitChanges();
                        return true;
                    }
                    return false;
                }
            }
            catch
            {
                return false;
            }
        }

        public static bool MarcarTodasComoLeidas(int idUsuario)
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var notificaciones = db.tbl_Notificaciones.Where(n => n.not_IdUsuario == idUsuario && n.not_Leida == false).ToList();
                    foreach (var n in notificaciones)
                    {
                        n.not_Leida = true;
                        n.not_FechaLectura = DateTime.Now;
                    }
                    db.SubmitChanges();
                    return true;
                }
            }
            catch
            {
                return false;
            }
        }

        public static List<int> ObtenerUsuariosRefugio(int idRefugio)
        {
            using (var db = new DataClasses1DataContext())
            {
                return db.tbl_Usuarios
                         .Where(u => u.usu_IdRefugio == idRefugio && u.usu_Estado == true && (u.usu_IdRol == 2 || u.usu_IdRol == 3))
                         .Select(u => u.usu_IdUsuario)
                         .ToList();
            }
        }
    }

    public class NotificacionDTO
    {
        public int IdNotificacion { get; set; }
        public string Titulo { get; set; }
        public string Mensaje { get; set; }
        public string Tipo { get; set; }
        public string Icono { get; set; }
        public string UrlAccion { get; set; }
        public bool Leida { get; set; }
        public DateTime? FechaCreacion { get; set; }
        public string TiempoRelativo
        {
            get
            {
                if (!FechaCreacion.HasValue) return "";
                var timeSpan = DateTime.Now - FechaCreacion.Value;
                if (timeSpan <= TimeSpan.FromSeconds(60)) return "Hace un momento";
                if (timeSpan <= TimeSpan.FromMinutes(60)) return $"Hace {timeSpan.Minutes} minutos";
                if (timeSpan <= TimeSpan.FromHours(24)) return $"Hace {timeSpan.Hours} horas";
                if (timeSpan <= TimeSpan.FromDays(30)) return $"Hace {timeSpan.Days} dias";
                return FechaCreacion.Value.ToString("dd/MM/yyyy");
            }
        }
    }
}
