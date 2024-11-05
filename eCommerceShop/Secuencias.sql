USE ecommerceShop;

-- Crear nuevas tablas para las secuencias

-- Tabla de prueba para productos de una categoría específica
CREATE TABLE producto_categoria (
    id INT PRIMARY KEY,
    nombre VARCHAR(100)
);

-- Tabla de prueba para los departamentos de ventas
CREATE TABLE departamento_ventas (
    id INT PRIMARY KEY,
    nombre VARCHAR(50)
);

-- Tabla de prueba para los envíos
CREATE TABLE envio (
    id INT PRIMARY KEY,
    codigo_envio VARCHAR(20)
);

-- Tabla de prueba para las promociones
CREATE TABLE promocion (
    id INT PRIMARY KEY,
    nombre VARCHAR(50)
);

-- Tabla de prueba para el número de revisiones de productos
CREATE TABLE revision_producto (
    id INT PRIMARY KEY,
    idProducto INT,
    revision_numero INT
);


-- 1. Secuencia con CYCLE para IDs de productos en una categoría específica
CREATE SEQUENCE seq_producto_categoria_id
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 5
    CYCLE;

-- 2. Secuencia con NO CYCLE para IDs de departamento en ventas
CREATE SEQUENCE seq_departamento_ventas_id
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 100
    NO CYCLE;

-- 3. Secuencia con CYCLE para códigos de envíos
CREATE SEQUENCE seq_envio_codigo
    START WITH 1000
    INCREMENT BY 10
    MINVALUE 1000
    MAXVALUE 1050
    CYCLE;

-- 4. Secuencia con NO CYCLE para IDs de promociones
CREATE SEQUENCE seq_promocion_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 10
    NO CYCLE;

-- 5. Secuencia con CYCLE para números de revisiones de productos
CREATE SEQUENCE seq_revision_producto_numero
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 5
    CYCLE;

-- 6. Secuencia con NO CYCLE para IDs de direcciones temporales
CREATE TABLE direccion_temporal (
    id INT PRIMARY KEY,
    direccion VARCHAR(255)
);

CREATE SEQUENCE seq_direccion_temporal_id
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 1000
    NO CYCLE;

-- 7. Secuencia con CYCLE para IDs de prueba en el sistema
CREATE TABLE pruebas_sistema (
    id INT PRIMARY KEY,
    descripcion VARCHAR(255)
);

CREATE SEQUENCE seq_pruebas_sistema_id
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 3
    CYCLE;

-- 8. Secuencia con NO CYCLE para IDs de clientes VIP
CREATE TABLE cliente_vip (
    id INT PRIMARY KEY,
    nombre VARCHAR(255)
);

CREATE SEQUENCE seq_cliente_vip_id
    START WITH 100
    INCREMENT BY 5
    MINVALUE 100
    MAXVALUE 1000
    NO CYCLE;

-- 9. Secuencia con CYCLE para códigos de descuento por temporada
CREATE TABLE descuento_temporada (
    id INT PRIMARY KEY,
    descuento_codigo VARCHAR(20)
);

CREATE SEQUENCE seq_descuento_temporada_codigo
    START WITH 10
    INCREMENT BY 2
    MINVALUE 10
    MAXVALUE 20
    CYCLE;

-- 10. Secuencia con NO CYCLE para IDs de auditoría
CREATE TABLE auditoria (
    id INT PRIMARY KEY,
    accion VARCHAR(255),
    fecha DATE
);

CREATE SEQUENCE seq_auditoria_id
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 10000
    NO CYCLE;

-- Insertar usando la secuencia con CYCLE para producto_categoria
INSERT INTO producto_categoria (id, nombre) VALUES (NEXT VALUE FOR seq_producto_categoria_id, 'Producto A');

-- Insertar usando la secuencia con NO CYCLE para departamento_ventas
INSERT INTO departamento_ventas (id, nombre) VALUES (NEXT VALUE FOR seq_departamento_ventas_id, 'Ventas Norte');

-- Insertar usando la secuencia con CYCLE para envio
INSERT INTO envio (id, codigo_envio) VALUES (NEXT VALUE FOR seq_envio_codigo, 'ENV001');

-- Insertar usando la secuencia con NO CYCLE para promocion
INSERT INTO promocion (id, nombre) VALUES (NEXT VALUE FOR seq_promocion_id, 'Promo Verano');

-- Insertar usando la secuencia con CYCLE para revision_producto
INSERT INTO revision_producto (id, idProducto, revision_numero) VALUES (NEXT VALUE FOR seq_revision_producto_numero, 1, NEXT VALUE FOR seq_revision_producto_numero);

-- Insertar usando la secuencia con NO CYCLE para direccion_temporal
INSERT INTO direccion_temporal (id, direccion) VALUES (NEXT VALUE FOR seq_direccion_temporal_id, '123 Calle Principal');

-- Insertar usando la secuencia con CYCLE para pruebas_sistema
INSERT INTO pruebas_sistema (id, descripcion) VALUES (NEXT VALUE FOR seq_pruebas_sistema_id, 'Prueba de carga');

-- Insertar usando la secuencia con NO CYCLE para cliente_vip
INSERT INTO cliente_vip (id, nombre) VALUES (NEXT VALUE FOR seq_cliente_vip_id, 'Cliente VIP A');

-- Insertar usando la secuencia con CYCLE para descuento_temporada
INSERT INTO descuento_temporada (id, descuento_codigo) VALUES (NEXT VALUE FOR seq_descuento_temporada_codigo, 'DESC20');

-- Insertar usando la secuencia con NO CYCLE para auditoria
INSERT INTO auditoria (id, accion, fecha) VALUES (NEXT VALUE FOR seq_auditoria_id, 'Inicio de sesión', GETDATE());
