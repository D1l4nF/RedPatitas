using System;
using System.Collections.Generic;
using System.Linq;
using CapaDatos;

namespace CapaNegocios
{
    /// <summary>
    /// Servicio para gestión de usuarios desde el panel de Admin
    /// </summary>
    public class CN_AdminUsuarioService
    {
        /// <summary>
        /// DTO para representar un usuario en la lista de administración
        /// </summary>
        public class UsuarioAdmin
        {
            public int IdUsuario { get; set; }
            public string Nombre { get; set; }
            public string Apellido { get; set; }
            public string NombreCompleto => $"{Nombre} {Apellido}".Trim();
            public string Email { get; set; }
            public string Telefono { get; set; }
            public string Ciudad { get; set; }
            public int IdRol { get; set; }
            public string NombreRol { get; set; }
            public int? IdRefugio { get; set; }
            public string NombreRefugio { get; set; }
            public bool Estado { get; set; }
            public bool Bloqueado { get; set; }
            public DateTime? FechaBloqueo { get; set; }
            public DateTime? FechaRegistro { get; set; }
            public DateTime? UltimoAcceso { get; set; }
            public bool EmailVerificado { get; set; }
            public string Iniciales { get; set; }
        }

        /// <summary>
        /// DTO para representar un refugio en dropdown
        /// </summary>
        public class RefugioDropdown
        {
            public int IdRefugio { get; set; }
            public string Nombre { get; set; }
            public bool Verificado { get; set; }
        }

        /// <summary>
        /// DTO para representar un rol en dropdown
        /// </summary>
        public class RolDropdown
        {
            public int IdRol { get; set; }
            public string Nombre { get; set; }
        }

        /// <summary>
        /// Obtiene todos los usuarios con filtros opcionales
        /// </summary>
        public List<UsuarioAdmin> ObtenerTodosUsuarios(int? filtroRol = null, bool? filtroEstado = null, string busqueda = null)
        {
            using (var db = new DataClasses1DataContext())
            {
                var query = db.tbl_Usuarios.AsQueryable();

                // Filtro por rol
                if (filtroRol.HasValue && filtroRol.Value > 0)
                {
                    query = query.Where(u => u.usu_IdRol == filtroRol.Value);
                }

                // Filtro por estado
                if (filtroEstado.HasValue)
                {
                    query = query.Where(u => u.usu_Estado == filtroEstado.Value);
                }

                // Búsqueda por nombre o email
                if (!string.IsNullOrWhiteSpace(busqueda))
                {
                    busqueda = busqueda.ToLower();
                    query = query.Where(u => 
                        u.usu_Nombre.ToLower().Contains(busqueda) ||
                        (u.usu_Apellido != null && u.usu_Apellido.ToLower().Contains(busqueda)) ||
                        u.usu_Email.ToLower().Contains(busqueda));
                }

                return query
                    .OrderByDescending(u => u.usu_FechaRegistro)
                    .Select(u => new
                    {
                        u.usu_IdUsuario,
                        u.usu_Nombre,
                        u.usu_Apellido,
                        u.usu_Email,
                        u.usu_Telefono,
                        u.usu_Ciudad,
                        u.usu_IdRol,
                        RolNombre = u.tbl_Roles.rol_Nombre,
                        u.usu_IdRefugio,
                        RefugioNombre = u.tbl_Refugios != null ? u.tbl_Refugios.ref_Nombre : null,
                        u.usu_Estado,
                        u.usu_Bloqueado,
                        u.usu_FechaBloqueo,
                        u.usu_FechaRegistro,
                        u.usu_UltimoAcceso,
                        u.usu_EmailVerificado
                    })
                    .ToList()
                    .Select(u => new UsuarioAdmin
                    {
                        IdUsuario = u.usu_IdUsuario,
                        Nombre = u.usu_Nombre,
                        Apellido = u.usu_Apellido ?? "",
                        Email = u.usu_Email,
                        Telefono = u.usu_Telefono ?? "",
                        Ciudad = u.usu_Ciudad ?? "",
                        IdRol = u.usu_IdRol,
                        NombreRol = TraducirRol(u.RolNombre),
                        IdRefugio = u.usu_IdRefugio,
                        NombreRefugio = u.RefugioNombre ?? "Sin asignar",
                        Estado = u.usu_Estado ?? false,
                        Bloqueado = u.usu_Bloqueado ?? false,
                        FechaBloqueo = u.usu_FechaBloqueo,
                        FechaRegistro = u.usu_FechaRegistro,
                        UltimoAcceso = u.usu_UltimoAcceso,
                        EmailVerificado = u.usu_EmailVerificado ?? false,
                        Iniciales = ObtenerIniciales(u.usu_Nombre, u.usu_Apellido)
                    })
                    .ToList();
            }
        }

