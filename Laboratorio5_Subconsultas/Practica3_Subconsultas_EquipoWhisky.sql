-- Equipo Whisky
-- Alumnos: Gustavo Murillo Vega, Jose Alfredo Sanchez Grijalva, …
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
	SELECT l.id_localidad, l.id_municipio, l.id_estado, l.nombre, COUNT(*) numero_clientes
	FROM clientes c
	RIGHT JOIN localidades l
	ON (c.id_localidad, c.id_municipio, c.id_estado) = (l.id_localidad, l.id_municipio, l.id_estado)
	GROUP BY l.id_localidad, l.id_municipio, l.id_estado
)
SELECT c.nombre nombre_cliente, cl.nombre localidad
FROM clientes c
INNER JOIN clientes_localidades cl
ON (c.id_localidad, c.id_municipio, c.id_estado) = (cl.id_localidad, cl.id_municipio, cl.id_estado)
WHERE cl.numero_clientes = (
	SELECT MAX(cl_sub.numero_clientes)
	FROM clientes_localidades cl_sub
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
);

-- 6. Como cientifico de datos, proponer por lo menos dos subconsulta de este tipo,
-- #1 Articulos que cuesten más del doble del más barato
SELECT codigo, nombre, precio
FROM articulos
WHERE precio > (
	SELECT 2*MIN(precio)
	FROM articulos
);
-- #2 Artículos vendidos el mayor número de veces en una sola factura
SELECT a.nombre, a.precio
FROM articulos a
WHERE a.codigo IN (
	SELECT df.codigo_articulo
	FROM detalles_facturas df
	WHERE cantidad = ( -- subconsulta escalar
		SELECT MAX(cantidad)
		FROM detalles_facturas
	)
);











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
INNER JOIN facturas_productos_distintos fpd ON c.rfc_cliente = fpd.rfc_cliente
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

-- 3. ¿Qué artículos han sido vendidos en más de 5 unidades? Listar codigo_articulo,
-- total_vendido. Permite identificar los productos más demandados y optimizar el
-- inventario en función de la demanda.
WITH articulos_vendidos AS (
	SELECT a.codigo, SUM(df.cantidad) total_vendido
	FROM detalles_facturas df
	INNER JOIN articulos a ON df.codigo_articulo = a.codigo
	GROUP BY a.codigo
)
SELECT * FROM articulos_vendidos
WHERE total_vendido > 5;

-- 4. ¿Cuáles son las facturas que incluyen más de 3 artículos distintos? Listar
-- Folio_fatura,total_articulos. Permite analizar el comportamiento de compra y detectar
-- patrones de consumo que ayuden a personalizar recomendaciones.
SELECT folio_factura, COUNT(*) total_articulos
FROM detalles_facturas df
GROUP BY folio_factura
HAVING COUNT(*) > 3; -- como un registro de df tiene como llave (codigo_articulo, folio_factura), un registro distinto con la misma factura en la tabla corresponde a un artículo distinto

-- 5. ¿Qué estados tienen más de 10 clientes registrados? Listar id_estado, totalclientes.
-- Permite identificar regiones con alta densidad de clientes para mejorar estrategias de
-- distribución y marketing.
-- SELECT l.id_estado, COUNT(*) AS totalclientes
-- FROM localidades l
-- INNER JOIN clientes c ON (c.id_estado, c.id_municipio, c.id_localidad) = (l.id_estado, l.id_municipio, l.id_localidad)
-- GROUP BY l.id_estado
-- HAVING COUNT(*) > 10;
SELECT c.id_estado, COUNT(*) AS totalclientes
FROM clientes c
GROUP BY c.id_estado
HAVING COUNT(*) > 10;

-- 6. Como cientifico de datos, proponer por lo menos dos subconsulta de este tipo,
-- explicando su propósito, qué se logra con como científico de datos y su solución.
-- #1 Cantidad promedio vendida por artículo
SELECT a.nombre, COALESCE(cantidad_promedio, 0) cantidad_promedio_vendida
FROM (
	SELECT codigo_articulo, AVG(cantidad) AS cantidad_promedio
	FROM detalles_facturas df
	GROUP BY codigo_articulo
) subtabla
RIGHT JOIN articulos a ON subtabla.codigo_articulo = a.codigo;
-- #2 Precio de venta promedio de cada artículo vendido contra precio en inventario
SELECT a.nombre, precio_venta_promedio, a.precio precio
FROM (
	SELECT codigo_articulo, AVG(precio_venta) precio_venta_promedio
	FROM detalles_facturas
	GROUP BY codigo_articulo
) subtabla
INNER JOIN articulos a ON subtabla.codigo_articulo = a.codigo;











-------------------------------------
-- 3. SUBCONSULTAS CORRELACIONADAS --
-------------------------------------
-- 1. Listar las facturas junto con el total de dinero generado en cada una. Listar: folio,
-- rfc_cliente, fecha, total_factura. Proporciona información clave sobre el volumen de
-- ventas por factura. Puede emplear la función COALESCE(..., 0).

