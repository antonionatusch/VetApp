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

    INSERT INTO Personas (ci, nombre, telefono, correo, direccion)
    VALUES (@Ci, @Nombre, @Telefono, @Correo, @Direccion);
END


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

    UPDATE Personas
    SET nombre = @Nombre,
        telefono = @Telefono,
        correo = @Correo,
        direccion = @Direccion
    WHERE ci = @Ci;
END
GO

CREATE PROCEDURE DeletePersona
    @Ci VARCHAR(20)
AS
BEGIN
    DELETE FROM Personas
    WHERE ci = @Ci;
END


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

