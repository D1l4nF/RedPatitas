using System;
using System.Collections.Generic;
using System.Linq;
using CapaDatos;

namespace CapaNegocios
{
    public class CN_SeguimientoService
    {
        private DataClasses1DataContext db = new DataClasses1DataContext();

        // ======================================================================
        // 1. OBTENER INFORMACIÓN (Para Adoptantes y Refugios)
        // ======================================================================

        /// <summary>
        /// Obtiene la lista de seguimientos pendientes/disponibles para un Adoptante específico.
        /// </summary>
        public List<SeguimientoDTO> ObtenerSeguimientosPorAdoptante(int idMascota, int idAdoptante)
        {
            try
            {
                // AUTOSANACIÓN: Generar cronogramas faltantes para adopciones antiguas
                var solicitudesAprobadasSinSeg = db.tbl_SolicitudesAdopcion
                    .Where(s => s.sol_IdUsuario == idAdoptante && s.sol_Estado == "Aprobada" &&
                          !db.tbl_SeguimientosAdopcion.Any(seg => seg.seg_IdSolicitud == s.sol_IdSolicitud))
                    .ToList();

                foreach (var sol in solicitudesAprobadasSinSeg)
                {
                    db.sp_ProgramarSeguimientosAdopcion(sol.sol_IdSolicitud);
                }

                var seguimientosQuery = from seg in db.tbl_SeguimientosAdopcion
                                        join sol in db.tbl_SolicitudesAdopcion on seg.seg_IdSolicitud equals sol.sol_IdSolicitud
                                        join mas in db.tbl_Mascotas on sol.sol_IdMascota equals mas.mas_IdMascota
                                        where sol.sol_IdUsuario == idAdoptante
                                        select new
                                        {
                                            seg,
                                            mas,
                                            fot_Url = mas.tbl_FotosMascotas.Where(f => f.fot_EsPrincipal == true).Select(f => f.fot_Url).FirstOrDefault()
                                        };

                if (idMascota > 0)
                {
                    seguimientosQuery = seguimientosQuery.Where(x => x.mas.mas_IdMascota == idMascota);
                }

                var seguimientos = seguimientosQuery
                                    .OrderBy(x => x.seg.seg_FechaProgramada)
                                    .Select(x => new SeguimientoDTO
                                    {
                                        IdSeguimiento = x.seg.seg_IdSeguimiento,
                                        Etapa = x.seg.seg_NumeroEtapa,
                                        Titulo = x.seg.seg_TituloEtapa,
                                        NombreMascota = x.mas.mas_Nombre,
                                        FotoMascota = x.fot_Url != null
                                            ? (x.fot_Url.StartsWith("http") ? x.fot_Url : (x.fot_Url.StartsWith("~/") ? x.fot_Url : (x.fot_Url.StartsWith("/") ? "~" + x.fot_Url : "~/Images/Mascotas/" + x.fot_Url)))
                                            : "https://ui-avatars.com/api/?name=" + x.mas.mas_Nombre + "&background=FF8C42&color=fff",
                                        FechaProgramada = x.seg.seg_FechaProgramada,
                                        Estado = x.seg.seg_Estado,
                                        DiferenciaDias = (x.seg.seg_FechaProgramada - DateTime.Now).Days
                                    }).ToList();

                return seguimientos;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al cargar el historial de seguimientos: " + ex.Message);
            }
        }

        /// <summary>
        /// Obtiene los detalles completos de un seguimiento específico (para armar el formulario).
        /// </summary>
        public tbl_SeguimientosAdopcion ObtenerDetalleSeguimiento(int idSeguimiento)
        {
            return db.tbl_SeguimientosAdopcion.FirstOrDefault(s => s.seg_IdSeguimiento == idSeguimiento);
        }

        /// <summary>
        /// (Para Refugios) Obtiene los seguimientos "Enviados" por los adoptantes, listos para ser revisados por el staff del refugio.
        /// </summary>
        public object ObtenerAuditoriasPendientesRefugio(int idRefugio)
        {
            try
            {
                var auditorias = (from seg in db.tbl_SeguimientosAdopcion
                                  join sol in db.tbl_SolicitudesAdopcion on seg.seg_IdSolicitud equals sol.sol_IdSolicitud
                                  join mas in db.tbl_Mascotas on sol.sol_IdMascota equals mas.mas_IdMascota
                                  join u in db.tbl_Usuarios on sol.sol_IdUsuario equals u.usu_IdUsuario
                                  where mas.mas_IdRefugio == idRefugio && seg.seg_Estado == "Enviado"
                                  orderby seg.seg_FechaEnvio ascending
                                  select new
                                  {
                                      IdSeguimiento = seg.seg_IdSeguimiento,
                                      Adoptante = u.usu_Nombre + " " + u.usu_Apellido,
                                      Mascota = mas.mas_Nombre,
                                      Etapa = seg.seg_TituloEtapa,
                                      FechaEnvio = seg.seg_FechaEnvio,
                                      RespuestasJSON = seg.seg_RespuestasJSON
                                  }).ToList();

                return auditorias;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al cargar la bandeja de auditorías de seguimiento: " + ex.Message);
            }
        }


