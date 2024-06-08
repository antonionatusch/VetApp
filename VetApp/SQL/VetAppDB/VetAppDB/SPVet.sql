-- Procedimiento para generar un reporte de ConsumosVet entre dos fechas con precio total
CREATE PROCEDURE GenerateReportWithTotalPrice
    @fechaInicio DATE,
    @fechaFin DATE,
    @resultado INT OUTPUT
AS
BEGIN
    BEGIN TRY
        -- Obtener datos de ConsumosVet con cálculo de precio total
        SELECT 
            cv.codMascota,
            m.nombre AS nombreMascota,
            c.apellido AS cliente,
            cv.idServicio,
            s.nombre AS nombreServicio,
            cv.observaciones,
            cv.cantVacunas,
            cv.nit,
            apv.fechaPrevista AS fecha,
            (
                s.precio -- Precio del servicio base (consulta o aplicación de vacuna)
                + ISNULL((
                    SELECT SUM(v.precioUnitario)
                    FROM Vacunas v
                    WHERE v.codVacuna = cv.codVacuna
                ), 0) -- Suma de los precios de las vacunas aplicadas
            ) AS precioTotal
        FROM 
            ConsumosVet cv
            JOIN Mascotas m ON cv.codMascota = m.codMascota
            JOIN Clientes c ON m.codCliente = c.codCliente
            JOIN Servicios s ON cv.idServicio = s.idServicio
            LEFT JOIN AplicaVacuna apv ON cv.codMascota = apv.codMascota AND cv.codVacuna = apv.codVacuna
        WHERE 
            apv.fechaPrevista BETWEEN @fechaInicio AND @fechaFin
        
        UNION
        
        -- Obtener datos de Consultas
        SELECT 
            con.codMascota,
            m.nombre AS nombreMascota,
            c.apellido AS cliente,
            'CG000' AS idServicio,
            'ConsultaGeneral' AS nombreServicio,
            con.diagnostico AS observaciones,
            0 AS cantVacunas,
            '' AS nit,
            con.fechaConsulta AS fecha,
            (SELECT precio FROM Servicios WHERE idServicio = 'CG000') AS precioTotal
        FROM 
            Consultas con
            JOIN Mascotas m ON con.codMascota = m.codMascota
            JOIN Clientes c ON m.codCliente = c.codCliente
        WHERE 
            con.fechaConsulta BETWEEN @fechaInicio AND @fechaFin
        
        ORDER BY 
            fecha;

        SET @resultado = 1 -- Éxito
    END TRY
    BEGIN CATCH
        SET @resultado = -1 -- Error
    END CATCH
END


/* Probando

DECLARE @resultado INT;

EXEC GenerateReportWithTotalPrice @fechaInicio = '2024-01-01', @fechaFin = '2024-12-31', @resultado = @resultado OUTPUT;

SELECT @resultado AS Resultado;


*/


-- Procedimiento para generar un reporte de ConsumosVet y Consultas para una mascota específica con precio total
-- Procedimiento para generar un reporte de ConsumosVet y Consultas para una mascota específica con precio total
CREATE PROCEDURE GenerateReportByPet
    @codMascota CHAR(20),
    @resultado INT OUTPUT
