-- ==========================================
-- CONSULTAS COMPLEJAS: SUBCONSULTAS Y WINDOW FUNCTIONS (81-100)
-- Archivo: 03_Consultas/05_consultas_complejas.sql
-- ==========================================

-- 81. Top 10 usuarios con mayor gasto acumulado (Subconsulta con SUM)
SELECT u.nombre, 
       (SELECT SUM(monto) FROM pagos WHERE usuario_id = u.id AND estado = 'Pagado') AS total_gastado
FROM usuarios u
WHERE (SELECT SUM(monto) FROM pagos WHERE usuario_id = u.id AND estado = 'Pagado') IS NOT NULL
ORDER BY total_gastado DESC LIMIT 10;

-- 82. Espacios más ocupados (Reservas confirmadas + Asistencias)
SELECT e.nombre, 
       COUNT(DISTINCT r.id) AS reservas_confirmadas,
       COUNT(DISTINCT a.id) AS asistencias_reales,
       (COUNT(DISTINCT r.id) + COUNT(DISTINCT a.id)) AS score_ocupacion
FROM espacios e
LEFT JOIN reservas r ON e.id = r.espacio_id AND r.estado = 'Confirmada'
LEFT JOIN accesos a ON e.id = 1 
GROUP BY e.nombre ORDER BY score_ocupacion DESC;

-- 83. Promedio de ingresos por usuario (Subconsultas anidadas)
SELECT ROUND(AVG(total_por_usuario), 2) AS promedio_ingresos
FROM (SELECT usuario_id, SUM(monto) AS total_por_usuario FROM pagos WHERE estado = 'Pagado' GROUP BY usuario_id) AS sub;

-- 84. Usuarios con reservas activas y facturas pendientes
SELECT DISTINCT u.nombre
FROM usuarios u
INNER JOIN reservas r ON u.id = r.usuario_id AND r.estado IN ('Pendiente', 'Confirmada')
INNER JOIN facturas f ON u.id = f.usuario_id AND f.estado IN ('Pendiente', 'Parcial');

-- 85. Empresas que generan más del 20% de los ingresos totales
SELECT e.nombre AS empresa, 
       SUM(p.monto) AS ingresos_empresa,
       (SELECT SUM(monto) FROM pagos WHERE estado = 'Pagado') AS ingresos_totales,
       ROUND((SUM(p.monto) / (SELECT SUM(monto) FROM pagos WHERE estado = 'Pagado')) * 100, 2) AS porcentaje
FROM empresas e
INNER JOIN usuarios u ON e.id = u.empresa_id
INNER JOIN pagos p ON u.id = p.usuario_id AND p.estado = 'Pagado'
GROUP BY e.nombre HAVING porcentaje > 20;

-- 86. Top 5 usuarios que más usan servicios adicionales
SELECT u.nombre, COUNT(rs.id) AS veces_servicio
FROM usuarios u
INNER JOIN reservas r ON u.id = r.usuario_id
INNER JOIN reserva_servicios rs ON r.id = rs.reserva_id
GROUP BY u.nombre ORDER BY veces_servicio DESC LIMIT 5;

-- 87. Reservas que generaron facturas mayores al promedio
SELECT r.id, u.nombre, e.nombre AS espacio, f.monto_total
FROM reservas r
INNER JOIN usuarios u ON r.usuario_id = u.id
INNER JOIN espacios e ON r.espacio_id = e.id
INNER JOIN factura_detalle fd ON fd.concepto LIKE '%Reserva%'
INNER JOIN facturas f ON fd.factura_id = f.id
WHERE f.monto_total > (SELECT AVG(monto_total) FROM facturas);

-- 88. Porcentaje de ocupación global del coworking por mes
SELECT 
    DATE_FORMAT(r.fecha_inicio, '%Y-%m') AS mes,
    COUNT(DISTINCT r.id) AS total_reservas,
    ROUND((COUNT(DISTINCT r.id) / (SELECT COUNT(*) FROM espacios)) * 100, 2) AS pct_ocupacion
FROM reservas r WHERE r.estado = 'Confirmada'
GROUP BY DATE_FORMAT(r.fecha_inicio, '%Y-%m') ORDER BY mes;

-- 89. Usuarios con más horas de reserva que el promedio del sistema
SELECT u.nombre, 
       SUM(TIMESTAMPDIFF(HOUR, r.fecha_inicio, r.fecha_fin)) AS horas_totales
