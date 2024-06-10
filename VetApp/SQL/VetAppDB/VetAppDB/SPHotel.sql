CREATE PROCEDURE RegistrarHospedaje 
    @CodMascota NVARCHAR(20),
    @FechaIngreso DATE,
    @FechaSalida DATE,
    @UsaNecesidadesEspeciales BIT,
    @TamanoMascota CHAR(1),
    @NombreAlimento NVARCHAR(80) = NULL,
    @DescripcionAlimento NVARCHAR(150) = NULL,
    @ProveedorAlimento NVARCHAR(80) = NULL,
    @CantidadAlimento INT = 0,
    @NombreComodidad NVARCHAR(80) = NULL,
    @DescripcionComodidad NVARCHAR(150) = NULL,
    @CantidadComodidad INT = 0,
    @NombreMedicamento NVARCHAR(80) = NULL,
    @LaboratorioMedicamento NVARCHAR(80) = NULL,
    @PresentacionMedicamento NVARCHAR(30) = NULL,
    @PesoNetoMedicamento DECIMAL(5,2) = NULL,
    @CantidadMedicamento INT = 0
AS
BEGIN
    DECLARE @IdHospedaje INT;
    DECLARE @IdServicioHospedaje NVARCHAR(20);
    DECLARE @IdServicioNecesidades NVARCHAR(20) = 'NE000';
    DECLARE @Nit NVARCHAR(20) = 'S/N';  -- Suponiendo un valor por defecto para NIT
    DECLARE @Observaciones NVARCHAR(150) = 'Registro autom�tico';
    DECLARE @NochesHosp INT;

    -- Validar si ya existe un hospedaje que se solape en fechas para la misma mascota
    IF EXISTS (
        SELECT 1 
        FROM Hospedajes 
        WHERE codMascota = @CodMascota 
          AND (
                (fechaIngreso <= @FechaIngreso AND fechaSalida >= @FechaIngreso) OR
                (fechaIngreso <= @FechaSalida AND fechaSalida >= @FechaSalida) OR
                (fechaIngreso >= @FechaIngreso AND fechaSalida <= @FechaSalida)
              )
    )
    BEGIN
        RAISERROR ('Ya existe un hospedaje para esta mascota con un rango de fechas que se solapa.', 16, 1);
        RETURN;
    END

    -- Calcular la cantidad de noches de hospedaje
    SET @NochesHosp = DATEDIFF(DAY, @FechaIngreso, @FechaSalida);

    -- Insertar el registro en la tabla Hospedajes
    INSERT INTO Hospedajes (codMascota, fechaIngreso, fechaSalida, observaciones)
    VALUES (@CodMascota, @FechaIngreso, @FechaSalida, @Observaciones);

    -- Obtener el IdHospedaje reci�n insertado
    SET @IdHospedaje = SCOPE_IDENTITY();

    -- Determinar el IdServicio basado en el tama�o de la mascota
    SET @IdServicioHospedaje = 
        CASE 
            WHEN @TamanoMascota = 'P' THEN 'H001'
            WHEN @TamanoMascota = 'M' THEN 'H002'
            WHEN @TamanoMascota = 'G' THEN 'H003'
        END;

    -- Insertar el registro del tipo de hospedaje en ConsumoHotel
    INSERT INTO ConsumoHotel (idHospedaje, idServicio, codMascota, NIT, observaciones, nochesHosp)
    VALUES (@IdHospedaje, @IdServicioHospedaje, @CodMascota, @Nit, @Observaciones, @NochesHosp);

    -- Insertar registros de necesidades especiales si se especificaron
    IF @UsaNecesidadesEspeciales = 1
    BEGIN
        DECLARE @CodAlimento INT = NULL;
        DECLARE @CodComodidad INT = NULL;
        DECLARE @CodMedicamento INT = NULL;

        -- Insertar el alimento especial si se especific�
        IF @NombreAlimento IS NOT NULL
        BEGIN
            INSERT INTO Alimentos (nombre, descripcion, proveedor, precioUnitario)
            VALUES (@NombreAlimento, @DescripcionAlimento, @ProveedorAlimento, 0);

            SET @CodAlimento = SCOPE_IDENTITY();
        END

        -- Insertar la comodidad especial si se especific�
        IF @NombreComodidad IS NOT NULL
        BEGIN
            INSERT INTO Comodidades (nombre, descripcion, precioUnitario)
            VALUES (@NombreComodidad, @DescripcionComodidad, 0);

            SET @CodComodidad = SCOPE_IDENTITY();
        END

        -- Insertar el medicamento especial si se especific�
        IF @NombreMedicamento IS NOT NULL
        BEGIN
            INSERT INTO Medicamentos (nombre, laboratorio, presentacion, pesoNeto, precioUnitario)
            VALUES (@NombreMedicamento, @LaboratorioMedicamento, @PresentacionMedicamento, @PesoNetoMedicamento, 0);

            SET @CodMedicamento = SCOPE_IDENTITY();
        END

        -- Insertar el registro de necesidades especiales en ConsumoHotel
        INSERT INTO ConsumoHotel (idHospedaje, idServicio, codMascota, codAlimento, codMedicamento, idComodidad, NIT, observaciones, nochesHosp, cantidadAlim, cantidadMedic, cantidadCom)
        VALUES (@IdHospedaje, @IdServicioNecesidades, @CodMascota, @CodAlimento, @CodMedicamento, @CodComodidad, @Nit, @Observaciones, @NochesHosp, @CantidadAlimento, @CantidadMedicamento, @CantidadComodidad);
    END
