using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaDatos;
using CapaNegocios;

namespace RedPatitas.Adoptante
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Seguridad básica: Si no hay usuario, mandar al login
                if (Session["UsuarioId"] == null)
                {
                    Response.Redirect("~/Login/Login.aspx");
                    return;
                }

                CargarDatosUsuario();
                CargarEstadisticas();
                CargarMascotasRecomendadas();
            }
        }

        private void CargarDatosUsuario()
        {
            try
            {
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);

                using (DataClasses1DataContext dc = new DataClasses1DataContext())
                {
                    var usuario = dc.tbl_Usuarios.FirstOrDefault(u => u.usu_IdUsuario == idUsuario);

                    if (usuario != null)
                    {
                        // Ponemos solo el primer nombre para que sea más personal
                        string primerNombre = usuario.usu_Nombre.Split(' ')[0];
                        litNombreUsuario.Text = primerNombre;
                    }
                }
            }
            catch (Exception)
            {
                litNombreUsuario.Text = "Amigo";
            }
        }

        /// <summary>
        /// Carga las estadísticas del usuario (favoritos y solicitudes)
        /// </summary>
        private void CargarEstadisticas()
        {
            try
            {
                int idUsuario = Convert.ToInt32(Session["UsuarioId"]);

                using (var db = new DataClasses1DataContext())
                {
                    // Contar favoritos
                    int totalFavoritos = db.tbl_Favoritos.Count(f => f.fav_IdUsuario == idUsuario);
                    litFavoritos.Text = totalFavoritos.ToString();

                    // Contar solicitudes de adopción
                    int totalSolicitudes = db.tbl_SolicitudesAdopcion.Count(s => s.sol_IdUsuario == idUsuario);
                    litSolicitudes.Text = totalSolicitudes.ToString();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar estadísticas: " + ex.Message);
                litFavoritos.Text = "0";
                litSolicitudes.Text = "0";
            }
        }

        /// <summary>
        /// Carga las mascotas recomendadas (últimas 5 disponibles)
        /// </summary>
        private void CargarMascotasRecomendadas()
        {
            try
            {
                var servicio = new CN_MascotaService();
                var mascotas = servicio.ObtenerMascotasDisponibles();

                if (mascotas != null && mascotas.Count > 0)
                {
                    // Tomar solo las 5 más recientes
                    var recomendadas = mascotas
                        .OrderByDescending(m => m.FechaRegistro)
                        .Take(5)
                        .ToList();

                    rptMascotas.DataSource = recomendadas;
                    rptMascotas.DataBind();

                    pnlMascotas.Visible = true;
                    pnlSinMascotas.Visible = false;
                }
                else
                {
                    pnlMascotas.Visible = false;
                    pnlSinMascotas.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar mascotas: " + ex.Message);
                pnlMascotas.Visible = false;
                pnlSinMascotas.Visible = true;
            }
        }
    }
}