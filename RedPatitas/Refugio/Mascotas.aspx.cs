using CapaDatos;
using CapaNegocios;
using System;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RedPatitas.Refugio
{
    public partial class Mascotas : System.Web.UI.Page
    {
        CN_MascotaService mascotaService = new CN_MascotaService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["RefugioId"] == null)
                {
                    Response.Redirect("~/Login/Login.aspx");
                    return;
                }

                CargarEspecies();
                CargarMascotas();
            }
        }

        private void CargarEspecies()
        {
            var especies = mascotaService.ObtenerEspecies();
            ddlEspecie.Items.Clear();
            ddlEspecie.Items.Add(new ListItem("-- Seleccionar --", ""));
            foreach (var esp in especies)
            {
                ddlEspecie.Items.Add(new ListItem(esp.esp_Nombre, esp.esp_IdEspecie.ToString()));
            }
        }

        protected void ddlEspecie_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarRazas();
        }

        private void CargarRazas()
        {
            ddlRaza.Items.Clear();
            ddlRaza.Items.Add(new ListItem("-- Seleccionar --", ""));

            if (!string.IsNullOrEmpty(ddlEspecie.SelectedValue))
            {
                int idEspecie = int.Parse(ddlEspecie.SelectedValue);
                var razas = mascotaService.ObtenerRazasPorEspecie(idEspecie);
                foreach (var raza in razas)
                {
                    ddlRaza.Items.Add(new ListItem(raza.raz_Nombre, raza.raz_IdRaza.ToString()));
                }
            }
        }

        private void CargarMascotas()
        {
            int idRefugio = Convert.ToInt32(Session["RefugioId"]);
            var mascotas = mascotaService.ObtenerMascotasPorRefugio(idRefugio);

            if (mascotas.Count > 0)
            {
                rptMascotas.DataSource = mascotas;
                rptMascotas.DataBind();
                pnlLista.Visible = true;
                pnlEmpty.Visible = false;
            }
            else
            {
                pnlLista.Visible = false;
                pnlEmpty.Visible = true;
            }
        }

        protected void btnNuevaMascota_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
            litTituloForm.Text = "Nueva Mascota";
            pnlFormulario.Visible = true;
            pnlLista.Visible = false;
            pnlEmpty.Visible = false;
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            pnlFormulario.Visible = false;
            CargarMascotas();
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                int idRefugio = Convert.ToInt32(Session["RefugioId"]);
                int idMascota = int.Parse(hfIdMascota.Value);

                var mascota = new tbl_Mascotas
                {
                    mas_IdMascota = idMascota,
                    mas_Nombre = txtNombre.Text.Trim(),
                    mas_IdRefugio = idRefugio,
                    mas_IdRaza = string.IsNullOrEmpty(ddlRaza.SelectedValue) ? (int?)null : int.Parse(ddlRaza.SelectedValue),
                    mas_Sexo = string.IsNullOrEmpty(ddlSexo.SelectedValue) ? (char?)null : ddlSexo.SelectedValue[0],
                    mas_EdadAproximada = ddlEdad.SelectedValue,
                    mas_Tamano = ddlTamano.SelectedValue,
                    mas_Color = txtColor.Text.Trim(),
                    mas_Descripcion = txtDescripcion.Text.Trim(),
                    mas_Vacunado = chkVacunado.Checked,
                    mas_Esterilizado = chkEsterilizado.Checked,
                    mas_EstadoAdopcion = "Disponible"
                };

                if (idMascota == 0)
                {
                    // Nueva mascota
                    int nuevoId = mascotaService.RegistrarMascota(mascota);
                    if (nuevoId > 0)
                    {
                        // Subir fotos (galería)
                        SubirFotos(nuevoId);
                        MostrarMensaje("Mascota registrada exitosamente", true);
                    }
                    else
                    {
                        MostrarMensaje("Error al registrar la mascota", false);
                    }
                }
                else
                {
                    // Actualizar mascota
                    bool exito = mascotaService.ActualizarMascota(mascota);
                    if (exito)
                    {
                        SubirFotos(idMascota);
                        MostrarMensaje("Mascota actualizada exitosamente", true);
                    }
                    else
                    {
                        MostrarMensaje("Error al actualizar la mascota", false);
                    }
                }

                pnlFormulario.Visible = false;
                CargarMascotas();
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error: " + ex.Message, false);
            }
        }

        private void SubirFotos(int idMascota)
        {
            try
            {
                if (fuFoto.HasFiles)
                {
                    string rutaFisica = Server.MapPath("~/Images/Mascotas/");
                    if (!Directory.Exists(rutaFisica))
                        Directory.CreateDirectory(rutaFisica);

                    bool esPrimera = true;
                    foreach (var archivo in fuFoto.PostedFiles)
                    {
                        string extension = Path.GetExtension(archivo.FileName).ToLower();
                        if (extension == ".jpg" || extension == ".jpeg" || extension == ".png" || extension == ".gif")
                        {
                            string nombreArchivo = $"mascota_{idMascota}_{DateTime.Now.Ticks}{extension}";
                            string rutaCompleta = Path.Combine(rutaFisica, nombreArchivo);
                            archivo.SaveAs(rutaCompleta);

                            string urlFoto = $"~/Images/Mascotas/{nombreArchivo}";
                            mascotaService.AgregarFotoMascota(idMascota, urlFoto, esPrimera);
                            esPrimera = false; // Solo la primera foto es principal
                        }
                    }
                }
                else if (fuFoto.HasFile)
                {
                    // Single file fallback
                    string extension = Path.GetExtension(fuFoto.FileName).ToLower();
                    if (extension == ".jpg" || extension == ".jpeg" || extension == ".png" || extension == ".gif")
                    {
                        string rutaFisica = Server.MapPath("~/Images/Mascotas/");
                        if (!Directory.Exists(rutaFisica))
                            Directory.CreateDirectory(rutaFisica);

                        string nombreArchivo = $"mascota_{idMascota}_{DateTime.Now.Ticks}{extension}";
                        string rutaCompleta = Path.Combine(rutaFisica, nombreArchivo);
                        fuFoto.SaveAs(rutaCompleta);

                        string urlFoto = $"~/Images/Mascotas/{nombreArchivo}";
                        mascotaService.AgregarFotoMascota(idMascota, urlFoto, true);
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error SubirFotos: " + ex.Message);
            }
        }

        protected void rptMascotas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int idMascota = int.Parse(e.CommandArgument.ToString());

            if (e.CommandName == "Editar")
            {
                CargarMascotaParaEdicion(idMascota);
            }
            else if (e.CommandName == "Eliminar")
            {
                mascotaService.EliminarMascota(idMascota);
                MostrarMensaje("Mascota eliminada", true);
                CargarMascotas();
            }
        }

        private void CargarMascotaParaEdicion(int idMascota)
        {
            var mascota = mascotaService.ObtenerMascotaPorId(idMascota);
            if (mascota != null)
            {
                hfIdMascota.Value = idMascota.ToString();
                txtNombre.Text = mascota.Nombre;
                txtColor.Text = mascota.Color;
                txtDescripcion.Text = mascota.Descripcion;
                SetDropdownValue(ddlSexo, mascota.Sexo == "Macho" ? "M" : mascota.Sexo == "Hembra" ? "H" : "");
                SetDropdownValue(ddlEdad, mascota.EdadAproximada);
                SetDropdownValue(ddlTamano, mascota.Tamano);
                chkVacunado.Checked = mascota.Vacunado;
                chkEsterilizado.Checked = mascota.Esterilizado;

                litTituloForm.Text = "Editar Mascota";
                pnlFormulario.Visible = true;
                pnlLista.Visible = false;
            }
        }

        private void SetDropdownValue(DropDownList ddl, string value)
        {
            if (ddl.Items.FindByValue(value ?? "") != null)
            {
                ddl.SelectedValue = value ?? "";
            }
            else
            {
                ddl.SelectedIndex = 0;
            }
        }

        private void LimpiarFormulario()
        {
            hfIdMascota.Value = "0";
            txtNombre.Text = "";
            txtColor.Text = "";
            txtDescripcion.Text = "";
            ddlEspecie.SelectedIndex = 0;
            ddlRaza.Items.Clear();
            ddlRaza.Items.Add(new ListItem("-- Seleccionar --", ""));
            ddlSexo.SelectedIndex = 0;
            ddlEdad.SelectedIndex = 0;
            ddlTamano.SelectedIndex = 0;
            chkVacunado.Checked = false;
            chkEsterilizado.Checked = false;
        }

        private void MostrarMensaje(string mensaje, bool exito)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.ForeColor = exito ? System.Drawing.Color.Green : System.Drawing.Color.Red;
            lblMensaje.Visible = true;
        }

        protected string GetStatusClass(string estado)
        {
            switch (estado?.ToLower())
            {
                case "disponible": return "available";
                case "enproceso": return "process";
                case "adoptado": return "adopted";
                default: return "available";
            }
        }

        protected string GetBadgeClass(string estado)
        {
            switch (estado?.ToLower())
            {
                case "disponible": return "pet-badge-new";
                case "enproceso": return "pet-badge-process";
                case "adoptado": return "pet-badge-urgent";
                default: return "pet-badge-new";
            }
        }

        protected string GetEmojiByEspecie(string especie)
        {
            switch (especie?.ToLower())
            {
                case "perro": return "🐕";
                case "gato": return "🐱";
                case "conejo": return "🐰";
                case "ave": return "🐦";
                case "hámster": return "🐹";
                default: return "🐾";
            }
        }

        protected string ResolveFotoUrl(object foto)
        {
            if (foto == null || string.IsNullOrEmpty(foto.ToString()))
                return "~/Images/placeholder-pet.png";

            string url = foto.ToString();
            if (url.StartsWith("~/"))
            {
                return ResolveUrl(url);
            }
            return url;
        }
    }
}
