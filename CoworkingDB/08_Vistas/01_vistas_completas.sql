-- ==========================================
-- FASE 8: VISTAS PREDEFINIDAS (20)
-- Descripción: Consultas predefinidas para reportes y dashboards.
-- Ejecutar COMPLETO con Alt + X o Ctrl + Enter
-- ==========================================

USE coworking_db;

-- 1. vw_usuarios_membresia_activa: Lista usuarios con membresía actualmente vigente.
CREATE OR REPLACE VIEW vw_usuarios_membresia_activa AS
SELECT u.id, u.nombre, u.email, m.fecha_vencimiento, m.estado
FROM usuarios u INNER JOIN membresias m ON u.id = m.usuario_id WHERE m.estado = 'Activa';

-- 2. vw_usuarios_membresia_inactiva: Lista usuarios con membresía vencida o suspendida.
CREATE OR REPLACE VIEW vw_usuarios_membresia_inactiva AS
SELECT u.id, u.nombre, u.email, m.fecha_vencimiento, m.estado
FROM usuarios u INNER JOIN membresias m ON u.id = m.usuario_id WHERE m.estado IN ('Vencida', 'Suspendida');

-- 3. vw_historial_membresias: Muestra el log de cambios de tipo de membresía por usuario.
CREATE OR REPLACE VIEW vw_historial_membresias AS
SELECT u.nombre AS usuario, hm.fecha_cambio, tm1.nombre AS tipo_anterior, tm2.nombre AS tipo_nuevo
FROM historial_membresias hm INNER JOIN usuarios u ON hm.usuario_id = u.id
LEFT JOIN tipos_membresia tm1 ON hm.membresia_anterior_id = tm1.id
LEFT JOIN tipos_membresia tm2 ON hm.membresia_nueva_id = tm2.id;

-- 4. vw_usuarios_por_empresa: Agrupa y cuenta usuarios asociados a cada empresa.
CREATE OR REPLACE VIEW vw_usuarios_por_empresa AS
SELECT e.nombre AS empresa, COUNT(u.id) AS cantidad_empleados
FROM empresas e LEFT JOIN usuarios u ON e.id = u.empresa_id GROUP BY e.id, e.nombre;

-- 5. vw_proximas_reservas: Lista las próximas reservas confirmadas ordenadas por fecha.
CREATE OR REPLACE VIEW vw_proximas_reservas AS
SELECT r.id, u.nombre AS usuario, e.nombre AS espacio, r.fecha_inicio, r.fecha_fin
FROM reservas r INNER JOIN usuarios u ON r.usuario_id = u.id INNER JOIN espacios e ON r.espacio_id = e.id
WHERE r.estado = 'Confirmada' AND r.fecha_inicio >= NOW() ORDER BY r.fecha_inicio;

-- 6. vw_ocupacion_espacios: Resumen de cantidad de reservas confirmadas por espacio.
CREATE OR REPLACE VIEW vw_ocupacion_espacios AS
SELECT e.nombre, e.tipo, COUNT(r.id) AS total_reservas
FROM espacios e LEFT JOIN reservas r ON e.id = r.espacio_id AND r.estado = 'Confirmada' GROUP BY e.id, e.nombre, e.tipo;

-- 7. vw_reservas_con_servicios: Detalla las reservas que incluyen servicios adicionales.
CREATE OR REPLACE VIEW vw_reservas_con_servicios AS
SELECT r.id AS reserva_id, u.nombre, e.nombre AS espacio, rs.subtotal AS costo_servicio
FROM reservas r INNER JOIN usuarios u ON r.usuario_id = u.id INNER JOIN espacios e ON r.espacio_id = e.id
INNER JOIN reserva_servicios rs ON r.id = rs.reserva_id;

-- 8. vw_espacios_disponibles_hoy: Muestra espacios que no tienen reservas confirmadas hoy.
CREATE OR REPLACE VIEW vw_espacios_disponibles_hoy AS
SELECT e.id, e.nombre, e.tipo FROM espacios e
WHERE e.id NOT IN (SELECT espacio_id FROM reservas WHERE DATE(fecha_inicio) = CURDATE() AND estado = 'Confirmada');

-- 9. vw_facturas_pendientes: Lista facturas que aún no han sido pagadas.
CREATE OR REPLACE VIEW vw_facturas_pendientes AS
SELECT f.id, u.nombre, f.monto_total, f.saldo_pendiente, f.fecha_vencimiento
FROM facturas f INNER JOIN usuarios u ON f.usuario_id = u.id WHERE f.estado = 'Pendiente';

