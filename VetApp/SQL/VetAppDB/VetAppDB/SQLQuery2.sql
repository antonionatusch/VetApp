CREATE PROCEDURE [dbo].[GenerateHotelConsumptionReport]
    @fechaInicio DATE,
    @fechaFin DATE,
    @resultado INT OUTPUT
AS
BEGIN
    BEGIN TRY
        -- Obtener datos de ConsumoHotel con cálculo de precio total
        SELECT 
            ch.codMascota,
            m.nombre AS nombreMascota,
            c.apellido AS cliente,
            ch.idServicio,
            s.nombre AS nombreServicio,
            ch.observaciones,
            ch.nochesHosp,
            ch.cantidadAlim,
            ch.cantidadMedic,
            ch.cantidadCom,
            ch.cantidadBanos,  -- Agregar cantidad de baños
            ch.NIT,
            h.fechaIngreso AS fecha,
            (
                CASE 
                    WHEN ch.idServicio IN ('H001', 'H002', 'H003') THEN 
                        ch.nochesHosp * s.precio -- Precio del servicio de hospedaje
                    ELSE 
                        0
                END
                + ISNULL((
                    SELECT a.precioUnitario * ch.cantidadAlim
                    FROM Alimentos a
                    WHERE a.codAlimento = ch.codAlimento
                ), 0) -- Precio del alimento consumido
                + ISNULL((
                    SELECT co.precioUnitario * ch.cantidadCom
                    FROM Comodidades co
                    WHERE co.idComodidad = ch.idComodidad
                ), 0) -- Precio de la comodidad consumida
                + ISNULL((
                    SELECT me.precioUnitario * ch.cantidadMedic
                    FROM Medicamentos me
                    WHERE me.codMedicamento = ch.codMedicamento
                ), 0) -- Precio del medicamento consumido
                + ISNULL((
                    CASE
                        WHEN ch.idServicio IN ('BE001', 'BE002', 'BE003') THEN s.precio * ch.cantidadBanos
                        ELSE 0
                    END
                ), 0) -- Precio de los baños consumidos
            ) AS precioTotal
        INTO #tempReport
        FROM 
            ConsumoHotel ch
            JOIN Mascotas m ON ch.codMascota = m.codMascota
            JOIN Clientes c ON m.codCliente = c.codCliente
            JOIN Servicios s ON ch.idServicio = s.idServicio
            JOIN Hospedajes h ON ch.idHospedaje = h.idHospedaje AND ch.codMascota = h.codMascota
        WHERE 
            h.fechaIngreso BETWEEN @fechaInicio AND @fechaFin;
        
        -- Calcular el precio total general por mascota
        SELECT 
            codMascota, 
            SUM(precioTotal) AS precioTotalGeneral
        INTO #totalPorMascota
        FROM #tempReport
        GROUP BY codMascota;

        -- Seleccionar datos del reporte con el precio total general por mascota
        SELECT 
            tr.*,
            CASE 
                WHEN tr.idServicio IN ('H001', 'H002', 'H003') THEN tm.precioTotalGeneral
                ELSE NULL
            END AS precioTotalGeneral
        FROM #tempReport tr
        LEFT JOIN #totalPorMascota tm ON tr.codMascota = tm.codMascota;

        SET @resultado = 1; -- Éxito
    END TRY
    BEGIN CATCH
        SET @resultado = -1; -- Error
    END CATCH
END;


DECLARE @resultado INT;

EXEC [dbo].[GenerateHotelConsumptionReport] 
    @fechaInicio = '2024-06-01',
    @fechaFin = '2024-06-30',
    @resultado = @resultado OUTPUT;

SELECT @resultado AS Resultado;

-- Verificar los resultados
SELECT * FROM #tempReport;
SELECT * FROM #totalPorMascota;
