-- ============================================================
-- BASE DE DATOS: RedPatitas
-- Plataforma Web Comunitaria para Gestión de Mascotas y Adopciones
-- Versión: 2.1 (Consolidada y Completa)
-- Fecha: 2026-03-18
-- ============================================================

PRINT 'Iniciando configuración de Base de Datos RedPatitas...';

CREATE DATABASE RedPatitas
GO

USE RedPatitas

-- ============================================================
-- MÓDULO 1: SEGURIDAD Y USUARIOS
-- ============================================================

CREATE TABLE tbl_Roles (
    rol_IdRol INT PRIMARY KEY IDENTITY(1,1),
    rol_Nombre VARCHAR(50) NOT NULL UNIQUE,
    rol_Descripcion VARCHAR(200),
    rol_Nivel INT DEFAULT 0,  
    rol_Estado BIT DEFAULT 1,
    rol_FechaCreacion DATETIME DEFAULT GETDATE()
);

CREATE TABLE tbl_Refugios (
    ref_IdRefugio INT PRIMARY KEY IDENTITY(1,1),
    ref_Nombre VARCHAR(150) NOT NULL,
    ref_Descripcion TEXT,
    ref_Direccion VARCHAR(300),
    ref_Latitud DECIMAL(10,8),   
    ref_Longitud DECIMAL(11,8),  
    ref_Ciudad VARCHAR(100),
    ref_Telefono VARCHAR(20),
    ref_Email VARCHAR(100),
    ref_LogoUrl VARCHAR(500),
    ref_FacebookUrl VARCHAR(300),       
    ref_InstagramUrl VARCHAR(300),      
    ref_HorarioAtencion VARCHAR(200),   
    ref_CuentaDonacion VARCHAR(500),    
    ref_Verificado BIT DEFAULT 0,  
    ref_FechaVerificacion DATETIME,
    ref_Estado BIT DEFAULT 1,
    ref_FechaRegistro DATETIME DEFAULT GETDATE()
);

CREATE TABLE tbl_Usuarios (
    usu_IdUsuario INT PRIMARY KEY IDENTITY(1,1),
    usu_IdRol INT NOT NULL FOREIGN KEY REFERENCES tbl_Roles(rol_IdRol),
    usu_IdRefugio INT NULL FOREIGN KEY REFERENCES tbl_Refugios(ref_IdRefugio),  
    usu_Nombre VARCHAR(100) NOT NULL,
    usu_Apellido VARCHAR(100),
    usu_Email VARCHAR(100) NOT NULL UNIQUE,
    usu_Contrasena VARCHAR(255) NOT NULL,  
    usu_Cedula VARCHAR(20),  
    usu_Telefono VARCHAR(20),
    usu_Latitud DECIMAL(10,8),   
    usu_Longitud DECIMAL(11,8),  
    usu_Ciudad VARCHAR(100),
    usu_FotoUrl VARCHAR(500),
    usu_EmailVerificado BIT DEFAULT 0,
    usu_IntentosFallidos INT DEFAULT 0,  
    usu_Bloqueado BIT DEFAULT 0,  
    usu_FechaBloqueo DATETIME,  
    usu_Estado BIT DEFAULT 1,  
    usu_FechaRegistro DATETIME DEFAULT GETDATE(),
    usu_UltimoAcceso DATETIME,
    usu_Salt VARCHAR(32) NULL
);

CREATE TABLE tbl_TokensRecuperacion (
    tok_IdToken INT PRIMARY KEY IDENTITY(1,1),
    tok_IdUsuario INT NOT NULL FOREIGN KEY REFERENCES tbl_Usuarios(usu_IdUsuario),
    tok_Token VARCHAR(255) NOT NULL,
    tok_FechaCreacion DATETIME DEFAULT GETDATE(),
    tok_FechaExpiracion DATETIME NOT NULL,
    tok_Usado BIT DEFAULT 0
);

CREATE TABLE tbl_Auditoria (
    aud_IdAuditoria BIGINT PRIMARY KEY IDENTITY(1,1),
    aud_IdUsuario INT FOREIGN KEY REFERENCES tbl_Usuarios(usu_IdUsuario),
    aud_Accion VARCHAR(50) NOT NULL,  
    aud_Tabla VARCHAR(50),
    aud_IdRegistro INT,
    aud_ValorAnterior TEXT,
    aud_ValorNuevo TEXT,
    aud_DireccionIP VARCHAR(50),
    aud_Fecha DATETIME DEFAULT GETDATE()
);

