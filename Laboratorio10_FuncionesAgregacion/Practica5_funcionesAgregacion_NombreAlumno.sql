-- Equipo Whisky
-- Alumnos: Gustavo Murillo Vega, Jose Alfredo Sanchez Grijalva, Misael Enrique Urquidez Lopez, Isvi Gabriel Garcia Monzon
-- Instructor: Gerardo Gálvez Gámez
-- Lic. en Ing. en Ciencias de Datos
-- Tema: Practica 5 Funciones de Agragación
-- Materia: Lenguajes de Consulta de Datos
-- Fecha: 30 - Marzo - 2025

-- (1) --Poner en uso la BD CuentasAhorros
-- 1. Obtener el número de cuentas de ahorros registradas.
-- 2. Obtener el total de capital en ahorros.
-- 3. Obtener el mayor capital registrado.
-- 4. Obtener el promedio de capitales ahorrados.
-- 5. Obtener el menor capital registrado.
-- 6. Encontrar el nombre de la cuenta del mayor capital registrado.

-- (2) -- Poner en uso la BD CuentasAhorros
-- 1. Obtener el nombre de los clientes registrados en mayúsculas.
-- 2. Obtener el id_cliente y la unión del nombre y apellidos de todos los clientes.
-- 3. Obtener la unión del nombre y apellidos, separados por un espacio, de todos los clientes.
-- 4. Listar los id_cuenta, nombre, longitud de caracteres del nombre
-- 5. Listar los primeros 3 caracteres de cada nombre de cuenta con su id completo.

-- (3) --Usando la BD CuentaAhorros
-- 1. Listar el nombre de cada cuenta y los dias de registro:
-- 2. Obtener la antigüedad en días y años de registro de los clientes, incluir el nombre.
-- 3. Obtener el nombre del día, mes y año de registro, de los clientes registrados, incluir el nombre.
-- 4. Contar cuántos registros hay por cada cantidad de días registrados

-- (4) --Usando la BD world:
-- 1. Listar los nombres de países que comiencen con una ‘p’
-- 2. Listar los nombres de países que terminen con una ‘s’
-- 3. Listar los nombres de países con la segunda letra ‘e’
-- 4. Listar los nombres de países que contengan ‘an’
-- 5. Listar los nombres de países con código `Mex` sin distinguir mayúsculas o minúsculas
-- 6. Listar los nombres de países del continente Asia con una población entre 1000 a 200000

-- (5) Usando la BD CuentaAhorros
-- 1. Listar la cantidad de movimientos de cada cuenta que sean depositos.
-- 2. Listar el total de depositos y de retiros de cada cuenta.
SELECT d.id_cuenta, total_depositos, total_retiros
FROM (
	SELECT id_cuenta, COUNT(tipo) AS total_depositos FROM movimientos
	WHERE tipo = 'D'
	GROUP BY id_cuenta
) d 
INNER JOIN (
	SELECT id_cuenta, COUNT(tipo) AS total_retiros FROM movimientos
	WHERE tipo = 'R'
	GROUP BY id_cuenta
) r ON d.id_cuenta = r.id_cuenta;

-- 3. Mostrar solo las cuentas que tengan más de 3 movimientos.
-- 4. Calcular la suma de los movimientos de cada cuenta en el último mes.
-- 5. Mostrar el promedio de los depósitos (D) por cuenta, pero solo si han realizado más de 2 depósitos.
-- 6. Listar las cuentas donde la suma de retiros (R) sea mayor a 5000.