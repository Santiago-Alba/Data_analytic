CREATE OR REPLACE VIEW v_venta_trimestre_canal AS
SELECT 	v.fecha,
        ca.Canal,
        SUM(v.Precio * v.Cantidad * v.Outlier)	AS venta,
        SUM(v.Cantidad * v.Outlier) AS venta_cantidad,
        SUM(v.Outlier)	AS venta_volumen,
        SUM(v.Precio * v.Cantidad) AS venta_outlier,
        SUM(v.Cantidad)	AS venta_cantidad_outlier,
        COUNT(v.IdVenta) AS venta_volumen_outlier
FROM venta v JOIN canal_venta ca
    	ON (v.IdCanal = ca.IdCanal)
GROUP BY v.fecha,
        ca.Canal;


CREATE OR REPLACE VIEW v_compra_mes_producto AS
SELECT 	co.fecha,
        p.IdProducto,
        p.Producto,
        t.TipoProducto,
        SUM(co.Precio * co.Cantidad)	AS compra,
        SUM(co.Cantidad)	AS compra_cantidad,
        COUNT(co.IdCompra) AS compra_volumen
FROM compra co JOIN producto p
	ON (co.IdProducto = p.IdProducto)
    	JOIN tipo_producto t
    	ON (p.IdTipoProducto = t.IdTipoProducto)
 	GROUP BY co.fecha,
        p.IdProducto,
        p.Producto,
        t.TipoProducto;

CREATE OR REPLACE VIEW v_gasto_mes_sucursal AS
SELECT 	g.fecha,
        s.IdSucursal,
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
        s.IdSucursal,
        s.Sucursal,
        t.Tipo_Gasto,
        l.Localidad,
        p.Provincia;

CREATE OR REPLACE VIEW v_venta_mes_sucursal AS
SELECT 	v.fecha,
        s.IdSucursal,
        s.Sucursal,
        l.Localidad,
        p.Provincia,
        SUM(v.Precio * v.Cantidad)	AS venta,
        SUM(v.Cantidad)				AS venta_cantidad,
        COUNT(v.IdVenta)			AS venta_volumen
FROM venta v JOIN sucursal s
    	ON (v.IdSucursal = s.IdSucursal)
    JOIN localidad l
    	ON (s.IdLocalidad = l.IdLocalidad)
    JOIN provincia p
    	ON (l.IdProvincia = p.IdProvincia)
WHERE v.Outlier = 1
GROUP BY v.fecha,
        s.IdSucursal,
        s.Sucursal,
        l.Localidad,
        p.Provincia;