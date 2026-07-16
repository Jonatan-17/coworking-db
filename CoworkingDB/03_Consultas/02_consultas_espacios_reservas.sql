-- ==========================================
-- CONSULTAS: ESPACIOS Y RESERVAS (21-40)
-- ==========================================

-- 21. Listar todos los espacios con capacidad y precio
SELECT id, nombre, tipo, capacidad_maxima, precio_hora FROM espacios;

-- 22. Reservas activas en el día actual
SELECT r.id, u.nombre, e.nombre AS espacio, r.fecha_inicio, r.fecha_fin, r.estado
FROM reservas r INNER JOIN usuarios u ON r.usuario_id = u.id
INNER JOIN espacios e ON r.espacio_id = e.id
WHERE DATE(r.fecha_inicio) = CURDATE() AND r.estado IN ('Pendiente', 'Confirmada');

-- 23. Reservas canceladas en el último mes
SELECT r.id, u.nombre, e.nombre AS espacio, r.fecha_inicio, r.estado
FROM reservas r INNER JOIN usuarios u ON r.usuario_id = u.id
INNER JOIN espacios e ON r.espacio_id = e.id
WHERE r.estado = 'Cancelada' AND r.fecha_inicio >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- 24. Reservas de salas de reuniones en horario pico (9 am – 11 am)
SELECT r.id, e.nombre AS sala, r.fecha_inicio, r.fecha_fin
FROM reservas r INNER JOIN espacios e ON r.espacio_id = e.id
WHERE e.tipo = 'Sala de reuniones' AND TIME(r.fecha_inicio) BETWEEN '09:00:00' AND '11:00:00';

-- 25. Cantidad de reservas por tipo de espacio
SELECT e.tipo, COUNT(r.id) AS total_reservas
FROM espacios e LEFT JOIN reservas r ON e.id = r.espacio_id GROUP BY e.tipo;

-- 26. Espacio más reservado del último mes
SELECT e.nombre, COUNT(r.id) AS veces_reservado
FROM espacios e INNER JOIN reservas r ON e.id = r.espacio_id
WHERE r.fecha_inicio >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY e.nombre ORDER BY veces_reservado DESC LIMIT 1;

-- 27. Usuarios que más han reservado oficinas privadas
SELECT u.nombre, COUNT(r.id) AS total_salas_privadas
FROM usuarios u INNER JOIN reservas r ON u.id = r.usuario_id
INNER JOIN espacios e ON r.espacio_id = e.id
WHERE e.tipo = 'Oficina privada' GROUP BY u.nombre ORDER BY total_salas_privadas DESC;

-- 28. Reservas que exceden la capacidad máxima (lógica: costo > precio esperado)
SELECT r.id, e.nombre, e.capacidad_maxima, r.costo_total
FROM reservas r INNER JOIN espacios e ON r.espacio_id = e.id
WHERE e.capacidad_maxima = 1 AND r.costo_total > (e.precio_hora * TIMESTAMPDIFF(HOUR, r.fecha_inicio, r.fecha_fin));

-- 29. Espacios sin reservas en la última semana
SELECT e.id, e.nombre, e.tipo
FROM espacios e LEFT JOIN reservas r ON e.id = r.espacio_id AND r.fecha_inicio >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
WHERE r.id IS NULL;

-- 30. Tasa de ocupación mensual promedio por espacio (%)
SELECT e.nombre, ROUND((SUM(TIMESTAMPDIFF(HOUR, r.fecha_inicio, r.fecha_fin)) / (DAY(LAST_DAY(CURDATE())) * 12)) * 100, 2) AS tasa_ocupacion_pct
FROM espacios e LEFT JOIN reservas r ON e.id = r.espacio_id AND MONTH(r.fecha_inicio) = MONTH(CURDATE()) AND r.estado IN ('Confirmada')
GROUP BY e.nombre;

