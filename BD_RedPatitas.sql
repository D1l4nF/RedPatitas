-- ============================================================
-- BASE DE DATOS: RedPatitas
-- Plataforma Web Comunitaria para Gestión de Mascotas y Adopciones
-- Fecha: 2025-12-19
-- ============================================================

-- Crear base de datos
-- CREATE DATABASE RedPatitas;
-- GO
-- USE RedPatitas;
-- GO

-- ============================================================
-- MÓDULO 1: SEGURIDAD Y USUARIOS
-- ============================================================

-- Tabla de Roles del Sistema
CREATE TABLE tbl_Roles (
    rol_IdRol INT PRIMARY KEY IDENTITY(1,1),
    rol_Nombre VARCHAR(50) NOT NULL UNIQUE,
    rol_Descripcion VARCHAR(200),
    rol_Nivel INT DEFAULT 0,  -- Para jerarquía (SuperAdmin=100, AdminRefugio=50, etc.)
    rol_Estado BIT DEFAULT 1,
    rol_FechaCreacion DATETIME DEFAULT GETDATE()
);

-- Tabla de Refugios
CREATE TABLE tbl_Refugios (
    ref_IdRefugio INT PRIMARY KEY IDENTITY(1,1),
    ref_Nombre VARCHAR(150) NOT NULL,
    ref_Descripcion TEXT,
    ref_Direccion VARCHAR(300),
    ref_Latitud DECIMAL(10,8),   -- Coordenada de ubicación del refugio
    ref_Longitud DECIMAL(11,8),  -- Coordenada de ubicación del refugio
    ref_Ciudad VARCHAR(100),
    ref_Telefono VARCHAR(20),
    ref_Email VARCHAR(100),
    ref_LogoUrl VARCHAR(500),
    ref_FacebookUrl VARCHAR(300),       -- URL de página de Facebook
    ref_InstagramUrl VARCHAR(300),      -- URL de perfil de Instagram
    ref_HorarioAtencion VARCHAR(200),   -- Ej: "Lun-Vie: 9:00-18:00"
    ref_CuentaDonacion VARCHAR(500),    -- URL o datos para donaciones
    ref_Verificado BIT DEFAULT 0,  -- Aprobado por SuperAdmin
    ref_FechaVerificacion DATETIME,
    ref_Estado BIT DEFAULT 1,
    ref_FechaRegistro DATETIME DEFAULT GETDATE()
);

-- Tabla de Usuarios
CREATE TABLE tbl_Usuarios (
    usu_IdUsuario INT PRIMARY KEY IDENTITY(1,1),
    usu_IdRol INT NOT NULL FOREIGN KEY REFERENCES tbl_Roles(rol_IdRol),
    usu_IdRefugio INT NULL FOREIGN KEY REFERENCES tbl_Refugios(ref_IdRefugio),  -- NULL si es Adoptante o SuperAdmin
    usu_Nombre VARCHAR(100) NOT NULL,
    usu_Apellido VARCHAR(100),
    usu_Email VARCHAR(100) NOT NULL UNIQUE,
    usu_Contrasena VARCHAR(255) NOT NULL,  -- SHA-256 + Salt
    usu_Cedula VARCHAR(20),  -- Para adoptantes (requerido para adoptar)
    usu_Telefono VARCHAR(20),
    usu_Latitud DECIMAL(10,8),   -- Coordenada de ubicación del usuario
    usu_Longitud DECIMAL(11,8),  -- Coordenada de ubicación del usuario
    usu_Ciudad VARCHAR(100),
    usu_FotoUrl VARCHAR(500),
    usu_EmailVerificado BIT DEFAULT 0,
    -- Campos de seguridad para bloqueo de cuenta
    usu_IntentosFallidos INT DEFAULT 0,  -- Contador de intentos fallidos
    usu_Bloqueado BIT DEFAULT 0,  -- Cuenta bloqueada
    usu_FechaBloqueo DATETIME,  -- Cuándo se bloqueó
    usu_Estado BIT DEFAULT 1,  -- Activo/Inactivo
    usu_FechaRegistro DATETIME DEFAULT GETDATE(),
    usu_UltimoAcceso DATETIME,
    usu_Salt VARCHAR(32) NULL
);


-- Tokens para recuperación de contraseña
CREATE TABLE tbl_TokensRecuperacion (
    tok_IdToken INT PRIMARY KEY IDENTITY(1,1),
    tok_IdUsuario INT NOT NULL FOREIGN KEY REFERENCES tbl_Usuarios(usu_IdUsuario),
    tok_Token VARCHAR(255) NOT NULL,
    tok_FechaCreacion DATETIME DEFAULT GETDATE(),
    tok_FechaExpiracion DATETIME NOT NULL,
    tok_Usado BIT DEFAULT 0
);

-- Tabla de Auditoría
CREATE TABLE tbl_Auditoria (
    aud_IdAuditoria BIGINT PRIMARY KEY IDENTITY(1,1),
    aud_IdUsuario INT FOREIGN KEY REFERENCES tbl_Usuarios(usu_IdUsuario),
    aud_Accion VARCHAR(50) NOT NULL,  -- INSERT, UPDATE, DELETE, LOGIN, LOGOUT
    aud_Tabla VARCHAR(50),
    aud_IdRegistro INT,
    aud_ValorAnterior TEXT,
    aud_ValorNuevo TEXT,
    aud_DireccionIP VARCHAR(50),
    aud_Fecha DATETIME DEFAULT GETDATE()
);

-- ============================================================
-- MÓDULO 2: CATÁLOGOS (ESPECIES Y RAZAS)
-- ============================================================

-- Tabla de Especies
CREATE TABLE tbl_Especies (
    esp_IdEspecie INT PRIMARY KEY IDENTITY(1,1),
    esp_Nombre VARCHAR(50) NOT NULL UNIQUE,
    esp_Descripcion VARCHAR(200),
    esp_IconoUrl VARCHAR(500),
    esp_Estado BIT DEFAULT 1
);

-- Tabla de Razas
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

