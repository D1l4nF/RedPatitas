-- ============================================================
-- DATOS DE DEMOSTRACIÓN - RedPatitas
-- Ejecutar en SQL Server después de crear la BD
-- ============================================================

USE RedPatitas;
GO

-- ============================================================
-- 1. VERIFICAR QUE EXISTAN ESPECIES Y RAZAS
-- ============================================================
-- Las razas de PERRO son: 1=Mestizo, 2=Labrador, 3=Golden, 4=Pastor, 5=Bulldog, 6=Poodle, 7=Chihuahua, 8=Beagle
-- Las razas de GATO son: 11=Mestizo, 12=Siamés, 13=Persa, 14=Maine Coon, 15=Angora, 16=Bengalí

-- ============================================================
-- 2. INSERTAR REFUGIO DE PRUEBA (si no existe)
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM tbl_Refugios WHERE ref_Nombre = 'Refugio Patitas Felices')
BEGIN
    INSERT INTO tbl_Refugios (
        ref_Nombre, 
        ref_Descripcion, 
        ref_Direccion, 
        ref_Ciudad, 
        ref_Telefono, 
        ref_Email, 
        ref_Verificado, 
        ref_Estado,
        ref_Latitud,
        ref_Longitud
    ) VALUES (
        'Refugio Patitas Felices',
        'Refugio dedicado al rescate y adopción de mascotas abandonadas en Quito.',
        'Av. Amazonas N24-85 y Colón',
        'Quito',
        '0991234567',
        'patitasfelices@example.com',
        1,  -- Verificado
        1,  -- Activo
        -0.1807,
        -78.4678
    );
    PRINT 'Refugio Patitas Felices insertado.';
END

-- Segundo refugio
IF NOT EXISTS (SELECT 1 FROM tbl_Refugios WHERE ref_Nombre = 'Refugio Esperanza Animal')
BEGIN
    INSERT INTO tbl_Refugios (
        ref_Nombre, 
        ref_Descripcion, 
        ref_Direccion, 
        ref_Ciudad, 
        ref_Telefono, 
        ref_Email, 
        ref_Verificado, 
        ref_Estado
    ) VALUES (
        'Refugio Esperanza Animal',
        'Fundación dedicada a la protección y adopción responsable.',
        'Calle Principal 123',
        'Guayaquil',
        '0998765432',
        'esperanza@example.com',
        1,
        1
    );
    PRINT 'Refugio Esperanza Animal insertado.';
END
GO

-- ============================================================
-- 3. INSERTAR MASCOTAS DE PRUEBA
-- ============================================================

-- Obtener IDs de refugios
DECLARE @IdRefugio1 INT = (SELECT TOP 1 ref_IdRefugio FROM tbl_Refugios WHERE ref_Estado = 1 ORDER BY ref_IdRefugio);
DECLARE @IdRefugio2 INT = (SELECT TOP 1 ref_IdRefugio FROM tbl_Refugios WHERE ref_Estado = 1 ORDER BY ref_IdRefugio DESC);

-- Mascota 1: Max - Perro Mestizo Grande
IF NOT EXISTS (SELECT 1 FROM tbl_Mascotas WHERE mas_Nombre = 'Max')
BEGIN
    INSERT INTO tbl_Mascotas (
        mas_IdRefugio, mas_IdRaza, mas_Nombre, mas_Edad, mas_EdadAproximada,
        mas_Sexo, mas_Tamano, mas_Peso, mas_Color, mas_Descripcion, mas_Temperamento,
        mas_Esterilizado, mas_Vacunado, mas_Desparasitado, mas_EstadoAdopcion, mas_Estado, mas_FechaRegistro
    ) VALUES (
        @IdRefugio1,
        1,  -- Mestizo (Perro)
        'Max',
        24,
        'Adulto',
        'M',
        'Grande',
        25.5,
        'Café con manchas blancas',
        'Max es un perro muy cariñoso y leal. Fue rescatado de la calle y ahora busca una familia amorosa. Le encanta jugar y pasear al aire libre.',
        'Juguetón, Cariñoso, Protector',
        1, 1, 1,
        'Disponible',
        1,
        DATEADD(DAY, -5, GETDATE())
    );
    PRINT 'Max insertado.';
END

-- Mascota 2: Luna - Gata Mestiza
IF NOT EXISTS (SELECT 1 FROM tbl_Mascotas WHERE mas_Nombre = 'Luna')
BEGIN
    INSERT INTO tbl_Mascotas (
        mas_IdRefugio, mas_IdRaza, mas_Nombre, mas_Edad, mas_EdadAproximada,
        mas_Sexo, mas_Tamano, mas_Peso, mas_Color, mas_Descripcion, mas_Temperamento,
        mas_Esterilizado, mas_Vacunado, mas_Desparasitado, mas_EstadoAdopcion, mas_Estado, mas_FechaRegistro
    ) VALUES (
        @IdRefugio1,
        11, -- Mestizo (Gato)
        'Luna',
        12,
        'Joven',
        'F',
        'Pequeño',
        3.5,
        'Gris atigrada',
        'Luna es una gatita tranquila y muy independiente. Le gusta observar desde la ventana y ronronea cuando la acarician. Ideal para un hogar tranquilo.',
        'Tranquila, Independiente, Cariñosa',
        1, 1, 1,
        'Disponible',
        1,
        DATEADD(DAY, -2, GETDATE())
    );
    PRINT 'Luna insertada.';
END

