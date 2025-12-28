using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocios
{
    public class CN_LoginResultado
    {
        public bool Exito { get; set; }
        public string Mensaje { get; set; }
        public int? UsuarioId { get; set; }
        public string NombreUsuario { get; set; }
        public int? RolId { get; set; }
        public string Correo { get; set; }
        public int? RefugioId { get; set; }
        public string FotoUrl { get; set; }
        public bool? Ref_Verificado { get; set; }
    }
}