-- Tabla de Mascotas
CREATE TABLE tbl_Mascotas (
    mas_IdMascota INT PRIMARY KEY IDENTITY(1,1),
    mas_IdRefugio INT NOT NULL FOREIGN KEY REFERENCES tbl_Refugios(ref_IdRefugio),
    mas_IdRaza INT FOREIGN KEY REFERENCES tbl_Razas(raz_IdRaza),
    mas_IdUsuarioRegistro INT FOREIGN KEY REFERENCES tbl_Usuarios(usu_IdUsuario),
    mas_Nombre VARCHAR(100) NOT NULL,
    mas_Edad INT,  -- En meses
    mas_EdadAproximada VARCHAR(50),  -- "Cachorro", "Adulto", "Senior"
    mas_Sexo CHAR(1),  -- M/F
    mas_Tamano VARCHAR(20),  -- Pequeño, Mediano, Grande
    mas_Peso DECIMAL(5,2),  -- En kg
    mas_Color VARCHAR(100),
    mas_Descripcion TEXT,
    mas_Temperamento VARCHAR(200),  -- Tranquilo, Juguetón, etc.
    mas_Esterilizado BIT DEFAULT 0,
    mas_Vacunado BIT DEFAULT 0,
    mas_Desparasitado BIT DEFAULT 0,
    mas_NecesidadesEspeciales TEXT,
    mas_EstadoAdopcion VARCHAR(20) DEFAULT 'Disponible',  -- Disponible, EnProceso, Adoptado, Reservado
    mas_Estado BIT DEFAULT 1,
    mas_FechaRegistro DATETIME DEFAULT GETDATE(),
    mas_FechaAdopcion DATETIME
);

-- Fotos de Mascotas (múltiples por mascota)
CREATE TABLE tbl_FotosMascotas (
    fot_IdFoto INT PRIMARY KEY IDENTITY(1,1),
    fot_IdMascota INT NOT NULL FOREIGN KEY REFERENCES tbl_Mascotas(mas_IdMascota) ON DELETE CASCADE,
    fot_Url VARCHAR(500) NOT NULL,
    fot_EsPrincipal BIT DEFAULT 0,
    fot_Orden INT DEFAULT 0,
    fot_FechaSubida DATETIME DEFAULT GETDATE()
);

-- Favoritos de Mascotas (para adoptantes)
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

-- Criterios de Evaluación (configurables por admin)
CREATE TABLE tbl_CriteriosEvaluacion (
    cri_IdCriterio INT PRIMARY KEY IDENTITY(1,1),
    cri_Nombre VARCHAR(100) NOT NULL,
    cri_Descripcion VARCHAR(300),
    cri_Peso DECIMAL(5,2) NOT NULL,  -- Porcentaje (ej: 20.00 = 20%)
    cri_PuntajeMaximo INT DEFAULT 10,
    cri_Orden INT DEFAULT 0,
    cri_Estado BIT DEFAULT 1
);

-- Solicitudes de Adopción
CREATE TABLE tbl_SolicitudesAdopcion (
    sol_IdSolicitud INT PRIMARY KEY IDENTITY(1,1),
    sol_IdMascota INT NOT NULL FOREIGN KEY REFERENCES tbl_Mascotas(mas_IdMascota),
    sol_IdUsuario INT NOT NULL FOREIGN KEY REFERENCES tbl_Usuarios(usu_IdUsuario),
    -- Datos del formulario
    sol_MotivoAdopcion TEXT,
    sol_ExperienciaMascotas TEXT,
    sol_TipoVivienda VARCHAR(50),  -- Casa, Apartamento, Finca
    sol_TienePatioJardin BIT DEFAULT 0,
    sol_OtrasMascotas BIT DEFAULT 0,
    sol_DetalleOtrasMascotas VARCHAR(300),
    sol_TieneNinos BIT DEFAULT 0,
    sol_EdadesNinos VARCHAR(100),
    sol_HorasEnCasa INT,  -- Horas al día en casa
    sol_IngresosMensuales VARCHAR(50),  -- Rango
    sol_AceptaVisita BIT DEFAULT 1,  -- Acepta visita de seguimiento
    sol_Comentarios TEXT,
    -- Estado y evaluación
    sol_Estado VARCHAR(20) DEFAULT 'Pendiente',  -- Pendiente, EnRevision, Aprobada, Rechazada
    sol_PuntajeTotal DECIMAL(5,2),  -- Calculado por procedimiento
    sol_IdUsuarioRevision INT FOREIGN KEY REFERENCES tbl_Usuarios(usu_IdUsuario),
    sol_ComentariosRevision TEXT,
    sol_FechaSolicitud DATETIME DEFAULT GETDATE(),
    sol_FechaRevision DATETIME
);

-- Detalle de Evaluación por Criterio
CREATE TABLE tbl_DetalleEvaluacion (
    det_IdDetalle INT PRIMARY KEY IDENTITY(1,1),
    det_IdSolicitud INT NOT NULL FOREIGN KEY REFERENCES tbl_SolicitudesAdopcion(sol_IdSolicitud) ON DELETE CASCADE,
    det_IdCriterio INT NOT NULL FOREIGN KEY REFERENCES tbl_CriteriosEvaluacion(cri_IdCriterio),
    det_Puntaje INT NOT NULL,
    det_Comentario VARCHAR(300),
    det_FechaEvaluacion DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_Evaluacion_Criterio UNIQUE (det_IdSolicitud, det_IdCriterio)
);

-- ============================================================
-- MÓDULO 5: REPORTES DE MASCOTAS PERDIDAS/ENCONTRADAS
-- ============================================================

-- Reportes de Mascotas
CREATE TABLE tbl_ReportesMascotas (
    rep_IdReporte INT PRIMARY KEY IDENTITY(1,1),
    rep_IdUsuario INT NOT NULL FOREIGN KEY REFERENCES tbl_Usuarios(usu_IdUsuario),
    rep_TipoReporte VARCHAR(20) NOT NULL,  -- Perdida, Encontrada
    rep_NombreMascota VARCHAR(100),
    rep_IdEspecie INT FOREIGN KEY REFERENCES tbl_Especies(esp_IdEspecie),
    rep_Raza VARCHAR(100),
    rep_Color VARCHAR(100),
    rep_Tamano VARCHAR(20),
    rep_Sexo CHAR(1),
    rep_EdadAproximada VARCHAR(50),
    rep_Descripcion TEXT,
    rep_CaracteristicasDistintivas TEXT,
    -- Ubicación
    rep_UbicacionUltima VARCHAR(300),
    rep_Ciudad VARCHAR(100),
    rep_Latitud DECIMAL(10,8),
    rep_Longitud DECIMAL(11,8),
    -- Contacto
    rep_TelefonoContacto VARCHAR(20),
    rep_EmailContacto VARCHAR(100),
    -- Fechas y estado
    rep_FechaEvento DATETIME,  -- Cuándo se perdió/encontró
    rep_Estado VARCHAR(20) DEFAULT 'Reportado',  -- Reportado, EnBusqueda, Avistado, Encontrado, Reunido, SinResolver
    rep_FechaReporte DATETIME DEFAULT GETDATE(),
    rep_FechaCierre DATETIME
);

