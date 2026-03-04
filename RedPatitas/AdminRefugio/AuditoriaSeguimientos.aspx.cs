using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaNegocios;

namespace RedPatitas.AdminRefugio
{
    public partial class AuditoriaSeguimientos : System.Web.UI.Page
    {
        private CN_SeguimientoService seguimientoService = new CN_SeguimientoService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Validación de Refugio Login
                if (Session["UsuarioId"] == null || Session["RolId"]?.ToString() != "2")
                {
                    Response.Redirect("../Login/Login.aspx");
                    return;
                }

                CargarBandeja();
            }
        }

        private void CargarBandeja()
        {
            try
            {
                // 1. Obtener de qué refugio es dueño el sesión actual
                // Asumimos que el ID del Refugio está en Session, si no, lo cargamos del Context
                // Para este ejemplo, requerimos la variable idRefugio (Por defecto pondremos 1 si no está en session ppara debugueo inicial)
                int idRefugioLogeado = Session["RefugioId"] != null ? Convert.ToInt32(Session["RefugioId"]) : 1;

                // 2. Extraer los datos enviados pero NO revisados desde la DB
                dynamic auditorias = seguimientoService.ObtenerAuditoriasPendientesRefugio(idRefugioLogeado);

                // Convertirlo estáticamente a enumerable de LINQ para conocer la longitud y bindear
                var conteoLista = ((IEnumerable<object>)auditorias).Cast<object>().ToList();

                if (conteoLista.Count > 0)
                {
                    gvBandejaSeguimientos.DataSource = conteoLista;
                    gvBandejaSeguimientos.DataBind();
                    
                    gvBandejaSeguimientos.Visible = true;
                    divVacioInbox.Visible = false;
                }
                else
                {
                    // Bandeja Vacía / "InBox Zero"
                    gvBandejaSeguimientos.Visible = false;
                    divVacioInbox.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error al sincronizar con el Refugio Matriz: " + ex.Message + "');</script>");
            }
        }
    }
}
