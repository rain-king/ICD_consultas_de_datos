-- Equipo Whisky
-- Alumnos: Gustavo Murillo Vega, Jose Alfredo Sanchez Grijalva, Misael Enrique Urquidez Lopez, Isvi Gabriel Garcia Monzon
-- Instructor: Gerardo Gálvez Gámez
-- Lic. en Ing. en Ciencias de Datos
-- Tema: Laboratorio 7 Consultas Joins
-- Materia: Lenguajes de Consulta de Datos
-- Fecha: 30 - Marzo - 2025

-- 1. Listar las facturas registradas ordenadas por Apellido paterno del cliente.
SELECT c.apellido_paterno, f.*
FROM facturas f
INNER JOIN clientes c ON f.rfc_cliente = c.rfc_cliente
ORDER BY c.apellido_paterno;

-- 2. Listar las facturas registradas ordenadas por Apellido paterno del cliente, con estatus cancelado.
-- nota: la base de datos no tiene estatus de factura
SELECT c.apellido_paterno, f.*
FROM facturas f
INNER JOIN clientes c ON f.rfc_cliente = c.rfc_cliente
-- WHERE f.estatus = 'cancelado'
ORDER BY c.apellido_paterno;

-- 3. Determinar el total general de facturas canceladas a un cliente específico, mostrado los campos nombre y apellidos del cliente concatenados y el total, usar alias.
-- nota: no hay estatus de factura en la base de datos
SELECT CONCAT_WS(' ', c.nombre, c.apellido_paterno, c.apellido_materno) nombre_completo, COUNT(f.folio) total
FROM clientes c
LEFT JOIN facturas f ON c.rfc_cliente = f.rfc_cliente
-- WHERE f.estatus = 'cancelado'
GROUP BY c.rfc_cliente, c.nombre, c.apellido_paterno, c.apellido_materno
HAVING c.rfc_cliente = ( -- reemplace por la id del cliente deseado
	SELECT rfc_cliente
	FROM clientes
	LIMIT 1
);

-- 4. Determinar el total general de facturas activas de un cliente específico, mostrado los campos nombre y apellidos del cliente concatenados y el total, usar alias.
-- nota: no hay estatus para encontrar facturas activas
SELECT CONCAT_WS(' ', c.nombre, c.apellido_paterno, c.apellido_materno) nombre_completo, COUNT(f.folio) total
FROM clientes c
LEFT JOIN facturas f ON c.rfc_cliente = f.rfc_cliente
-- WHERE f.estatus = 'activo'
GROUP BY c.rfc_cliente, c.nombre, c.apellido_paterno, c.apellido_materno
HAVING c.rfc_cliente = ( -- reemplace por la id del cliente deseado
	SELECT rfc_cliente
	FROM clientes
	LIMIT 1
);

-- 5. Determinar cuántos clientes tienen facturas menores a 1000.
SELECT COUNT(*) nclientes
FROM (
	SELECT DISTINCT c.rfc_cliente
	FROM clientes c
	INNER JOIN facturas f ON c.rfc_cliente = f.rfc_cliente
	-- en este join hay un registro por factura
	WHERE EXISTS (
		SELECT 1
		FROM detalles_facturas df
		WHERE f.folio = df.folio_factura
		GROUP BY df.folio_factura
		HAVING SUM(df.cantidad*df.precio_venta) < 1000
	)
	-- con este WHERE solo hay facturas con total menor a 1000
);

-- 6. Listar el total que se le ha facturado a cada cliente.
SELECT f.rfc_cliente, SUM(COALESCE(cantidad*precio_venta, 0)) total
FROM facturas f
LEFT JOIN detalles_facturas df ON f.folio = df.folio_factura
GROUP BY f.rfc_cliente;

-- 7. Listar los datos de clientes con un promedio de facturación menor a 5000.
SELECT c.*
FROM clientes c
INNER JOIN (
	SELECT f.rfc_cliente, AVG(total_factura) promedio_facturacion
	FROM facturas f
	INNER JOIN (
		SELECT folio_factura, SUM(cantidad*precio_venta) total_factura
		FROM detalles_facturas
		GROUP BY folio_factura
	) tf ON tf.folio_factura = f.folio
	GROUP BY f.rfc_cliente
) pf ON c.rfc_cliente = pf.rfc_cliente
WHERE pf.promedio_facturacion < 5000;

-- 8. Listar los datos de los clientes registrados incluyendo a los que no tienen facturas registradas, mostrar el campo nombre y apellidos del cliente y el folio y total de facturación.
SELECT c.nombre, c.apellido_paterno, c.apellido_materno, tf.folio, tf.total_facturacion
FROM clientes c
LEFT JOIN (
	SELECT f.rfc_cliente, f.folio, SUM(df.precio_venta*df.cantidad) total_facturacion
	FROM facturas f
	INNER JOIN detalles_facturas df ON f.folio = df.folio_factura
	GROUP BY f.rfc_cliente, f.folio
) tf ON c.rfc_cliente = tf.rfc_cliente;

-- 9. Basado en el inciso anterior, pero mostrado los clientes que no tienen facturas registradas.
SELECT c.nombre, c.apellido_paterno, c.apellido_materno, tf.folio, tf.total_facturacion
FROM clientes c
LEFT JOIN (
	SELECT f.rfc_cliente, f.folio, SUM(df.precio_venta*df.cantidad) total_facturacion
	FROM facturas f
	INNER JOIN detalles_facturas df ON f.folio = df.folio_factura
	GROUP BY f.rfc_cliente, f.folio
) tf ON c.rfc_cliente = tf.rfc_cliente
WHERE tf.folio IS NULL;

-- 10. Obtener una unión de clientes y facturas.
SELECT *
FROM clientes c
FULL OUTER JOIN facturas f ON c.rfc_cliente = f.rfc_cliente;

-- 11. Listar el nombre de los clientes que adquirido cierto producto.
-- (digamos, el producto con el primer código)
SELECT DISTINCT c.nombre
FROM clientes c
INNER JOIN facturas f ON c.rfc_cliente = f.rfc_cliente
INNER JOIN detalles_facturas df ON f.folio = df.folio_factura
INNER JOIN articulos a ON df.codigo_articulo = a.codigo
WHERE a.codigo = ( -- reemplazar con codigo del articulo deseado
	SELECT MIN(codigo) FROM articulos
);

-- 12. Listar que productos no se encuentran en al menos una factura.
SELECT DISTINCT a.codigo, a.nombre
FROM articulos a
LEFT JOIN detalles_facturas df ON a.codigo = df.codigo_articulo
WHERE df.codigo_articulo IS NULL;