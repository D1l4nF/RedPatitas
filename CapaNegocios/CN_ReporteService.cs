using CapaDatos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace CapaNegocios
{
    /// <summary>
    /// Servicio para gestión de reportes de mascotas perdidas/encontradas
    /// </summary>
    public class CN_ReporteService
    {
        /// <summary>
        /// Obtiene todos los reportes activos para el mapa público
        /// </summary>
        public static List<ReporteMapaDTO> ObtenerReportesActivos()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    return db.tbl_ReportesMascotas
                        .Where(r => r.rep_Estado != "Reunido" && r.rep_Estado != "SinResolver")
                        .Where(r => r.rep_Latitud != null && r.rep_Longitud != null)
                        .Select(r => new ReporteMapaDTO
                        {
                            IdReporte = r.rep_IdReporte,
                            Tipo = r.rep_TipoReporte,
                            Nombre = r.rep_NombreMascota ?? "Sin nombre",
                            Descripcion = r.rep_Descripcion != null ?
                                (r.rep_Descripcion.Length > 100 ? r.rep_Descripcion.Substring(0, 100) + "..." : r.rep_Descripcion) : "",
                            Ubicacion = r.rep_UbicacionUltima ?? r.rep_Ciudad ?? "",
                            Latitud = r.rep_Latitud,
                            Longitud = r.rep_Longitud,
                            Fecha = r.rep_FechaEvento ?? r.rep_FechaReporte,
                            Telefono = r.rep_TelefonoContacto ?? ""
                        })
                        .ToList();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error obteniendo reportes activos: " + ex.Message);
                return new List<ReporteMapaDTO>();
            }
        }

        /// <summary>
        /// Obtiene reportes de un usuario específico (para "Mis Reportes" del Adoptante)
        /// </summary>
        public static List<ReporteUsuarioDTO> ObtenerReportesPorUsuario(int idUsuario)
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    return db.tbl_ReportesMascotas
                        .Where(r => r.rep_IdUsuario == idUsuario)
                        .OrderByDescending(r => r.rep_FechaReporte)
                        .Select(r => new ReporteUsuarioDTO
                        {
                            IdReporte = r.rep_IdReporte,
                            NombreMascota = r.rep_NombreMascota ?? "Sin nombre",
                            TipoReporte = r.rep_TipoReporte,
                            Especie = r.tbl_Especies != null ? r.tbl_Especies.esp_Nombre : "Desconocida",
                            Ciudad = r.rep_Ciudad ?? "-",
                            Estado = r.rep_Estado,
                            FechaReporte = r.rep_FechaReporte,
                            CantidadAvistamientos = r.tbl_Avistamientos.Count(),
                            FotoUrl = db.tbl_FotosReportes
                                .Where(f => f.fore_IdReporte == r.rep_IdReporte)
                                .OrderBy(f => f.fore_Orden)
                                .Select(f => f.fore_Url)
                                .FirstOrDefault()
                        })
                        .ToList();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error obteniendo reportes del usuario: " + ex.Message);
                return new List<ReporteUsuarioDTO>();
            }
        }

        /// <summary>
        /// Obtiene el historial completo de un reporte (reporte + avistamientos)
        /// </summary>
        /// <param name="idReporte">ID del reporte</param>
        /// <param name="idUsuario">ID del usuario (null para público, verifica propiedad si tiene valor)</param>
        public static ReporteDetalleDTO ObtenerHistorialReporte(int idReporte, int? idUsuario = null)
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var reporte = db.tbl_ReportesMascotas.FirstOrDefault(r => r.rep_IdReporte == idReporte);
                    if (reporte == null) return null;

                    // Determinar si el usuario es el dueño del reporte
                    bool esDueno = idUsuario.HasValue && reporte.rep_IdUsuario == idUsuario.Value;

                    var detalle = new ReporteDetalleDTO
                    {
                        IdReporte = reporte.rep_IdReporte,
                        NombreMascota = reporte.rep_NombreMascota ?? "Sin nombre",
                        TipoReporte = reporte.rep_TipoReporte,
                        Especie = reporte.tbl_Especies?.esp_Nombre ?? "Desconocida",
                        Raza = reporte.rep_Raza ?? "Desconocida",
                        Color = reporte.rep_Color,
                        Tamano = reporte.rep_Tamano,
                        Sexo = reporte.rep_Sexo?.ToString(),
                        EdadAproximada = reporte.rep_EdadAproximada,
                        Descripcion = reporte.rep_Descripcion,
                        CaracteristicasDistintivas = reporte.rep_CaracteristicasDistintivas,
                        UbicacionUltima = reporte.rep_UbicacionUltima,
                        Ciudad = reporte.rep_Ciudad,
                        Latitud = reporte.rep_Latitud,
                        Longitud = reporte.rep_Longitud,
                        TelefonoContacto = reporte.rep_TelefonoContacto,
                        EmailContacto = reporte.rep_EmailContacto,
                        Estado = reporte.rep_Estado,
                        FechaEvento = reporte.rep_FechaEvento,
                        FechaReporte = reporte.rep_FechaReporte,
                        EsDueno = esDueno,
                        NombreDueno = reporte.tbl_Usuarios?.usu_Nombre,
                        Fotos = db.tbl_FotosReportes
                            .Where(f => f.fore_IdReporte == idReporte)
                            .OrderBy(f => f.fore_Orden)
                            .Select(f => f.fore_Url)
                            .ToList(),
                        Avistamientos = reporte.tbl_Avistamientos
                            .OrderByDescending(a => a.avi_FechaAvistamiento ?? a.avi_FechaReporte)
                            .Select(a => new AvistamientoDTO
                            {
                                IdAvistamiento = a.avi_IdAvistamiento,
                                Ubicacion = a.avi_Ubicacion,
                                Descripcion = a.avi_Descripcion,
                                FechaAvistamiento = a.avi_FechaAvistamiento,
                                FechaReporte = a.avi_FechaReporte,
                                Latitud = a.avi_Latitud,
                                Longitud = a.avi_Longitud,
                                FotoUrl = a.avi_FotoUrl,
                                NombreUsuario = a.tbl_Usuarios?.usu_Nombre ?? "Anónimo"
                            })
                            .ToList()
                    };

                    return detalle;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error obteniendo historial del reporte: " + ex.Message);
                return null;
            }
        }

        /// <summary>
        /// Registra un nuevo avistamiento
        /// </summary>
        public static ResultadoOperacion RegistrarAvistamiento(int idReporte, int? idUsuario, string descripcion,
            string ubicacion, decimal? latitud, decimal? longitud, string fotoUrl)
        {
            try
            {
                // Validación de descripción
                if (string.IsNullOrWhiteSpace(descripcion))
                {
                    return new ResultadoOperacion { Exito = false, Mensaje = "La descripción es requerida" };
                }

                // Sanitizar descripción (eliminar scripts HTML)
                descripcion = SanitizarTexto(descripcion);

                // Validar que el reporte existe y está activo
                using (var db = new DataClasses1DataContext())
                {
                    var reporte = db.tbl_ReportesMascotas.FirstOrDefault(r => r.rep_IdReporte == idReporte);
                    if (reporte == null)
                    {
                        return new ResultadoOperacion { Exito = false, Mensaje = "El reporte no existe" };
                    }

                    if (reporte.rep_Estado == "Reunido" || reporte.rep_Estado == "SinResolver")
                    {
                        return new ResultadoOperacion { Exito = false, Mensaje = "Este reporte ya fue cerrado" };
                    }

                    var avistamiento = new tbl_Avistamientos
                    {
                        avi_IdReporte = idReporte,
                        avi_IdUsuario = idUsuario,
                        avi_Descripcion = descripcion,
                        avi_Ubicacion = ubicacion,
                        avi_Latitud = latitud,
                        avi_Longitud = longitud,
                        avi_FotoUrl = fotoUrl,
                        avi_FechaAvistamiento = DateTime.Now,
                        avi_FechaReporte = DateTime.Now
                    };

                    db.tbl_Avistamientos.InsertOnSubmit(avistamiento);

                    // Actualizar estado del reporte a "Avistado" si estaba en "Reportado" o "EnBusqueda"
                    if (reporte.rep_Estado == "Reportado" || reporte.rep_Estado == "EnBusqueda")
                    {
                        reporte.rep_Estado = "Avistado";
                    }

                    db.SubmitChanges();

                    return new ResultadoOperacion { Exito = true, Mensaje = "Avistamiento registrado exitosamente" };
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error registrando avistamiento: " + ex.Message);
                return new ResultadoOperacion { Exito = false, Mensaje = "Error al registrar el avistamiento" };
            }
        }

        /// <summary>
        /// Cambia el estado de un reporte (solo el dueño puede hacerlo)
        /// </summary>
        public static ResultadoOperacion CambiarEstadoReporte(int idReporte, int idUsuario, string nuevoEstado)
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var reporte = db.tbl_ReportesMascotas.FirstOrDefault(r => r.rep_IdReporte == idReporte);
                    if (reporte == null)
                    {
                        return new ResultadoOperacion { Exito = false, Mensaje = "El reporte no existe" };
                    }

                    // Verificar que el usuario es el dueño
                    if (reporte.rep_IdUsuario != idUsuario)
                    {
                        return new ResultadoOperacion { Exito = false, Mensaje = "No tienes permiso para modificar este reporte" };
                    }

                    // Validar estados permitidos
                    var estadosValidos = new[] { "Reportado", "EnBusqueda", "Avistado", "Encontrado", "Reunido", "SinResolver" };
                    if (!estadosValidos.Contains(nuevoEstado))
                    {
                        return new ResultadoOperacion { Exito = false, Mensaje = "Estado no válido" };
                    }

                    reporte.rep_Estado = nuevoEstado;

                    // Si se marca como reunido o sin resolver, cerrar el reporte
                    if (nuevoEstado == "Reunido" || nuevoEstado == "SinResolver")
                    {
                        reporte.rep_FechaCierre = DateTime.Now;
                    }

                    db.SubmitChanges();

                    return new ResultadoOperacion { Exito = true, Mensaje = "Estado actualizado correctamente" };
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cambiando estado del reporte: " + ex.Message);
                return new ResultadoOperacion { Exito = false, Mensaje = "Error al actualizar el estado" };
            }
        }

        /// <summary>
        /// Obtiene estadísticas agregadas de reportes (para el dashboard admin)
        /// </summary>
        public static EstadisticasReportesDTO ObtenerEstadisticasReportes()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var reportes = db.tbl_ReportesMascotas;
                    var hoy = DateTime.Today;
                    var inicioMes = new DateTime(hoy.Year, hoy.Month, 1);

                    var stats = new EstadisticasReportesDTO
                    {
                        TotalReportes = reportes.Count(),
                        ReportesActivos = reportes.Count(r => r.rep_Estado != "Reunido" && r.rep_Estado != "SinResolver"),
                        Perdidas = reportes.Count(r => r.rep_TipoReporte == "Perdida"),
                        Encontradas = reportes.Count(r => r.rep_TipoReporte == "Encontrada"),
                        Reunidas = reportes.Count(r => r.rep_Estado == "Reunido"),
                        SinResolver = reportes.Count(r => r.rep_Estado == "SinResolver"),
                        ReportesEsteMes = reportes.Count(r => r.rep_FechaReporte >= inicioMes),
                        TotalAvistamientos = db.tbl_Avistamientos.Count(),

                        // Reportes mensuales (últimos 6 meses)
                        ReportesMensuales = reportes
                            .Where(r => r.rep_FechaReporte >= hoy.AddMonths(-6))
                            .GroupBy(r => new { Anio = r.rep_FechaReporte.Value.Year, Mes = r.rep_FechaReporte.Value.Month })
                            .Select(g => new ReporteMensualDTO
                            {
                                Anio = g.Key.Anio,
                                Mes = g.Key.Mes,
                                Cantidad = g.Count()
                            })
                            .OrderBy(r => r.Anio).ThenBy(r => r.Mes)
                            .ToList()
                    };

                    return stats;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error obteniendo estadísticas: " + ex.Message);
                return new EstadisticasReportesDTO();
            }
        }

        /// <summary>
        /// Valida una imagen para avistamiento
        /// </summary>
        public static ResultadoOperacion ValidarImagen(string nombreArchivo, int tamanoBytes)
        {
            // Validar extensión
            var extensionesValidas = new[] { ".jpg", ".jpeg", ".png" };
            var extension = System.IO.Path.GetExtension(nombreArchivo).ToLower();

            if (!extensionesValidas.Contains(extension))
            {
                return new ResultadoOperacion { Exito = false, Mensaje = "Solo se permiten imágenes JPG o PNG" };
            }

            // Validar tamaño (máximo 2MB)
            const int maxTamano = 2 * 1024 * 1024; // 2MB
            if (tamanoBytes > maxTamano)
            {
                return new ResultadoOperacion { Exito = false, Mensaje = "La imagen no debe superar los 2MB" };
            }

            return new ResultadoOperacion { Exito = true };
        }

        /// <summary>
        /// Sanitiza texto eliminando scripts y HTML peligroso
        /// </summary>
        private static string SanitizarTexto(string texto)
        {
            if (string.IsNullOrEmpty(texto)) return texto;

            // Eliminar etiquetas script
            texto = Regex.Replace(texto, @"<script[^>]*>.*?</script>", "", RegexOptions.IgnoreCase | RegexOptions.Singleline);

            // Eliminar eventos on*
            texto = Regex.Replace(texto, @"on\w+=""[^""]*""", "", RegexOptions.IgnoreCase);
            texto = Regex.Replace(texto, @"on\w+='[^']*'", "", RegexOptions.IgnoreCase);

            // Eliminar etiquetas HTML potencialmente peligrosas
            texto = Regex.Replace(texto, @"<(script|iframe|object|embed|form)[^>]*>", "", RegexOptions.IgnoreCase);

            return texto.Trim();
        }
    }

    #region DTOs

    public class ReporteMapaDTO
    {
        public int IdReporte { get; set; }
        public string Tipo { get; set; }
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public string Ubicacion { get; set; }
        public decimal? Latitud { get; set; }
        public decimal? Longitud { get; set; }
        public DateTime? Fecha { get; set; }
        public string Telefono { get; set; }
    }

    public class ReporteUsuarioDTO
    {
        public int IdReporte { get; set; }
        public string NombreMascota { get; set; }
        public string TipoReporte { get; set; }
        public string Especie { get; set; }
        public string Ciudad { get; set; }
        public string Estado { get; set; }
        public DateTime? FechaReporte { get; set; }
        public int CantidadAvistamientos { get; set; }
        public string FotoUrl { get; set; }
    }

    public class ReporteDetalleDTO
    {
        public int IdReporte { get; set; }
        public string NombreMascota { get; set; }
        public string TipoReporte { get; set; }
        public string Especie { get; set; }
        public string Raza { get; set; }
        public string Color { get; set; }
        public string Tamano { get; set; }
        public string Sexo { get; set; }
        public string EdadAproximada { get; set; }
        public string Descripcion { get; set; }
        public string CaracteristicasDistintivas { get; set; }
        public string UbicacionUltima { get; set; }
        public string Ciudad { get; set; }
        public decimal? Latitud { get; set; }
        public decimal? Longitud { get; set; }
        public string TelefonoContacto { get; set; }
        public string EmailContacto { get; set; }
        public string Estado { get; set; }
        public DateTime? FechaEvento { get; set; }
        public DateTime? FechaReporte { get; set; }
        public bool EsDueno { get; set; }
        public string NombreDueno { get; set; }
        public List<string> Fotos { get; set; }
        public List<AvistamientoDTO> Avistamientos { get; set; }
    }

    public class AvistamientoDTO
    {
        public int IdAvistamiento { get; set; }
        public string Ubicacion { get; set; }
        public string Descripcion { get; set; }
        public DateTime? FechaAvistamiento { get; set; }
        public DateTime? FechaReporte { get; set; }
        public decimal? Latitud { get; set; }
        public decimal? Longitud { get; set; }
        public string FotoUrl { get; set; }
        public string NombreUsuario { get; set; }
    }

    public class EstadisticasReportesDTO
    {
        public int TotalReportes { get; set; }
        public int ReportesActivos { get; set; }
        public int Perdidas { get; set; }
        public int Encontradas { get; set; }
        public int Reunidas { get; set; }
        public int SinResolver { get; set; }
        public int ReportesEsteMes { get; set; }
        public int TotalAvistamientos { get; set; }
        public List<ReporteMensualDTO> ReportesMensuales { get; set; }
    }

    public class ReporteMensualDTO
    {
        public int Anio { get; set; }
        public int Mes { get; set; }
        public int Cantidad { get; set; }
    }



    #endregion
}