-- Fotos de Reportes
CREATE TABLE tbl_FotosReportes (
    fore_IdFoto INT PRIMARY KEY IDENTITY(1,1),
    fore_IdReporte INT NOT NULL FOREIGN KEY REFERENCES tbl_ReportesMascotas(rep_IdReporte) ON DELETE CASCADE,
    fore_Url VARCHAR(500) NOT NULL,
    fore_Orden INT DEFAULT 0,
    fore_FechaSubida DATETIME DEFAULT GETDATE()
);

-- Avistamientos (reportes de que alguien vio la mascota)
CREATE TABLE tbl_Avistamientos (
    avi_IdAvistamiento INT PRIMARY KEY IDENTITY(1,1),
    avi_IdReporte INT NOT NULL FOREIGN KEY REFERENCES tbl_ReportesMascotas(rep_IdReporte),
    avi_IdUsuario INT FOREIGN KEY REFERENCES tbl_Usuarios(usu_IdUsuario),
    avi_Ubicacion VARCHAR(300),
    avi_Descripcion TEXT,
    avi_FechaAvistamiento DATETIME,
    avi_FechaReporte DATETIME DEFAULT GETDATE()
);

-- ============================================================
-- MÓDULO 6: NOTIFICACIONES Y CAMPAÑAS
-- ============================================================

-- Notificaciones
CREATE TABLE tbl_Notificaciones (
    not_IdNotificacion INT PRIMARY KEY IDENTITY(1,1),
    not_IdUsuario INT NOT NULL FOREIGN KEY REFERENCES tbl_Usuarios(usu_IdUsuario),
    not_Titulo VARCHAR(150) NOT NULL,
    not_Mensaje TEXT,
    not_Tipo VARCHAR(30),  -- Adopcion, Reporte, Sistema, Campana
    not_Icono VARCHAR(50),
    not_UrlAccion VARCHAR(300),
    not_Leida BIT DEFAULT 0,
    not_FechaCreacion DATETIME DEFAULT GETDATE(),
    not_FechaLectura DATETIME
);

-- Campañas de Refugios
CREATE TABLE tbl_Campanias (
    cam_IdCampania INT PRIMARY KEY IDENTITY(1,1),
    cam_IdRefugio INT NOT NULL FOREIGN KEY REFERENCES tbl_Refugios(ref_IdRefugio),
    cam_Titulo VARCHAR(150) NOT NULL,
    cam_Descripcion TEXT,
    cam_TipoCampania VARCHAR(30),  -- Adopcion, Donacion, Voluntariado, Evento
    cam_ImagenUrl VARCHAR(500),
    cam_FechaInicio DATETIME,
    cam_FechaFin DATETIME,
    cam_Ubicacion VARCHAR(200),
    cam_Estado VARCHAR(20) DEFAULT 'Activa',  -- Borrador, Activa, Finalizada, Cancelada
    cam_FechaCreacion DATETIME DEFAULT GETDATE()
);



-- ============================================================
-- DATOS INICIALES
-- ============================================================

-- Roles
INSERT INTO tbl_Roles (rol_Nombre, rol_Descripcion, rol_Nivel) VALUES 
('SuperAdmin', 'Administrador global del sistema', 100),
('AdminRefugio', 'Administrador de un refugio específico', 50),
('Refugio', 'Usuario operativo de refugio', 30),
('Adoptante', 'Usuario que busca adoptar mascotas', 10);

-- Especies
INSERT INTO tbl_Especies (esp_Nombre, esp_Descripcion) VALUES 
('Perro', 'Canis lupus familiaris'),
('Gato', 'Felis catus'),
('Conejo', 'Oryctolagus cuniculus'),
('Ave', 'Aves domésticas'),
('Hámster', 'Cricetinae'),
('Otro', 'Otras especies');

-- Razas comunes de Perros
INSERT INTO tbl_Razas (raz_IdEspecie, raz_Nombre) VALUES 
(1, 'Mestizo'),
(1, 'Labrador Retriever'),
(1, 'Golden Retriever'),
(1, 'Pastor Alemán'),
(1, 'Bulldog'),
(1, 'Poodle'),
(1, 'Chihuahua'),
(1, 'Beagle'),
(1, 'Rottweiler'),
(1, 'Schnauzer');

-- Razas comunes de Gatos
INSERT INTO tbl_Razas (raz_IdEspecie, raz_Nombre) VALUES 
(2, 'Mestizo'),
(2, 'Siamés'),
(2, 'Persa'),
(2, 'Maine Coon'),
(2, 'Angora'),
(2, 'Bengalí');

-- Criterios de Evaluación para Adopción
INSERT INTO tbl_CriteriosEvaluacion (cri_Nombre, cri_Descripcion, cri_Peso, cri_Orden) VALUES 
('Tipo de Vivienda', 'Evaluación del espacio disponible para la mascota', 15.00, 1),
('Experiencia con Mascotas', 'Experiencia previa cuidando animales', 15.00, 2),
('Tiempo Disponible', 'Horas que puede dedicar a la mascota', 15.00, 3),
('Espacio Exterior', 'Disponibilidad de patio, jardín o áreas verdes cercanas', 15.00, 4),
('Compatibilidad Familiar', 'Situación familiar (niños, otras mascotas)', 10.00, 5),
('Estabilidad Económica', 'Capacidad para cubrir gastos veterinarios y alimentación', 15.00, 6),
('Motivación', 'Razones para adoptar y compromiso demostrado', 15.00, 7);


