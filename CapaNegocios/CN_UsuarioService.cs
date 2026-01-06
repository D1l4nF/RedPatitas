using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CapaDatos;



namespace CapaNegocios
{
    public class CN_UsuarioService
    {
        public CN_LoginResultado ValidarLogin(string correo, string clave)
        {
            using (DataClasses1DataContext dc = new DataClasses1DataContext())
            {
                var usuario = dc.tbl_Usuarios.FirstOrDefault(u => u.usu_Email == correo && u.usu_Estado == true);
                if (usuario == null)
                {
                    return new CN_LoginResultado
                    {
                        Exito = false,
                        Mensaje = "Credenciales invalidas"
                    };
                }

                if (usuario.usu_Bloqueado == true)
                {
                    return new CN_LoginResultado
                    {
                        Exito = false,
                        Mensaje = "Usuario bloqueado. Contacte al administrador."
                    };
                }
                if (CN_CryptoService.VerifyPassword(clave, usuario.usu_Contrasena, usuario.usu_Salt))
                {
                    usuario.usu_IntentosFallidos = 0;
                    dc.SubmitChanges();
                    return new CN_LoginResultado
                    {
                        Exito = true,
                        Mensaje = "Login exitoso",
                        UsuarioId = usuario.usu_IdUsuario,
                        NombreUsuario = usuario.usu_Nombre + " " + usuario.usu_Apellido,
                        RolId = usuario.usu_IdRol,
                        Correo = usuario.usu_Email,
                        RefugioId = usuario.usu_IdRefugio,
                        FotoUrl = usuario.usu_FotoUrl,
                        Ref_Verificado = usuario.usu_IdRefugio != null ? usuario.tbl_Refugios.ref_Verificado : null
                    };
                }
                else
                {
                    usuario.usu_IntentosFallidos = (usuario.usu_IntentosFallidos ?? 0) + 1;
                    
                    if (usuario.usu_IntentosFallidos >= 3)
                    {
                        usuario.usu_Bloqueado = true;
                        usuario.usu_FechaBloqueo = DateTime.Now;
                        dc.SubmitChanges();
                        return new CN_LoginResultado
                        {
                            Exito = false,
                            Mensaje = "Usuario bloqueado por múltiples intentos fallidos. Contacte al administrador."
                        };
                    }
                    dc.SubmitChanges(); 

                    int intentosRestantes = 3 - (usuario.usu_IntentosFallidos ?? 0);
                    return new CN_LoginResultado
                    {
                        Exito = false,
                        Mensaje = $"Correo o clave incorrectos. Intentos Restantes: {intentosRestantes}"
                    };
                    
                }
            }
        }

        /// <summary>
        /// Registra un nuevo usuario adoptante (rol 4)
        /// </summary>
        public CN_RegistroResultado RegistrarAdoptante(string nombre, string apellido, string email, string contrasena)
        {
            using (DataClasses1DataContext dc = new DataClasses1DataContext())
            {
                // Verificar si el email ya existe
                var usuarioExistente = dc.tbl_Usuarios.FirstOrDefault(u => u.usu_Email == email);
                if (usuarioExistente != null)
                {
                    return new CN_RegistroResultado
                    {
                        Exito = false,
                        Mensaje = "El correo electrónico ya está registrado."
                    };
                }

                // Generar salt y hash para la contraseña
                string salt = CN_CryptoService.GenerarSalt();
                string hash = CN_CryptoService.HashPassword(contrasena, salt);

                // Crear nuevo usuario adoptante
                var nuevoUsuario = new tbl_Usuarios
                {
                    usu_IdRol = 4, // Rol Adoptante
                    usu_IdRefugio = null,
                    usu_Nombre = nombre,
                    usu_Apellido = apellido,
                    usu_Email = email,
                    usu_Contrasena = hash,
                    usu_Salt = salt,
                    usu_EmailVerificado = false,
                    usu_IntentosFallidos = 0,
                    usu_Bloqueado = false,
                    usu_Estado = true,
                    usu_FechaRegistro = DateTime.Now
                };

                dc.tbl_Usuarios.InsertOnSubmit(nuevoUsuario);
                dc.SubmitChanges();

                return new CN_RegistroResultado
                {
                    Exito = true,
                    Mensaje = "Cuenta creada exitosamente.",
                    UsuarioId = nuevoUsuario.usu_IdUsuario
                };
            }
        }

        /// <summary>
        /// Registra un nuevo refugio con su cuenta de usuario (rol 3)
        /// </summary>
        public CN_RegistroResultado RegistrarRefugio(string nombreRefugio, string descripcion, string telefono, 
            string ciudad, string direccion, string email, string contrasena)
        {
            using (DataClasses1DataContext dc = new DataClasses1DataContext())
            {
                // Verificar si el email ya existe
                var usuarioExistente = dc.tbl_Usuarios.FirstOrDefault(u => u.usu_Email == email);
                if (usuarioExistente != null)
                {
                    return new CN_RegistroResultado
                    {
                        Exito = false,
                        Mensaje = "El correo electrónico ya está registrado."
                    };
                }

                // Crear el refugio primero
                var nuevoRefugio = new tbl_Refugios
                {
                    ref_Nombre = nombreRefugio,
                    ref_Descripcion = descripcion,
                    ref_Telefono = telefono,
                    ref_Ciudad = ciudad,
                    ref_Direccion = direccion,
                    ref_Email = email,
                    ref_Verificado = false, // Pendiente de verificación por admin
                    ref_Estado = true,
                    ref_FechaRegistro = DateTime.Now
                };

                dc.tbl_Refugios.InsertOnSubmit(nuevoRefugio);
                dc.SubmitChanges(); // Guardar para obtener el ID

                // Generar salt y hash para la contraseña
                string salt = CN_CryptoService.GenerarSalt();
                string hash = CN_CryptoService.HashPassword(contrasena, salt);

                // Crear usuario vinculado al refugio
                var nuevoUsuario = new tbl_Usuarios
                {
                    usu_IdRol = 2, // Rol Refugio
                    usu_IdRefugio = nuevoRefugio.ref_IdRefugio,
                    usu_Nombre = nombreRefugio, // Usar nombre del refugio
                    usu_Apellido = null,
                    usu_Email = email,
                    usu_Contrasena = hash,
                    usu_Salt = salt,
                    usu_Telefono = telefono,
                    usu_Ciudad = ciudad,
                    usu_Direccion = direccion,
                    usu_EmailVerificado = false,
                    usu_IntentosFallidos = 0,
                    usu_Bloqueado = false,
                    usu_Estado = true,
                    usu_FechaRegistro = DateTime.Now
                };

                dc.tbl_Usuarios.InsertOnSubmit(nuevoUsuario);
                dc.SubmitChanges();

                return new CN_RegistroResultado
                {
                    Exito = true,
                    Mensaje = "Solicitud de registro enviada. Un administrador verificará tu información.",
                    UsuarioId = nuevoUsuario.usu_IdUsuario
                };
            }
        }
    }
}