AS
BEGIN
    BEGIN TRY
        -- Obtener datos de ConsumosVet con cálculo de precio total
        SELECT 
            cv.codMascota,
            m.nombre AS nombreMascota,
            c.apellido AS cliente,
            cv.idServicio,
            s.nombre AS nombreServicio,
            cv.observaciones,
            cv.cantVacunas,
            cv.nit,
            apv.fechaPrevista AS fecha,
            (
                s.precio -- Precio del servicio base (consulta o aplicación de vacuna)
                + ISNULL((
                    SELECT SUM(v.precioUnitario)
                    FROM Vacunas v
                    WHERE v.codVacuna = cv.codVacuna
                ), 0) -- Suma de los precios de las vacunas aplicadas
            ) AS precioTotal
        FROM 
            ConsumosVet cv
            JOIN Mascotas m ON cv.codMascota = m.codMascota
            JOIN Clientes c ON m.codCliente = c.codCliente
            JOIN Servicios s ON cv.idServicio = s.idServicio
            LEFT JOIN AplicaVacuna apv ON cv.codMascota = apv.codMascota AND cv.codVacuna = apv.codVacuna
        WHERE 
            cv.codMascota = @codMascota
        
        UNION
        
        -- Obtener datos de Consultas
        SELECT 
            con.codMascota,
            m.nombre AS nombreMascota,
            c.apellido AS cliente,
            'CG000' AS idServicio,
            'ConsultaGeneral' AS nombreServicio,
            con.diagnostico AS observaciones,
            0 AS cantVacunas,
            '' AS nit,
            con.fechaConsulta AS fecha,
            (SELECT precio FROM Servicios WHERE idServicio = 'CG000') AS precioTotal
        FROM 
            Consultas con
            JOIN Mascotas m ON con.codMascota = m.codMascota
            JOIN Clientes c ON m.codCliente = c.codCliente
        WHERE 
            con.codMascota = @codMascota
        
        ORDER BY 
            fecha;

        SET @resultado = 1 -- Éxito
    END TRY
    BEGIN CATCH
        SET @resultado = -1 -- Error
    END CATCH
END


/*
Probando

DECLARE @resultado INT;

EXEC GenerateReportByPet @codMascota = 'M001', @resultado = @resultado OUTPUT;

SELECT @resultado AS Resultado;



*/
-- insercion asociacion

CREATE PROCEDURE PersonaCliente_Insert
    @CodCliente nvarchar(20),
    @Ci nvarchar(20),
    @FechaAsociacion date
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM PersonaCliente WHERE CodCliente = @CodCliente AND Ci = @Ci)
    BEGIN
        INSERT INTO PersonaCliente (CodCliente, Ci, FechaAsociacion)
        VALUES (@CodCliente, @Ci, @FechaAsociacion);
    END
    ELSE
    BEGIN
        RAISERROR('La asociación ya existe.', 16, 1);
    END
END

SELECT * FROM Personas
SELECT * FROM Clientes
SELECT * FROM PersonaCliente
/*
-- Inserta una nueva asociación
EXEC PersonaCliente_Insert @CodCliente = 'C001', @Ci = '23232', @FechaAsociacion = '2024-06-07';
*/

CREATE PROCEDURE PersonaCliente_Update
    @CodCliente nvarchar(20),
    @Ci nvarchar(20),
    @FechaAsociacion date
AS
BEGIN
    UPDATE PersonaCliente
    SET FechaAsociacion = @FechaAsociacion
    WHERE CodCliente = @CodCliente AND Ci = @Ci;
END

SELECT * FROM PersonaCliente
/*
-- Actualiza la fecha de asociación
EXEC PersonaCliente_Update @CodCliente = 'C001', @Ci = '23232', @FechaAsociacion = '2024-07-01';
*/

CREATE PROCEDURE PersonaCliente_Delete
    @CodCliente nvarchar(20),
    @Ci nvarchar(20)
AS
BEGIN
    DELETE FROM PersonaCliente
    WHERE CodCliente = @CodCliente AND Ci = @Ci;
END

/*
-- Elimina la asociación
EXEC PersonaCliente_Delete @CodCliente = 'C001', @Ci = '23232';
*/


