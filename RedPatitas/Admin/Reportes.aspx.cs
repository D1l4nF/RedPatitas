using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaDatos;

namespace RedPatitas.Admin
{
    public partial class Reportes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarEstadisticasGenerales();
                CargarUsuariosPorRol();
                CargarMascotasPorEstado();
                CargarAdopcionesMensuales();
                CargarTopRefugios();
                CargarEstadisticasReportes();
            }
        }

        private void CargarEstadisticasGenerales()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    litTotalUsuarios.Text = db.tbl_Usuarios.Count(u => u.usu_Estado == true).ToString("N0");
                    litTotalRefugios.Text = db.tbl_Refugios.Count(r => r.ref_Estado == true && r.ref_Verificado == true).ToString("N0");
                    litTotalMascotas.Text = db.tbl_Mascotas.Count(m => m.mas_Estado == true).ToString("N0");
                    litTotalAdopciones.Text = db.tbl_Mascotas.Count(m => m.mas_EstadoAdopcion == "Adoptado").ToString("N0");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cargando estadísticas: " + ex.Message);
            }
        }

        private void CargarUsuariosPorRol()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var total = db.tbl_Usuarios.Count(u => u.usu_Estado == true);
                    if (total == 0) total = 1;

                    var datos = db.tbl_Roles
                        .Select(r => new
                        {
                            NombreRol = r.rol_Nombre,
                            Cantidad = db.tbl_Usuarios.Count(u => u.usu_IdRol == r.rol_IdRol && u.usu_Estado == true),
                            r.rol_IdRol
                        })
                        .ToList()
                        .Select(r => new
                        {
                            r.NombreRol,
                            r.Cantidad,
                            Porcentaje = Math.Round((double)r.Cantidad / total * 100, 1),
                            ClaseBadge = GetRolBadgeClass(r.rol_IdRol)
                        })
                        .Where(r => r.Cantidad > 0)
                        .OrderByDescending(r => r.Cantidad)
                        .ToList();

                    rptUsuariosPorRol.DataSource = datos;
                    rptUsuariosPorRol.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cargando usuarios por rol: " + ex.Message);
            }
        }

        private void CargarMascotasPorEstado()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var total = db.tbl_Mascotas.Count(m => m.mas_Estado == true);
                    if (total == 0) total = 1;

                    var estados = new[] { "Disponible", "EnProceso", "Adoptado", "Reservado" };
                    var datos = estados.Select(estado => new
                    {
                        Estado = estado,
                        Cantidad = db.tbl_Mascotas.Count(m => m.mas_EstadoAdopcion == estado && m.mas_Estado == true),
                        Porcentaje = Math.Round((double)db.tbl_Mascotas.Count(m => m.mas_EstadoAdopcion == estado && m.mas_Estado == true) / total * 100, 1),
                        ClaseBadge = GetEstadoBadgeClass(estado)
                    })
                    .Where(e => e.Cantidad > 0)
                    .ToList();

                    rptMascotasPorEstado.DataSource = datos;
                    rptMascotasPorEstado.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cargando mascotas por estado: " + ex.Message);
            }
        }

        private void CargarAdopcionesMensuales()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var datos = new List<object>();
                    var nombresMeses = new[] { "", "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic" };
                    int maxAdopciones = 1;

                    // Obtener datos de 12 meses
                    for (int i = 11; i >= 0; i--)
                    {
                        var fecha = DateTime.Now.AddMonths(-i);
                        var inicioMes = new DateTime(fecha.Year, fecha.Month, 1);
                        var finMes = inicioMes.AddMonths(1);

                        var cantidad = db.tbl_Mascotas.Count(m => m.mas_FechaAdopcion >= inicioMes && m.mas_FechaAdopcion < finMes);
                        if (cantidad > maxAdopciones) maxAdopciones = cantidad;

                        datos.Add(new
                        {
                            NombreMes = nombresMeses[fecha.Month],
                            Anio = fecha.Year,
                            CantidadAdopciones = cantidad,
                            PorcentajeBarra = 0 // Se calculará después
                        });
                    }

                    // Recalcular porcentajes
                    var datosConPorcentaje = datos.Cast<dynamic>().Select(d => new
                    {
                        d.NombreMes,
                        d.Anio,
                        d.CantidadAdopciones,
                        PorcentajeBarra = maxAdopciones > 0 ? (int)((double)d.CantidadAdopciones / maxAdopciones * 100) : 0
                    }).ToList();

                    rptAdopcionesMensuales.DataSource = datosConPorcentaje;
                    rptAdopcionesMensuales.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cargando adopciones mensuales: " + ex.Message);
            }
        }

        private void CargarTopRefugios()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var datos = db.tbl_Refugios
                        .Where(r => r.ref_Estado == true && r.ref_Verificado == true)
                        .Select(r => new
                        {
                            r.ref_Nombre,
                            TotalMascotas = r.tbl_Mascotas.Count(m => m.mas_Estado == true),
                            MascotasAdoptadas = r.tbl_Mascotas.Count(m => m.mas_EstadoAdopcion == "Adoptado")
                        })
                        .ToList()
                        .Select(r => new
                        {
                            NombreRefugio = r.ref_Nombre,
                            Iniciales = GetIniciales(r.ref_Nombre),
                            r.TotalMascotas,
                            r.MascotasAdoptadas,
                            TasaExito = r.TotalMascotas > 0 ? Math.Round((double)r.MascotasAdoptadas / r.TotalMascotas * 100, 0) : 0
                        })
                        .OrderByDescending(r => r.MascotasAdoptadas)
                        .Take(5)
                        .ToList();

                    if (datos.Count > 0)
                    {
                        rptTopRefugios.DataSource = datos;
                        rptTopRefugios.DataBind();
                        pnlSinRefugios.Visible = false;
                    }
                    else
                    {
                        pnlSinRefugios.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                pnlSinRefugios.Visible = true;
                System.Diagnostics.Debug.WriteLine("Error cargando top refugios: " + ex.Message);
            }
        }

        private void CargarEstadisticasReportes()
        {
            try
            {
                var stats = CapaNegocios.CN_ReporteService.ObtenerEstadisticasReportes();
                
                litReportesTotales.Text = stats.TotalReportes.ToString("N0");
                litReportesPerdidas.Text = stats.Perdidas.ToString("N0");
                litReportesEncontradas.Text = stats.Encontradas.ToString("N0");
                litReportesReunidas.Text = stats.Reunidas.ToString("N0");
                litTotalAvistamientos.Text = stats.TotalAvistamientos.ToString("N0");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cargando estadísticas de reportes: " + ex.Message);
            }
        }

        private string GetRolBadgeClass(int idRol)
        {
            switch (idRol)
            {
                case 1: return "inactive"; // SuperAdmin
                case 2: return "pending";  // AdminRefugio
                case 3: return "pending";  // Refugio
                case 4: return "active";   // Adoptante
                default: return "";
            }
        }

        private string GetEstadoBadgeClass(string estado)
        {
            switch (estado)
            {
                case "Disponible": return "active";
                case "EnProceso": return "pending";
                case "Adoptado": return "active";
                case "Reservado": return "pending";
                default: return "";
            }
        }

        private string GetIniciales(string nombre)
        {
            if (string.IsNullOrEmpty(nombre)) return "";
            var palabras = nombre.Split(' ');
            if (palabras.Length >= 2)
                return (palabras[0][0].ToString() + palabras[1][0].ToString()).ToUpper();
            return nombre.Length >= 2 ? nombre.Substring(0, 2).ToUpper() : nombre.ToUpper();
        }

        protected void btnExportarExcel_Click(object sender, EventArgs e)
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    Response.Clear();
                    Response.Buffer = true;
                    Response.ContentType = "application/vnd.ms-excel";
                    Response.AddHeader("content-disposition", $"attachment;filename=Reporte_RedPatitas_{DateTime.Now:yyyyMMdd}.xls");

                    Response.Write("<html xmlns:x='urn:schemas-microsoft-com:office:excel'>");
                    Response.Write("<head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'></head>");
                    Response.Write("<body>");

                    // Estadísticas Generales
                    Response.Write("<h2>Estadísticas Generales - RedPatitas</h2>");
                    Response.Write($"<p><strong>Fecha:</strong> {DateTime.Now:dd/MM/yyyy HH:mm}</p>");
                    Response.Write("<table border='1' cellpadding='5'>");
                    Response.Write("<tr><th>Métrica</th><th>Valor</th></tr>");
                    Response.Write($"<tr><td>Usuarios Activos</td><td>{db.tbl_Usuarios.Count(u => u.usu_Estado == true)}</td></tr>");
                    Response.Write($"<tr><td>Refugios Verificados</td><td>{db.tbl_Refugios.Count(r => r.ref_Estado == true && r.ref_Verificado == true)}</td></tr>");
                    Response.Write($"<tr><td>Mascotas Registradas</td><td>{db.tbl_Mascotas.Count(m => m.mas_Estado == true)}</td></tr>");
                    Response.Write($"<tr><td>Adopciones Realizadas</td><td>{db.tbl_Mascotas.Count(m => m.mas_EstadoAdopcion == "Adoptado")}</td></tr>");
                    Response.Write("</table><br/>");

                    // Usuarios por Rol
                    Response.Write("<h3>Usuarios por Rol</h3>");
                    Response.Write("<table border='1' cellpadding='5'>");
                    Response.Write("<tr><th>Rol</th><th>Cantidad</th></tr>");
                    var roles = db.tbl_Roles.Select(r => new { r.rol_Nombre, Cantidad = db.tbl_Usuarios.Count(u => u.usu_IdRol == r.rol_IdRol && u.usu_Estado == true) }).ToList();
                    foreach (var rol in roles.Where(r => r.Cantidad > 0))
                    {
                        Response.Write($"<tr><td>{rol.rol_Nombre}</td><td>{rol.Cantidad}</td></tr>");
                    }
                    Response.Write("</table><br/>");

                    // Mascotas por Estado
                    Response.Write("<h3>Mascotas por Estado</h3>");
                    Response.Write("<table border='1' cellpadding='5'>");
                    Response.Write("<tr><th>Estado</th><th>Cantidad</th></tr>");
                    var estados = new[] { "Disponible", "EnProceso", "Adoptado", "Reservado" };
                    foreach (var estado in estados)
                    {
                        var cantidad = db.tbl_Mascotas.Count(m => m.mas_EstadoAdopcion == estado && m.mas_Estado == true);
                        if (cantidad > 0)
                        {
                            Response.Write($"<tr><td>{estado}</td><td>{cantidad}</td></tr>");
                        }
                    }
                    Response.Write("</table>");

                    Response.Write("</body></html>");
                    Response.End();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error exportando Excel: " + ex.Message);
            }
        }
    }
}