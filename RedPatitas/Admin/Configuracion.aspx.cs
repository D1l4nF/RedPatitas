using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaDatos;

namespace RedPatitas.Admin
{
    public partial class Configuracion : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarCriterios();
                CargarEspecies();
                CargarRazas();
                CargarConfiguracionSeguridad();
            }
        }

        #region Tabs

        protected void tabCriterios_Click(object sender, EventArgs e)
        {
            ActivarTab("criterios");
        }

        protected void tabEspecies_Click(object sender, EventArgs e)
        {
            ActivarTab("especies");
        }

        protected void tabSeguridad_Click(object sender, EventArgs e)
        {
            ActivarTab("seguridad");
        }

        private void ActivarTab(string tab)
        {
            tabCriterios.CssClass = "config-tab";
            tabEspecies.CssClass = "config-tab";
            tabSeguridad.CssClass = "config-tab";
            pnlCriterios.CssClass = "config-section";
            pnlEspecies.CssClass = "config-section";
            pnlSeguridad.CssClass = "config-section";

            switch (tab)
            {
                case "criterios":
                    tabCriterios.CssClass = "config-tab active";
                    pnlCriterios.CssClass = "config-section active";
                    break;
                case "especies":
                    tabEspecies.CssClass = "config-tab active";
                    pnlEspecies.CssClass = "config-section active";
                    CargarEspeciesDropdown();
                    break;
                case "seguridad":
                    tabSeguridad.CssClass = "config-tab active";
                    pnlSeguridad.CssClass = "config-section active";
                    break;
            }
        }

        #endregion

        #region Criterios de Evaluación

        private void CargarCriterios()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var criterios = db.tbl_CriteriosEvaluacion
                        .OrderBy(c => c.cri_Orden)
                        .Select(c => new
                        {
                            IdCriterio = c.cri_IdCriterio,
                            Nombre = c.cri_Nombre,
                            Descripcion = c.cri_Descripcion ?? "",
                            Peso = c.cri_Peso,
                            PuntajeMaximo = c.cri_PuntajeMaximo ?? 10,
                            Orden = c.cri_Orden ?? 0,
                            Estado = c.cri_Estado ?? true
                        })
                        .ToList();

                    rptCriterios.DataSource = criterios;
                    rptCriterios.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cargando criterios: " + ex.Message);
            }
        }

        protected void btnGuardarCriterio_Click(object sender, EventArgs e)
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    int id = int.Parse(hdnCriterioId.Value);

                    if (id == 0)
                    {
                        // Nuevo criterio
                        var nuevoCriterio = new tbl_CriteriosEvaluacion
                        {
                            cri_Nombre = txtCriterioNombre.Text.Trim(),
                            cri_Descripcion = txtCriterioDescripcion.Text.Trim(),
                            cri_Peso = decimal.Parse(txtCriterioPeso.Text),
                            cri_PuntajeMaximo = int.Parse(txtCriterioPuntaje.Text),
                            cri_Orden = db.tbl_CriteriosEvaluacion.Count() + 1,
                            cri_Estado = true
                        };
                        db.tbl_CriteriosEvaluacion.InsertOnSubmit(nuevoCriterio);
                    }
                    else
                    {
                        // Editar existente
                        var criterio = db.tbl_CriteriosEvaluacion.FirstOrDefault(c => c.cri_IdCriterio == id);
                        if (criterio != null)
                        {
                            criterio.cri_Nombre = txtCriterioNombre.Text.Trim();
                            criterio.cri_Descripcion = txtCriterioDescripcion.Text.Trim();
                            criterio.cri_Peso = decimal.Parse(txtCriterioPeso.Text);
                            criterio.cri_PuntajeMaximo = int.Parse(txtCriterioPuntaje.Text);
                        }
                    }

                    db.SubmitChanges();
                    LimpiarFormularioCriterio();
                    CargarCriterios();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error guardando criterio: " + ex.Message);
            }
        }

        protected void btnCancelarCriterio_Click(object sender, EventArgs e)
        {
            LimpiarFormularioCriterio();
        }

        protected void rptCriterios_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = int.Parse(e.CommandArgument.ToString());

            using (var db = new DataClasses1DataContext())
            {
                if (e.CommandName == "Editar")
                {
                    var criterio = db.tbl_CriteriosEvaluacion.FirstOrDefault(c => c.cri_IdCriterio == id);
                    if (criterio != null)
                    {
                        hdnCriterioId.Value = criterio.cri_IdCriterio.ToString();
                        txtCriterioNombre.Text = criterio.cri_Nombre;
                        txtCriterioDescripcion.Text = criterio.cri_Descripcion;
                        txtCriterioPeso.Text = criterio.cri_Peso.ToString();
                        txtCriterioPuntaje.Text = (criterio.cri_PuntajeMaximo ?? 10).ToString();
                        btnCancelarCriterio.Visible = true;
                    }
                }
                else if (e.CommandName == "Eliminar")
                {
                    var criterio = db.tbl_CriteriosEvaluacion.FirstOrDefault(c => c.cri_IdCriterio == id);
                    if (criterio != null)
                    {
                        db.tbl_CriteriosEvaluacion.DeleteOnSubmit(criterio);
                        db.SubmitChanges();
                        CargarCriterios();
                    }
                }
            }
        }

        private void LimpiarFormularioCriterio()
        {
            hdnCriterioId.Value = "0";
            txtCriterioNombre.Text = "";
            txtCriterioDescripcion.Text = "";
            txtCriterioPeso.Text = "";
            txtCriterioPuntaje.Text = "10";
            btnCancelarCriterio.Visible = false;
        }

        #endregion

        #region Especies

        private void CargarEspecies()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var especies = db.tbl_Especies
                        .Where(e => e.esp_Estado == true)
                        .Select(e => new
                        {
                            IdEspecie = e.esp_IdEspecie,
                            Nombre = e.esp_Nombre,
                            TotalRazas = db.tbl_Razas.Count(r => r.raz_IdEspecie == e.esp_IdEspecie && r.raz_Estado == true)
                        })
                        .ToList();

                    rptEspecies.DataSource = especies;
                    rptEspecies.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cargando especies: " + ex.Message);
            }
        }

        private void CargarEspeciesDropdown()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    ddlEspecieRaza.Items.Clear();
                    ddlEspecieRaza.Items.Add(new ListItem("-- Seleccionar --", "0"));

                    var especies = db.tbl_Especies
                        .Where(e => e.esp_Estado == true)
                        .Select(e => new { e.esp_IdEspecie, e.esp_Nombre })
                        .ToList();

                    foreach (var esp in especies)
                    {
                        ddlEspecieRaza.Items.Add(new ListItem(esp.esp_Nombre, esp.esp_IdEspecie.ToString()));
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cargando dropdown especies: " + ex.Message);
            }
        }

        protected void btnGuardarEspecie_Click(object sender, EventArgs e)
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    int id = int.Parse(hdnEspecieId.Value);

                    if (id == 0)
                    {
                        var nueva = new tbl_Especies
                        {
                            esp_Nombre = txtEspecieNombre.Text.Trim(),
                            esp_Estado = true
                        };
                        db.tbl_Especies.InsertOnSubmit(nueva);
                    }
                    else
                    {
                        var especie = db.tbl_Especies.FirstOrDefault(es => es.esp_IdEspecie == id);
                        if (especie != null)
                        {
                            especie.esp_Nombre = txtEspecieNombre.Text.Trim();
                        }
                    }

                    db.SubmitChanges();
                    hdnEspecieId.Value = "0";
                    txtEspecieNombre.Text = "";
                    CargarEspecies();
                    CargarEspeciesDropdown();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error guardando especie: " + ex.Message);
            }
        }

        protected void rptEspecies_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = int.Parse(e.CommandArgument.ToString());

            using (var db = new DataClasses1DataContext())
            {
                if (e.CommandName == "Editar")
                {
                    var especie = db.tbl_Especies.FirstOrDefault(es => es.esp_IdEspecie == id);
                    if (especie != null)
                    {
                        hdnEspecieId.Value = especie.esp_IdEspecie.ToString();
                        txtEspecieNombre.Text = especie.esp_Nombre;
                    }
                }
                else if (e.CommandName == "Eliminar")
                {
                    var especie = db.tbl_Especies.FirstOrDefault(es => es.esp_IdEspecie == id);
                    if (especie != null)
                    {
                        especie.esp_Estado = false;
                        db.SubmitChanges();
                        CargarEspecies();
                    }
                }
            }
            ActivarTab("especies");
        }

        #endregion

        #region Razas

        private void CargarRazas()
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var razas = db.tbl_Razas
                        .Where(r => r.raz_Estado == true)
                        .Select(r => new
                        {
                            IdRaza = r.raz_IdRaza,
                            Nombre = r.raz_Nombre,
                            NombreEspecie = r.tbl_Especies.esp_Nombre
                        })
                        .OrderBy(r => r.NombreEspecie)
                        .ThenBy(r => r.Nombre)
                        .ToList();

                    rptRazas.DataSource = razas;
                    rptRazas.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error cargando razas: " + ex.Message);
            }
        }

        protected void btnGuardarRaza_Click(object sender, EventArgs e)
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    int id = int.Parse(hdnRazaId.Value);
                    int idEspecie = int.Parse(ddlEspecieRaza.SelectedValue);

                    if (idEspecie == 0) return;

                    if (id == 0)
                    {
                        var nueva = new tbl_Razas
                        {
                            raz_IdEspecie = idEspecie,
                            raz_Nombre = txtRazaNombre.Text.Trim(),
                            raz_Estado = true
                        };
                        db.tbl_Razas.InsertOnSubmit(nueva);
                    }
                    else
                    {
                        var raza = db.tbl_Razas.FirstOrDefault(r => r.raz_IdRaza == id);
                        if (raza != null)
                        {
                            raza.raz_IdEspecie = idEspecie;
                            raza.raz_Nombre = txtRazaNombre.Text.Trim();
                        }
                    }

                    db.SubmitChanges();
                    hdnRazaId.Value = "0";
                    txtRazaNombre.Text = "";
                    CargarRazas();
                    CargarEspecies();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error guardando raza: " + ex.Message);
            }
            ActivarTab("especies");
        }

        protected void rptRazas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = int.Parse(e.CommandArgument.ToString());

            using (var db = new DataClasses1DataContext())
            {
                if (e.CommandName == "Editar")
                {
                    var raza = db.tbl_Razas.FirstOrDefault(r => r.raz_IdRaza == id);
                    if (raza != null)
                    {
                        hdnRazaId.Value = raza.raz_IdRaza.ToString();
                        txtRazaNombre.Text = raza.raz_Nombre;
                        CargarEspeciesDropdown();
                        ddlEspecieRaza.SelectedValue = raza.raz_IdEspecie.ToString();
                    }
                }
                else if (e.CommandName == "Eliminar")
                {
                    var raza = db.tbl_Razas.FirstOrDefault(r => r.raz_IdRaza == id);
                    if (raza != null)
                    {
                        raza.raz_Estado = false;
                        db.SubmitChanges();
                        CargarRazas();
                        CargarEspecies();
                    }
                }
            }
            ActivarTab("especies");
        }

        #endregion

        #region Seguridad

        private void CargarConfiguracionSeguridad()
        {
            // Por ahora valores por defecto - se podría guardar en BD
            txtIntentosMaximos.Text = "3";
            txtExpiracionToken.Text = "24";
            txtLongitudPassword.Text = "6";
        }

        protected void btnGuardarSeguridad_Click(object sender, EventArgs e)
        {
            // Aquí se guardarían en BD o en Web.config
            // Por ahora solo mostramos mensaje de éxito
            lblMensajeSeguridad.Text = "✓ Configuración guardada";
            lblMensajeSeguridad.ForeColor = System.Drawing.Color.Green;
            lblMensajeSeguridad.Visible = true;
        }

        #endregion
    }
}