using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaDatos;
using CapaNegocios;

namespace RedPatitas.AdminRefugio
{
    public partial class Campanias : System.Web.UI.Page
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
                CargarCampanias();
            }
        }

        private void CargarCampanias()
        {
            try
            {
                int idRefugio = Convert.ToInt32(Session["RefugioId"]);
                CN_CampaniaService service = new CN_CampaniaService();
                var campanias = service.ObtenerCampaniasPorRefugio(idRefugio);
                rptCampanias.DataSource = campanias;
                rptCampanias.DataBind();
                
                noData.Style["display"] = campanias.Count == 0 ? "block" : "none";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error CargarCampanias: " + ex.Message);
            }
        }

        protected void btnNuevaCampania_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
            pnlLista.Visible = false;
            pnlFormulario.Visible = true;
            litTituloFormulario.Text = "Registrar Nueva Campaña";
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
                CN_CampaniaService service = new CN_CampaniaService();

                // Manejo de imagen
                string imagenUrl = hfImagenUrl.Value;
                if (fuImagen.HasFile)
                {
                    try
                    {
                        string fileName = "camp_" + Guid.NewGuid().ToString() + System.IO.Path.GetExtension(fuImagen.FileName);
                        string folderPath = Server.MapPath("~/Images/Campanias/");

                        if (!System.IO.Directory.Exists(folderPath))
                            System.IO.Directory.CreateDirectory(folderPath);

                        string fullPath = System.IO.Path.Combine(folderPath, fileName);
                        fuImagen.SaveAs(fullPath);
                        imagenUrl = "/Images/Campanias/" + fileName;
                    }
                    catch (Exception exImg)
                    {
                        System.Diagnostics.Debug.WriteLine("Error subiendo imagen: " + exImg.Message);
                    }
                }

                if (string.IsNullOrEmpty(hfIdCampania.Value))
                {
                    // NUEVA CAMPAÑA
                    tbl_Campanias nueva = new tbl_Campanias
                    {
                        cam_IdRefugio = idRefugio,
                        cam_Titulo = txtTitulo.Text.Trim(),
                        cam_TipoCampania = ddlTipo.SelectedValue,
                        cam_Ubicacion = txtUbicacion.Text.Trim(),
                        cam_FechaInicio = DateTime.Parse(txtFechaInicio.Text),
                        cam_FechaFin = DateTime.Parse(txtFechaFin.Text),
                        cam_Descripcion = txtDescripcion.Text,
                        cam_Estado = ddlEstado.SelectedValue,
                        cam_ImagenUrl = imagenUrl
                    };

                    if (service.RegistrarCampania(nueva))
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Campaña creada correctamente');", true);
                        pnlFormulario.Visible = false;
                        pnlLista.Visible = true;
                        CargarCampanias();
                    }
                    else
                    {
                         ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Error al crear campaña');", true);
                    }
                }
                else
                {
                    // EDITAR CAMPAÑA
                    int idCampania = Convert.ToInt32(hfIdCampania.Value);
                    tbl_Campanias editada = new tbl_Campanias
                    {
                        cam_IdCampania = idCampania,
                        cam_Titulo = txtTitulo.Text.Trim(),
                        cam_TipoCampania = ddlTipo.SelectedValue,
                        cam_Ubicacion = txtUbicacion.Text.Trim(),
                        cam_FechaInicio = DateTime.Parse(txtFechaInicio.Text),
                        cam_FechaFin = DateTime.Parse(txtFechaFin.Text),
                        cam_Descripcion = txtDescripcion.Text,
                        cam_Estado = ddlEstado.SelectedValue,
                        cam_ImagenUrl = imagenUrl // Si vino vacía y no había nueva, el servicio la ignora si así lo programamos, pero aquí pasamos lo que tenemos
                    };
                    
                    if (service.ActualizarCampania(editada))
                    {
                         ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Campaña actualizada correctamente');", true);
                         pnlFormulario.Visible = false;
                         pnlLista.Visible = true;
                         CargarCampanias();
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Error al actualizar campaña');", true);
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error Guardar: " + ex.Message);
            }
        }

        protected void rptCampanias_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Eliminar")
            {
                int idCampania = Convert.ToInt32(e.CommandArgument);
                CN_CampaniaService service = new CN_CampaniaService();
                if (service.EliminarCampania(idCampania))
                {
                    CargarCampanias();
                }
            }
            else if (e.CommandName == "Editar")
            {
                int idCampania = Convert.ToInt32(e.CommandArgument);
                CargarDatosEdicion(idCampania);
            }
        }

        private void CargarDatosEdicion(int idCampania)
        {
            try
            {
                CN_CampaniaService service = new CN_CampaniaService();
                var c = service.ObtenerCampaniaPorId(idCampania);
                if (c != null)
                {
                    hfIdCampania.Value = c.cam_IdCampania.ToString();
                    txtTitulo.Text = c.cam_Titulo;
                    ddlTipo.SelectedValue = c.cam_TipoCampania;
                    txtUbicacion.Text = c.cam_Ubicacion;
                    
                    if(c.cam_FechaInicio.HasValue)
                        txtFechaInicio.Text = c.cam_FechaInicio.Value.ToString("yyyy-MM-dd");
                        
                    if(c.cam_FechaFin.HasValue)
                        txtFechaFin.Text = c.cam_FechaFin.Value.ToString("yyyy-MM-dd");
                        
                    txtDescripcion.Text = c.cam_Descripcion;
                    ddlEstado.SelectedValue = c.cam_Estado;
                    hfImagenUrl.Value = c.cam_ImagenUrl;
                    
                    litTituloFormulario.Text = "Editar Campaña";
                    pnlLista.Visible = false;
                    pnlFormulario.Visible = true;
                }
            }
            catch (Exception ex)
            {
                 System.Diagnostics.Debug.WriteLine("Error CargarDatosEdicion: " + ex.Message);
            }
        }

        private void LimpiarFormulario()
        {
            hfIdCampania.Value = "";
            txtTitulo.Text = "";
            ddlTipo.SelectedIndex = 0;
            txtUbicacion.Text = "";
            txtFechaInicio.Text = "";
            txtFechaFin.Text = "";
            txtDescripcion.Text = "";
            ddlEstado.SelectedIndex = 0;
            hfImagenUrl.Value = "";
        }
    }
}
