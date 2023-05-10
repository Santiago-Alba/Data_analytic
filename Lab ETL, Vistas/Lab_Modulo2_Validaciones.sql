/*Chequear tamaño de campos Varchar*/
/*SELECT MAX(LENGTH(Provincia)) FROM cliente;*/
SELECT MAX(LENGTH(Nombre_Y_Apellido)) FROM cliente;
SELECT MAX(LENGTH(Domicilio)) FROM cliente;
SELECT MAX(LENGTH(Telefono)) FROM cliente;

SELECT MAX(LENGTH(Apellido)) FROM empleado;
SELECT MAX(LENGTH(Nombre)) FROM empleado;
/*SELECT MAX(LENGTH(Sucursal)) FROM empleado;
SELECT MAX(LENGTH(Sector)) FROM empleado;
SELECT MAX(LENGTH(Cargo)) FROM empleado;*/

SELECT MAX(LENGTH(Producto)) FROM producto;
/*SELECT MAX(LENGTH(Tipo)) FROM producto;*/

SELECT MAX(LENGTH(Domicilio)) FROM sucursal;
/*SELECT MAX(LENGTH(Sucursal)) FROM sucursal;*/

/*Columnas Vacías
SELECT DISTINCT Col10 FROM cliente;*/

/*Creacion de clave única tabla empleados*/
SELECT Sucursal, IdEmpleado, COUNT(*) FROM `empleado` GROUP BY Sucursal, IdEmpleado HAVING COUNT(*) > 1;

/*Empleados sin sector y/o cargo*/
SELECT * FROM empleado WHERE IdSector = 0;
SELECT * FROM empleado WHERE IdCargo = 0;

/*Localidades con el mismo nombre de provincias distintas*/
SELECT Localidad FROM localidad GROUP BY Localidad HAVING COUNT(*) > 1;

SELECT * FROM localidad 
WHERE Localidad IN ('El Talar',
                    'Los Alamos',
                    'Malvinas Argentinas',
                    'San Andres',
                    'San Martin',
                    'San Miguel',
                    'Bajo Grande',
                    'El Vergel',
                    'San Roque',
                    'Fray Luis Beltran',
                    'Sin Dato')
ORDER BY Localidad, Provincia;

/*Venta con precio o cantidad nulo ó en cero*/
SELECT * FROM venta WHERE Precio IS NULL OR Precio = 0 OR Cantidad IS NULL OR Cantidad = 0;
/*Compra con precio o cantidad nulo ó en cero*/
SELECT * FROM compra WHERE Precio IS NULL OR Precio = 0 OR Cantidad IS NULL OR Cantidad = 0;
/*Gasto con monto nulo ó en cero*/
SELECT * FROM gasto WHERE Monto IS NULL OR Monto = 0;
