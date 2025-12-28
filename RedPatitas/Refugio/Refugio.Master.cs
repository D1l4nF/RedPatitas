using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RedPatitas.Refugio
{
    public partial class Refugio : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            /*if (Session["UsuarioId"] == null || Session["RolId"] == null)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }
            int rolId = Convert.ToInt32(Session["RolId"]);
            if (rolId != 3)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }*/
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