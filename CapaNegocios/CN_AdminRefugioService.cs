using System;
using System.Collections.Generic;
using System.Linq;
using CapaDatos;

namespace CapaNegocios
{
    /// <summary>
    /// Servicio para gestión de refugios desde el panel de Admin
    /// </summary>
    public class CN_AdminRefugioService
    {
        /// <summary>
        /// DTO para representar un refugio en la lista de administración
        /// </summary>
        public class RefugioAdmin
        {
            public int IdRefugio { get; set; }
            public string Nombre { get; set; }
            public string Descripcion { get; set; }
            public string Direccion { get; set; }
            public string Ciudad { get; set; }
            public string Telefono { get; set; }
            public string Email { get; set; }
            public string LogoUrl { get; set; }
            public bool Verificado { get; set; }
            public DateTime? FechaVerificacion { get; set; }
            public bool Estado { get; set; }
            public DateTime? FechaRegistro { get; set; }
            public int TotalMascotas { get; set; }
            public int TotalUsuarios { get; set; }
            public string Iniciales { get; set; }
        }

        /// <summary>
        /// Obtiene todos los refugios con filtros opcionales
        /// </summary>
        public List<RefugioAdmin> ObtenerTodosRefugios(bool? filtroVerificado = null, string busqueda = null)
        {
            using (var db = new DataClasses1DataContext())
            {
                var query = db.tbl_Refugios.Where(r => r.ref_Estado == true);

                // Filtro por verificación
                if (filtroVerificado.HasValue)
                {
                    query = query.Where(r => r.ref_Verificado == filtroVerificado.Value);
                }

                // Búsqueda por nombre o ciudad
                if (!string.IsNullOrWhiteSpace(busqueda))
                {
                    busqueda = busqueda.ToLower();
                    query = query.Where(r =>
                        r.ref_Nombre.ToLower().Contains(busqueda) ||
                        (r.ref_Ciudad != null && r.ref_Ciudad.ToLower().Contains(busqueda)) ||
                        (r.ref_Email != null && r.ref_Email.ToLower().Contains(busqueda)));
                }

                return query
                    .OrderByDescending(r => r.ref_FechaRegistro)
                    .Select(r => new
                    {
                        r.ref_IdRefugio,
                        r.ref_Nombre,
                        r.ref_Descripcion,
                        r.ref_Direccion,
                        r.ref_Ciudad,
                        r.ref_Telefono,
                        r.ref_Email,
                        r.ref_LogoUrl,
                        r.ref_Verificado,
                        r.ref_FechaVerificacion,
                        r.ref_Estado,
                        r.ref_FechaRegistro,
                        TotalMascotas = r.tbl_Mascotas.Count(m => m.mas_Estado == true),
                        TotalUsuarios = r.tbl_Usuarios.Count(u => u.usu_Estado == true)
                    })
                    .ToList()
                    .Select(r => new RefugioAdmin
                    {
                        IdRefugio = r.ref_IdRefugio,
                        Nombre = r.ref_Nombre,
                        Descripcion = r.ref_Descripcion ?? "",
                        Direccion = r.ref_Direccion ?? "",
                        Ciudad = r.ref_Ciudad ?? "",
                        Telefono = r.ref_Telefono ?? "",
                        Email = r.ref_Email ?? "",
                        LogoUrl = r.ref_LogoUrl ?? "",
                        Verificado = r.ref_Verificado ?? false,
                        FechaVerificacion = r.ref_FechaVerificacion,
                        Estado = r.ref_Estado ?? false,
                        FechaRegistro = r.ref_FechaRegistro,
                        TotalMascotas = r.TotalMascotas,
                        TotalUsuarios = r.TotalUsuarios,
                        Iniciales = ObtenerIniciales(r.ref_Nombre)
                    })
                    .ToList();
            }
        }

        /// <summary>
        /// Verifica (aprueba) un refugio
        /// </summary>
        public bool VerificarRefugio(int idRefugio)
        {
            using (var db = new DataClasses1DataContext())
            {
                var refugio = db.tbl_Refugios.FirstOrDefault(r => r.ref_IdRefugio == idRefugio);
                if (refugio == null) return false;

                refugio.ref_Verificado = true;
                refugio.ref_FechaVerificacion = DateTime.Now;
                db.SubmitChanges();
                return true;
            }
        }

        /// <summary>
        /// Rechaza (quita verificación) de un refugio
        /// </summary>
        public bool RechazarRefugio(int idRefugio)
        {
            using (var db = new DataClasses1DataContext())
            {
                var refugio = db.tbl_Refugios.FirstOrDefault(r => r.ref_IdRefugio == idRefugio);
                if (refugio == null) return false;

                refugio.ref_Verificado = false;
                refugio.ref_FechaVerificacion = null;
                db.SubmitChanges();
                return true;
            }
        }

        /// <summary>
        /// Cambia el estado (activo/inactivo) de un refugio
        /// </summary>
        public bool CambiarEstadoRefugio(int idRefugio, bool nuevoEstado)
        {
            using (var db = new DataClasses1DataContext())
            {
                var refugio = db.tbl_Refugios.FirstOrDefault(r => r.ref_IdRefugio == idRefugio);
                if (refugio == null) return false;

                refugio.ref_Estado = nuevoEstado;
                db.SubmitChanges();
                return true;
            }
        }

        /// <summary>
        /// Obtiene estadísticas de refugios
        /// </summary>
        public (int Total, int Verificados, int Pendientes) ObtenerEstadisticasRefugios()
        {
            using (var db = new DataClasses1DataContext())
            {
                var refugios = db.tbl_Refugios.Where(r => r.ref_Estado == true);
                int total = refugios.Count();
                int verificados = refugios.Count(r => r.ref_Verificado == true);
                int pendientes = total - verificados;
                return (total, verificados, pendientes);
            }
        }

        #region Métodos Auxiliares

        private static string ObtenerIniciales(string nombre)
        {
            if (string.IsNullOrEmpty(nombre)) return "";
            
            var palabras = nombre.Split(' ');
            if (palabras.Length >= 2)
            {
                return (palabras[0][0].ToString() + palabras[1][0].ToString()).ToUpper();
            }
            return nombre.Length >= 2 ? nombre.Substring(0, 2).ToUpper() : nombre.ToUpper();
        }

        #endregion
    }
}
