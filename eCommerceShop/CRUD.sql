
-- CRUD

CREATE OR ALTER PROCEDURE dbo.sp_SeleccionarProductos
    @filtro NVARCHAR(100) = NULL -- Filtro para búsqueda por nombre
AS
BEGIN
    SELECT idProducto, nombre, descripcion, precio, stock
    FROM producto
    WHERE nombre LIKE '%' + @filtro + '%';
END;
GO

EXEC dbo.sp_SeleccionarProductos @filtro = 'Nuevo';


CREATE OR ALTER PROCEDURE dbo.sp_ActualizarProducto
    @idProducto INT,
    @nombre NVARCHAR(100),
    @descripcion NVARCHAR(MAX),
    @precio DECIMAL(10, 2),
    @stock INT
AS
BEGIN
    UPDATE producto
    SET nombre = @nombre,
        descripcion = @descripcion,
        precio = @precio,
        stock = @stock
    WHERE idProducto = @idProducto;
END;
GO

EXEC dbo.sp_ActualizarProducto 
    @idProducto = 1,
    @nombre = 'Nuevo Nombre',
    @descripcion = 'Descripción actualizada',
    @precio = 999.99,
    @stock = 10;


CREATE OR ALTER PROCEDURE dbo.sp_EliminarProducto
    @idProducto INT
AS
BEGIN
    DELETE FROM producto
    WHERE idProducto = @idProducto;
END;
GO

EXEC dbo.sp_EliminarProducto @idProducto = 7;



-- CRUD Clientes

CREATE OR ALTER PROCEDURE dbo.sp_SeleccionarClientes
    @filtro NVARCHAR(255) = NULL -- Filtro para búsqueda por nombre
AS
BEGIN
    SELECT idCliente, dui, nombre, email, telefono, idDireccion, idEstado
    FROM cliente
    WHERE nombre LIKE '%' + @filtro + '%';
END;
GO

EXEC dbo.sp_SeleccionarClientes @filtro = 'Juan';


CREATE OR ALTER PROCEDURE dbo.sp_InsertarCliente
    @dui NVARCHAR(10),
    @nombre NVARCHAR(255),
    @email NVARCHAR(255),
    @telefono NVARCHAR(20),
    @idDireccion INT,
    @idEstado INT
AS
BEGIN
    INSERT INTO cliente (dui, nombre, email, telefono, idDireccion, idEstado)
    VALUES (@dui, @nombre, @email, @telefono, @idDireccion, @idEstado);
END;
GO

EXEC dbo.sp_InsertarCliente 
    @dui = '12345678-9', 
    @nombre = 'Pedro Martinez', 
    @email = 'pedro.martinez@mail.com', 
    @telefono = '555-1234', 
    @idDireccion = 1, 
    @idEstado = 1;


CREATE OR ALTER PROCEDURE dbo.sp_ActualizarCliente
    @idCliente INT,
    @dui NVARCHAR(10),
    @nombre NVARCHAR(255),
    @email NVARCHAR(255),
    @telefono NVARCHAR(20),
    @idDireccion INT,
    @idEstado INT
AS
BEGIN
    UPDATE cliente
    SET dui = @dui,
        nombre = @nombre,
        email = @email,
        telefono = @telefono,
        idDireccion = @idDireccion,
        idEstado = @idEstado
    WHERE idCliente = @idCliente;
END;
GO

EXEC dbo.sp_ActualizarCliente 
    @idCliente = 1, 
    @dui = '98765432-1', 
    @nombre = 'Juan Perez Actualizado', 
    @email = 'juan.perez.nuevo@mail.com', 
    @telefono = '555-9876', 
    @idDireccion = 2, 
    @idEstado = 1;


CREATE OR ALTER PROCEDURE dbo.sp_EliminarCliente
    @idCliente INT
AS
BEGIN
    DELETE FROM cliente
    WHERE idCliente = @idCliente;
END;
GO

EXEC dbo.sp_EliminarCliente @idCliente = 1;
