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
    public partial class Usuarios : System.Web.UI.Page
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
                CargarUsuarios();
            }
        }

        private void CargarUsuarios()
        {
            try
            {
                int idRefugio = Convert.ToInt32(Session["RefugioId"]);
                int idUsuarioActual = Convert.ToInt32(Session["UsuarioId"]);

                CN_UsuarioService service = new CN_UsuarioService();
                var usuarios = service.ObtenerUsuariosPorRefugio(idRefugio);
                
                // Opcional: Filtrar para no mostrarse a uno mismo si se desea, 
                // o mostrarse pero deshabilitar bloqueo.
                // Filtramos al usuario actual para evitar que se bloquee a sí mismo
                var listaFinal = usuarios.Where(u => u.usu_IdUsuario != idUsuarioActual).ToList();

                rptUsuarios.DataSource = listaFinal;
                rptUsuarios.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error CargarUsuarios: " + ex.Message);
            }
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            try
            {
                if(!Page.IsValid) return;

                int idRefugio = Convert.ToInt32(Session["RefugioId"]);
                CN_UsuarioService service = new CN_UsuarioService();

                tbl_Usuarios nuevo = new tbl_Usuarios
                {
                    usu_Nombre = txtNombre.Text.Trim(),
                    usu_Apellido = txtApellido.Text.Trim(),
                    usu_Email = txtEmail.Text.Trim(),
                    usu_Contrasena = txtPassword.Text, // El servicio lo hasheará
                    usu_IdRefugio = idRefugio
                };

                var resultado = service.RegistrarUsuarioStaff(nuevo);

                if (resultado.Exito)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Usuario registrado correctamente');", true);
                    LimpiarFormulario();
                    CargarUsuarios();
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('Error: {resultado.Mensaje}');", true);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error Registrar: " + ex.Message);
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Ocurrió un error inesperado');", true);
            }
        }

        protected void rptUsuarios_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int idUsuario = Convert.ToInt32(e.CommandArgument);
            CN_UsuarioService service = new CN_UsuarioService();

            if (e.CommandName == "Bloquear")
            {
                service.CambiarBloqueoUsuario(idUsuario, true);
                CargarUsuarios();
            }
            else if (e.CommandName == "Desbloquear")
            {
                service.CambiarBloqueoUsuario(idUsuario, false);
                CargarUsuarios();
            }
        }

        private void LimpiarFormulario()
        {
            txtNombre.Text = "";
            txtApellido.Text = "";
            txtEmail.Text = "";
            txtPassword.Text = "";
        }
    }
}
