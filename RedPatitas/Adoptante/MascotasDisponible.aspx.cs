using CapaDatos;
using CapaNegocios;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RedPatitas.Adoptante
{
    public partial class MascotasDisponible : System.Web.UI.Page
    {
        private readonly DataClasses1DataContext db = new DataClasses1DataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarFiltros();
                CargarMascotas();
            }
        }

        private void CargarFiltros()
        {
            try
            {
                // Cargar especies
                var especies = CN_AdopcionService.ObtenerEspeciesDisponibles();
                foreach (var especie in especies)
                {
                    ddlEspecie.Items.Add(new ListItem(especie, especie));
                }

                // Cargar ubicaciones
                var ubicaciones = CN_AdopcionService.ObtenerUbicacionesDisponibles();
                foreach (var ubicacion in ubicaciones)
                {
                    ddlUbicacion.Items.Add(new ListItem(ubicacion, ubicacion));
                }

                // Cargar tamaños
                var tamanos = CN_AdopcionService.ObtenerTamanosDisponibles();
                if (tamanos.Count > 0)
                {
                    foreach (var tamano in tamanos)
                    {
                        if (!ddlTamano.Items.Contains(new ListItem(tamano, tamano)))
                        {
                            ddlTamano.Items.Add(new ListItem(tamano, tamano));
                        }
                    }
                }

                // Cargar edades aproximadas
                var edades = CN_AdopcionService.ObtenerEdadesAproximadasDisponibles();
                foreach (var edad in edades)
                {
                    ddlEdadAproximada.Items.Add(new ListItem(edad, edad));
                }
            }
            catch (Exception ex)
            {
                MostrarError($"Error al cargar filtros: {ex.Message}");
            }
        }

        private void CargarMascotas()
        {
            try
            {
                // Obtener filtros seleccionados
                string especie = ddlEspecie.SelectedValue;
                string ubicacion = ddlUbicacion.SelectedValue;
                string tamano = ddlTamano.SelectedValue;
                string sexo = ddlSexo.SelectedValue;
                string edadAproximada = ddlEdadAproximada.SelectedValue;

                // Determinar filtros booleanos
                bool? esterilizado = chkEsterilizado.Checked ? (bool?)true : null;
                bool? vacunado = chkVacunado.Checked ? (bool?)true : null;

                // Obtener mascotas filtradas
                var mascotas = CN_AdopcionService.ObtenerMascotasDisponibles(
                    especie, ubicacion, tamano, sexo, edadAproximada, esterilizado, vacunado);

                // Actualizar contador
                lblContador.InnerText = mascotas.Count.ToString();

                // Mostrar/Ocultar paneles según resultados
                if (mascotas.Count == 0)
                {
                    panelMascotas.Visible = false;
                    panelNoResultados.Visible = true;
                    return;
                }

                panelMascotas.Visible = true;
                panelNoResultados.Visible = false;

                // Limpiar panel
                panelMascotas.Controls.Clear();

                // Obtener ID de usuario (si está logueado)
                int? idUsuario = null;
                if (Session["IdUsuario"] != null)
                {
                    idUsuario = Convert.ToInt32(Session["IdUsuario"]);
                }

                // Crear cartas para cada mascota
                foreach (var mascota in mascotas)
                {
                    panelMascotas.Controls.Add(CrearCartaMascota(mascota, idUsuario));
                }
            }
            catch (Exception ex)
            {
                MostrarError($"Error al cargar mascotas: {ex.Message}");
                panelMascotas.Visible = false;
                panelNoResultados.Visible = true;
            }
        }

        private Panel CrearCartaMascota(MascotaDisponibleDTO mascota, int? idUsuario)
        {
            // Panel principal de la carta
            Panel cardPanel = new Panel();
            cardPanel.CssClass = "col";

            // Card container
            Panel card = new Panel();
            card.CssClass = "card h-100 shadow-sm border-0";

            // Imagen de la mascota
            Image img = new Image();
            img.ImageUrl = !string.IsNullOrEmpty(mascota.FotoPrincipal)
                ? mascota.FotoPrincipal
                : "~/Images/default-pet.jpg";
            img.CssClass = "card-img-top";
            img.AlternateText = mascota.mas_Nombre;
            img.Style.Add("height", "250px");
            img.Style.Add("object-fit", "cover");
            img.Attributes.Add("onerror", "this.src='Images/default-pet.jpg'");
            card.Controls.Add(img);

            // Badge de estado
            LiteralControl badgeEstado = new LiteralControl(
                $"<div class='position-absolute top-0 end-0 m-2'>" +
                $"<span class='badge bg-success'><i class='fas fa-heart'></i> Disponible</span></div>"
            );
            card.Controls.Add(badgeEstado);

            // Card body
            Panel cardBody = new Panel();
            cardBody.CssClass = "card-body d-flex flex-column";

            // Nombre y especie
            string iconoEspecie = CN_AdopcionService.ObtenerIconoEspecie(mascota.Especie);
            string sexoTexto = !string.IsNullOrEmpty(mascota.mas_Sexo) ? mascota.mas_Sexo : "";
            string iconoSexo = CN_AdopcionService.ObtenerIconoSexo(sexoTexto);
            string edadTexto = CN_AdopcionService.ObtenerEdadTexto(mascota.mas_Edad);

            LiteralControl header = new LiteralControl(
                $"<h5 class='card-title'><i class='{iconoEspecie}'></i> {mascota.mas_Nombre}" +
                $" <small><i class='{iconoSexo}'></i> {sexoTexto}</small></h5>" +
                $"<h6 class='card-subtitle mb-2 text-muted'>{mascota.Raza ?? mascota.Especie}</h6>"
            );
            cardBody.Controls.Add(header);

            // Información básica
            LiteralControl info = new LiteralControl(
                "<div class='mb-3'>" +
                $"<div><i class='fas fa-birthday-cake me-2'></i><strong>Edad:</strong> {edadTexto}" +
                $"{(string.IsNullOrEmpty(mascota.mas_EdadAproximada) ? "" : $" ({mascota.mas_EdadAproximada})")}</div>" +
                $"<div><i class='fas fa-expand-alt me-2'></i><strong>Tamaño:</strong> {mascota.mas_Tamano}</div>" +
                $"<div><i class='fas fa-home me-2'></i><strong>Refugio:</strong> {mascota.Refugio}</div>" +
                $"<div><i class='fas fa-map-marker-alt me-2'></i><strong>Ubicación:</strong> {mascota.CiudadRefugio}</div>" +
                "</div>"
            );
            cardBody.Controls.Add(info);

            // Estado de salud
            LiteralControl salud = new LiteralControl("<div class='mb-3'>");
            if (mascota.mas_Esterilizado == true)
                salud.Text += "<span class='badge bg-info me-1 mb-1'><i class='fas fa-stethoscope'></i> Esterilizado</span>";
            if (mascota.mas_Vacunado == true)
                salud.Text += "<span class='badge bg-success me-1 mb-1'><i class='fas fa-syringe'></i> Vacunado</span>";
            salud.Text += "</div>";
            cardBody.Controls.Add(salud);

            // Descripción (truncada)
            if (!string.IsNullOrEmpty(mascota.mas_Descripcion))
            {
                string descripcionCorta = mascota.mas_Descripcion.Length > 120
                    ? mascota.mas_Descripcion.Substring(0, 120) + "..."
                    : mascota.mas_Descripcion;

                LiteralControl descripcion = new LiteralControl(
                    $"<p class='card-text flex-grow-1'><small>{descripcionCorta}</small></p>"
                );
                cardBody.Controls.Add(descripcion);
            }

            card.Controls.Add(cardBody);

            // Card footer
            Panel cardFooter = new Panel();
            cardFooter.CssClass = "card-footer bg-white border-top-0 pt-0";

            // Verificar si ya tiene solicitud pendiente
            bool tieneSolicitud = idUsuario.HasValue &&
                CN_AdopcionService.TieneSolicitudPendiente(mascota.mas_IdMascota, idUsuario.Value);

            if (idUsuario.HasValue)
            {
                if (!tieneSolicitud)
                {
                    // Botón Solicitar Adopción
                    Button btnSolicitar = new Button();
                    btnSolicitar.Text = "<i class='fas fa-heart me-2'></i>Solicitar Adopción";
                    btnSolicitar.CssClass = "btn btn-primary w-100";
                    btnSolicitar.CommandArgument = mascota.mas_IdMascota.ToString();
                    btnSolicitar.Click += btnSolicitar_Click;
                    cardFooter.Controls.Add(btnSolicitar);
                }
                else
                {
                    // Mensaje de solicitud pendiente
                    LiteralControl mensaje = new LiteralControl(
                        "<div class='alert alert-info text-center py-2 mb-0'>" +
                        "<i class='fas fa-clock me-2'></i>Solicitud en proceso</div>"
                    );
                    cardFooter.Controls.Add(mensaje);
                }
            }
            else
            {
                // Botón para iniciar sesión
                HyperLink lnkLogin = new HyperLink();
                lnkLogin.Text = "<i class='fas fa-sign-in-alt me-2'></i>Iniciar sesión para adoptar";
                lnkLogin.NavigateUrl = "~/Login.aspx?returnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery);
                lnkLogin.CssClass = "btn btn-outline-primary w-100";
                cardFooter.Controls.Add(lnkLogin);
            }

            // Botón para ver más detalles
            HyperLink lnkDetalles = new HyperLink();
            lnkDetalles.Text = "<i class='fas fa-eye me-2'></i>Ver detalles";
            lnkDetalles.NavigateUrl = $"DetalleMascota.aspx?id={mascota.mas_IdMascota}";
            lnkDetalles.CssClass = "btn btn-outline-secondary w-100 mt-2";
            cardFooter.Controls.Add(lnkDetalles);

            card.Controls.Add(cardFooter);
            cardPanel.Controls.Add(card);

            return cardPanel;
        }

        // Evento para solicitar adopción
        protected void btnSolicitar_Click(object sender, EventArgs e)
        {
            try
            {
                if (Session["IdUsuario"] == null)
                {
                    Response.Redirect("~/Login.aspx?returnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
                    return;
                }

                int idMascota = Convert.ToInt32(((Button)sender).CommandArgument);
                int idUsuario = Convert.ToInt32(Session["IdUsuario"]);

                // Usar el método existente de CN_AdopcionService
                bool exito = CN_AdopcionService.SolicitarAdopcion(idMascota, idUsuario);

                if (exito)
                {
                    MostrarExito("¡Solicitud enviada con éxito! El refugio revisará tu solicitud pronto.");
                    CargarMascotas(); // Recargar para actualizar estados
                }
                else
                {
                    MostrarError("Ya existe una solicitud pendiente para esta mascota.");
                }
            }
            catch (Exception ex)
            {
                MostrarError($"Error al procesar la solicitud: {ex.Message}");
            }
        }

        // Eventos de filtros
        protected void ddlEspecie_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarMascotas();
        }

        protected void ddlUbicacion_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarMascotas();
        }

        protected void ddlTamano_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarMascotas();
        }

        protected void ddlSexo_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarMascotas();
        }

        protected void ddlEdadAproximada_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarMascotas();
        }

        protected void chkEsterilizado_CheckedChanged(object sender, EventArgs e)
        {
            CargarMascotas();
        }

        protected void chkVacunado_CheckedChanged(object sender, EventArgs e)
        {
            CargarMascotas();
        }

        protected void btnLimpiarFiltros_Click(object sender, EventArgs e)
        {
            // Resetear todos los filtros
            ddlEspecie.SelectedIndex = 0;
            ddlUbicacion.SelectedIndex = 0;
            ddlTamano.SelectedIndex = 0;
            ddlSexo.SelectedIndex = 0;
            ddlEdadAproximada.SelectedIndex = 0;
            chkEsterilizado.Checked = false;
            chkVacunado.Checked = false;

            CargarMascotas();
        }

        protected void btnVerTodas_Click(object sender, EventArgs e)
        {
            btnLimpiarFiltros_Click(sender, e);
        }

        // Métodos auxiliares para mostrar mensajes
        private void MostrarError(string mensaje)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Error",
                $"Swal.fire({{title: 'Error', text: '{mensaje.Replace("'", "\\'")}', icon: 'error'}});", true);
        }

        private void MostrarExito(string mensaje)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Exito",
                $"Swal.fire({{title: '¡Éxito!', text: '{mensaje.Replace("'", "\\'")}', icon: 'success'}});", true);
        }
    }
}