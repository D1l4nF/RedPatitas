using System;
using System.Linq;
using System.Web.UI;
using System.IO;
using CapaDatos;

namespace RedPatitas.Admin
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
                        txtNombre.Text = usuario.usu_Nombre;
                        txtApellido.Text = usuario.usu_Apellido;
                        txtEmail.Text = usuario.usu_Email;
                        txtTelefono.Text = usuario.usu_Telefono;

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

                if (fuFotoPerfil.HasFile)
                {
                    nuevaUrlFoto = SubirFoto(idUsuario);
                    if (string.IsNullOrEmpty(nuevaUrlFoto)) return;
                    seSubioFoto = true;
                }

                using (DataClasses1DataContext dc = new DataClasses1DataContext())
                {
                    var usuario = dc.tbl_Usuarios.FirstOrDefault(u => u.usu_IdUsuario == idUsuario);

                    if (usuario != null)
                    {
                        usuario.usu_Nombre = txtNombre.Text.Trim();
                        usuario.usu_Apellido = txtApellido.Text.Trim();
                        usuario.usu_Telefono = txtTelefono.Text.Trim();

                        // Actualizar contraseña si se proporcionó
                        if (!string.IsNullOrEmpty(txtNuevaClave.Text))
                        {
                            if (string.IsNullOrEmpty(txtClaveActual.Text))
                            {
                                lblErrorClave.Text = "Debes ingresar tu contraseña actual para cambiarla.";
                                lblErrorClave.Visible = true;
                                return;
                            }

                            if (!CapaNegocios.CN_CryptoService.VerifyPassword(txtClaveActual.Text, usuario.usu_Contrasena, usuario.usu_Salt))
                            {
                                lblErrorClave.Text = "La contraseña actual es incorrecta.";
                                lblErrorClave.Visible = true;
                                return;
                            }

                            if (txtNuevaClave.Text != txtConfirmarClave.Text)
                            {
                                lblErrorClave.Text = "Las contraseñas nuevas no coinciden.";
                                lblErrorClave.Visible = true;
                                return;
                            }

                            string nuevoSalt = CapaNegocios.CN_CryptoService.GenerarSalt();
                            string nuevoHash = CapaNegocios.CN_CryptoService.HashPassword(txtNuevaClave.Text, nuevoSalt);
                            usuario.usu_Contrasena = nuevoHash;
                            usuario.usu_Salt = nuevoSalt;
                            lblErrorClave.Visible = false;
                        }

                        if (seSubioFoto)
                        {
                            EliminarFotoAnterior(usuario.usu_FotoUrl);
                            usuario.usu_FotoUrl = nuevaUrlFoto;
                            imgFotoActual.ImageUrl = nuevaUrlFoto;
                            Session["FotoUrl"] = nuevaUrlFoto;

                            var imgSidebar = Master.FindControl("imgPerfilUsuario") as System.Web.UI.WebControls.Image;
                            if (imgSidebar != null)
                            {
                                imgSidebar.ImageUrl = nuevaUrlFoto;
                            }
                        }

                        dc.SubmitChanges();

                        // Actualizar nombre en el sidebar inmediatamente
                        var lblNombre = Master.FindControl("lblNombreUsuario") as System.Web.UI.WebControls.Label;
                        if (lblNombre != null)
                        {
                            lblNombre.Text = txtNombre.Text.Trim() + " " + txtApellido.Text.Trim();
                        }

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

                string nombreArchivo = "admin_" + idUsuario + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + extension;
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
                if (string.IsNullOrEmpty(fotoUrl)) return;
                if (!fotoUrl.Contains("~/Images/admin_")) return;

                string rutaFisica = Server.MapPath(fotoUrl);
                if (File.Exists(rutaFisica))
                {
                    File.Delete(rutaFisica);
                }
            }
            catch { }
        }

        private void MostrarMensaje(string mensaje, bool esExito)
        {
            pnlMensaje.Visible = true;
            lblMensaje.Text = mensaje;
            lblMensaje.ForeColor = esExito ? System.Drawing.Color.Green : System.Drawing.Color.Red;
        }
    }
}