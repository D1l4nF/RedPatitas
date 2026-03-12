using System;
using System.Web.UI;
using CapaDatos;
using System.Linq;

namespace RedPatitas.Adoptante
{
    public partial class ReportarMascota : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificar sesión
            if (Session["UsuarioId"] == null)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Precargar email del usuario si está disponible
                try
                {
                    int idUsuario = Convert.ToInt32(Session["UsuarioId"]);
                    using (var db = new DataClasses1DataContext())
                    {
                        var usuario = db.tbl_Usuarios.FirstOrDefault(u => u.usu_IdUsuario == idUsuario);
                        if (usuario != null)
                        {
                            txtEmail.Text    = usuario.usu_Email;
                            txtTelefono.Text = usuario.usu_Telefono;
                        }
                    }
                }
                catch { }
            }
        }

        /// <summary>
        /// Envía el reporte de mascota con fotos
        /// </summary>
        protected void btnEnviar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                int idUsuario   = Convert.ToInt32(Session["UsuarioId"]);
                string tipoReporte = rbPerdida.Checked ? "Perdida" : "Encontrada";

                using (var db = new DataClasses1DataContext())
                {
                    var reporte = new tbl_ReportesMascotas
                    {
                        rep_IdUsuario       = idUsuario,
                        rep_TipoReporte     = tipoReporte,
                        rep_NombreMascota   = txtNombre.Text.Trim(),
                        rep_IdEspecie       = !string.IsNullOrEmpty(ddlEspecie.SelectedValue)
                                                ? int.Parse(ddlEspecie.SelectedValue)
                                                : (int?)null,
                        rep_Raza            = txtRaza.Text.Trim(),
                        rep_Color           = txtColor.Text.Trim(),
                        rep_Tamano          = ddlTamano.SelectedValue,
                        rep_Sexo            = !string.IsNullOrEmpty(ddlSexo.SelectedValue)
                                                ? ddlSexo.SelectedValue[0]
                                                : (char?)null,
                        rep_EdadAproximada  = ddlEdad.SelectedValue,
                        rep_Descripcion     = txtDescripcion.Text.Trim(),
                        rep_UbicacionUltima = txtUbicacion.Text.Trim(),
                        rep_Ciudad          = txtCiudad.Text.Trim(),
                        rep_TelefonoContacto = txtTelefono.Text.Trim(),
                        rep_EmailContacto   = txtEmail.Text.Trim(),
                        rep_Estado          = "Reportado",
                        rep_FechaReporte    = DateTime.Now
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

                    db.tbl_ReportesMascotas.InsertOnSubmit(reporte);
                    db.SubmitChanges();  // Primer SubmitChanges → genera rep_IdReporte

                    // ── Guardar fotos ─────────────────────────────────────────────
                    if (fuFotos.HasFiles)
                    {
                        string uploadPath = Server.MapPath("~/Uploads/Reportes/");
                        if (!System.IO.Directory.Exists(uploadPath))
                            System.IO.Directory.CreateDirectory(uploadPath);

                        int orden = 0;
                        foreach (var file in fuFotos.PostedFiles)
                        {
                            if (file.ContentLength == 0 || orden >= 5) continue;

                            string ext = System.IO.Path.GetExtension(file.FileName).ToLower();
                            if (ext != ".jpg" && ext != ".jpeg" && ext != ".png") continue;
                            if (file.ContentLength > 5 * 1024 * 1024) continue;  // max 5 MB

                            string nombreArchivo = Guid.NewGuid().ToString() + ext;
                            string rutaFisica    = System.IO.Path.Combine(uploadPath, nombreArchivo);
                            file.SaveAs(rutaFisica);

                            var foto = new tbl_FotosReportes
                            {
                                fore_IdReporte   = reporte.rep_IdReporte,
                                fore_Url         = "~/Uploads/Reportes/" + nombreArchivo,
                                fore_Orden       = orden++,
                                fore_FechaSubida = DateTime.Now
                            };
                            db.tbl_FotosReportes.InsertOnSubmit(foto);
                        }
                        db.SubmitChanges();  // Segundo SubmitChanges → guarda fotos
                    }
                    // ─────────────────────────────────────────────────────────────

                    // SweetAlert con redirección a MisReportes
                    ClientScript.RegisterStartupScript(GetType(), "alertExito",
                        "Swal.fire({icon:'success',title:'¡Reporte enviado!'," +
                        "text:'Gracias por ayudar a reunir mascotas con sus familias.'," +
                        "confirmButtonText:'Ver mis reportes'})" +
                        ".then(function(r){if(r.isConfirmed)window.location.href='MisReportes.aspx';});",
                        true);

                    LimpiarFormulario();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al enviar reporte: " + ex.Message);
                ClientScript.RegisterStartupScript(GetType(), "alertError",
                    "Swal.fire({icon:'error',title:'Error'," +
                    "text:'No se pudo enviar el reporte. Inténtalo de nuevo.'});",
                    true);
            }
        }

        /// <summary>
        /// Limpia el formulario después de enviar
        /// </summary>
        private void LimpiarFormulario()
        {
            txtNombre.Text       = "";
            ddlEspecie.SelectedIndex = 0;
            txtRaza.Text         = "";
            txtColor.Text        = "";
            ddlTamano.SelectedIndex  = 0;
            ddlSexo.SelectedIndex    = 0;
            ddlEdad.SelectedIndex    = 0;
            txtDescripcion.Text  = "";
            txtUbicacion.Text    = "";
            txtCiudad.Text       = "";
            txtFecha.Text        = "";
            hfLatitud.Value      = "";
            hfLongitud.Value     = "";
            rbPerdida.Checked    = true;
            rbEncontrada.Checked = false;
        }
    }
}
