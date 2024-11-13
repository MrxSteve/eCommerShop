-- Vista 1: Lista de productos y su categoría
CREATE VIEW vw_ProductosCategorias AS
SELECT p.nombre AS producto, c.categoria
FROM producto p
INNER JOIN categoria c ON p.idCategoria = c.idCategoria;

-- Vista 2: Clientes y su estado actual
CREATE VIEW vw_ClientesEstado AS
SELECT c.nombre AS cliente, e.estado
FROM cliente c
INNER JOIN estado e ON c.idEstado = e.idEstado;

-- Vista 3: Compras y su estado
CREATE VIEW vw_ComprasEstado AS
SELECT co.idCompra, co.monto, e.estado
FROM compra co
INNER JOIN estado e ON co.idEstado = e.idEstado;

-- Vista 4: Productos y su stock con estado
CREATE VIEW vw_ProductosStockEstado AS
SELECT p.nombre AS producto, p.stock, e.estado
FROM producto p
LEFT JOIN estado e ON p.idEstado = e.idEstado;

-- Vista 5: Clientes y sus direcciones
CREATE VIEW vw_ClientesDirecciones AS
SELECT c.nombre AS cliente, d.linea1 AS direccion, m.municipio, dep.departamento
FROM cliente c
LEFT JOIN direcciones d ON c.idDireccion = d.idDireccion
LEFT JOIN distrito dist ON d.idDistrito = dist.idDistrito
LEFT JOIN municipio m ON dist.idMunicipio = m.idMunicipio
LEFT JOIN departamento dep ON m.idDepartamento = dep.idDepartamento;

-- Vista 6: Detalles de compras con productos
CREATE VIEW vw_DetallesComprasProductos AS
SELECT dc.idDetalle, co.idCompra, p.nombre AS producto, dc.cantidad, dc.precioCompra
FROM detalle_compra dc
INNER JOIN compra co ON dc.idCompra = co.idCompra
INNER JOIN producto p ON dc.idProducto = p.idProducto;

-- Vista 7: Compras por cliente
CREATE VIEW vw_ComprasClientes AS
SELECT c.nombre AS cliente, co.idCompra, co.monto, co.fechaCompra
FROM compra co
INNER JOIN cliente c ON co.idCliente = c.idCliente;

-- Vista 8: Productos con sus categorías y estados
CREATE VIEW vw_ProductosCategoriasEstado AS
SELECT p.nombre AS producto, c.categoria, e.estado
FROM producto p
LEFT JOIN categoria c ON p.idCategoria = c.idCategoria
LEFT JOIN estado e ON p.idEstado = e.idEstado;

-- Vista 9: Clientes con su dirección y municipio
CREATE VIEW vw_ClientesMunicipios AS
SELECT c.nombre AS cliente, m.municipio
FROM cliente c
LEFT JOIN direcciones d ON c.idDireccion = d.idDireccion
LEFT JOIN distrito dist ON d.idDistrito = dist.idDistrito
LEFT JOIN municipio m ON dist.idMunicipio = m.idMunicipio;

-- Vista 10: Lista de municipios y sus departamentos
CREATE VIEW vw_MunicipiosDepartamentos AS
SELECT m.municipio, dep.departamento
FROM municipio m
INNER JOIN departamento dep ON m.idDepartamento = dep.idDepartamento;

-- Vista 11: Departamentos con municipios, incluyendo los que no tienen
CREATE VIEW vw_DepartamentosConMunicipios AS
SELECT dep.departamento, m.municipio
FROM departamento dep
LEFT JOIN municipio m ON dep.idDepartamento = m.idDepartamento;

-- Vista 12: Clientes y compras con estado
CREATE VIEW vw_ClientesComprasEstado AS
SELECT c.nombre AS cliente, co.idCompra, co.monto, e.estado
FROM cliente c
INNER JOIN compra co ON c.idCliente = co.idCliente
LEFT JOIN estado e ON co.idEstado = e.idEstado;

-- Vista 13: Productos y sus detalles de compra
CREATE VIEW vw_ProductosDetallesCompra AS
SELECT p.nombre AS producto, dc.cantidad, dc.precioCompra
FROM producto p
INNER JOIN detalle_compra dc ON p.idProducto = dc.idProducto;

-- Vista 14: Distritos y sus municipios
CREATE VIEW vw_DistritosMunicipios AS
SELECT dist.distrito, m.municipio
FROM distrito dist
LEFT JOIN municipio m ON dist.idMunicipio = m.idMunicipio;

-- Vista 15: Categorías con productos
CREATE VIEW vw_CategoriasProductos AS
SELECT c.categoria, p.nombre AS producto
FROM categoria c
LEFT JOIN producto p ON c.idCategoria = p.idCategoria;
