using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RedPatitas.AdminRefugio
{
    public partial class AdminRefugio : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            /*if (Session["UsuarioId"] == null || Session["RolId"] == null)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }
            int rolId = Convert.ToInt32(Session["RolId"]);
            if (rolId != 2)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }*/
            if (Session["Ref_Verificado"] != null)
            {
                bool? verificado = (bool?)Session["Ref_Verificado"];
                pnlVerificacion.Visible = verificado == false;
            }
            if (pnlVerificacion.Visible)
            {
                lnkMascotas.Enabled = false;
                lnkMascotas.CssClass = "nav-link disabled";
                lnkMascotas.ToolTip = "Disponible después de la verificación";
                lnkSolicitudes.Enabled = false;
                lnkSolicitudes.CssClass = "nav-link disabled";
                lnkSolicitudes.ToolTip = "Disponible después de la verificación";
                lnkCampanias.Enabled = false;
                lnkCampanias.CssClass = "nav-link disabled";
                lnkCampanias.ToolTip = "Disponible después de la verificación";
                lnkUsuarios.Enabled = false;
                lnkUsuarios.CssClass = "nav-link disabled";
                lnkUsuarios.ToolTip = "Disponible después de la verificación";
            }
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Session.RemoveAll();
            Response.Redirect("~/Login/Login.aspx");
        }
    }
}