-- 10. vw_ingresos_por_metodo: Total recaudado agrupado por método de pago.
CREATE OR REPLACE VIEW vw_ingresos_por_metodo AS
SELECT metodo_pago, SUM(monto) AS total_recaudado, COUNT(*) AS cantidad_transacciones
FROM pagos WHERE estado = 'Pagado' GROUP BY metodo_pago;

-- 11. vw_detalle_facturas: Desglose de conceptos por cada factura emitida.
CREATE OR REPLACE VIEW vw_detalle_facturas AS
SELECT f.id AS factura_id, u.nombre, fd.concepto, fd.monto, f.fecha_emision
FROM facturas f INNER JOIN usuarios u ON f.usuario_id = u.id INNER JOIN factura_detalle fd ON f.id = fd.factura_id;

-- 12. vw_pagos_aplicados: Relación de pagos aplicados a facturas específicas.
CREATE OR REPLACE VIEW vw_pagos_aplicados AS
SELECT f.id AS factura_id, p.metodo_pago, fp.monto_aplicado, fp.fecha_aplicacion
FROM factura_pagos fp INNER JOIN facturas f ON fp.factura_id = f.id INNER JOIN pagos p ON fp.pago_id = p.id;

-- 13. vw_accesos_hoy: Registro de entradas y salidas del día actual.
CREATE OR REPLACE VIEW vw_accesos_hoy AS
SELECT u.nombre, a.fecha_hora_entrada, a.fecha_hora_salida, a.estado
FROM accesos a INNER JOIN usuarios u ON a.usuario_id = u.id WHERE DATE(a.fecha_hora_entrada) = CURDATE();

-- 14. vw_accesos_rechazados: Historial de accesos denegados con su motivo.
CREATE OR REPLACE VIEW vw_accesos_rechazados AS
SELECT u.nombre, a.fecha_hora_entrada, a.motivo_rechazo
FROM accesos a INNER JOIN usuarios u ON a.usuario_id = u.id WHERE a.estado = 'Rechazado';

-- 15. vw_sesiones_abiertas: Usuarios que ingresaron pero no han registrado salida.
CREATE OR REPLACE VIEW vw_sesiones_abiertas AS
SELECT u.nombre, a.fecha_hora_entrada FROM accesos a
INNER JOIN usuarios u ON a.usuario_id = u.id WHERE a.fecha_hora_salida IS NULL AND a.estado = 'Permitido';

-- 16. vw_accesos_fin_semana: Filtra los accesos permitidos realizados en sábado o domingo.
CREATE OR REPLACE VIEW vw_accesos_fin_semana AS
SELECT u.nombre, a.fecha_hora_entrada FROM accesos a
INNER JOIN usuarios u ON a.usuario_id = u.id WHERE DAYOFWEEK(a.fecha_hora_entrada) IN (1, 7);

-- 17. vw_top_usuarios_gasto: Top 5 usuarios que más dinero han pagado en el sistema.
CREATE OR REPLACE VIEW vw_top_usuarios_gasto AS
SELECT u.nombre, SUM(p.monto) AS total_gastado FROM usuarios u
INNER JOIN pagos p ON u.id = p.usuario_id AND p.estado = 'Pagado' GROUP BY u.id, u.nombre ORDER BY total_gastado DESC LIMIT 5;

-- 18. vw_ingresos_mensuales: Resumen de ingresos netos agrupados por mes.
CREATE OR REPLACE VIEW vw_ingresos_mensuales AS
SELECT DATE_FORMAT(fecha_pago, '%Y-%m') AS mes, SUM(monto) AS total
FROM pagos WHERE estado = 'Pagado' GROUP BY DATE_FORMAT(fecha_pago, '%Y-%m') ORDER BY mes DESC;

-- 19. vw_saldos_pendientes: Deuda total acumulada por usuario con saldo mayor a cero.
CREATE OR REPLACE VIEW vw_saldos_pendientes AS
SELECT u.nombre, SUM(f.saldo_pendiente) AS deuda_total FROM usuarios u
INNER JOIN facturas f ON u.id = f.usuario_id WHERE f.saldo_pendiente > 0 GROUP BY u.id, u.nombre;

-- 20. vw_dashboard_usuario: Vista maestra con resumen de membresía, pagos y deuda por usuario.
CREATE OR REPLACE VIEW vw_dashboard_usuario AS
SELECT u.id, u.nombre, m.estado AS membresia, m.fecha_vencimiento,
    (SELECT COALESCE(SUM(monto),0) FROM pagos WHERE usuario_id = u.id AND estado='Pagado') AS total_pagado,
    (SELECT COALESCE(SUM(saldo_pendiente),0) FROM facturas WHERE usuario_id = u.id) AS deuda
FROM usuarios u LEFT JOIN membresias m ON u.id = m.usuario_id;