CREATE PROCEDURE InsertPersona
    @Ci VARCHAR(20),
    @Nombre VARCHAR(80),
    @Telefono VARCHAR(50),
    @Correo VARCHAR(50),
    @Direccion VARCHAR(60)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Personas WHERE ci = @Ci)
    BEGIN
        RAISERROR('La persona ya está registrada.', 16, 1);
        RETURN;
    END

    DECLARE @ErrorMessages NVARCHAR(MAX) = '';

    IF LEN(@Ci) > 20
        SET @ErrorMessages = @ErrorMessages + 'ci, ';
    IF LEN(@Nombre) > 80
        SET @ErrorMessages = @ErrorMessages + 'nombre, ';
    IF LEN(@Telefono) > 50
        SET @ErrorMessages = @ErrorMessages + 'telefono, ';
    IF LEN(@Correo) > 50
        SET @ErrorMessages = @ErrorMessages + 'correo, ';
    IF LEN(@Direccion) > 60
        SET @ErrorMessages = @ErrorMessages + 'direccion, ';

    IF @ErrorMessages <> ''
    BEGIN
        SET @ErrorMessages = 'Los campos ' + LEFT(@ErrorMessages, LEN(@ErrorMessages) - 2) + ' se excedieron.';
        RAISERROR(@ErrorMessages, 16, 1);
        RETURN;
    END

    INSERT INTO Personas (ci, nombre, telefono, correo, direccion)
    VALUES (@Ci, @Nombre, @Telefono, @Correo, @Direccion);
END
GO

CREATE PROCEDURE UpdatePersona
    @Ci VARCHAR(20),
    @Nombre VARCHAR(80),
    @Telefono VARCHAR(50),
    @Correo VARCHAR(50),
    @Direccion VARCHAR(60)
AS
BEGIN
    DECLARE @ErrorMessages NVARCHAR(MAX) = '';

    IF LEN(@Ci) > 20
        SET @ErrorMessages = @ErrorMessages + 'ci, ';
    IF LEN(@Nombre) > 80
        SET @ErrorMessages = @ErrorMessages + 'nombre, ';
    IF LEN(@Telefono) > 50
        SET @ErrorMessages = @ErrorMessages + 'telefono, ';
    IF LEN(@Correo) > 50
        SET @ErrorMessages = @ErrorMessages + 'correo, ';
    IF LEN(@Direccion) > 60
        SET @ErrorMessages = @ErrorMessages + 'direccion, ';

    IF @ErrorMessages <> ''
    BEGIN
        SET @ErrorMessages = 'Los campos ' + LEFT(@ErrorMessages, LEN(@ErrorMessages) - 2) + ' se excedieron.';
        THROW 50000, @ErrorMessages, 1;
    END

    IF NOT EXISTS (SELECT 1 FROM Personas WHERE Ci = @Ci)
    BEGIN
        RAISERROR('La persona no está registrada.', 16, 1);
        RETURN;
    END

    UPDATE Personas
    SET Nombre = @Nombre,
        Telefono = @Telefono,
        Correo = @Correo,
        Direccion = @Direccion
    WHERE Ci = @Ci;
END



CREATE PROCEDURE DeletePersona
    @Ci VARCHAR(20)
AS
BEGIN
    DELETE FROM Personas
    WHERE ci = @Ci;
END

-- Vacunas

CREATE PROCEDURE InsertVacuna
    @CodVacuna VARCHAR(20),
    @Nombre VARCHAR(80),
    @Laboratorio VARCHAR(80),
    @PrevEnfermedad VARCHAR(50),
    @Dosis DECIMAL(5, 2),
    @PrecioUnitario DECIMAL(5, 2)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Vacunas WHERE CodVacuna = @CodVacuna)
    BEGIN
        RAISERROR('La vacuna ya está registrada.', 16, 1);
        RETURN;
    END

    DECLARE @ErrorMessages NVARCHAR(MAX) = '';

    IF LEN(@CodVacuna) > 20
        SET @ErrorMessages = @ErrorMessages + 'codVacuna, ';
    IF LEN(@Nombre) > 80
        SET @ErrorMessages = @ErrorMessages + 'nombre, ';
    IF LEN(@Laboratorio) > 80
        SET @ErrorMessages = @ErrorMessages + 'laboratorio, ';
    IF LEN(@PrevEnfermedad) > 50
        SET @ErrorMessages = @ErrorMessages + 'prevEnfermedad, ';
    IF @Dosis > 999.99
        SET @ErrorMessages = @ErrorMessages + 'dosis, ';
    IF @PrecioUnitario > 999.99
        SET @ErrorMessages = @ErrorMessages + 'precioUnitario, ';

    IF @ErrorMessages <> ''
    BEGIN
        SET @ErrorMessages = 'Los campos ' + LEFT(@ErrorMessages, LEN(@ErrorMessages) - 2) + ' se excedieron.';
        THROW 50000, @ErrorMessages, 1;
    END

    INSERT INTO Vacunas (CodVacuna, Nombre, Laboratorio, PrevEnfermedad, Dosis, PrecioUnitario)
    VALUES (@CodVacuna, @Nombre, @Laboratorio, @PrevEnfermedad, @Dosis, @PrecioUnitario);
