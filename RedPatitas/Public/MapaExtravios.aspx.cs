using System;
using System.Collections.Generic;
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
                    // Obtener reportes activos con coordenadas
                    var reportes = db.tbl_ReportesMascotas
                        .Where(r => r.rep_Estado != "Reunido" && r.rep_Estado != "SinResolver")
                        .Where(r => r.rep_Latitud != null && r.rep_Longitud != null)
                        .Select(r => new
                        {
                            Id = r.rep_IdReporte,
                            Tipo = r.rep_TipoReporte,
                            Nombre = r.rep_NombreMascota ?? "Sin nombre",
                            Descripcion = r.rep_Descripcion != null ? 
                                (r.rep_Descripcion.Length > 100 ? r.rep_Descripcion.Substring(0, 100) + "..." : r.rep_Descripcion) : "",
                            Ubicacion = r.rep_UbicacionUltima ?? r.rep_Ciudad ?? "",
                            Latitud = r.rep_Latitud,
                            Longitud = r.rep_Longitud,
                            Fecha = r.rep_FechaEvento.HasValue ? r.rep_FechaEvento.Value.ToString("dd/MM/yyyy") : 
                                    r.rep_FechaReporte.HasValue ? r.rep_FechaReporte.Value.ToString("dd/MM/yyyy") : "",
                            Telefono = r.rep_TelefonoContacto ?? ""
                        })
                        .ToList();

                    // Serializar a JSON para JavaScript
                    var serializer = new JavaScriptSerializer();
                    hfReportesJson.Value = serializer.Serialize(reportes);

                    // Contar estadísticas
                    int perdidas = reportes.Count(r => r.Tipo == "Perdida");
                    int encontradas = reportes.Count(r => r.Tipo == "Encontrada");

                    litPerdidas.Text = perdidas.ToString();
                    litEncontradas.Text = encontradas.ToString();
                }
            }
            catch (Exception ex)
            {
                // En caso de error, mostrar mapa vacío
                hfReportesJson.Value = "[]";
                System.Diagnostics.Debug.WriteLine("Error al cargar reportes: " + ex.Message);
            }
        }
    }
}
