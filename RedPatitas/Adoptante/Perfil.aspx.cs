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
                        // Mapeo de datos (IDs corregidos)
                        txtNombre.Text = usuario.usu_Nombre;
                        txtApellido.Text = usuario.usu_Apellido;
                        txtEmail.Text = usuario.usu_Email;
                        txtTelefono.Text = usuario.usu_Telefono;
                        txtCedula.Text = usuario.usu_Cedula; // Agregado campo Cédula
                        txtDireccion.Text = usuario.usu_Direccion;

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
                        usuario.usu_Cedula = txtCedula.Text.Trim(); // Guardamos Cédula
                        usuario.usu_Direccion = txtDireccion.Text.Trim();

                        // 3. Actualizar contraseña SOLO si escribió algo
                        if (!string.IsNullOrEmpty(txtNuevaClave.Text))
                        {
                            // AQUÍ DEBERÍAS ENCRIPTAR LA CLAVE ANTES DE GUARDAR
                            // Por ahora lo guardamos directo como ejemplo:
                            usuario.usu_Contrasena = txtNuevaClave.Text.Trim();
                        }

                        // 4. Actualizar foto
                        if (seSubioFoto)
                        {
                            usuario.usu_FotoUrl = nuevaUrlFoto;
                            imgFotoActual.ImageUrl = nuevaUrlFoto;
                            Session["FotoUrl"] = nuevaUrlFoto;
                        }

                        dc.SubmitChanges();
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