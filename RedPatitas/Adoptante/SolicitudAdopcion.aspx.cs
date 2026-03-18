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
                
                if (!string.IsNullOrEmpty(Request.QueryString["edit"]))
                {
                    int idEdit;
                    if (int.TryParse(Request.QueryString["edit"], out idEdit))
                    {
                        CargarSolicitudParaEditar(idEdit);
                    }
                }
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
            if (!string.IsNullOrEmpty(Request.QueryString["edit"]))
                return;

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

        private void CargarSolicitudParaEditar(int idSolicitud)
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var solicitud = db.tbl_SolicitudesAdopcion.FirstOrDefault(s => s.sol_IdSolicitud == idSolicitud);

                    if (solicitud == null || solicitud.sol_IdUsuario != IdUsuario || solicitud.sol_IdMascota != IdMascota)
                    {
                        MostrarError("La solicitud no existe o no tienes permiso para editarla.");
                        pnlFormulario.Visible = false;
                        return;
                    }

                    if (solicitud.sol_Estado != "Pendiente")
                    {
                        MostrarError("Solo se pueden editar solicitudes en estado Pendiente.");
                        pnlFormulario.Visible = false;
                        return;
                    }

                    txtMotivo.Text = solicitud.sol_MotivoAdopcion;
                    txtExperiencia.Text = string.IsNullOrEmpty(solicitud.sol_ExperienciaMascotas) ? "" : solicitud.sol_ExperienciaMascotas;
                    
                    if (solicitud.sol_TipoVivienda == "Casa") rbCasa.Checked = true;
                    else if (solicitud.sol_TipoVivienda == "Apartamento") rbApartamento.Checked = true;
                    else if (solicitud.sol_TipoVivienda == "Finca") rbFinca.Checked = true;

                    chkPatioJardin.Checked = solicitud.sol_TienePatioJardin ?? false;
                    
                    chkOtrasMascotas.Checked = solicitud.sol_OtrasMascotas ?? false;
                    if (solicitud.sol_OtrasMascotas == true)
                    {
                        txtOtrasMascotas.Text = solicitud.sol_DetalleOtrasMascotas;
                        pnlOtrasMascotas.Style["display"] = "block";
                    }

                    chkNinos.Checked = solicitud.sol_TieneNinos ?? false;
                    if (solicitud.sol_TieneNinos == true)
                    {
                        txtEdadesNinos.Text = solicitud.sol_EdadesNinos;
                        pnlNinos.Style["display"] = "block";
                    }

                    if (ddlHorasEnCasa.Items.FindByValue(solicitud.sol_HorasEnCasa?.ToString()) != null)
                        ddlHorasEnCasa.SelectedValue = solicitud.sol_HorasEnCasa?.ToString();

                    if (ddlIngresos.Items.FindByValue(solicitud.sol_IngresosMensuales) != null)
                        ddlIngresos.SelectedValue = solicitud.sol_IngresosMensuales;

                    chkAceptaVisita.Checked = solicitud.sol_AceptaVisita ?? false;
                    txtComentarios.Text = solicitud.sol_Comentarios;

                    btnEnviar.Text = "✏️ Actualizar Solicitud";

                    // Prellenar fotos
                    var fotos = db.tbl_FotosSolicitud.Where(f => f.fos_IdSolicitud == idSolicitud).ToList();
                    string scriptFotos = "";
                    foreach (var f in fotos)
                    {
                        int num = 0;
                        if (f.fos_TipoFoto == "Frontal") num = 1;
                        else if (f.fos_TipoFoto == "Interior") num = 2;
                        else if (f.fos_TipoFoto == "Patio") num = 3;

                        if (num > 0 && !string.IsNullOrEmpty(f.fos_Url))
                        {
                            scriptFotos += $"showExistingPhoto({num}, '{ResolveUrl(f.fos_Url)}');\n";
                        }
                    }

                    if (!string.IsNullOrEmpty(scriptFotos))
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "LoadPhotos", "document.addEventListener('DOMContentLoaded', function() { " + scriptFotos + " });", true);
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar solicitud para editar: " + ex.Message);
                MostrarError("Error al cargar los datos de la solicitud.");
                pnlFormulario.Visible = false;
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
                    int? idEdit = null;
                    if (!string.IsNullOrEmpty(Request.QueryString["edit"]))
                    {
                        int parsed;
                        if (int.TryParse(Request.QueryString["edit"], out parsed))
                        {
                            idEdit = parsed;
                        }
                    }

                    if (!idEdit.HasValue)
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

                        // Guardar fotos de vivienda
                        GuardarFotosVivienda(db, nuevaSolicitud.sol_IdSolicitud);

                        // NOTIFICACIÓN: Nueva solicitud para el refugio (Avisar a todos los admins del refugio)
                        try
                        {
                            var usuariosRefugio = CN_NotificacionService.ObtenerUsuariosRefugio(mascota.mas_IdRefugio);
                            foreach (int adminId in usuariosRefugio)
                            {
                                CN_NotificacionService.Crear(
                                    adminId, 
                                    "Nueva Solicitud", 
                                    $"Has recibido una nueva solicitud de adopción para la mascota {mascota.mas_Nombre}.", 
                                    "Adopcion", 
                                    "/AdminRefugio/RevisarSolicitud.aspx?id=" + nuevaSolicitud.sol_IdSolicitud, 
                                    "fas fa-envelope"
                                );
                            }
                        }
                        catch (Exception exNotif)
                        {
                            System.Diagnostics.Debug.WriteLine("Error al notificar al refugio: " + exNotif.Message);
                        }

                        // Redirigir a página de éxito o a mis solicitudes
                        Response.Redirect("~/Adoptante/Solicitudes.aspx?success=1");
                    }
                    else
                    {
                        var solicitudExitente = db.tbl_SolicitudesAdopcion.FirstOrDefault(s => s.sol_IdSolicitud == idEdit.Value);
                        if (solicitudExitente == null || solicitudExitente.sol_IdUsuario != IdUsuario || solicitudExitente.sol_Estado != "Pendiente")
                        {
                            MostrarError("No puedes editar esta solicitud porque no está en estado Pendiente o no te pertenece.");
                            return;
                        }

                        // Actualizar
                        solicitudExitente.sol_MotivoAdopcion = txtMotivo.Text.Trim();
                        solicitudExitente.sol_ExperienciaMascotas = txtExperiencia.Text.Trim();
                        solicitudExitente.sol_TipoVivienda = tipoVivienda;
                        solicitudExitente.sol_TienePatioJardin = chkPatioJardin.Checked;
                        solicitudExitente.sol_OtrasMascotas = chkOtrasMascotas.Checked;
                        solicitudExitente.sol_DetalleOtrasMascotas = chkOtrasMascotas.Checked ? txtOtrasMascotas.Text.Trim() : null;
                        solicitudExitente.sol_TieneNinos = chkNinos.Checked;
                        solicitudExitente.sol_EdadesNinos = chkNinos.Checked ? txtEdadesNinos.Text.Trim() : null;
                        solicitudExitente.sol_HorasEnCasa = horasEnCasa;
                        solicitudExitente.sol_IngresosMensuales = ddlIngresos.SelectedValue;
                        solicitudExitente.sol_AceptaVisita = chkAceptaVisita.Checked;
                        solicitudExitente.sol_Comentarios = txtComentarios.Text.Trim();
                        // Nota: El estado ya venía de ser "Pendiente", así que lo mantenemos. No es necesario re-setear la fecha a menos que se desee.
                        
                        db.SubmitChanges();
                        
                        // Guardar fotos de vivienda (añade nuevas que se subieron)
                        GuardarFotosVivienda(db, solicitudExitente.sol_IdSolicitud);

                        Response.Redirect("~/Adoptante/Solicitudes.aspx?success=2");
                    }
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

        /// <summary>
        /// Guarda las fotos de vivienda subidas por el adoptante
        /// </summary>
        private void GuardarFotosVivienda(DataClasses1DataContext db, int idSolicitud)
        {
            try
            {
                var tiposFoto = new[] { "Frontal", "Interior", "Patio" };
                var fileUploads = new[] { fuFoto1, fuFoto2, fuFoto3 };

                for (int i = 0; i < fileUploads.Length; i++)
                {
                    if (fileUploads[i].HasFile)
                    {
                        try
                        {
                            // Subir foto
                            string urlFoto = SubirFoto(fileUploads[i], idSolicitud, tiposFoto[i]);

                            if (!string.IsNullOrEmpty(urlFoto))
                            {
                                // Eliminar foto anterior del mismo tipo si existe para no duplicar
                                db.ExecuteCommand("DELETE FROM tbl_FotosSolicitud WHERE fos_IdSolicitud = {0} AND fos_TipoFoto = {1}", idSolicitud, tiposFoto[i]);

                                // Guardar en BD usando SQL directo
                                db.ExecuteCommand(
                                    @"INSERT INTO tbl_FotosSolicitud (fos_IdSolicitud, fos_Url, fos_TipoFoto, fos_FechaSubida) 
                                      VALUES ({0}, {1}, {2}, {3})",
                                    idSolicitud, urlFoto, tiposFoto[i], DateTime.Now);
                            }
                        }
                        catch (Exception ex)
                        {
                            System.Diagnostics.Debug.WriteLine($"Error subiendo foto {i + 1}: {ex.Message}");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en GuardarFotosVivienda: " + ex.Message);
            }
        }

        /// <summary>
        /// Sube una foto y retorna la URL (guarda localmente)
        /// </summary>
        private string SubirFoto(System.Web.UI.WebControls.FileUpload fileUpload, int idSolicitud, string tipo)
        {
            return GuardarFotoLocal(fileUpload, idSolicitud, tipo);
        }

        /// <summary>
        /// Guarda la foto localmente como fallback
        /// </summary>
        private string GuardarFotoLocal(System.Web.UI.WebControls.FileUpload fileUpload, int idSolicitud, string tipo)
        {
            try
            {
                string carpeta = Server.MapPath("~/Uploads/Solicitudes/" + idSolicitud);
                if (!System.IO.Directory.Exists(carpeta))
                {
                    System.IO.Directory.CreateDirectory(carpeta);
                }

                string extension = System.IO.Path.GetExtension(fileUpload.FileName);
                string nombreArchivo = $"{tipo}_{DateTime.Now.Ticks}{extension}";
                string rutaCompleta = System.IO.Path.Combine(carpeta, nombreArchivo);

                fileUpload.SaveAs(rutaCompleta);

                return $"~/Uploads/Solicitudes/{idSolicitud}/{nombreArchivo}";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error guardando local: " + ex.Message);
                return null;
            }
        }
    }
}
