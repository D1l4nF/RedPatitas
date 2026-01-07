using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RedPatitas.Public
{
    public partial class Reportar : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnPublicarReporte_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // Obtener el tipo de reporte
                string tipoReporte = rbPerdida.Checked ? "perdida" : "encontrada";
                
                // Aquí iría la lógica para guardar el reporte en la base de datos
                // Por ahora solo mostramos un mensaje de éxito
                
                lblMensaje.Text = "✅ ¡Tu reporte ha sido publicado exitosamente!";
                lblMensaje.CssClass = "mensaje-resultado mensaje-exito";
                lblMensaje.Visible = true;
            }
        }
    }
}