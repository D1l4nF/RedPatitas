using CapaDatos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocios
{
    public static class CN_AdopcionService
    {
        private static readonly DataClasses1DataContext db = new DataClasses1DataContext();

        // SOLICITAR ADOPCIÓN
       
        public static bool SolicitarAdopcion(int idMascota, int idUsuario)
        {
            bool existeSolicitud = db.tbl_SolicitudesAdopcion
                .Any(s => s.sol_IdMascota == idMascota
                       && s.sol_Estado == "Pendiente");

            if (existeSolicitud)
                return false;

            tbl_SolicitudesAdopcion solicitud = new tbl_SolicitudesAdopcion
            {
                sol_IdMascota = idMascota,
                sol_IdUsuario = idUsuario,
                sol_FechaSolicitud = DateTime.Now,
                sol_Estado = "Pendiente"
            };

            db.tbl_SolicitudesAdopcion.InsertOnSubmit(solicitud);

            var mascota = db.tbl_Mascotas
                .First(m => m.mas_IdMascota == idMascota);

            mascota.mas_EstadoAdopcion = "EnProceso";

            db.SubmitChanges();
            return true;
        }
        // MIS SOLICITUDES (USUARIO)
        public static List<vw_SolicitudesCompleta> MisSolicitudes(int idUsuario)
        {
            return db.vw_SolicitudesCompleta
                .Where(s => s.IdAdoptante == idUsuario)
                .OrderByDescending(s => s.sol_FechaSolicitud)
                .ToList();
        }
        // SOLICITUDES RECIBIDAS (REFUGIO)

        public static  List<vw_SolicitudesCompleta> SolicitudesRecibidas(int idRefugio)
        {
            return db.vw_SolicitudesCompleta
                .Where(s => s.ref_IdRefugio == idRefugio
                         && s.sol_Estado == "Pendiente")
                .ToList();
        }


        // APROBAR

        public static void Aprobar(int idSolicitud)
        {
            var solicitud = db.tbl_SolicitudesAdopcion
                .First(s => s.sol_IdSolicitud == idSolicitud);

            solicitud.sol_Estado = "Aprobada";

            var mascota = db.tbl_Mascotas
                .First(m => m.mas_IdMascota == solicitud.sol_IdMascota);

            mascota.mas_EstadoAdopcion = "Adoptado";

            db.SubmitChanges();
        }

        // RECHAZAR

        public static void Rechazar(int idSolicitud, string comentario)
        {
            var solicitud = db.tbl_SolicitudesAdopcion
                .First(s => s.sol_IdSolicitud == idSolicitud);

            solicitud.sol_Estado = "Rechazada";
            solicitud.sol_ComentariosRevision = comentario;

            var mascota = db.tbl_Mascotas
                .First(m => m.mas_IdMascota == solicitud.sol_IdMascota);

            mascota.mas_EstadoAdopcion = "Disponible";

            db.SubmitChanges();
        }
        // OBTENER MASCOTAS DISPONIBLES CON FILTROS
        public static List<vw_MascotasCompleta> ObtenerMascotasDisponibles(
            string especie = null,
            string ubicacion = null,
            string tamano = null,
            string sexo = null,
            string edadAproximada = null,
            bool? esterilizado = null,
            bool? vacunado = null)
        {
            var query = db.vw_MascotasCompleta
                .Where(m => m.mas_EstadoAdopcion == "Disponible");

            // Aplicar filtros si se especifican
            if (!string.IsNullOrEmpty(especie) && especie != "todas")
            {
                query = query.Where(m => m.Especie == especie);
            }

            if (!string.IsNullOrEmpty(ubicacion) && ubicacion != "todas")
            {
                query = query.Where(m => m.CiudadRefugio.Contains(ubicacion));
            }

            if (!string.IsNullOrEmpty(tamano) && tamano != "todos")
            {
                query = query.Where(m => m.mas_Tamano == tamano);
            }

            if (!string.IsNullOrEmpty(sexo) && sexo != "todos")
            {
                query = query.Where(m => m.mas_Sexo.HasValue && m.mas_Sexo.Value.ToString().Equals(sexo, StringComparison.OrdinalIgnoreCase));
            }

            if (!string.IsNullOrEmpty(edadAproximada) && edadAproximada != "todas")
            {
                query = query.Where(m => m.mas_EdadAproximada == edadAproximada);
            }

            if (esterilizado.HasValue)
            {
                query = query.Where(m => m.mas_Esterilizado == esterilizado.Value);
            }

            if (vacunado.HasValue)
            {
                query = query.Where(m => m.mas_Vacunado == vacunado.Value);
            }

            return query.OrderByDescending(m => m.mas_FechaRegistro).ToList();
        }

        // OBTENER ESPECIES DISPONIBLES
        public static List<string> ObtenerEspeciesDisponibles()
        {
            return db.vw_MascotasCompleta
                .Where(m => m.mas_EstadoAdopcion == "Disponible")
                .Select(m => m.Especie)
                .Distinct()
                .Where(e => !string.IsNullOrEmpty(e))
                .OrderBy(e => e)
                .ToList();
        }

        // OBTENER UBICACIONES DISPONIBLES
        public static List<string> ObtenerUbicacionesDisponibles()
        {
            return db.vw_MascotasCompleta
                .Where(m => m.mas_EstadoAdopcion == "Disponible")
                .Select(m => m.CiudadRefugio)
                .Distinct()
                .Where(u => !string.IsNullOrEmpty(u))
                .OrderBy(u => u)
                .ToList();
        }

        // OBTENER TAMAÑOS DISPONIBLES
        public static List<string> ObtenerTamanosDisponibles()
        {
            return db.vw_MascotasCompleta
                .Where(m => m.mas_EstadoAdopcion == "Disponible")
                .Select(m => m.mas_Tamano)
                .Distinct()
                .Where(t => !string.IsNullOrEmpty(t))
                .OrderBy(t => t)
                .ToList();
        }

        // OBTENER EDADES APROXIMADAS DISPONIBLES
        public static List<string> ObtenerEdadesAproximadasDisponibles()
        {
            return db.vw_MascotasCompleta
                .Where(m => m.mas_EstadoAdopcion == "Disponible")
                .Select(m => m.mas_EdadAproximada)
                .Distinct()
                .Where(e => !string.IsNullOrEmpty(e))
                .OrderBy(e => e)
                .ToList();
        }

        // OBTENER RAZAS DISPONIBLES POR ESPECIE
        public static List<string> ObtenerRazasPorEspecie(string especie)
        {
            return db.vw_MascotasCompleta
                .Where(m => m.mas_EstadoAdopcion == "Disponible" && m.Especie == especie)
                .Select(m => m.Raza)
                .Distinct()
                .Where(r => !string.IsNullOrEmpty(r))
                .OrderBy(r => r)
                .ToList();
        }

        // VERIFICAR SI USUARIO YA TIENE SOLICITUD PENDIENTE
        public static bool TieneSolicitudPendiente(int idMascota, int idUsuario)
        {
            return db.tbl_SolicitudesAdopcion
                .Any(s => s.sol_IdMascota == idMascota
                       && s.sol_IdUsuario == idUsuario
                       && s.sol_Estado == "Pendiente");
        }

        // OBTENER DETALLE DE MASCOTA POR ID
        public static vw_MascotasCompleta ObtenerMascotaPorId(int idMascota)
        {
            return db.vw_MascotasCompleta
                .FirstOrDefault(m => m.mas_IdMascota == idMascota);
        }

        // CONVERTIR EDAD EN MESES A TEXTO LEGIBLE
        public static string ObtenerEdadTexto(int? edadMeses)
        {
            if (!edadMeses.HasValue) return "Edad no especificada";

            if (edadMeses < 12)
            {
                return $"{edadMeses} mes{(edadMeses != 1 ? "es" : "")}";
            }
            else
            {
                int años = edadMeses.Value / 12;
                int meses = edadMeses.Value % 12;

                if (meses == 0)
                {
                    return $"{años} año{(años != 1 ? "s" : "")}";
                }
                else
                {
                    return $"{años} año{(años != 1 ? "s" : "")} y {meses} mes{(meses != 1 ? "es" : "")}";
                }
            }
        }

        // OBTENER ICONO SEGÚN ESPECIE
        public static string ObtenerIconoEspecie(string especie)
        {
            if (string.IsNullOrEmpty(especie))
                return "fas fa-paw";

            string especieLower = especie.ToLower();
            if (especieLower == "perro" || especieLower == "canino")
                return "fas fa-dog";
            if (especieLower == "gato" || especieLower == "felino")
                return "fas fa-cat";
            if (especieLower == "ave")
                return "fas fa-dove";
            if (especieLower == "conejo")
                return "fas fa-paw";
            if (especieLower == "roedor")
                return "fas fa-otter";
            return "fas fa-paw";
        }

        // OBTENER ICONO SEGÚN SEXO
        public static string ObtenerIconoSexo(string sexo)
        {
            if (string.IsNullOrEmpty(sexo))
                return "fas fa-genderless text-secondary";

            string sexoUpper = sexo.ToUpper();
            if (sexoUpper == "M" || sexoUpper == "MACHO")
                return "fas fa-mars text-primary";
            if (sexoUpper == "F" || sexoUpper == "HEMBRA")
                return "fas fa-venus text-pink";
            return "fas fa-genderless text-secondary";
        }

        // OBTENER TEXTO PARA SEXO
        public static string ObtenerTextoSexo(string sexo)
        {
            if (string.IsNullOrEmpty(sexo))
                return "No especificado";

            string sexoUpper = sexo.ToUpper();
            if (sexoUpper == "M" || sexoUpper == "MACHO")
                return "Macho";
            if (sexoUpper == "F" || sexoUpper == "HEMBRA")
                return "Hembra";
            return "No especificado";
        }
    }

}