-- ============================================================
-- MÓDULO 2: CATÁLOGOS
-- ============================================================

CREATE TABLE tbl_Especies (
    esp_IdEspecie INT PRIMARY KEY IDENTITY(1,1),
    esp_Nombre VARCHAR(50) NOT NULL UNIQUE,
    esp_Descripcion VARCHAR(200),
    esp_IconoUrl VARCHAR(500),
    esp_Estado BIT DEFAULT 1
);

CREATE TABLE tbl_Razas (
    raz_IdRaza INT PRIMARY KEY IDENTITY(1,1),
    raz_IdEspecie INT NOT NULL FOREIGN KEY REFERENCES tbl_Especies(esp_IdEspecie),
    raz_Nombre VARCHAR(100) NOT NULL,
    raz_Descripcion VARCHAR(300),
    raz_Estado BIT DEFAULT 1,
    CONSTRAINT UQ_Raza_Especie UNIQUE (raz_IdEspecie, raz_Nombre)
);

-- ============================================================
-- MÓDULO 3: MASCOTAS
-- ============================================================

CREATE TABLE tbl_Mascotas (
    mas_IdMascota INT PRIMARY KEY IDENTITY(1,1),
    mas_IdRefugio INT NOT NULL FOREIGN KEY REFERENCES tbl_Refugios(ref_IdRefugio),
    mas_IdRaza INT FOREIGN KEY REFERENCES tbl_Razas(raz_IdRaza),
    mas_IdUsuarioRegistro INT FOREIGN KEY REFERENCES tbl_Usuarios(usu_IdUsuario),
    mas_Nombre VARCHAR(100) NOT NULL,
    mas_Edad INT,  
    mas_EdadAproximada VARCHAR(50),  
    mas_Sexo CHAR(1),  
    mas_Tamano VARCHAR(20),  
    mas_Peso DECIMAL(5,2),  
    mas_Color VARCHAR(100),
    mas_Descripcion TEXT,
    mas_Temperamento VARCHAR(200),  
    mas_Esterilizado BIT DEFAULT 0,
    mas_Vacunado BIT DEFAULT 0,
    mas_Desparasitado BIT DEFAULT 0,
    mas_NecesidadesEspeciales TEXT,
    mas_EstadoAdopcion VARCHAR(20) DEFAULT 'Disponible',  
    mas_Estado BIT DEFAULT 1,
    mas_FechaRegistro DATETIME DEFAULT GETDATE(),
    mas_FechaAdopcion DATETIME
);

CREATE TABLE tbl_FotosMascotas (
    fot_IdFoto INT PRIMARY KEY IDENTITY(1,1),
    fot_IdMascota INT NOT NULL FOREIGN KEY REFERENCES tbl_Mascotas(mas_IdMascota) ON DELETE CASCADE,
    fot_Url VARCHAR(500) NOT NULL,
    fot_EsPrincipal BIT DEFAULT 0,
    fot_Orden INT DEFAULT 0,
    fot_FechaSubida DATETIME DEFAULT GETDATE()
);

CREATE TABLE tbl_Favoritos (
    fav_IdFavorito INT PRIMARY KEY IDENTITY(1,1),
    fav_IdUsuario INT NOT NULL FOREIGN KEY REFERENCES tbl_Usuarios(usu_IdUsuario),
    fav_IdMascota INT NOT NULL FOREIGN KEY REFERENCES tbl_Mascotas(mas_IdMascota) ON DELETE CASCADE,
    fav_FechaAgregado DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_Favorito_Usuario_Mascota UNIQUE (fav_IdUsuario, fav_IdMascota)
);

-- ============================================================
-- MÓDULO 4: ADOPCIONES Y EVALUACIÓN
-- ============================================================

