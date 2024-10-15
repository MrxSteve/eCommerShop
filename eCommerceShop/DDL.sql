-- Crear la base de datos
CREATE DATABASE ecommerceShop;
USE ecommerceShop;

-- Crear tabla estado
CREATE TABLE estado (
    idEstado INT IDENTITY PRIMARY KEY,
    estado VARCHAR(100)
);

-- Crear tabla categoria
CREATE TABLE categoria (
    idCategoria INT IDENTITY PRIMARY KEY,
    categoria VARCHAR(120),
    descripcion VARCHAR(MAX)
);

-- Crear tabla producto
CREATE TABLE producto (
    idProducto INT IDENTITY PRIMARY KEY,
    nombre VARCHAR(100),
    foto VARBINARY(MAX),
    descripcion VARCHAR(MAX),
    precio DECIMAL(10, 2),
    stock INT,
    idCategoria INT,
    idEstado INT
);

-- Definir claves foráneas para producto
ALTER TABLE producto 
ADD FOREIGN KEY (idCategoria) REFERENCES categoria(idCategoria);
ALTER TABLE producto 
ADD FOREIGN KEY (idEstado) REFERENCES estado(idEstado);

-- Crear tabla departamento
CREATE TABLE departamento (
    idDepartamento CHAR(2) PRIMARY KEY,
    departamento VARCHAR(25),
    pais VARCHAR(25)
);

-- Crear tabla municipio
CREATE TABLE municipio (
    idMunicipio CHAR(3) PRIMARY KEY,
    municipio VARCHAR(50) NOT NULL,
    idDepartamento CHAR(2) NOT NULL
);

-- Definir clave foránea para municipio
ALTER TABLE municipio 
ADD FOREIGN KEY (idDepartamento) REFERENCES departamento(idDepartamento);

-- Crear tabla distrito
CREATE TABLE distrito (
    idDistrito CHAR(5) PRIMARY KEY,
    distrito VARCHAR(50),
    idMunicipio CHAR(3)
);

-- Definir clave foránea para distrito
ALTER TABLE distrito 
ADD FOREIGN KEY (idMunicipio) REFERENCES municipio(idMunicipio);

-- Crear tabla direcciones
CREATE TABLE direcciones (
    idDireccion INT IDENTITY PRIMARY KEY,
    linea1 VARCHAR(100) NOT NULL,
    linea2 VARCHAR(100),
    idDistrito CHAR(5),
    codigoPostal VARCHAR(7)
);

-- Definir clave foránea para direcciones
ALTER TABLE direcciones 
ADD FOREIGN KEY (idDistrito) REFERENCES distrito(idDistrito);

-- Crear tabla cliente
CREATE TABLE cliente (
    idCliente INT IDENTITY PRIMARY KEY,
    dui VARCHAR(10),
    nombre VARCHAR(255),
    email VARCHAR(255),
    idDireccion INT,
    telefono VARCHAR(20),
    idEstado INT
);

-- Definir claves foráneas para cliente
ALTER TABLE cliente 
ADD FOREIGN KEY (idDireccion) REFERENCES direcciones(idDireccion);
ALTER TABLE cliente 
ADD FOREIGN KEY (idEstado) REFERENCES estado(idEstado);

-- Crear tabla compra
CREATE TABLE compra (
    idCompra INT IDENTITY PRIMARY KEY,
    idCliente INT,
    monto DECIMAL(10, 2),
    fechaCompra DATETIME DEFAULT GETDATE(),
    idEstado INT
);

-- Definir claves foráneas para compra
ALTER TABLE compra 
ADD FOREIGN KEY (idEstado) REFERENCES estado(idEstado);
ALTER TABLE compra 
ADD FOREIGN KEY (idCliente) REFERENCES cliente(idCliente);

-- Crear tabla detalle_compra
CREATE TABLE detalle_compra (
    idDetalle INT IDENTITY PRIMARY KEY,
    idProducto INT,
    idCompra INT,
    cantidad INT,
    precioCompra DECIMAL(10, 2)
);

-- Definir claves foráneas para detalle_compra
ALTER TABLE detalle_compra 
ADD FOREIGN KEY (idProducto) REFERENCES producto(idProducto);
ALTER TABLE detalle_compra 
ADD FOREIGN KEY (idCompra) REFERENCES compra(idCompra);