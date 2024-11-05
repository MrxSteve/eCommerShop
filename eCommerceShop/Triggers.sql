-- Triggers orientados a la base de datos de ecommerceBD

use ecommerceShop;

-- Nuevas inserciones:
alter table cliente add fechaNacimiento date;
alter table cliente add FechaUltimaCompra datetime;

-- Instead Triggers

-- 1. Controlar Disponibilidad de Productos/Medicamentos/Libros/Asientos:
-- Crea un INSTEAD OF INSERT Trigger en una tabla de pedidos o reservas
-- que verifique si hay suficiente stock (productos para quien manejen
-- productos, medicamentos en farmacia, libros en biblioteca, asientos
-- disponibles en aerolínea) antes de permitir la inserción de un pedido o reserva

CREATE OR ALTER TRIGGER trg_checkStock
ON detalle_compra
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @idProducto INT, @cantidad INT, @stockActual INT;

    SELECT @idProducto = idProducto, @cantidad = cantidad FROM inserted;

    SELECT @stockActual = stock FROM producto WHERE idProducto = @idProducto;

    IF @stockActual >= @cantidad
    BEGIN
        INSERT INTO detalle_compra (idProducto, idCompra, cantidad, precioCompra)
        SELECT idProducto, idCompra, cantidad, precioCompra FROM inserted;

        UPDATE producto
        SET stock = stock - @cantidad
        WHERE idProducto = @idProducto;
    END
    ELSE
    BEGIN
        RAISERROR ('Stock insuficiente para completar la compra.', 16, 1);
    END
END;

SELECT stock FROM producto WHERE idProducto = 1;

INSERT INTO detalle_compra (idProducto, idCompra, cantidad, precioCompra)
VALUES (1, 1, 999, 50.00); 



-- 2. Prevenir Actualización de Factura/Reservación: Crea un INSTEAD OF
-- UPDATE Trigger que impida cambiar el estado de un pedido o reservación
-- que ya ha sido completado o cerrado.

CREATE OR ALTER TRIGGER trg_prevenirActualizacionCompra
ON compra
INSTEAD OF UPDATE
AS
BEGIN
    DECLARE @estadoAnterior VARCHAR(100), @nuevoEstado VARCHAR(100), @idCompra INT;

    SELECT @idCompra = idCompra, @nuevoEstado = estado.estado 
    FROM inserted
    JOIN estado ON estado.idEstado = inserted.idEstado;

    SELECT @estadoAnterior = estado.estado
    FROM compra
    JOIN estado ON compra.idEstado = estado.idEstado
    WHERE compra.idCompra = @idCompra;

    IF @estadoAnterior = 'Completado' AND @nuevoEstado <> 'Completado'
    BEGIN
        RAISERROR ('No se puede actualizar una compra que ya está completada.', 16, 1);
    END
    ELSE
    BEGIN
        UPDATE compra SET idEstado = (SELECT idEstado FROM inserted) WHERE idCompra = @idCompra;
    END
END;

UPDATE compra SET idEstado = (SELECT idEstado FROM estado WHERE estado = 'Completado') WHERE idCompra = 1;

select * from compra 
where idCompra = 1;

-- 3. Validar Edad del Cliente: Crea un INSTEAD OF INSERT Trigger de un
-- cliente y que valide que la edad sea mayor a 18 años antes de permitir la
-- inserción.

CREATE OR ALTER TRIGGER trg_validarEdadCliente
ON cliente
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @fechaNacimiento DATE, @edad INT;

    SELECT @fechaNacimiento = FechaNacimiento FROM inserted;
    SET @edad = DATEDIFF(YEAR, @fechaNacimiento, GETDATE());

    IF @edad >= 18
    BEGIN
        INSERT INTO cliente (dui, nombre, email, idDireccion, telefono, idEstado) 
        SELECT dui, nombre, email, idDireccion, telefono, idEstado FROM inserted;
    END
    ELSE
    BEGIN
        RAISERROR ('El cliente debe ser mayor de 18 años.', 16, 1);
    END
END;

INSERT INTO cliente (dui, nombre, email, telefono, idEstado, FechaNacimiento)
VALUES ('12345678-9', 'Juan Pérez', 'juan@example.com', '12345678', 1, '2000-01-01');



-- 4. Prevenir la Eliminación de Productos/Libros/Medicamentos Asignados
-- a Usuarios: Crea un INSTEAD OF DELETE Trigger que impida la
-- eliminación de libros (en una biblioteca), medicamentos (en una farmacia), o
-- productos (para quien manejen productos) que ya están asignados o
-- reservados para un cliente.

