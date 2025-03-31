-- 2.
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