CREATE TABLE tbl_CriteriosEvaluacion (
    cri_IdCriterio INT PRIMARY KEY IDENTITY(1,1),
    cri_Nombre VARCHAR(100) NOT NULL,
    cri_Descripcion VARCHAR(300),
    cri_Peso DECIMAL(5,2) NOT NULL,  
    cri_PuntajeMaximo INT DEFAULT 10,
    cri_Orden INT DEFAULT 0,
    cri_Estado BIT DEFAULT 1
);

CREATE TABLE tbl_SolicitudesAdopcion (
    sol_IdSolicitud INT PRIMARY KEY IDENTITY(1,1),
    sol_IdMascota INT NOT NULL FOREIGN KEY REFERENCES tbl_Mascotas(mas_IdMascota),
    sol_IdUsuario INT NOT NULL FOREIGN KEY REFERENCES tbl_Usuarios(usu_IdUsuario),
    sol_MotivoAdopcion TEXT,
    sol_ExperienciaMascotas TEXT,
    sol_TipoVivienda VARCHAR(50),  
    sol_TienePatioJardin BIT DEFAULT 0,
    sol_OtrasMascotas BIT DEFAULT 0,
    sol_DetalleOtrasMascotas VARCHAR(300),
    sol_TieneNinos BIT DEFAULT 0,
    sol_EdadesNinos VARCHAR(100),
    sol_HorasEnCasa INT,  
    sol_IngresosMensuales VARCHAR(50),  
    sol_AceptaVisita BIT DEFAULT 1,  
    sol_Comentarios TEXT,
    sol_Estado VARCHAR(20) DEFAULT 'Pendiente',  
    sol_PuntajeTotal DECIMAL(5,2),  
    sol_IdUsuarioRevision INT FOREIGN KEY REFERENCES tbl_Usuarios(usu_IdUsuario),
    sol_ComentariosRevision TEXT,
    sol_FechaSolicitud DATETIME DEFAULT GETDATE(),
    sol_FechaRevision DATETIME
);

CREATE TABLE tbl_DetalleEvaluacion (
    det_IdDetalle INT PRIMARY KEY IDENTITY(1,1),
    det_IdSolicitud INT NOT NULL FOREIGN KEY REFERENCES tbl_SolicitudesAdopcion(sol_IdSolicitud) ON DELETE CASCADE,
    det_IdCriterio INT NOT NULL FOREIGN KEY REFERENCES tbl_CriteriosEvaluacion(cri_IdCriterio),
    det_Puntaje INT NOT NULL,
    det_Comentario VARCHAR(300),
    det_FechaEvaluacion DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_Evaluacion_Criterio UNIQUE (det_IdSolicitud, det_IdCriterio)
);

CREATE TABLE tbl_FotosSolicitud (
    fos_IdFoto INT PRIMARY KEY IDENTITY(1,1),
    fos_IdSolicitud INT NOT NULL FOREIGN KEY REFERENCES tbl_SolicitudesAdopcion(sol_IdSolicitud) ON DELETE CASCADE,
    fos_Url VARCHAR(500) NOT NULL,
    fos_TipoFoto VARCHAR(50) NOT NULL, 
    fos_Descripcion VARCHAR(200),
    fos_FechaSubida DATETIME DEFAULT GETDATE()
);

-- ============================================================
-- MÓDULO 5: SEGUIMIENTO Y DEVOLUCIONES
-- ============================================================

CREATE TABLE tbl_SeguimientosAdopcion (
    seg_IdSeguimiento INT PRIMARY KEY IDENTITY(1,1),
    seg_IdSolicitud INT NOT NULL FOREIGN KEY REFERENCES tbl_SolicitudesAdopcion(sol_IdSolicitud),
    seg_NumeroEtapa INT NOT NULL, 
    seg_TituloEtapa VARCHAR(100) NOT NULL,
    seg_FechaProgramada DATETIME NOT NULL,
    seg_Latitud DECIMAL(10,8),
    seg_Longitud DECIMAL(11,8),
    seg_FotoUrlEnVivo VARCHAR(500),
    seg_ArchivoAdjuntoUrl VARCHAR(500), 
    seg_RespuestasJSON TEXT, 
    seg_Estado VARCHAR(30) DEFAULT 'Pendiente', 
    seg_FechaEnvio DATETIME,
    seg_FechaRevision DATETIME,
    seg_IdUsuarioRevision INT FOREIGN KEY REFERENCES tbl_Usuarios(usu_IdUsuario),
    seg_ComentariosRevision TEXT,
    seg_FechaCreacion DATETIME DEFAULT GETDATE()
);