CREATE OR ALTER TRIGGER trg_prevenirEliminacionProducto
ON producto
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @idProducto INT;

    SELECT @idProducto = idProducto FROM deleted;

    IF EXISTS (SELECT 1 FROM detalle_compra WHERE idProducto = @idProducto)
    BEGIN
        RAISERROR ('No se puede eliminar un producto con compras asociadas.', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM producto WHERE idProducto = @idProducto;
    END
END;

DELETE FROM producto WHERE idProducto = 2;


-- 5. Prevenir Actualización de Precios en Productos Antiguos: Crea un
-- INSTEAD OF UPDATE Trigger que impida actualizar los precios de productos
-- o tarifas que ya tienen más de 30 días en el sistema.

CREATE OR ALTER TRIGGER trg_prevenirActPreciosAntiguos
ON producto
INSTEAD OF UPDATE
AS
BEGIN
    DECLARE @fechaAdquisicion DATE, @idProducto INT, @nuevoPrecio DECIMAL(10, 2);

    SELECT @idProducto = idProducto, @nuevoPrecio = precio FROM inserted;

    SELECT @fechaAdquisicion = GETDATE() - 30;

    IF DATEDIFF(DAY, @fechaAdquisicion, GETDATE()) > 30
    BEGIN
        RAISERROR ('No se puede actualizar el precio de productos con más de 30 días.', 16, 1);
    END
    ELSE
    BEGIN
        UPDATE producto SET precio = @nuevoPrecio WHERE idProducto = @idProducto;
    END
END;

UPDATE producto SET precio = 150.00 WHERE idProducto = 1;


-- After Triggers

-- 1. Registrar Historial de Cambios en los Precios: Crea un AFTER UPDATE
-- Trigger que registre cada vez que se actualice el precio de un producto o
-- tarifa (en una aerolínea).

CREATE OR ALTER TRIGGER trg_historialCambiosProductos
ON producto
AFTER UPDATE
AS
BEGIN
    INSERT INTO historial_precios (idProducto, precioAnterior, fechaCambio)
    SELECT d.idProducto, d.precio, GETDATE()
    FROM deleted d
    INNER JOIN inserted i ON d.idProducto = i.idProducto
    WHERE d.precio <> i.precio;
END;


-- 2. Registrar Fecha de Última Consulta/Compra/Reserva: Crea un AFTER
-- UPDATE Trigger en una tabla de pacientes (clínica), clientes (zapatería o
-- aerolínea), o usuarios (biblioteca) que actualice el campo FechaUltimaVisita
-- cada vez que el cliente realiza una compra, consulta o reserva.

CREATE OR ALTER TRIGGER trg_historialCambiosProductos
ON producto
AFTER UPDATE
AS
BEGIN
    INSERT INTO historial_precios (idProducto, precioAnterior, fechaCambio)
    SELECT d.idProducto, d.precio, GETDATE()
    FROM deleted d
    INNER JOIN inserted i ON d.idProducto = i.idProducto
    WHERE d.precio <> i.precio;
END;


-- 3. Actualizar Stock Después de una Venta/Préstamo/Reserva: Crea un
-- AFTER INSERT Trigger que, después de insertar un pedido o reserva,
-- actualice el stock en la tabla de inventario y la fecha en la que se hizo

CREATE OR ALTER TRIGGER trg_registrarUltimaCompra
ON compra
AFTER INSERT
AS
BEGIN
    DECLARE @idCliente INT;

    SELECT @idCliente = idCliente FROM inserted;

    UPDATE cliente
    SET FechaUltimaCompra = GETDATE()
    WHERE idCliente = @idCliente;
END;


-- 4. Registrar Cambios en Información del Cliente/Paciente: Crea un AFTER
-- UPDATE Trigger en una tabla de clientes o pacientes que registre cualquier
-- cambio de información (nombre, dirección, teléfono) en una tabla de
-- auditoría.

CREATE OR ALTER TRIGGER trg_historialCliente
ON cliente
AFTER UPDATE
AS
BEGIN
    INSERT INTO auditoria_cliente (idCliente, cambios, fechaCambio)
    SELECT d.idCliente, 
           'Cambios: ' + 
           (CASE WHEN d.nombre <> i.nombre THEN 'Nombre, ' ELSE '' END) +
           (CASE WHEN d.telefono <> i.telefono THEN 'Teléfono, ' ELSE '' END),
           GETDATE()
    FROM deleted d
    INNER JOIN inserted i ON d.idCliente = i.idCliente
    WHERE d.nombre <> i.nombre OR d.telefono <> i.telefono;
END;


-- 5. Actualizar el Total de una Factura Después de Insertar Detalles: Crea un
-- AFTER INSERT Trigger que actualice el total de una factura en la tabla de
-- facturas después de que se inserte un nuevo detalle de factura.

CREATE OR ALTER TRIGGER trg_actualizarTotalCompra
ON detalle_compra
AFTER INSERT
AS
BEGIN
    DECLARE @idCompra INT;

    SELECT @idCompra = idCompra FROM inserted;

    UPDATE compra
    SET monto = (SELECT SUM(cantidad * precioCompra) FROM detalle_compra WHERE idCompra = @idCompra)
    WHERE idCompra = @idCompra;
END;