-- Usuario SuperAdmin inicial
-- Contraseña: admin123
-- El hash y salt fueron generados por CN_CryptoService
INSERT INTO tbl_Usuarios (
    usu_IdRol, 
    usu_Nombre, 
    usu_Apellido, 
    usu_Email, 
    usu_Contrasena,
    usu_Salt,
    usu_Estado, 
    usu_EmailVerificado
) VALUES (
    1,                      -- Rol SuperAdmin
    'Admin',
    'Test',
    'admin@test.com',
    '4dfc2fdb1f2a4e6e912d467da6bec325d5c2d97c0a0e9eb48c1b76fb3783d72b',  -- Hash SHA256 de 'admin123'
    '789c3e1d13b5fc0e28998407654a90a6',  -- Salt
    1,                      -- Activo
    1                       -- Email Verificado
);

GO

-- ============================================================
-- VISTAS PARA ESTADÍSTICAS
-- ============================================================

-- Vista: Estadísticas Generales del Sistema
CREATE VIEW vw_EstadisticasGenerales AS
SELECT 
    (SELECT COUNT(*) FROM tbl_Usuarios WHERE usu_Estado = 1) AS TotalUsuarios,
    (SELECT COUNT(*) FROM tbl_Usuarios WHERE usu_IdRol = 4 AND usu_Estado = 1) AS TotalAdoptantes,
    (SELECT COUNT(*) FROM tbl_Refugios WHERE ref_Estado = 1) AS TotalRefugios,
    (SELECT COUNT(*) FROM tbl_Refugios WHERE ref_Verificado = 1 AND ref_Estado = 1) AS RefugiosVerificados,
    (SELECT COUNT(*) FROM tbl_Mascotas WHERE mas_Estado = 1) AS TotalMascotas,
    (SELECT COUNT(*) FROM tbl_Mascotas WHERE mas_EstadoAdopcion = 'Disponible' AND mas_Estado = 1) AS MascotasDisponibles,
    (SELECT COUNT(*) FROM tbl_Mascotas WHERE mas_EstadoAdopcion = 'Adoptado') AS MascotasAdoptadas,
    (SELECT COUNT(*) FROM tbl_SolicitudesAdopcion WHERE sol_Estado = 'Pendiente') AS SolicitudesPendientes,
    (SELECT COUNT(*) FROM tbl_ReportesMascotas WHERE rep_Estado IN ('Reportado', 'EnBusqueda')) AS ReportesActivos;
GO

-- Vista: Estadísticas por Refugio
CREATE VIEW vw_EstadisticasPorRefugio AS
SELECT 
    r.ref_IdRefugio,
    r.ref_Nombre AS NombreRefugio,
    r.ref_Verificado,
    COUNT(DISTINCT m.mas_IdMascota) AS TotalMascotas,
    SUM(CASE WHEN m.mas_EstadoAdopcion = 'Disponible' THEN 1 ELSE 0 END) AS Disponibles,
    SUM(CASE WHEN m.mas_EstadoAdopcion = 'Adoptado' THEN 1 ELSE 0 END) AS Adoptadas,
    SUM(CASE WHEN m.mas_EstadoAdopcion = 'EnProceso' THEN 1 ELSE 0 END) AS EnProceso,
    (SELECT COUNT(*) FROM tbl_Usuarios u WHERE u.usu_IdRefugio = r.ref_IdRefugio AND u.usu_Estado = 1) AS TotalUsuarios
FROM tbl_Refugios r
LEFT JOIN tbl_Mascotas m ON r.ref_IdRefugio = m.mas_IdRefugio AND m.mas_Estado = 1
WHERE r.ref_Estado = 1
GROUP BY r.ref_IdRefugio, r.ref_Nombre, r.ref_Verificado;
GO

-- Vista: Mascotas con información completa
CREATE VIEW vw_MascotasCompleta AS
SELECT 
    m.mas_IdMascota,
    m.mas_Nombre,
    e.esp_Nombre AS Especie,
    r.raz_Nombre AS Raza,
    m.mas_Edad,
    m.mas_EdadAproximada,
    m.mas_Sexo,
    m.mas_Tamano,
    m.mas_Descripcion,
    m.mas_EstadoAdopcion,
    m.mas_Esterilizado,
    m.mas_Vacunado,
    ref.ref_Nombre AS Refugio,
    ref.ref_Ciudad AS CiudadRefugio,
    (SELECT TOP 1 fot_Url FROM tbl_FotosMascotas fm WHERE fm.fot_IdMascota = m.mas_IdMascota AND fm.fot_EsPrincipal = 1) AS FotoPrincipal,
    m.mas_FechaRegistro
FROM tbl_Mascotas m
INNER JOIN tbl_Refugios ref ON m.mas_IdRefugio = ref.ref_IdRefugio
LEFT JOIN tbl_Razas r ON m.mas_IdRaza = r.raz_IdRaza
LEFT JOIN tbl_Especies e ON r.raz_IdEspecie = e.esp_IdEspecie
WHERE m.mas_Estado = 1;
GO

-- Vista: Solicitudes con información completa
CREATE VIEW vw_SolicitudesCompleta AS
SELECT 
    s.sol_IdSolicitud,
    s.sol_FechaSolicitud,
    s.sol_Estado,
    s.sol_PuntajeTotal,
    -- Datos del adoptante
    u.usu_IdUsuario AS IdAdoptante,
    u.usu_Nombre + ' ' + ISNULL(u.usu_Apellido, '') AS NombreAdoptante,
    u.usu_Email AS EmailAdoptante,
    u.usu_Cedula,
    u.usu_Telefono AS TelefonoAdoptante,
    -- Datos de la mascota
    m.mas_IdMascota,
    m.mas_Nombre AS NombreMascota,
    -- Datos del refugio
    r.ref_IdRefugio,
    r.ref_Nombre AS NombreRefugio
FROM tbl_SolicitudesAdopcion s
INNER JOIN tbl_Usuarios u ON s.sol_IdUsuario = u.usu_IdUsuario
INNER JOIN tbl_Mascotas m ON s.sol_IdMascota = m.mas_IdMascota
INNER JOIN tbl_Refugios r ON m.mas_IdRefugio = r.ref_IdRefugio;
GO