FROM usuarios u INNER JOIN reservas r ON u.id = r.usuario_id
GROUP BY u.nombre
HAVING horas_totales > (
    SELECT AVG(total_horas) FROM (
        SELECT usuario_id, SUM(TIMESTAMPDIFF(HOUR, fecha_inicio, fecha_fin)) AS total_horas
        FROM reservas GROUP BY usuario_id
    ) AS promedios
);

-- 90. Top 3 salas más usadas en el último trimestre
SELECT e.nombre, COUNT(r.id) AS veces_usada
FROM espacios e INNER JOIN reservas r ON e.id = r.espacio_id
WHERE r.fecha_inicio >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
  AND e.tipo IN ('Sala de reuniones', 'Sala de eventos')
GROUP BY e.nombre ORDER BY veces_usada DESC LIMIT 3;

-- 91. Ingresos promedio por tipo de membresía
SELECT tm.nombre AS tipo_membresia, ROUND(AVG(m.precio), 2) AS ingreso_promedio
FROM tipos_membresia tm INNER JOIN membresias m ON tm.id = m.tipo_membresia_id
GROUP BY tm.nombre;

-- 92. Usuarios que pagan solo con un método de pago
SELECT u.nombre, p.metodo_pago
FROM usuarios u INNER JOIN pagos p ON u.id = p.usuario_id
WHERE u.id IN (SELECT usuario_id FROM pagos GROUP BY usuario_id HAVING COUNT(DISTINCT metodo_pago) = 1);

-- 93. Reservas canceladas por usuarios que nunca asistieron
SELECT r.id, u.nombre, r.fecha_inicio, r.estado
FROM reservas r INNER JOIN usuarios u ON r.usuario_id = u.id
WHERE r.estado = 'Cancelada'
  AND u.id NOT IN (SELECT DISTINCT usuario_id FROM accesos WHERE estado = 'Permitido');

-- 94. Facturas con pagos parciales y cálculo de saldo real
SELECT f.id, u.nombre, f.monto_total, 
       COALESCE(SUM(fp.monto_aplicado), 0) AS total_pagado,
       (f.monto_total - COALESCE(SUM(fp.monto_aplicado), 0)) AS saldo_real
FROM facturas f INNER JOIN usuarios u ON f.usuario_id = u.id
LEFT JOIN factura_pagos fp ON f.id = fp.factura_id
GROUP BY f.id, u.nombre, f.monto_total
HAVING saldo_real > 0 AND saldo_real < f.monto_total;

-- 95. Facturación total de cada empresa ordenada
SELECT e.nombre AS empresa, SUM(f.monto_total) AS facturacion_total
FROM empresas e INNER JOIN usuarios u ON e.id = u.empresa_id
INNER JOIN facturas f ON u.id = f.usuario_id
GROUP BY e.nombre ORDER BY facturacion_total DESC;

-- 96. Usuarios que superan el promedio de reservas de su empresa
SELECT u.nombre, e.nombre AS empresa, COUNT(r.id) AS reservas_usuario
FROM usuarios u INNER JOIN empresas e ON u.empresa_id = e.id
INNER JOIN reservas r ON u.id = r.usuario_id
GROUP BY u.nombre, e.nombre
HAVING reservas_usuario > (
    SELECT AVG(reservas_por_usuario) FROM (
        SELECT u2.id, COUNT(r2.id) AS reservas_por_usuario
        FROM usuarios u2 INNER JOIN reservas r2 ON u2.id = r2.usuario_id
        WHERE u2.empresa_id = e.id GROUP BY u2.id
    ) AS promedios_empresa
);

-- 97. Top 3 empresas con más empleados activos
SELECT e.nombre, COUNT(u.id) AS empleados_activos
FROM empresas e INNER JOIN usuarios u ON e.id = u.empresa_id
INNER JOIN membresias m ON u.id = m.usuario_id AND m.estado = 'Activa'
GROUP BY e.nombre ORDER BY empleados_activos DESC LIMIT 3;

-- 98. Porcentaje de usuarios activos vs total registrados
SELECT 
    (SELECT COUNT(*) FROM usuarios u INNER JOIN membresias m ON u.id = m.usuario_id WHERE m.estado = 'Activa') AS usuarios_activos,
    (SELECT COUNT(*) FROM usuarios) AS total_usuarios,
    ROUND(((SELECT COUNT(*) FROM usuarios u INNER JOIN membresias m ON u.id = m.usuario_id WHERE m.estado = 'Activa') / 
    (SELECT COUNT(*) FROM usuarios)) * 100, 2) AS porcentaje_activos;

-- 99. Ingresos mensuales