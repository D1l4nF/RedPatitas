using System;
using System.Collections.Generic;
using System.Linq;
using CapaDatos;

namespace CapaNegocios
{
    /// <summary>
    /// Servicio para obtener estadísticas y datos del Dashboard de administración
    /// </summary>
    public class CN_DashboardService
    {
        /// <summary>
        /// DTO para las estadísticas generales del sistema
        /// </summary>
        public class EstadisticasGenerales
        {
            public int TotalUsuarios { get; set; }
            public int TotalMascotas { get; set; }
            public int ReportesActivos { get; set; }
            public int AdopcionesExitosas { get; set; }
            public string TendenciaUsuarios { get; set; }
            public string TendenciaMascotas { get; set; }
            public string TendenciaReportes { get; set; }
            public string TendenciaAdopciones { get; set; }

            // Detalles de usuarios
            public int UsuariosAdminRefugio { get; set; }
            public int UsuariosRefugio { get; set; } // Staff
            public int UsuariosAdoptante { get; set; }
        }

        /// <summary>
        /// DTO para representar un usuario reciente en la tabla
        /// </summary>
        public class UsuarioReciente
        {
            public int IdUsuario { get; set; }
            public string Nombre { get; set; }
            public string Apellido { get; set; }
            public string Email { get; set; }
            public string Rol { get; set; }
            public bool EstadoActivo { get; set; }
            public string Iniciales { get; set; }
            public string ColorAvatar { get; set; }
        }

        /// <summary>
        /// DTO para representar una actividad reciente
        /// </summary>
        public class ActividadReciente
        {
            public string Tipo { get; set; } // user, pet, report, adoption
            public string Titulo { get; set; }
            public string Descripcion { get; set; }
            public string TiempoRelativo { get; set; }
            public DateTime Fecha { get; set; }
        }

        /// <summary>
        /// DTO para estadísticas de mascotas por refugio
        /// </summary>
        public class EstadisticaRefugio
        {
            public int IdRefugio { get; set; }
            public string NombreRefugio { get; set; }
            public int TotalMascotas { get; set; }
            public int MascotasDisponibles { get; set; }
            public int MascotasAdoptadas { get; set; }
            public string Iniciales { get; set; }
        }

        /// <summary>
        /// DTO para adopciones por mes
        /// </summary>
        public class AdopcionMensual
        {
            public int Anio { get; set; }
            public int Mes { get; set; }
            public string NombreMes { get; set; }
            public int CantidadAdopciones { get; set; }
        }

        /// <summary>
        /// DTO para datos de gráficos de tendencia
        /// </summary>
        public class DatosTendencia
        {
            public List<string> Etiquetas { get; set; }
            public List<int> Valores { get; set; }
        }

