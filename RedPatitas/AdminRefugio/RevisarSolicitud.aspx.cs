using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using CapaDatos;
using System.Web.Script.Serialization;

namespace RedPatitas.AdminRefugio
{
    public partial class RevisarSolicitud : System.Web.UI.Page
    {
        private int IdSolicitud;
        private int IdRefugio;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["RefugioId"] == null)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }

            IdRefugio = Convert.ToInt32(Session["RefugioId"]);

            if (!int.TryParse(Request.QueryString["id"], out IdSolicitud))
            {
                Response.Redirect("Solicitudes.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CargarSolicitud();
            }
        }

        private void CargarSolicitud()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var solicitud = (from s in db.tbl_SolicitudesAdopcion
                                     join m in db.tbl_Mascotas on s.sol_IdMascota equals m.mas_IdMascota
                                     join u in db.tbl_Usuarios on s.sol_IdUsuario equals u.usu_IdUsuario
                                     where s.sol_IdSolicitud == IdSolicitud && m.mas_IdRefugio == IdRefugio
                                     select new
                                     {
                                         Solicitud = s,
                                         Mascota = m,
                                         Adoptante = u,
                                         Especie = m.tbl_Razas != null && m.tbl_Razas.tbl_Especies != null
                                                   ? m.tbl_Razas.tbl_Especies.esp_Nombre : "Mascota",
                                         FotoMascota = m.tbl_FotosMascotas
                                             .Where(f => f.fot_EsPrincipal == true)
                                             .Select(f => f.fot_Url)
                                             .FirstOrDefault()
                                     }).FirstOrDefault();

                    if (solicitud == null)
                    {
                        MostrarError("Solicitud no encontrada o no pertenece a tu refugio.");
                        pnlContenido.Visible = false;
                        return;
                    }

                    hfIdSolicitud.Value = IdSolicitud.ToString();

                    // Header
                    litNombreMascota.Text = solicitud.Mascota.mas_Nombre;
                    litNombreAdoptante.Text = solicitud.Adoptante.usu_Nombre + " " + solicitud.Adoptante.usu_Apellido;
                    litFechaSolicitud.Text = solicitud.Solicitud.sol_FechaSolicitud?.ToString("dd/MM/yyyy") ?? "N/A";
                    litEstado.Text = solicitud.Solicitud.sol_Estado;

                    // Foto mascota
                    if (!string.IsNullOrEmpty(solicitud.FotoMascota))
                    {
                        imgMascota.ImageUrl = solicitud.FotoMascota;
                        imgMascota.Visible = true;
                        pnlEmoji.Visible = false;
                    }
                    else
                    {
                        imgMascota.Visible = false;
                        pnlEmoji.Visible = true;
                        litEmoji.Text = ObtenerEmoji(solicitud.Especie);
                    }

                    // Datos del adoptante
                    litAdoptanteNombre.Text = solicitud.Adoptante.usu_Nombre + " " + solicitud.Adoptante.usu_Apellido;
                    litAdoptanteCedula.Text = solicitud.Adoptante.usu_Cedula ?? "No registrada";
                    litAdoptanteTelefono.Text = solicitud.Adoptante.usu_Telefono ?? "No registrado";
                    litAdoptanteEmail.Text = solicitud.Adoptante.usu_Email;
                    litAdoptanteCiudad.Text = solicitud.Adoptante.usu_Ciudad ?? "No especificada";

                    // Motivación
                    string motivacion = !string.IsNullOrEmpty(solicitud.Solicitud.sol_MotivoAdopcion)
                        ? solicitud.Solicitud.sol_MotivoAdopcion : "No especificada";
                    litMotivacion.Text = motivacion;
                    hfTextoMotivacion.Value = motivacion;

                    // Experiencia
                    string experiencia = !string.IsNullOrEmpty(solicitud.Solicitud.sol_ExperienciaMascotas)
                        ? solicitud.Solicitud.sol_ExperienciaMascotas : "No especificada";
                    litExperiencia.Text = experiencia;
                    hfTextoExperiencia.Value = experiencia;

                    // Vivienda
                    string tipoVivienda = solicitud.Solicitud.sol_TipoVivienda ?? "No especificado";
                    litTipoVivienda.Text = tipoVivienda;
                    hfTipoVivienda.Value = tipoVivienda;

                    bool tienePatio = solicitud.Solicitud.sol_TienePatioJardin == true;
                    litPatioJardin.Text = tienePatio
                        ? "<span class='good'>✅ Sí tiene</span>"
                        : "<span class='bad'>❌ No tiene</span>";
                    hfTienePatio.Value = tienePatio.ToString().ToLower();

                    int horasEnCasa = solicitud.Solicitud.sol_HorasEnCasa ?? 0;
                    litHorasEnCasa.Text = FormatearHoras(horasEnCasa);
                    hfHorasEnCasa.Value = horasEnCasa.ToString();

                    // Ingresos
                    string ingresos = solicitud.Solicitud.sol_IngresosMensuales ?? "No especificado";
                    litIngresos.Text = ingresos;
                    hfIngresos.Value = ingresos;

                    // Otras mascotas
                    bool otrasMascotas = solicitud.Solicitud.sol_OtrasMascotas == true;
                    hfOtrasMascotas.Value = otrasMascotas.ToString().ToLower();
                    if (otrasMascotas)
                    {
                        litOtrasMascotas.Text = "<span class='warning'>⚠️ Sí tiene otras mascotas</span>";
                        if (!string.IsNullOrEmpty(solicitud.Solicitud.sol_DetalleOtrasMascotas))
                        {
                            pnlDetallesOtrasMascotas.Visible = true;
                            litDetalleOtrasMascotas.Text = solicitud.Solicitud.sol_DetalleOtrasMascotas;
                        }
                    }
                    else
                    {
                        litOtrasMascotas.Text = "<span class='good'>No tiene otras mascotas</span>";
                    }

                    // Niños
                    bool tieneNinos = solicitud.Solicitud.sol_TieneNinos == true;
                    hfTieneNinos.Value = tieneNinos.ToString().ToLower();
                    if (tieneNinos)
                    {
                        litNinos.Text = "<span class='warning'>⚠️ Sí hay niños en casa</span>";
                        if (!string.IsNullOrEmpty(solicitud.Solicitud.sol_EdadesNinos))
                        {
                            pnlEdadesNinos.Visible = true;
                            litEdadesNinos.Text = solicitud.Solicitud.sol_EdadesNinos;
                        }
                    }
                    else
                    {
                        litNinos.Text = "<span class='good'>No hay niños</span>";
                    }

                    // Acepta visita
                    litAceptaVisita.Text = solicitud.Solicitud.sol_AceptaVisita == true
                        ? "<span class='good'>✅ Sí acepta</span>"
                        : "<span class='bad'>❌ No acepta</span>";

                    // Comentarios
                    if (!string.IsNullOrEmpty(solicitud.Solicitud.sol_Comentarios))
                    {
                        pnlComentarios.Visible = true;
                        litComentarios.Text = solicitud.Solicitud.sol_Comentarios;
                    }

                    // Fotos de vivienda
                    CargarFotosVivienda();
                }
            }
            catch (Exception ex)
            {
                MostrarError("Error al cargar la solicitud: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Error CargarSolicitud: " + ex.ToString());
            }
        }

        private void CargarFotosVivienda()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    try
                    {
                        var fotos = db.ExecuteQuery<FotoSolicitudDTO>(
                            @"SELECT fos_IdFoto, fos_Url, fos_TipoFoto, fos_Descripcion 
                              FROM tbl_FotosSolicitud 
                              WHERE fos_IdSolicitud = {0}", IdSolicitud).ToList();

                        if (fotos.Count > 0)
                        {
                            rptFotos.DataSource = fotos;
                            rptFotos.DataBind();
                            pnlFotos.Visible = true;
                            pnlSinFotos.Visible = false;
                        }
                        else
                        {
                            pnlFotos.Visible = false;
                            pnlSinFotos.Visible = true;
                        }
                    }
                    catch
                    {
                        pnlFotos.Visible = false;
                        pnlSinFotos.Visible = true;
                    }
                }
            }
            catch
            {
                pnlFotos.Visible = false;
                pnlSinFotos.Visible = true;
            }
        }

        protected void btnAprobar_Click(object sender, EventArgs e)
        {
            try
            {
                int idSolicitud = Convert.ToInt32(hfIdSolicitud.Value);
                decimal puntajeTotal = 0;
                decimal.TryParse(hfPuntajeTotal.Value, System.Globalization.NumberStyles.Any,
                                 System.Globalization.CultureInfo.InvariantCulture, out puntajeTotal);

                using (var db = new DataClasses1DataContext())
                {
                    var solicitud = db.tbl_SolicitudesAdopcion
                        .FirstOrDefault(s => s.sol_IdSolicitud == idSolicitud);

                    if (solicitud == null)
                    {
                        MostrarError("Solicitud no encontrada.");
                        return;
                    }

                    solicitud.sol_Estado = "Aprobada";
                    solicitud.sol_PuntajeTotal = puntajeTotal;
                    solicitud.sol_IdUsuarioRevision = Convert.ToInt32(Session["UsuarioId"]);
                    solicitud.sol_FechaRevision = DateTime.Now;

                    var mascota = db.tbl_Mascotas
                        .FirstOrDefault(m => m.mas_IdMascota == solicitud.sol_IdMascota);

                    if (mascota != null)
                    {
                        mascota.mas_EstadoAdopcion = "Adoptado";
                        mascota.mas_FechaAdopcion = DateTime.Now;
                    }

                    db.SubmitChanges();

                    pnlSuccess.Visible = true;
                    litSuccess.Text = "¡Adopción aprobada exitosamente! La mascota ha sido marcada como adoptada.";
                    btnAprobar.Enabled = false;
                    btnRechazar.Enabled = false;
                }
            }
            catch (Exception ex)
            {
                MostrarError("Error al aprobar: " + ex.Message);
            }
        }

        protected void btnRechazar_Click(object sender, EventArgs e)
        {
            pnlModalRechazo.Visible = true;
        }

        protected void btnCancelarRechazo_Click(object sender, EventArgs e)
        {
            pnlModalRechazo.Visible = false;
        }

        protected void btnConfirmarRechazo_Click(object sender, EventArgs e)
        {
            try
            {
                int idSolicitud = Convert.ToInt32(hfIdSolicitud.Value);
                decimal puntajeTotal = 0;
                decimal.TryParse(hfPuntajeTotal.Value, System.Globalization.NumberStyles.Any,
                                 System.Globalization.CultureInfo.InvariantCulture, out puntajeTotal);
                string motivo = txtMotivoRechazo.Text.Trim();

                using (var db = new DataClasses1DataContext())
                {
                    var solicitud = db.tbl_SolicitudesAdopcion
                        .FirstOrDefault(s => s.sol_IdSolicitud == idSolicitud);

                    if (solicitud == null)
                    {
                        MostrarError("Solicitud no encontrada.");
                        return;
                    }

                    solicitud.sol_Estado = "Rechazada";
                    solicitud.sol_PuntajeTotal = puntajeTotal;
                    solicitud.sol_ComentariosRevision = motivo;
                    solicitud.sol_IdUsuarioRevision = Convert.ToInt32(Session["UsuarioId"]);
                    solicitud.sol_FechaRevision = DateTime.Now;

                    var mascota = db.tbl_Mascotas
                        .FirstOrDefault(m => m.mas_IdMascota == solicitud.sol_IdMascota);

                    if (mascota != null)
                    {
                        mascota.mas_EstadoAdopcion = "Disponible";
                    }

                    db.SubmitChanges();

                    pnlModalRechazo.Visible = false;
                    pnlSuccess.Visible = true;
                    litSuccess.Text = "Solicitud rechazada. El adoptante será notificado.";
                    btnAprobar.Enabled = false;
                    btnRechazar.Enabled = false;
                }
            }
            catch (Exception ex)
            {
                MostrarError("Error al rechazar: " + ex.Message);
            }
        }

        private string FormatearHoras(int horas)
        {
            if (horas >= 24) return "<span class='good'>Trabajo desde casa</span>";
            if (horas >= 10) return "<span class='good'>" + horas + "+ horas</span>";
            if (horas >= 6) return "<span class='warning'>" + horas + " horas</span>";
            if (horas > 0) return "<span class='bad'>" + horas + " horas (poco tiempo)</span>";
            return "No especificado";
        }

        private string ObtenerEmoji(string especie)
        {
            if (string.IsNullOrEmpty(especie)) return "🐾";
            especie = especie.ToLower();
            if (especie.Contains("perro")) return "🐕";
            if (especie.Contains("gato")) return "🐱";
            if (especie.Contains("conejo")) return "🐰";
            return "🐾";
        }

        private void MostrarError(string mensaje)
        {
            pnlError.Visible = true;
            litError.Text = mensaje;
        }
    }

    public class FotoSolicitudDTO
    {
        public int fos_IdFoto { get; set; }
        public string fos_Url { get; set; }
        public string fos_TipoFoto { get; set; }
        public string fos_Descripcion { get; set; }
    }
}
