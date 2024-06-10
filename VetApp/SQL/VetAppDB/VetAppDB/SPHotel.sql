Use VeterinariaExtendida;
GO

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
    DECLARE @Observaciones NVARCHAR(150) = 'Registro automático';
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

    -- Obtener el IdHospedaje recién insertado
    SET @IdHospedaje = SCOPE_IDENTITY();

    -- Determinar el IdServicio basado en el tamaño de la mascota
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

        -- Insertar el alimento especial si se especificó
        IF @NombreAlimento IS NOT NULL
        BEGIN
            INSERT INTO Alimentos (nombre, descripcion, proveedor, precioUnitario)
            VALUES (@NombreAlimento, @DescripcionAlimento, @ProveedorAlimento, 0);

            SET @CodAlimento = SCOPE_IDENTITY();
        END

        -- Insertar la comodidad especial si se especificó
        IF @NombreComodidad IS NOT NULL
        BEGIN
            INSERT INTO Comodidades (nombre, descripcion, precioUnitario)
            VALUES (@NombreComodidad, @DescripcionComodidad, 0);

            SET @CodComodidad = SCOPE_IDENTITY();
        END

        -- Insertar el medicamento especial si se especificó
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
    @idHospedaje INT,
    @resultado MONEY OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Variable para almacenar el consumo total
    DECLARE @consumoTotal MONEY;
    SET @consumoTotal = 0;

    -- Calcular el costo de las noches de hospedaje
    SELECT @consumoTotal = ISNULL(@consumoTotal, 0) + ISNULL(SUM(s.precio * ch.nochesHosp), 0)
    FROM ConsumoHotel ch
    JOIN Servicios s ON ch.idServicio = s.idServicio
    WHERE ch.idHospedaje = @idHospedaje
    AND ch.idHospedaje IN (
        SELECT idHospedaje 
        FROM Hospedajes 
        WHERE fechaIngreso >= @fechaInicio AND fechaSalida <= @fechaFin
    );

    -- Calcular el costo de los baños
    SELECT @consumoTotal = ISNULL(@consumoTotal, 0) + ISNULL(SUM(s.precio * ch.cantidadBanos), 0)
    FROM ConsumoHotel ch
    JOIN Servicios s ON ch.idServicio = s.idServicio
    WHERE ch.idHospedaje = @idHospedaje
    AND ch.idHospedaje IN (
        SELECT idHospedaje 
        FROM Hospedajes 
        WHERE fechaIngreso >= @fechaInicio AND fechaSalida <= @fechaFin
    );

    -- Calcular el costo de los alimentos extra
    SELECT @consumoTotal = ISNULL(@consumoTotal, 0) + ISNULL(SUM(a.precioUnitario * ch.cantidadAlim), 0)
    FROM ConsumoHotel ch
    JOIN Alimentos a ON ch.codAlimento = a.codAlimento
    WHERE ch.idHospedaje = @idHospedaje
    AND ch.idHospedaje IN (
        SELECT idHospedaje 
        FROM Hospedajes 
        WHERE fechaIngreso >= @fechaInicio AND fechaSalida <= @fechaFin
    );

    -- Calcular el costo de las comodidades extra
    SELECT @consumoTotal = ISNULL(@consumoTotal, 0) + ISNULL(SUM(c.precioUnitario * ch.cantidadCom), 0)
    FROM ConsumoHotel ch
    JOIN Comodidades c ON ch.idComodidad = c.idComodidad
    WHERE ch.idHospedaje = @idHospedaje
    AND ch.idHospedaje IN (
        SELECT idHospedaje 
        FROM Hospedajes 
        WHERE fechaIngreso >= @fechaInicio AND fechaSalida <= @fechaFin
    );

    -- Calcular el costo de los medicamentos extra
    SELECT @consumoTotal = ISNULL(@consumoTotal, 0) + ISNULL(SUM(m.precioUnitario * ch.cantidadMedic), 0)
    FROM ConsumoHotel ch
    JOIN Medicamentos m ON ch.codMedicamento = m.codMedicamento
    WHERE ch.idHospedaje = @idHospedaje
    AND ch.idHospedaje IN (
        SELECT idHospedaje 
        FROM Hospedajes 
        WHERE fechaIngreso >= @fechaInicio AND fechaSalida <= @fechaFin
    );

    -- Asignar el resultado al parámetro de salida
    SET @resultado = @consumoTotal;
END;



-- baños extra

CREATE PROCEDURE RegistrarBanoExtra
    @IdHospedaje INT,
    @CantidadBanos INT
AS
BEGIN
    BEGIN TRY
        DECLARE @CodMascota NVARCHAR(20);
        DECLARE @IdServicio NVARCHAR(20);
        DECLARE @Nit NVARCHAR(20) = 'S/N'; -- Suponiendo un valor por defecto para NIT
        DECLARE @Observaciones NVARCHAR(150) = 'Registro automático';
        DECLARE @NochesHosp INT = 0; -- Para baños extra no se considera noches hospedadas

        -- Obtener el CodMascota y el servicio asociado al hospedaje
        SELECT @CodMascota = codMascota, @IdServicio = idServicio
        FROM ConsumoHotel
        WHERE idHospedaje = @IdHospedaje AND idServicio IN ('H001', 'H002', 'H003');

        -- Determinar el IdServicio del baño extra basado en el servicio del hospedaje
        SET @IdServicio = 
        CASE 
            WHEN @IdServicio = 'H001' THEN 'BE001' -- Baño Extra Pequeño
            WHEN @IdServicio = 'H002' THEN 'BE002' -- Baño Extra Mediano
            WHEN @IdServicio = 'H003' THEN 'BE003' -- Baño Extra Grande
        END;

        -- Insertar el registro del baño extra en ConsumoHotel
        INSERT INTO ConsumoHotel (idHospedaje, idServicio, codMascota, NIT, observaciones, nochesHosp, cantidadBanos)
        VALUES (@IdHospedaje, @IdServicio, @CodMascota, @Nit, @Observaciones, @NochesHosp, @CantidadBanos);

    END TRY
    BEGIN CATCH
        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;

CREATE PROCEDURE UpdateBanoCount
    @idHospedaje INT,
    @cantidadBanos INT
AS
BEGIN
    UPDATE ConsumoHotel
    SET cantidadBanos = @cantidadBanos
    WHERE idHospedaje = @idHospedaje AND idServicio IN ('BE001', 'BE002', 'BE003');
END