END


CREATE PROCEDURE UpdateVacuna
    @CodVacuna VARCHAR(20),
    @Nombre VARCHAR(80),
    @Laboratorio VARCHAR(80),
    @PrevEnfermedad VARCHAR(50),
    @Dosis DECIMAL(5, 2),
    @PrecioUnitario MONEY
AS
BEGIN
    DECLARE @ErrorMessages NVARCHAR(MAX) = '';

    IF LEN(@CodVacuna) > 20
        SET @ErrorMessages = @ErrorMessages + 'codVacuna, ';
    IF LEN(@Nombre) > 80
        SET @ErrorMessages = @ErrorMessages + 'nombre, ';
    IF LEN(@Laboratorio) > 80
        SET @ErrorMessages = @ErrorMessages + 'laboratorio, ';
    IF LEN(@PrevEnfermedad) > 50
        SET @ErrorMessages = @ErrorMessages + 'prevEnfermedad, ';

    IF @ErrorMessages <> ''
    BEGIN
        SET @ErrorMessages = 'Los campos ' + LEFT(@ErrorMessages, LEN(@ErrorMessages) - 2) + ' se excedieron.';
        THROW 50000, @ErrorMessages, 1;
    END

    IF NOT EXISTS (SELECT 1 FROM Vacunas WHERE CodVacuna = @CodVacuna)
    BEGIN
        RAISERROR('La vacuna no está registrada.', 16, 1);
        RETURN;
    END

    UPDATE Vacunas
    SET Nombre = @Nombre,
        Dosis = @Dosis,
        Laboratorio = @Laboratorio,
        PrecioUnitario = @PrecioUnitario,
        PrevEnfermedad = @PrevEnfermedad
    WHERE CodVacuna = @CodVacuna;
END
GO

CREATE PROCEDURE DeleteVacuna
    @CodVacuna VARCHAR(20)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Vacunas WHERE CodVacuna = @CodVacuna)
    BEGIN
        RAISERROR('La vacuna no está registrada.', 16, 1);
        RETURN;
    END

    DELETE FROM Vacunas
    WHERE CodVacuna = @CodVacuna;
END
GO


/*

SELECT * FROM Personas

-- Insertar en Personas
EXEC InsertPersona '1234567891', 'Juan Pérez', '1234567890', 'juan@example.com', '123 Calle Falsa';

-- Actualizar en Personas
EXEC UpdatePersona '1234567891', 'Juan Pérez Actualizado', '0987654321', 'juan_actualizado@example.com', '456 Calle Verdadera';

-- Eliminar en Personas
EXEC DeletePersona '1234567891';

-- Insertar en Clientes
EXEC InsertCliente 'C123', 'Pérez', 'Juan', 'Banco XYZ', 'juan@example.com', '123456789', '123 Calle Falsa', '1234567890';

-- Actualizar en Clientes
EXEC UpdateCliente 'C123', 'Pérez Actualizado', 'Juan Actualizado', 'Banco ABC', 'juan_actualizado@example.com', '987654321', '456 Calle Verdadera', '0987654321';

-- Eliminar en Clientes
EXEC DeleteCliente 'C123';


*/
-- clientes

