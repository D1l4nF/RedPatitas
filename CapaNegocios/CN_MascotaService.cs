using System;
using System.Collections.Generic;
using System.Linq;
using CapaDatos;

namespace CapaNegocios
{
    /// <summary>
    /// Servicio para gestión de mascotas
    /// </summary>
    public class CN_MascotaService
    {
        /// <summary>
        /// Obtiene las mascotas disponibles para adopción
        /// </summary>
        /// <returns>Lista de mascotas con estado "Disponible"</returns>
        public List<MascotaDTO> ObtenerMascotasDisponibles()
        {
            using (var db = new DataClasses1DataContext())
            {
                var mascotas = (from m in db.tbl_Mascotas
                               where m.mas_Estado == true && m.mas_EstadoAdopcion == "Disponible"
                               let especie = m.tbl_Razas != null && m.tbl_Razas.tbl_Especies != null 
                                             ? m.tbl_Razas.tbl_Especies.esp_Nombre 
                                             : "Otro"
                               let raza = m.tbl_Razas != null ? m.tbl_Razas.raz_Nombre : "Mestizo"
                               let fotoPrincipal = m.tbl_FotosMascotas
                                                    .Where(f => f.fot_EsPrincipal == true)
                                                    .Select(f => f.fot_Url)
                                                    .FirstOrDefault()
                               select new MascotaDTO
                               {
                                   IdMascota = m.mas_IdMascota,
                                   Nombre = m.mas_Nombre,
                                   Especie = especie,
                                   Raza = raza,
                                   Edad = m.mas_Edad,
                                   EdadAproximada = m.mas_EdadAproximada ?? "Adulto",
                                   Sexo = m.mas_Sexo.HasValue ? (m.mas_Sexo.Value == 'M' ? "Macho" : "Hembra") : "Desconocido",
                                   Tamano = m.mas_Tamano ?? "Mediano",
                                   Color = m.mas_Color,
                                   Descripcion = m.mas_Descripcion,
                                   Vacunado = m.mas_Vacunado == true,
                                   Esterilizado = m.mas_Esterilizado == true,
                                   Desparasitado = m.mas_Desparasitado == true,
                                   EstadoAdopcion = m.mas_EstadoAdopcion,
                                   NombreRefugio = m.tbl_Refugios.ref_Nombre,
                                   CiudadRefugio = m.tbl_Refugios.ref_Ciudad ?? "Ecuador",
                                   FotoPrincipal = fotoPrincipal,
                                   FechaRegistro = m.mas_FechaRegistro
                               }).ToList();

                return mascotas;
            }
        }

        /// <summary>
        /// Obtiene una mascota por su ID
        /// </summary>
        public MascotaDTO ObtenerMascotaPorId(int idMascota)
        {
            using (var db = new DataClasses1DataContext())
            {
                var m = db.tbl_Mascotas.FirstOrDefault(x => x.mas_IdMascota == idMascota && x.mas_Estado == true);
                
                if (m == null) return null;

                string especie = m.tbl_Razas != null && m.tbl_Razas.tbl_Especies != null
                                 ? m.tbl_Razas.tbl_Especies.esp_Nombre
                                 : "Otro";
                string raza = m.tbl_Razas != null ? m.tbl_Razas.raz_Nombre : "Mestizo";
                string fotoPrincipal = m.tbl_FotosMascotas
                                        .Where(f => f.fot_EsPrincipal == true)
                                        .Select(f => f.fot_Url)
                                        .FirstOrDefault();

                return new MascotaDTO
                {
                    IdMascota = m.mas_IdMascota,
                    Nombre = m.mas_Nombre,
                    Especie = especie,
                    Raza = raza,
                    Edad = m.mas_Edad,
                    EdadAproximada = m.mas_EdadAproximada ?? "Adulto",
                    Sexo = m.mas_Sexo.HasValue ? (m.mas_Sexo.Value == 'M' ? "Macho" : "Hembra") : "Desconocido",
                    Tamano = m.mas_Tamano ?? "Mediano",
                    Color = m.mas_Color,
                    Descripcion = m.mas_Descripcion,
                    Temperamento = m.mas_Temperamento,
                    Vacunado = m.mas_Vacunado == true,
                    Esterilizado = m.mas_Esterilizado == true,
                    Desparasitado = m.mas_Desparasitado == true,
                    NecesidadesEspeciales = m.mas_NecesidadesEspeciales,
                    EstadoAdopcion = m.mas_EstadoAdopcion,
                    NombreRefugio = m.tbl_Refugios.ref_Nombre,
                    CiudadRefugio = m.tbl_Refugios.ref_Ciudad ?? "Ecuador",
                    FotoPrincipal = fotoPrincipal,
                    FechaRegistro = m.mas_FechaRegistro
                };
            }
        }