        /// <summary>
        /// Obtiene las estadísticas generales del sistema para el Dashboard
        /// </summary>
        public EstadisticasGenerales ObtenerEstadisticasGenerales()
        {
            using (var db = new DataClasses1DataContext())
            {
                var stats = new EstadisticasGenerales();

                // Total de usuarios activos
                var usuariosActivos = db.tbl_Usuarios.Where(u => u.usu_Estado == true).ToList();
                stats.TotalUsuarios = usuariosActivos.Count;
                
                // Desglose por roles
                stats.UsuariosAdminRefugio = usuariosActivos.Count(u => u.usu_IdRol == 2);
                stats.UsuariosRefugio = usuariosActivos.Count(u => u.usu_IdRol == 3);
                stats.UsuariosAdoptante = usuariosActivos.Count(u => u.usu_IdRol == 4);

                // Total de mascotas publicadas (activas)
                stats.TotalMascotas = db.tbl_Mascotas.Count(m => m.mas_Estado == true);

                // Reportes activos (Reportado o EnBusqueda)
                stats.ReportesActivos = db.tbl_ReportesMascotas
                    .Count(r => r.rep_Estado == "Reportado" || r.rep_Estado == "EnBusqueda");

                // Adopciones exitosas (mascotas adoptadas)
                stats.AdopcionesExitosas = db.tbl_Mascotas
                    .Count(m => m.mas_EstadoAdopcion == "Adoptado");

                // Calcular tendencias (comparar mes actual vs anterior)
                var inicioMesActual = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                var inicioMesAnterior = inicioMesActual.AddMonths(-1);

                // Tendencia usuarios
                var usuariosMesActual = db.tbl_Usuarios.Count(u => u.usu_FechaRegistro >= inicioMesActual);
                var usuariosMesAnterior = db.tbl_Usuarios.Count(u => u.usu_FechaRegistro >= inicioMesAnterior && u.usu_FechaRegistro < inicioMesActual);
                stats.TendenciaUsuarios = CalcularTendencia(usuariosMesActual, usuariosMesAnterior);

                // Tendencia mascotas
                var mascotasMesActual = db.tbl_Mascotas.Count(m => m.mas_FechaRegistro >= inicioMesActual);
                var mascotasMesAnterior = db.tbl_Mascotas.Count(m => m.mas_FechaRegistro >= inicioMesAnterior && m.mas_FechaRegistro < inicioMesActual);
                stats.TendenciaMascotas = CalcularTendencia(mascotasMesActual, mascotasMesAnterior);

                // Tendencia reportes
                var reportesMesActual = db.tbl_ReportesMascotas.Count(r => r.rep_FechaReporte >= inicioMesActual);
                var reportesMesAnterior = db.tbl_ReportesMascotas.Count(r => r.rep_FechaReporte >= inicioMesAnterior && r.rep_FechaReporte < inicioMesActual);
                stats.TendenciaReportes = CalcularTendencia(reportesMesActual, reportesMesAnterior, true);

                // Tendencia adopciones
                var adopcionesMesActual = db.tbl_Mascotas.Count(m => m.mas_FechaAdopcion >= inicioMesActual);
                var adopcionesMesAnterior = db.tbl_Mascotas.Count(m => m.mas_FechaAdopcion >= inicioMesAnterior && m.mas_FechaAdopcion < inicioMesActual);
                stats.TendenciaAdopciones = CalcularTendencia(adopcionesMesActual, adopcionesMesAnterior);

                return stats;
            }
        }

        /// <summary>
        /// Obtiene los usuarios registrados más recientemente
        /// </summary>
        public List<UsuarioReciente> ObtenerUsuariosRecientes(int cantidad = 5)
        {
            using (var db = new DataClasses1DataContext())
            {
                var coloresAvatar = new[] { "#FF6B6B", "#FF6B35", "#27AE60", "#3498DB", "#9B59B6" };
                var random = new Random();

                return db.tbl_Usuarios
                    .OrderByDescending(u => u.usu_FechaRegistro)
                    .Take(cantidad)
                    .Select(u => new
                    {
                        u.usu_IdUsuario,
                        u.usu_Nombre,
                        u.usu_Apellido,
                        u.usu_Email,
                        u.usu_Estado,
                        RolNombre = u.tbl_Roles.rol_Nombre
                    })
                    .ToList()
                    .Select((u, index) => new UsuarioReciente
                    {
                        IdUsuario = u.usu_IdUsuario,
                        Nombre = u.usu_Nombre,
                        Apellido = u.usu_Apellido ?? "",
                        Email = u.usu_Email,
                        Rol = TraducirRol(u.RolNombre),
                        EstadoActivo = u.usu_Estado ?? false,
                        Iniciales = ObtenerIniciales(u.usu_Nombre, u.usu_Apellido),
                        ColorAvatar = coloresAvatar[index % coloresAvatar.Length]
                    })
                    .ToList();
            }
        }

