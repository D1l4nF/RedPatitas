-- ============================================================
-- MÓDULO: SEGUIMIENTO POST-ADOPCIÓN Y DEVOLUCIONES
-- Creado: 2026-03-03
-- ============================================================

USE [RedPatitas];
GO

-- 1. Eliminar la tabla y SPs si ya existen (para volver a crearlos limpios)
IF OBJECT_ID('dbo.tbl_SeguimientosAdopcion', 'U') IS NOT NULL 
    DROP TABLE dbo.tbl_SeguimientosAdopcion;
GO

IF OBJECT_ID('dbo.sp_ProgramarSeguimientosAdopcion', 'P') IS NOT NULL 
    DROP PROCEDURE dbo.sp_ProgramarSeguimientosAdopcion;
GO

IF OBJECT_ID('dbo.sp_EnviarSeguimiento', 'P') IS NOT NULL 
    DROP PROCEDURE dbo.sp_EnviarSeguimiento;
GO

IF OBJECT_ID('dbo.sp_RevisarSeguimiento', 'P') IS NOT NULL 
    DROP PROCEDURE dbo.sp_RevisarSeguimiento;
GO

IF OBJECT_ID('dbo.sp_SolicitarDevolucion', 'P') IS NOT NULL 
    DROP PROCEDURE dbo.sp_SolicitarDevolucion;
GO

IF OBJECT_ID('dbo.sp_ConfirmarDevolucionRetorno', 'P') IS NOT NULL 
    DROP PROCEDURE dbo.sp_ConfirmarDevolucionRetorno;
GO


-- 2. Tabla de Seguimientos (Hitos)
CREATE TABLE dbo.tbl_SeguimientosAdopcion (
    seg_IdSeguimiento INT PRIMARY KEY IDENTITY(1,1),
    seg_IdSolicitud INT NOT NULL FOREIGN KEY REFERENCES dbo.tbl_SolicitudesAdopcion(sol_IdSolicitud),
    seg_NumeroEtapa INT NOT NULL, -- 1 (7 días), 2 (1 mes), 3 (3 meses), 4 (6 meses)
    seg_TituloEtapa VARCHAR(100) NOT NULL,
    seg_FechaProgramada DATETIME NOT NULL,
    
    -- Evidencia adjuntada por el adoptante
    seg_Latitud DECIMAL(10,8),
    seg_Longitud DECIMAL(11,8),
    seg_FotoUrlEnVivo VARCHAR(500),
    seg_ArchivoAdjuntoUrl VARCHAR(500), -- Ej: Cartilla de vacuna en etapa 3, o documento de devolución
    seg_RespuestasJSON TEXT, -- Respuestas dinámicas del formulario guardadas en formato JSON
    
    -- Estado y revisión (Para el panel del Admin del Refugio)
    seg_Estado VARCHAR(30) DEFAULT 'Pendiente', -- Pendiente, Disponible, Enviado, Aprobado, Rechazado
    seg_FechaEnvio DATETIME,
    seg_FechaRevision DATETIME,
    seg_IdUsuarioRevision INT FOREIGN KEY REFERENCES dbo.tbl_Usuarios(usu_IdUsuario),
    seg_ComentariosRevision TEXT,
    seg_FechaCreacion DATETIME DEFAULT GETDATE()
);
GO

