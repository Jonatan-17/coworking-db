-- ==========================================
-- CONSULTAS: ACCESOS, ASISTENCIAS Y REPORTES (61-80)
-- Archivo: 04_consultas_accesos_reportes.sql
-- ==========================================

-- 61. Listar todos los accesos permitidos del día actual
SELECT a.id, u.nombre, a.fecha_hora_entrada, a.fecha_hora_salida, a.metodo_acceso
FROM accesos a INNER JOIN usuarios u ON a.usuario_id = u.id
WHERE DATE(a.fecha_hora_entrada) = CURDATE() AND a.estado = 'Permitido';

-- 62. Mostrar usuarios con más de 20 asistencias en total
SELECT u.nombre, COUNT(a.id) AS total_asistencias
FROM usuarios u INNER JOIN accesos a ON u.id = a.usuario_id
WHERE a.estado = 'Permitido'
GROUP BY u.nombre HAVING COUNT(a.id) > 20;

-- 63. Listar accesos rechazados con motivo
SELECT a.id, u.nombre, a.fecha_hora_entrada, a.motivo_rechazo
FROM accesos a INNER JOIN usuarios u ON a.usuario_id = u.id
WHERE a.estado = 'Rechazado';

-- 64. Calcular el promedio de horas de permanencia por usuario
SELECT u.nombre, 
       ROUND(AVG(TIMESTAMPDIFF(HOUR, a.fecha_hora_entrada, a.fecha_hora_salida)), 2) AS promedio_horas
FROM usuarios u INNER JOIN accesos a ON u.id = a.usuario_id
WHERE a.estado = 'Permitido' AND a.fecha_hora_salida IS NOT NULL
GROUP BY u.nombre;

-- 65. Mostrar usuarios que asistieron más de 5 días en el último mes
SELECT u.nombre, COUNT(DISTINCT DATE(a.fecha_hora_entrada)) AS dias_asistidos
FROM usuarios u INNER JOIN accesos a ON u.id = a.usuario_id
WHERE a.estado = 'Permitido' AND a.fecha_hora_entrada >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY u.nombre HAVING dias_asistidos > 5;

-- 66. Accesos fuera de horario laboral (antes 8am o después 8pm)
SELECT a.id, u.nombre, a.fecha_hora_entrada, a.estado
FROM accesos a INNER JOIN usuarios u ON a.usuario_id = u.id
WHERE TIME(a.fecha_hora_entrada) < '08:00:00' OR TIME(a.fecha_hora_entrada) > '20:00:00';

-- 67. Porcentaje de accesos rechazados vs permitidos
SELECT 
    SUM(CASE WHEN estado = 'Permitido' THEN 1 ELSE 0 END) AS permitidos,
    SUM(CASE WHEN estado = 'Rechazado' THEN 1 ELSE 0 END) AS rechazados,
    ROUND((SUM(CASE WHEN estado = 'Rechazado' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS pct_rechazados
FROM accesos;

-- 68. Usuarios que solo asisten los fines de semana
SELECT u.nombre, COUNT(a.id) AS accesos_fin_semana
FROM usuarios u INNER JOIN accesos a ON u.id = a.usuario_id
WHERE DAYOFWEEK(a.fecha_hora_entrada) IN (1, 7) AND a.estado = 'Permitido'
GROUP BY u.nombre;

-- 69. Usuarios con más de 2 accesos en el mismo día
SELECT u.nombre, DATE(a.fecha_hora_entrada) AS fecha, COUNT(a.id) AS accesos_dia
FROM usuarios u INNER JOIN accesos a ON u.id = a.usuario_id
WHERE a.estado = 'Permitido'
GROUP BY u.nombre, DATE(a.fecha_hora_entrada)
HAVING COUNT(a.id) > 2;

-- 70. Método de acceso más utilizado (QR vs RFID)
SELECT metodo_acceso, COUNT(*) AS total_usos
FROM accesos WHERE estado = 'Permitido'
GROUP BY metodo_acceso;

-- 71. Usuarios con accesos pero sin reservas
SELECT DISTINCT u.nombre
FROM usuarios u INNER JOIN accesos a ON u.id = a.usuario_id
LEFT JOIN reservas r ON u.id = r.usuario_id
WHERE a.estado = 'Permitido' AND r.id IS NULL;

-- 72. Horario pico de asistencia (hora con más ingresos)
SELECT 
    HOUR(fecha_hora_entrada) AS hora,
    COUNT(*) AS total_ingresos
FROM accesos WHERE estado = 'Permitido'
GROUP BY HOUR(fecha_hora_entrada)
ORDER BY total_ingresos DESC LIMIT 1;

-- 73. Accesos sin registro de salida (sesiones abiertas)
SELECT a.id, u.nombre, a.fecha_hora_entrada
FROM accesos a INNER JOIN usuarios u ON a.usuario_id = u.id
WHERE a.fecha_hora_salida IS NULL AND a.estado = 'Permitido';

-- 74. Usuarios que nunca han sido rechazados
SELECT u.nombre
FROM usuarios u
WHERE u.id NOT IN (SELECT usuario_id FROM accesos WHERE estado = 'Rechazado');

-- 75. Promedio de asistencias diarias del último mes
SELECT ROUND(COUNT(*) / 30, 2) AS promedio_diario
FROM accesos 
WHERE estado = 'Permitido' AND fecha_hora_entrada >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- 76. Top 5 días con más asistencias
SELECT DATE(fecha_hora_entrada) AS fecha, COUNT(*) AS total_asistencias
FROM accesos WHERE estado = 'Permitido'
GROUP BY DATE(fecha_hora_entrada)
ORDER BY total_asistencias DESC LIMIT 5;

-- 77. Usuarios rechazados por QR inválido
SELECT u.nombre, COUNT(a.id) AS veces_rechazado
FROM usuarios u INNER JOIN accesos a ON u.id = a.usuario_id
WHERE a.estado = 'Rechazado' AND a.motivo_rechazo LIKE '%QR%'
GROUP BY u.nombre;

-- 78. Comparar asistencias de usuarios con membresía activa vs vencida
SELECT m.estado AS tipo_membresia, COUNT(a.id) AS total_asistencias
FROM membresias m INNER JOIN accesos a ON m.usuario_id = a.usuario_id
WHERE a.estado = 'Permitido'
GROUP BY m.estado;

-- 79. Usuarios que entran temprano (antes de 9am) consistently
SELECT u.nombre, COUNT(a.id) AS accesos_temprano
FROM usuarios u INNER JOIN accesos a ON u.id = a.usuario_id
WHERE TIME(a.fecha_hora_entrada) < '09:00:00' AND a.estado = 'Permitido'
GROUP BY u.nombre HAVING accesos_temprano > 5;

-- 80. Reporte consolidado: usuarios, reservas, pagos y accesos
SELECT 
    u.nombre,
    COUNT(DISTINCT r.id) AS total_reservas,
    COALESCE(SUM(DISTINCT p.monto), 0) AS total_pagado,
    COUNT(DISTINCT a.id) AS total_accesos
FROM usuarios u
LEFT JOIN reservas r ON u.id = r.usuario_id
LEFT JOIN pagos p ON u.id = p.usuario_id AND p.estado = 'Pagado'
LEFT JOIN accesos a ON u.id = a.usuario_id AND a.estado = 'Permitido'
GROUP BY u.nombre
ORDER BY total_accesos DESC;