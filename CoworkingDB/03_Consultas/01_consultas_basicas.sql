-- ==========================================
-- CONSULTAS BÁSICAS: USUARIOS Y MEMBRESÍAS (1-10)
-- ==========================================

-- 1. Información básica de todos los usuarios
SELECT id, nombre, apellidos, fecha_nacimiento, email, telefono, empresa_id 
FROM usuarios;

-- 2. Usuarios con membresía actualmente activa
SELECT u.id, u.nombre, u.apellidos, m.fecha_vencimiento, m.estado
FROM usuarios u
INNER JOIN membresias m ON u.id = m.usuario_id
WHERE m.estado = 'Activa';

-- 3. Usuarios con membresía vencida
SELECT u.id, u.nombre, u.apellidos, m.fecha_vencimiento
FROM usuarios u
INNER JOIN membresias m ON u.id = m.usuario_id
WHERE m.estado = 'Vencida';

-- 4. Usuarios con membresía suspendida
SELECT u.id, u.nombre, u.apellidos, m.fecha_vencimiento
FROM usuarios u
INNER JOIN membresias m ON u.id = m.usuario_id
WHERE m.estado = 'Suspendida';

-- 5. Cantidad de usuarios por tipo de membresía
SELECT tm.nombre AS tipo_membresia, COUNT(m.id) AS cantidad_usuarios
FROM tipos_membresia tm
LEFT JOIN membresias m ON tm.id = m.tipo_membresia_id
GROUP BY tm.nombre;

-- 6. Top 10 usuarios con mayor antigüedad en el sistema
SELECT id, nombre, apellidos, fecha_registro
FROM usuarios
ORDER BY fecha_registro ASC
LIMIT 10;

-- 7. Usuarios asociados a una empresa específica (Ej: Tech Solutions SAS)
SELECT u.id, u.nombre, u.apellidos, e.nombre AS empresa
FROM usuarios u
INNER JOIN empresas e ON u.empresa_id = e.id
WHERE e.nombre = 'Tech Solutions SAS';

-- 8. Total de empleados asociados a cada empresa
SELECT e.nombre AS empresa, COUNT(u.id) AS total_empleados
FROM empresas e
LEFT JOIN usuarios u ON e.id = u.empresa_id
GROUP BY e.nombre;

-- 9. Usuarios que nunca han realizado una reserva
SELECT u.id, u.nombre, u.apellidos
FROM usuarios u
LEFT JOIN reservas r ON u.id = r.usuario_id
WHERE r.id IS NULL;

-- 10. Usuarios con más de 5 reservas activas en el mes actual
SELECT u.id, u.nombre, COUNT(r.id) AS total_reservas_mes
FROM usuarios u
INNER JOIN reservas r ON u.id = r.usuario_id
WHERE MONTH(r.fecha_inicio) = MONTH(CURDATE()) 
  AND YEAR(r.fecha_inicio) = YEAR(CURDATE())
  AND r.estado IN ('Pendiente', 'Confirmada')
GROUP BY u.id, u.nombre
HAVING COUNT(r.id) > 5;

-- ==========================================
-- CONSULTAS INTERMEDIAS: USUARIOS Y MEMBRESÍAS (11-20)
-- ==========================================

-- 11. Promedio de edad de todos los usuarios registrados
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE())), 2) AS promedio_edad
FROM usuarios;

-- 12. Usuarios que han cambiado de membresía más de 2 veces
SELECT u.id, u.nombre, COUNT(hm.id) AS cambios_membresia
FROM usuarios u
INNER JOIN historial_membresias hm ON u.id = hm.usuario_id
GROUP BY u.id, u.nombre
HAVING COUNT(hm.id) > 2;

-- 13. Usuarios con gasto total en reservas superior a $500
SELECT u.id, u.nombre, SUM(r.costo_total) AS total_gastado_reservas
FROM usuarios u
INNER JOIN reservas r ON u.id = r.usuario_id
GROUP BY u.id, u.nombre
HAVING SUM(r.costo_total) > 500;

-- 14. Usuarios que tienen membresía activa y han contratado servicios adicionales
SELECT DISTINCT u.id, u.nombre
FROM usuarios u
INNER JOIN membresias m ON u.id = m.usuario_id
INNER JOIN reservas r ON u.id = r.usuario_id
INNER JOIN reserva_servicios rs ON r.id = rs.reserva_id;

-- 15. Usuarios con membresía Premium y reservas actualmente activas
SELECT u.id, u.nombre, m.estado AS estado_membresia, r.estado AS estado_reserva
FROM usuarios u
INNER JOIN membresias m ON u.id = m.usuario_id
INNER JOIN tipos_membresia tm ON m.tipo_membresia_id = tm.id
INNER JOIN reservas r ON u.id = r.usuario_id
WHERE tm.nombre = 'Premium' 
  AND r.estado IN ('Pendiente', 'Confirmada');

-- 16. Usuarios con membresía Corporativa y nombre de su empresa
SELECT u.id, u.nombre, e.nombre AS empresa, tm.nombre AS tipo_membresia
FROM usuarios u
INNER JOIN empresas e ON u.empresa_id = e.id
INNER JOIN membresias m ON u.id = m.usuario_id
INNER JOIN tipos_membresia tm ON m.tipo_membresia_id = tm.id
WHERE tm.nombre = 'Corporativa';

-- 17. Usuarios con membresía Diaria renovada más de 10 veces
SELECT u.id, u.nombre, COUNT(m.id) AS total_renovaciones_diarias
FROM usuarios u
INNER JOIN membresias m ON u.id = m.usuario_id
INNER JOIN tipos_membresia tm ON m.tipo_membresia_id = tm.id
WHERE tm.nombre = 'Diaria'
GROUP BY u.id, u.nombre
HAVING COUNT(m.id) > 10;

-- 18. Usuarios cuya membresía activa vence en los próximos 7 días
SELECT u.id, u.nombre, m.fecha_vencimiento
FROM usuarios u
INNER JOIN membresias m ON u.id = m.usuario_id
WHERE m.fecha_vencimiento BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)
  AND m.estado = 'Activa';

-- 19. Usuarios que se registraron en el último mes
SELECT id, nombre, apellidos, fecha_registro
FROM usuarios
WHERE fecha_registro >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- 20. Usuarios registrados que nunca han asistido al coworking (0 accesos)
SELECT u.id, u.nombre, u.apellidos
FROM usuarios u
LEFT JOIN accesos a ON u.id = a.usuario_id
WHERE a.id IS NULL;