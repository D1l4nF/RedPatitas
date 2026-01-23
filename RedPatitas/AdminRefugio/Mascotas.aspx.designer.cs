//------------------------------------------------------------------------------
// <generado automáticamente>
//     Este código fue generado por una herramienta.
//
//     Los cambios en este archivo podrían causar un comportamiento incorrecto y se perderán si
//     se vuelve a generar el código. 
// </generado automáticamente>
//------------------------------------------------------------------------------

namespace RedPatitas.AdminRefugio
{


    public partial class Mascotas
    {

        /// <summary>
        /// Control pnlLista.
        /// </summary>
        /// <remarks>
        /// Campo generado automáticamente.
        /// Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        /// </remarks>
        protected global::System.Web.UI.WebControls.Panel pnlLista;

        /// <summary>
        /// Control btnNuevaMascota.
        /// </summary>
        /// <remarks>
        /// Campo generado automáticamente.
        /// Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        /// </remarks>
        protected global::System.Web.UI.WebControls.Button btnNuevaMascota;

        /// <summary>
        /// Control rptMascotas.
        /// </summary>
        /// <remarks>
        /// Campo generado automáticamente.
        /// Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        /// </remarks>
        protected global::System.Web.UI.WebControls.Repeater rptMascotas;

        /// <summary>
        /// Control pnlFormulario.
        /// </summary>
        /// <remarks>
        /// Campo generado automáticamente.
        /// Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        /// </remarks>
        protected global::System.Web.UI.WebControls.Panel pnlFormulario;

        /// <summary>
        /// Control litTituloFormulario.
        /// </summary>
        /// <remarks>
        /// Campo generado automáticamente.
        /// Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        /// </remarks>
        protected global::System.Web.UI.WebControls.Literal litTituloFormulario;

        /// <summary>
        /// Control btnCancelar.
        /// </summary>
        /// <remarks>
        /// Campo generado automáticamente.
        /// Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        /// </remarks>
        protected global::System.Web.UI.WebControls.Button btnCancelar;

        /// <summary>
        /// Control hfIdMascota.
        /// </summary>
        /// <remarks>
        /// Campo generado automáticamente.
        /// Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        /// </remarks>
        protected global::System.Web.UI.WebControls.HiddenField hfIdMascota;

        /// <summary>
        /// Control txtNombre.
        /// </summary>
        /// <remarks>
        /// Campo generado automáticamente.
        /// Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        /// </remarks>
        protected global::System.Web.UI.WebControls.TextBox txtNombre;

        /// <summary>
        /// Control rfvNombre.
        /// </summary>
        /// <remarks>
        /// Campo generado automáticamente.
        /// Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        /// </remarks>
        protected global::System.Web.UI.WebControls.RequiredFieldValidator rfvNombre;

        /// <summary>
        /// Control ddlEspecie.
        /// </summary>
        /// <remarks>
        /// Campo generado automáticamente.
        /// Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        /// </remarks>
        protected global::System.Web.UI.WebControls.DropDownList ddlEspecie;

        /// <summary>
        /// Control ddlRaza.
        /// </summary>
        /// <remarks>
        /// Campo generado automáticamente.
        /// Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        /// </remarks>
        protected global::System.Web.UI.WebControls.DropDownList ddlRaza;

        /// <summary>
        /// Control txtEdad.
        /// </summary>
        /// <remarks>
        /// Campo generado automáticamente.
        /// Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        /// </remarks>
        protected global::System.Web.UI.WebControls.TextBox txtEdad;

        /// <summary>
        /// Control ddlSexo.
        /// </summary>
        /// <remarks>
        /// Campo generado automáticamente.
        /// Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        /// </remarks>
        protected global::System.Web.UI.WebControls.DropDownList ddlSexo;

        /// <summary>
        /// Control ddlTamano.
        /// </summary>
        /// <remarks>
        /// Campo generado automáticamente.
        /// Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        /// </remarks>
        protected global::System.Web.UI.WebControls.DropDownList ddlTamano;

        /// <summary>
        /// Control txtColor.
        /// </summary>
        /// <remarks>
        /// Campo generado automáticamente.
        /// Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        /// </remarks>
        protected global::System.Web.UI.WebControls.TextBox txtColor;
        
        // Foto 1 - Principal
        protected global::System.Web.UI.HtmlControls.HtmlGenericControl previewFoto1;
        protected global::System.Web.UI.WebControls.Image imgPreview1;
        protected global::System.Web.UI.WebControls.FileUpload fuFoto1;
        protected global::System.Web.UI.WebControls.HiddenField hfFotoUrl1;
        
        // Foto 2
        protected global::System.Web.UI.HtmlControls.HtmlGenericControl previewFoto2;
        protected global::System.Web.UI.WebControls.Image imgPreview2;
        protected global::System.Web.UI.WebControls.FileUpload fuFoto2;
        protected global::System.Web.UI.WebControls.HiddenField hfFotoUrl2;
        
        // Foto 3
        protected global::System.Web.UI.HtmlControls.HtmlGenericControl previewFoto3;
        protected global::System.Web.UI.WebControls.Image imgPreview3;
        protected global::System.Web.UI.WebControls.FileUpload fuFoto3;
        protected global::System.Web.UI.WebControls.HiddenField hfFotoUrl3;

        protected global::System.Web.UI.WebControls.TextBox txtDescripcion;
        protected global::System.Web.UI.WebControls.CheckBox chkVacunado;
        protected global::System.Web.UI.WebControls.CheckBox chkEsterilizado;
        protected global::System.Web.UI.WebControls.CheckBox chkDesparasitado;
        protected global::System.Web.UI.WebControls.Button btnGuardar;
    }
}
