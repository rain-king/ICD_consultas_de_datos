-- Alumno: Gustavo Murillo Vega
-- Instructor: Gerardo Gálvez Gámez
-- Lic. en Ing. en Ciencias de Datos
-- Tema: Laboratorio 5 Subconsultas
-- Materia: Lenguajes de Consulta de Datos
-- Fecha: 12 - Marzo - 2025

---------------------------------------
------ 1. Subconsultas escalares ------
---------------------------------------
-- 1. ¿Qué artículos tienen un precio superior al precio promedio de todos los artículos? Listar código, nombre y precio (Ayuda a analizar qué productos están en un segmento de precios altos para ajustar estrategias de marketing).
SELECT codigo, nombre, precio
FROM articulos
WHERE precio > (
	SELECT AVG(precio) FROM articulos
);
-- 2. ¿Cuál es el artículo más caro que ha sido vendido en la empresa? Listar codigo_articulo, precio_venta (Permite conocer el producto con mayor valor de venta para entender su impacto en los ingresos).
WITH articulos_vendidos AS (
	SELECT codigo, precio
	FROM articulos
	WHERE EXISTS (
		SELECT 1 
		FROM detalles_facturas
		WHERE articulos.codigo = detalles_facturas.codigo_articulo
	)
) -- Se delimitaron los articulos a aquellos que han tenido factura, es decir los vendidos
SELECT *
FROM articulos_vendidos
WHERE precio = ( -- uso de subconsulta escalar
	SELECT MAX(precio)
	FROM articulos_vendidos
);

-- 3. ¿Cuál es el folio de la factura con la fecha más reciente? Listar folio y rfc_cliente
-- Permite conocer la última factura emitida en la empresa, lo que puede ser útil para auditorías o reportes financieros.
SELECT folio, rfc_cliente
FROM facturas
WHERE fecha = (
	SELECT MAX(fecha)
	FROM facturas
);

-- 4. ¿Cuáles son los clientes que viven en la localidad con el mayor número de clientes registrados? Listar nombre del cliente y localidad. Permite realizar estrategias de mercado o segmentación, es útil conocer la localidad con más clientes.
WITH clientes_localidades AS (
	SELECT l.id_localidad, l.id_municipio, l.id_estado, COUNT(*) numero_clientes
	FROM clientes c
	RIGHT JOIN localidades l
	ON (c.id_localidad, c.id_municipio, c.id_estado) = (l.id_localidad, l.id_municipio, l.id_estado) -- RIGHT porque no se cuentan clientes sin localidad registrada en el conteo de clientes por localidad
	GROUP BY l.id_localidad, l.id_municipio, l.id_estado
)
SELECT c.rfc_cliente, c.nombre nombre_cliente, l.nombre localidad
FROM clientes c
INNER JOIN localidades l
ON (c.id_localidad, c.id_municipio, c.id_estado) = (l.id_localidad, l.id_municipio, l.id_estado)
WHERE (l.id_localidad, l.id_municipio, l.id_estado) IN ( -- localidades que tengan el máximo de clientes
	SELECT id_localidad, id_municipio, id_estado
	FROM clientes_localidades
	WHERE numero_clientes = (
		SELECT MAX(numero_clientes)
		FROM clientes_localidades
	)
);

-- 5. ¿Cuál es el producto que ha sido vendido más veces en todas las facturas? Listar
-- codigo y nombre del producto. Permite conocer qué producto tiene la mayor
-- demanda para optimizar el inventario y estrategias de ventas.
WITH ventas_articulo AS (
	SELECT codigo_articulo, SUM(cantidad) AS cantidad_vendida
	FROM detalles_facturas
	GROUP BY codigo_articulo
)
SELECT va.codigo_articulo, a.nombre articulo
FROM ventas_articulo va
LEFT JOIN articulos a ON va.codigo_articulo = a.codigo
WHERE va.cantidad_vendida = (
	SELECT MAX(cantidad_vendida)
	FROM ventas_articulo
)
-- 6. Como cientifico de datos, proponer por lo menos dos subconsulta de este tipo,
-- PENDIENTE

------------------------------
-- 2. SUBCONSULTAS DE TABLA --
------------------------------
-- 1. ¿Cuáles son los clientes que han comprado más de un producto diferente en una sola factura? Listar el nombre_cliente, productos_distintos. Ayuda a analizar patrones de compra diversificada.

-- En este WITH se encuentran las facturas con más de un producto (dos o más registros de detalles_facturas por folio de factura)
WITH facturas_productos_distintos AS (
	SELECT f.rfc_cliente, df.folio_factura
	FROM detalles_facturas df
	INNER JOIN facturas f ON df.folio_factura = f.folio
	GROUP BY (f.rfc_cliente, df.folio_factura)
	HAVING COUNT(*) > 1
)
SELECT c.nombre nombre_cliente, a.nombre productos_distintos
FROM clientes c
-- Los siguientes join encuentran el nombre del artículo que se compro en conjunto con otro en la misma factura
INNER JOIN facturas_productos_distintos fpd  ON c.rfc_cliente = fpd.rfc_cliente
INNER JOIN detalles_facturas df ON fpd.folio_factura = df.folio_factura
INNER JOIN articulos a ON df.codigo_articulo = a.codigo;

-- 2. ¿Qué clientes han realizado compras por un monto total superior a 2,000?. Listar
-- rfc_cliente, total_facturado. Permite identificar a los clientes de alto valor y
-- segmentarlos para estrategias de fidelización o ventas cruzadas.
WITH total_por_cliente AS (
	SELECT f.rfc_cliente, (
		-- suma del gasto por cada articulo en una sola factura
		SELECT SUM(df.precio_venta*df.cantidad)
		FROM detalles_facturas df
		WHERE f.folio = df.folio_factura
		GROUP BY f.folio
	) AS total_facturado
	FROM facturas f
)
 -- se listan multiples veces los mismos clientes si han realizado más de una compra que exceda 2000 en gastos
SELECT * FROM total_por_cliente
WHERE total_facturado > 2000;

-- PENDIENTES…

-------------------------------------
-- 3. SUBCONSULTAS CORRELACIONADAS --
-------------------------------------
-- 1. Listar las facturas junto con el total de dinero generado en cada una. Listar: folio,
-- rfc_cliente, fecha, total_factura. Proporciona información clave sobre el volumen de
-- ventas por factura. Puede emplear la función COALESCE(..., 0).
SELECT f.folio, f.rfc_cliente, f.fecha, (
	SELECT SUM(df.cantidad*df.precio_venta)
	FROM detalles_facturas df
	WHERE f.folio = df.folio_factura
	GROUP BY f.folio
) AS total_factura
