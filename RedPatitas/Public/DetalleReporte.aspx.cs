using System;
using System.Linq;
using CapaDatos;

namespace RedPatitas.Public
{
    public partial class DetalleReporte : System.Web.UI.Page
    {
        protected System.Web.UI.WebControls.HiddenField hfAvistamientosCoords;

        protected void Page_Load(object sender, EventArgs e)
        {
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

                    // Badges de tipo y estado
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

                    litColor.Text   = System.Web.HttpUtility.HtmlEncode(reporte.rep_Color   ?? "-");
                    litTamano.Text  = System.Web.HttpUtility.HtmlEncode(reporte.rep_Tamano  ?? "-");
                    litEdad.Text    = System.Web.HttpUtility.HtmlEncode(reporte.rep_EdadAproximada ?? "-");

                    // Sexo legible
                    string sexo = reporte.rep_Sexo == 'M' ? "🐾 Macho" :
                                  reporte.rep_Sexo == 'F' ? "🐾 Hembra" : "-";
                    litSexo.Text = sexo;

                    // Fecha del evento
                    litFecha.Text = reporte.rep_FechaEvento.HasValue
                        ? reporte.rep_FechaEvento.Value.ToString("dd/MM/yyyy")
                        : (reporte.rep_FechaReporte.HasValue
                              ? reporte.rep_FechaReporte.Value.ToString("dd/MM/yyyy")
                              : "-");

                    litDescripcion.Text = System.Web.HttpUtility.HtmlEncode(
                        reporte.rep_Descripcion ?? "Sin descripción.");

                    string ubiUltima = reporte.rep_UbicacionUltima ?? reporte.rep_Ciudad ?? "";
                    int idxUltima = ubiUltima.IndexOf("(Coords: ");
                    if (idxUltima >= 0) {
                        ubiUltima = ubiUltima.Substring(0, idxUltima).Trim();
                    }
                    litUbicacion.Text = System.Web.HttpUtility.HtmlEncode(ubiUltima);

                    // Coordenadas para el mapa
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

                    // Contacto — solo si está logueado
                    bool logueado = Session["UsuarioId"] != null;
                    if (logueado)
                    {
                        litTelefono.Text = System.Web.HttpUtility.HtmlEncode(
                            reporte.rep_TelefonoContacto ?? "No proporcionado");
                        lnkTelefono.NavigateUrl = "tel:" + (reporte.rep_TelefonoContacto ?? "");

                        litEmail.Text = System.Web.HttpUtility.HtmlEncode(
                            reporte.rep_EmailContacto ?? "No proporcionado");

                        pnlContacto.Visible   = true;
                        pnlLoginAviso.Visible = false;
                    }
                    else
                    {
                        pnlContacto.Visible       = false;
                        pnlLoginAviso.Visible     = true;
                    }

                    // Botón avistamiento visible para todos excepto para el dueño
                    bool activo = reporte.rep_Estado != "Reunido" &&
                                  reporte.rep_Estado != "SinResolver";
                    bool esDueno = false;
                    
                    if (logueado)
                    {
                        int idUsuario = Convert.ToInt32(Session["UsuarioId"]);
                        esDueno = reporte.rep_IdUsuario == idUsuario;
                    }

                    pnlBtnAvistamiento.Visible = activo && !esDueno;
                    if (activo && !esDueno)
                    {
                        lnkAvistamiento.NavigateUrl =
                            ResolveUrl("~/Public/RegistrarAvistamiento.aspx?idReporte=" + idReporte);
                    }

                    // Fotos del reporte
                    var fotos = db.tbl_FotosReportes
                        .Where(f => f.fore_IdReporte == idReporte)
                        .OrderBy(f => f.fore_Orden)
                        .ToList();

                    if (fotos.Any())
                    {
                        rptFotos.DataSource = fotos;
                        rptFotos.DataBind();
                        pnlFotos.Visible = true;
                        pnlSinFoto.Visible = false;
                    }
                    else
                    {
                        pnlFotos.Visible = false;
                        pnlSinFoto.Visible = true;
                    }

                    // Avistamientos
                    var avistamientos = db.tbl_Avistamientos
                        .Where(a => a.avi_IdReporte == idReporte)
                        .OrderBy(a => a.avi_FechaAvistamiento ?? a.avi_FechaReporte) // Orden ascendente para la ruta
                        .ToList();

                    var avistamientosList = avistamientos.Select(a => {
                        string ubi = a.avi_Ubicacion ?? "";
                        string latStr = "";
                        string lngStr = "";
                        int idx = ubi.IndexOf("(Coords: ");
                        if(idx >= 0) {
                            string coords = ubi.Substring(idx + 9).Replace(")", "");
                            var parts = coords.Split(',');
                            if(parts.Length == 2) {
                                latStr = parts[0].Trim();
                                lngStr = parts[1].Trim();
                            }
                            ubi = ubi.Substring(0, idx).Trim();
                        }
                        return new {
                            UbicacionLimpia = ubi,
                            Lat = latStr,
                            Lng = lngStr,
                            a.avi_Descripcion,
                            Fecha = a.avi_FechaAvistamiento ?? a.avi_FechaReporte
                        };
                    }).ToList();

                    // Lista para mostrar ordenada descendente
                    var avistamientosView = avistamientosList.OrderByDescending(a => a.Fecha).ToList();

                    litTotalAvistamientos.Text = avistamientosView.Count.ToString();

                    if (avistamientosView.Any())
                    {
                        rptAvistamientos.DataSource = avistamientosView;
                        rptAvistamientos.DataBind();
                        pnlSinAvistamientos.Visible = false;

                        // Construir JSON de coordenadas para el mapa
                        var arrayPuntos = avistamientosList
                                            .Where(x => !string.IsNullOrEmpty(x.Lat) && !string.IsNullOrEmpty(x.Lng))
                                            .Select(x => "{\"lat\": " + x.Lat + ", \"lng\": " + x.Lng + ", \"desc\": \"" + System.Web.HttpUtility.JavaScriptStringEncode(x.UbicacionLimpia) + "\"}")
                                            .ToArray();
                        
                        hfAvistamientosCoords.Value = "[" + string.Join(",", arrayPuntos) + "]";
                    }
                    else
                    {
                        pnlSinAvistamientos.Visible = true;
                        hfAvistamientosCoords.Value = "[]";
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en DetalleReporte: " + ex.Message);
                pnlNoEncontrado.Visible = true;
                pnlDetalle.Visible = false;
            }
        }
    }
}