-- ============================================================
-- MÓDULO 6: CERTIFICADOS Y NOTIFICACIONES
-- ============================================================

CREATE TABLE tbl_CertificadosAdopcion (
    cer_IdCertificado INT PRIMARY KEY IDENTITY(1,1),
    cer_IdSolicitud INT NOT NULL FOREIGN KEY REFERENCES tbl_SolicitudesAdopcion(sol_IdSolicitud),
    cer_CodigoCertificado VARCHAR(50) NOT NULL UNIQUE,
    cer_FechaEmision DATETIME DEFAULT GETDATE(),
    cer_NombreAdoptante VARCHAR(200) NOT NULL,
    cer_CedulaAdoptante VARCHAR(20),
    cer_NombreMascota VARCHAR(100) NOT NULL,
    cer_EspecieMascota VARCHAR(50),
    cer_RazaMascota VARCHAR(100),
    cer_NombreRefugio VARCHAR(150) NOT NULL,
    cer_Estado VARCHAR(20) DEFAULT 'Vigente' 
);

CREATE TABLE tbl_Notificaciones (
    not_IdNotificacion INT PRIMARY KEY IDENTITY(1,1),
    not_IdUsuario INT NOT NULL FOREIGN KEY REFERENCES tbl_Usuarios(usu_IdUsuario),
    not_Titulo VARCHAR(150) NOT NULL,
    not_Mensaje TEXT,
    not_Tipo VARCHAR(30),  
    not_Icono VARCHAR(50),
    not_UrlAccion VARCHAR(300),
    not_Leida BIT DEFAULT 0,
    not_FechaCreacion DATETIME DEFAULT GETDATE(),
    not_FechaLectura DATETIME
);

-- ============================================================
-- MÓDULO 7: COMUNIDAD (REPORTES)
-- ============================================================

CREATE TABLE tbl_ReportesMascotas (
    rep_IdReporte INT PRIMARY KEY IDENTITY(1,1),
    rep_IdUsuario INT NOT NULL FOREIGN KEY REFERENCES tbl_Usuarios(usu_IdUsuario),
    rep_TipoReporte VARCHAR(20) NOT NULL,  
    rep_NombreMascota VARCHAR(100),
    rep_IdEspecie INT FOREIGN KEY REFERENCES tbl_Especies(esp_IdEspecie),
    rep_Raza VARCHAR(100),
    rep_Color VARCHAR(100),
    rep_Tamano VARCHAR(20),
    rep_Sexo CHAR(1),
    rep_EdadAproximada VARCHAR(50),
    rep_Descripcion TEXT,
    rep_CaracteristicasDistintivas TEXT,
    rep_UbicacionUltima VARCHAR(300),
    rep_Ciudad VARCHAR(100),
    rep_Latitud DECIMAL(10,8),
    rep_Longitud DECIMAL(11,8),
    rep_TelefonoContacto VARCHAR(20),
    rep_EmailContacto VARCHAR(100),
    rep_FechaEvento DATETIME,  
    rep_Estado VARCHAR(20) DEFAULT 'Reportado',  
    rep_FechaReporte DATETIME DEFAULT GETDATE(),
    rep_FechaCierre DATETIME
);

CREATE TABLE tbl_FotosReportes (
    fore_IdFoto INT PRIMARY KEY IDENTITY(1,1),
    fore_IdReporte INT NOT NULL FOREIGN KEY REFERENCES tbl_ReportesMascotas(rep_IdReporte) ON DELETE CASCADE,
    fore_Url VARCHAR(500) NOT NULL,
    fore_Orden INT DEFAULT 0,
    fore_FechaSubida DATETIME DEFAULT GETDATE()
);

CREATE TABLE tbl_Avistamientos (
    avi_IdAvistamiento INT PRIMARY KEY IDENTITY(1,1),
    avi_IdReporte INT NOT NULL FOREIGN KEY REFERENCES tbl_ReportesMascotas(rep_IdReporte),
    avi_IdUsuario INT FOREIGN KEY REFERENCES tbl_Usuarios(usu_IdUsuario),
    avi_Ubicacion VARCHAR(300),
    avi_Descripcion TEXT,
    avi_FechaAvistamiento DATETIME,
    avi_FechaReporte DATETIME DEFAULT GETDATE(),
    avi_Latitud DECIMAL(10,8),
    avi_Longitud DECIMAL(11,8),
    avi_FotoUrl VARCHAR(500)
);

