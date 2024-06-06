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

CREATE TABLE PersonaCliente
(
	codCliente			idFijo,
	ci					idFijo,
	fechaAsociacion		fechaObligatoria

	CONSTRAINT PK_PC PRIMARY KEY (codCliente, ci, fechaAsociacion),
	CONSTRAINT FK_ClientesPC FOREIGN KEY (codCliente) REFERENCES Clientes(codCliente),
	CONSTRAINT FK_PersonasPC FOREIGN KEY (ci) REFERENCES Personas(ci)
);

