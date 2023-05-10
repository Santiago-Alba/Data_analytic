CREATE OR REPLACE VIEW v_venta_mes_empleado_sucursal AS
SELECT  v.fecha,
        e.Apellido,
        e.Nombre,
        se.Sector,
        ca.Cargo,
        s.Sucursal,
        SUM(v.Precio * v.Cantidad * v.Outlier)		AS venta,
        SUM(v.Cantidad * v.Outlier)					AS venta_cantidad,
        SUM(v.Outlier)								AS venta_volumen,
        SUM(v.Precio * v.Cantidad)		AS venta_outlier,
        SUM(v.Cantidad)					AS venta_cantidad_outlier,
        COUNT(v.IdVenta)				AS venta_volumen_outlier
FROM venta v JOIN empleado e
		ON (v.IdEmpleado = e.IdEmpleado)
	JOIN sector se
    	ON (se.IdSector = e.IdSector)
    JOIN cargo ca
    	ON (ca.IdCargo = e.IdCargo)
	JOIN sucursal s
    	ON (v.IdSucursal = s.IdSucursal)
    
GROUP BY v.fecha,
        e.Apellido,
        e.Nombre,
        se.Sector,
        ca.Cargo,
        s.Sucursal;
		
CREATE OR REPLACE VIEW v_venta_trimestre_cliente AS
SELECT 	v.fecha,
        c.Nombre_y_Apellido,
        c.Edad,
		c.Rango_Etario,
        l.Localidad,
        p.Provincia,
        cn.Canal,
        SUM(v.Precio * v.Cantidad * v.Outlier)		AS venta,
        SUM(v.Cantidad * v.Outlier)					AS venta_cantidad,
        SUM(v.Outlier)								AS venta_volumen,
        SUM(v.Precio * v.Cantidad)		AS venta_outlier,
        SUM(v.Cantidad)					AS venta_cantidad_outlier,
        COUNT(v.IdVenta)				AS venta_volumen_outlier
FROM venta v JOIN cliente c
		ON (v.IdCliente = c.IdCliente)
    JOIN localidad l
    	ON (c.IdLocalidad = l.IdLocalidad)
    JOIN provincia p
    	ON (l.IdProvincia = p.IdProvincia)
    	JOIN canal_venta cn
    	ON (v.IdCanal = cn.IdCanal)
GROUP BY v.fecha,
        c.Nombre_y_Apellido,
        c.Edad,
		c.Rango_Etario,
        l.Localidad,
        p.Provincia,
        cn.Canal;
		
CREATE OR REPLACE VIEW v_venta_mes_producto AS
SELECT 	v.fecha,
        p.Producto,
        t.TipoProducto,
        SUM(v.Precio * v.Cantidad * v.Outlier)		AS venta,
        SUM(v.Cantidad * v.Outlier)					AS venta_cantidad,
        SUM(v.Outlier)								AS venta_volumen,
        SUM(v.Precio * v.Cantidad)		AS venta_outlier,
        SUM(v.Cantidad)					AS venta_cantidad_outlier,
        COUNT(v.IdVenta)				AS venta_volumen_outlier
FROM venta v JOIN producto p
		ON (v.IdProducto = p.IdProducto)
    JOIN tipo_producto t
    	ON (p.IdTipoProducto = t.IdTipoProducto)
   
GROUP BY v.fecha,
        p.Producto,
        t.TipoProducto;
		
CREATE OR REPLACE VIEW v_venta_trimestre_canal AS
SELECT v.fecha,
        ca.Canal,
        SUM(v.Precio * v.Cantidad * v.Outlier)		AS venta,
        SUM(v.Cantidad * v.Outlier)					AS venta_cantidad,
        SUM(v.Outlier)								AS venta_volumen,
        SUM(v.Precio * v.Cantidad)		AS venta_outlier,
        SUM(v.Cantidad)					AS venta_cantidad_outlier,
        COUNT(v.IdVenta)				AS venta_volumen_outlier
FROM venta v JOIN canal_venta ca
    	ON (v.IdCanal = ca.IdCanal)
   
GROUP BY v.fecha,
        ca.Canal;
		
CREATE OR REPLACE VIEW v_gasto_mes_sucursal AS
SELECT 	g.fecha,
        s.Sucursal,
        t.Tipo_Gasto,
        l.Localidad,
        p.Provincia,
        SUM(g.Monto)		AS gasto,
        COUNT(g.IdGasto)	AS gasto_volumen
FROM gasto g JOIN sucursal s
    	ON (g.IdSucursal = s.IdSucursal)
    JOIN localidad l
    	ON (s.IdLocalidad = l.IdLocalidad)
    JOIN provincia p
    	ON (l.IdProvincia = p.IdProvincia)
    JOIN tipo_gasto t
    	ON (g.IdTipoGasto = t.IdTipoGasto)
    
GROUP BY g.fecha,
        s.Sucursal,
        t.Tipo_Gasto,
        l.Localidad,
        p.Provincia;
		
CREATE OR REPLACE VIEW v_compra_mes_producto AS
SELECT 	co.fecha,
        p.Producto,
        t.TipoProducto,
        SUM(co.Precio * co.Cantidad)	AS compra,
        SUM(co.Cantidad)				AS compra_cantidad,
        COUNT(co.IdCompra)				AS compra_volumen
FROM compra co JOIN producto p
		ON (co.IdProducto = p.IdProducto)
    JOIN tipo_producto t
    	ON (p.IdTipoProducto = t.IdTipoProducto)
   
GROUP BY co.fecha,
        p.Producto,
        t.TipoProducto;