-- 3. Procedimiento: Generar Hitos de Seguimiento Automáticos
CREATE PROCEDURE dbo.sp_ProgramarSeguimientosAdopcion
    @IdSolicitud INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @FechaActual DATETIME = GETDATE();
    
    -- Verificar que la solicitud existe y está aprobada
    IF EXISTS (SELECT 1 FROM dbo.tbl_SolicitudesAdopcion WHERE sol_IdSolicitud = @IdSolicitud AND sol_Estado = 'Aprobada')
    BEGIN
        -- Verificar si ya existen seguimientos para evitar duplicados en caso de error
        IF NOT EXISTS (SELECT 1 FROM dbo.tbl_SeguimientosAdopcion WHERE seg_IdSolicitud = @IdSolicitud)
        BEGIN
            -- Etapa 1: Adaptación (Inmediata al momento de la adopción)
            INSERT INTO dbo.tbl_SeguimientosAdopcion (seg_IdSolicitud, seg_NumeroEtapa, seg_TituloEtapa, seg_FechaProgramada, seg_Estado)
            VALUES (@IdSolicitud, 1, 'Etapa 1: Llegada a Casa', @FechaActual, 'Pendiente');
            
            -- Etapa 2: Comportamiento y Salud (1 mes / 30 días)
            INSERT INTO dbo.tbl_SeguimientosAdopcion (seg_IdSolicitud, seg_NumeroEtapa, seg_TituloEtapa, seg_FechaProgramada, seg_Estado)
            VALUES (@IdSolicitud, 2, 'Etapa 2: Comportamiento y Rutina', DATEADD(DAY, 30, @FechaActual), 'Pendiente');
            
            -- Etapa 3: Vacunación y Cuidados (3 meses / 90 días)
            INSERT INTO dbo.tbl_SeguimientosAdopcion (seg_IdSolicitud, seg_NumeroEtapa, seg_TituloEtapa, seg_FechaProgramada, seg_Estado)
            VALUES (@IdSolicitud, 3, 'Etapa 3: Salud y Vacunación', DATEADD(DAY, 90, @FechaActual), 'Pendiente');
            
            -- Etapa 4: Seguimiento Final (6 meses / 180 días)
            INSERT INTO dbo.tbl_SeguimientosAdopcion (seg_IdSolicitud, seg_NumeroEtapa, seg_TituloEtapa, seg_FechaProgramada, seg_Estado)
            VALUES (@IdSolicitud, 4, 'Etapa 4: Seguimiento Final - Alta', DATEADD(DAY, 180, @FechaActual), 'Pendiente');
            
            SELECT 1 AS Exito, 'Hitos de seguimiento programados correctamente' AS Mensaje;
        END
        ELSE
        BEGIN
            SELECT 0 AS Exito, 'Ya existen seguimientos programados para esta adopción' AS Mensaje;
        END
    END
    ELSE
    BEGIN
        SELECT 0 AS Exito, 'La solicitud no existe o no ha sido aprobada' AS Mensaje;
    END
END;
GO

-- 4. Procedimiento para que el adoptante envíe su evaluación del formulario con las fotos GPS
CREATE PROCEDURE dbo.sp_EnviarSeguimiento
    @IdSeguimiento INT,
    @Latitud DECIMAL(10,8),
    @Longitud DECIMAL(11,8),
    @FotoUrlEnVivo VARCHAR(500),
    @ArchivoAdjuntoUrl VARCHAR(500) = NULL,
    @RespuestasJSON TEXT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE dbo.tbl_SeguimientosAdopcion
    SET 
        seg_Latitud = @Latitud,
        seg_Longitud = @Longitud,
        seg_FotoUrlEnVivo = @FotoUrlEnVivo,
        seg_ArchivoAdjuntoUrl = @ArchivoAdjuntoUrl,
        seg_RespuestasJSON = @RespuestasJSON,
        seg_Estado = 'Enviado',
        seg_FechaEnvio = GETDATE()
    WHERE 
        seg_IdSeguimiento = @IdSeguimiento AND 
        (seg_Estado = 'Pendiente' OR seg_Estado = 'Rechazado' OR seg_Estado = 'Disponible');
        
    SELECT @@ROWCOUNT AS FilasActualizadas;
END;
GO

-- 5. Procedimiento para que el refugio califique la evaluación remitida
CREATE PROCEDURE dbo.sp_RevisarSeguimiento
    @IdSeguimiento INT,
    @IdUsuarioRevision INT,
    @EstadoNuevo VARCHAR(30), -- 'Aprobado' o 'Rechazado'
    @Comentarios TEXT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE dbo.tbl_SeguimientosAdopcion
    SET 
        seg_Estado = @EstadoNuevo,
        seg_IdUsuarioRevision = @IdUsuarioRevision,
        seg_ComentariosRevision = @Comentarios,
        seg_FechaRevision = GETDATE()
    WHERE 
        seg_IdSeguimiento = @IdSeguimiento AND 
        seg_Estado = 'Enviado';
        
    SELECT @@ROWCOUNT AS FilasActualizadas;
END;
GO

