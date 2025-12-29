using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RedPatitas.Adoptante
{
    public partial class MascotasDisponibles : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var mascotas = new[]
                {
            new { Nombre="Max", Especie="Perro", Ubicacion="Quito", Estado="Disponible" },
            new { Nombre="Mia", Especie="Gato", Ubicacion="Quito", Estado="Disponible" }
        };

                rptMascotas.DataSource = mascotas;
                rptMascotas.DataBind();
            }
        }

    }
}