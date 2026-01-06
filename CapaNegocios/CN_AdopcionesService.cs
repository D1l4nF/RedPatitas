using CapaDatos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocios
{
    public class CN_AdopcionesService
    {
        private CD_Adopciones datos = new CD_Adopciones();

        public void SolicitarAdopcion(int idMascota, int idUsuario, string comentario)
        {
            tbl_SolicitudesAdopcion solicitud = new tbl_SolicitudesAdopcion
            {
                sol_IdMascota = idMascota,
                sol_IdUsuario = idUsuario,
                sol_Comentarios = comentario
            };

            datos.CrearSolicitud(solicitud);
        }

        // Acción: MisSolicitudes (usuario)
        public List<tbl_SolicitudesAdopcion> MisSolicitudes(int idUsuario)
        {
            return datos.ObtenerSolicitudesPorUsuario(idUsuario);
        }

        // Acción: SolicitudesRecibidas (refugio)
        public List<tbl_SolicitudesAdopcion> SolicitudesRecibidas(int idRefugio)
        {
            return datos.ObtenerSolicitudesPorRefugio(idRefugio);
        }

        // Acción: Aprobar
        public void Aprobar(int idSolicitud, int idUsuarioRevision)
        {
            datos.AprobarSolicitud(idSolicitud, idUsuarioRevision);
        }

        // Acción: Rechazar
        public void Rechazar(int idSolicitud, string comentario, int idUsuarioRevision)
        {
            datos.RechazarSolicitud(idSolicitud, comentario, idUsuarioRevision);
        }
        public void CancelarSolicitud(int idSolicitud)
        {
            datos.CancelarSolicitud(idSolicitud);
        }
        public List<vw_SolicitudesCompleta> HistorialSolicitudes(int idUsuario)
        {
            return datos.ObtenerHistorialUsuario(idUsuario);
        }





    }

}
