using System;
using System.Linq;
using System.Web.UI.WebControls;
using CapaDatos;

namespace RedPatitas.Adoptante
{
    public partial class MisReportes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Verificar sesión (OBLIGATORIO según SKILL)
            if (Session["UsuarioId"] == null)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CargarReportes();
            }
        }

        /// <summary>
        /// Método helper llamado desde el DataBinding del Repeater.
        /// Genera el HTML de la foto principal de cada reporte.
        /// Separado del ASPX para poder usar ResolveUrl() correctamente.
        /// </summary>
        protected string ObtenerHtmlFoto(object urlFoto)
        {
            string url = urlFoto?.ToString();
            if (!string.IsNullOrEmpty(url))
            {
                string urlResuelta = ResolveUrl(url);
                return string.Format(
                    "<img src='{0}' style='width:100%;height:100%;object-fit:cover;' alt='Foto de la mascota' />",
                    urlResuelta);
            }
            return "<div class='reporte-foto-placeholder'>🐾</div>";
        }

        private void CargarReportes()
        {
            try
            {
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);

                using (var db = new DataClasses1DataContext())
                {
                    var reportes = (from r in db.tbl_ReportesMascotas
                                    join esp in db.tbl_Especies
                                        on r.rep_IdEspecie equals esp.esp_IdEspecie into espJoin
                                    from especie in espJoin.DefaultIfEmpty()
                                    where r.rep_IdUsuario == idUsuario
                                    orderby r.rep_FechaReporte descending
                                    select new
                                    {
                                        r.rep_IdReporte,
                                        r.rep_TipoReporte,
                                        r.rep_NombreMascota,
                                        r.rep_Color,
                                        r.rep_Ciudad,
                                        r.rep_Estado,
                                        r.rep_FechaReporte,
                                        EspecieNombre = especie != null ? especie.esp_Nombre : "No especificado",
                                        TotalAvistamientos = db.tbl_Avistamientos
                                            .Count(a => a.avi_IdReporte == r.rep_IdReporte),
                                        FotoPrincipal = db.tbl_FotosReportes
                                            .Where(f => f.fore_IdReporte == r.rep_IdReporte)
                                            .OrderBy(f => f.fore_Orden)
                                            .ThenBy(f => f.fore_IdFoto)
                                            .Select(f => f.fore_Url)
                                            .FirstOrDefault()
                                    }).ToList();

                    if (reportes.Any())
                    {
                        rptReportes.DataSource = reportes;
                        rptReportes.DataBind();
                        pnlEmpty.Visible = false;
                    }
                    else
                    {
                        rptReportes.DataSource = null;
                        rptReportes.DataBind();
                        pnlEmpty.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar reportes: " + ex.Message);
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "alert alert-danger";
                lblMensaje.Text = "❌ Error al cargar los reportes. Inténtalo de nuevo.";
                lblMensaje.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void rptReportes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // Verificar sesión antes de cualquier acción
            if (Session["UsuarioId"] == null) return;

            int idReporte = Convert.ToInt32(e.CommandArgument);
            int idUsuario = Convert.ToInt32(Session["UsuarioId"]);

            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    // Verificar que el reporte pertenece al usuario (SEGURIDAD)
                    var reporte = db.tbl_ReportesMascotas
                        .FirstOrDefault(r => r.rep_IdReporte == idReporte
                                          && r.rep_IdUsuario == idUsuario);

                    if (reporte == null)
                    {
                        ClientScript.RegisterStartupScript(GetType(), "alertError",
                            "Swal.fire({icon:'error',title:'Sin permiso',text:'No puedes modificar este reporte.'});",
                            true);
                        return;
                    }

                    if (e.CommandName == "MarcarReunido")
                    {
                        reporte.rep_Estado = "Reunido";
                        reporte.rep_FechaCierre = DateTime.Now;
                        db.SubmitChanges();

                        ClientScript.RegisterStartupScript(GetType(), "alertExito",
                            "Swal.fire({icon:'success',title:'¡Qué alegría!',text:'Reporte marcado como Reunido. 🎉'});",
                            true);
                    }
                    else if (e.CommandName == "CerrarSinResolver")
                    {
                        reporte.rep_Estado = "SinResolver";
                        reporte.rep_FechaCierre = DateTime.Now;
                        db.SubmitChanges();

                        ClientScript.RegisterStartupScript(GetType(), "alertCerrado",
                            "Swal.fire({icon:'info',title:'Reporte cerrado',text:'El reporte quedó marcado como Sin Resolver.'});",
                            true);
                    }

                    // Recargar la lista después de la acción
                    CargarReportes();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en ItemCommand: " + ex.Message);
                ClientScript.RegisterStartupScript(GetType(), "alertError",
                    "Swal.fire({icon:'error',title:'Error',text:'No se pudo actualizar el reporte.'});",
                    true);
            }
        }
    }
}
