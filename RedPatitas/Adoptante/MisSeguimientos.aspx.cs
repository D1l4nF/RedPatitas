using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.Adoptante
{
    public partial class MisSeguimientos : System.Web.UI.Page
    {
        private CN_SeguimientoService seguimientoService = new CN_SeguimientoService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UsuarioId"] == null || Session["RolId"]?.ToString() != "4")
                {
                    Response.Redirect("../Login/Login.aspx");
                    return;
                }

                int idAdoptante = Convert.ToInt32(Session["UsuarioId"]);
                int idPerro = 0;

                if (Request.QueryString["idMascota"] != null)
                {
                    int.TryParse(Request.QueryString["idMascota"], out idPerro);
                }

                CargarCronograma(idPerro, idAdoptante);
            }
        }

        private void CargarCronograma(int idMascota, int idAdoptante)
        {
            try
            {
                // Obtenemos los 4 hitos anónimos de LINQ
                dynamic seguimientos = seguimientoService.ObtenerSeguimientosPorAdoptante(idMascota, idAdoptante);

                var listaFormateada = new List<object>();
                bool tieneRegistros = false;

                foreach (var seg in seguimientos)
                {
                    tieneRegistros = true;
                    DateTime fProg = seg.FechaProgramada;
                    string estadoBase = seg.Estado;
                    int difDias = seg.DiferenciaDias; // Días que faltan para que sea disponible

                    // Variables para controlar Aspecto
                    string claseContainer = "item-pendiente";
                    string claseBadge = "badge-pendiente";

                    int etapaNum = seg.Etapa;
                    string nombreAnimal = seg.NombreMascota;

                    string msjExplicativo = "¡Enhorabuena por adoptar a " + nombreAnimal + "! Nos encantaría saber si se está adaptando bien a su nuevo hogar. Faltan " + difDias + " días para que puedas habilitar el formulario y enviarnos novedades y fotos mágicas.";

                    if (etapaNum == 3 || etapaNum == 4)
                    {
                        msjExplicativo = "Las vacunas y el seguimiento médico son fundamentales. Este reporte para " + nombreAnimal + " abrirá en " + difDias + " días para asegurar su constante bienestar.";
                    }

                    bool mostrarBoton = false;

                    // == LÓGICA DE ESTADOS DEL TIMELINE ==
                    if (estadoBase == "Aprobado")
                    {
                        claseContainer = "item-aprobado";
                        claseBadge = "badge-aprobado";
                        msjExplicativo = "✅ El administrador de la fundación revisó y aprobó este reporte de seguimiento.";
                        mostrarBoton = false;
                    }
                    else if (estadoBase == "Enviado")
                    {
                        claseContainer = "item-enviado";
                        claseBadge = "badge-enviado";
                        msjExplicativo = "📬 Evaluando... Has enviado el formulario satelital. Esperando repuesta del refugio.";
                        mostrarBoton = false;
                    }
                    else if (estadoBase == "Rechazado")
                    {
                        claseContainer = "item-rechazado";
                        claseBadge = "badge-rechazado";
                        msjExplicativo = "⚠️ EL REFUGIO HA SOLICITADO QUE CORRIJAS O VUELVAS A ENVIAR ESTE REPORTE CON FOTOS NUEVAS.";
                        mostrarBoton = true;
                        estadoBase = "Requiere Atención Urgente";
                    }
                    else // 'Pendiente' originalmente
                    {
                        // Si ya pasó la fecha o es el mismo día, cambia a 'Disponible' visualmente
                        if (DateTime.Now.Date >= fProg.Date)
                        {
                            claseContainer = "item-disponible";
                            claseBadge = "badge-disponible";
                            estadoBase = "Habilitado 🚨";
                            msjExplicativo = "¿Está todo bien con " + nombreAnimal + "? Ha llegado el momento de documentar esta etapa. Haz clic abajo para enviarnos una foto satelital para saber que todo está en orden.";
                            mostrarBoton = true;
                        }
                    }

                    // Meter los cálculos finales a la lista
                    listaFormateada.Add(new
                    {
                        IdSeguimiento = seg.IdSeguimiento,
                        Titulo = seg.Titulo,
                        NombreMascota = seg.NombreMascota,
                        FechaProgramada = fProg,
                        Estado = estadoBase,
                        CssClassContainer = claseContainer,
                        CssClassBadge = claseBadge,
                        MensajeExplicativo = msjExplicativo,
                        MostrarBoton = mostrarBoton
                    });
                }

                if (idMascota == 0)
                {
                    lblNombreMascota.InnerText = "Mis Mascotas Adoptadas";
                }

                if (tieneRegistros)
                {
                    var listaSeguimientosTipada = seguimientos as List<SeguimientoDTO>;
                    if (listaSeguimientosTipada != null && listaSeguimientosTipada.Count > 0)
                    {
                        imgMascota.ImageUrl = listaSeguimientosTipada[0].FotoMascota;
                    }

                    rpSeguimientos.DataSource = listaFormateada;
                    rpSeguimientos.DataBind();
                }
                else
                {
                    rpSeguimientos.Visible = false;
                    divVacio.Visible = true;
                }
            }
            catch (Exception ex)
            {
                // Error manejado localmente y mostrado en pantalla para diagnóstico rápido
                lblNombreMascota.InnerText = "Error del Sistema";
                rpSeguimientos.Visible = false;
                divVacio.InnerHtml = "<div style='color:red; padding: 20px;'><h3>Error crítico:</h3><br/>" + ex.Message + "<br/>" + ex.StackTrace + "</div>";
                divVacio.Visible = true;
            }
        }

        // El OnItemDataBound nos sirve para cosas adicionales de interfaz si queremos, 
        // pero la mayor parte la hicimos en CargarCronograma para mantener el HTML limpio.
        protected void rpSeguimientos_ItemDataBound(object sender, RepeaterItemEventArgs e) { }
    }
}
