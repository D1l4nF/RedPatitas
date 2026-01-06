using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaDatos
{
        public class CD_Adopciones
        {
            DataClasses1DataContext db = new DataClasses1DataContext();

            public void SolicitarAdopcion(tbl_SolicitudesAdopcion solicitud)
            {
                db.tbl_SolicitudesAdopcion.InsertOnSubmit(solicitud);
                db.SubmitChanges();
            }

            public List<tbl_SolicitudesAdopcion> ObtenerSolicitudesPorUsuario(int idUsuario)
            {
                return db.tbl_SolicitudesAdopcion
                         .Where(s => s.sol_IdUsuario == idUsuario)
                         .ToList();
            }

            public List<tbl_SolicitudesAdopcion> ObtenerSolicitudesPorRefugio(int idRefugio)
            {
                return db.tbl_SolicitudesAdopcion
                         .Where(s => s.tbl_Mascotas.mas_IdRefugio == idRefugio)
                         .ToList();
            }

            public void AprobarSolicitud(int idSolicitud, int idUsuarioRevision)
            {
                var solicitud = db.tbl_SolicitudesAdopcion
                                  .FirstOrDefault(s => s.sol_IdSolicitud == idSolicitud);

                if (solicitud != null)
                {
                    solicitud.sol_Estado = "Aprobada";
                    solicitud.sol_IdUsuarioRevision = idUsuarioRevision;
                    solicitud.sol_FechaRevision = DateTime.Now;
                    db.SubmitChanges();
                }
            }

            public void RechazarSolicitud(int idSolicitud, string comentario, int idUsuarioRevision)
            {
                var solicitud = db.tbl_SolicitudesAdopcion
                                  .FirstOrDefault(s => s.sol_IdSolicitud == idSolicitud);

                if (solicitud != null)
                {
                    solicitud.sol_Estado = "Rechazada";
                    solicitud.sol_ComentariosRevision = comentario;
                    solicitud.sol_IdUsuarioRevision = idUsuarioRevision;
                    solicitud.sol_FechaRevision = DateTime.Now;
                    db.SubmitChanges();
                }
            }
            public bool ExisteSolicitudActiva(int idMascota)
            {
                return db.tbl_SolicitudesAdopcion.Any(s =>
                    s.sol_IdMascota == idMascota &&
                    (s.sol_Estado == "Pendiente" || s.sol_Estado == "EnProceso"));
            }
            public void CambiarEstadoMascota(int idMascota, string estado)
            {
                var mascota = db.tbl_Mascotas.FirstOrDefault(m => m.mas_IdMascota == idMascota);

                if (mascota != null)
                {
                    mascota.mas_EstadoAdopcion = estado;
                    db.SubmitChanges();
                }
            }

            public void RechazarSolicitudCompleta(int idSolicitud, string comentario, int idUsuarioRevision)
            {
                var solicitud = db.tbl_SolicitudesAdopcion
                                  .FirstOrDefault(s => s.sol_IdSolicitud == idSolicitud);

                if (solicitud != null)
                {
                    solicitud.sol_Estado = "Rechazada";
                    solicitud.sol_ComentariosRevision = comentario;
                    solicitud.sol_IdUsuarioRevision = idUsuarioRevision;
                    solicitud.sol_FechaRevision = DateTime.Now;

                    int idMascota = solicitud.sol_IdMascota;

                    bool quedanActivas = db.tbl_SolicitudesAdopcion.Any(s =>
                        s.sol_IdMascota == idMascota &&
                        (s.sol_Estado == "Pendiente" || s.sol_Estado == "EnProceso"));

                    if (!quedanActivas)
                    {
                        var mascota = db.tbl_Mascotas.FirstOrDefault(m => m.mas_IdMascota == idMascota);
                        if (mascota != null)
                            mascota.mas_EstadoAdopcion = "Disponible";
                    }

                    db.SubmitChanges();
                }
            }
            public void CrearSolicitud(tbl_SolicitudesAdopcion solicitud)
            {
                bool existe = db.tbl_SolicitudesAdopcion.Any(s =>
                    s.sol_IdMascota == solicitud.sol_IdMascota &&
                    (s.sol_Estado == "Pendiente" || s.sol_Estado == "EnProceso"));

                if (existe)
                    throw new Exception("La mascota ya tiene una solicitud activa.");

                solicitud.sol_Estado = "Pendiente";
                solicitud.sol_FechaSolicitud = DateTime.Now;

                db.tbl_SolicitudesAdopcion.InsertOnSubmit(solicitud);

                var mascota = db.tbl_Mascotas
                    .First(m => m.mas_IdMascota == solicitud.sol_IdMascota);

                mascota.mas_EstadoAdopcion = "EnProceso";

                db.SubmitChanges();
            }


    }

}
