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
    }
}
