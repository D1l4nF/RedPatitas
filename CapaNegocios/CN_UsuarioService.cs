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
                if (usuario.usu_Contrasena == clave)
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
                        FotoUrl = usuario.usu_FotoUrl
                        
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
    }
}
