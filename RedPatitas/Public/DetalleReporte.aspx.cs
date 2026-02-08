using System;
using System.IO;
using System.Web.Script.Serialization;
using System.Web.UI;
using CapaDatos;
using CapaNegocios;

namespace RedPatitas.Public
{
    public partial class DetalleReporte : System.Web.UI.Page
    {
        private int IdReporte => Request.QueryString["id"] != null ? Convert.ToInt32(Request.QueryString["id"]) : 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarReporte();
            }
        }

        private int? ObtenerIdUsuario()
        {
            return Session["UsuarioId"] != null ? (int?)Convert.ToInt32(Session["UsuarioId"]) : null;
        }

        private void CargarReporte()
        {
            try
            {
                var detalle = CN_ReporteService.ObtenerHistorialReporte(IdReporte, ObtenerIdUsuario());
                
                if (detalle == null)
                {
                    pnlReporte.Visible = false;
                    pnlNoEncontrado.Visible = true;
                    return;
                }

                // Información básica
                litTitulo.Text = detalle.NombreMascota;
                litNombre.Text = detalle.NombreMascota;
                litTipoReporte.Text = detalle.TipoReporte;
                litEspecie.Text = detalle.Especie;
                litRaza.Text = detalle.Raza ?? "Desconocida";
                litColor.Text = detalle.Color ?? "-";
                litTamano.Text = detalle.Tamano ?? "-";
                litSexo.Text = ObtenerSexoTexto(detalle.Sexo);
                litDescripcion.Text = detalle.Descripcion ?? "Sin descripción";
                
                if (!string.IsNullOrEmpty(detalle.CaracteristicasDistintivas))
                {
                    litCaracteristicas.Text = detalle.CaracteristicasDistintivas;
                    pnlCaracteristicas.Visible = true;
                }

                // Contacto
                litTelefono.Text = detalle.TelefonoContacto ?? "-";
                litEmail.Text = detalle.EmailContacto ?? "-";
                litUbicacion.Text = detalle.UbicacionUltima ?? detalle.Ciudad ?? "-";

                // Fechas
                litFechaReporte.Text = detalle.FechaReporte?.ToString("dd/MM/yyyy HH:mm") ?? "Fecha no disponible";
                litUbicacionReporte.Text = detalle.UbicacionUltima ?? detalle.Ciudad ?? "Ubicación no especificada";

                // Estado
                litEstado.Text = detalle.Estado;
                pnlEstadoBadge.CssClass = "estado-badge " + ObtenerClaseEstado(detalle.Estado);

                // Foto
                if (detalle.Fotos != null && detalle.Fotos.Count > 0)
                {
                    imgMascota.ImageUrl = detalle.Fotos[0];
                }
                else
                {
                    imgMascota.ImageUrl = "~/Content/img/no-pet-photo.png";
                }

                // Avistamientos
                if (detalle.Avistamientos != null && detalle.Avistamientos.Count > 0)
                {
                    rptAvistamientos.DataSource = detalle.Avistamientos;
                    rptAvistamientos.DataBind();
                    pnlSinAvistamientos.Visible = false;
                }
                else
                {
                    pnlSinAvistamientos.Visible = true;
                }

                // Acciones del dueño
                if (detalle.EsDueno && detalle.Estado != "Reunido" && detalle.Estado != "SinResolver")
                {
                    pnlAccionesDueno.Visible = true;
                }

                // Datos para el mapa (JSON)
                var mapData = new
                {
                    IdReporte = detalle.IdReporte,
                    Nombre = detalle.NombreMascota,
                    Tipo = detalle.TipoReporte,
                    Latitud = detalle.Latitud,
                    Longitud = detalle.Longitud,
                    Avistamientos = detalle.Avistamientos
                };
                var serializer = new JavaScriptSerializer();
                hfReporteData.Value = serializer.Serialize(mapData);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cargando reporte: " + ex.Message);
                pnlReporte.Visible = false;
                pnlNoEncontrado.Visible = true;
            }
        }

        protected void btnMarcarReunido_Click(object sender, EventArgs e)
        {
            var idUsuario = ObtenerIdUsuario();
            if (!idUsuario.HasValue) return;

            var resultado = CN_ReporteService.CambiarEstadoReporte(IdReporte, idUsuario.Value, "Reunido");
            if (resultado.Exito)
            {
                MostrarMensaje("¡Felicidades! 🎉 Tu mascota ha sido marcada como reunida.", "success");
                CargarReporte();
            }
            else
            {
                MostrarMensaje(resultado.Mensaje, "error");
            }
        }

        protected void btnRegistrarAvistamiento_Click(object sender, EventArgs e)
        {
            try
            {
                string descripcion = txtDescripcionAvi.Text.Trim();
                string ubicacion = txtUbicacionAvi.Text.Trim();
                
                decimal? latitud = null;
                decimal? longitud = null;
                
                if (!string.IsNullOrEmpty(hfLatitud.Value))
                {
                    latitud = decimal.Parse(hfLatitud.Value, System.Globalization.CultureInfo.InvariantCulture);
                }
                if (!string.IsNullOrEmpty(hfLongitud.Value))
                {
                    longitud = decimal.Parse(hfLongitud.Value, System.Globalization.CultureInfo.InvariantCulture);
                }

                string fotoUrl = null;

                // Procesar foto si se subió
                if (fuFotoAvi.HasFile)
                {
                    var validacion = CN_ReporteService.ValidarImagen(fuFotoAvi.FileName, fuFotoAvi.PostedFile.ContentLength);
                    if (!validacion.Exito)
                    {
                        MostrarMensaje(validacion.Mensaje, "error");
                        return;
                    }

                    // Guardar archivo
                    string nombreArchivo = $"avistamiento_{IdReporte}_{DateTime.Now:yyyyMMddHHmmss}{Path.GetExtension(fuFotoAvi.FileName)}";
                    string carpeta = Server.MapPath("~/Uploads/Avistamientos/");
                    
                    if (!Directory.Exists(carpeta))
                    {
                        Directory.CreateDirectory(carpeta);
                    }
                    
                    string rutaCompleta = Path.Combine(carpeta, nombreArchivo);
                    fuFotoAvi.SaveAs(rutaCompleta);
                    fotoUrl = $"~/Uploads/Avistamientos/{nombreArchivo}";
                }

                var resultado = CN_ReporteService.RegistrarAvistamiento(
                    IdReporte, 
                    ObtenerIdUsuario(), 
                    descripcion, 
                    ubicacion, 
                    latitud, 
                    longitud, 
                    fotoUrl
                );

                if (resultado.Exito)
                {
                    MostrarMensaje("¡Gracias! Tu avistamiento ha sido registrado.", "success");
                    // Limpiar formulario
                    txtDescripcionAvi.Text = "";
                    txtUbicacionAvi.Text = "";
                    hfLatitud.Value = "";
                    hfLongitud.Value = "";
                    // Recargar
                    CargarReporte();
                }
                else
                {
                    MostrarMensaje(resultado.Mensaje, "error");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error registrando avistamiento: " + ex.Message);
                MostrarMensaje("Error al registrar el avistamiento", "error");
            }
        }

        private string ObtenerSexoTexto(string sexo)
        {
            if (string.IsNullOrEmpty(sexo)) return "No especificado";
            return sexo.ToUpper() == "M" ? "Macho" : "Hembra";
        }

        private string ObtenerClaseEstado(string estado)
        {
            switch (estado)
            {
                case "Reunido": return "reunido";
                case "SinResolver": return "cerrado";
                default: return "activo";
            }
        }

        private void MostrarMensaje(string mensaje, string tipo)
        {
            string icon = tipo == "success" ? "success" : tipo == "error" ? "error" : "info";
            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                $"Swal.fire({{ icon: '{icon}', text: '{mensaje}', timer: 3000 }});", true);
        }
    }
}
