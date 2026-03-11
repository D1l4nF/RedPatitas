using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using CapaNegocios;

namespace RedPatitas.AdminRefugio
{
    public partial class VerSeguimiento : System.Web.UI.Page
    {
        private CN_SeguimientoService seguimientoService = new CN_SeguimientoService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Seguridad básica de rol
                if (Session["UsuarioId"] == null || Session["RolId"]?.ToString() != "2")
                {
                    Response.Redirect("../Login/Login.aspx");
                    return;
                }

                if (Request.QueryString["id"] != null)
                {
                    int idSeg = Convert.ToInt32(Request.QueryString["id"]);
                    CargarDatosAuditoria(idSeg);
                }
                else
                {
                    Response.Redirect("AuditoriaSeguimientos.aspx");
                }
            }
        }

        private void CargarDatosAuditoria(int idSeg)
        {
            try
            {
                var dictRespuestas = new Dictionary<string, string>();
                var reporte = seguimientoService.ObtenerDetalleSeguimiento(idSeg);

                if (reporte != null)
                {
                    // 1. Mostrar título dinámico (Ej: Etapa 1)
                    lblEtapaTitulo.InnerText = "📋 Cuestionario - " + reporte.seg_TituloEtapa;

                    // 2. Colocar Foto enviada (Ruta generada en el Submit del adoptante)
                    imgEvidenciaEnVivo.ImageUrl = reporte.seg_FotoUrlEnVivo;

                    // 3. Colocar Mapa (Coordenadas en los Hidden Fields para que Leaflet JS las lea)
                    hfLatitudGPS.Value = reporte.seg_Latitud?.ToString() ?? "0";
                    hfLongitudGPS.Value = reporte.seg_Longitud?.ToString() ?? "0";

                    // 4. Activar botón de documento PDF adiconal (Solo si hubo cartilla de vacuna)
                    if (!string.IsNullOrEmpty(reporte.seg_ArchivoAdjuntoUrl))
                    {
                        pnlDescargaObligatoria.Visible = true;
                        lnkDescargarEvidenciaExtra.NavigateUrl = reporte.seg_ArchivoAdjuntoUrl;
                    }

                    // Descodificar JSON de las preguntas
                    // El JSON guarda formato: {"Alimentacion": "Poco Ansioso", "Agresividad": "True"}
                    if (!string.IsNullOrEmpty(reporte.seg_RespuestasJSON))
                    {
                        var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                        dictRespuestas = serializer.Deserialize<Dictionary<string, string>>(reporte.seg_RespuestasJSON);

                        // Parsear true/false a español legible y mapear valores de listas
                        var listaFormateada = new List<KeyValuePair<string, string>>();
                        foreach (var kvp in dictRespuestas)
                        {
                            string valor = kvp.Value;
                            
                            // 1. Mapear booleanos
                            if (valor == "True") valor = "SÍ";
                            else if (valor == "False") valor = "NO";
                            
                            // 2. Mapear valores del DropDown de Alimentación
                            else if (valor == "Normal_100") valor = "Come toda su ración (100% normal)";
                            else if (valor == "Poco_Ansioso") valor = "Come poco (posible ansiedad)";
                            else if (valor == "Casi_Nada") valor = "Casi no prueba la comida";

                            // 3. Fallback vacío
                            valor = string.IsNullOrEmpty(valor) ? "No Registrado" : valor;

                            listaFormateada.Add(new KeyValuePair<string, string>(
                                FormatearNombreLlave(kvp.Key), valor));
                        }

                        // Llenar el Repeater del HTML
                        rpRespuestasDinamicas.DataSource = listaFormateada;
                        rpRespuestasDinamicas.DataBind();
                    }
                }
            }
            catch (Exception)
            {
                MostrarAlerta("Error", "No se pude descargar la información cifrada del servidor.", "error");
            }
        }

        // Método auxiliar para que los nombres de las llaves JSON se vean bonitas (LlantosDeNoche => Llantos De Noche)
        private string FormatearNombreLlave(string llave)
        {
            var text = System.Text.RegularExpressions.Regex.Replace(llave, "([A-Z])", " $1").Trim();
            text = text.Replace("Destruccion Casa", "Destrucción de Enseres");
            text = text.Replace("Fecha Desparasito", "Comprobante Desparasitación");
            return text;
        }


        // ==========================================================
        // BOTÓN: APROBAR SEGUIMIENTO ✅
        // ==========================================================
        protected void btnAprobar_Click(object sender, EventArgs e)
        {
            try
            {
                int idAdmin = Convert.ToInt32(Session["UsuarioId"]);
                int idSeg = Convert.ToInt32(Request.QueryString["id"]);

                string comentarios = txtComentariosRevisor.Text.Trim();
                if (string.IsNullOrEmpty(comentarios)) comentarios = "Seguimiento validado correctamente sin observaciones.";

                bool ok = seguimientoService.AuditarSeguimiento(idSeg, idAdmin, "Aprobado", comentarios);

                if (ok)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "AprobadoExito", "Swal.fire('¡Superado!', 'La etapa ha sido firmada como completada.', 'success').then((result) => { window.location.href = 'AuditoriaSeguimientos.aspx'; });", true);
                }
            }
            catch (Exception ex)
            {
                MostrarAlerta("Error al Aprobar", ex.Message, "error");
            }
        }

        // ==========================================================
        // BOTÓN: PEDIR QUE LO REPITA (RECHAZAR) ⚠️
        // ==========================================================
        protected void btnRechazar_Click(object sender, EventArgs e)
        {
            try
            {
                int idAdmin = Convert.ToInt32(Session["UsuarioId"]);
                int idSeg = Convert.ToInt32(Request.QueryString["id"]);
                string comentarios = txtComentariosRevisor.Text.Trim();

                if (string.IsNullOrEmpty(comentarios))
                {
                    MostrarAlerta("Advertencia", "Debe justificar por qué rechaza el deporte (Ej: La foto no es de la mascota, el GPS no corresponde).", "warning");
                    return;
                }

                // El estado 'Rechazado' en este contexto significa que la etapa vuelve a activarse para el adoptante pidiéndole correcciones
                bool ok = seguimientoService.AuditarSeguimiento(idSeg, idAdmin, "Rechazado", "MOTIVO CORRECCIÓN: " + comentarios);

                if (ok)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "RechazadoExito", "Swal.fire('Rechazado', 'Se ha notificado al adoptante para que corrija su envío.', 'warning').then((result) => { window.location.href = 'AuditoriaSeguimientos.aspx'; });", true);
                }
            }
            catch (Exception ex)
            {
                MostrarAlerta("Error al Rechazar", ex.Message, "error");
            }
        }

        // ==========================================================
        // BOTÓN DE EMERGENCIA: CANCELAR CONTRATO ADOPCIÓN Y LISTA NEGRA 🚨 
        // ==========================================================
        protected void btnAlertaMaltrato_Click(object sender, EventArgs e)
        {
            try
            {
                int idAdmin = Convert.ToInt32(Session["UsuarioId"]);
                int idSeg = Convert.ToInt32(Request.QueryString["id"]);
                string motivoGrave = txtComentariosRevisor.Text.Trim();

                // 1. Obtener de qué mascota estamos hablando
                var reporte = seguimientoService.ObtenerDetalleSeguimiento(idSeg);

                if (reporte != null && !string.IsNullOrEmpty(motivoGrave))
                {
                    int idSol = reporte.seg_IdSolicitud;

                    // Tenemos que ir a bd para buscar el ID de la mascota con esa solicitud 
                    // (Para este ejemplo usaré LINQ directo para no hacerte redactar otro Stored Procedure solo por un SELECT)
                    using (CapaDatos.DataClasses1DataContext dbLocal = new CapaDatos.DataClasses1DataContext())
                    {
                        var soli = dbLocal.tbl_SolicitudesAdopcion.FirstOrDefault(x => x.sol_IdSolicitud == idSol);
                        if (soli != null)
                        {
                            int idPerroGato = soli.sol_IdMascota;

                            // 2. Ejecutar Protocolo de Maltrato Oficial (EsMaltrato = true)
                            seguimientoService.FinalizarYRevocarAdopcion(idSol, idPerroGato, idAdmin, motivoGrave, true);

                            ScriptManager.RegisterStartupScript(this, GetType(), "MaltratoEjecutado", "Swal.fire('¡Contrato Anulado!', 'La familia ingresó a LA LISTA NEGRA por maltrato animal permanente. El animal ha regresado al catálogo.', 'error').then((result) => { window.location.href = 'Dashboard.aspx'; });", true);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MostrarAlerta("Error Grave", ex.Message, "error");
            }
        }


        private void MostrarAlerta(string titulo, string mensaje, string icono)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alerta", $"Swal.fire('{titulo}', '{mensaje.Replace("'", "\\'")}', '{icono}');", true);
        }

    }
}
