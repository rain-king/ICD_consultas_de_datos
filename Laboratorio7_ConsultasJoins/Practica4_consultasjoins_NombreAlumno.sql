-- Equipo Whisky
-- Alumnos: Gustavo Murillo Vega, Jose Alfredo Sanchez Grijalva, …
-- Instructor: Gerardo Gálvez Gámez
-- Lic. en Ing. en Ciencias de Datos
-- Tema: Laboratorio 7 Consultas Joins
-- Materia: Lenguajes de Consulta de Datos
-- Fecha: 30 - Marzo - 2025

-- 1. Listar las facturas registradas ordenadas por Apellido paterno del cliente.
-- 2. Listar las facturas registradas ordenadas por Apellido paterno del cliente, con estatus cancelado.
-- 3. Determinar el total general de facturas canceladas a un cliente específico, mostrado los campos nombre y
-- apellidos del cliente concatenados y el total, usar alias.
-- 4. Determinar el total general de facturas activas de un cliente específico, mostrado los campos nombre y
-- apellidos del cliente concatenados y el total, usar alias.
-- 5. Determinar cuántos clientes tienen facturas menores a 1000.
-- 6. Listar el total que se le ha facturado a cada cliente.
-------------------------------------------------------------------------------------

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

-- 8. Listar los datos de los clientes registrados incluyendo a los que no tienen facturas registradas, mostrar el campo
-- nombre y apellidos del cliente y el folio y total de facturación.
-- 9. Basado en el inciso anterior, pero mostrado los clientes que no tienen facturas registradas.
-- 10. Obtener una unión de clientes y facturas.
-- 11. Listar el nombre de los clientes que adquirido cierto producto.
-- 12. Listar que productos no se encuentran en al menos una factura.
