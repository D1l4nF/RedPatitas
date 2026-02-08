using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CapaDatos;

namespace RedPatitas.Admin
{
    public partial class Notificaciones : System.Web.UI.Page
    {
        // Lista estática para simular almacenamiento de notificaciones
        // En producción, deberías crear una tabla tbl_Notificaciones en la BD
        private static List<NotificacionDTO> _notificaciones = new List<NotificacionDTO>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarNotificaciones();
            }
        }

        protected void btnNuevaNotificacion_Click(object sender, EventArgs e)
        {
            pnlFormulario.Visible = true;
            LimpiarFormulario();
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            pnlFormulario.Visible = false;
            LimpiarFormulario();
        }

        protected void btnEnviar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtTitulo.Text) || string.IsNullOrEmpty(txtMensaje.Text))
            {
                lblMensaje.Text = "❌ Complete todos los campos";
                lblMensaje.ForeColor = System.Drawing.Color.Red;
                lblMensaje.Visible = true;
                return;
            }

            try
            {
                // Crear la notificación
                var notificacion = new NotificacionDTO
                {
                    Fecha = DateTime.Now,
                    Tipo = ddlTipo.SelectedValue,
                    Titulo = txtTitulo.Text.Trim(),
                    Mensaje = txtMensaje.Text.Trim().Length > 100 ? txtMensaje.Text.Trim().Substring(0, 100) + "..." : txtMensaje.Text.Trim(),
                    Destinatarios = ddlDestinatarios.SelectedItem.Text,
                    EnviadoPor = "Admin"
                };

                // Agregarla a la lista (en producción, guardarla en BD)
                _notificaciones.Insert(0, notificacion);

                // Registrar en auditoría
                RegistrarAuditoria(notificacion);

                lblMensaje.Text = "✓ Notificación enviada correctamente";
                lblMensaje.ForeColor = System.Drawing.Color.Green;
                lblMensaje.Visible = true;

                LimpiarFormulario();
                CargarNotificaciones();
            }
            catch (Exception ex)
            {
                lblMensaje.Text = "❌ Error: " + ex.Message;
                lblMensaje.ForeColor = System.Drawing.Color.Red;
                lblMensaje.Visible = true;
            }
        }

        private void RegistrarAuditoria(NotificacionDTO notificacion)
        {
            try
            {
                using (var db = new DataClasses1DataContext())
                {
                    var auditoria = new tbl_Auditoria
                    {
                        aud_Accion = "NOTIFICACION",
                        aud_Tabla = "Notificaciones",
                        aud_Fecha = DateTime.Now,
                        aud_DireccionIP = Request.UserHostAddress,
                        aud_ValorNuevo = $"{notificacion.Tipo}: {notificacion.Titulo}"
                    };

                    // Intentar obtener el usuario actual de la sesión
                    if (Session["UsuarioId"] != null)
                    {
                        auditoria.aud_IdUsuario = Convert.ToInt32(Session["UsuarioId"]);
                    }

                    db.tbl_Auditoria.InsertOnSubmit(auditoria);
                    db.SubmitChanges();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en auditoría: " + ex.Message);
            }
        }

        private void CargarNotificaciones()
        {
            if (_notificaciones.Count > 0)
            {
                rptNotificaciones.DataSource = _notificaciones.Take(20);
                rptNotificaciones.DataBind();
                pnlSinNotificaciones.Visible = false;
            }
            else
            {
                pnlSinNotificaciones.Visible = true;
            }
        }

        private void LimpiarFormulario()
        {
            txtTitulo.Text = "";
            txtMensaje.Text = "";
            ddlTipo.SelectedIndex = 0;
            ddlDestinatarios.SelectedIndex = 0;
            lblMensaje.Visible = false;
        }

        protected string GetTipoBadgeClass(string tipo)
        {
            switch (tipo)
            {
                case "info": return "";
                case "alerta": return "pending";
                case "urgente": return "inactive";
                case "mantenimiento": return "pending";
                default: return "";
            }
        }

        protected string GetTipoIcono(string tipo)
        {
            switch (tipo)
            {
                case "info": return "ℹ️ Info";
                case "alerta": return "⚠️ Alerta";
                case "urgente": return "🚨 Urgente";
                case "mantenimiento": return "🔧 Mant.";
                default: return tipo;
            }
        }
    }

    public class NotificacionDTO
    {
        public DateTime Fecha { get; set; }
        public string Tipo { get; set; }
        public string Titulo { get; set; }
        public string Mensaje { get; set; }
        public string Destinatarios { get; set; }
        public string EnviadoPor { get; set; }
    }
}