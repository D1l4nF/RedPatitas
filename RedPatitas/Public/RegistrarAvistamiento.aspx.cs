using System;
using System.Linq;
using CapaDatos;

namespace RedPatitas.Public
{
    public partial class RegistrarAvistamiento : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Requiere login
            if (Session["UsuarioId"] == null)
            {
                Response.Redirect("~/Login/Login.aspx?returnUrl=" +
                    Server.UrlEncode(Request.Url.PathAndQuery));
                return;
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

            if (Session["UsuarioId"] == null) return;

            int idReporte = Convert.ToInt32(hfIdReporte.Value);
            int idUsuario = Convert.ToInt32(Session["UsuarioId"]);

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

                    // Actualizar estado del reporte
                    var reporte = db.tbl_ReportesMascotas
                        .FirstOrDefault(r => r.rep_IdReporte == idReporte);

                    if (reporte != null &&
                        (reporte.rep_Estado == "Reportado" || reporte.rep_Estado == "EnBusqueda"))
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

                    string urlDetalle = ResolveUrl(
                        "~/Public/DetalleReporte.aspx?id=" + idReporte);

                    ClientScript.RegisterStartupScript(GetType(), "alertExito",
                        string.Format(
                            "Swal.fire({{icon:'success',title:'¡Avistamiento registrado!'," +
                            "text:'Gracias. El dueño ha sido notificado.'," +
                            "confirmButtonText:'Ver detalle del reporte'}})" +
                            ".then(function(r){{if(r.isConfirmed)window.location.href='{0}';}});",
                            urlDetalle),
                        true);
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
