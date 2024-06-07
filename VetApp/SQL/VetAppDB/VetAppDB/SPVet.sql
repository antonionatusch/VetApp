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