        /// <summary>
        /// Obtiene la actividad reciente del sistema desde la tabla de auditoría
        /// </summary>
        public List<ActividadReciente> ObtenerActividadReciente(int cantidad = 5)
        {
            using (var db = new DataClasses1DataContext())
            {
                var actividades = new List<ActividadReciente>();

                // Obtener registros recientes de auditoría
                var auditoria = db.tbl_Auditoria
                    .OrderByDescending(a => a.aud_Fecha)
                    .Take(cantidad * 2) // Tomamos más para filtrar
                    .ToList();

                foreach (var aud in auditoria.Take(cantidad))
                {
                    var actividad = new ActividadReciente
                    {
                        Fecha = aud.aud_Fecha ?? DateTime.Now,
                        TiempoRelativo = CalcularTiempoRelativo(aud.aud_Fecha ?? DateTime.Now)
                    };

                    // Determinar tipo y descripción según la acción
                    switch (aud.aud_Accion)
                    {
                        case "LOGIN":
                            actividad.Tipo = "user";
                            actividad.Titulo = "Inicio de sesión";
                            actividad.Descripcion = ObtenerNombreUsuario(db, aud.aud_IdUsuario);
                            break;
                        case "INSERT":
                            if (aud.aud_Tabla == "tbl_Mascotas")
                            {
                                actividad.Tipo = "pet";
                                actividad.Titulo = "Nueva mascota registrada";
                                actividad.Descripcion = "Mascota agregada al sistema";
                            }
                            else if (aud.aud_Tabla == "tbl_Usuarios")
                            {
                                actividad.Tipo = "user";
                                actividad.Titulo = "Nuevo usuario";
                                actividad.Descripcion = "Usuario registrado";
                            }
                            else if (aud.aud_Tabla == "tbl_SolicitudesAdopcion")
                            {
                                actividad.Tipo = "adoption";
                                actividad.Titulo = "Nueva solicitud de adopción";
                                actividad.Descripcion = "Solicitud recibida";
                            }
                            else if (aud.aud_Tabla == "tbl_Refugios")
                            {
                                actividad.Tipo = "user";
                                actividad.Titulo = "Nuevo Refugio";
                                actividad.Descripcion = "Refugio registrado";
                            }
                            else
                            {
                                actividad.Tipo = "user";
                                actividad.Titulo = "Registro nuevo";
                                actividad.Descripcion = ConstruirDescripcionAmigable(aud.aud_Tabla, "creado");
                            }
                            break;
                        case "UPDATE":
                            actividad.Tipo = "user";
                            actividad.Titulo = "Actualización";
                            actividad.Descripcion = ConstruirDescripcionAmigable(aud.aud_Tabla, "actualizado");
                            break;
                        case "DELETE":
                            actividad.Tipo = "report";
                            actividad.Titulo = "Eliminación";
                            actividad.Descripcion = ConstruirDescripcionAmigable(aud.aud_Tabla, "eliminado");
                            break;
                        case "CUENTA_BLOQUEADA":
                            actividad.Tipo = "report";
                            actividad.Titulo = "Cuenta bloqueada";
                            actividad.Descripcion = "Por intentos fallidos";
                            break;
                        default:
                            actividad.Tipo = "user";
                            actividad.Titulo = aud.aud_Accion;
                            actividad.Descripcion = aud.aud_Tabla ?? "Sistema";
                            break;
                    }

                    actividades.Add(actividad);
                }

                // Si no hay suficiente auditoría, agregar actividad basada en datos reales
                if (actividades.Count < cantidad)
                {
                    // Agregar últimas mascotas registradas
                    var mascotasRecientes = db.tbl_Mascotas
                        .OrderByDescending(m => m.mas_FechaRegistro)
                        .Take(cantidad - actividades.Count)
                        .ToList();

                    foreach (var mascota in mascotasRecientes)
                    {
                        actividades.Add(new ActividadReciente
                        {
                            Tipo = "pet",
                            Titulo = "Nueva mascota",
                            Descripcion = mascota.mas_Nombre,
                            Fecha = mascota.mas_FechaRegistro ?? DateTime.Now,
                            TiempoRelativo = CalcularTiempoRelativo(mascota.mas_FechaRegistro ?? DateTime.Now)
                        });
                    }
                }

                // Si aún no hay actividad, agregar mensaje informativo
                if (actividades.Count == 0)
                {
                    actividades.Add(new ActividadReciente
                    {
                        Tipo = "user",
                        Titulo = "Sin actividad reciente",
                        Descripcion = "El sistema está listo",
                        Fecha = DateTime.Now,
                        TiempoRelativo = "Ahora"
                    });
                }

                return actividades.OrderByDescending(a => a.Fecha).Take(cantidad).ToList();
            }
        }