-- Vista: Estadísticas mensuales de adopciones
CREATE VIEW vw_AdopcionesMensuales AS
SELECT 
    YEAR(mas_FechaAdopcion) AS Anio,
    MONTH(mas_FechaAdopcion) AS Mes,
    COUNT(*) AS TotalAdopciones
FROM tbl_Mascotas
WHERE mas_EstadoAdopcion = 'Adoptado' AND mas_FechaAdopcion IS NOT NULL
GROUP BY YEAR(mas_FechaAdopcion), MONTH(mas_FechaAdopcion);
GO

-- ============================================================
-- PROCEDIMIENTOS ALMACENADOS
-- ============================================================

-- Procedimiento: Calcular Puntaje de Evaluación con CURSOR
CREATE PROCEDURE sp_CalcularEvaluacionAdopcion
    @IdSolicitud INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @IdCriterio INT;
    DECLARE @Peso DECIMAL(5,2);
    DECLARE @Puntaje INT;
    DECLARE @PuntajeMaximo INT;
    DECLARE @PuntajeTotal DECIMAL(5,2) = 0;
    DECLARE @SumaPesos DECIMAL(5,2) = 0;
    
    -- Cursor para recorrer todos los criterios evaluados
    DECLARE cursorEvaluacion CURSOR FOR
        SELECT de.det_IdCriterio, ce.cri_Peso, de.det_Puntaje, ce.cri_PuntajeMaximo
        FROM tbl_DetalleEvaluacion de
        INNER JOIN tbl_CriteriosEvaluacion ce ON de.det_IdCriterio = ce.cri_IdCriterio
        WHERE de.det_IdSolicitud = @IdSolicitud AND ce.cri_Estado = 1;
    
    OPEN cursorEvaluacion;
    
    FETCH NEXT FROM cursorEvaluacion INTO @IdCriterio, @Peso, @Puntaje, @PuntajeMaximo;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Calcular puntaje ponderado: (Puntaje/PuntajeMaximo) * Peso
        SET @PuntajeTotal = @PuntajeTotal + (CAST(@Puntaje AS DECIMAL(5,2)) / @PuntajeMaximo * @Peso);
        SET @SumaPesos = @SumaPesos + @Peso;
        
        FETCH NEXT FROM cursorEvaluacion INTO @IdCriterio, @Peso, @Puntaje, @PuntajeMaximo;
    END
    
    CLOSE cursorEvaluacion;
    DEALLOCATE cursorEvaluacion;
    
    -- Normalizar si no se evaluaron todos los criterios
    IF @SumaPesos > 0
        SET @PuntajeTotal = (@PuntajeTotal / @SumaPesos) * 100;
    
    -- Actualizar puntaje en la solicitud
    UPDATE tbl_SolicitudesAdopcion
    SET sol_PuntajeTotal = @PuntajeTotal
    WHERE sol_IdSolicitud = @IdSolicitud;
    
    -- Retornar resultado
    SELECT 
        @IdSolicitud AS IdSolicitud,
        @PuntajeTotal AS PuntajeTotal,
        CASE 
            WHEN @PuntajeTotal >= 70 THEN 'APTO'
            WHEN @PuntajeTotal >= 50 THEN 'REQUIERE REVISION'
            ELSE 'NO APTO'
        END AS Resultado;
END;
GO

-- Procedimiento: Validar Login con control de intentos fallidos
CREATE PROCEDURE sp_ValidarLogin
    @Email VARCHAR(100),
    @Contrasena VARCHAR(255),
    @DireccionIP VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @IdUsuario INT;
    DECLARE @ContrasenaDB VARCHAR(255);
    DECLARE @Bloqueado BIT;
    DECLARE @IntentosFallidos INT;
    DECLARE @MaxIntentos INT = 3;
    
    -- Buscar usuario
    SELECT 
        @IdUsuario = usu_IdUsuario,
        @ContrasenaDB = usu_Contrasena,
        @Bloqueado = usu_Bloqueado,
        @IntentosFallidos = usu_IntentosFallidos
    FROM tbl_Usuarios 
    WHERE usu_Email = @Email AND usu_Estado = 1;
    
    -- Usuario no existe
    IF @IdUsuario IS NULL
    BEGIN
        SELECT 0 AS Exito, 'Credenciales inválidas' AS Mensaje, NULL AS IdUsuario;
        RETURN;
    END
    
    -- Verificar si está bloqueado (solo el administrador puede desbloquear)
    IF @Bloqueado = 1
    BEGIN
        SELECT 0 AS Exito, 
               'Cuenta bloqueada. Contacte al administrador para desbloquear su cuenta.' AS Mensaje, 
               NULL AS IdUsuario;
        RETURN;
    END
    
    -- Validar contraseña
    IF @ContrasenaDB = @Contrasena  -- En producción: usar función de hash para comparar
    BEGIN
        -- Login exitoso - resetear intentos fallidos
        UPDATE tbl_Usuarios 
        SET usu_IntentosFallidos = 0, usu_UltimoAcceso = GETDATE() 
        WHERE usu_IdUsuario = @IdUsuario;
        
        -- Registrar en auditoría
        INSERT INTO tbl_Auditoria (aud_IdUsuario, aud_Accion, aud_DireccionIP)
        VALUES (@IdUsuario, 'LOGIN', @DireccionIP);
        
        SELECT 1 AS Exito, 'Login exitoso' AS Mensaje, @IdUsuario AS IdUsuario;
    END
    ELSE
    BEGIN
        -- Contraseña incorrecta - incrementar intentos
        SET @IntentosFallidos = @IntentosFallidos + 1;
        
        IF @IntentosFallidos >= @MaxIntentos
        BEGIN
            -- Bloquear cuenta
            UPDATE tbl_Usuarios 
            SET usu_IntentosFallidos = @IntentosFallidos, 
                usu_Bloqueado = 1, 
                usu_FechaBloqueo = GETDATE()
            WHERE usu_IdUsuario = @IdUsuario;
            
            -- Registrar en auditoría
            INSERT INTO tbl_Auditoria (aud_IdUsuario, aud_Accion, aud_DireccionIP)
            VALUES (@IdUsuario, 'CUENTA_BLOQUEADA', @DireccionIP);
            
            SELECT 0 AS Exito, 
                   'Cuenta bloqueada por múltiples intentos fallidos. Contacte al administrador.' AS Mensaje, 
                   NULL AS IdUsuario;
        END
        ELSE
        BEGIN
            -- Solo incrementar contador
            UPDATE tbl_Usuarios 
            SET usu_IntentosFallidos = @IntentosFallidos 
            WHERE usu_IdUsuario = @IdUsuario;
            
            DECLARE @IntentosRestantes INT = @MaxIntentos - @IntentosFallidos;
            SELECT 0 AS Exito, 
                   'Credenciales inválidas. Intentos restantes: ' + CAST(@IntentosRestantes AS VARCHAR) AS Mensaje, 
                   NULL AS IdUsuario;
        END
    END
