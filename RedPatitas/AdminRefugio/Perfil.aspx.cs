using System;
using System.Linq;
using System.Web.UI;
using System.IO;
using CapaDatos;

namespace RedPatitas.AdminRefugio
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
                        txtEmail.Text = usuario.usu_Email;

                        // Cargar datos del refugio asociado
                        if (usuario.usu_IdRefugio.HasValue)
                        {
                            var refugio = dc.tbl_Refugios.FirstOrDefault(r => r.ref_IdRefugio == usuario.usu_IdRefugio.Value);
                            if (refugio != null)
                            {
                                txtNombreRefugio.Text = refugio.ref_Nombre;
                                txtDescripcion.Text = refugio.ref_Descripcion;
                                txtTelefono.Text = refugio.ref_Telefono;
                                txtCiudad.Text = refugio.ref_Ciudad;
                                txtDireccion.Text = refugio.ref_Direccion;

                                if (refugio.ref_Latitud.HasValue)
                                    hfLatitud.Value = refugio.ref_Latitud.Value.ToString(System.Globalization.CultureInfo.InvariantCulture);
                                if (refugio.ref_Longitud.HasValue)
                                    hfLongitud.Value = refugio.ref_Longitud.Value.ToString(System.Globalization.CultureInfo.InvariantCulture);

                                if (!string.IsNullOrEmpty(refugio.ref_LogoUrl))
                                {
                                    imgFotoActual.ImageUrl = refugio.ref_LogoUrl;
                                }
                            }
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
                        // Actualizar datos del refugio
                        if (usuario.usu_IdRefugio.HasValue)
                        {
                            var refugio = dc.tbl_Refugios.FirstOrDefault(r => r.ref_IdRefugio == usuario.usu_IdRefugio.Value);
                            if (refugio != null)
                            {
                                refugio.ref_Nombre = txtNombreRefugio.Text.Trim();
                                refugio.ref_Descripcion = txtDescripcion.Text.Trim();
                                refugio.ref_Telefono = txtTelefono.Text.Trim();
                                refugio.ref_Ciudad = txtCiudad.Text.Trim();
                                refugio.ref_Direccion = txtDireccion.Text.Trim();

                                if (!string.IsNullOrEmpty(hfLatitud.Value))
                                    refugio.ref_Latitud = decimal.Parse(hfLatitud.Value, System.Globalization.CultureInfo.InvariantCulture);
                                if (!string.IsNullOrEmpty(hfLongitud.Value))
                                    refugio.ref_Longitud = decimal.Parse(hfLongitud.Value, System.Globalization.CultureInfo.InvariantCulture);

                                if (seSubioFoto)
                                {
                                    EliminarFotoAnterior(refugio.ref_LogoUrl);
                                    refugio.ref_LogoUrl = nuevaUrlFoto;
                                    imgFotoActual.ImageUrl = nuevaUrlFoto;
                                }
                            }
                        }

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

                        dc.SubmitChanges();

                        // Actualizar sidebar inmediatamente
                        var lblNombre = Master.FindControl("lblNombreUsuario") as System.Web.UI.WebControls.Label;
                        if (lblNombre != null)
                        {
                            lblNombre.Text = txtNombreRefugio.Text.Trim();
                        }

                        if (seSubioFoto)
                        {
                            var imgSidebar = Master.FindControl("imgPerfilUsuario") as System.Web.UI.WebControls.Image;
                            if (imgSidebar != null)
                            {
                                imgSidebar.ImageUrl = nuevaUrlFoto;
                            }
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

                string nombreArchivo = "adminrefugio_" + idUsuario + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + extension;
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
                if (!fotoUrl.Contains("~/Images/adminrefugio_")) return;

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