CREATE DATABASE VeterinariaExtendida
USE VeterinariaExtendida

-- sin foreign keys: persona, cliente, vacuna, servicio, hospedaje, alimento, medicamento, comodidades

/*
tipos custom
*/

CREATE TYPE idFijo FROM char(20) not null
CREATE TYPE nombre FROM varchar(80) not null
CREATE TYPE numTel FROM varchar(50) not null
CREATE TYPE correo FROM varchar(50) not null
CREATE TYPE direccion FROM varchar(60) not null
CREATE TYPE fechaObligatoria FROM date not null

CREATE TABLE Personas
(

	ci				idFijo,
	nombre			nombre, 
	telefono		numTel,
	correo			correo,
	direccion		direccion

	CONSTRAINT PK_Personas PRIMARY KEY (ci)

);


CREATE TABLE Clientes
(

	codCliente		idFijo,
	apellido		nombre,
	cuentaBanco		varchar(40) not null,
	banco			nombre,
	direccion		direccion,
	telefono		numTel,
	correo			correo,
	CONSTRAINT PK_Clientes PRIMARY KEY (codCliente)

);

CREATE TABLE Vacunas
(

	codVacuna		idFijo,
	nombre			nombre,
	laboratorio		nombre,
	prevEnfermedad	varchar(50) not null,
	dosis			decimal(5,2) not null,
	precioUnitario	money not null,
	CONSTRAINT PK_Vac PRIMARY KEY (codVacuna)


);

CREATE TABLE Servicios
(

	idServicio		idFijo,
	nombre			nombre,
	descripcion		varchar(100) not null,
	precio			money not null,
	unidadMedida	char(20) not null,
	tipoServicio	char(20) not null,
	CONSTRAINT PK_Ser PRIMARY KEY (idServicio)

);


-- con foreign keys, no asociativas: mascotas, consultas, histpeso

CREATE TABLE Mascotas
(

	codMascota			idFijo,
	codCliente			idFijo,
	nombre				nombre,
	especie				varchar(30) not null,
	raza				varchar(30) not null,
	color				varchar(20) not null,
	fechaNac			date
	CONSTRAINT PK_Mascotas PRIMARY KEY (codMascota),
	CONSTRAINT FK_CliMascotas FOREIGN KEY (codCliente) REFERENCES Clientes

);

CREATE TABLE Consultas
(

	codMascota		idFijo,
	fechaConsulta	fechaObligatoria,
	motivo			varchar(50) not null,
	diagnostico		varchar(100) not null,
	tratamiento		varchar(150) not null,
	medicacion		varchar(200) not null,
	CONSTRAINT PK_Consultas PRIMARY KEY (codMascota, fechaConsulta),
	CONSTRAINT FK_MascConsultas FOREIGN KEY (codMascota) REFERENCES Mascotas

);

-- entidades asociativas: consumo vet, persona cliente, aplica vacuna

CREATE TABLE ConsumosVet
(

	codMascota		idFijo,
	codVacuna		idFijo,
	idServicio		idFijo,
	idConsumoVet	INT IDENTITY(1,1) not null,
	observaciones	varchar(200) not null,
	cantVacunas		int not null DEFAULT 0,
	nit				idFijo,
	CONSTRAINT PK_CV PRIMARY KEY (codMascota, codVacuna, idServicio, idConsumoVet),
	CONSTRAINT FK_MasCV FOREIGN KEY (codMascota) REFERENCES Mascotas,
	CONSTRAINT FK_VacCV FOREIGN KEY (codVacuna) REFERENCES Vacunas,
	CONSTRAINT FK_SerCV FOREIGN KEY (idServicio) REFERENCES Servicios

);

CREATE TABLE PersonaCliente
(
	codCliente			idFijo,
	ci					idFijo,
	fechaAsociacion		fechaObligatoria

	CONSTRAINT PK_PC PRIMARY KEY (codCliente, ci, fechaAsociacion),
	CONSTRAINT FK_ClientesPC FOREIGN KEY (codCliente) REFERENCES Clientes(codCliente),
	CONSTRAINT FK_PersonasPC FOREIGN KEY (ci) REFERENCES Personas(ci)
);

CREATE TABLE AplicaVacuna
(

	codMascota		idFijo,
	codVacuna		idFijo,
	fechaPrevista	fechaObligatoria,
	fechaAplicacion	date DEFAULT GETDATE(),
	dosisAplicada	int not null DEFAULT 0,
	CONSTRAINT PK_AplicaVac PRIMARY KEY (codMascota, codVacuna, fechaPrevista),
	CONSTRAINT FK_MasAV FOREIGN KEY (codMascota) REFERENCES Mascotas,
	CONSTRAINT FK_VacAV FOREIGN KEY (codVacuna) REFERENCES Vacunas,


);