END;
GO

-- Procedimiento: Desbloquear cuenta (para admin)
CREATE PROCEDURE sp_DesbloquearCuenta
    @IdUsuario INT,
    @IdAdminUsuario INT
AS
BEGIN
    UPDATE tbl_Usuarios 
    SET usu_Bloqueado = 0, usu_IntentosFallidos = 0, usu_FechaBloqueo = NULL
    WHERE usu_IdUsuario = @IdUsuario;
    
    -- Registrar en auditoría
    INSERT INTO tbl_Auditoria (aud_IdUsuario, aud_Accion, aud_Tabla, aud_IdRegistro)
    VALUES (@IdAdminUsuario, 'DESBLOQUEO_CUENTA', 'tbl_Usuarios', @IdUsuario);
    
    SELECT 1 AS Exito, 'Cuenta desbloqueada correctamente' AS Mensaje;
END;
GO

-- Procedimiento: Insertar registro de Auditoría
CREATE PROCEDURE sp_RegistrarAuditoria
    @IdUsuario INT,
    @Accion VARCHAR(50),
    @Tabla VARCHAR(50),
    @IdRegistro INT,
    @ValorAnterior TEXT = NULL,
    @ValorNuevo TEXT = NULL,
    @DireccionIP VARCHAR(50) = NULL
AS
BEGIN
    INSERT INTO tbl_Auditoria (aud_IdUsuario, aud_Accion, aud_Tabla, aud_IdRegistro, aud_ValorAnterior, aud_ValorNuevo, aud_DireccionIP)
    VALUES (@IdUsuario, @Accion, @Tabla, @IdRegistro, @ValorAnterior, @ValorNuevo, @DireccionIP);
END;
GO

-- Procedimiento: Generar Token de Recuperación
CREATE PROCEDURE sp_GenerarTokenRecuperacion
    @Email VARCHAR(100),
    @Token VARCHAR(255) OUTPUT
AS
BEGIN
    DECLARE @IdUsuario INT;
    
    SELECT @IdUsuario = usu_IdUsuario FROM tbl_Usuarios WHERE usu_Email = @Email AND usu_Estado = 1;
    
    IF @IdUsuario IS NULL
    BEGIN
        SET @Token = NULL;
        RETURN;
    END
    
    -- Generar token único
    SET @Token = CONVERT(VARCHAR(255), NEWID());
    
    -- Invalidar tokens anteriores
    UPDATE tbl_TokensRecuperacion SET tok_Usado = 1 WHERE tok_IdUsuario = @IdUsuario AND tok_Usado = 0;
    
    -- Insertar nuevo token (válido por 24 horas)
    INSERT INTO tbl_TokensRecuperacion (tok_IdUsuario, tok_Token, tok_FechaExpiracion)
    VALUES (@IdUsuario, @Token, DATEADD(HOUR, 24, GETDATE()));
    
    SELECT @Token AS Token, @IdUsuario AS IdUsuario;
END;
GO

-- Procedimiento: Validar y usar Token de Recuperación
CREATE PROCEDURE sp_ValidarTokenRecuperacion
    @Token VARCHAR(255),
    @NuevaContrasena VARCHAR(255)
AS
BEGIN
    DECLARE @IdUsuario INT;
    DECLARE @IdToken INT;
    
    -- Buscar token válido
    SELECT @IdToken = tok_IdToken, @IdUsuario = tok_IdUsuario
    FROM tbl_TokensRecuperacion
    WHERE tok_Token = @Token 
      AND tok_Usado = 0 
      AND tok_FechaExpiracion > GETDATE();
    
    IF @IdUsuario IS NULL
    BEGIN
        SELECT 0 AS Exito, 'Token inválido o expirado' AS Mensaje;
        RETURN;
    END
    
    -- Actualizar contraseña
    UPDATE tbl_Usuarios SET usu_Contrasena = @NuevaContrasena WHERE usu_IdUsuario = @IdUsuario;
    
    -- Marcar token como usado
    UPDATE tbl_TokensRecuperacion SET tok_Usado = 1 WHERE tok_IdToken = @IdToken;
    
    SELECT 1 AS Exito, 'Contraseña actualizada correctamente' AS Mensaje;
END;
GO

-- Procedimiento: Obtener estadísticas del dashboard
CREATE PROCEDURE sp_ObtenerEstadisticasDashboard
    @IdRefugio INT = NULL  -- NULL para SuperAdmin (ve todo)
AS
BEGIN
    -- Estadísticas de mascotas
    SELECT 
        COUNT(*) AS TotalMascotas,
        SUM(CASE WHEN mas_EstadoAdopcion = 'Disponible' THEN 1 ELSE 0 END) AS Disponibles,
        SUM(CASE WHEN mas_EstadoAdopcion = 'EnProceso' THEN 1 ELSE 0 END) AS EnProceso,
        SUM(CASE WHEN mas_EstadoAdopcion = 'Adoptado' THEN 1 ELSE 0 END) AS Adoptadas
    FROM tbl_Mascotas
    WHERE mas_Estado = 1 AND (@IdRefugio IS NULL OR mas_IdRefugio = @IdRefugio);
    
    -- Estadísticas de solicitudes
    SELECT 
        COUNT(*) AS TotalSolicitudes,
        SUM(CASE WHEN sol_Estado = 'Pendiente' THEN 1 ELSE 0 END) AS Pendientes,
        SUM(CASE WHEN sol_Estado = 'Aprobada' THEN 1 ELSE 0 END) AS Aprobadas,
        SUM(CASE WHEN sol_Estado = 'Rechazada' THEN 1 ELSE 0 END) AS Rechazadas
    FROM tbl_SolicitudesAdopcion s
    INNER JOIN tbl_Mascotas m ON s.sol_IdMascota = m.mas_IdMascota
    WHERE @IdRefugio IS NULL OR m.mas_IdRefugio = @IdRefugio;
    
    -- Adopciones de los últimos 6 meses
    SELECT 
        FORMAT(mas_FechaAdopcion, 'yyyy-MM') AS Periodo,
        COUNT(*) AS Cantidad
    FROM tbl_Mascotas
    WHERE mas_EstadoAdopcion = 'Adoptado' 
      AND mas_FechaAdopcion >= DATEADD(MONTH, -6, GETDATE())
      AND (@IdRefugio IS NULL OR mas_IdRefugio = @IdRefugio)
    GROUP BY FORMAT(mas_FechaAdopcion, 'yyyy-MM')
    ORDER BY Periodo;