        // ======================================================================
        // 2. ACCIONES DEL ADOPTANTE
        // ======================================================================

        /// <summary>
        /// Llama al SC sp_EnviarSeguimiento para guardar la evaluación en la base de datos con las coordenadas GPS.
        /// </summary>
        public bool EnviarFormularioSeguimiento(int idSeguimiento, decimal latitud, decimal longitud, string fotoUrl, string urlArchivoAdjunto, string respuestasJson)
        {
            try
            {
                // Usamos el Stored Procedure creado en la base de datos
                var rpt = db.sp_EnviarSeguimiento(idSeguimiento, latitud, longitud, fotoUrl, urlArchivoAdjunto, respuestasJson);

                // NOTIFICACIÓN: Seguimiento enviado para el refugio
                var segInfo = (from s in db.tbl_SeguimientosAdopcion
                               join sol in db.tbl_SolicitudesAdopcion on s.seg_IdSolicitud equals sol.sol_IdSolicitud
                               join m in db.tbl_Mascotas on sol.sol_IdMascota equals m.mas_IdMascota
                               where s.seg_IdSeguimiento == idSeguimiento
                               select new { m.mas_IdRefugio, m.mas_Nombre }).FirstOrDefault();

                if (segInfo != null)
                {
                    var adminsRefugio = CN_NotificacionService.ObtenerUsuariosRefugio(segInfo.mas_IdRefugio);
                    foreach(int adminId in adminsRefugio)
                    {
                        CN_NotificacionService.Crear(adminId, "Seguimiento Recibido", $"Se ha recibido el formulario de seguimiento para {segInfo.mas_Nombre}.", "Seguimiento", "/AdminRefugio/AuditoriaSeguimientos.aspx", "fas fa-clipboard-check");
                    }
                }

                return true;
            }
            catch (Exception ex)
            {
                throw new Exception("Hubo un error al remitir su formulario de seguimiento: " + ex.Message);
            }
        }

        /// <summary>
        /// Llama al SC de emergencia para el botón SOS.
        /// </summary>
        public bool SolicitarDevolucionMascota(int idSolicitud, string motivo, int idUsuarioSolicitante)
        {
            try
            {
                db.sp_SolicitarDevolucion(idSolicitud, motivo, idUsuarioSolicitante);
                return true;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al procesar la alerta de devolución: " + ex.Message);
            }
        }


        // ======================================================================
        // 3. ACCIONES DEL REFUGIO (Auditoría)
        // ======================================================================

        /// <summary>
        /// Llama al SC para procesar el veredicto del Refugio sobre el cuestionario enviado por el adoptante.
        /// </summary>
        public bool AuditarSeguimiento(int idSeguimiento, int idUsuarioRevision, string nuevoEstado, string comentarios)
        {
            try
            {
                // nuevoEstado = "Aprobado" ó "Rechazado" (Que significa corregir/repetir)
                db.sp_RevisarSeguimiento(idSeguimiento, idUsuarioRevision, nuevoEstado, comentarios);

                // NOTIFICACIÓN: Seguimiento revisado para el adoptante
                var segInfo = (from s in db.tbl_SeguimientosAdopcion
                               join sol in db.tbl_SolicitudesAdopcion on s.seg_IdSolicitud equals sol.sol_IdSolicitud
                               join m in db.tbl_Mascotas on sol.sol_IdMascota equals m.mas_IdMascota
                               where s.seg_IdSeguimiento == idSeguimiento
                               select new { sol.sol_IdUsuario, m.mas_Nombre }).FirstOrDefault();

                if (segInfo != null)
                {
                    string mensaje = nuevoEstado == "Aprobado" ? $"Tu seguimiento para {segInfo.mas_Nombre} ha sido aprobado." : $"Tu seguimiento para {segInfo.mas_Nombre} requiere correcciones.";
                    CN_NotificacionService.Crear(segInfo.sol_IdUsuario, "Seguimiento Revisado", mensaje, "Seguimiento", "/Adoptante/MisSeguimientos.aspx", nuevoEstado == "Aprobado" ? "fas fa-check" : "fas fa-exclamation-triangle");
                }

                return true;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al guardar la revisión del formulario: " + ex.Message);
            }
        }

        /// <summary>
        /// (Opción Drástica) Confirmar el reingreso físico de la mascota al Refugio y aplicarla lista negra si la bandera "EsMaltrato" viene activada.
        /// </summary>
        public bool FinalizarYRevocarAdopcion(int idSolicitud, int idMascota, int idUsuarioAdmin, string motivoRefugio, bool esMaltrato)
        {
            try
            {
                db.sp_ConfirmarDevolucionRetorno(idSolicitud, idMascota, idUsuarioAdmin, motivoRefugio, esMaltrato);
                return true;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al ejecutar el protocolo de revocación de adopciones: " + ex.Message);
            }
        }

    }

    public class SeguimientoDTO
    {
        public int IdSeguimiento { get; set; }
        public int Etapa { get; set; }
        public string Titulo { get; set; }
        public string NombreMascota { get; set; }
        public string FotoMascota { get; set; }
        public DateTime FechaProgramada { get; set; }
        public string Estado { get; set; }
        public int DiferenciaDias { get; set; }
    }
}
