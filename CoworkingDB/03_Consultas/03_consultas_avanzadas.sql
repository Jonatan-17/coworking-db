-- ==========================================
-- CONSULTAS AVANZADAS: PAGOS Y FACTURACIÓN (41-60)
-- Archivo: 03_Consultas/03_consultas_avanzadas.sql
-- ==========================================

-- 41. Pagos realizados con tarjeta
SELECT p.id, u.nombre, p.monto, p.fecha_pago, p.estado
FROM pagos p INNER JOIN usuarios u ON p.usuario_id = u.id
WHERE p.metodo_pago = 'Tarjeta';

-- 42. Pagos pendientes de usuarios
SELECT p.id, u.nombre, p.monto, p.fecha_pago
FROM pagos p INNER JOIN usuarios u ON p.usuario_id = u.id
WHERE p.estado = 'Pendiente';

-- 43. Pagos cancelados en los últimos 3 meses
SELECT p.id, u.nombre, p.monto, p.fecha_pago
FROM pagos p INNER JOIN usuarios u ON p.usuario_id = u.id
WHERE p.estado = 'Cancelado' AND p.fecha_pago >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH);

-- 44. Facturas generadas por membresías
SELECT f.id, u.nombre, fd.concepto, f.monto_total, f.estado
FROM facturas f INNER JOIN usuarios u ON f.usuario_id = u.id
INNER JOIN factura_detalle fd ON f.id = fd.factura_id
WHERE fd.concepto LIKE '%Membresía%';

-- 45. Facturas generadas por reservas
SELECT f.id, u.nombre, fd.concepto, f.monto_total, f.estado
FROM facturas f INNER JOIN usuarios u ON f.usuario_id = u.id
INNER JOIN factura_detalle fd ON f.id = fd.factura_id
WHERE fd.concepto LIKE '%Reserva%';

-- 46. Total de ingresos por membresías en el último mes
SELECT SUM(fd.monto) AS total_ingresos_membresias
FROM factura_detalle fd INNER JOIN facturas f ON fd.factura_id = f.id
WHERE fd.concepto LIKE '%Membresía%' AND f.fecha_emision >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AND f.estado = 'Pagada';

-- 47. Total de ingresos por reservas en el último mes
SELECT SUM(fd.monto) AS total_ingresos_reservas
FROM factura_detalle fd INNER JOIN facturas f ON fd.factura_id = f.id
WHERE fd.concepto LIKE '%Reserva%' AND f.fecha_emision >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AND f.estado = 'Pagada';

-- 48. Total de ingresos por servicios adicionales
SELECT SUM(rs.subtotal) AS total_servicios_adicionales
FROM reserva_servicios rs INNER JOIN reservas r ON rs.reserva_id = r.id
WHERE r.estado IN ('Confirmada', 'No Show');

-- 49. Usuarios que nunca han pagado con PayPal
SELECT u.id, u.nombre
FROM usuarios u
WHERE u.id NOT IN (SELECT DISTINCT usuario_id FROM pagos WHERE metodo_pago = 'PayPal');

-- 50. Promedio de gasto por usuario
SELECT ROUND(AVG(total_gastado), 2) AS promedio_gasto_usuario
FROM (SELECT usuario_id, SUM(monto) AS total_gastado FROM pagos WHERE estado = 'Pagado' GROUP BY usuario_id) AS gastos;

-- 51. Top 5 usuarios que más han pagado
SELECT u.nombre, SUM(p.monto) AS total_pagado
FROM usuarios u INNER JOIN pagos p ON u.id = p.usuario_id
WHERE p.estado = 'Pagado' GROUP BY u.nombre ORDER BY total_pagado DESC LIMIT 5;

-- 52. Facturas con monto mayor a $1000
SELECT f.id, u.nombre, f.monto_total, f.estado
FROM facturas f INNER JOIN usuarios u ON f.usuario_id = u.id
WHERE f.monto_total > 1000;

-- 53. Pagos realizados después del vencimiento de factura
SELECT p.id AS pago_id, u.nombre, p.fecha_pago AS fecha_pago_real, 
       f.fecha_vencimiento, DATEDIFF(p.fecha_pago, f.fecha_vencimiento) AS dias_atraso
FROM pagos p INNER JOIN usuarios u ON p.usuario_id = u.id
INNER JOIN factura_pagos fp ON p.id = fp.pago_id
INNER JOIN facturas f ON fp.factura_id = f.id
WHERE p.fecha_pago > f.fecha_vencimiento;

-- 54. Total recaudado en el año actual
SELECT SUM(monto) AS total_recaudado_anio
FROM pagos WHERE YEAR(fecha_pago) = YEAR(CURDATE()) AND estado = 'Pagado';

-- 55. Facturas anuladas y su motivo
SELECT f.id, u.nombre, f.monto_total, f.motivo_anulacion, f.fecha_emision
FROM facturas f INNER JOIN usuarios u ON f.usuario_id = u.id
WHERE f.estado = 'Anulada';

-- 56. Usuarios con facturas pendientes mayores a $200
SELECT u.nombre, f.monto_total AS saldo_pendiente
FROM usuarios u INNER JOIN facturas f ON u.id = f.usuario_id
WHERE f.saldo_pendiente > 200 AND f.estado IN ('Pendiente', 'Parcial');

-- 57. Usuarios que han pagado más de una vez el mismo servicio
SELECT u.nombre, fd.concepto, COUNT(fd.id) AS veces_pagado
FROM usuarios u INNER JOIN facturas f ON u.id = f.usuario_id
INNER JOIN factura_detalle fd ON f.id = fd.factura_id
GROUP BY u.nombre, fd.concepto HAVING COUNT(fd.id) > 1;

-- 58. Ingresos por cada método de pago
SELECT p.metodo_pago, SUM(p.monto) AS total_ingresos
FROM pagos p WHERE p.estado = 'Pagado' GROUP BY p.metodo_pago;

-- 59. Facturación acumulada por empresa
SELECT e.nombre AS empresa, SUM(f.monto_total) AS facturacion_total
FROM empresas e INNER JOIN usuarios u ON e.id = u.empresa_id
INNER JOIN facturas f ON u.id = f.usuario_id
GROUP BY e.nombre ORDER BY facturacion_total DESC;

-- 60. Ingresos netos por mes del último año
SELECT DATE_FORMAT(fecha_pago, '%Y-%m') AS mes, SUM(monto) AS ingresos_netos
FROM pagos WHERE estado = 'Pagado' AND fecha_pago >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY DATE_FORMAT(fecha_pago, '%Y-%m') ORDER BY mes;