-- ============================================================
-- MÓDULO 8: CAMPAÑAS
-- ============================================================

CREATE TABLE tbl_Campanias (
    cam_IdCampania INT PRIMARY KEY IDENTITY(1,1),
    cam_IdRefugio INT NOT NULL FOREIGN KEY REFERENCES tbl_Refugios(ref_IdRefugio),
    cam_Titulo VARCHAR(150) NOT NULL,
    cam_Descripcion TEXT,
    cam_TipoCampania VARCHAR(30),  
    cam_ImagenUrl VARCHAR(500),
    cam_FechaInicio DATETIME,
    cam_FechaFin DATETIME,
    cam_Ubicacion VARCHAR(200),
    cam_Estado VARCHAR(20) DEFAULT 'Activa',  
    cam_FechaCreacion DATETIME DEFAULT GETDATE()
);

GO

-- ============================================================
-- DATOS INICIALES
-- ============================================================

INSERT INTO tbl_Roles (rol_Nombre, rol_Descripcion, rol_Nivel) VALUES 
('SuperAdmin', 'Administrador global del sistema', 100),
('AdminRefugio', 'Administrador de un refugio específico', 50),
('Refugio', 'Usuario operativo de refugio', 30),
('Adoptante', 'Usuario que busca adoptar mascotas', 10);

INSERT INTO tbl_Especies (esp_Nombre, esp_Descripcion) VALUES 
('Perro', 'Canis lupus familiaris'), ('Gato', 'Felis catus'), ('Otro', 'Otras especies');

INSERT INTO tbl_Razas (raz_IdEspecie, raz_Nombre) VALUES 
(1, 'Mestizo'), (1, 'Labrador'), (1, 'Pastor Alemán'), (1, 'Golden'), (2, 'Mestizo'), (2, 'Siamés'), (2, 'Persa');

INSERT INTO tbl_CriteriosEvaluacion (cri_Nombre, cri_Descripcion, cri_Peso, cri_Orden) VALUES 
('Tipo de Vivienda', 'Espacio disponible', 15.00, 1),
('Experiencia', 'Experiencia previa', 15.00, 2),
('Tiempo', 'Tiempo disponible al día', 15.00, 3),
('Espacio Exterior', 'Patio o jardín', 15.00, 4),
('Familia', 'Niños u otras mascotas', 10.00, 5),
('Economía', 'Capacidad económica', 15.00, 6),
('Compromiso', 'Motivación y compromiso', 15.00, 7);

-- Admin (admin123)
INSERT INTO tbl_Usuarios (usu_IdRol, usu_Nombre, usu_Apellido, usu_Email, usu_Contrasena, usu_Salt, usu_Estado, usu_EmailVerificado) 
VALUES (1, 'Admin', 'RedPatitas', 'admin@test.com', '4dfc2fdb1f2a4e6e912d467da6bec325d5c2d97c0a0e9eb48c1b76fb3783d72b', '789c3e1d13b5fc0e28998407654a90a6', 1, 1);

GO

-- ============================================================
-- VISTAS
-- ============================================================

CREATE VIEW vw_EstadisticasGenerales AS
SELECT 
    (SELECT COUNT(*) FROM tbl_Usuarios WHERE usu_Estado = 1) AS TotalUsuarios,
    (SELECT COUNT(*) FROM tbl_Refugios WHERE ref_Estado = 1) AS TotalRefugios,
    (SELECT COUNT(*) FROM tbl_Mascotas WHERE mas_Estado = 1) AS TotalMascotas,
    (SELECT COUNT(*) FROM tbl_SolicitudesAdopcion WHERE sol_Estado = 'Pendiente') AS SolicitudesPendientes;
GO