        /// <summary>
        /// Obtiene estadísticas de mascotas por cada refugio
        /// </summary>
        public List<EstadisticaRefugio> ObtenerEstadisticasPorRefugio(int top = 5)
        {
            using (var db = new DataClasses1DataContext())
            {
                return db.tbl_Refugios
                    .Where(r => r.ref_Estado == true && r.ref_Verificado == true)
                    .Select(r => new
                    {
                        r.ref_IdRefugio,
                        r.ref_Nombre,
                        TotalMascotas = r.tbl_Mascotas.Count(m => m.mas_Estado == true),
                        MascotasDisponibles = r.tbl_Mascotas.Count(m => m.mas_Estado == true && m.mas_EstadoAdopcion == "Disponible"),
                        MascotasAdoptadas = r.tbl_Mascotas.Count(m => m.mas_EstadoAdopcion == "Adoptado")
                    })
                    .OrderByDescending(r => r.TotalMascotas)
                    .Take(top)
                    .ToList()
                    .Select(r => new EstadisticaRefugio
                    {
                        IdRefugio = r.ref_IdRefugio,
                        NombreRefugio = r.ref_Nombre,
                        TotalMascotas = r.TotalMascotas,
                        MascotasDisponibles = r.MascotasDisponibles,
                        MascotasAdoptadas = r.MascotasAdoptadas,
                        Iniciales = ObtenerInicialesRefugio(r.ref_Nombre)
                    })
                    .ToList();
            }
        }

        /// <summary>
        /// Obtiene adopciones por mes de los últimos N meses
        /// </summary>
        public List<AdopcionMensual> ObtenerAdopcionesPorMes(int meses = 6)
        {
            using (var db = new DataClasses1DataContext())
            {
                var resultado = new List<AdopcionMensual>();
                var nombresMeses = new[] { "", "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic" };

                for (int i = meses - 1; i >= 0; i--)
                {
                    var fecha = DateTime.Now.AddMonths(-i);
                    var inicioMes = new DateTime(fecha.Year, fecha.Month, 1);
                    var finMes = inicioMes.AddMonths(1);

                    var cantidad = db.tbl_Mascotas
                        .Count(m => m.mas_FechaAdopcion >= inicioMes && m.mas_FechaAdopcion < finMes);

                    resultado.Add(new AdopcionMensual
                    {
                        Anio = fecha.Year,
                        Mes = fecha.Month,
                        NombreMes = nombresMeses[fecha.Month],
                        CantidadAdopciones = cantidad
                    });
                }

                return resultado;
            }
        }

        /// <summary>
        /// Obtiene datos para gráfico de tendencia de registros
        /// </summary>
        public DatosTendencia ObtenerTendenciaRegistros(int meses = 6)
        {
            using (var db = new DataClasses1DataContext())
            {
                var etiquetas = new List<string>();
                var valores = new List<int>();
                var nombresMeses = new[] { "", "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic" };

                for (int i = meses - 1; i >= 0; i--)
                {
                    var fecha = DateTime.Now.AddMonths(-i);
                    var inicioMes = new DateTime(fecha.Year, fecha.Month, 1);
                    var finMes = inicioMes.AddMonths(1);

                    etiquetas.Add(nombresMeses[fecha.Month]);
                    valores.Add(db.tbl_Mascotas.Count(m => m.mas_FechaRegistro >= inicioMes && m.mas_FechaRegistro < finMes));
                }

                return new DatosTendencia { Etiquetas = etiquetas, Valores = valores };
            }
        }

