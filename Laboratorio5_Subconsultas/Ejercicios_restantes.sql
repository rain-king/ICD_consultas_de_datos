-- 4. Listar los estados junto con la cantidad de municipios que tienen:
--Listar: id_estado,nombre cantidad_municipios.
--Util para estudios geograficos y administratios sobre la cantidad de municipios por estado
SELECT id_estado,nombre, (
  SELECT COUNT(*)
  FROM municipio m
  WHERE m.id_estado = e.id_estado) AS cantidad_municipios
FROM estados e
ORDER BY cantidad_municipio DESC;

-- 5.Listar los artículos junto con la cantidad total de veces que han sido vendidos en facturas
--Listar: codigo, nombre, cantidad_vendida.
--Ayuda en la estión de inventario y deteccion de productos más vvendidos.
SELECT codigo,nombre,(
  SELECT COALESCE(SUM(df.cantidad), 0) 
  FROM detalles_facturas df
  WHERE df.codigo_articulo = a.codigo) AS cantidad_vendida
FROM articulos a
ORDER BY cantidad_vendida DESC;

--6. Como cientifico de datos, proponer po lo menos dos subconsultas de este tipo, explicando su propósito,
--qué se logra con como cientifico de datos y su solución.

-----------------------------------
-- 4. PREDICADOS EN SUBCONSULTAS --
-----------------------------------
--IN Y NOT IN
--1. ¿Cualés son los productos que no se han vendido? Listar codigo y nombre.
--Permite conocer qué producto no tienen demanda para definir estrategias de ventas.
SELECT codigo, nombre
FROM articulos
WHERE codigo NOT IN(
	SELECT codigo_articulo
	FROM detalles_facturas)
ORDER BY codigo ASC;
--2. ¿Cuáles son los clientes que han realizado al menos una compra? 
--Listar:rfc_cliente, nombre, apellido_paterno, apellido_materno. 
--Permite identificar clientes activos que han realizado compras permite analizar tendencias de
--consumo, segmentar clientes y desarrollar estrategias de fidelización.
SELECT rfc_cliente,nombre,apellido_paterno,apellido_materno
FROM clientes
WHERE rfc_cliente IN( 
  SELECT rfc_cliente
  FROM facturas);
--3. ¿Cuáles son los artículos que no han sido vendidos en ninguna factura? 
--Listar:codigo, nombre, precio.
--Identificar productos sin demanda es clave
--para optimizar el inventario, mejorar estrategias de ventas y reducir costos de almacenamiento.
SELECT codigo,nombre,precio
FROM articulos
WHERE codigo NOT IN(
  SELECT codigo_articulo
  FROM detalles_facturas)
ORDER BY precio DESC;

--4. Listar estados que no tienen localidades registradas. 
--Listar: id_estado,nombre. 
--Permite identificar estados sin localidades registradas es importante
--para detectar inconsistencias en los datos, mejorar la calidad de la información
--y garantizar la cobertura completa en análisis geoespaciales.
SELECT id_estado,nombre
FROM estados
WHERE id_estado NOT IN(
  SELECT id_estado FROM localidades);
  
--5. Como cientifico de datos, proponer por lo menos dos subconsulta de este
--tipo, explicando su propósito, qué se logra con como científico de datos y su
--solución.

--EXISTS
--1. ¿Cuáles son los productos que no se an vendido? Listar codigo y nombre.
--Permite conocer qué producto no tienen demanda para definir estrategias de
--ventas.
SELECT codigo, nombre
FROM articulos a
WHERE NOT EXISTS (
  SELECT 1
  FROM detalles_facturas df
  WHERE df.codigo_articulo = a.codigo)
ORDER BY codigo ASC;

--2. ¿Cuáles son los clientes que han realizado al menos una compra? 
--Listar:rfc_cliente, nombre, apellido_paterno, apellido_materno. 
--Permite identificar clientes activos que han realizado compras permite analizar tendencias de
--consumo, segmentar clientes y desarrollar estrategias de fidelización.
SELECT rfc_cliente,nombre,apellido_paterno,apellido_materno
FROM clientes c
WHERE EXISTS ( 
  SELECT 1 
  FROM facturas f
  WHERE f.rfc_cliente = c.rfc_cliente);

--3. ¿Cuáles son los artículos que no han sido vendidos en ninguna factura? 
--Listar:codigo, nombre, precio.
--Identificar productos sin demanda es clave
--para optimizar el inventario, mejorar estrategias de ventas y reducir costos de almacenamiento.
SELECT codigo,nombre,precio
FROM articulos a
WHERE NOT EXISTS(
  SELECT 1
  FROM detalles_facturas df
  WHERE df.codigo_articulo = a.codigo)
ORDER BY precio DESC;

/* 1. ¿Cuáles son los clientes que han realizado al menos una compra? Listar:
rfc_cliente, nombre, apellido_paterno, apellido_materno. Permite identificar
clientes activos permite segmentar campañas de fidelización y mejorar
estrategias de ventas.*/
SELECT rfc_cliente,nombre,apellido_paterno,apellido_materno
FROM clientes
WHERE rfc_cliente= ANY( 
  SELECT rfc_cliente
  FROM facturas);
  
/* 2. ¿Qué artículos han sido vendidos a un precio mayor que el registrado en la
tabla de artículos? 
Listar: codigo_articulo, precio_venta. 
Permite analizar precios de venta frente a los precios base permite detectar oportunidades de
mejora en la fijación de precios y márgenes de ganancia.
*/
SELECT codigo_articulo,precio_venta
FROM detalles_facturas df
WHERE df.precio_venta > ANY (
  SELECT precio
  FROM articulos a
  WHERE a.codigo = df.codigo_articulo)
ORDER BY precio_venta DESC;

/* 1. ¿Cuáles son los artículos que en todas sus ventas se vendieron a un precio
mayor que el registrado en el catálogo? 
Listar: codigo_articulo, nombre,precio_venta. 
Permite analizar la efectividad de las estrategias de precios y
detectar artículos con márgenes de ganancia constantes.
*/
SELECT a.codigo AS codigo_articulo, a.nombre, a.precio AS precio_venta
FROM articulos a
WHERE a.precio < ALL (
  SELECT df.precio_venta
  FROM detalles_facturas df
  WHERE df.codigo_articulo = a.codigo
)
ORDER BY precio_venta DESC;

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
  WHERE rfc_cliente IN(
    SELECT rfc_cliente--Cantidad de compra de los Gomez
    FROM clientes
    WHERE apellido_paterno = 'Gómez'
  )
  GROUP BY rfc_cliente
)
AND apellido_materno != 'Gomez'

/* 3. Como cientifico de datos, proponer por lo menos dos subconsulta de este
tipo, explicando su propósito, qué se logra con como científico de datos y su
solución
*/
