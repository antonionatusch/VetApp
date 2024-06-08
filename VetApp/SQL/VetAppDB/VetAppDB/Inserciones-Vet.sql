USE VeterinariaExtendida;

-- Insertar en la tabla Servicios
INSERT INTO Servicios (idServicio, nombre, descripcion, precio, unidadMedida, tipoServicio) VALUES
('H001', 'BásicoPeque', 'Servicio básico del hotel para mascotas pequeñas, incluye baño inicial y alimentación general', 50, 'Noche', 'Hospedaje'),
('H002', 'BásicoMed', 'Servicio básico del hotel para mascotas medianas, incluye baño inicial y alimentación general', 55, 'Noche', 'Hospedaje'),
('H003', 'BásicoGrande', 'Servicio básico del hotel para mascotas grandes, incluye baño inicial y alimentación general', 60, 'Noche', 'Hospedaje'),
('NE000', 'NecesidadEspecial', 'Servicio de la veterinaria que atiende a mascotas con necesidades especiales', 30, 'Servicio', 'Extra'),
('BE001', 'BañoExtraPeque', 'Servicio de higiene extra para mascotas pequeñas', 5, 'Servicio', 'Extra'),
('BE002', 'BañoExtraMediano', 'Servicio de higiene extra para mascotas medianas', 10, 'Servicio', 'Extra'),
('BE003', 'BañoExtraGrande', 'Servicio de higiene extra para mascotas grandes', 15, 'Servicio', 'Extra'),
('CG000', 'ConsultaGeneral', 'Consulta general de la veterinaria, para todo tipo de mascotas', 150, 'Servicio', 'Veterinaria'),
('AV000', 'AplicaciónVacuna', 'Servicio de vacunación para la mascota', 60, 'Servicio', 'Veterinaria');



-- Insertar en la tabla Personas
INSERT INTO Personas (ci, nombre, telefono, correo, direccion) VALUES
('1234567890', 'Carlos Ramirez', '123456789', 'carlos@example.com', 'Calle 1, Ciudad'),
('0987654321', 'Ana Perez', '987654321', 'ana@example.com', 'Calle 2, Ciudad'),
('1122334455', 'Luis Fernandez', '1122334455', 'luis@example.com', 'Calle 3, Ciudad'),
('5566778899', 'Maria Gomez', '5566778899', 'maria@example.com', 'Calle 4, Ciudad'),
('4433221100', 'Pedro Martinez', '4433221100', 'pedro@example.com', 'Calle 5, Ciudad');

-- Insertar en la tabla Clientes
INSERT INTO Clientes (codCliente, apellido, cuentaBanco, banco, direccion, telefono, correo) VALUES
('C001', 'Ramirez', '1234567890123456', 'Banco 1', 'Calle 1, Ciudad', '123456789', 'carlos@example.com'),
('C002', 'Perez', '2345678901234567', 'Banco 2', 'Calle 2, Ciudad', '987654321', 'ana@example.com'),
('C003', 'Fernandez', '3456789012345678', 'Banco 3', 'Calle 3, Ciudad', '1122334455', 'luis@example.com'),
('C004', 'Gomez', '4567890123456789', 'Banco 4', 'Calle 4, Ciudad', '5566778899', 'maria@example.com'),
('C005', 'Martinez', '5678901234567890', 'Banco 5', 'Calle 5, Ciudad', '4433221100', 'pedro@example.com');

-- Insertar en la tabla PersonaCliente
INSERT INTO PersonaCliente (codCliente, ci, fechaAsociacion) VALUES
('C001', '1234567890', '2024-01-01'),
('C002', '0987654321', '2024-01-02'),
('C003', '1122334455', '2024-01-03'),
('C004', '5566778899', '2024-01-04'),
('C005', '4433221100', '2024-01-05');

-- Insertar en la tabla Mascotas
INSERT INTO Mascotas (codMascota, codCliente, nombre, especie, raza, color, fechaNac) VALUES
('M001', 'C001', 'Rex', 'Canino', 'Labrador', 'Negro', '2022-01-01'),
('M002', 'C002', 'Michi', 'Felino', 'Siames', 'Blanco', '2021-02-02'),
('M003', 'C003', 'Piolin', 'Ave', 'Canario', 'Amarillo', '2020-03-03'),
('M004', 'C004', 'Nemo', 'Pez', 'Pez payaso', 'Naranja', '2019-04-04'),
('M005', 'C005', 'Bunny', 'Conejo', 'Holandés', 'Gris', '2018-05-05');

-- Insertar en la tabla Vacunas
INSERT INTO Vacunas (codVacuna, nombre, laboratorio, prevEnfermedad, dosis, precioUnitario) VALUES
('V001', 'Rabia', 'Lab 1', 'Rabia', 1, 100.00),
('V002', 'Moquillo', 'Lab 2', 'Moquillo', 1, 150.00),
('V003', 'Parvovirus', 'Lab 3', 'Parvovirus', 1, 120.00),
('V004', 'Hepatitis', 'Lab 4', 'Hepatitis', 1, 130.00),
('V005', 'Leptospirosis', 'Lab 5', 'Leptospirosis', 1, 140.00);

-- Insertar en la tabla AplicaVacuna
INSERT INTO AplicaVacuna (codMascota, codVacuna, fechaPrevista, fechaAplicacion, dosisAplicada) VALUES
('M001', 'V001', '2024-05-01', '2024-05-01', 1),
('M002', 'V002', '2024-05-02', '2024-05-02', 1),
('M003', 'V003', '2024-05-03', '2024-05-03', 1),
('M004', 'V004', '2024-05-04', '2024-05-04', 1),
('M005', 'V005', '2024-05-05', '2024-05-05', 1);