CREATE PROCEDURE InsertCliente
    @CodCliente VARCHAR(20),
    @Apellido VARCHAR(80),
    @Banco VARCHAR(80),
    @Correo VARCHAR(50),
    @CuentaBanco VARCHAR(40),
    @Direccion VARCHAR(60),
    @Telefono VARCHAR(50)
AS
BEGIN
    DECLARE @ErrorMessages NVARCHAR(MAX) = '';

    IF LEN(@CodCliente) > 20
        SET @ErrorMessages = @ErrorMessages + 'codCliente, ';
    IF LEN(@Apellido) > 80
        SET @ErrorMessages = @ErrorMessages + 'apellido, ';
    IF LEN(@Banco) > 80
        SET @ErrorMessages = @ErrorMessages + 'banco, ';
    IF LEN(@Correo) > 50
        SET @ErrorMessages = @ErrorMessages + 'correo, ';
    IF LEN(@CuentaBanco) > 40
        SET @ErrorMessages = @ErrorMessages + 'cuentaBanco, ';
    IF LEN(@Direccion) > 60
        SET @ErrorMessages = @ErrorMessages + 'direccion, ';
    IF LEN(@Telefono) > 50
        SET @ErrorMessages = @ErrorMessages + 'telefono, ';

    IF @ErrorMessages <> ''
    BEGIN
        SET @ErrorMessages = 'Los campos ' + LEFT(@ErrorMessages, LEN(@ErrorMessages) - 2) + ' se excedieron.';
        THROW 50000, @ErrorMessages, 1;
    END

    INSERT INTO Clientes (codCliente, apellido, banco, correo, cuentaBanco, direccion, telefono)
    VALUES (@CodCliente, @Apellido, @Banco, @Correo, @CuentaBanco, @Direccion, @Telefono);
END
GO

CREATE PROCEDURE UpdateCliente
    @CodCliente VARCHAR(20),
    @Apellido VARCHAR(80),
    @Banco VARCHAR(80),
    @Correo VARCHAR(50),
    @CuentaBanco VARCHAR(40),
    @Direccion VARCHAR(60),
    @Telefono VARCHAR(50)
AS
BEGIN
    DECLARE @ErrorMessages NVARCHAR(MAX) = '';

    IF LEN(@CodCliente) > 20
        SET @ErrorMessages = @ErrorMessages + 'codCliente, ';
    IF LEN(@Apellido) > 80
        SET @ErrorMessages = @ErrorMessages + 'apellido, ';
    IF LEN(@Banco) > 80
        SET @ErrorMessages = @ErrorMessages + 'banco, ';
    IF LEN(@Correo) > 50
        SET @ErrorMessages = @ErrorMessages + 'correo, ';
    IF LEN(@CuentaBanco) > 40
        SET @ErrorMessages = @ErrorMessages + 'cuentaBanco, ';
    IF LEN(@Direccion) > 60
        SET @ErrorMessages = @ErrorMessages + 'direccion, ';
    IF LEN(@Telefono) > 50
        SET @ErrorMessages = @ErrorMessages + 'telefono, ';

    IF @ErrorMessages <> ''
    BEGIN
        SET @ErrorMessages = 'Los campos ' + LEFT(@ErrorMessages, LEN(@ErrorMessages) - 2) + ' se excedieron.';
        THROW 50000, @ErrorMessages, 1;
    END

    UPDATE Clientes
    SET apellido = @Apellido,
        banco = @Banco,
        correo = @Correo,
        cuentaBanco = @CuentaBanco,
        direccion = @Direccion,
        telefono = @Telefono
    WHERE codCliente = @CodCliente;
END
GO

CREATE PROCEDURE DeleteCliente
    @CodCliente VARCHAR(20)
