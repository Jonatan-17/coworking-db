-- ==========================================
-- AJUSTE DE DATOS PARA CONSULTAS CRÍTICAS
-- Archivo: 02_DML_Datos/06_insert_ajuste_final.sql
-- ==========================================
SET @HOY = CURDATE();

-- 1. Agregar empleados a Tech Solutions (para Consulta #33: >10 empleados)
INSERT INTO usuarios (nombre, apellidos, fecha_nacimiento, email, telefono, empresa_id, fecha_registro)
SELECT 
    CONCAT('Extra', n), 'Empleado', 
    DATE_SUB(@HOY, INTERVAL (n*30) DAY),
    CONCAT('extra', n, '@techsolutions.com'),
    CONCAT('300', LPAD(n, 7, '0')),
    1, 
    DATE_SUB(@HOY, INTERVAL (n*5) DAY)
FROM (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
    UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
) AS nums;

-- 2. Agregar reservas masivas al usuario 21 (para Consulta #32: >20 reservas)
INSERT INTO reservas (usuario_id, espacio_id, fecha_inicio, fecha_fin, estado, costo_total)
SELECT 
    21, 
    FLOOR(1 + RAND() * 6), 
    DATE_SUB(@HOY, INTERVAL n DAY),
    DATE_SUB(@HOY, INTERVAL n DAY) + INTERVAL 2 HOUR,
    'Confirmada',
    25.00
FROM (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
    UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
    UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15
) AS nums;

-- Verificación rápida de datos
SELECT 'Usuarios Tech Solutions' as Tabla, COUNT(*) FROM usuarios WHERE empresa_id = 1
UNION ALL
SELECT 'Reservas Usuario 21', COUNT(*) FROM reservas WHERE usuario_id = 21;
