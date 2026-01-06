using System;
using System.Security.Cryptography;
using System.Text;

namespace CapaNegocios
{
    /// <summary>
    /// Servicio de criptografía para el manejo seguro de contraseñas
    /// Utiliza SHA256 con Salt para proteger las contraseñas
    /// </summary>
    public static class CN_CryptoService
    {
        private const int SALT_SIZE = 16; // 16 bytes = 32 caracteres hex

        /// <summary>
        /// Genera un salt aleatorio criptográficamente seguro
        /// </summary>
        public static string GenerarSalt()
        {
            byte[] saltBytes = new byte[SALT_SIZE];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(saltBytes);
            }
            return BitConverter.ToString(saltBytes).Replace("-", "").ToLower();
        }

        /// <summary>
        /// Crea un hash SHA256 de la contraseña con el salt proporcionado
        /// </summary>
        /// <param name="password">Contraseña en texto plano</param>
        /// <param name="salt">Salt a usar para el hash</param>
        /// <returns>Hash SHA256 de la contraseña</returns>
        public static string HashPassword(string password, string salt)
        {
            return ComputeSHA256(salt + password);
        }

        /// <summary>
        /// Verifica si una contraseña coincide con el hash almacenado
        /// </summary>
        /// <param name="password">Contraseña a verificar</param>
        /// <param name="storedHash">Hash almacenado en BD</param>
        /// <param name="salt">Salt almacenado en BD</param>
        /// <returns>True si la contraseña es correcta</returns>
        public static bool VerifyPassword(string password, string storedHash, string salt)
        {
            // Si no hay salt, comparar directamente (contraseñas antiguas sin hash)
            if (string.IsNullOrEmpty(salt))
            {
                return password == storedHash;
            }

            string computedHash = ComputeSHA256(salt + password);
            return storedHash == computedHash;
        }

        /// <summary>
        /// Calcula el hash SHA256 de un texto
        /// </summary>
        private static string ComputeSHA256(string input)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] inputBytes = Encoding.UTF8.GetBytes(input);
                byte[] hashBytes = sha256.ComputeHash(inputBytes);
                
                StringBuilder sb = new StringBuilder();
                foreach (byte b in hashBytes)
                {
                    sb.Append(b.ToString("x2"));
                }
                return sb.ToString();
            }
        }
    }
}
