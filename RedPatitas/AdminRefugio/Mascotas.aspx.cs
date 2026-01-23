using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;
using CapaDatos;

namespace RedPatitas.AdminRefugio
{
    public partial class Mascotas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["RefugioId"] == null)
                {
                    Response.Redirect("~/Login/Login.aspx");
                    return;
                }
                CargarEspecies(); // Cargar combo de especies
                CargarMascotas();
            }
        }

        private void CargarEspecies()
        {
            try
            {
                CN_MascotaService service = new CN_MascotaService();
                var especies = service.ObtenerEspecies();
                ddlEspecie.DataSource = especies;
                ddlEspecie.DataTextField = "esp_Nombre";
                ddlEspecie.DataValueField = "esp_IdEspecie";
                ddlEspecie.DataBind();

                ddlEspecie.Items.Insert(0, new ListItem("Seleccione Especie", "0"));
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error CargarEspecies: " + ex.Message);
            }
        }

        protected void ddlEspecie_SelectedIndexChanged(object sender, EventArgs e)
        {
            int idEspecie;
            if (int.TryParse(ddlEspecie.SelectedValue, out idEspecie) && idEspecie > 0)
            {
                CargarRazas(idEspecie);
            }
            else
            {
                ddlRaza.Items.Clear();
                ddlRaza.Items.Insert(0, new ListItem("Seleccione Especie primero", ""));
            }
        }

        private void CargarRazas(int idEspecie)
        {
            try
            {
                CN_MascotaService service = new CN_MascotaService();
                var razas = service.ObtenerRazasPorEspecie(idEspecie);
                ddlRaza.DataSource = razas;
                ddlRaza.DataTextField = "raz_Nombre";
                ddlRaza.DataValueField = "raz_IdRaza";
                ddlRaza.DataBind();

                ddlRaza.Items.Insert(0, new ListItem("Seleccione Raza", ""));
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error CargarRazas: " + ex.Message);
            }
        }

        private void CargarMascotas()
        {
            try
            {
                int idRefugio = Convert.ToInt32(Session["RefugioId"]);
                CN_MascotaService service = new CN_MascotaService();
                var mascotas = service.ObtenerMascotasPorRefugio(idRefugio);
                rptMascotas.DataSource = mascotas;
                rptMascotas.DataBind();
            }
            catch (Exception ex)
            {
                // Manejo de error
                System.Diagnostics.Debug.WriteLine("Error CargarMascotas: " + ex.Message);
            }
        }

        protected void btnNuevaMascota_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
            pnlLista.Visible = false;
            pnlFormulario.Visible = true;
            litTituloFormulario.Text = "Registrar Nueva Mascota";
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            pnlLista.Visible = true;
            pnlFormulario.Visible = false;
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                if (!Page.IsValid) return;

                int idRefugio = Convert.ToInt32(Session["RefugioId"]);
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);

                // Obtener IdRaza seleccionado
                int idRaza = 0;
                int.TryParse(ddlRaza.SelectedValue, out idRaza);

                if (idRaza == 0)
                {
                    string scriptRaza = "Swal.fire({ title: 'Atención', text: 'Por favor seleccione una raza', icon: 'warning', confirmButtonColor: '#0D9488' });";
                    ScriptManager.RegisterStartupScript(this, GetType(), "swal-raza", scriptRaza, true);
                    return;
                }

                // Verificar si es edición o creación
                int idMascotaEditar = 0;
                int.TryParse(hfIdMascota.Value, out idMascotaEditar);
                bool esEdicion = idMascotaEditar > 0;

                using (var db = new DataClasses1DataContext())
                {
                    tbl_Mascotas mascota;

                    if (esEdicion)
                    {
                        // EDICIÓN: Obtener mascota existente
                        mascota = db.tbl_Mascotas.FirstOrDefault(m => m.mas_IdMascota == idMascotaEditar);
                        if (mascota == null)
                        {
                            string script404 = "Swal.fire({ title: 'Error', text: 'Mascota no encontrada', icon: 'error', confirmButtonColor: '#0D9488' });";
                            ScriptManager.RegisterStartupScript(this, GetType(), "swal-404", script404, true);
                            return;
                        }
                    }
                    else
                    {
                        // CREACIÓN: Nueva mascota
                        mascota = new tbl_Mascotas
                        {
                            mas_IdRefugio = idRefugio,
                            mas_IdUsuarioRegistro = idUsuario,
                            mas_EstadoAdopcion = "Disponible",
                            mas_FechaRegistro = DateTime.Now
                        };
                    }

                    // Asignar datos comunes
                    mascota.mas_Nombre = txtNombre.Text.Trim();
                    mascota.mas_Edad = int.TryParse(txtEdad.Text, out int edad) ? (int?)edad : null;
                    mascota.mas_EdadAproximada = CalcularEdadAproximada(mascota.mas_Edad);
                    mascota.mas_Sexo = !string.IsNullOrEmpty(ddlSexo.SelectedValue) ? Convert.ToChar(ddlSexo.SelectedValue) : (char?)null;
                    mascota.mas_Tamano = ddlTamano.SelectedValue;
                    mascota.mas_Color = txtColor.Text.Trim();
                    mascota.mas_Descripcion = txtDescripcion.Text;
                    mascota.mas_Vacunado = chkVacunado.Checked;
                    mascota.mas_Esterilizado = chkEsterilizado.Checked;
                    mascota.mas_Desparasitado = chkDesparasitado.Checked;
                    mascota.mas_IdRaza = idRaza;

                    if (!esEdicion)
                    {
                        db.tbl_Mascotas.InsertOnSubmit(mascota);
                    }

                    db.SubmitChanges();

                    int idMascotaGuardada = mascota.mas_IdMascota;

                    // Guardar las 3 fotos
                    GuardarFotosMascota(db, idMascotaGuardada, esEdicion);

                    // Éxito
                    string mensaje = esEdicion ? "Mascota actualizada correctamente" : "Mascota registrada correctamente";
                    string scriptSuccess = $"Swal.fire({{ title: '¡Éxito!', text: '{mensaje}', icon: 'success', confirmButtonColor: '#0D9488' }});";
                    ScriptManager.RegisterStartupScript(this, GetType(), "swal", scriptSuccess, true);

                    LimpiarFormulario();
                    pnlFormulario.Visible = false;
                    pnlLista.Visible = true;
                    CargarMascotas();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error Guardar: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Error Guardar: " + ex.Message);
                string scriptError = $"Swal.fire({{ title: 'Error', text: 'Error al guardar: {ex.Message.Replace("'", "")}', icon: 'error', confirmButtonColor: '#0D9488' }});";
                ScriptManager.RegisterStartupScript(this, GetType(), "swal-error", scriptError, true);
            }
        }

        /// <summary>
        /// Calcula una descripción de edad aproximada basada en meses
        /// </summary>
        private string CalcularEdadAproximada(int? edadMeses)
        {
            if (!edadMeses.HasValue) return "Desconocida";

            int meses = edadMeses.Value;
            if (meses < 3) return "Cachorro";
            if (meses < 12) return $"{meses} meses";

            int años = meses / 12;
            int mesesRestantes = meses % 12;

            if (mesesRestantes == 0)
                return años == 1 ? "1 año" : $"{años} años";
            else
                return $"{años} año(s) y {mesesRestantes} meses";
        }


        protected void rptMascotas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int idMascota = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Eliminar")
            {
                try
                {
                    CN_MascotaService service = new CN_MascotaService();
                    if (service.EliminarMascota(idMascota))
                    {
                        string scriptDel = "Swal.fire({ title: '¡Eliminado!', text: 'Mascota eliminada correctamente', icon: 'success', confirmButtonColor: '#0D9488' });";
                        ScriptManager.RegisterStartupScript(this, GetType(), "swal-del", scriptDel, true);
                        CargarMascotas();
                    }
                    else
                    {
                        string scriptWarn = "Swal.fire({ title: 'Atención', text: 'No se pudo eliminar la mascota. Puede tener solicitudes asociadas.', icon: 'warning', confirmButtonColor: '#0D9488' });";
                        ScriptManager.RegisterStartupScript(this, GetType(), "swal-warn", scriptWarn, true);
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error al eliminar: " + ex.Message);
                    string scriptErrDel = $"Swal.fire({{ title: 'Error', text: 'Error al eliminar: {ex.Message.Replace("'", "")}', icon: 'error', confirmButtonColor: '#0D9488' }});";
                    ScriptManager.RegisterStartupScript(this, GetType(), "swal-err-del", scriptErrDel, true);
                }
            }
            else if (e.CommandName == "Editar")
            {
                CargarMascotaParaEditar(idMascota);
            }
        }

        /// <summary>
        /// Carga los datos de una mascota en el formulario para editarla
        /// </summary>
        private void CargarMascotaParaEditar(int idMascota)
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var mascota = db.tbl_Mascotas
                        .FirstOrDefault(m => m.mas_IdMascota == idMascota);

                    if (mascota == null)
                    {
                        string script404Edit = "Swal.fire({ title: 'Error', text: 'Mascota no encontrada', icon: 'error', confirmButtonColor: '#0D9488' });";
                        ScriptManager.RegisterStartupScript(this, GetType(), "swal-404-edit", script404Edit, true);
                        return;
                    }

                    // Guardar ID para edición
                    hfIdMascota.Value = idMascota.ToString();

                    // Cargar datos en el formulario
                    txtNombre.Text = mascota.mas_Nombre;
                    txtEdad.Text = mascota.mas_Edad?.ToString() ?? "";
                    txtColor.Text = mascota.mas_Color ?? "";
                    txtDescripcion.Text = mascota.mas_Descripcion ?? "";

                    // Sexo
                    if (mascota.mas_Sexo.HasValue)
                    {
                        ddlSexo.SelectedValue = mascota.mas_Sexo.Value.ToString();
                    }

                    // Tamaño
                    if (!string.IsNullOrEmpty(mascota.mas_Tamano))
                    {
                        ListItem item = ddlTamano.Items.FindByValue(mascota.mas_Tamano);
                        if (item != null) ddlTamano.SelectedValue = mascota.mas_Tamano;
                    }

                    // Checkboxes
                    chkVacunado.Checked = mascota.mas_Vacunado ?? false;
                    chkEsterilizado.Checked = mascota.mas_Esterilizado ?? false;
                    chkDesparasitado.Checked = mascota.mas_Desparasitado ?? false;

                    // Cargar Especie y Raza
                    if (mascota.mas_IdRaza.HasValue)
                    {
                        var raza = db.tbl_Razas.FirstOrDefault(r => r.raz_IdRaza == mascota.mas_IdRaza.Value);
                        if (raza != null)
                        {
                            ddlEspecie.SelectedValue = raza.raz_IdEspecie.ToString();
                            CargarRazas(raza.raz_IdEspecie);
                            ddlRaza.SelectedValue = raza.raz_IdRaza.ToString();
                        }
                    }

                    // Cargar fotos existentes
                    var fotos = db.tbl_FotosMascotas
                        .Where(f => f.fot_IdMascota == idMascota)
                        .OrderByDescending(f => f.fot_EsPrincipal)
                        .Take(3)
                        .ToList();

                    // Mostrar fotos existentes en los previews
                    if (fotos.Count > 0)
                    {
                        imgPreview1.ImageUrl = fotos[0].fot_Url;
                        imgPreview1.Visible = true;
                        hfFotoUrl1.Value = fotos[0].fot_Url;
                    }
                    if (fotos.Count > 1)
                    {
                        imgPreview2.ImageUrl = fotos[1].fot_Url;
                        imgPreview2.Visible = true;
                        hfFotoUrl2.Value = fotos[1].fot_Url;
                    }
                    if (fotos.Count > 2)
                    {
                        imgPreview3.ImageUrl = fotos[2].fot_Url;
                        imgPreview3.Visible = true;
                        hfFotoUrl3.Value = fotos[2].fot_Url;
                    }

                    // Mostrar formulario en modo edición
                    pnlLista.Visible = false;
                    pnlFormulario.Visible = true;
                    litTituloFormulario.Text = "✏️ Editar Mascota: " + mascota.mas_Nombre;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error CargarMascotaParaEditar: " + ex.Message);
                string script = $"Swal.fire({{ title: 'Error', text: 'Error al cargar mascota: {ex.Message.Replace("'", "")}', icon: 'error', confirmButtonColor: '#0D9488' }});";
                ScriptManager.RegisterStartupScript(this, GetType(), "swal-load-err", script, true);
            }
        }

        private void LimpiarFormulario()
        {
            hfIdMascota.Value = "";
            hfFotoUrl1.Value = "";
            hfFotoUrl2.Value = "";
            hfFotoUrl3.Value = "";
            txtNombre.Text = "";
            txtEdad.Text = "";

            // Reset dropdowns
            if (ddlEspecie.Items.Count > 0)
                ddlEspecie.SelectedIndex = 0;
            ddlRaza.Items.Clear();
            ddlRaza.Items.Insert(0, new ListItem("Seleccione Especie primero", ""));

            if (ddlSexo.Items.Count > 0)
                ddlSexo.SelectedIndex = 0;
            if (ddlTamano.Items.Count > 0)
                ddlTamano.SelectedIndex = 0;

            txtColor.Text = "";
            txtDescripcion.Text = "";
            chkVacunado.Checked = false;
            chkEsterilizado.Checked = false;
            chkDesparasitado.Checked = false;

            // Limpiar previews de fotos
            imgPreview1.Visible = false;
            imgPreview2.Visible = false;
            imgPreview3.Visible = false;
        }

        /// <summary>
        /// Guarda las fotos de la mascota
        /// </summary>
        private void GuardarFotosMascota(DataClasses1DataContext db, int idMascota, bool esEdicion)
        {
            try
            {
                var fileUploads = new[] { fuFoto1, fuFoto2, fuFoto3 };
                var esPrincipal = new[] { true, false, false };
                string folderPath = Server.MapPath("~/Images/Mascotas/");

                // Crear directorio si no existe
                if (!System.IO.Directory.Exists(folderPath))
                    System.IO.Directory.CreateDirectory(folderPath);

                for (int i = 0; i < fileUploads.Length; i++)
                {
                    if (fileUploads[i].HasFile)
                    {
                        try
                        {
                            string fileName = Guid.NewGuid().ToString() + System.IO.Path.GetExtension(fileUploads[i].FileName);
                            string fullPath = System.IO.Path.Combine(folderPath, fileName);
                            fileUploads[i].SaveAs(fullPath);

                            string fotoUrl = "/Images/Mascotas/" + fileName;

                            // Si es edición y es la foto principal, actualizar la existente
                            if (esEdicion && esPrincipal[i])
                            {
                                var fotoExistente = db.tbl_FotosMascotas
                                    .FirstOrDefault(f => f.fot_IdMascota == idMascota && f.fot_EsPrincipal == true);

                                if (fotoExistente != null)
                                {
                                    fotoExistente.fot_Url = fotoUrl;
                                }
                                else
                                {
                                    db.tbl_FotosMascotas.InsertOnSubmit(new tbl_FotosMascotas
                                    {
                                        fot_IdMascota = idMascota,
                                        fot_Url = fotoUrl,
                                        fot_EsPrincipal = true
                                    });
                                }
                            }
                            else
                            {
                                // Agregar nueva foto
                                db.tbl_FotosMascotas.InsertOnSubmit(new tbl_FotosMascotas
                                {
                                    fot_IdMascota = idMascota,
                                    fot_Url = fotoUrl,
                                    fot_EsPrincipal = esPrincipal[i]
                                });
                            }
                        }
                        catch (Exception ex)
                        {
                            System.Diagnostics.Debug.WriteLine($"Error subiendo foto {i + 1}: {ex.Message}");
                        }
                    }
                }

                db.SubmitChanges();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en GuardarFotosMascota: " + ex.Message);
            }
        }
    }
}
