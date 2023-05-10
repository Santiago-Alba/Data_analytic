/*Discretización*/
ALTER TABLE `cliente` ADD `Rango_Etario` VARCHAR(20) NOT NULL DEFAULT '-' AFTER `Edad`;

UPDATE cliente SET Rango_Etario = '1_Hasta 30 años' WHERE Edad <= 30;
UPDATE cliente SET Rango_Etario = '2_De 31 a 40 años' WHERE Edad <= 40 AND Rango_Etario = '-';
UPDATE cliente SET Rango_Etario = '3_De 41 a 50 años' WHERE Edad <= 50 AND Rango_Etario = '-';
UPDATE cliente SET Rango_Etario = '4_De 51 a 60 años' WHERE Edad <= 60 AND Rango_Etario = '-';
UPDATE cliente SET Rango_Etario = '5_Desde 60 años' WHERE Edad > 60 AND Rango_Etario = '-';

/*Motivos:
4-No existe cliente
5-No existe producto
6-No existe empleado
7-No existe sucursal
*/
INSERT INTO aux_venta (IdVenta, Fecha, Fecha_Entrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, Cantidad, Motivo)
SELECT v.IdVenta, v.Fecha, v.Fecha_Entrega, v.IdCliente, v.IdSucursal, v.IdEmpleado, v.IdProducto, v.Precio, v.Cantidad, 4
FROM venta v WHERE v.IdCliente NOT IN (SELECT c.IdCliente FROM cliente c);

INSERT INTO aux_venta (IdVenta, Fecha, Fecha_Entrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, Cantidad, Motivo)
SELECT v.IdVenta, v.Fecha, v.Fecha_Entrega, v.IdCliente, v.IdSucursal, v.IdEmpleado, v.IdProducto, v.Precio, v.Cantidad, 5
FROM venta v WHERE v.IdProducto NOT IN (SELECT p.IdProducto FROM producto p);

INSERT INTO aux_venta (IdVenta, Fecha, Fecha_Entrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, Cantidad, Motivo)
SELECT v.IdVenta, v.Fecha, v.Fecha_Entrega, v.IdCliente, v.IdSucursal, v.IdEmpleado, v.IdProducto, v.Precio, v.Cantidad, 6
FROM venta v WHERE v.IdEmpleado NOT IN (SELECT e.IdEmpleado FROM empleado e);

INSERT INTO aux_venta (IdVenta, Fecha, Fecha_Entrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, Cantidad, Motivo)
SELECT v.IdVenta, v.Fecha, v.Fecha_Entrega, v.IdCliente, v.IdSucursal, v.IdEmpleado, v.IdProducto, v.Precio, v.Cantidad, 7
FROM venta v WHERE v.IdSucursal NOT IN (SELECT s.IdSucursal FROM sucursal s);

DELETE FROM venta WHERE IdVenta IN (SELECT IdVenta FROM aux_venta WHERE Motivo > 1);

/*Deteccion y corrección de Outliers sobre ventas*/
/*Motivos:
2-Outlier de Cantidad
3-Outlier de Precio
*/
INSERT INTO aux_venta (IdVenta, Fecha, Fecha_Entrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, Cantidad, Motivo)
SELECT IdVenta, Fecha, Fecha_Entrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, Cantidad, 2
FROM venta v join (SELECT AVG(Cantidad) As Promedio, STDDEV(Cantidad) as Desv FROM venta) v2 
WHERE v.Cantidad > (v2.Promedio + (3 * v2.Desv)) OR v.Cantidad < 1;

INSERT INTO aux_venta (IdVenta, Fecha, Fecha_Entrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, Cantidad, Motivo)
SELECT v.IdVenta, v.Fecha, v.Fecha_Entrega, v.IdCliente, v.IdSucursal, v.IdEmpleado, v.IdProducto, v.Precio, v.Cantidad, 3
FROM venta v 
JOIN (SELECT IdProducto, AVG(Precio) As Promedio, STDDEV(Precio) as Desv FROM venta GROUP BY IdProducto) v2
	on (v.IdProducto = v2.IdProducto)
WHERE v.Precio > (v2.Promedio + (3 * v2.Desv)) OR v.Precio < 0;

ALTER TABLE `venta` ADD `Outlier` TINYINT NOT NULL DEFAULT '1' AFTER `Cantidad`;

UPDATE venta v JOIN aux_venta a
	ON (v.IdVenta = a.IdVenta AND a.Motivo IN (2,3))
SET v.Outlier = 0;