        /// <summary>
        /// Filtra mascotas por tipo, edad y tamaño
        /// </summary>
        public List<MascotaDTO> FiltrarMascotas(string tipo, string edad, string tamano)
        {
            using (var db = new DataClasses1DataContext())
            {
                var query = from m in db.tbl_Mascotas
                           where m.mas_Estado == true && m.mas_EstadoAdopcion == "Disponible"
                           select m;

                // Filtro por tipo (especie)
                if (!string.IsNullOrEmpty(tipo))
                {
                    query = query.Where(m => m.tbl_Razas != null && 
                                            m.tbl_Razas.tbl_Especies != null && 
                                            m.tbl_Razas.tbl_Especies.esp_Nombre.ToLower() == tipo.ToLower());
                }

                // Filtro por edad aproximada
                if (!string.IsNullOrEmpty(edad))
                {
                    query = query.Where(m => m.mas_EdadAproximada != null && 
                                            m.mas_EdadAproximada.ToLower() == edad.ToLower());
                }

                // Filtro por tamaño
                if (!string.IsNullOrEmpty(tamano))
                {
                    query = query.Where(m => m.mas_Tamano != null && 
                                            m.mas_Tamano.ToLower() == tamano.ToLower());
                }

                var mascotas = (from m in query
                               let especie = m.tbl_Razas != null && m.tbl_Razas.tbl_Especies != null
                                             ? m.tbl_Razas.tbl_Especies.esp_Nombre
                                             : "Otro"
                               let raza = m.tbl_Razas != null ? m.tbl_Razas.raz_Nombre : "Mestizo"
                               let fotoPrincipal = m.tbl_FotosMascotas
                                                    .Where(f => f.fot_EsPrincipal == true)
                                                    .Select(f => f.fot_Url)
                                                    .FirstOrDefault()
                               select new MascotaDTO
                               {
                                   IdMascota = m.mas_IdMascota,
                                   Nombre = m.mas_Nombre,
                                   Especie = especie,
                                   Raza = raza,
                                   Edad = m.mas_Edad,
                                   EdadAproximada = m.mas_EdadAproximada ?? "Adulto",
                                   Sexo = m.mas_Sexo.HasValue ? (m.mas_Sexo.Value == 'M' ? "Macho" : "Hembra") : "Desconocido",
                                   Tamano = m.mas_Tamano ?? "Mediano",
                                   Color = m.mas_Color,
                                   Vacunado = m.mas_Vacunado == true,
                                   Esterilizado = m.mas_Esterilizado == true,
                                   EstadoAdopcion = m.mas_EstadoAdopcion,
                                   NombreRefugio = m.tbl_Refugios.ref_Nombre,
                                   CiudadRefugio = m.tbl_Refugios.ref_Ciudad ?? "Ecuador",
                                   FotoPrincipal = fotoPrincipal,
                                   FechaRegistro = m.mas_FechaRegistro
                               }).ToList();

                return mascotas;
            }
        }

        /// <summary>
        /// Obtiene el emoji correspondiente a la especie
        /// </summary>
        public static string ObtenerEmojiEspecie(string especie)
        {
            switch (especie?.ToLower())
            {
                case "perro": return "🐕";
                case "gato": return "🐱";
                case "conejo": return "🐰";
                case "ave": return "🐦";
                case "hámster": return "🐹";
                default: return "🐾";
            }
        }

        /// <summary>
        /// Formatea la edad para mostrar
        /// </summary>
        public static string FormatearEdad(int? edadMeses, string edadAproximada)
        {
            if (edadMeses.HasValue)
            {
                if (edadMeses < 12)
                    return $"{edadMeses} meses";
                else
                    return $"{edadMeses / 12} años";
            }
            return edadAproximada ?? "Desconocida";
        }
    }

    /// <summary>
    /// DTO para transferencia de datos de mascotas
    /// </summary>
    public class MascotaDTO
    {
        public int IdMascota { get; set; }
        public string Nombre { get; set; }
        public string Especie { get; set; }
        public string Raza { get; set; }
        public int? Edad { get; set; }
        public string EdadAproximada { get; set; }
        public string Sexo { get; set; }
        public string Tamano { get; set; }
        public string Color { get; set; }
        public string Descripcion { get; set; }
        public string Temperamento { get; set; }
        public bool Vacunado { get; set; }
        public bool Esterilizado { get; set; }
        public bool Desparasitado { get; set; }
        public string NecesidadesEspeciales { get; set; }
        public string EstadoAdopcion { get; set; }
        public string NombreRefugio { get; set; }
        public string CiudadRefugio { get; set; }
        public string FotoPrincipal { get; set; }
        public DateTime? FechaRegistro { get; set; }

        /// <summary>
        /// Obtiene el emoji correspondiente a la especie
        /// </summary>
        public string EmojiEspecie
        {
            get { return CN_MascotaService.ObtenerEmojiEspecie(Especie); }
        }

        /// <summary>
        /// Edad formateada para mostrar
        /// </summary>
        public string EdadFormateada
        {
            get { return CN_MascotaService.FormatearEdad(Edad, EdadAproximada); }
        }

        /// <summary>
        /// Indica si la mascota es nueva (registrada en los últimos 7 días)
        /// </summary>
        public bool EsNueva
        {
            get { return FechaRegistro.HasValue && (DateTime.Now - FechaRegistro.Value).TotalDays <= 7; }
        }
    }
}
