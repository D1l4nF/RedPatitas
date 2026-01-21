using System;
using System.Linq;
using CapaDatos;
using CapaNegocios;

namespace RedPatitas.Adoptante
{
    public partial class Solicitudes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificar sesión
            if (Session["UsuarioId"] == null)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CargarSolicitudes();
            }
        }

        /// <summary>
        /// Carga las solicitudes del usuario
        /// </summary>
        private void CargarSolicitudes()
        {
            try
            {
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);

                using (var db = new DataClasses1DataContext())
                {
                    var solicitudes = db.tbl_SolicitudesAdopcion
                        .Where(s => s.sol_IdUsuario == idUsuario)
                        .OrderByDescending(s => s.sol_FechaSolicitud)
                        .ToList();

                    if (solicitudes.Count > 0)
                    {
                        rptSolicitudes.DataSource = solicitudes;
                        rptSolicitudes.DataBind();

                        // Contar por estado
                        litPendientes.Text = solicitudes.Count(s => 
                            s.sol_Estado == "Pendiente" || s.sol_Estado == "EnRevision").ToString();
                        litAprobadas.Text = solicitudes.Count(s => 
                            s.sol_Estado == "Aprobada").ToString();

                        pnlSolicitudes.Visible = true;
                        pnlVacio.Visible = false;
                    }
                    else
                    {
                        MostrarVacio();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar solicitudes: " + ex.Message);
                MostrarVacio();
            }
        }

        /// <summary>
        /// Muestra el estado vacío
        /// </summary>
        private void MostrarVacio()
        {
            pnlSolicitudes.Visible = false;
            pnlVacio.Visible = true;
            litPendientes.Text = "0";
            litAprobadas.Text = "0";
        }

        /// <summary>
        /// Obtiene el emoji para la especie
        /// </summary>
        protected string GetEmojiEspecie(string especie)
        {
            return CN_MascotaService.ObtenerEmojiEspecie(especie);
        }

        /// <summary>
        /// Obtiene la clase CSS para el estado
        /// </summary>
        protected string GetEstadoClass(string estado)
        {
            switch (estado?.ToLower())
            {
                case "pendiente": return "estado-pendiente";
                case "enrevision": return "estado-enrevision";
                case "aprobada": return "estado-aprobada";
                case "rechazada": return "estado-rechazada";
                default: return "estado-pendiente";
            }
        }

        /// <summary>
        /// Obtiene el texto legible para el estado
        /// </summary>
        protected string GetEstadoTexto(string estado)
        {
            switch (estado?.ToLower())
            {
                case "pendiente": return "⏳ Pendiente";
                case "enrevision": return "🔍 En Revisión";
                case "aprobada": return "✅ Aprobada";
                case "rechazada": return "❌ Rechazada";
                default: return estado;
            }
        }
    }
}
