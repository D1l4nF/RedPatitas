using System;
using System.IO;
using System.Web;
using System.Web.UI;
using CapaNegocios;

namespace RedPatitas.Adoptante
{
    public partial class CompletarSeguimiento : System.Web.UI.Page
    {
        private CN_SeguimientoService seguimientoService = new CN_SeguimientoService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Validación de sesión básica
                if (Session["UsuarioId"] == null || Session["RolId"]?.ToString() != "4")
                {
                    Response.Redirect("../Login/Login.aspx");
                    return;
                }

                // Cargar el ID del Seguimiento de la URL (?id=1)
                if (Request.QueryString["id"] != null)
                {
                    int idSeg = Convert.ToInt32(Request.QueryString["id"]);
                    CargarDatosDelFormularioSegunEtapa(idSeg);
                }
                else
                {
                    Response.Redirect("Mascotas.aspx");
                }
            }
        }

        // ==========================================================
        // CONFIGURAR LAS PREGUNTAS VISIBLES SEGÚN LA ETAPA (1, 2, 3 o 4)
        // ==========================================================
        private void CargarDatosDelFormularioSegunEtapa(int idSeguimiento)
        {
            try
            {
                // Obtener detalle de la Capa Negocios (DB)
                var segActual = seguimientoService.ObtenerDetalleSeguimiento(idSeguimiento);

                if (segActual != null)
                {
                    // 1. Mostrar título dinámico (Ej: "Etapa 1: Adaptación")
                    lblTituloEtapa.InnerText = segActual.seg_TituloEtapa;

                    // 2. Mostrar cuestionarios según el número
                    if (segActual.seg_NumeroEtapa == 1 || segActual.seg_NumeroEtapa == 2)
                    {
                        pnlEtapaTemprana.Visible = true;
                    }
                    else if (segActual.seg_NumeroEtapa == 3)
                    {
                        pnlEtapaMedia.Visible = true;
                    }
                    // Etapa 4 es solo Foto en Vivo + GPS. No cargamos panel extra explícitamente en el HTML.
                }
            }
            catch (Exception ex)
            {
                MostrarAlerta("Error al cargar la etapa", ex.Message, "error");
            }
        }

        // ==========================================================
        // PROCESAR Y ENVIAR EL REPORTE AL REFUGIO (CLICK)
        // ==========================================================
        protected void btnEnviarEvaluacion_Click(object sender, EventArgs e)
        {
            try
            {
                int idSeg = Convert.ToInt32(Request.QueryString["id"]);
                var currentStatus = seguimientoService.ObtenerDetalleSeguimiento(idSeg);

                // 1. OBTENER GEOLOCALIZACIÓN DEL JAVASCRIPT
                if (string.IsNullOrEmpty(hfLatitud.Value) || string.IsNullOrEmpty(hfLongitud.Value))
                {
                    MostrarAlerta("Error Médico", "No se detectó su ubicación GPS nativa. Encienda la geolocalización.", "warning");
                    return;
                }

                // Parseo universal de coordenadas independiente del idioma de Windows
                decimal decimalLat = decimal.Parse(hfLatitud.Value.Replace(",", "."), System.Globalization.CultureInfo.InvariantCulture);
                decimal decimalLong = decimal.Parse(hfLongitud.Value.Replace(",", "."), System.Globalization.CultureInfo.InvariantCulture);


                // 2. CREAR CARPETA SI NO EXISTE Y SUBIR LA FOTO EN VIVO FORZOSA
                string folderPath = Server.MapPath("~/Uploads/Seguimientos/");
                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                string rutaFotoEnVivo = "";
                if (fuFotoVivo.HasFile)
                {
                    string extension = Path.GetExtension(fuFotoVivo.FileName).ToLower();
                    // Chequeo de seguridad de imagen
                    if (extension != ".jpg" && extension != ".jpeg" && extension != ".png")
                    {
                        MostrarAlerta("Error de Archivo", "Solo se permiten fotos (JPG, PNG)", "error");
                        return;
                    }

                    // Crear nombre único (Ej: SEG_Etapa1_Adoptante24_Timestamp.jpeg)
                    string guidName = "SEG_E" + currentStatus.seg_NumeroEtapa + "_ADPT" + Session["UsuarioId"].ToString() + "_" + DateTime.Now.Ticks + extension;
                    string filePathDirecto = Server.MapPath("~/Uploads/Seguimientos/") + guidName;

                    // Guardar físico
                    fuFotoVivo.SaveAs(filePathDirecto);
                    rutaFotoEnVivo = "~/Uploads/Seguimientos/" + guidName;
                }


                // 3. SUBIR ARCHIVO OPCIONAL / CARTILLA VACUNAS
                string rutaCartillaDocs = "";
                if (pnlEtapaMedia.Visible && fuCartilla.HasFile)
                {
                    string ext = Path.GetExtension(fuCartilla.FileName).ToLower();
                    string docName = "CARTILLA_SEG" + idSeg + "_" + DateTime.Now.Ticks + ext;
                    fuCartilla.SaveAs(Server.MapPath("~/Uploads/Seguimientos/") + docName);
                    rutaCartillaDocs = "~/Uploads/Seguimientos/" + docName;
                }
                else if (pnlEtapaMedia.Visible && !fuCartilla.HasFile)
                {
                    MostrarAlerta("Documento Obligatorio", "Para la Etapa 3 (3 meses) es obligatoria la foto o el PDF de la cartilla firmada por el Veterinario.", "warning");
                    return;
                }

                // 4. ARMAR EL JSON CON LAS RESPUESTAS DINÁMICAS
                // Esto es brutal. Dependiendo de qué etapa estemos visualizando, meteremos en el bolsillo "JSON" distintas variables.
                var respuestas = new System.Collections.Generic.Dictionary<string, string>();

                if (pnlEtapaTemprana.Visible)
                {
                    respuestas.Add("Alimentacion", ddlAlimentacion.SelectedValue);
                    respuestas.Add("Agresividad", chkAgresividad.Checked.ToString());
                    respuestas.Add("DestruccionCasa", chkDestruccion.Checked.ToString());
                    respuestas.Add("LlantosDeNoche", chkLlantos.Checked.ToString());
                    respuestas.Add("Incidencias", txtIncidencias.Text);
                }
                else if (pnlEtapaMedia.Visible)
                {
                    respuestas.Add("FechaDesparasito", txtFechaDespara.Text);
                    respuestas.Add("ClinicaFrecuente", txtClinica.Text);
                }

                // Generar el String JSON final usando el serializador nativo de .NET
                var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                string respuestasJsonGuardadas = serializer.Serialize(respuestas);

                // 5. ENVIAR TODO AL SERVICIO
                bool exito = seguimientoService.EnviarFormularioSeguimiento(idSeg, decimalLat, decimalLong, rutaFotoEnVivo, rutaCartillaDocs, respuestasJsonGuardadas);

                if (exito)
                {
                    // Redirigir al inicio o mostrar SweetAlert2 y lueeeego redirigir
                    ScriptManager.RegisterStartupScript(this, GetType(), "EnviadoExito", "Swal.fire('¡Evidencia Enviada!', 'El refugio ha recibido tu actualización satelital con éxito. Ellos la revisarán pronto.', 'success').then((result) => { window.location.href = 'Mascotas.aspx'; });", true);
                }

            }
            catch (Exception ex)
            {
                MostrarAlerta("Error Grave", ex.Message, "error");
            }
        }

        // Utilidad rápida para SweetAlert
        private void MostrarAlerta(string titulo, string mensaje, string icono)
        {
            string msjLimpio = mensaje.Replace("\\", "\\\\").Replace("'", "\\'").Replace("\n", "\\n").Replace("\r", "");
            ScriptManager.RegisterStartupScript(this, GetType(), "alerta", $"Swal.fire('{titulo}', '{msjLimpio}', '{icono}');", true);
        }

    }
}
