-- ============================================================
-- SCRIPT DE ACTUALIZACIÓN: MÓDULOS DE CERTIFICADOS Y NOTIFICACIONES
-- Fecha: 2026-03-18
-- ============================================================

USE RedPatitas;
GO

-- ============================================================
-- 1. TABLA: Certificados de Adopción
-- ============================================================

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='tbl_CertificadosAdopcion' AND xtype='U')
BEGIN
    CREATE TABLE tbl_CertificadosAdopcion (
        cer_IdCertificado INT PRIMARY KEY IDENTITY(1,1),
        cer_IdSolicitud INT NOT NULL FOREIGN KEY REFERENCES tbl_SolicitudesAdopcion(sol_IdSolicitud),
        cer_CodigoCertificado VARCHAR(50) NOT NULL UNIQUE,
        cer_FechaEmision DATETIME DEFAULT GETDATE(),
        -- Campos desnormalizados para inmutabilidad del certificado
        cer_NombreAdoptante VARCHAR(200) NOT NULL,
        cer_CedulaAdoptante VARCHAR(20),
        cer_NombreMascota VARCHAR(100) NOT NULL,
        cer_EspecieMascota VARCHAR(50),
        cer_RazaMascota VARCHAR(100),
        cer_NombreRefugio VARCHAR(150) NOT NULL,
        cer_Estado VARCHAR(20) DEFAULT 'Vigente' -- Vigente, Revocado
    );
    PRINT 'Tabla tbl_CertificadosAdopcion creada exitosamente.';
END
ELSE
BEGIN
    PRINT 'La tabla tbl_CertificadosAdopcion ya existe.';
END
GO

-- ============================================================
-- 2. PROCEDIMIENTO ALMACENADO: Generar Certificado
-- ============================================================

IF OBJECT_ID('sp_GenerarCertificadoAdopcion', 'P') IS NOT NULL
    DROP PROCEDURE sp_GenerarCertificadoAdopcion;
GO

CREATE PROCEDURE sp_GenerarCertificadoAdopcion
    @IdSolicitud INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validar que la solicitud existe y está aprobada
    IF NOT EXISTS (SELECT 1 FROM tbl_SolicitudesAdopcion WHERE sol_IdSolicitud = @IdSolicitud AND sol_Estado = 'Aprobada')
    BEGIN
        SELECT 0 AS Exito, 'La solicitud no existe o no se encuentra en estado Aprobada.' AS Mensaje;
        RETURN;
    END
    
    -- Validar que no exista ya un certificado para esta solicitud
    IF EXISTS (SELECT 1 FROM tbl_CertificadosAdopcion WHERE cer_IdSolicitud = @IdSolicitud)
    BEGIN
        SELECT 0 AS Exito, 'Ya existe un certificado emitido para esta adopción.' AS Mensaje;
        RETURN;
    END

    -- Variables para datos del certificado
    DECLARE @CodigoCertificado VARCHAR(50);
    DECLARE @AnioActual VARCHAR(4) = CAST(YEAR(GETDATE()) AS VARCHAR(4));
    DECLARE @SiguienteNumero INT;
    DECLARE @NombreAdoptante VARCHAR(200);
    DECLARE @CedulaAdoptante VARCHAR(20);
    DECLARE @NombreMascota VARCHAR(100);
    DECLARE @EspecieMascota VARCHAR(50) = 'No especificada';
    DECLARE @RazaMascota VARCHAR(100) = 'No especificada';
    DECLARE @NombreRefugio VARCHAR(150);

    -- Generar código secuencial RP-YYYY-NNNNN
    SELECT @SiguienteNumero = ISNULL(MAX(cer_IdCertificado), 0) + 1 FROM tbl_CertificadosAdopcion;
    SET @CodigoCertificado = 'RP-' + @AnioActual + '-' + RIGHT('00000' + CAST(@SiguienteNumero AS VARCHAR(5)), 5);

    -- Obtener datos desnormalizados
    SELECT 
        @NombreAdoptante = u.usu_Nombre + ' ' + ISNULL(u.usu_Apellido, ''),
        @CedulaAdoptante = u.usu_Cedula,
        @NombreMascota = m.mas_Nombre,
        @EspecieMascota = ISNULL(e.esp_Nombre, 'No especificada'),
        @RazaMascota = ISNULL(rz.raz_Nombre, 'No especificada'),
        @NombreRefugio = ref.ref_Nombre
    FROM tbl_SolicitudesAdopcion s
    INNER JOIN tbl_Usuarios u ON s.sol_IdUsuario = u.usu_IdUsuario
    INNER JOIN tbl_Mascotas m ON s.sol_IdMascota = m.mas_IdMascota
    INNER JOIN tbl_Refugios ref ON m.mas_IdRefugio = ref.ref_IdRefugio
    LEFT JOIN tbl_Razas rz ON m.mas_IdRaza = rz.raz_IdRaza
    LEFT JOIN tbl_Especies e ON rz.raz_IdEspecie = e.esp_IdEspecie
    WHERE s.sol_IdSolicitud = @IdSolicitud;

    -- Insertar el certificado
    INSERT INTO tbl_CertificadosAdopcion (
        cer_IdSolicitud, 
        cer_CodigoCertificado, 
        cer_NombreAdoptante, 
        cer_CedulaAdoptante, 
        cer_NombreMascota, 
        cer_EspecieMascota, 
        cer_RazaMascota, 
        cer_NombreRefugio
    )
    VALUES (
        @IdSolicitud,
        @CodigoCertificado,
        @NombreAdoptante,
        @CedulaAdoptante,
        @NombreMascota,
        @EspecieMascota,
        @RazaMascota,
        @NombreRefugio
    );

    PRINT 'Certificado generado con código: ' + @CodigoCertificado;
    SELECT 1 AS Exito, 'Certificado generado con éxito.' AS Mensaje, @CodigoCertificado AS CodigoCertificado;
END
GO
