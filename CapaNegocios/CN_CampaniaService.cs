using CapaDatos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocios
{
    public class CN_CampaniaService
    {
        public List<tbl_Campanias> ObtenerCampaniasPorRefugio(int idRefugio)
        {
            using (DataClasses1DataContext db = new DataClasses1DataContext())
            {
                return db.tbl_Campanias
                    .Where(c => c.cam_IdRefugio == idRefugio && c.cam_Estado != "Eliminada")
                    .OrderByDescending(c => c.cam_FechaInicio)
                    .ToList();
            }
        }

        public tbl_Campanias ObtenerCampaniaPorId(int idCampania)
        {
            using (DataClasses1DataContext db = new DataClasses1DataContext())
            {
                return db.tbl_Campanias.FirstOrDefault(c => c.cam_IdCampania == idCampania);
            }
        }

        public bool RegistrarCampania(tbl_Campanias campania)
        {
            try
            {
                using (DataClasses1DataContext db = new DataClasses1DataContext())
                {
                    campania.cam_FechaCreacion = DateTime.Now;
                    if(string.IsNullOrEmpty(campania.cam_Estado))
                        campania.cam_Estado = "Activa";

                    db.tbl_Campanias.InsertOnSubmit(campania);
                    db.SubmitChanges();
                    return true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error Registrar Campania: " + ex.Message);
                return false;
            }
        }

        public bool ActualizarCampania(tbl_Campanias campaniaEditada)
        {
            try
            {
                using (DataClasses1DataContext db = new DataClasses1DataContext())
                {
                    var campania = db.tbl_Campanias.FirstOrDefault(c => c.cam_IdCampania == campaniaEditada.cam_IdCampania);
                    if (campania != null)
                    {
                        campania.cam_Titulo = campaniaEditada.cam_Titulo;
                        campania.cam_Descripcion = campaniaEditada.cam_Descripcion;
                        campania.cam_FechaInicio = campaniaEditada.cam_FechaInicio;
                        campania.cam_FechaFin = campaniaEditada.cam_FechaFin;
                        campania.cam_Ubicacion = campaniaEditada.cam_Ubicacion; // Si existe
                        campania.cam_Estado = campaniaEditada.cam_Estado;
                        
                        // Actualizar foto solo si no es nula (para no borrar la anterior si no se sube nueva)
                        if (!string.IsNullOrEmpty(campaniaEditada.cam_ImagenUrl))
                        {
                            campania.cam_ImagenUrl = campaniaEditada.cam_ImagenUrl;
                        }

                        db.SubmitChanges();
                        return true;
                    }
                    return false;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error Actualizar Campania: " + ex.Message);
                return false;
            }
        }

        public bool EliminarCampania(int idCampania)
        {
            try
            {
                using (DataClasses1DataContext db = new DataClasses1DataContext())
                {
                    var campania = db.tbl_Campanias.FirstOrDefault(c => c.cam_IdCampania == idCampania);
                    if (campania != null)
                    {
                        // Borrado lógico preferiblemente
                        campania.cam_Estado = "Eliminada";
                        // o fisico: db.tbl_Campanias.DeleteOnSubmit(campania);
                        
                        db.SubmitChanges();
                        return true;
                    }
                    return false;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error Eliminar Campania: " + ex.Message);
                return false;
            }
        }
    }
}
