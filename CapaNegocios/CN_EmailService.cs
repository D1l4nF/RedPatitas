using System;
using System.Net;
using System.Net.Mail;

namespace CapaNegocios
{
    public class CN_EmailService
    {
        // Configuración SMTP - Gmail
        private readonly string _smtpServer = "smtp.gmail.com";
        private readonly int _smtpPort = 587;
        private readonly string _smtpUser = "dilanpr82@gmail.com";
        private readonly string _smtpPassword = "yiwvfzlgogwqmrnk";
        private readonly string _fromEmail = "dilanpr82@gmail.com";
        private readonly string _fromName = "RedPatitas";

        /// <summary>
        /// Envía un email de recuperación de contraseña
        /// </summary>
        public bool EnviarEmailRecuperacion(string emailDestino, string token, string urlBase)
        {
            try
            {
                string urlRecuperacion = $"{urlBase}/Login/CambiarContrasena.aspx?token={token}";

                string asunto = "Recuperar Contraseña - RedPatitas";
                string cuerpoHtml = GenerarPlantillaEmail(urlRecuperacion);

                return EnviarEmail(emailDestino, asunto, cuerpoHtml);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error enviando email: {ex.Message}");
                return false;
            }
        }

        /// <summary>
        /// Envía un email genérico
        /// </summary>
        public bool EnviarEmail(string destinatario, string asunto, string cuerpoHtml)
        {
            try
            {
                using (var mensaje = new MailMessage())
                {
                    mensaje.From = new MailAddress(_fromEmail, _fromName);
                    mensaje.To.Add(destinatario);
                    mensaje.Subject = asunto;
                    mensaje.Body = cuerpoHtml;
                    mensaje.IsBodyHtml = true;

                    using (var smtp = new SmtpClient(_smtpServer, _smtpPort))
                    {
                        smtp.EnableSsl = true;
                        smtp.UseDefaultCredentials = false;
                        smtp.Credentials = new NetworkCredential(_smtpUser, _smtpPassword);
                        smtp.DeliveryMethod = SmtpDeliveryMethod.Network;

                        smtp.Send(mensaje);
                    }
                }

                return true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error SMTP: {ex.Message}");
                return false;
            }
        }

        /// <summary>
        /// Genera la plantilla HTML del email de recuperación
        /// </summary>
        private string GenerarPlantillaEmail(string urlRecuperacion)
        {
            return $@"
<!DOCTYPE html>
<html>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
</head>
<body style='margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f5f5f5;'>
    <table width='100%' cellpadding='0' cellspacing='0' style='background-color: #f5f5f5; padding: 40px 20px;'>
        <tr>
            <td align='center'>
                <table width='600' cellpadding='0' cellspacing='0' style='background-color: #ffffff; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);'>
                    <!-- Header -->
                    <tr>
                        <td style='background: linear-gradient(135deg, #FF8C42 0%, #FF6B35 100%); padding: 30px; border-radius: 12px 12px 0 0; text-align: center;'>
                            <h1 style='color: #ffffff; margin: 0; font-size: 28px;'>🐾 RedPatitas</h1>
                        </td>
                    </tr>
                    <!-- Content -->
                    <tr>
                        <td style='padding: 40px 30px;'>
                            <h2 style='color: #333333; margin: 0 0 20px 0; font-size: 24px;'>Recuperar Contraseña</h2>
                            <p style='color: #666666; font-size: 16px; line-height: 1.6; margin: 0 0 20px 0;'>
                                Hemos recibido una solicitud para restablecer la contraseña de tu cuenta en RedPatitas.
                            </p>
                            <p style='color: #666666; font-size: 16px; line-height: 1.6; margin: 0 0 30px 0;'>
                                Haz clic en el siguiente botón para crear una nueva contraseña:
                            </p>
                            <!-- Button -->
                            <table width='100%' cellpadding='0' cellspacing='0'>
                                <tr>
                                    <td align='center'>
                                        <a href='{urlRecuperacion}' 
                                           style='display: inline-block; background: linear-gradient(135deg, #FF8C42 0%, #FF6B35 100%); 
                                                  color: #ffffff; text-decoration: none; padding: 16px 40px; 
                                                  border-radius: 8px; font-size: 16px; font-weight: bold;'>
                                            Cambiar Contraseña
                                        </a>
                                    </td>
                                </tr>
                            </table>
                            <p style='color: #999999; font-size: 14px; line-height: 1.6; margin: 30px 0 0 0;'>
                                Este enlace expirará en <strong>24 horas</strong>.
                            </p>
                            <p style='color: #999999; font-size: 14px; line-height: 1.6; margin: 10px 0 0 0;'>
                                Si no solicitaste este cambio, puedes ignorar este mensaje.
                            </p>
                        </td>
                    </tr>
                    <!-- Footer -->
                    <tr>
                        <td style='background-color: #f9f9f9; padding: 20px 30px; border-radius: 0 0 12px 12px; text-align: center;'>
                            <p style='color: #999999; font-size: 12px; margin: 0;'>
                                © {DateTime.Now.Year} RedPatitas - Plataforma de Adopción de Mascotas
                            </p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>";
        }
    }
}
