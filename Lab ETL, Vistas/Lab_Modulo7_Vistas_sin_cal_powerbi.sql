CREATE OR REPLACE VIEW v_venta_mes_producto AS
SELECT 	v.fecha,
        p.Producto,
        t.TipoProducto,
        lo.Localidad,
        pr.Provincia,
        SUM(v.Precio * v.Cantidad)	AS venta,
        SUM(v.Cantidad)				AS venta_cantidad,
        COUNT(v.IdVenta)			AS venta_volumen
FROM venta v JOIN producto p
		ON (v.IdProducto = p.IdProducto)
    JOIN tipo_producto t
    	ON (p.IdTipoProducto = t.IdTipoProducto)
    JOIN cliente cl
    	ON (v.IdCliente = cl.IdCliente)
    JOIN Localidad lo
    	ON (cl.IdLocalidad = lo.IdLocalidad)
    JOIN provincia pr
    	ON (lo.IdProvincia = pr.IdProvincia)
WHERE v.IdVenta NOT IN (SELECT IdVenta FROM aux_venta WHERE Motivo IN (1,2,3))
GROUP BY v.fecha,
	p.Producto,
        t.TipoProducto,
        lo.Localidad,
        pr.Provincia;
		
CREATE OR REPLACE VIEW v_venta_mes_sucursal AS
SELECT  v.fecha,
        s.IdSucursal,
        s.Sucursal,
        s.Latitud,
        s.Longitud,
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
 WHERE v.IdVenta NOT IN (SELECT IdVenta FROM aux_venta WHERE Motivo IN (1,2,3))
GROUP BY v.fecha,
	s.IdSucursal,
        s.Sucursal,
        s.Latitud,
        s.Longitud,
        l.Localidad,
        p.Provincia;
		
CREATE OR REPLACE VIEW v_venta_mes_cliente AS
SELECT 	v.fecha,
        cl.Nombre_y_Apellido,
        cl.Domicilio,
        cl.Latitud,
        cl.Longitud,
        l.Localidad,
        p.Provincia,
        SUM(v.Precio * v.Cantidad)	AS venta,
        SUM(v.Cantidad)				AS venta_cantidad,
        COUNT(v.IdVenta)			AS venta_volumen
FROM venta v JOIN cliente cl
    	ON (v.IdCliente = cl.IdCliente)
    JOIN localidad l
    	ON (cl.IdLocalidad = l.IdLocalidad)
    JOIN provincia p
    	ON (l.IdProvincia = p.IdProvincia)
WHERE v.IdVenta NOT IN (SELECT IdVenta FROM aux_venta WHERE Motivo IN (1,2,3))
GROUP BY v.fecha,
        cl.Nombre_y_Apellido,
        cl.Domicilio,
        cl.Latitud,
        cl.Longitud,
        l.Localidad,
        p.Provincia;
		
