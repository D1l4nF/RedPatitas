-- ============================================================
-- Script para agregar tabla de fotos de solicitudes
-- RedPatitas - Sistema de Evaluación de Adopciones
-- Ejecutar en la base de datos RedPatitas
-- ============================================================

USE RedPatitas;
GO

-- Tabla para almacenar fotos de la vivienda del adoptante
CREATE TABLE tbl_FotosSolicitud (
    fos_IdFoto INT PRIMARY KEY IDENTITY(1,1),
    fos_IdSolicitud INT NOT NULL,
    fos_Url VARCHAR(500) NOT NULL,
    fos_TipoFoto VARCHAR(50) NOT NULL,  -- 'VIVIENDA_FRONTAL', 'VIVIENDA_INTERIOR', 'PATIO', 'OTRO'
    fos_Descripcion VARCHAR(200),
    fos_FechaSubida DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_FotosSolicitud_Solicitud 
        FOREIGN KEY (fos_IdSolicitud) 
        REFERENCES tbl_SolicitudesAdopcion(sol_IdSolicitud) 
        ON DELETE CASCADE
);
GO

-- Índice para mejorar consultas por solicitud
CREATE INDEX IX_FotosSolicitud_IdSolicitud ON tbl_FotosSolicitud(fos_IdSolicitud);
GO

PRINT 'Tabla tbl_FotosSolicitud creada exitosamente';
GO
