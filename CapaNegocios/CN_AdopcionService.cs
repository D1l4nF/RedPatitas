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
        // SOLICITAR ADOPCIÓN

        public static bool SolicitarAdopcion(int idMascota, int idUsuario)
        {
            using (var db = new DataClasses1DataContext())
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
        }

        // MIS SOLICITUDES (USUARIO)
        public static List<SolicitudDTO> MisSolicitudes(int idUsuario)
        {
            using (var db = new DataClasses1DataContext())
            {
                return (from s in db.tbl_SolicitudesAdopcion
                        join m in db.tbl_Mascotas on s.sol_IdMascota equals m.mas_IdMascota
                        where s.sol_IdUsuario == idUsuario
                        orderby s.sol_FechaSolicitud descending
                        select new SolicitudDTO
                        {
                            IdSolicitud = s.sol_IdSolicitud,
                            IdMascota = s.sol_IdMascota,
                            NombreMascota = m.mas_Nombre,
                            IdAdoptante = s.sol_IdUsuario,
                            sol_FechaSolicitud = s.sol_FechaSolicitud,
                            Estado = s.sol_Estado,
                            Comentarios = s.sol_ComentariosRevision
                        }).ToList();
            }
        }

        // SOLICITUDES RECIBIDAS (REFUGIO)
        public static List<SolicitudDTO> SolicitudesRecibidas(int idRefugio)
        {
            using (var db = new DataClasses1DataContext())
            {
                return (from s in db.tbl_SolicitudesAdopcion
                        join m in db.tbl_Mascotas on s.sol_IdMascota equals m.mas_IdMascota
                        join u in db.tbl_Usuarios on s.sol_IdUsuario equals u.usu_IdUsuario
                        where m.mas_IdRefugio == idRefugio && s.sol_Estado == "Pendiente"
                        select new SolicitudDTO
                        {
                            sol_IdSolicitud = s.sol_IdSolicitud,
                            IdSolicitud = s.sol_IdSolicitud,
                            IdMascota = s.sol_IdMascota,
                            NombreMascota = m.mas_Nombre,
                            FotoMascota = m.tbl_FotosMascotas
                                .Where(f => f.fot_EsPrincipal == true)
                                .Select(f => f.fot_Url)
                                .FirstOrDefault() ?? "https://via.placeholder.com/80?text=🐾",
                            IdAdoptante = s.sol_IdUsuario,
                            NombreAdoptante = u.usu_Nombre,
                            ApellidoAdoptante = u.usu_Apellido ?? "",
                            sol_FechaSolicitud = s.sol_FechaSolicitud,
                            Estado = s.sol_Estado,
                            ref_IdRefugio = idRefugio
                        }).ToList();
            }
        }

        // OBTENER ADOPCIONES POR MES (para estadísticas)
        public static Dictionary<string, int> ObtenerAdopcionesPorMes(int idRefugio)
        {
            using (var db = new DataClasses1DataContext())
            {
                var resultado = new Dictionary<string, int>();
                var hoy = DateTime.Now;

                // Obtener los últimos 6 meses
                for (int i = 5; i >= 0; i--)
                {
                    var fecha = hoy.AddMonths(-i);
                    var mes = fecha.ToString("MMM yyyy");

                    var count = (from s in db.tbl_SolicitudesAdopcion
                                 join m in db.tbl_Mascotas on s.sol_IdMascota equals m.mas_IdMascota
                                 where m.mas_IdRefugio == idRefugio
                                       && s.sol_Estado == "Aprobada"
                                       && s.sol_FechaSolicitud.HasValue
                                       && s.sol_FechaSolicitud.Value.Month == fecha.Month
                                       && s.sol_FechaSolicitud.Value.Year == fecha.Year
                                 select s).Count();

                    resultado[mes] = count;
                }

                return resultado;
            }
        }

        // APROBAR
        public static void Aprobar(int idSolicitud)
        {
            using (var db = new DataClasses1DataContext())
            {
                var solicitud = db.tbl_SolicitudesAdopcion
                    .First(s => s.sol_IdSolicitud == idSolicitud);

                solicitud.sol_Estado = "Aprobada";

                var mascota = db.tbl_Mascotas
                    .First(m => m.mas_IdMascota == solicitud.sol_IdMascota);

                mascota.mas_EstadoAdopcion = "Adoptado";

                db.SubmitChanges();
            }
        }

        // RECHAZAR
        public static void Rechazar(int idSolicitud, string comentario)
        {
            using (var db = new DataClasses1DataContext())
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
        }

        // VERIFICAR SI USUARIO YA TIENE SOLICITUD PENDIENTE
        public static bool TieneSolicitudPendiente(int idMascota, int idUsuario)
        {
            using (var db = new DataClasses1DataContext())
            {
                return db.tbl_SolicitudesAdopcion
                    .Any(s => s.sol_IdMascota == idMascota
                           && s.sol_IdUsuario == idUsuario
                           && s.sol_Estado == "Pendiente");
            }
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

        // OBTENER ESPECIES DISPONIBLES
        public static List<string> ObtenerEspeciesDisponibles()
        {
            using (var db = new DataClasses1DataContext())
            {
                // Como no existe vista, usamos query sobre mascotas disponibles
                return db.tbl_Mascotas
                    .Where(m => m.mas_EstadoAdopcion == "Disponible" && m.mas_Estado == true && m.tbl_Razas != null && m.tbl_Razas.tbl_Especies != null)
                    .Select(m => m.tbl_Razas.tbl_Especies.esp_Nombre)
                    .Distinct()
                    .OrderBy(e => e)
                    .ToList();
            }
        }

        // OBTENER UBICACIONES DISPONIBLES
        public static List<string> ObtenerUbicacionesDisponibles()
        {
            using (var db = new DataClasses1DataContext())
            {
                return db.tbl_Mascotas
                    .Where(m => m.mas_EstadoAdopcion == "Disponible" && m.mas_Estado == true && m.tbl_Refugios != null)
                    .Select(m => m.tbl_Refugios.ref_Ciudad)
                    .Distinct()
                    .Where(c => !string.IsNullOrEmpty(c))
                    .OrderBy(c => c)
                    .ToList();
            }
        }

        // OBTENER TAMAÑOS DISPONIBLES
        public static List<string> ObtenerTamanosDisponibles()
        {
            using (var db = new DataClasses1DataContext())
            {
                return db.tbl_Mascotas
                    .Where(m => m.mas_EstadoAdopcion == "Disponible" && m.mas_Estado == true && m.mas_Tamano != null)
                    .Select(m => m.mas_Tamano)
                    .Distinct()
                    .OrderBy(t => t)
                    .ToList();
            }
        }

        // OBTENER EDADES APROXIMADAS DISPONIBLES
        public static List<string> ObtenerEdadesAproximadasDisponibles()
        {
            using (var db = new DataClasses1DataContext())
            {
                return db.tbl_Mascotas
                    .Where(m => m.mas_EstadoAdopcion == "Disponible" && m.mas_Estado == true && m.mas_EdadAproximada != null)
                    .Select(m => m.mas_EdadAproximada)
                    .Distinct()
                    .OrderBy(e => e)
                    .ToList();
            }
        }
        public static List<MascotaDisponibleDTO> ObtenerMascotasDisponibles(
            string especie = null,
            string ubicacion = null,
            string tamano = null,
            string sexo = null,
            string edadAproximada = null,
            bool? esterilizado = null,
            bool? vacunado = null)
        {
            using (var db = new DataClasses1DataContext())
            {
                var query = from m in db.tbl_Mascotas
                            where m.mas_EstadoAdopcion == "Disponible" && m.mas_Estado == true
                            select new
                            {
                                Mascota = m,
                                EspecieNombre = m.tbl_Razas != null && m.tbl_Razas.tbl_Especies != null ? m.tbl_Razas.tbl_Especies.esp_Nombre : "",
                                RazaNombre = m.tbl_Razas != null ? m.tbl_Razas.raz_Nombre : "",
                                RefugioNombre = m.tbl_Refugios != null ? m.tbl_Refugios.ref_Nombre : "",
                                Ciudad = m.tbl_Refugios != null ? m.tbl_Refugios.ref_Ciudad : "",
                                Foto = m.tbl_FotosMascotas.Where(f => f.fot_EsPrincipal == true).Select(f => f.fot_Url).FirstOrDefault()
                            };

                // Filtros
                if (!string.IsNullOrEmpty(especie) && especie != "Todas")
                    query = query.Where(x => x.EspecieNombre == especie);

                if (!string.IsNullOrEmpty(ubicacion) && ubicacion != "Todas")
                    query = query.Where(x => x.Ciudad == ubicacion);

                if (!string.IsNullOrEmpty(tamano) && tamano != "Todos")
                    query = query.Where(x => x.Mascota.mas_Tamano == tamano);

                if (!string.IsNullOrEmpty(sexo) && sexo != "Todos")
                {
                    char sexoChar = ' ';
                    if (sexo.Equals("Macho", StringComparison.OrdinalIgnoreCase) || sexo.Equals("M", StringComparison.OrdinalIgnoreCase))
                        sexoChar = 'M';
                    else if (sexo.Equals("Hembra", StringComparison.OrdinalIgnoreCase) || sexo.Equals("F", StringComparison.OrdinalIgnoreCase))
                        sexoChar = 'F';

                    if (sexoChar != ' ')
                        query = query.Where(x => x.Mascota.mas_Sexo == sexoChar);
                }

                if (!string.IsNullOrEmpty(edadAproximada) && edadAproximada != "Todas")
                    query = query.Where(x => x.Mascota.mas_EdadAproximada == edadAproximada);

                if (esterilizado.HasValue)
                    query = query.Where(x => x.Mascota.mas_Esterilizado == esterilizado.Value);

                if (vacunado.HasValue)
                    query = query.Where(x => x.Mascota.mas_Vacunado == vacunado.Value);

                return query.Select(x => new MascotaDisponibleDTO
                {
                    mas_IdMascota = x.Mascota.mas_IdMascota,
                    mas_Nombre = x.Mascota.mas_Nombre,
                    Especie = x.EspecieNombre,
                    Raza = x.RazaNombre,
                    mas_Sexo = x.Mascota.mas_Sexo.HasValue ? x.Mascota.mas_Sexo.Value.ToString() : "",
                    mas_Edad = x.Mascota.mas_Edad,
                    mas_EdadAproximada = x.Mascota.mas_EdadAproximada,
                    mas_Tamano = x.Mascota.mas_Tamano,
                    mas_Esterilizado = x.Mascota.mas_Esterilizado,
                    mas_Vacunado = x.Mascota.mas_Vacunado,
                    mas_Descripcion = x.Mascota.mas_Descripcion,
                    FotoPrincipal = x.Foto,
                    Refugio = x.RefugioNombre,
                    CiudadRefugio = x.Ciudad
                }).ToList();
            }
        }
    }

    /// <summary>
    /// DTO para transferencia de datos de solicitudes
    /// </summary>
    public class SolicitudDTO
    {
        public int sol_IdSolicitud { get; set; }  // Para la vista ASPX
        public int IdSolicitud { get; set; }
        public int IdMascota { get; set; }
        public string NombreMascota { get; set; }
        public string FotoMascota { get; set; }   // URL de la foto de la mascota
        public int IdAdoptante { get; set; }
        public string NombreAdoptante { get; set; }
        public string ApellidoAdoptante { get; set; }  // Apellido separado
        public DateTime? sol_FechaSolicitud { get; set; }
        public string Estado { get; set; }
        public string Comentarios { get; set; }
        public int ref_IdRefugio { get; set; }
    }

    public class MascotaDisponibleDTO
    {
        public int mas_IdMascota { get; set; }
        public string mas_Nombre { get; set; }
        public string Especie { get; set; }
        public string Raza { get; set; }
        public string mas_Sexo { get; set; }
        public int? mas_Edad { get; set; }
        public string mas_EdadAproximada { get; set; }
        public string mas_Tamano { get; set; }
        public bool? mas_Esterilizado { get; set; }
        public bool? mas_Vacunado { get; set; }
        public string mas_Descripcion { get; set; }
        public string FotoPrincipal { get; set; }
        public string Refugio { get; set; }
        public string CiudadRefugio { get; set; }
    }
}