-- 6. Procedimiento para que el usuario active el botón de la Alerta: S.O.S "Solicitar Devolución"
CREATE PROCEDURE dbo.sp_SolicitarDevolucion
    @IdSolicitud INT,
    @MotivoDevolucion TEXT,
    @IdUsuarioSolicitante INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Actualizar el estado de la solicitud para reflejar la crisis a los refugios
    UPDATE dbo.tbl_SolicitudesAdopcion
    SET 
        sol_Estado = 'Devolucion_EnProceso', 
        sol_ComentariosRevision = CAST(ISNULL(CAST(sol_ComentariosRevision AS VARCHAR(MAX)), '') AS VARCHAR(MAX)) + CHAR(13) + CHAR(10) + 'DEVOLUCIÓN SOLICITADA (' + CONVERT(VARCHAR, GETDATE(), 103) + '): ' + CAST(@MotivoDevolucion AS VARCHAR(MAX))
    WHERE 
        sol_IdSolicitud = @IdSolicitud;
        
    -- Registrar en tabla general de auditoría
    INSERT INTO dbo.tbl_Auditoria (aud_IdUsuario, aud_Accion, aud_Tabla, aud_IdRegistro, aud_ValorNuevo)
    VALUES (@IdUsuarioSolicitante, 'ALERTA_DEVOLUCION', 'tbl_SolicitudesAdopcion', @IdSolicitud, @MotivoDevolucion);
    
    SELECT 1 AS Exito, 'Solicitud de devolución/emergencia registrada al centro del refugio' AS Mensaje;
END;
GO

-- 7. Procedimiento para confirmar (el Refugio) que la mascota ha sido devuelta físicamente o decomisada (maltrato)
CREATE PROCEDURE dbo.sp_ConfirmarDevolucionRetorno
    @IdSolicitud INT,
    @IdMascota INT,
    @IdUsuarioAdmin INT,
    @ComentariosFinales TEXT,
    @EsMaltrato BIT -- Si enviamos un 1 (true) en C#, activa el protocolo de bloqueo
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Cerrar definitivamente la solicitud con su motivo
    UPDATE dbo.tbl_SolicitudesAdopcion
    SET 
        sol_Estado = CASE WHEN @EsMaltrato = 1 THEN 'Revocada_Maltrato' ELSE 'Devolucion_Concretada' END,
        sol_ComentariosRevision = CAST(ISNULL(CAST(sol_ComentariosRevision AS VARCHAR(MAX)), '') AS VARCHAR(MAX)) + CHAR(13) + CHAR(10) + 'RETORNO CONFIRMADO: ' + CAST(@ComentariosFinales AS VARCHAR(MAX))
    WHERE sol_IdSolicitud = @IdSolicitud;
    
    -- Regresar la mascota a estado disponible para otra familia
    UPDATE dbo.tbl_Mascotas
    SET mas_EstadoAdopcion = 'Disponible'
    WHERE mas_IdMascota = @IdMascota;
    
    -- Si fue un decomiso legal o negligencia fuerte, bloqueamos la cuenta del adoptante
    IF @EsMaltrato = 1
    BEGIN
        DECLARE @IdAdoptante INT;
        SELECT @IdAdoptante = sol_IdUsuario FROM dbo.tbl_SolicitudesAdopcion WHERE sol_IdSolicitud = @IdSolicitud;
        
        IF @IdAdoptante IS NOT NULL
        BEGIN
            UPDATE dbo.tbl_Usuarios
            SET usu_Estado = 0 -- Se inhabilita la cuenta por maltrato animal
            WHERE usu_IdUsuario = @IdAdoptante;
            
            -- Auditoría: lista negra
            INSERT INTO dbo.tbl_Auditoria (aud_IdUsuario, aud_Accion, aud_Tabla, aud_IdRegistro, aud_ValorNuevo)
            VALUES (@IdUsuarioAdmin, 'BLOQUEO_POR_MALTRATO', 'tbl_Usuarios', @IdAdoptante, 'Se bloqueó la cuenta por revocación forzosa de adopción');
        END
    END
    
    -- Auditoría del refugio confirmando el éxito del reingreso
    INSERT INTO dbo.tbl_Auditoria (aud_IdUsuario, aud_Accion, aud_Tabla, aud_IdRegistro, aud_ValorNuevo)
    VALUES (@IdUsuarioAdmin, 'CONFIRMACION_RETORNO', 'tbl_Mascotas', @IdMascota, 'Mascota devuelta y nuevamente en catálogo');
    
    SELECT 1 AS Exito, 'Devolución procesada y mascota reingresada al catálogo general' AS Mensaje;
END;
GO


UPDATE tbl_SeguimientosAdopcion
SET seg_FechaProgramada = GETDATE()
WHERE seg_NumeroEtapa = 1;