using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaDatos
{

    using System;
    using System.Collections.Generic;
    using System.Linq;

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
        }
    }

}
