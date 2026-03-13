using System;
using System.Linq;
using CapaDatos;

namespace RedPatitas.Public
{
    public partial class RegistrarAvistamiento : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            // Habilitar subida de archivos
            if (Page.Form != null)
            {
                Page.Form.Enctype = "multipart/form-data";
            }

            if (!IsPostBack)
            {
                int idReporte;
                if (!int.TryParse(Request.QueryString["idReporte"], out idReporte))
                {
                    Response.Redirect("~/Public/MapaExtravios.aspx");
                    return;
                }

                hfIdReporte.Value = idReporte.ToString();
                CargarInfoReporte(idReporte);
            }
        }

        private void CargarInfoReporte(int idReporte)
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var reporte = db.tbl_ReportesMascotas
                        .FirstOrDefault(r => r.rep_IdReporte == idReporte);

                    if (reporte == null ||
                        reporte.rep_Estado == "Reunido" ||
                        reporte.rep_Estado == "SinResolver")
                    {
                        Response.Redirect("~/Public/MapaExtravios.aspx");
                        return;
                    }

                    string nombre = string.IsNullOrEmpty(reporte.rep_NombreMascota)
                        ? "Mascota sin nombre" : reporte.rep_NombreMascota;

                    litNombreReporte.Text = (reporte.rep_TipoReporte == "Perdida" ? "😿 " : "🐾 ") +
                        System.Web.HttpUtility.HtmlEncode(nombre);

                    litInfoReporte.Text = string.Format("{0} · {1} · Reportado el {2}",
                        reporte.rep_TipoReporte,
                        System.Web.HttpUtility.HtmlEncode(reporte.rep_Ciudad ?? "Sin ciudad"),
                        reporte.rep_FechaReporte.HasValue
                            ? reporte.rep_FechaReporte.Value.ToString("dd/MM/yyyy") : "");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cargando info reporte: " + ex.Message);
            }
        }

        protected void btnEnviar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int idReporte = Convert.ToInt32(hfIdReporte.Value);
            int? idUsuario = Session["UsuarioId"] != null ? (int?)Convert.ToInt32(Session["UsuarioId"]) : null;

            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    string ubicacionCompleta = txtUbicacion.Text.Trim();

                    // Añadir coordenadas a la descripción de ubicación si se marcó en el mapa
                    if (!string.IsNullOrEmpty(hfLat.Value) && !string.IsNullOrEmpty(hfLng.Value))
                    {
                        ubicacionCompleta += string.Format(" (Coords: {0}, {1})",
                            hfLat.Value, hfLng.Value);
                    }

                    var avistamiento = new tbl_Avistamientos
                    {
                        avi_IdReporte = idReporte,
                        avi_IdUsuario = idUsuario,
                        avi_Ubicacion = ubicacionCompleta,
                        avi_Descripcion = txtDescripcion.Text.Trim(),
                        avi_FechaAvistamiento = !string.IsNullOrEmpty(txtFechaAvistamiento.Text)
                                                ? DateTime.Parse(txtFechaAvistamiento.Text)
                                                : DateTime.Now,
                        avi_FechaReporte = DateTime.Now
                    };

                    db.tbl_Avistamientos.InsertOnSubmit(avistamiento);

                    // Actualizar estado y ubicación del reporte
                    var reporte = db.tbl_ReportesMascotas
                        .FirstOrDefault(r => r.rep_IdReporte == idReporte);

                    if (reporte != null)
                    {
                        // Update location based on this sighting
                        if (!string.IsNullOrEmpty(hfLat.Value) && !string.IsNullOrEmpty(hfLng.Value))
                        {
                            decimal lat, lng;
                            if (decimal.TryParse(hfLat.Value, System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out lat) &&
                                decimal.TryParse(hfLng.Value, System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out lng))
                            {
                                reporte.rep_Latitud = lat;
                                reporte.rep_Longitud = lng;
                            }
                        }
                        reporte.rep_UbicacionUltima = ubicacionCompleta;

                        if (reporte.rep_Estado == "Reportado" || reporte.rep_Estado == "EnBusqueda")
                        {
                            reporte.rep_Estado = "Avistado";

                            // Notificar al dueño
                            var notificacion = new tbl_Notificaciones
                            {
                                not_IdUsuario = reporte.rep_IdUsuario,
                                not_Titulo = "👁 ¡Avistaron a tu mascota!",
                                not_Mensaje = string.Format(
                                    "Alguien reportó haber visto a {0} en: {1}",
                                    string.IsNullOrEmpty(reporte.rep_NombreMascota)
                                        ? "tu mascota"
                                        : reporte.rep_NombreMascota,
                                    ubicacionCompleta),
                                not_Tipo = "Reporte",
                                not_Icono = "👁",
                                not_UrlAccion = "~/Public/DetalleReporte.aspx?id=" + idReporte,
                                not_Leida = false,
                                not_FechaCreacion = DateTime.Now
                            };
                            db.tbl_Notificaciones.InsertOnSubmit(notificacion);
                        }

                        db.SubmitChanges();

                        // Procesar foto opcional del avistamiento y guardarla en tbl_FotosReportes
                        if (fuFotoAvistamiento.HasFile)
                        {
                            string extension = System.IO.Path.GetExtension(fuFotoAvistamiento.FileName).ToLower();
                            string[] extensionesPermitidas = { ".jpg", ".jpeg", ".png", ".gif" };

                            if (extensionesPermitidas.Contains(extension))
                            {
                                int maxSize = 5 * 1024 * 1024; // 5MB
                                if (fuFotoAvistamiento.PostedFile.ContentLength <= maxSize)
                                {
                                    string fileName = Guid.NewGuid().ToString() + "_avist" + extension;
                                    string savePath = Server.MapPath("~/Uploads/Reportes/" + fileName);

                                    string dirPath = Server.MapPath("~/Uploads/Reportes/");
                                    if (!System.IO.Directory.Exists(dirPath))
                                    {
                                        System.IO.Directory.CreateDirectory(dirPath);
                                    }

                                    fuFotoAvistamiento.SaveAs(savePath);

                                    var nuevaFoto = new tbl_FotosReportes
                                    {
                                        fore_IdReporte = idReporte,
                                        fore_Url = "~/Uploads/Reportes/" + fileName,
                                        fore_Orden = 99 // Para que aparezca al final
                                    };
                                    db.tbl_FotosReportes.InsertOnSubmit(nuevaFoto);
                                    db.SubmitChanges();
                                }
                            }
                        }

                        string urlDetalle = ResolveUrl("~/Public/DetalleReporte.aspx?id=" + idReporte);

                        ClientScript.RegisterStartupScript(GetType(), "alertExito",
                            string.Format(
                                "Swal.fire({{icon:'success',title:'¡Avistamiento registrado!'," +
                                "text:'Gracias. La mascota ha sido actualizada en el mapa y el dueño ha sido notificado.'," +
                                "confirmButtonText:'Ver detalle del reporte'}})" +
                                ".then(function(r){{if(r.isConfirmed || true)window.location.href='{0}';}});",
                                urlDetalle),
                            true);
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error registrando avistamiento: " + ex.Message);
                pnlMensaje.Visible = true;
                lblMensaje.Text = "❌ Error al registrar el avistamiento. Inténtalo de nuevo.";
                lblMensaje.ForeColor = System.Drawing.Color.Red;
            }
        }
    }
}
