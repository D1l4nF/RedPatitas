using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaDatos;
using CapaNegocios;

namespace RedPatitas.AdminRefugio
{
    public partial class Estadisticas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["RefugioId"] == null)
                {
                    Response.Redirect("~/Login/Login.aspx");
                    return;
                }
                CargarDatosDashboard();
            }
        }

        private void CargarDatosDashboard()
        {
            try
            {
                int idRefugio = Convert.ToInt32(Session["RefugioId"]);
                CN_MascotaService mascotaService = new CN_MascotaService();

                // =========================================
                // 1. OBTENER DATOS BASE
                // =========================================
                var mascotas = mascotaService.ObtenerMascotasPorRefugio(idRefugio);
                var solicitudesPendientes = CN_AdopcionService.SolicitudesRecibidas(idRefugio);
                var adopcionesPorMes = CN_AdopcionService.ObtenerAdopcionesPorMes(idRefugio);

                int totalMascotas = mascotas.Count;
                int mascotasDisponibles = mascotas.Count(m => m.EstadoAdopcion == "Disponible");
                int mascotasEnProceso = mascotas.Count(m => m.EstadoAdopcion == "EnProceso");
                int mascotasAdoptadas = mascotas.Count(m => m.EstadoAdopcion == "Adoptado");
                int totalSolicitudesPendientes = solicitudesPendientes.Count;
                int totalAdopciones = adopcionesPorMes.Sum(x => x.Value);

                // =========================================
                // 2. KPIs PRINCIPALES
                // =========================================
                litTotalMascotas.Text = totalMascotas.ToString();
                litTotalAdopciones.Text = totalAdopciones.ToString();
                litSolicitudesPendientes.Text = totalSolicitudesPendientes.ToString();

                // Tasa de éxito (adopciones / total mascotas registradas * 100)
                double tasaExito = totalMascotas > 0 ? Math.Round((double)mascotasAdoptadas / totalMascotas * 100, 1) : 0;
                litTasaExito.Text = tasaExito.ToString("0");

                // Tendencias (mascotas nuevas este mes)
                int mascotasNuevasEsteMes = mascotas.Count(m => m.FechaRegistro.HasValue && 
                    m.FechaRegistro.Value.Month == DateTime.Now.Month && 
                    m.FechaRegistro.Value.Year == DateTime.Now.Year);
                litTrendMascotas.Text = "+" + mascotasNuevasEsteMes.ToString();

                // Tendencia adopciones (comparar con mes anterior si hay datos)
                if (adopcionesPorMes.Count >= 2)
                {
                    var valores = adopcionesPorMes.Values.ToList();
                    double mesActual = valores.Last();
                    double mesAnterior = valores[valores.Count - 2];
                    if (mesAnterior > 0)
                    {
                        double variacion = ((mesActual - mesAnterior) / mesAnterior) * 100;
                        litTrendAdopciones.Text = (variacion >= 0 ? "+" : "") + variacion.ToString("0") + "%";
                    }
                }

                // =========================================
                // 3. GRÁFICO ADOPCIONES POR MES
                // =========================================
                if (adopcionesPorMes.Count == 0)
                {
                    adopcionesPorMes.Add("Sin datos", 0);
                }
                hfLabelsAdopciones.Value = string.Join(",", adopcionesPorMes.Keys);
                hfDataAdopciones.Value = string.Join(",", adopcionesPorMes.Values);

                // =========================================
                // 4. GRÁFICO POR ESPECIE
                // =========================================
                var dictEspecies = mascotaService.ObtenerConteoPorEspecie(idRefugio);
                if (dictEspecies.Count == 0)
                {
                    dictEspecies.Add("Sin mascotas", 0);
                }
                hfLabelsEspecies.Value = string.Join(",", dictEspecies.Keys);
                hfDataEspecies.Value = string.Join(",", dictEspecies.Values);

                // =========================================
                // 5. GRÁFICO POR ESTADO
                // =========================================
                var estadosData = new Dictionary<string, int>
                {
                    { "Disponible", mascotasDisponibles },
                    { "En Proceso", mascotasEnProceso },
                    { "Adoptado", mascotasAdoptadas }
                };
                hfLabelsEstados.Value = string.Join(",", estadosData.Keys);
                hfDataEstados.Value = string.Join(",", estadosData.Values);

                // =========================================
                // 6. MÉTRICAS DE RENDIMIENTO
                // =========================================
                // Tiempo promedio de respuesta (simulado - podrías calcular real si tienes fechas)
                litTiempoRespuesta.Text = "2.5";

                // Capacidad del refugio (estimada como % basado en mascotas disponibles)
                // Asumimos capacidad máxima de 50 mascotas como ejemplo
                int capacidadMaxima = 50;
                int capacidadPorcentaje = Math.Min(100, (totalMascotas * 100) / capacidadMaxima);
                litCapacidad.Text = capacidadPorcentaje.ToString();
                progressCapacidad.Style["width"] = capacidadPorcentaje + "%";

                // Meta mensual (configurable, tomamos 10 como default)
                int metaMensual = 10;
                int adopcionesEsteMes = adopcionesPorMes.LastOrDefault().Value;
                litMetaProgreso.Text = adopcionesEsteMes.ToString();
                litMetaTotal.Text = metaMensual.ToString();
                int metaPorcentaje = Math.Min(100, (adopcionesEsteMes * 100) / metaMensual);
                progressMeta.Style["width"] = metaPorcentaje + "%";

                // =========================================
                // 7. ACTIVIDAD RECIENTE
                // =========================================
                var actividadReciente = new List<object>();

                // Últimas solicitudes pendientes
                foreach (var sol in solicitudesPendientes.Take(3))
                {
                    actividadReciente.Add(new
                    {
                        Titulo = $"Nueva solicitud para {sol.NombreMascota}",
                        Tiempo = sol.sol_FechaSolicitud.HasValue ? 
                            FormatearTiempoRelativo(sol.sol_FechaSolicitud.Value) : "Reciente",
                        TipoClase = "warning"
                    });
                }

                // Mascotas nuevas
                foreach (var m in mascotas.Where(x => x.EsNueva).Take(2))
                {
                    actividadReciente.Add(new
                    {
                        Titulo = $"{m.Nombre} fue registrado/a",
                        Tiempo = m.FechaRegistro.HasValue ? 
                            FormatearTiempoRelativo(m.FechaRegistro.Value) : "Reciente",
                        TipoClase = "info"
                    });
                }

                if (actividadReciente.Count > 0)
                {
                    rptActividad.DataSource = actividadReciente.OrderBy(x => x.GetType().GetProperty("Tiempo").GetValue(x)).Take(5);
                    rptActividad.DataBind();
                }
                else
                {
                    noActivity.Visible = true;
                }

            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error CargarEstadisticas: " + ex.Message);
            }
        }

        private string FormatearTiempoRelativo(DateTime fecha)
        {
            var diferencia = DateTime.Now - fecha;

            if (diferencia.TotalMinutes < 60)
                return "Hace " + (int)diferencia.TotalMinutes + " min";
            if (diferencia.TotalHours < 24)
                return "Hace " + (int)diferencia.TotalHours + " horas";
            if (diferencia.TotalDays < 7)
                return "Hace " + (int)diferencia.TotalDays + " días";
            
            return fecha.ToString("dd/MM/yyyy");
        }
    }
}
