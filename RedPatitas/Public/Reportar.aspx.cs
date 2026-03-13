using System;
using System.Linq;
using System.Web.UI;
using CapaDatos;

namespace RedPatitas.Public
{
    public partial class Reportar : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // No requiere sesión — formulario público
        }

        protected void btnPublicarReporte_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                string tipoReporte = rbPerdida.Checked ? "Perdida" : "Encontrada";

                using (var db = new DataClasses1DataContext())
                {
                    var reporte = new tbl_ReportesMascotas
                    {
                        rep_IdUsuario        = Session["UsuarioId"] != null
                                                ? Convert.ToInt32(Session["UsuarioId"])
                                                : 1,  // Usuario genérico para reportes públicos
                        rep_TipoReporte      = tipoReporte,
                        rep_NombreMascota    = txtNombreMascota.Text.Trim(),
                        rep_Raza             = txtRaza.Text.Trim(),
                        rep_Color            = txtColor.Text.Trim(),
                        rep_Descripcion      = txtDescripcion.Text.Trim(),
                        rep_UbicacionUltima  = txtDireccion.Text.Trim(),
                        rep_Ciudad           = txtCiudad.Text.Trim(),
                        rep_TelefonoContacto = txtTelefono.Text.Trim(),
                        rep_EmailContacto    = txtEmail.Text.Trim(),
                        rep_Estado           = "Reportado",
                        rep_FechaReporte     = DateTime.Now,
                        // Tipo de animal (perro/gato/otro) → buscar especie
                        rep_IdEspecie        = ObtenerIdEspecie(db, ddlTipoAnimal.SelectedValue)
                    };

                    // Coordenadas del mapa
                    if (!string.IsNullOrEmpty(hfLatitud.Value) && !string.IsNullOrEmpty(hfLongitud.Value))
                    {
                        reporte.rep_Latitud  = decimal.Parse(hfLatitud.Value,
                            System.Globalization.CultureInfo.InvariantCulture);
                        reporte.rep_Longitud = decimal.Parse(hfLongitud.Value,
                            System.Globalization.CultureInfo.InvariantCulture);
                    }

                    // Fecha del evento
                    if (!string.IsNullOrEmpty(txtFecha.Text))
                        reporte.rep_FechaEvento = DateTime.Parse(txtFecha.Text);

                    // Guardar nombre del contacto en descripción si aplica
                    if (!string.IsNullOrEmpty(txtNombreContacto.Text.Trim()))
                        reporte.rep_Descripcion = "[Contacto: " + txtNombreContacto.Text.Trim() + "] " +
                                                  reporte.rep_Descripcion;

                    db.tbl_ReportesMascotas.InsertOnSubmit(reporte);
                    db.SubmitChanges();

                    // Registrar la ubicación original como el primer avistamiento para el mapa
                    if (reporte.rep_Latitud.HasValue && reporte.rep_Longitud.HasValue)
                    {
                        var avistamientoInicial = new tbl_Avistamientos
                        {
                            avi_IdReporte = reporte.rep_IdReporte,
                            avi_IdUsuario = reporte.rep_IdUsuario,
                            avi_Ubicacion = reporte.rep_UbicacionUltima + " (Coords: " + 
                                reporte.rep_Latitud.Value.ToString(System.Globalization.CultureInfo.InvariantCulture) + ", " + 
                                reporte.rep_Longitud.Value.ToString(System.Globalization.CultureInfo.InvariantCulture) + ")",
                            avi_Descripcion = "Reportado inicialmente en esta ubicación.",
                            avi_FechaAvistamiento = reporte.rep_FechaEvento ?? reporte.rep_FechaReporte,
                            avi_FechaReporte = DateTime.Now
                        };
                        db.tbl_Avistamientos.InsertOnSubmit(avistamientoInicial);
                        db.SubmitChanges();
                    }

                    // ── Guardar fotos si se subieron ─────────────────────────────
                    if (fuImagenes.HasFiles)
                    {
                        string uploadPath = Server.MapPath("~/Uploads/Reportes/");
                        if (!System.IO.Directory.Exists(uploadPath))
                            System.IO.Directory.CreateDirectory(uploadPath);

                        int orden = 0;
                        foreach (var file in fuImagenes.PostedFiles)
                        {
                            if (file.ContentLength == 0 || orden >= 5) continue;
                            string ext = System.IO.Path.GetExtension(file.FileName).ToLower();
                            if (ext != ".jpg" && ext != ".jpeg" && ext != ".png") continue;
                            if (file.ContentLength > 5 * 1024 * 1024) continue;

                            string nombre    = Guid.NewGuid() + ext;
                            string rutaFisica = System.IO.Path.Combine(uploadPath, nombre);
                            file.SaveAs(rutaFisica);

                            db.tbl_FotosReportes.InsertOnSubmit(new tbl_FotosReportes
                            {
                                fore_IdReporte   = reporte.rep_IdReporte,
                                fore_Url         = "~/Uploads/Reportes/" + nombre,
                                fore_Orden       = orden++,
                                fore_FechaSubida = DateTime.Now
                            });
                        }
                        db.SubmitChanges();
                    }
                    // ─────────────────────────────────────────────────────────────
                }

                // SweetAlert de éxito
                ClientScript.RegisterStartupScript(GetType(), "alertExito",
                    "Swal.fire({icon:'success',title:'¡Reporte publicado!',html:" +
                    "'<p>Tu reporte fue publicado. La comunidad puede ayudarte a encontrarla.</p>'," +
                    "confirmButtonText:'Ver el mapa',confirmButtonColor:'#27ae60'" +
                    "}).then(function(r){if(r.isConfirmed)window.location.href='MapaExtravios.aspx';});",
                    true);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al publicar reporte: " + ex.Message);
                ClientScript.RegisterStartupScript(GetType(), "alertError",
                    "Swal.fire({icon:'error',title:'Error',text:'No se pudo publicar el reporte. Inténtalo de nuevo.'});",
                    true);
            }
        }

        // ── Helpers ────────────────────────────────────────────────────────────
        private int? ObtenerIdEspecie(DataClasses1DataContext db, string tipoAnimal)
        {
            if (string.IsNullOrEmpty(tipoAnimal)) return null;
            // Mapeo simple: perro→Perro, gato→Gato, otro→Otro
            string nombreBuscar = tipoAnimal == "perro" ? "Perro" :
                                  tipoAnimal == "gato"  ? "Gato"  : null;
            if (nombreBuscar == null) return null;
            var especie = db.tbl_Especies.FirstOrDefault(
                e => e.esp_Nombre.Contains(nombreBuscar));
            return especie?.esp_IdEspecie;
        }
    }
}