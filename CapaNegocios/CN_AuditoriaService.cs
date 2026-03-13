using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CapaDatos;
using System.Web;

namespace CapaNegocios
{
    public class CN_AuditoriaService
    {
        public static void RegistrarAccion(int? idUsuario, string accion, string tabla, int? idRegistro = null, string valorAnterior = null, string valorNuevo = null)
        {
            try
            {
                using (DataClasses1DataContext dc = new DataClasses1DataContext())
                {
                    string ip = HttpContext.Current != null ? HttpContext.Current.Request.UserHostAddress : "Unknown";

                    // Intentar obtener el IdUsuario de la sesión si no se proporcionó
                    if (!idUsuario.HasValue && HttpContext.Current != null && HttpContext.Current.Session != null && HttpContext.Current.Session["UsuarioId"] != null)
                    {
                        idUsuario = Convert.ToInt32(HttpContext.Current.Session["UsuarioId"]);
                    }

                    var auditoria = new tbl_Auditoria
                    {
                        aud_IdUsuario = idUsuario,
                        aud_Accion = accion,
                        aud_Tabla = tabla,
                        aud_IdRegistro = idRegistro,
                        aud_ValorAnterior = valorAnterior,
                        aud_ValorNuevo = valorNuevo,
                        aud_DireccionIP = ip,
                        aud_Fecha = DateTime.Now
                    };

                    dc.tbl_Auditoria.InsertOnSubmit(auditoria);
                    dc.SubmitChanges();
                }
            }
            catch (Exception ex)
            {
                // Silenciar error para no interrumpir flujo principal, pero se podría loguear en archivo
                System.Diagnostics.Debug.WriteLine("Error al registrar auditoría: " + ex.Message);
            }
        }

        // Obtener la actividad más reciente para el Dashboard (ej. últimos 5)
        public static object ObtenerActividadRecienteXRefugio(int idRefugio, int cantidad = 5)
        {
            try
            {
                using (DataClasses1DataContext dc = new DataClasses1DataContext())
                {
                    var actividad = (from a in dc.tbl_Auditoria
                                     join u in dc.tbl_Usuarios on a.aud_IdUsuario equals u.usu_IdUsuario
                                     where u.usu_IdRefugio == idRefugio
                                     orderby a.aud_Fecha descending
                                     select new
                                     {
                                         IdAuditoria = a.aud_IdAuditoria,
                                         Fecha = a.aud_Fecha,
                                         Accion = a.aud_Accion,
                                         Tabla = a.aud_Tabla,
                                         IdRegistro = a.aud_IdRegistro,
                                         UsuarioNombre = u.usu_Nombre + " " + u.usu_Apellido,
                                         FotoUsuario = string.IsNullOrEmpty(u.usu_FotoUrl) ? "/Images/Default/default-user.png" : u.usu_FotoUrl
                                     }).Take(cantidad).ToList();

                    return actividad;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al obtener auditoría: " + ex.Message);
                return null;
            }
        }

        // Obtener toda la actividad para la pantalla de Administración/Auditoría
        public static object ObtenerTodaActividadXRefugio(int idRefugio)
        {
            try
            {
                using (DataClasses1DataContext dc = new DataClasses1DataContext())
                {
                    var actividad = (from a in dc.tbl_Auditoria
                                     join u in dc.tbl_Usuarios on a.aud_IdUsuario equals u.usu_IdUsuario
                                     where u.usu_IdRefugio == idRefugio
                                     orderby a.aud_Fecha descending
                                     select new
                                     {
                                         IdAuditoria = a.aud_IdAuditoria,
                                         Fecha = a.aud_Fecha,
                                         Accion = a.aud_Accion,
                                         Tabla = a.aud_Tabla,
                                         IdRegistro = a.aud_IdRegistro,
                                         UsuarioNombre = u.usu_Nombre + " " + u.usu_Apellido,
                                         DetallePrevio = a.aud_ValorAnterior,
                                         DetalleNuevo = a.aud_ValorNuevo,
                                         DireccionIP = a.aud_DireccionIP
                                     }).ToList();

                    return actividad;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al obtener toda la auditoría: " + ex.Message);
                return null;
            }
        }
    }
}
