-- Equipo Whisky
-- Alumnos: Gustavo Murillo Vega, Jose Alfredo Sanchez Grijalva, Misael Enrique Urquidez Lopez, Isvi Gabriel Garcia Monzon
-- Instructor: Gerardo Gálvez Gámez
-- Lic. en Ing. en Ciencias de Datos
-- Tema: Practica 5 Funciones de Agragación
-- Materia: Lenguajes de Consulta de Datos
-- Fecha: 31 - Marzo - 2025

-- (1) --Poner en uso la BD CuentasAhorros

-- 1. Obtener el número de cuentas de ahorros registradas.
SELECT COUNT(*) AS cuentas_registradas
FROM cuentas;
-- 2. Obtener el total de capital en ahorros.
SELECT SUM(capital) AS total_capital
FROM cuentas;
-- 3. Obtener el mayor capital registrado.
SELECT MAX(capital) AS mayor_capital
FROM cuentas;
-- 4. Obtener el promedio de capitales ahorrados.
SELECT AVG(capital) AS prom_capitales_ahorrados
FROM cuentas;
-- 5. Obtener el menor capital registrado.
SELECT MIN(capital) AS menor_capital
FROM cuentas;
-- 6. Encontrar el nombre de la cuenta del mayor capital registrado.
SELECT nombre 
FROM cuentas 
WHERE capital = (SELECT MAX(capital) FROM cuentas);

-- (2) -- Poner en uso la BD CuentasAhorros

-- 1. Obtener el nombre de los clientes registrados en mayúsculas.
SELECT UPPER(nombre) AS nombres_mayusculas
FROM cuentas;
-- 2. Obtener el id_cliente y la unión del nombre y apellidos de todos los clientes.
SELECT id_cuenta, CONCAT(nombre, apellido_paterno, apellido_materno) AS nombre_completo 
FROM cuentas;
-- 3. Obtener la unión del nombre y apellidos, separados por un espacio, de todos los clientes.
SELECT id_cuenta, CONCAT(nombre, ' ', apellido_paterno, ' ', apellido_materno) AS nombre_completo 
FROM cuentas;
-- 4. Listar los id_cuenta, nombre, longitud de caracteres del nombre
SELECT id_cuenta,nombre,LENGTH(nombre) AS longitud_nombre
FROM cuentas;
-- 5. Listar los primeros 3 caracteres de cada nombre de cuenta con su id completo.
SELECT id_cuenta, SUBSTRING(nombre FROM 1 FOR 3) AS tres_caracteres
FROM cuentas;

-- (3) --Usando la BD CuentaAhorros

-- 1. Listar el nombre de cada cuenta y los dias de registro:
SELECT nombre, CURRENT_DATE - fecha_registro AS dias_registro
FROM cuentas;
-- 2. Obtener la antigüedad en días y años de registro de los clientes, incluir el nombre.
SELECT nombre, 
       EXTRACT(DAY FROM AGE(CURRENT_DATE, fecha_registro)) AS antiguedad_años,
       EXTRACT(YEAR FROM AGE(CURRENT_DATE, fecha_registro)) AS antiguedad_dias
FROM cuentas;
-- 3. Obtener el nombre del día, mes y año de registro, de los clientes registrados, incluir el nombre.
SELECT nombre, 
       TO_CHAR(fecha_registro, 'Day') AS nombre_dia, 
       TO_CHAR(fecha_registro, 'Month') AS nombre_mes, 
       EXTRACT(YEAR FROM fecha_registro) AS año_registro
FROM cuentas;
-- 4. Contar cuántos registros hay por cada cantidad de días registrados
SELECT CURRENT_DATE - fecha_registro AS dias_registrados, 
       COUNT(*) AS cantidad_registros
FROM cuentas
GROUP BY dias_registrados;

-- (4) --Usando la BD world:

-- 1. Listar los nombres de países que comiencen con una ‘p’
SELECT * FROM paises 
WHERE nombre LIKE 'p%';
-- 2. Listar los nombres de países que terminen con una ‘s’
SELECT * FROM paises 
WHERE nombre LIKE '%s';
-- 3. Listar los nombres de países con la segunda letra ‘e’
SELECT * FROM paises 
WHERE nombre LIKE '_e%';
-- 4. Listar los nombres de países que contengan ‘an’
SELECT * FROM paises 
WHERE nombre LIKE '%an%';
-- 5. Listar los nombres de países con código `Mex` sin distinguir mayúsculas o minúsculas
SELECT * FROM clientes 
WHERE nombre ILIKE 'Mex%';
-- 6. Listar los nombres de países del continente Asia con una población entre 1000 a 200000
SELECT nombre 
FROM paises 
WHERE continente = 'Asia' 
	AND poblacion BETWEEN 1000 AND 200000;
