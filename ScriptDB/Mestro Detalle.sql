CREATE DATABASE MAESTRO_DETALLE

USE MAESTRO_DETALLE



CREATE TABLE VENTA(

ID_VENTA INT PRIMARY KEY IDENTITY(1,1),
NUMERO_DOCUMENTO VARCHAR(20),
RAZON_SOCIAL VARCHAR(50),
TOTAL DECIMAL(10,2)

)


CREATE TABLE DETALLE_VENTA(

 ID_DETALLE_VENTA INT PRIMARY KEY IDENTITY(1,1),
 ID_VENTA INT REFERENCES VENTA(ID_VENTA),
 PRODUCTO VARCHAR(50),
 CANTIDAD INT,
 TOTAL DECIMAL(10,2)

)


CREATE PROCEDURE SP_GUARDAR_VENTA
(
    @Venta_xml XML
)
AS
BEGIN
    
      

        -- Insertar datos en la tabla VENTA
        INSERT INTO VENTA (NUMERO_DOCUMENTO, RAZON_SOCIAL, TOTAL)
        SELECT 
            NODO.ELEMENTO.value('NumeroDocumento[1]', 'VARCHAR(20)') AS NUMERO_DOCUMENTO,
            NODO.ELEMENTO.value('RazonSocial[1]', 'VARCHAR(50)') AS RAZON_SOCIAL,
            NODO.ELEMENTO.value('Total[1]', 'DECIMAL(10,2)') AS TOTAL
        FROM 
            @Venta_xml.nodes('Venta') AS NODO(ELEMENTO);

        -- Obtener el ID de la venta recién insertada
        DECLARE @IdVenta_Generado INT;
        SELECT @IdVenta_Generado = MAX(ID_VENTA) FROM VENTA;

        -- Insertar datos en la tabla DETALLE_VENTA
        INSERT INTO DETALLE_VENTA (ID_VENTA, PRODUCTO, PRECIO, CANTIDAD, TOTAL)
        SELECT 
            @IdVenta_Generado AS ID_VENTA,
            NODO.ELEMENTO.value('Producto[1]', 'VARCHAR(20)') AS PRODUCTO,
            NODO.ELEMENTO.value('Precio[1]', 'DECIMAL(10,2)') AS PRECIO,
            NODO.ELEMENTO.value('Cantidad[1]', 'INT') AS CANTIDAD,
            NODO.ELEMENTO.value('Total[1]', 'DECIMAL(10,2)') AS TOTAL
        FROM 
            @Venta_xml.nodes('Venta/DetalleVenta/Item') AS NODO(ELEMENTO);

    
    
END

SELECT * FROM VENTA