END;
GO

-- Procedimiento: Evaluar candidato con matriz (usando cursor)
CREATE PROCEDURE sp_EvaluarCandidatoCompleto
    @IdSolicitud INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Variables para el cursor
    DECLARE @IdCriterio INT;
    DECLARE @NombreCriterio VARCHAR(100);
    DECLARE @Peso DECIMAL(5,2);
    DECLARE @Puntaje INT;
    DECLARE @PuntajeMaximo INT;
    DECLARE @PuntajePonderado DECIMAL(5,2);
    
    -- Tabla temporal para la matriz de resultados
    CREATE TABLE #MatrizEvaluacion (
        Criterio VARCHAR(100),
        Peso DECIMAL(5,2),
        Puntaje INT,
        PuntajeMax INT,
        PuntajePonderado DECIMAL(5,2)
    );
    
    DECLARE @PuntajeTotal DECIMAL(5,2) = 0;
    
    -- Cursor para llenar la matriz
    DECLARE cursorMatriz CURSOR FOR
        SELECT ce.cri_IdCriterio, ce.cri_Nombre, ce.cri_Peso, ISNULL(de.det_Puntaje, 0), ce.cri_PuntajeMaximo
        FROM tbl_CriteriosEvaluacion ce
        LEFT JOIN tbl_DetalleEvaluacion de ON ce.cri_IdCriterio = de.det_IdCriterio AND de.det_IdSolicitud = @IdSolicitud
        WHERE ce.cri_Estado = 1
        ORDER BY ce.cri_Orden;
    
    OPEN cursorMatriz;
    FETCH NEXT FROM cursorMatriz INTO @IdCriterio, @NombreCriterio, @Peso, @Puntaje, @PuntajeMaximo;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @PuntajePonderado = (CAST(@Puntaje AS DECIMAL(5,2)) / @PuntajeMaximo) * @Peso;
        SET @PuntajeTotal = @PuntajeTotal + @PuntajePonderado;
        
        INSERT INTO #MatrizEvaluacion VALUES (@NombreCriterio, @Peso, @Puntaje, @PuntajeMaximo, @PuntajePonderado);
        
        FETCH NEXT FROM cursorMatriz INTO @IdCriterio, @NombreCriterio, @Peso, @Puntaje, @PuntajeMaximo;
    END
    
    CLOSE cursorMatriz;
    DEALLOCATE cursorMatriz;
    
    -- Actualizar puntaje total
    UPDATE tbl_SolicitudesAdopcion SET sol_PuntajeTotal = @PuntajeTotal WHERE sol_IdSolicitud = @IdSolicitud;
    
    -- Mostrar matriz de evaluación
    SELECT * FROM #MatrizEvaluacion;
    
    -- Mostrar resultado final
    SELECT 
        @IdSolicitud AS IdSolicitud,
        @PuntajeTotal AS PuntajeTotal,
        CASE 
            WHEN @PuntajeTotal >= 70 THEN 'APTO PARA ADOPCIÓN'
            WHEN @PuntajeTotal >= 50 THEN 'REQUIERE EVALUACIÓN ADICIONAL'
            ELSE 'NO APTO PARA ADOPCIÓN'
        END AS Resultado,
        CASE 
            WHEN @PuntajeTotal >= 70 THEN 'Se recomienda aprobar la solicitud'
            WHEN @PuntajeTotal >= 50 THEN 'Se sugiere realizar entrevista presencial'
            ELSE 'Se recomienda rechazar la solicitud'
        END AS Recomendacion;
    
    DROP TABLE #MatrizEvaluacion;
END;
GO

-- ============================================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- ============================================================

CREATE INDEX IX_Usuarios_Email ON tbl_Usuarios(usu_Email);
CREATE INDEX IX_Usuarios_IdRol ON tbl_Usuarios(usu_IdRol);
CREATE INDEX IX_Usuarios_IdRefugio ON tbl_Usuarios(usu_IdRefugio);
CREATE INDEX IX_Mascotas_IdRefugio ON tbl_Mascotas(mas_IdRefugio);
CREATE INDEX IX_Mascotas_EstadoAdopcion ON tbl_Mascotas(mas_EstadoAdopcion);
CREATE INDEX IX_Mascotas_IdRaza ON tbl_Mascotas(mas_IdRaza);
CREATE INDEX IX_SolicitudesAdopcion_Estado ON tbl_SolicitudesAdopcion(sol_Estado);
CREATE INDEX IX_SolicitudesAdopcion_IdMascota ON tbl_SolicitudesAdopcion(sol_IdMascota);
CREATE INDEX IX_SolicitudesAdopcion_IdUsuario ON tbl_SolicitudesAdopcion(sol_IdUsuario);
CREATE INDEX IX_Notificaciones_IdUsuario ON tbl_Notificaciones(not_IdUsuario);
CREATE INDEX IX_Notificaciones_Leida ON tbl_Notificaciones(not_Leida);
CREATE INDEX IX_ReportesMascotas_Estado ON tbl_ReportesMascotas(rep_Estado);

CREATE INDEX IX_Auditoria_Fecha ON tbl_Auditoria(aud_Fecha);
GO

PRINT '¡Base de datos RedPatitas creada exitosamente!';
GO