AS
BEGIN
    DELETE FROM Clientes
    WHERE codCliente = @CodCliente;
END
GO

CREATE PROCEDURE InsertMascota
    @CodMascota VARCHAR(20),
    @CodCliente VARCHAR(20),
    @Nombre VARCHAR(80),
    @Especie VARCHAR(30),
    @Raza VARCHAR(30),
    @Color VARCHAR(20),
    @FechaNac DATE
AS
BEGIN
    DECLARE @ErrorMessages NVARCHAR(MAX) = '';

    IF LEN(@CodMascota) > 20
        SET @ErrorMessages = @ErrorMessages + 'codMascota, ';
    IF LEN(@CodCliente) > 20
        SET @ErrorMessages = @ErrorMessages + 'codCliente, ';
    IF LEN(@Nombre) > 80
        SET @ErrorMessages = @ErrorMessages + 'nombre, ';
    IF LEN(@Especie) > 30
        SET @ErrorMessages = @ErrorMessages + 'especie, ';
    IF LEN(@Raza) > 30
        SET @ErrorMessages = @ErrorMessages + 'raza, ';
    IF LEN(@Color) > 20
        SET @ErrorMessages = @ErrorMessages + 'color, ';

    IF @ErrorMessages <> ''
    BEGIN
        SET @ErrorMessages = 'Los campos ' + LEFT(@ErrorMessages, LEN(@ErrorMessages) - 2) + ' se excedieron.';
        THROW 50000, @ErrorMessages, 1;
    END

    IF EXISTS (SELECT 1 FROM Mascotas WHERE CodMascota = @CodMascota)
    BEGIN
        RAISERROR('La mascota ya está registrada.', 16, 1);
        RETURN;
    END

    INSERT INTO Mascotas (CodMascota, CodCliente, Nombre, Especie, Raza, Color, FechaNac)
    VALUES (@CodMascota, @CodCliente, @Nombre, @Especie, @Raza, @Color, @FechaNac);
END
GO

CREATE PROCEDURE UpdateMascota
    @CodMascota VARCHAR(20),
    @CodCliente VARCHAR(20),
    @Nombre VARCHAR(80),
    @Especie VARCHAR(30),
    @Raza VARCHAR(30),
    @Color VARCHAR(20),
    @FechaNac DATE
AS
BEGIN
    DECLARE @ErrorMessages NVARCHAR(MAX) = '';

    IF LEN(@CodMascota) > 20
        SET @ErrorMessages = @ErrorMessages + 'codMascota, ';
    IF LEN(@CodCliente) > 20
        SET @ErrorMessages = @ErrorMessages + 'codCliente, ';
    IF LEN(@Nombre) > 80
        SET @ErrorMessages = @ErrorMessages + 'nombre, ';
    IF LEN(@Especie) > 30
        SET @ErrorMessages = @ErrorMessages + 'especie, ';
    IF LEN(@Raza) > 30
        SET @ErrorMessages = @ErrorMessages + 'raza, ';
    IF LEN(@Color) > 20
        SET @ErrorMessages = @ErrorMessages + 'color, ';

    IF @ErrorMessages <> ''
    BEGIN
        SET @ErrorMessages = 'Los campos ' + LEFT(@ErrorMessages, LEN(@ErrorMessages) - 2) + ' se excedieron.';
        THROW 50000, @ErrorMessages, 1;
    END

    IF NOT EXISTS (SELECT 1 FROM Mascotas WHERE CodMascota = @CodMascota)
    BEGIN
        RAISERROR('La mascota no está registrada.', 16, 1);
        RETURN;
    END

    UPDATE Mascotas
    SET CodCliente = @CodCliente,
        Nombre = @Nombre,
        Especie = @Especie,
        Raza = @Raza,
        Color = @Color,
        FechaNac = @FechaNac
    WHERE CodMascota = @CodMascota;
END
GO

