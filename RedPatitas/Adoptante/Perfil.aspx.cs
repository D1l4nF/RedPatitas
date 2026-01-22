using System;
using System.Linq;
using System.Web.UI;
using System.IO; // Importante para manejo de archivos
using CapaDatos;

namespace RedPatitas.Adoptante
{
    public partial class Perfil : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UsuarioId"] == null)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CargarDatosUsuario();
            }
        }

        private void CargarDatosUsuario()
        {
            try
            {
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);

                using (DataClasses1DataContext dc = new DataClasses1DataContext())
                {
                    var usuario = dc.tbl_Usuarios.FirstOrDefault(u => u.usu_IdUsuario == idUsuario);

                    if (usuario != null)
                    {
                        // Mapeo de datos
                        txtNombre.Text = usuario.usu_Nombre;
                        txtApellido.Text = usuario.usu_Apellido;
                        txtEmail.Text = usuario.usu_Email;
                        txtTelefono.Text = usuario.usu_Telefono;
                        txtCedula.Text = usuario.usu_Cedula;
                        txtCiudad.Text = usuario.usu_Ciudad; // Cargar ciudad

                        // Cargar coordenadas del mapa
                        if (usuario.usu_Latitud.HasValue)
                            hfLatitud.Value = usuario.usu_Latitud.Value.ToString(System.Globalization.CultureInfo.InvariantCulture);
                        if (usuario.usu_Longitud.HasValue)
                            hfLongitud.Value = usuario.usu_Longitud.Value.ToString(System.Globalization.CultureInfo.InvariantCulture);

                        // Cargar foto
                        if (!string.IsNullOrEmpty(usuario.usu_FotoUrl))
                        {
                            imgFotoActual.ImageUrl = usuario.usu_FotoUrl;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al cargar: " + ex.Message, false);
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);
                string nuevaUrlFoto = "";
                bool seSubioFoto = false;

                // 1. Verificar si hay foto nueva seleccionada
                if (fuFotoPerfil.HasFile)
                {
                    nuevaUrlFoto = SubirFoto(idUsuario);
                    if (string.IsNullOrEmpty(nuevaUrlFoto)) return; // Error en validación de foto
                    seSubioFoto = true;
                }

                using (DataClasses1DataContext dc = new DataClasses1DataContext())
                {
                    var usuario = dc.tbl_Usuarios.FirstOrDefault(u => u.usu_IdUsuario == idUsuario);

                    if (usuario != null)
                    {
                        // 2. Actualizar datos de texto
                        usuario.usu_Nombre = txtNombre.Text.Trim();
                        usuario.usu_Apellido = txtApellido.Text.Trim();
                        usuario.usu_Telefono = txtTelefono.Text.Trim();
                        usuario.usu_Cedula = txtCedula.Text.Trim();
                        usuario.usu_Ciudad = txtCiudad.Text.Trim(); // Guardar ciudad

                        // Guardar coordenadas del mapa
                        if (!string.IsNullOrEmpty(hfLatitud.Value))
                            usuario.usu_Latitud = decimal.Parse(hfLatitud.Value, System.Globalization.CultureInfo.InvariantCulture);
                        if (!string.IsNullOrEmpty(hfLongitud.Value))
                            usuario.usu_Longitud = decimal.Parse(hfLongitud.Value, System.Globalization.CultureInfo.InvariantCulture);

                        // 3. Actualizar contraseña SOLO si escribió algo
                        if (!string.IsNullOrEmpty(txtNuevaClave.Text))
                        {
                            // Verificar que ingresó la contraseña actual
                            if (string.IsNullOrEmpty(txtClaveActual.Text))
                            {
                                lblErrorClave.Text = "Debes ingresar tu contraseña actual para cambiarla.";
                                lblErrorClave.Visible = true;
                                return;
                            }

                            // Verificar que la contraseña actual sea correcta
                            if (!CapaNegocios.CN_CryptoService.VerifyPassword(txtClaveActual.Text, usuario.usu_Contrasena, usuario.usu_Salt))
                            {
                                lblErrorClave.Text = "La contraseña actual es incorrecta.";
                                lblErrorClave.Visible = true;
                                return;
                            }

                            // Verificar que las nuevas contraseñas coincidan
                            if (txtNuevaClave.Text != txtConfirmarClave.Text)
                            {
                                lblErrorClave.Text = "Las contraseñas nuevas no coinciden.";
                                lblErrorClave.Visible = true;
                                return;
                            }

                            // Generar nuevo salt y hash
                            string nuevoSalt = CapaNegocios.CN_CryptoService.GenerarSalt();
                            string nuevoHash = CapaNegocios.CN_CryptoService.HashPassword(txtNuevaClave.Text, nuevoSalt);
                            usuario.usu_Contrasena = nuevoHash;
                            usuario.usu_Salt = nuevoSalt;
                            lblErrorClave.Visible = false;
                        }

                        // 4. Actualizar foto
                        if (seSubioFoto)
                        {
                            // Eliminar foto anterior del servidor si existe
                            EliminarFotoAnterior(usuario.usu_FotoUrl);

                            usuario.usu_FotoUrl = nuevaUrlFoto;
                            imgFotoActual.ImageUrl = nuevaUrlFoto;
                            Session["FotoUrl"] = nuevaUrlFoto;

                            // Actualizar también la imagen del sidebar en el Master page
                            var imgSidebar = Master.FindControl("imgPerfilUsuario") as System.Web.UI.WebControls.Image;
                            if (imgSidebar != null)
                            {
                                imgSidebar.ImageUrl = nuevaUrlFoto;
                            }
                        }

                        dc.SubmitChanges();
                        
                        // Registrar auditoría
                        CapaNegocios.CN_AuditoriaService.RegistrarAccion(idUsuario, "UPDATE", "tbl_Usuarios", idUsuario, null, "Actualización de perfil");
                        
                        MostrarMensaje("¡Perfil actualizado correctamente!", true);
                    }
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al guardar: " + ex.Message, false);
            }
        }

        private string SubirFoto(int idUsuario)
        {
            try
            {
                string extension = Path.GetExtension(fuFotoPerfil.FileName).ToLower();
                if (extension != ".jpg" && extension != ".jpeg" && extension != ".png")
                {
                    MostrarMensaje("Solo formato JPG/PNG.", false);
                    return "";
                }

                if (fuFotoPerfil.PostedFile.ContentLength > 2097152)
                {
                    MostrarMensaje("Máximo 2MB.", false);
                    return "";
                }

                string nombreArchivo = "user_" + idUsuario + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + extension;
                string rutaFisica = Server.MapPath("~/Images/") + nombreArchivo;
                fuFotoPerfil.SaveAs(rutaFisica);

                return "~/Images/" + nombreArchivo;
            }
            catch
            {
                MostrarMensaje("Error al subir imagen.", false);
                return "";
            }
        }

        private void EliminarFotoAnterior(string fotoUrl)
        {
            try
            {
                // No eliminar si no hay foto anterior o si es una imagen por defecto
                if (string.IsNullOrEmpty(fotoUrl)) return;
                if (!fotoUrl.Contains("~/Images/user_")) return; // Solo eliminamos fotos de usuarios

                string rutaFisica = Server.MapPath(fotoUrl);
                if (File.Exists(rutaFisica))
                {
                    File.Delete(rutaFisica);
                }
            }
            catch
            {
                // Si falla la eliminación, no interrumpimos el proceso
            }
        }

        private void MostrarMensaje(string mensaje, bool esExito)
        {
            pnlMensaje.Visible = true;
            lblMensaje.Text = mensaje;
            lblMensaje.ForeColor = esExito ? System.Drawing.Color.Green : System.Drawing.Color.Red;
        }

        // Evento que tenías en el HTML original, lo dejamos vacío o lo borras del HTML
        protected void btnCambiarFoto_Click(object sender, EventArgs e) { }
    }
}