-- Insertar en la tabla ConsumosVet
INSERT INTO ConsumosVet (codMascota, codVacuna, idServicio, observaciones, cantVacunas, nit) VALUES
('M001', 'V001', 'AV000', 'Vacuna de rabia aplicada', 1, '1234567890'),
('M002', NULL, 'CG000', 'Consulta general sin vacuna', 0, '0987654321'),
('M003', 'V003', 'AV000', 'Vacuna de parvovirus aplicada', 1, '1122334455'),
('M004', 'V004', 'AV000', 'Vacuna de hepatitis aplicada', 1, '5566778899'),
('M005', 'V005', 'AV000', 'Vacuna de leptospirosis aplicada', 1, '4433221100');

-- Consulta adicional sin vacuna aplicada
INSERT INTO ConsumosVet (codMascota, codVacuna, idServicio, observaciones, cantVacunas, nit) VALUES
('M002', NULL, 'CG000', 'Consulta de seguimiento', 0, '0987654321');

-- Insertar en la tabla Consultas
INSERT INTO Consultas (codMascota, fechaConsulta, motivo, diagnostico, tratamiento, medicacion) VALUES
('M001', '2024-05-01', 'Revisión general', 'Saludable', 'Ninguno', 'Ninguna'),
('M002', '2024-05-02', 'Dolor de estómago', 'Gastritis', 'Medicamento A', 'Medicamento A, 5mg'),
('M003', '2024-05-03', 'Herida en la pata', 'Corte leve', 'Vendaje', 'Ninguna'),
('M004', '2024-05-04', 'Problemas respiratorios', 'Asma', 'Inhalador', 'Inhalador B, 2 veces al día'),
('M005', '2024-05-05', 'Vacunación', 'Vacunación de rutina', 'Vacuna aplicada', 'Vacuna C, 1 dosis');

INSERT INTO Hospedajes (fechaIngreso, fechaSalida, observaciones)
VALUES 
('2024-06-01', '2024-06-10', 'Estancia tranquila'),
('2024-06-05', '2024-06-15', 'Algunos ladridos durante la noche'),
('2024-06-10', '2024-06-20', 'Problemas de convivencia con otras mascotas'),
('2024-06-15', '2024-06-25', 'Requiere atención especial'),
('2024-06-20', '2024-06-30', 'Buena adaptación al entorno');

INSERT INTO Comodidades (idComodidad, nombre, descripcion, precioUnitario)
VALUES 
('C001', 'Cama Deluxe', 'Cama cómoda para mascotas', 30.00),
('C002', 'Zona de Juegos', 'Área de recreación para mascotas', 25.00),
('C003', 'Piscina', 'Piscina para mascotas', 40.00),
('C004', 'Gimnasio', 'Gimnasio para mascotas', 35.00),
('C005', 'Spa', 'Spa para mascotas', 50.00);

INSERT INTO Alimentos (codAlimento, nombre, descripcion, proveedor, precioUnitario)
VALUES 
('A001', 'Dog Food', 'Alimento para perros', 'Proveedor A', 20.00),
('A002', 'Cat Food', 'Alimento para gatos', 'Proveedor B', 15.00),
('A003', 'Premium Dog Food', 'Alimento premium para perros', 'Proveedor C', 25.00),
('A004', 'Premium Cat Food', 'Alimento premium para gatos', 18.00),
('A005', 'Puppy Food', 'Alimento para cachorros', 22.00);

INSERT INTO Medicamentos (codMedicamento, laboratorio, presentacion, pesoNeto, precioUnitario, nombre)
VALUES 
('MED001', 'Lab A', 'Tabletas', 0.50, 10.00, 'Antipulgas'),
('MED002', 'Lab B', 'Jarabe', 1.00, 12.00, 'Antiparasitario'),
('MED003', 'Lab C', 'Inyección', 0.10, 15.00, 'Antibiótico'),
('MED004', 'Lab D', 'Cápsulas', 0.25, 8.00, 'Antiinflamatorio'),
('MED005', 'Lab E', 'Crema', 0.20, 5.00, 'Antiséptico');

INSERT INTO ConsumoHotel (idHospedaje, idServicio, codMascota, codAlimento, codMedicamento, idComodidad, NIT, observaciones, cantidadAlim, cantidadMedic, cantidadCom)
VALUES 
(1, 'H001', 'M001', 'A001', 'MED001', 'C001', '123456789', 'Consumo regular', 2, 1, 1),
(2, 'H002', 'M002', 'A002', 'MED002', 'C002', '987654321', 'Consumo especial', 3, 2, 1),
(3, 'H003', 'M003', 'A003', 'MED003', 'C003', '234567890', 'Requiere atención especial', 4, 3, 2),
(4, 'H001', 'M004', 'A004', 'MED004', 'C004', '345678901', 'Problemas de convivencia', 1, 1, 1),
(5, 'H002', 'M005', 'A005', 'MED005', 'C005', '456789012', 'Buena adaptación', 2, 2, 1);


/* SELECT * FROM Servicios
SELECT * FROM Personas
SELECT * FROM Clientes
SELECT * FROM Mascotas
SELECT * FROM PersonaCliente
SELECT * FROM Servicios
SELECT * FROM ConsumosVet
SELECT * FROM Vacunas 
SELECT * FROM Consultas
SELECT * FROM Hospedajes;
SELECT * FROM Comodidades;
SELECT * FROM Alimentos;
SELECT * FROM Medicamentos;
SELECT * FROM ConsumoHotel;
*/
