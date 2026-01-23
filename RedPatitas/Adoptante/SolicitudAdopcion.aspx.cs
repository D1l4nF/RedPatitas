using System;
using System.Linq;
using CapaDatos;
using CapaNegocios;

namespace RedPatitas.Adoptante
{
    public partial class SolicitudAdopcion : System.Web.UI.Page
    {
        private int IdMascota;
        private int IdUsuario;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificar sesión
            if (Session["UsuarioId"] == null)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }

            IdUsuario = Convert.ToInt32(Session["UsuarioId"]);

            // Obtener ID de mascota de la URL
            if (!int.TryParse(Request.QueryString["id"], out IdMascota))
            {
                Response.Redirect("~/Adoptante/Mascotas.aspx");
                return;
            }

            if (!IsPostBack)
            {
                VerificarPerfilCompleto();
                VerificarSolicitudExistente();
                CargarDatosMascota();
            }
        }

        /// <summary>
        /// Verifica si el usuario tiene su perfil completo (cédula y teléfono)
        /// </summary>
        private void VerificarPerfilCompleto()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var usuario = db.tbl_Usuarios.FirstOrDefault(u => u.usu_IdUsuario == IdUsuario);

                    if (usuario == null)
                    {
                        Response.Redirect("~/Login/Login.aspx");
                        return;
                    }

                    bool perfilCompleto = !string.IsNullOrEmpty(usuario.usu_Cedula) &&
                                          !string.IsNullOrEmpty(usuario.usu_Telefono);

                    if (!perfilCompleto)
                    {
                        pnlPerfilIncompleto.Visible = true;
                        pnlFormulario.Visible = false;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error verificando perfil: " + ex.Message);
                MostrarError("Error al verificar tu perfil. Intenta de nuevo.");
            }
        }

        /// <summary>
        /// Verifica si ya existe una solicitud pendiente para esta mascota
        /// </summary>
        private void VerificarSolicitudExistente()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    bool existeSolicitud = db.tbl_SolicitudesAdopcion
                        .Any(s => s.sol_IdMascota == IdMascota &&
                                  s.sol_IdUsuario == IdUsuario &&
                                  (s.sol_Estado == "Pendiente" || s.sol_Estado == "EnRevision"));

                    if (existeSolicitud)
                    {
                        pnlSolicitudExistente.Visible = true;
                        pnlFormulario.Visible = false;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error verificando solicitud: " + ex.Message);
            }
        }

        /// <summary>
        /// Carga los datos de la mascota para mostrar en el resumen
        /// </summary>
        private void CargarDatosMascota()
        {
            try
            {
                var servicio = new CN_MascotaService();
                var mascota = servicio.ObtenerMascotaPorId(IdMascota);

                if (mascota == null)
                {
                    Response.Redirect("~/Adoptante/Mascotas.aspx");
                    return;
                }

                // Verificar que la mascota esté disponible
                if (mascota.EstadoAdopcion != "Disponible" && mascota.EstadoAdopcion != "EnProceso")
                {
                    MostrarError("Esta mascota ya no está disponible para adopción.");
                    pnlFormulario.Visible = false;
                    return;
                }

                // Cargar datos
                litNombreBreadcrumb.Text = mascota.Nombre;
                litNombreMascota.Text = mascota.Nombre;
                litEspecie.Text = mascota.Especie + " - " + mascota.Raza;
                litUbicacion.Text = mascota.NombreRefugio + ", " + mascota.CiudadRefugio;
                litEdad.Text = mascota.EdadFormateada;

                // Foto o emoji
                if (!string.IsNullOrEmpty(mascota.FotoPrincipal))
                {
                    imgMascota.ImageUrl = mascota.FotoPrincipal;
                    imgMascota.Visible = true;
                    pnlEmoji.Visible = false;
                }
                else
                {
                    imgMascota.Visible = false;
                    pnlEmoji.Visible = true;
                    litEmoji.Text = mascota.EmojiEspecie;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cargando mascota: " + ex.Message);
                MostrarError("Error al cargar los datos de la mascota.");
            }
        }

        /// <summary>
        /// Evento click del botón enviar solicitud
        /// </summary>
        protected void btnEnviar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                IdMascota = int.Parse(Request.QueryString["id"]);
                IdUsuario = Convert.ToInt32(Session["UsuarioId"]);

                // Determinar tipo de vivienda
                string tipoVivienda = "";
                if (rbCasa.Checked) tipoVivienda = "Casa";
                else if (rbApartamento.Checked) tipoVivienda = "Apartamento";
                else if (rbFinca.Checked) tipoVivienda = "Finca";

                if (string.IsNullOrEmpty(tipoVivienda))
                {
                    MostrarError("Debes seleccionar un tipo de vivienda.");
                    return;
                }

                // Obtener horas en casa
                int horasEnCasa = 0;
                int.TryParse(ddlHorasEnCasa.SelectedValue, out horasEnCasa);

                using (var db = new DataClasses1DataContext())
                {
                    // Verificar nuevamente que no exista solicitud pendiente
                    bool existeSolicitud = db.tbl_SolicitudesAdopcion
                        .Any(s => s.sol_IdMascota == IdMascota &&
                                  s.sol_IdUsuario == IdUsuario &&
                                  (s.sol_Estado == "Pendiente" || s.sol_Estado == "EnRevision"));

                    if (existeSolicitud)
                    {
                        MostrarError("Ya tienes una solicitud pendiente para esta mascota.");
                        return;
                    }

                    // Crear la solicitud
                    var nuevaSolicitud = new tbl_SolicitudesAdopcion
                    {
                        sol_IdMascota = IdMascota,
                        sol_IdUsuario = IdUsuario,
                        sol_MotivoAdopcion = txtMotivo.Text.Trim(),
                        sol_ExperienciaMascotas = txtExperiencia.Text.Trim(),
                        sol_TipoVivienda = tipoVivienda,
                        sol_TienePatioJardin = chkPatioJardin.Checked,
                        sol_OtrasMascotas = chkOtrasMascotas.Checked,
                        sol_DetalleOtrasMascotas = chkOtrasMascotas.Checked ? txtOtrasMascotas.Text.Trim() : null,
                        sol_TieneNinos = chkNinos.Checked,
                        sol_EdadesNinos = chkNinos.Checked ? txtEdadesNinos.Text.Trim() : null,
                        sol_HorasEnCasa = horasEnCasa,
                        sol_IngresosMensuales = ddlIngresos.SelectedValue,
                        sol_AceptaVisita = chkAceptaVisita.Checked,
                        sol_Comentarios = txtComentarios.Text.Trim(),
                        sol_Estado = "Pendiente",
                        sol_FechaSolicitud = DateTime.Now
                    };

                    db.tbl_SolicitudesAdopcion.InsertOnSubmit(nuevaSolicitud);

                    // Actualizar estado de la mascota a "EnProceso"
                    var mascota = db.tbl_Mascotas.FirstOrDefault(m => m.mas_IdMascota == IdMascota);
                    if (mascota != null && mascota.mas_EstadoAdopcion == "Disponible")
                    {
                        mascota.mas_EstadoAdopcion = "EnProceso";
                    }

                    db.SubmitChanges();

                    // Redirigir a página de éxito o a mis solicitudes
                    Response.Redirect("~/Adoptante/Solicitudes.aspx?success=1");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al enviar solicitud: " + ex.Message);
                MostrarError("Error al enviar la solicitud. Intenta de nuevo. " + ex.Message);
            }
        }

        /// <summary>
        /// Muestra un mensaje de error
        /// </summary>
        private void MostrarError(string mensaje)
        {
            pnlError.Visible = true;
            litError.Text = mensaje;
        }
    }
}