CREATE VIEW vw_MascotasCompleta AS
SELECT m.*, e.esp_Nombre AS Especie, r.raz_Nombre AS Raza, ref.ref_Nombre AS Refugio
FROM tbl_Mascotas m
INNER JOIN tbl_Refugios ref ON m.mas_IdRefugio = ref.ref_IdRefugio
LEFT JOIN tbl_Razas r ON m.mas_IdRaza = r.raz_IdRaza
LEFT JOIN tbl_Especies e ON r.raz_IdEspecie = e.esp_IdEspecie
WHERE m.mas_Estado = 1;
GO

-- ============================================================
-- PROCEDIMIENTOS ALMACENADOS
-- ============================================================

CREATE PROCEDURE sp_ValidarLogin @Email VARCHAR(100), @Contrasena VARCHAR(255), @DireccionIP VARCHAR(50) = NULL
AS
BEGIN
    DECLARE @IdUsuario INT, @ContrasenaDB VARCHAR(255), @Bloqueado BIT, @IntentosFallidos INT, @MaxIntentos INT = 3;
    SELECT @IdUsuario = usu_IdUsuario, @ContrasenaDB = usu_Contrasena, @Bloqueado = usu_Bloqueado, @IntentosFallidos = usu_IntentosFallidos
    FROM tbl_Usuarios WHERE usu_Email = @Email AND usu_Estado = 1;
    IF @IdUsuario IS NULL BEGIN SELECT 0 AS Exito, 'Credenciales inválidas' AS Mensaje; RETURN; END
    IF @Bloqueado = 1 BEGIN SELECT 0 AS Exito, 'Cuenta bloqueada' AS Mensaje; RETURN; END
    IF @ContrasenaDB = @Contrasena BEGIN
        UPDATE tbl_Usuarios SET usu_IntentosFallidos = 0, usu_UltimoAcceso = GETDATE() WHERE usu_IdUsuario = @IdUsuario;
        SELECT 1 AS Exito, 'Login exitoso' AS Mensaje, @IdUsuario AS IdUsuario;
    END ELSE BEGIN
        SET @IntentosFallidos = @IntentosFallidos + 1;
        UPDATE tbl_Usuarios SET usu_IntentosFallidos = @IntentosFallidos, usu_Bloqueado = CASE WHEN @IntentosFallidos >= @MaxIntentos THEN 1 ELSE 0 END WHERE usu_IdUsuario = @IdUsuario;
        SELECT 0 AS Exito, 'Credenciales inválidas' AS Mensaje;
    END
END;
GO

CREATE PROCEDURE sp_CalcularEvaluacionAdopcion @IdSolicitud INT
AS
BEGIN
    DECLARE @PuntajeTotal DECIMAL(5,2) = 0;
    SELECT @PuntajeTotal = SUM((CAST(de.det_Puntaje AS DECIMAL(5,2)) / ce.cri_PuntajeMaximo * ce.cri_Peso))
    FROM tbl_DetalleEvaluacion de INNER JOIN tbl_CriteriosEvaluacion ce ON de.det_IdCriterio = ce.cri_IdCriterio
    WHERE de.det_IdSolicitud = @IdSolicitud;
    UPDATE tbl_SolicitudesAdopcion SET sol_PuntajeTotal = @PuntajeTotal WHERE sol_IdSolicitud = @IdSolicitud;
    SELECT @PuntajeTotal AS PuntajeTotal;
END;
GO

CREATE PROCEDURE dbo.sp_ProgramarSeguimientosAdopcion @IdSolicitud INT
AS
BEGIN
    DECLARE @FechaActual DATETIME = GETDATE();
    INSERT INTO tbl_SeguimientosAdopcion (seg_IdSolicitud, seg_NumeroEtapa, seg_TituloEtapa, seg_FechaProgramada) VALUES 
    (@IdSolicitud, 1, 'Llegada a Casa', @FechaActual),
    (@IdSolicitud, 2, 'Primer Mes', DATEADD(DAY, 30, @FechaActual)),
    (@IdSolicitud, 3, 'Tercer Mes', DATEADD(DAY, 90, @FechaActual)),
    (@IdSolicitud, 4, 'Sexto Mes', DATEADD(DAY, 180, @FechaActual));
END;
GO