END;

-- reporte consumo hotelero

CREATE PROCEDURE GenerateHotelConsumptionReport
    @fechaInicio DATE,
    @fechaFin DATE,
    @resultado INT OUTPUT
AS
BEGIN
    BEGIN TRY
        -- Obtener datos de ConsumoHotel con c�lculo de precio total
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

        SET @resultado = 1; -- �xito
    END TRY
    BEGIN CATCH
        SET @resultado = -1; -- Error
    END CATCH
END;


-- ba�os extra

CREATE PROCEDURE RegistrarBanoExtra
    @IdHospedaje INT,
    @CantidadBa�os INT
AS
BEGIN
    BEGIN TRY
        DECLARE @CodMascota NVARCHAR(20);
        DECLARE @IdServicio NVARCHAR(20);
        DECLARE @Nit NVARCHAR(20) = 'S/N'; -- Suponiendo un valor por defecto para NIT
        DECLARE @Observaciones NVARCHAR(150) = 'Registro autom�tico';
        DECLARE @NochesHosp INT = 0; -- Para ba�os extra no se considera noches hospedadas

        -- Obtener el CodMascota y el servicio asociado al hospedaje
        SELECT @CodMascota = codMascota, @IdServicio = idServicio
        FROM ConsumoHotel
        WHERE idHospedaje = @IdHospedaje AND idServicio IN ('H001', 'H002', 'H003');

        -- Determinar el IdServicio del ba�o extra basado en el servicio del hospedaje
        SET @IdServicio = 
        CASE 
            WHEN @IdServicio = 'H001' THEN 'BE001' -- Ba�o Extra Peque�o
            WHEN @IdServicio = 'H002' THEN 'BE002' -- Ba�o Extra Mediano
            WHEN @IdServicio = 'H003' THEN 'BE003' -- Ba�o Extra Grande
        END;

        -- Insertar el registro del ba�o extra en ConsumoHotel
        INSERT INTO ConsumoHotel (idHospedaje, idServicio, codMascota, NIT, observaciones, nochesHosp, cantidadBanos)
        VALUES (@IdHospedaje, @IdServicio, @CodMascota, @Nit, @Observaciones, @NochesHosp, @CantidadBa�os);

    END TRY
    BEGIN CATCH
        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;




/*

EXEC RegistrarHospedaje 
    @CodMascota = 'M001', 
    @FechaIngreso = '2024-06-09', 
    @FechaSalida = '2024-06-10', 
    @UsaNecesidadesEspeciales = 0, 
    @TamanoMascota = 'P';

	demostrando que no puede solaparse las fechas para la misma mascota:

	EXEC RegistrarHospedaje 
    @CodMascota = 'M001', 
    @FechaIngreso = '2024-06-09', 
    @FechaSalida = '2024-06-10', 
    @UsaNecesidadesEspeciales = 0, 
    @TamanoMascota = 'P';

	EXEC RegistrarHospedaje 
    @CodMascota = 'M002', 
    @FechaIngreso = '2024-06-09', 
    @FechaSalida = '2024-06-12', 
    @UsaNecesidadesEspeciales = 1, 
    @NombreAlimento = 'Comida Especial', 
    @DescripcionAlimento = 'Comida para dieta especial', 
    @ProveedorAlimento = 'Proveedor A', 
    @NombreComodidad = 'Cama especial', 
    @DescripcionComodidad = 'Cama con calefacci�n', 
    @NombreMedicamento = 'Medicamento B', 
    @LaboratorioMedicamento = 'Laboratorio X', 
    @PresentacionMedicamento = 'Tabletas', 
    @PesoNetoMedicamento = 0.5, 
    @TamanoMascota = 'M';

	EXEC RegistrarHospedaje 
    @CodMascota = 'M002', 
    @FechaIngreso = '2024-05-09', 
    @FechaSalida = '2024-05-12', 
    @UsaNecesidadesEspeciales = 1, 
    @NombreAlimento = 'Comida Especial', 
    @DescripcionAlimento = 'Comida para dieta especial', 
    @ProveedorAlimento = 'Proveedor A', 
    @CantidadAlimento = 2,
    @NombreComodidad = 'Cama especial', 
    @DescripcionComodidad = 'Cama con calefacci�n', 
    @CantidadComodidad = 1,
    @NombreMedicamento = 'Medicamento B', 
    @LaboratorioMedicamento = 'Laboratorio X', 
    @PresentacionMedicamento = 'Tabletas', 
    @PesoNetoMedicamento = 0.5,
    @CantidadMedicamento = 1,
    @TamanoMascota = 'M';


	SELECT * FROM ConsumoHotel
	SELECT * FROM Hospedajes
	SELECT * FROM Alimentos
	SELECT * FROM Comodidades
	SELECT * FROM Medicamentos
	SELECT * FROM Servicios
	
	DECLARE @resultado INT;

	DELETE FROM ConsumoHotel WHERE idServicio = 'BE002'

-- Ejecutar el procedimiento almacenado con un rango de fechas
EXEC GenerateHotelConsumptionReport @fechaInicio = '2024-06-01', @fechaFin = '2024-06-30', @resultado = @resultado OUTPUT;

-- Ver el valor del resultado
SELECT @resultado;

-- Insertar 2 ba�os extra para el hospedaje con IdHospedaje 33
EXEC RegistrarBanoExtra @IdHospedaje = 37, @CantidadBa�os = 2;





*/