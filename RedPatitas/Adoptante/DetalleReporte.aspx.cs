using System;
using System.Linq;
using CapaDatos;

namespace RedPatitas.Adoptante
{
    public partial class DetalleReporte : System.Web.UI.Page
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
                int idReporte;
                if (!int.TryParse(Request.QueryString["id"], out idReporte))
                {
                    pnlNoEncontrado.Visible = true;
                    pnlDetalle.Visible = false;
                    return;
                }
                CargarDetalle(idReporte);
            }
        }

        protected void btnMarcarReunidoDetalle_Click(object sender, EventArgs e)
        {
            if (Session["UsuarioId"] == null) return;
            int idReporte;
            if (!int.TryParse(hiddenIdReporte.Value, out idReporte)) return;

            int idUsuario = Convert.ToInt32(Session["UsuarioId"]);
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var reporte = db.tbl_ReportesMascotas
                        .FirstOrDefault(r => r.rep_IdReporte == idReporte
                                          && r.rep_IdUsuario == idUsuario);
                    if (reporte != null)
                    {
                        reporte.rep_Estado = "Reunido";
                        reporte.rep_FechaCierre = DateTime.Now;
                        db.SubmitChanges();
                    }
                }
                ClientScript.RegisterStartupScript(GetType(), "alertReunido",
                    "Swal.fire({icon:'success',title:'¡Qué alegría!',text:'Mascota marcada como Reunida. 🎉'}).then(function(){window.location='MisReportes.aspx';});",
                    true);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al marcar Reunido: " + ex.Message);
            }
        }

        private void CargarDetalle(int idReporte)
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var reporte = db.tbl_ReportesMascotas
                        .FirstOrDefault(r => r.rep_IdReporte == idReporte);

                    if (reporte == null)
                    {
                        pnlNoEncontrado.Visible = true;
                        pnlDetalle.Visible = false;
                        return;
                    }

                    hiddenIdReporte.Value = idReporte.ToString();

                    // Badges tipo y estado
                    bool esPerdida = reporte.rep_TipoReporte == "Perdida";
                    litTipoBadge.Text = string.Format(
                        "<div class='tipo-badge {0}'>{1}</div>",
                        esPerdida ? "tipo-perdida" : "tipo-encontrada",
                        esPerdida ? "😿 MASCOTA PERDIDA" : "🐾 MASCOTA ENCONTRADA");

                    litEstadoBadge.Text = string.Format(
                        "<span class='estado-badge'>{0}</span>", reporte.rep_Estado);

                    litNombreMascota.Text = System.Web.HttpUtility.HtmlEncode(
                        string.IsNullOrEmpty(reporte.rep_NombreMascota)
                            ? "Sin nombre" : reporte.rep_NombreMascota);

                    // Especie
                    if (reporte.rep_IdEspecie.HasValue)
                    {
                        var especie = db.tbl_Especies
                            .FirstOrDefault(s => s.esp_IdEspecie == reporte.rep_IdEspecie.Value);
                        litEspecie.Text = especie != null ? especie.esp_Nombre : "-";
                    }
                    else
                    {
                        litEspecie.Text = "-";
                    }

                    litColor.Text  = System.Web.HttpUtility.HtmlEncode(reporte.rep_Color  ?? "-");
                    litTamano.Text = System.Web.HttpUtility.HtmlEncode(reporte.rep_Tamano ?? "-");
                    litEdad.Text   = System.Web.HttpUtility.HtmlEncode(reporte.rep_EdadAproximada ?? "-");

                    // Sexo legible
                    string sexo = reporte.rep_Sexo == 'M' ? "♂ Macho" :
                                  reporte.rep_Sexo == 'F' ? "♀ Hembra" : "-";
                    litSexo.Text = sexo;

                    // Fecha
                    litFecha.Text = reporte.rep_FechaEvento.HasValue
                        ? reporte.rep_FechaEvento.Value.ToString("dd/MM/yyyy")
                        : (reporte.rep_FechaReporte.HasValue
                            ? reporte.rep_FechaReporte.Value.ToString("dd/MM/yyyy")
                            : "-");

                    litDescripcion.Text = System.Web.HttpUtility.HtmlEncode(
                        reporte.rep_Descripcion ?? "Sin descripción.");

                    litUbicacion.Text = System.Web.HttpUtility.HtmlEncode(
                        reporte.rep_UbicacionUltima ?? reporte.rep_Ciudad ?? "");

                    // Mapa
                    if (reporte.rep_Latitud.HasValue && reporte.rep_Longitud.HasValue)
                    {
                        hfLatDetalle.Value = reporte.rep_Latitud.Value.ToString(
                            System.Globalization.CultureInfo.InvariantCulture);
                        hfLngDetalle.Value = reporte.rep_Longitud.Value.ToString(
                            System.Globalization.CultureInfo.InvariantCulture);
                        pnlMapa.Visible = true;
                    }
                    else
                    {
                        pnlMapa.Visible = false;
                    }

                    // Datos de contacto + acciones del dueño
                    int idUsuario = Convert.ToInt32(Session["UsuarioId"]);
                    bool esDueno = reporte.rep_IdUsuario == idUsuario;

                    litTelefono.Text = System.Web.HttpUtility.HtmlEncode(
                        reporte.rep_TelefonoContacto ?? "No proporcionado");
                    lnkTelefono.NavigateUrl = "tel:" + (reporte.rep_TelefonoContacto ?? "");

                    litEmail.Text = System.Web.HttpUtility.HtmlEncode(
                        reporte.rep_EmailContacto ?? "No proporcionado");

                    pnlContacto.Visible   = true;
                    pnlLoginAviso.Visible = false;

                    bool activo = reporte.rep_Estado != "Reunido" &&
                                  reporte.rep_Estado != "SinResolver";

                    // El dueño ve panel de acciones; otros usuarios pueden reportar avistamiento
                    if (esDueno)
                    {
                        pnlAccionesDueno.Visible   = activo;
                        pnlBtnAvistamiento.Visible = false;
                    }
                    else
                    {
                        pnlAccionesDueno.Visible   = false;
                        pnlBtnAvistamiento.Visible = activo;
                        if (activo)
                        {
                            lnkAvistamiento.NavigateUrl =
                                ResolveUrl("~/Public/RegistrarAvistamiento.aspx?idReporte=" + idReporte);
                        }
                    }

                    // Fotos
                    var fotos = db.tbl_FotosReportes
                        .Where(f => f.fore_IdReporte == idReporte)
                        .OrderBy(f => f.fore_Orden)
                        .ToList();

                    if (fotos.Any())
                    {
                        rptFotos.DataSource = fotos;
                        rptFotos.DataBind();
                        pnlFotos.Visible = true;
                    }
                    else
                    {
                        pnlFotos.Visible = false;
                    }

                    // Avistamientos
                    var avistamientos = db.tbl_Avistamientos
                        .Where(a => a.avi_IdReporte == idReporte)
                        .OrderByDescending(a => a.avi_FechaReporte)
                        .ToList();

                    litTotalAvistamientos.Text = avistamientos.Count.ToString();

                    if (avistamientos.Any())
                    {
                        rptAvistamientos.DataSource = avistamientos;
                        rptAvistamientos.DataBind();
                        pnlSinAvistamientos.Visible = false;
                    }
                    else
                    {
                        pnlSinAvistamientos.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en Adoptante/DetalleReporte: " + ex.Message);
                pnlNoEncontrado.Visible = true;
                pnlDetalle.Visible = false;
            }
        }
    }
}