CREATE PROCEDURE dbo.sp_RevisarSeguimiento @IdSeguimiento INT, @IdUsuarioRevision INT, @EstadoNuevo VARCHAR(30), @Comentarios TEXT
AS
BEGIN
    UPDATE tbl_SeguimientosAdopcion SET seg_Estado = @EstadoNuevo, seg_IdUsuarioRevision = @IdUsuarioRevision, seg_ComentariosRevision = @Comentarios, seg_FechaRevision = GETDATE()
    WHERE seg_IdSeguimiento = @IdSeguimiento;
END;
GO

CREATE PROCEDURE dbo.sp_SolicitarDevolucion @IdSolicitud INT, @Motivo TEXT, @IdUsuario INT
AS
BEGIN
    UPDATE tbl_SolicitudesAdopcion SET sol_Estado = 'Devolucion_EnProceso' WHERE sol_IdSolicitud = @IdSolicitud;
    INSERT INTO tbl_Auditoria (aud_IdUsuario, aud_Accion, aud_Tabla, aud_IdRegistro, aud_ValorNuevo) VALUES (@IdUsuario, 'SOLICITAR_DEVOLUCION', 'tbl_SolicitudesAdopcion', @IdSolicitud, @Motivo);
END;
GO

CREATE PROCEDURE dbo.sp_ConfirmarDevolucionRetorno @IdSolicitud INT, @IdMascota INT, @IdUsuarioAdmin INT, @Comentarios TEXT, @EsMaltrato BIT
AS
BEGIN
    UPDATE tbl_SolicitudesAdopcion SET sol_Estado = CASE WHEN @EsMaltrato = 1 THEN 'Revocada_Maltrato' ELSE 'Devolucion_Concretada' END WHERE sol_IdSolicitud = @IdSolicitud;
    UPDATE tbl_Mascotas SET mas_EstadoAdopcion = 'Disponible' WHERE mas_IdMascota = @IdMascota;
    IF @EsMaltrato = 1 UPDATE tbl_Usuarios SET usu_Estado = 0 WHERE usu_IdUsuario = (SELECT sol_IdUsuario FROM tbl_SolicitudesAdopcion WHERE sol_IdSolicitud = @IdSolicitud);
END;
GO

CREATE PROCEDURE sp_GenerarCertificadoAdopcion @IdSolicitud INT
AS
BEGIN
    DECLARE @CodigoCertificado VARCHAR(50) = 'RP-' + CAST(YEAR(GETDATE()) AS VARCHAR) + '-' + RIGHT('00000' + CAST((SELECT ISNULL(MAX(cer_IdCertificado),0)+1 FROM tbl_CertificadosAdopcion) AS VARCHAR), 5);
    INSERT INTO tbl_CertificadosAdopcion (cer_IdSolicitud, cer_CodigoCertificado, cer_NombreAdoptante, cer_CedulaAdoptante, cer_NombreMascota, cer_EspecieMascota, cer_RazaMascota, cer_NombreRefugio)
    SELECT @IdSolicitud, @CodigoCertificado, u.usu_Nombre + ' ' + u.usu_Apellido, u.usu_Cedula, m.mas_Nombre, e.esp_Nombre, rz.raz_Nombre, ref.ref_Nombre
    FROM tbl_SolicitudesAdopcion s INNER JOIN tbl_Usuarios u ON s.sol_IdUsuario = u.usu_IdUsuario INNER JOIN tbl_Mascotas m ON s.sol_IdMascota = m.mas_IdMascota
    INNER JOIN tbl_Refugios ref ON m.mas_IdRefugio = ref.ref_IdRefugio LEFT JOIN tbl_Razas rz ON m.mas_IdRaza = rz.raz_IdRaza LEFT JOIN tbl_Especies e ON rz.raz_IdEspecie = e.esp_IdEspecie
    WHERE s.sol_IdSolicitud = @IdSolicitud;
END;
GO

-- ============================================================
-- ÍNDICES
-- ============================================================

CREATE INDEX IX_Usuarios_Email ON tbl_Usuarios(usu_Email);
CREATE INDEX IX_Mascotas_IdRefugio ON tbl_Mascotas(mas_IdRefugio);
CREATE INDEX IX_SolicitudesAdopcion_Estado ON tbl_SolicitudesAdopcion(sol_Estado);

PRINT '¡Configuración finalizada con éxito!';
GO