-- 31. Reservas con duración mayor a 8 horas
SELECT r.id, u.nombre, e.nombre, TIMESTAMPDIFF(HOUR, r.fecha_inicio, r.fecha_fin) AS duracion_horas
FROM reservas r INNER JOIN usuarios u ON r.usuario_id = u.id INNER JOIN espacios e ON r.espacio_id = e.id
WHERE TIMESTAMPDIFF(HOUR, r.fecha_inicio, r.fecha_fin) > 8;

-- 32. Usuarios con más de 20 reservas en total
SELECT u.nombre, COUNT(r.id) AS total_reservas
FROM usuarios u INNER JOIN reservas r ON u.id = r.usuario_id GROUP BY u.nombre HAVING COUNT(r.id) > 20;

-- 33. Reservas realizadas por empresas con más de 10 empleados
SELECT e.nombre AS empresa, COUNT(r.id) AS reservas_empresa
FROM empresas e INNER JOIN usuarios u ON e.id = u.empresa_id INNER JOIN reservas r ON u.id = r.usuario_id
GROUP BY e.nombre HAVING COUNT(DISTINCT u.id) > 10;

-- 34. Detectar reservas solapadas en el mismo espacio y horario
SELECT r1.id AS reserva_1, r2.id AS reserva_2, esp.nombre AS espacio, r1.fecha_inicio, r1.fecha_fin, r2.fecha_inicio, r2.fecha_fin
FROM reservas r1 INNER JOIN reservas r2 ON r1.espacio_id = r2.espacio_id AND r1.id < r2.id
INNER JOIN espacios esp ON r1.espacio_id = esp.id
WHERE r1.fecha_inicio < r2.fecha_fin AND r2.fecha_inicio < r1.fecha_fin AND r1.estado IN ('Confirmada', 'Pendiente') AND r2.estado IN ('Confirmada', 'Pendiente');

-- 35. Reservas realizadas en fin de semana
SELECT r.id, u.nombre, e.nombre, r.fecha_inicio
FROM reservas r INNER JOIN usuarios u ON r.usuario_id = u.id INNER JOIN espacios e ON r.espacio_id = e.id
WHERE DAYOFWEEK(r.fecha_inicio) IN (1, 7);

-- 36. Porcentaje de ocupación por tipo de espacio
SELECT e.tipo, ROUND((COUNT(CASE WHEN r.estado IN ('Confirmada') THEN 1 END) / NULLIF(COUNT(r.id), 0)) * 100, 2) AS pct_ocupacion
FROM espacios e LEFT JOIN reservas r ON e.id = r.espacio_id GROUP BY e.tipo;

-- 37. Duración promedio de reservas por tipo de espacio
SELECT e.tipo, ROUND(AVG(TIMESTAMPDIFF(HOUR, r.fecha_inicio, r.fecha_fin)), 2) AS duracion_promedio_horas
FROM espacios e INNER JOIN reservas r ON e.id = r.espacio_id GROUP BY e.tipo;

-- 38. Reservas con servicios adicionales incluidos
SELECT r.id, u.nombre, e.nombre, GROUP_CONCAT(s.nombre SEPARATOR ', ') AS servicios
FROM reservas r INNER JOIN usuarios u ON r.usuario_id = u.id INNER JOIN espacios e ON r.espacio_id = e.id
INNER JOIN reserva_servicios rs ON r.id = rs.reserva_id INNER JOIN servicios_adicionales s ON rs.servicio_id = s.id
GROUP BY r.id, u.nombre, e.nombre;

-- 39. Usuarios que reservaron sala de eventos en los últimos 6 meses
SELECT DISTINCT u.nombre, e.nombre AS sala, r.fecha_inicio
FROM usuarios u INNER JOIN reservas r ON u.id = r.usuario_id INNER JOIN espacios e ON r.espacio_id = e.id
WHERE e.tipo = 'Sala de eventos' AND r.fecha_inicio >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 40. Reservas confirmadas pero nunca asistidas (No Show)
SELECT r.id, u.nombre, e.nombre, r.fecha_inicio, r.estado
FROM reservas r INNER JOIN usuarios u ON r.usuario_id = u.id INNER JOIN espacios e ON r.espacio_id = e.id
WHERE r.estado = 'No Show';