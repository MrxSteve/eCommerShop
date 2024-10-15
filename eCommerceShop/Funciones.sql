use shopProject;

-- FUNCIONES 

CREATE FUNCTION dbo.fn_CalcularEdad (@fechaNacimiento DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @fechaNacimiento, GETDATE()) - 
           CASE WHEN MONTH(@fechaNacimiento) > MONTH(GETDATE()) 
                OR (MONTH(@fechaNacimiento) = MONTH(GETDATE()) 
                AND DAY(@fechaNacimiento) > DAY(GETDATE())) 
           THEN 1 ELSE 0 END;
END;



CREATE FUNCTION dbo.fn_ConvertirMinusculas (@texto NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    RETURN LOWER(@texto);
END;


CREATE FUNCTION dbo.fn_ListarProductosPorCategoria (@idCategoria INT)
RETURNS TABLE
AS
RETURN
(
    SELECT nombre, descripcion
    FROM producto
    WHERE idCategoria = @idCategoria
);
