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
            catch(Exception ex) 
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
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]); // Asumimos que está login
                
                CN_MascotaService service = new CN_MascotaService();
                
                // Obtener IdRaza seleccionado
                int idRaza = 0;
                int.TryParse(ddlRaza.SelectedValue, out idRaza);

                if(idRaza == 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Por favor seleccione una raza');", true);
                    return;
                }

                // Creación del objeto tbl_Mascotas
                tbl_Mascotas mascota = new tbl_Mascotas
                {
                    mas_IdRefugio = idRefugio,
                    mas_IdUsuarioRegistro = idUsuario,
                    mas_Nombre = txtNombre.Text.Trim(),
                    mas_Edad = int.TryParse(txtEdad.Text, out int edad) ? (int?)edad : null,
                    mas_EdadAproximada = "N/A", // Podríamos calcularlo
                    mas_Sexo = Convert.ToChar(ddlSexo.SelectedValue), // 'M' o 'F'
                    mas_Tamano = ddlTamano.SelectedValue,
                    mas_Color = txtColor.Text.Trim(),
                    mas_Descripcion = txtDescripcion.Text,
                    mas_Vacunado = chkVacunado.Checked,
                    mas_Esterilizado = chkEsterilizado.Checked,
                    mas_Desparasitado = chkDesparasitado.Checked,
                    mas_EstadoAdopcion = "Disponible",
                    mas_IdRaza = idRaza
                };

                int nuevoId = service.RegistrarMascota(mascota);

                if (nuevoId > 0)
                {
                    // Guardar Foto si existe
                    string fotoUrl = "";
                    if (fuFoto.HasFile)
                    {
                        try 
                        {
                            string fileName = Guid.NewGuid().ToString() + System.IO.Path.GetExtension(fuFoto.FileName);
                            string folderPath = Server.MapPath("~/Images/Mascotas/");
                            
                            // Crear directorio si no existe
                            if (!System.IO.Directory.Exists(folderPath))
                                System.IO.Directory.CreateDirectory(folderPath);
                                
                            string fullPath = System.IO.Path.Combine(folderPath, fileName);
                            fuFoto.SaveAs(fullPath);
                            
                            fotoUrl = "/Images/Mascotas/" + fileName;
                            service.AgregarFotoMascota(nuevoId, fotoUrl, true);
                        }
                        catch(Exception exPhoto)
                        {
                             System.Diagnostics.Debug.WriteLine("Error subiendo foto: " + exPhoto.Message);
                        }
                    }

                    // Éxito
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Mascota registrada correctamente');", true);
                    pnlFormulario.Visible = false;
                    pnlLista.Visible = true;
                    CargarMascotas();
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Error al registrar mascota');", true);
                }
            }
            catch (Exception ex)
            {
                 System.Diagnostics.Debug.WriteLine("Error Guardar: " + ex.Message);
            }
        }

        protected void rptMascotas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Eliminar")
            {
                int idMascota = Convert.ToInt32(e.CommandArgument);
                CN_MascotaService service = new CN_MascotaService();
                if (service.EliminarMascota(idMascota))
                {
                    CargarMascotas();
                }
            }
            else if (e.CommandName == "Editar")
            {
                // Lógica para cargar datos y mostrar formulario
                // Para MVP simple, solo implementamos Crear y Eliminar primero.
                // Editar requeriría cargar datos en los textos.
            }
        }
        
        private void LimpiarFormulario()
        {
            txtNombre.Text = "";
            txtEdad.Text = "";
            
            // Reset dropdowns
            ddlEspecie.SelectedIndex = 0;
            ddlRaza.Items.Clear();
            ddlRaza.Items.Insert(0, new ListItem("Seleccione Especie primero", ""));
            
            txtColor.Text = "";
            txtDescripcion.Text = "";
            // txtFotoUrl.Text = ""; // Removed
            chkVacunado.Checked = false;
            chkEsterilizado.Checked = false;
            chkDesparasitado.Checked = false;
            hfIdMascota.Value = "";
        }
    }
}