-- Si la cantidad o el precio de venta fuera nulo, se suma 0 en ese registro en la subconsulta
SELECT f.folio, f.rfc_cliente, f.fecha, (
	SELECT SUM(COALESCE(df.cantidad*df.precio_venta, 0))
	FROM detalles_facturas df
	WHERE f.folio = df.folio_factura
	GROUP BY f.folio
) AS total_factura
FROM facturas f;

-- 2. Listar los clientes junto con la cantidad de facturas que han generado. Listar:
-- rfc_cliente, nombre, apellido_paterno, apellido_materno, cantidad_facturas. Permite
-- conocer qué clientes tienen mayor actividad comercial, lo que ayuda en estrategias de
-- fidelización o segmentación de clientes.
SELECT c.rfc_cliente, c.nombre, c.apellido_paterno, c.apellido_materno, (
	SELECT COUNT(*)
	FROM facturas f
	WHERE c.rfc_cliente = f.rfc_cliente
) cantidad_facturas
FROM clientes c;

-- 3. Listar los municipios junto con la cantidad de localidades que pertenecen a cada uno.
-- Listar: id_estado, id_municipio, nombre, cantidad_localidades. Ayuda a analizar la
-- distribución de localidades dentro de cada municipio, lo que permite tomar decisiones
-- sobre servicios o infraestructura.
SELECT id_estado, id_municipio, nombre, (
	SELECT COUNT(*)
	FROM localidades l
	WHERE (m.id_estado, m.id_municipio) = (l.id_estado, l.id_municipio)
)
FROM municipios m;

-- 4. Listar los estados junto con la cantidad de municipios que tienen:
--Listar: id_estado,nombre cantidad_municipios.
--Util para estudios geograficos y administratios sobre la cantidad de municipios por estado
SELECT id_estado, nombre, (
	SELECT COUNT(*)
	FROM municipios m
	WHERE m.id_estado = e.id_estado
) AS cantidad_municipios
FROM estados e;

-- 5.Listar los artículos junto con la cantidad total de veces que han sido vendidos en facturas
--Listar: codigo, nombre, cantidad_vendida.
--Ayuda en la estión de inventario y deteccion de productos más vvendidos.
SELECT codigo, nombre, (
	SELECT COALESCE(SUM(df.cantidad), 0)
	FROM detalles_facturas df
	WHERE df.codigo_articulo = a.codigo
) AS cantidad_vendida
FROM articulos a;

--6. Como cientifico de datos, proponer po lo menos dos subconsultas de este tipo, explicando su propósito,
--qué se logra con como cientifico de datos y su solución.
-- #1 Número de artículos distintos comprados por cliente: permite reconocer la necesidad de diversificar los articulos vendidos
SELECT rfc_cliente, (
	SELECT COUNT(*)
	FROM (
		SELECT DISTINCT codigo_articulo
		FROM detalles_facturas
		WHERE folio_factura IN (
			SELECT folio
			FROM facturas f
			WHERE f.rfc_cliente = c.rfc_cliente
		)
	)
) numero_articulos
FROM clientes c;

-- #2 Ventas por localidad: permite conocer qué localidades generan más ganancias
SELECT l.nombre, (
	SELECT COALESCE(SUM(cantidad*precio_venta), 0)
	FROM (
		SELECT cantidad, precio_venta
		FROM detalles_facturas
		WHERE folio_factura IN (
			SELECT folio
			FROM facturas
			WHERE rfc_cliente IN (
				SELECT rfc_cliente
				FROM clientes c
				WHERE (c.id_estado, c.id_municipio, c.id_localidad) = (l.id_estado, l.id_municipio, l.id_localidad)
			)
		)
	)
) venta_total
FROM localidades l
ORDER BY venta_total DESC;










-----------------------------------
-- 4. PREDICADOS EN SUBCONSULTAS --
-----------------------------------
--IN Y NOT IN
--1. ¿Cualés son los productos que no se han vendido? Listar codigo y nombre.
--Permite conocer qué producto no tienen demanda para definir estrategias de ventas.
SELECT codigo, nombre
FROM articulos
WHERE codigo NOT IN (
	SELECT codigo_articulo
	FROM detalles_facturas
)
ORDER BY codigo ASC;
--2. ¿Cuáles son los clientes que han realizado al menos una compra? 
--Listar:rfc_cliente, nombre, apellido_paterno, apellido_materno. 
--Permite identificar clientes activos que han realizado compras permite analizar tendencias de
--consumo, segmentar clientes y desarrollar estrategias de fidelización.
SELECT rfc_cliente, nombre, apellido_paterno, apellido_materno
FROM clientes
WHERE rfc_cliente IN ( 
	SELECT rfc_cliente
	FROM facturas
);

--3. ¿Cuáles son los artículos que no han sido vendidos en ninguna factura? 
--Listar:codigo, nombre, precio.
--Identificar productos sin demanda es clave
--para optimizar el inventario, mejorar estrategias de ventas y reducir costos de almacenamiento.
SELECT codigo, nombre, precio
FROM articulos
WHERE codigo NOT IN (
	SELECT codigo_articulo
	FROM detalles_facturas
)
ORDER BY precio DESC;

