using System;
using System.Linq;
using System.Web.Script.Serialization;
using CapaDatos;

namespace RedPatitas.Public
{
    public partial class MapaExtravios : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarReportes();
            }
        }

        private void CargarReportes()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var total = db.tbl_ReportesMascotas.Count();
                    System.Diagnostics.Debug.WriteLine("TOTAL REPORTES: " + total);

                    // ─── Reportes para el mapa ───
                    var reportesMapa = (from r in db.tbl_ReportesMascotas
                                            // Usar join con LEFT JOIN explícito para manejar NULLs
                                        join e in db.tbl_Especies on r.rep_IdEspecie equals e.esp_IdEspecie into especiesJoin
                                        from especie in especiesJoin.DefaultIfEmpty()

                                        where r.rep_Latitud != null && r.rep_Longitud != null

                                        select new
                                        {
                                            r.rep_IdReporte,
                                            r.rep_TipoReporte,
                                            r.rep_NombreMascota,
                                            r.rep_Descripcion,
                                            r.rep_UbicacionUltima,
                                            r.rep_Ciudad,
                                            r.rep_Latitud,
                                            r.rep_Longitud,
                                            r.rep_Estado,
                                            r.rep_FechaEvento,
                                            r.rep_FechaReporte,
                                            r.rep_IdEspecie, // Incluir esto para debug

                                            // SOLUCIÓN: Manejar NULL explícitamente
                                            NombreEspecie = especie != null ? especie.esp_Nombre : "",

                                            FotoPrincipal = db.tbl_FotosReportes
                                                .Where(f => f.fore_IdReporte == r.rep_IdReporte)
                                                .OrderBy(f => f.fore_Orden)
                                                .Select(f => f.fore_Url)
                                                .FirstOrDefault()
                                        }).ToList()
                                        .Select(r => new
                                        {
                                            Id = r.rep_IdReporte,
                                            Tipo = r.rep_TipoReporte ?? "Perdida", // Valor por defecto
                                            Nombre = r.rep_NombreMascota ?? "Sin nombre",

                                            Descripcion = r.rep_Descripcion != null
                                                ? (r.rep_Descripcion.Length > 120
                                                    ? r.rep_Descripcion.Substring(0, 120) + "..."
                                                    : r.rep_Descripcion)
                                                : "",

                                            Ubicacion = !string.IsNullOrEmpty(r.rep_UbicacionUltima)
                                                ? r.rep_UbicacionUltima
                                                : (!string.IsNullOrEmpty(r.rep_Ciudad) ? r.rep_Ciudad : ""),

                                            Latitud = r.rep_Latitud.HasValue ? Convert.ToDouble(r.rep_Latitud.Value) : 0,
                                            Longitud = r.rep_Longitud.HasValue ? Convert.ToDouble(r.rep_Longitud.Value) : 0,

                                            Estado = r.rep_Estado ?? "Activo", // Valor por defecto si es NULL

                                            Especie = r.NombreEspecie ?? "No especificada", // Usar el campo que ya manejamos

                                            Fecha = r.rep_FechaEvento.HasValue
                                                ? r.rep_FechaEvento.Value.ToString("dd/MM/yyyy")
                                                : (r.rep_FechaReporte.HasValue
                                                    ? r.rep_FechaReporte.Value.ToString("dd/MM/yyyy")
                                                    : "Fecha no disponible"),

                                            FechaISO = r.rep_FechaReporte.HasValue
                                                ? r.rep_FechaReporte.Value.ToString("yyyy-MM-ddTHH:mm:ss")
                                                : DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ss"),

                                            FotoPrincipal = r.FotoPrincipal ?? ""
                                        }).ToList();

                    System.Diagnostics.Debug.WriteLine("REPORTES MAPA: " + reportesMapa.Count);

                    // Verificar cuántos tienen coordenadas válidas
                    int conCoordenadas = reportesMapa.Count(r => r.Latitud != 0 && r.Longitud != 0);
                    System.Diagnostics.Debug.WriteLine($"Con coordenadas válidas: {conCoordenadas}");

                    hfReportesJson.Value = new JavaScriptSerializer().Serialize(reportesMapa);

                    // ─── Reportes recientes ───
                    var recientes = (from r in db.tbl_ReportesMascotas
                                     join e in db.tbl_Especies on r.rep_IdEspecie equals e.esp_IdEspecie into especiesJoin
                                     from especie in especiesJoin.DefaultIfEmpty()
                                     orderby r.rep_FechaReporte descending
                                     select new
                                     {
                                         r.rep_IdReporte,
                                         r.rep_TipoReporte,
                                         r.rep_NombreMascota,
                                         r.rep_UbicacionUltima,
                                         r.rep_Ciudad,
                                         r.rep_Estado,
                                         r.rep_FechaEvento,
                                         r.rep_FechaReporte,
                                         NombreEspecie = especie != null ? especie.esp_Nombre : "",
                                         FotoPrincipal = db.tbl_FotosReportes
                                            .Where(f => f.fore_IdReporte == r.rep_IdReporte)
                                            .OrderBy(f => f.fore_Orden)
                                            .Select(f => f.fore_Url)
                                            .FirstOrDefault()
                                     })
                                     .Take(6)
                                     .ToList()
                                     .Select(r => new
                                     {
                                         Id = r.rep_IdReporte,
                                         Tipo = r.rep_TipoReporte ?? "",
                                         Nombre = r.rep_NombreMascota ?? "Sin nombre",
                                         Ubicacion = !string.IsNullOrEmpty(r.rep_UbicacionUltima)
                                            ? r.rep_UbicacionUltima
                                            : (!string.IsNullOrEmpty(r.rep_Ciudad) ? r.rep_Ciudad : "Sin ubicación"),

                                         Estado = r.rep_Estado ?? "Activo",

                                         Especie = r.NombreEspecie ?? "No especificado",

                                         Fecha = r.rep_FechaEvento.HasValue
                                            ? r.rep_FechaEvento.Value.ToString("dd/MM/yyyy")
                                            : (r.rep_FechaReporte.HasValue
                                                ? r.rep_FechaReporte.Value.ToString("dd/MM/yyyy")
                                                : ""),

                                         FotoPrincipal = r.FotoPrincipal ?? ""
                                     }).ToList();

                    if (recientes.Any())
                    {
                        rptListaReportes.DataSource = recientes;
                        rptListaReportes.DataBind();
                        pnlSinReportes.Visible = false;
                    }
                    else
                    {
                        pnlSinReportes.Visible = true;
                    }

                    // ─── Contadores ───
                    litPerdidas.Text = db.tbl_ReportesMascotas.Count(r => r.rep_TipoReporte == "Perdida").ToString();
                    litEncontradas.Text = db.tbl_ReportesMascotas.Count(r => r.rep_TipoReporte == "Encontrada").ToString();
                }
            }
            catch (Exception ex)
            {
                hfReportesJson.Value = "[]";
                pnlSinReportes.Visible = true;
                System.Diagnostics.Debug.WriteLine("Error al cargar reportes mapa: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("StackTrace: " + ex.StackTrace);

                // Mostrar error en la página para debug
                litPerdidas.Text = "Error";
                litEncontradas.Text = "Error";
            }
        }
    }
}
