-- ==========================================
-- DATOS EXTRA PARA CONSULTAS AVANZADAS
-- ==========================================
SET @HOY = CURDATE();

-- Historial de cambios de membresía (usuarios con múltiples renovaciones)
INSERT INTO historial_membresias (usuario_id, membresia_anterior_id, membresia_nueva_id, fecha_cambio) VALUES
(1, NULL, 1, DATE_SUB(@HOY, INTERVAL 60 DAY)),
(1, 1, 2, DATE_SUB(@HOY, INTERVAL 30 DAY)),
(1, 2, 4, DATE_SUB(@HOY, INTERVAL 10 DAY)),
(2, NULL, 1, DATE_SUB(@HOY, INTERVAL 50 DAY)),
(2, 1, 3, DATE_SUB(@HOY, INTERVAL 20 DAY)),
(2, 3, 2, DATE_SUB(@HOY, INTERVAL 5 DAY)),     
(3, NULL, 2, DATE_SUB(@HOY, INTERVAL 40 DAY)),
(3, 2, 1, DATE_SUB(@HOY, INTERVAL 15 DAY));    

-- Usuario con +10 renovaciones diarias consecutivas
INSERT INTO membresias (usuario_id, tipo_membresia_id, fecha_inicio, fecha_vencimiento, estado)
SELECT 
    4 AS usuario_id, 1 AS tipo_membresia_id,
    DATE_SUB(@HOY, INTERVAL n DAY) AS fecha_inicio,
    DATE_SUB(@HOY, INTERVAL (n-1) DAY) AS fecha_vencimiento,
    'Vencida' AS estado
FROM (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
    UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
    UNION ALL SELECT 11 UNION ALL SELECT 12
) AS numeros;

-- Usuario con alto gasto en reservas (> $500)
INSERT INTO reservas (usuario_id, espacio_id, fecha_inicio, fecha_fin, estado, costo_total) VALUES
(5, 6, DATE_SUB(@HOY, INTERVAL 20 DAY), DATE_SUB(@HOY, INTERVAL 20 DAY) + INTERVAL 5 HOUR, 'Confirmada', 500.00),
(5, 6, DATE_SUB(@HOY, INTERVAL 10 DAY), DATE_SUB(@HOY, INTERVAL 10 DAY) + INTERVAL 4 HOUR, 'Confirmada', 400.00);

-- Usuario con +5 reservas este mes
INSERT INTO reservas (usuario_id, espacio_id, fecha_inicio, fecha_fin, estado, costo_total) VALUES
(21, 4, CONCAT(@HOY, ' 08:00:00'), CONCAT(@HOY, ' 09:00:00'), 'Confirmada', 25.00),
(21, 4, CONCAT(@HOY, ' 10:00:00'), CONCAT(@HOY, ' 11:00:00'), 'Confirmada', 25.00),
(21, 5, CONCAT(@HOY, ' 13:00:00'), CONCAT(@HOY, ' 14:00:00'), 'Pendiente', 20.00),
(21, 4, DATE_ADD(@HOY, INTERVAL 1 DAY), DATE_ADD(@HOY, INTERVAL 1 DAY) + INTERVAL 1 HOUR, 'Confirmada', 25.00),
(21, 5, DATE_ADD(@HOY, INTERVAL 2 DAY), DATE_ADD(@HOY, INTERVAL 2 DAY) + INTERVAL 1 HOUR, 'Confirmada', 20.00),
(21, 4, DATE_ADD(@HOY, INTERVAL 3 DAY), DATE_ADD(@HOY, INTERVAL 3 DAY) + INTERVAL 1 HOUR, 'Pendiente', 25.00);