--4. Listar estados que no tienen localidades registradas. 
--Listar: id_estado,nombre. 
--Permite identificar estados sin localidades registradas es importante
--para detectar inconsistencias en los datos, mejorar la calidad de la información
--y garantizar la cobertura completa en análisis geoespaciales.
SELECT id_estado, nombre
FROM estados
WHERE id_estado NOT IN (
	SELECT id_estado
	FROM localidades
);
	
--5. Como cientifico de datos, proponer por lo menos dos subconsulta de este
--tipo, explicando su propósito, qué se logra con como científico de datos y su
--solución.
-- PENDIENTE

--EXISTS
--1. ¿Cuáles son los productos que no se an vendido? Listar codigo y nombre.
--Permite conocer qué producto no tienen demanda para definir estrategias de
--ventas.
SELECT codigo, nombre
FROM articulos a
WHERE NOT EXISTS (
	SELECT 1
	FROM detalles_facturas df
	WHERE df.codigo_articulo = a.codigo
)
ORDER BY codigo ASC;

--2. ¿Cuáles son los clientes que han realizado al menos una compra? 
--Listar:rfc_cliente, nombre, apellido_paterno, apellido_materno. 
--Permite identificar clientes activos que han realizado compras permite analizar tendencias de
--consumo, segmentar clientes y desarrollar estrategias de fidelización.
SELECT rfc_cliente, nombre, apellido_paterno, apellido_materno
FROM clientes c
WHERE EXISTS ( 
	SELECT 1
	FROM facturas f
	WHERE f.rfc_cliente = c.rfc_cliente
);

--3. ¿Cuáles son los artículos que no han sido vendidos en ninguna factura? 
--Listar:codigo, nombre, precio.
--Identificar productos sin demanda es clave
--para optimizar el inventario, mejorar estrategias de ventas y reducir costos de almacenamiento.
SELECT codigo,nombre,precio
FROM articulos a
WHERE NOT EXISTS (
	SELECT 1
	FROM detalles_facturas df
	WHERE df.codigo_articulo = a.codigo
)
ORDER BY precio DESC;


-- 3. ANY --
/* 1. ¿Cuáles son los clientes que han realizado al menos una compra? Listar:
rfc_cliente, nombre, apellido_paterno, apellido_materno. Permite identificar
clientes activos permite segmentar campañas de fidelización y mejorar
estrategias de ventas.*/
SELECT rfc_cliente,nombre,apellido_paterno,apellido_materno
FROM clientes
WHERE rfc_cliente = ANY ( 
	SELECT rfc_cliente
	FROM facturas
);
	
/* 2. ¿Qué artículos han sido vendidos a un precio mayor que el registrado en la
tabla de artículos? 
Listar: codigo_articulo, precio_venta. 
Permite analizar precios de venta frente a los precios base permite detectar oportunidades de
mejora en la fijación de precios y márgenes de ganancia.
*/
-- en este ejercicio ANY es innecesario pues la tabla articulos solo tiene un registro de precio por artículo
SELECT codigo_articulo,precio_venta
FROM detalles_facturas df
WHERE df.precio_venta > ANY (
	SELECT precio
	FROM articulos a
	WHERE a.codigo = df.codigo_articulo
)
ORDER BY precio_venta DESC;

-- 4. ALL
/* 1. ¿Cuáles son los artículos que en todas sus ventas se vendieron a un precio
mayor que el registrado en el catálogo? 
Listar: codigo_articulo, nombre,precio_venta. 
Permite analizar la efectividad de las estrategias de precios y
detectar artículos con márgenes de ganancia constantes.
*/
SELECT df.codigo_articulo, a.nombre, df.precio_venta
FROM detalles_facturas df
LEFT JOIN articulos a ON df.codigo_articulo = a.codigo
WHERE a.precio < ALL (
	SELECT df_sub.precio_venta
	FROM detalles_facturas df_sub
	WHERE a.codigo = df_sub.codigo_articulo
);

/*2. ¿Qué clientes han realizado más compras que cualquier cliente con apellido
"Gómez"? Listar: rfc_cliente, nombre, apellido_paterno, apellido_materno
Propósito como científico de datos: Identifica clientes con alta recurrencia en
compras para estrategias de fidelización.
*/
SELECT rfc_cliente, nombre, apellido_paterno, apellido_materno
FROM clientes c
WHERE (
	SELECT COUNT(*) --cantidad compras hechas por el cliente
	FROM facturas f
	WHERE f.rfc_cliente = c.rfc_cliente 
) > ALL (
	SELECT COUNT(*)
	FROM facturas
	WHERE rfc_cliente IN (
		SELECT rfc_cliente --Cantidad de compra de los Gomez
		FROM clientes
		WHERE apellido_paterno = 'Gómez' OR apellido_materno = 'Gómez'
	)
	GROUP BY rfc_cliente
);


/* 3. Como cientifico de datos, proponer por lo menos dos subconsulta de este
tipo, explicando su propósito, qué se logra con como científico de datos y su
solución
*/
-- PENDIENTE