CREATE PROCEDURE DeleteMascota
    @CodMascota VARCHAR(20)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Mascotas WHERE CodMascota = @CodMascota)
    BEGIN
        RAISERROR('La mascota no está registrada.', 16, 1);
        RETURN;
    END

    DELETE FROM Mascotas
    WHERE CodMascota = @CodMascota;
END
GO
-- Procedimiento almacenado para insertar una nueva consulta
CREATE PROCEDURE InsertarConsulta
    @codMascota idFijo,
    @fechaConsulta fechaObligatoria,
    @motivo varchar(50),
    @diagnostico varchar(100),
    @tratamiento varchar(150),
    @medicacion varchar(200)
AS
BEGIN
    INSERT INTO Consultas (codMascota, fechaConsulta, motivo, diagnostico, tratamiento, medicacion)
    VALUES (@codMascota, @fechaConsulta, @motivo, @diagnostico, @tratamiento, @medicacion);
END;
GO
-- Procedimiento almacenado para actualizar una consulta existente
CREATE PROCEDURE ActualizarConsulta
    @codMascota idFijo,
    @fechaConsulta fechaObligatoria,
    @nuevoMotivo varchar(50),
    @nuevoDiagnostico varchar(100),
    @nuevoTratamiento varchar(150),
    @nuevaMedicacion varchar(200)
AS
BEGIN
    UPDATE Consultas
    SET motivo = @nuevoMotivo,
        diagnostico = @nuevoDiagnostico,
        tratamiento = @nuevoTratamiento,
        medicacion = @nuevaMedicacion
    WHERE codMascota = @codMascota AND fechaConsulta = @fechaConsulta;
END;
GO

-- Procedimiento almacenado para borrar una consulta existente
CREATE PROCEDURE BorrarConsulta
    @codMascota idFijo,
    @fechaConsulta fechaObligatoria
AS
BEGIN
    DELETE FROM Consultas
    WHERE codMascota = @codMascota AND fechaConsulta = @fechaConsulta;
END;
GO

/* EXEC InsertarConsulta 
    @codMascota = 'M001',
    @fechaConsulta = '2024-06-07',
    @motivo = 'Control de rutina',
    @diagnostico = 'Buen estado de salud',
    @tratamiento = 'Vacunación contra la rabia',
    @medicacion = 'Ninguna';

	EXEC ActualizarConsulta
    @codMascota = 'M001',
    @fechaConsulta = '2024-06-07',
    @nuevoMotivo = 'Dientes amarillos (actualizado)',
    @nuevoDiagnostico = 'Buen estado de salud (actualizado)',
    @nuevoTratamiento = 'Vacunación contra la rabia (actualizado)',
    @nuevaMedicacion = 'Ninguna (actualizado)';
	
	EXEC BorrarConsulta
    @codMascota = 'M001',
    @fechaConsulta = '2024-06-07';
	SELECT * FROM Consultas
*/

-- Aplica Vacunas

CREATE PROCEDURE InsertarAplicaVacuna
    @codMascota VARCHAR(20),
    @codVacuna VARCHAR(20),
    @fechaPrevista DATE,
    @fechaAplicacion DATE = NULL,
    @dosisAplicada INT = 0
AS
BEGIN
    IF EXISTS (SELECT 1 FROM AplicaVacuna WHERE codMascota = @codMascota AND codVacuna = @codVacuna AND fechaPrevista = @fechaPrevista)
    BEGIN
        RAISERROR('El registro de aplicación de vacuna ya existe.', 16, 1);
        RETURN;
    END

    INSERT INTO AplicaVacuna (codMascota, codVacuna, fechaPrevista, fechaAplicacion, dosisAplicada)
    VALUES (@codMascota, @codVacuna, @fechaPrevista, ISNULL(@fechaAplicacion, GETDATE()), @dosisAplicada);
END;
GO

