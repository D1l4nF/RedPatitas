using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocios
{
    public class CN_RegistroResultado
    {
        public bool Exito { get; set; }
        public string Mensaje { get; set; }
        public int? UsuarioId { get; set; }
    }
}