        /// <summary>
        /// Cambia el estado (activo/inactivo) de un usuario
        /// </summary>
        public bool CambiarEstadoUsuario(int idUsuario, bool nuevoEstado)
        {
            using (var db = new DataClasses1DataContext())
            {
                var usuario = db.tbl_Usuarios.FirstOrDefault(u => u.usu_IdUsuario == idUsuario);
                if (usuario == null) return false;

                usuario.usu_Estado = nuevoEstado;
                db.SubmitChanges();
                return true;
            }
        }

        /// <summary>
        /// Desbloquea una cuenta de usuario bloqueada
        /// </summary>
        public bool DesbloquearUsuario(int idUsuario)
        {
            using (var db = new DataClasses1DataContext())
            {
                var usuario = db.tbl_Usuarios.FirstOrDefault(u => u.usu_IdUsuario == idUsuario);
                if (usuario == null) return false;

                usuario.usu_Bloqueado = false;
                usuario.usu_IntentosFallidos = 0;
                usuario.usu_FechaBloqueo = null;
                db.SubmitChanges();
                return true;
            }
        }

        /// <summary>
        /// Asigna un usuario a un refugio (para roles AdminRefugio o Refugio)
        /// </summary>
        public bool AsignarUsuarioARefugio(int idUsuario, int? idRefugio)
        {
            using (var db = new DataClasses1DataContext())
            {
                var usuario = db.tbl_Usuarios.FirstOrDefault(u => u.usu_IdUsuario == idUsuario);
                if (usuario == null) return false;

                // Solo permitir asignación para roles de refugio (AdminRefugio=2, Refugio=3)
                if (usuario.usu_IdRol != 2 && usuario.usu_IdRol != 3)
                {
                    return false;
                }

                usuario.usu_IdRefugio = idRefugio;
                db.SubmitChanges();
                return true;
            }
        }

        /// <summary>
        /// Obtiene la lista de roles disponibles
        /// </summary>
        public List<RolDropdown> ObtenerRoles()
        {
            using (var db = new DataClasses1DataContext())
            {
                return db.tbl_Roles
                    .Where(r => r.rol_Estado == true)
                    .OrderByDescending(r => r.rol_Nivel)
                    .Select(r => new RolDropdown
                    {
                        IdRol = r.rol_IdRol,
                        Nombre = r.rol_Nombre
                    })
                    .ToList();
            }
        }

        /// <summary>
        /// Obtiene la lista de refugios para asignación
        /// </summary>
        public List<RefugioDropdown> ObtenerRefugiosParaAsignar()
        {
            using (var db = new DataClasses1DataContext())
            {
                return db.tbl_Refugios
                    .Where(r => r.ref_Estado == true)
                    .OrderBy(r => r.ref_Nombre)
                    .Select(r => new RefugioDropdown
                    {
                        IdRefugio = r.ref_IdRefugio,
                        Nombre = r.ref_Nombre,
                        Verificado = r.ref_Verificado ?? false
                    })
                    .ToList();
            }
        }

        #region Métodos Auxiliares

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

        private string ObtenerIniciales(string nombre, string apellido)
        {
            string inicial1 = !string.IsNullOrEmpty(nombre) ? nombre[0].ToString().ToUpper() : "";
            string inicial2 = !string.IsNullOrEmpty(apellido) ? apellido[0].ToString().ToUpper() : "";
            return inicial1 + inicial2;
        }

        #endregion
    }
}
