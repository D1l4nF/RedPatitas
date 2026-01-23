using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CapaDatos;

namespace CapaNegocios
{
    public class CN_RefugioService
    {
        public class RefugioAliadoDTO
        {
            // Campos básicos existentes
            public int IdRefugio { get; set; }
            public string Nombre { get; set; }
            public string LogoUrl { get; set; }
            public string Ciudad { get; set; }
            public string Descripcion { get; set; }
            public string Telefono { get; set; }
            public string Direccion { get; set; }
            public decimal? Latitud { get; set; }
            public decimal? Longitud { get; set; }
            
            // Campos existentes adicionales
            public string Email { get; set; }
            public DateTime? FechaRegistro { get; set; }
            
            // Nuevos campos de redes sociales y donación
            public string FacebookUrl { get; set; }
            public string InstagramUrl { get; set; }
            public string HorarioAtencion { get; set; }
            public string CuentaDonacion { get; set; }
            
            // Estadísticas calculadas
            public int MascotasAdoptadas { get; set; }
            public int MascotasDisponibles { get; set; }
            
            // Propiedad calculada: Año de fundación
            public int? AnioFundacion => FechaRegistro?.Year;
        }

        /// <summary>
        /// Obtiene la lista de refugios verificados para mostrar como aliados
        /// Incluye estadísticas calculadas de mascotas
        /// </summary>
        public List<RefugioAliadoDTO> ObtenerRefugiosAliados()
        {
            using (var db = new DataClasses1DataContext())
            {
                var refugios = db.tbl_Refugios
                    .Where(r => r.ref_Verificado == true && r.ref_Estado == true)
                    .Select(r => new RefugioAliadoDTO
                    {
                        IdRefugio = r.ref_IdRefugio,
                        Nombre = r.ref_Nombre,
                        LogoUrl = r.ref_LogoUrl,
                        Ciudad = r.ref_Ciudad,
                        Descripcion = r.ref_Descripcion,
                        Telefono = r.ref_Telefono,
                        Direccion = r.ref_Direccion,
                        Latitud = r.ref_Latitud,
                        Longitud = r.ref_Longitud,
                        Email = r.ref_Email,
                        FechaRegistro = r.ref_FechaRegistro,
                        FacebookUrl = r.ref_FacebookUrl,
                        InstagramUrl = r.ref_InstagramUrl,
                        HorarioAtencion = r.ref_HorarioAtencion,
                        CuentaDonacion = r.ref_CuentaDonacion
                    })
                    .ToList();

                // Calcular estadísticas de mascotas para cada refugio
                foreach (var refugio in refugios)
                {
                    refugio.MascotasAdoptadas = db.tbl_Mascotas
                        .Count(m => m.mas_IdRefugio == refugio.IdRefugio 
                                 && m.mas_EstadoAdopcion == "Adoptado" 
                                 && m.mas_Estado == true);
                    
                    refugio.MascotasDisponibles = db.tbl_Mascotas
                        .Count(m => m.mas_IdRefugio == refugio.IdRefugio 
                                 && m.mas_EstadoAdopcion == "Disponible" 
                                 && m.mas_Estado == true);
                }

                return refugios;
            }
        }
    }
}

