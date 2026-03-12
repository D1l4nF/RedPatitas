using System;
using System.Linq;
using CapaDatos;

namespace RedPatitas.Admin
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

                    bool esPerdida = reporte.rep_TipoReporte == "Perdida";

                    litTipoBadge.Text = string.Format(
                        "<div class='tipo-badge {0}'>{1}</div>",
                        esPerdida ? "tipo-perdida" : "tipo-encontrada",
                        esPerdida ? "😿 MASCOTA PERDIDA" : "🐾 MASCOTA ENCONTRADA");

                    litEstadoBadge.Text =
                        "<span class='estado-badge'>" + reporte.rep_Estado + "</span>";

                    litNombreMascota.Text =
                        string.IsNullOrEmpty(reporte.rep_NombreMascota)
                        ? "Sin nombre"
                        : reporte.rep_NombreMascota;

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

                    litColor.Text = reporte.rep_Color ?? "-";
                    litTamano.Text = reporte.rep_Tamano ?? "-";
                    litEdad.Text = reporte.rep_EdadAproximada ?? "-";

                    string sexo = reporte.rep_Sexo == 'M'
                        ? "♂ Macho"
                        : reporte.rep_Sexo == 'F'
                        ? "♀ Hembra"
                        : "-";

                    litSexo.Text = sexo;

                    // Fecha
                    litFecha.Text = reporte.rep_FechaEvento.HasValue
                        ? reporte.rep_FechaEvento.Value.ToString("dd/MM/yyyy")
                        : "-";

                    litDescripcion.Text =
                        string.IsNullOrEmpty(reporte.rep_Descripcion)
                        ? "Sin descripción."
                        : reporte.rep_Descripcion;

                    litUbicacion.Text =
                        reporte.rep_UbicacionUltima ?? reporte.rep_Ciudad ?? "";

                    // MAPA
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

                    // CONTACTO (admin siempre puede verlo)
                    litTelefono.Text = reporte.rep_TelefonoContacto ?? "No proporcionado";
                    lnkTelefono.NavigateUrl = "tel:" + (reporte.rep_TelefonoContacto ?? "");

                    litEmail.Text = reporte.rep_EmailContacto ?? "No proporcionado";

                    pnlContacto.Visible = true;
                    pnlLoginAviso.Visible = false;

                    // FOTOS
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

                    // AVISTAMIENTOS
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
                System.Diagnostics.Debug.WriteLine("Error en Admin/DetalleReporte: " + ex.Message);

                pnlNoEncontrado.Visible = true;
                pnlDetalle.Visible = false;
            }
        }
    }
}