CREATE PROCEDURE ActualizarAplicaVacuna
    @codMascota VARCHAR(20),
    @codVacuna VARCHAR(20),
    @fechaPrevista DATE,
    @fechaAplicacion DATE,
    @dosisAplicada INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM AplicaVacuna WHERE codMascota = @codMascota AND codVacuna = @codVacuna AND fechaPrevista = @fechaPrevista)
    BEGIN
        RAISERROR('El registro de aplicación de vacuna no existe.', 16, 1);
        RETURN;
    END

    UPDATE AplicaVacuna
    SET fechaAplicacion = @fechaAplicacion,
        dosisAplicada = @dosisAplicada
    WHERE codMascota = @codMascota AND codVacuna = @codVacuna AND fechaPrevista = @fechaPrevista;
END;
GO

CREATE PROCEDURE BorrarAplicaVacuna
    @codMascota VARCHAR(20),
    @codVacuna VARCHAR(20),
    @fechaPrevista DATE
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM AplicaVacuna WHERE codMascota = @codMascota AND codVacuna = @codVacuna AND fechaPrevista = @fechaPrevista)
    BEGIN
        RAISERROR('El registro de aplicación de vacuna no existe.', 16, 1);
        RETURN;
    END

    DELETE FROM AplicaVacuna
    WHERE codMascota = @codMascota AND codVacuna = @codVacuna AND fechaPrevista = @fechaPrevista;
END;
GO

-- Insertando Consumos Médicos con SP

CREATE PROCEDURE InsertarConsumoVet
    @fechaInicio DATE,
    @fechaFin DATE,
    @codMascota VARCHAR(20),
    @observaciones VARCHAR(200),
    @nit VARCHAR(20)
AS
BEGIN
    -- Insertar aplicaciones de vacunas
    INSERT INTO ConsumosVet (codMascota, codVacuna, idServicio, observaciones, cantVacunas, nit)
    SELECT 
        a.codMascota,
        a.codVacuna,
        'AV000', -- ID del servicio de aplicación de vacunas
        @observaciones,
        SUM(a.dosisAplicada),
        @nit
    FROM 
        AplicaVacuna a
    LEFT JOIN 
        ConsumosVet c
    ON 
        a.codMascota = c.codMascota AND a.codVacuna = c.codVacuna AND c.idServicio = 'AV000'
    WHERE 
        a.fechaAplicacion BETWEEN @fechaInicio AND @fechaFin
        AND c.codMascota IS NULL
        AND a.codMascota = @codMascota
    GROUP BY 
        a.codMascota, a.codVacuna;

    -- Insertar consultas
    INSERT INTO ConsumosVet (codMascota, codVacuna, idServicio, observaciones, cantVacunas, nit)
    SELECT 
        cons.codMascota,
        NULL, -- Sin vacuna en las consultas generales
        'CG000', -- ID del servicio de consultas generales
        @observaciones,
        0, -- Sin vacunas en consultas generales
        @nit
    FROM 
        Consultas cons
    LEFT JOIN 
        ConsumosVet c
    ON 
        cons.codMascota = c.codMascota AND c.idServicio = 'CG000'
    WHERE 
        cons.fechaConsulta BETWEEN @fechaInicio AND @fechaFin
        AND c.codMascota IS NULL
        AND cons.codMascota = @codMascota
    GROUP BY 
        cons.codMascota, cons.fechaConsulta, cons.motivo, cons.diagnostico, cons.tratamiento, cons.medicacion;
END;
GO






-- pruebas

/*

SELECT * FROM AplicaVacuna
SELECT * FROM Consultas
SELECT * FROM ConsumosVet
INSERT INTO AplicaVacuna VALUES ('M001', 'V002', '2024-06-08', '2024-05-02', 2)
EXEC InsertarConsumoVet @fechaInicio = '2024-05-01', @fechaFin = '2024-08-06', @codMascota = 'M001', @observaciones = 'Registro automático', @nit = '0987654321';



*/

