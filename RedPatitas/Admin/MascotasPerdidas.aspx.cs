using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaDatos;

namespace RedPatitas.Admin
{
    public partial class MascotasPerdidas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarEstadisticas();
                CargarReportes();
            }
        }

        private void CargarEstadisticas()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    litTotalReportes.Text = db.tbl_ReportesMascotas.Count().ToString();
                    litPerdidas.Text = db.tbl_ReportesMascotas.Count(r => r.rep_TipoReporte == "Perdida").ToString();
                    litEncontradas.Text = db.tbl_ReportesMascotas.Count(r => r.rep_TipoReporte == "Encontrada").ToString();
                    litReunidas.Text = db.tbl_ReportesMascotas.Count(r => r.rep_Estado == "Reunido").ToString();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cargando estadísticas: " + ex.Message);
            }
        }

        protected void Filtros_Changed(object sender, EventArgs e)
        {
            CargarReportes();
        }

        private void CargarReportes()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var query = db.tbl_ReportesMascotas.AsQueryable();

                    // Filtro por tipo
                    if (!string.IsNullOrEmpty(ddlTipo.SelectedValue))
                    {
                        query = query.Where(r => r.rep_TipoReporte == ddlTipo.SelectedValue);
                    }

                    // Filtro por estado
                    if (!string.IsNullOrEmpty(ddlEstado.SelectedValue))
                    {
                        query = query.Where(r => r.rep_Estado == ddlEstado.SelectedValue);
                    }

                    // Búsqueda
                    if (!string.IsNullOrEmpty(txtBusqueda.Text))
                    {
                        var busqueda = txtBusqueda.Text.Trim().ToLower();
                        query = query.Where(r => 
                            (r.rep_NombreMascota != null && r.rep_NombreMascota.ToLower().Contains(busqueda)) ||
                            (r.rep_Ciudad != null && r.rep_Ciudad.ToLower().Contains(busqueda)));
                    }

                    var reportes = query
                        .OrderByDescending(r => r.rep_FechaReporte)
                        .Take(50)
                        .Select(r => new
                        {
                            IdReporte = r.rep_IdReporte,
                            NombreMascota = r.rep_NombreMascota ?? "Sin nombre",
                            TipoReporte = r.rep_TipoReporte,
                            Especie = r.tbl_Especies != null ? r.tbl_Especies.esp_Nombre : "Desconocida",
                            Raza = r.rep_Raza ?? "Desconocida",
                            Ciudad = r.rep_Ciudad ?? "-",
                            Estado = r.rep_Estado,
                            FechaReporte = r.rep_FechaReporte
                        })
                        .ToList();

                    if (reportes.Count > 0)
                    {
                        rptReportes.DataSource = reportes;
                        rptReportes.DataBind();
                        pnlSinReportes.Visible = false;
                    }
                    else
                    {
                        pnlSinReportes.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                pnlSinReportes.Visible = true;
                System.Diagnostics.Debug.WriteLine("Error cargando reportes: " + ex.Message);
            }
        }

        protected void rptReportes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // Acciones de gestión se han movido al panel Adoptante (MisReportes.aspx)
            // El Admin solo tiene visibilidad, no acciones de cambio de estado
        }

        protected string GetEstadoBadgeClass(string estado)
        {
            switch (estado)
            {
                case "Reportado": return "pending";
                case "EnBusqueda": return "pending";
                case "Avistado": return "pending";
                case "Encontrado": return "active";
                case "Reunido": return "active";
                case "SinResolver": return "inactive";
                default: return "";
            }
        }
    }
}