-- ============================================================
-- SCRIPTS DE MIGRACIÓN
-- (Para bases de datos existentes que necesitan actualizarse)
-- ============================================================

-- Migración: Reemplazar campo usu_Direccion por coordenadas geográficas
-- Fecha: 2026-01-14
-- Descripción: Agrega campos de latitud y longitud para geolocalización
--              y elimina el campo de dirección de texto

-- Paso 1: Agregar nuevos campos de coordenadas
ALTER TABLE tbl_Usuarios ADD usu_Latitud DECIMAL(10,8) NULL;
GO
ALTER TABLE tbl_Usuarios ADD usu_Longitud DECIMAL(11,8) NULL;
GO

-- Paso 2: Eliminar campo de dirección de usuarios (ya no se usa)
-- NOTA: Ejecutar solo después de verificar que no hay datos importantes en usu_Direccion
ALTER TABLE tbl_Usuarios DROP COLUMN usu_Direccion;
GO

-- Paso 3: Agregar coordenadas a tabla de refugios (conservando ref_Direccion)
ALTER TABLE tbl_Refugios ADD ref_Latitud DECIMAL(10,8) NULL;
GO
ALTER TABLE tbl_Refugios ADD ref_Longitud DECIMAL(11,8) NULL;
GO

PRINT 'Migración completada: Campos de geolocalización agregados a tbl_Usuarios y tbl_Refugios';
GO


-- =============================================
-- Migración: Agregar campos de redes sociales y donación a tbl_Refugios
-- Fecha: 2026-01-22
-- Descripción: Agrega columnas para Facebook, Instagram, horario de atención y cuenta de donación
-- =============================================

USE RedPatitas;
GO

-- Agregar columna para URL de Facebook
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.tbl_Refugios') AND name = 'ref_FacebookUrl')
BEGIN
    ALTER TABLE dbo.tbl_Refugios
    ADD ref_FacebookUrl VARCHAR(300) NULL;
    PRINT 'Columna ref_FacebookUrl agregada correctamente.';
END
ELSE
BEGIN
    PRINT 'Columna ref_FacebookUrl ya existe.';
END
GO

-- Agregar columna para URL de Instagram
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.tbl_Refugios') AND name = 'ref_InstagramUrl')
BEGIN
    ALTER TABLE dbo.tbl_Refugios
    ADD ref_InstagramUrl VARCHAR(300) NULL;
    PRINT 'Columna ref_InstagramUrl agregada correctamente.';
END
ELSE
BEGIN
    PRINT 'Columna ref_InstagramUrl ya existe.';
END
GO

-- Agregar columna para horario de atención
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.tbl_Refugios') AND name = 'ref_HorarioAtencion')
BEGIN
    ALTER TABLE dbo.tbl_Refugios
    ADD ref_HorarioAtencion VARCHAR(200) NULL;
    PRINT 'Columna ref_HorarioAtencion agregada correctamente.';
END
ELSE
BEGIN
    PRINT 'Columna ref_HorarioAtencion ya existe.';
END
GO

-- Agregar columna para cuenta/enlace de donación
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.tbl_Refugios') AND name = 'ref_CuentaDonacion')
BEGIN
    ALTER TABLE dbo.tbl_Refugios
    ADD ref_CuentaDonacion VARCHAR(500) NULL;
    PRINT 'Columna ref_CuentaDonacion agregada correctamente.';
END
ELSE
BEGIN
    PRINT 'Columna ref_CuentaDonacion ya existe.';
END
GO

PRINT '========================================';
PRINT 'Migración completada exitosamente.';
PRINT 'Nuevas columnas en tbl_Refugios:';
PRINT '  - ref_FacebookUrl (VARCHAR 300)';
PRINT '  - ref_InstagramUrl (VARCHAR 300)';
PRINT '  - ref_HorarioAtencion (VARCHAR 200)';
PRINT '  - ref_CuentaDonacion (VARCHAR 500)';
PRINT '========================================';
GO

-- =============================================
-- Migración: Agregar campos de geolocalización a tbl_Avistamientos
-- Fecha: 2026-02-07
-- Descripción: Agrega coordenadas y foto de prueba para avistamientos en el mapa
-- =============================================

USE RedPatitas;
GO

-- Agregar columna para latitud del avistamiento
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.tbl_Avistamientos') AND name = 'avi_Latitud')
BEGIN
    ALTER TABLE dbo.tbl_Avistamientos
    ADD avi_Latitud DECIMAL(10,8) NULL;
    PRINT 'Columna avi_Latitud agregada correctamente.';
END
ELSE
BEGIN
    PRINT 'Columna avi_Latitud ya existe.';
END
GO

-- Agregar columna para longitud del avistamiento
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.tbl_Avistamientos') AND name = 'avi_Longitud')
BEGIN
    ALTER TABLE dbo.tbl_Avistamientos
    ADD avi_Longitud DECIMAL(11,8) NULL;
    PRINT 'Columna avi_Longitud agregada correctamente.';
END
ELSE
BEGIN
    PRINT 'Columna avi_Longitud ya existe.';
END
GO

-- Agregar columna para URL de foto del avistamiento
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.tbl_Avistamientos') AND name = 'avi_FotoUrl')
BEGIN
    ALTER TABLE dbo.tbl_Avistamientos
    ADD avi_FotoUrl VARCHAR(500) NULL;
    PRINT 'Columna avi_FotoUrl agregada correctamente.';
END
ELSE
BEGIN
    PRINT 'Columna avi_FotoUrl ya existe.';
END
GO

-- Crear índice para búsquedas geográficas de avistamientos
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.tbl_Avistamientos') AND name = 'IX_Avistamientos_Coordenadas')
BEGIN
    CREATE INDEX IX_Avistamientos_Coordenadas ON tbl_Avistamientos(avi_Latitud, avi_Longitud);
    PRINT 'Índice IX_Avistamientos_Coordenadas creado.';
END
GO

PRINT '========================================';
PRINT 'Migración completada exitosamente.';
PRINT 'Nuevas columnas en tbl_Avistamientos:';
PRINT '  - avi_Latitud (DECIMAL 10,8)';
PRINT '  - avi_Longitud (DECIMAL 11,8)';
PRINT '  - avi_FotoUrl (VARCHAR 500)';
PRINT '========================================';
GO
