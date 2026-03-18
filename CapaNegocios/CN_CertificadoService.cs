using System;
using System.Collections.Generic;
using System.Linq;
using CapaDatos;

namespace CapaNegocios
{
    public static class CN_CertificadoService
    {
        /// <summary>
        /// Genera el certificado de adopción invocando el Stored Procedure
        /// </summary>
        public static CertificadoResultado GenerarCertificado(int idSolicitud)
        {
            var resultado = new CertificadoResultado();
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    // Llama al SP que acabamos de crear
                    var spResult = db.sp_GenerarCertificadoAdopcion(idSolicitud).FirstOrDefault();
                    
                    if (spResult != null)
                    {
                        resultado.Exito = (spResult.Exito == 1);
                        resultado.Mensaje = spResult.Mensaje;
                        
                        // Obtener el código de certificado si fue exitoso
                        if (resultado.Exito)
                        {
                            var cert = db.tbl_CertificadosAdopcion.FirstOrDefault(c => c.cer_IdSolicitud == idSolicitud);
                            if (cert != null)
                            {
                                resultado.CodigoCertificado = cert.cer_CodigoCertificado;
                            }
                        }
                    }
                    else
                    {
                        resultado.Exito = false;
                        resultado.Mensaje = "No se obtuvo respuesta del proceso de generación.";
                    }
                }
            }
            catch (Exception ex)
            {
                resultado.Exito = false;
                resultado.Mensaje = "Error: " + ex.Message;
            }
            return resultado;
        }

        /// <summary>
        /// Obtiene un certificado para ser mostrado visualmente por su IdSolicitud
        /// </summary>
        public static CertificadoDTO ObtenerCertificadoPorSolicitud(int idSolicitud)
        {
            using (var db = new DataClasses1DataContext())
            {
                var c = db.tbl_CertificadosAdopcion.FirstOrDefault(cert => cert.cer_IdSolicitud == idSolicitud);
                if (c == null) return null;

                return ConvertToDTO(c);
            }
        }

        /// <summary>
        /// Obtiene un certificado para ser mostrado visualmente por su Código
        /// </summary>
        public static CertificadoDTO ObtenerCertificadoPorCodigo(string codigo)
        {
            using (var db = new DataClasses1DataContext())
            {
                var c = db.tbl_CertificadosAdopcion.FirstOrDefault(cert => cert.cer_CodigoCertificado == codigo);
                if (c == null) return null;

                return ConvertToDTO(c);
            }
        }

        /// <summary>
        /// Listado de todos los certificados emitidos en un refugio
        /// </summary>
        public static List<CertificadoDTO> ObtenerCertificadosPorRefugio(int idRefugio)
        {
            using (var db = new DataClasses1DataContext())
            {
                var query = from c in db.tbl_CertificadosAdopcion
                            join s in db.tbl_SolicitudesAdopcion on c.cer_IdSolicitud equals s.sol_IdSolicitud
                            join m in db.tbl_Mascotas on s.sol_IdMascota equals m.mas_IdMascota
                            where m.mas_IdRefugio == idRefugio
                            orderby c.cer_FechaEmision descending
                            select c;

                return query.AsEnumerable().Select(c => ConvertToDTO(c)).ToList();
            }
        }

        /// <summary>
        /// Obtiene el certificado más reciente de un adoptante
        /// </summary>
        public static CertificadoDTO ObtenerCertificadoMasRecientePorAdoptante(int idAdoptante)
        {
            using (var db = new DataClasses1DataContext())
            {
                var query = from c in db.tbl_CertificadosAdopcion
                            join s in db.tbl_SolicitudesAdopcion on c.cer_IdSolicitud equals s.sol_IdSolicitud
                            where s.sol_IdUsuario == idAdoptante
                            orderby c.cer_FechaEmision descending
                            select c;

                var cEntidad = query.FirstOrDefault();
                if (cEntidad == null) return null;

                return ConvertToDTO(cEntidad);
            }
        }

        /// <summary>
        /// Helper para mapear la entidad a DTO de presentación
        /// </summary>
        private static CertificadoDTO ConvertToDTO(tbl_CertificadosAdopcion c)
        {
            return new CertificadoDTO
            {
                IdCertificado = c.cer_IdCertificado,
                IdSolicitud = c.cer_IdSolicitud,
                CodigoCertificado = c.cer_CodigoCertificado,
                FechaEmision = c.cer_FechaEmision,
                NombreAdoptante = c.cer_NombreAdoptante,
                CedulaAdoptante = c.cer_CedulaAdoptante,
                NombreMascota = c.cer_NombreMascota,
                EspecieMascota = c.cer_EspecieMascota,
                RazaMascota = c.cer_RazaMascota,
                NombreRefugio = c.cer_NombreRefugio,
                Estado = c.cer_Estado
            };
        }
    }

    public class CertificadoResultado
    {
        public bool Exito { get; set; }
        public string Mensaje { get; set; }
        public string CodigoCertificado { get; set; }
    }

    public class CertificadoDTO
    {
        public int IdCertificado { get; set; }
        public int IdSolicitud { get; set; }
        public string CodigoCertificado { get; set; }
        public DateTime? FechaEmision { get; set; }
        public string NombreAdoptante { get; set; }
        public string CedulaAdoptante { get; set; }
        public string NombreMascota { get; set; }
        public string EspecieMascota { get; set; }
        public string RazaMascota { get; set; }
        public string NombreRefugio { get; set; }
        public string Estado { get; set; }
    }
}
