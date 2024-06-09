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

    -- Validar si ya existe un hospedaje con las mismas fechas para la misma mascota
    IF EXISTS (SELECT 1 
               FROM Hospedajes 
               WHERE codMascota = @CodMascota 
                 AND fechaIngreso = @FechaIngreso 
                 AND fechaSalida = @FechaSalida)
    BEGIN
        RAISERROR ('Ya existe un hospedaje para esta mascota con las mismas fechas.', 16, 1);
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




/*

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
    @DescripcionComodidad = 'Cama con calefacción', 
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
    @DescripcionComodidad = 'Cama con calefacción', 
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
	




*/