        private string ObtenerInicialesRefugio(string nombre)
        {
            if (string.IsNullOrEmpty(nombre)) return "";
            var palabras = nombre.Split(' ');
            if (palabras.Length >= 2)
                return (palabras[0][0].ToString() + palabras[1][0].ToString()).ToUpper();
            return nombre.Length >= 2 ? nombre.Substring(0, 2).ToUpper() : nombre.ToUpper();
        }

        #region Métodos Auxiliares

        private string CalcularTendencia(int valorActual, int valorAnterior, bool invertir = false)
        {
            if (valorAnterior == 0)
            {
                return valorActual > 0 ? "↑ Nuevo" : "Sin cambios";
            }

            double porcentaje = ((double)(valorActual - valorAnterior) / valorAnterior) * 100;

            if (Math.Abs(porcentaje) < 1)
            {
                return "Sin cambios";
            }

            string flecha = porcentaje > 0 ? "↑" : "↓";
            string clase = porcentaje > 0 ? "" : " down";

            // Para reportes, bajada es buena
            if (invertir)
            {
                clase = porcentaje > 0 ? " down" : "";
            }

            return $"{flecha} {Math.Abs(porcentaje):0}% este mes";
        }

        private string ObtenerIniciales(string nombre, string apellido)
        {
            string inicial1 = !string.IsNullOrEmpty(nombre) ? nombre[0].ToString().ToUpper() : "";
            string inicial2 = !string.IsNullOrEmpty(apellido) ? apellido[0].ToString().ToUpper() : "";
            return inicial1 + inicial2;
        }

        private string TraducirRol(string rol)
        {
            switch (rol)
            {
                case "SuperAdmin": return "Administrador";
                case "AdminRefugio": return "Admin Refugio";
                case "Refugio": return "Refugio";
                case "Adoptante": return "Adoptante";
                default: return rol;
            }
        }

        private string CalcularTiempoRelativo(DateTime fecha)
        {
            var diferencia = DateTime.Now - fecha;

            if (diferencia.TotalMinutes < 1)
                return "Ahora";
            if (diferencia.TotalMinutes < 60)
                return $"Hace {(int)diferencia.TotalMinutes} min";
            if (diferencia.TotalHours < 24)
                return $"Hace {(int)diferencia.TotalHours} hora{((int)diferencia.TotalHours > 1 ? "s" : "")}";
            if (diferencia.TotalDays < 7)
                return $"Hace {(int)diferencia.TotalDays} día{((int)diferencia.TotalDays > 1 ? "s" : "")}";
            return fecha.ToString("dd/MM/yyyy");
        }

        private string ObtenerNombreUsuario(DataClasses1DataContext db, int? idUsuario)
        {
            if (!idUsuario.HasValue) return "Usuario";

            var usuario = db.tbl_Usuarios.FirstOrDefault(u => u.usu_IdUsuario == idUsuario.Value);
            if (usuario == null) return "Usuario";

            return $"{usuario.usu_Nombre} {usuario.usu_Apellido}".Trim();
        }

        private string ConstruirDescripcionAmigable(string tabla, string accion)
        {
            string entidad = tabla;
            if (tabla == "tbl_Mascotas") entidad = "Mascota";
            else if (tabla == "tbl_Usuarios") entidad = "Usuario";
            else if (tabla == "tbl_Refugios") entidad = "Refugio";
            else if (tabla == "tbl_SolicitudesAdopcion") entidad = "Solicitud";
            else if (tabla == "tbl_ReportesMascotas") entidad = "Reporte";
            else if (tabla.StartsWith("tbl_")) entidad = tabla.Substring(4);

            return $"{entidad} {accion}";
        }

        #endregion
    }
}