-- Mascota 3: Rocky - Labrador Cachorro
IF NOT EXISTS (SELECT 1 FROM tbl_Mascotas WHERE mas_Nombre = 'Rocky')
BEGIN
    INSERT INTO tbl_Mascotas (
        mas_IdRefugio, mas_IdRaza, mas_Nombre, mas_Edad, mas_EdadAproximada,
        mas_Sexo, mas_Tamano, mas_Peso, mas_Color, mas_Descripcion, mas_Temperamento,
        mas_Esterilizado, mas_Vacunado, mas_Desparasitado, mas_EstadoAdopcion, mas_Estado, mas_FechaRegistro
    ) VALUES (
        @IdRefugio2,
        2,  -- Labrador
        'Rocky',
        4,
        'Cachorro',
        'M',
        'Mediano',
        8.0,
        'Negro',
        'Rocky es un cachorro adorable lleno de energía. Es muy juguetón y le encanta morder todo lo que encuentra. Necesita una familia con tiempo para entrenarlo.',
        'Juguetón, Activo, Curioso',
        0, 1, 1,
        'Disponible',
        1,
        DATEADD(DAY, -1, GETDATE())
    );
    PRINT 'Rocky insertado.';
END

-- Mascota 4: Michi - Siamés Senior
IF NOT EXISTS (SELECT 1 FROM tbl_Mascotas WHERE mas_Nombre = 'Michi')
BEGIN
    INSERT INTO tbl_Mascotas (
        mas_IdRefugio, mas_IdRaza, mas_Nombre, mas_Edad, mas_EdadAproximada,
        mas_Sexo, mas_Tamano, mas_Peso, mas_Color, mas_Descripcion, mas_Temperamento,
        mas_Esterilizado, mas_Vacunado, mas_Desparasitado, mas_EstadoAdopcion, mas_Estado, mas_FechaRegistro
    ) VALUES (
        @IdRefugio1,
        12, -- Siamés
        'Michi',
        96,
        'Senior',
        'M',
        'Mediano',
        4.5,
        'Crema con puntas oscuras',
        'Michi es un gato siamés mayor que busca un hogar tranquilo para pasar sus años dorados. Es muy cariñoso y le gusta dormir en lugares cálidos.',
        'Tranquilo, Cariñoso, Hogareño',
        1, 1, 1,
        'Disponible',
        1,
        DATEADD(DAY, -10, GETDATE())
    );
    PRINT 'Michi insertado.';
END

-- Mascota 5: Coco - Chihuahua
IF NOT EXISTS (SELECT 1 FROM tbl_Mascotas WHERE mas_Nombre = 'Coco')
BEGIN
    INSERT INTO tbl_Mascotas (
        mas_IdRefugio, mas_IdRaza, mas_Nombre, mas_Edad, mas_EdadAproximada,
        mas_Sexo, mas_Tamano, mas_Peso, mas_Color, mas_Descripcion, mas_Temperamento,
        mas_Esterilizado, mas_Vacunado, mas_Desparasitado, mas_EstadoAdopcion, mas_Estado, mas_FechaRegistro
    ) VALUES (
        @IdRefugio2,
        7,  -- Chihuahua
        'Coco',
        36,
        'Adulto',
        'F',
        'Pequeño',
        2.0,
        'Café claro',
        'Coco es una chihuahua muy cariñosa y protectora. Le encanta estar en brazos y es ideal para departamentos.',
        'Cariñosa, Protectora, Fiel',
        1, 1, 1,
        'Disponible',
        1,
        DATEADD(DAY, -3, GETDATE())
    );
    PRINT 'Coco insertada.';
END

-- Mascota 6: Toby - Beagle
IF NOT EXISTS (SELECT 1 FROM tbl_Mascotas WHERE mas_Nombre = 'Toby')
BEGIN
    INSERT INTO tbl_Mascotas (
        mas_IdRefugio, mas_IdRaza, mas_Nombre, mas_Edad, mas_EdadAproximada,
        mas_Sexo, mas_Tamano, mas_Peso, mas_Color, mas_Descripcion, mas_Temperamento,
        mas_Esterilizado, mas_Vacunado, mas_Desparasitado, mas_EstadoAdopcion, mas_Estado, mas_FechaRegistro
    ) VALUES (
        @IdRefugio1,
        8,  -- Beagle
        'Toby',
        18,
        'Joven',
        'M',
        'Mediano',
        12.0,
        'Tricolor (blanco, negro y café)',
        'Toby es un beagle alegre y juguetón. Le encanta olfatear todo y seguir rastros. Muy bueno con niños.',
        'Alegre, Curioso, Sociable',
        1, 1, 1,
        'Disponible',
        1,
        DATEADD(DAY, -7, GETDATE())
    );
    PRINT 'Toby insertado.';
END
GO

-- ============================================================
-- VERIFICAR INSERCIÓN
-- ============================================================
SELECT 'REFUGIOS:' AS Tabla, COUNT(*) AS Total FROM tbl_Refugios WHERE ref_Estado = 1;
SELECT 'MASCOTAS DISPONIBLES:' AS Tabla, COUNT(*) AS Total FROM tbl_Mascotas WHERE mas_Estado = 1 AND mas_EstadoAdopcion = 'Disponible';

-- Ver mascotas insertadas
SELECT 
    mas_IdMascota AS ID,
    mas_Nombre AS Nombre,
    mas_EdadAproximada AS Edad,
    mas_Tamano AS Tamano,
    mas_EstadoAdopcion AS Estado
FROM tbl_Mascotas
WHERE mas_Estado = 1
ORDER BY mas_FechaRegistro DESC;

PRINT '';
PRINT '✅ Datos de demostración insertados correctamente!';
PRINT '   Ahora puedes entrar como adoptante y ver las mascotas.';
