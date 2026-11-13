-- ==========================================
-- FASE 5: EVENTOS (20 Eventos Programados)
-- Archivo: 05_Eventos/01_eventos_completos.sql
-- Ejecutar COMPLETO con Alt + X
-- ==========================================

SET GLOBAL event_scheduler = ON;
SELECT @@event_scheduler;

-- Evento 1
DROP EVENT IF EXISTS evt_actualizar_membresias_vencidas;
CREATE EVENT evt_actualizar_membresias_vencidas
ON SCHEDULE EVERY 1 DAY STARTS NOW() + INTERVAL 1 DAY
DO UPDATE membresias SET estado = 'Vencida' WHERE fecha_vencimiento < NOW() AND estado = 'Activa';

-- Evento 2
DROP EVENT IF EXISTS evt_recordatorio_vencimiento_5dias;
CREATE EVENT evt_recordatorio_vencimiento_5dias
ON SCHEDULE EVERY 1 DAY STARTS NOW() + INTERVAL 1 DAY
DO INSERT INTO logs_auditoria (tabla_afectada, registro_id, accion, fecha_hora, detalles, usuario_db)
SELECT 'membresias', id, 'RECORDATORIO_5_DIAS', NOW(), CONCAT('Membresía vence en 5 días - Usuario: ', usuario_id), 'SYSTEM'
FROM membresias WHERE fecha_vencimiento BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 5 DAY) AND estado = 'Activa';

-- Evento 3
DROP EVENT IF EXISTS evt_suspender_membresias_inactivas;
CREATE EVENT evt_suspender_membresias_inactivas
ON SCHEDULE EVERY 1 DAY STARTS NOW() + INTERVAL 1 DAY
DO UPDATE membresias SET estado = 'Suspendida' 
WHERE usuario_id NOT IN (SELECT usuario_id FROM pagos WHERE fecha_pago >= DATE_SUB(NOW(), INTERVAL 30 DAY)) AND estado = 'Activa';

-- Evento 4
DROP EVENT IF EXISTS evt_reporte_semanal_nuevas_membresias;
CREATE EVENT evt_reporte_semanal_nuevas_membresias
ON SCHEDULE EVERY 1 WEEK STARTS NOW() + INTERVAL 1 DAY
DO INSERT INTO logs_auditoria (tabla_afectada, registro_id, accion, fecha_hora, detalles, usuario_db)
VALUES ('reportes', 0, 'REPORTE_SEMANAL_MEMBRESIAS', NOW(), CONCAT('Nuevas membresías esta semana: ', (SELECT COUNT(*) FROM membresias WHERE fecha_inicio >= DATE_SUB(NOW(), INTERVAL 7 DAY))), 'SYSTEM');

-- Evento 5
DROP EVENT IF EXISTS evt_notificar_membresias_suspendidas;
CREATE EVENT evt_notificar_membresias_suspendidas
ON SCHEDULE EVERY 1 DAY STARTS NOW() + INTERVAL 1 HOUR
DO INSERT INTO logs_auditoria (tabla_afectada, registro_id, accion, fecha_hora, detalles, usuario_db)
SELECT 'membresias', id, 'NOTIFICACION_SUSPENSION', NOW(), CONCAT('Membresía suspendida - Usuario: ', usuario_id), 'SYSTEM'
FROM membresias WHERE estado = 'Suspendida' AND DATE(fecha_vencimiento) = CURDATE();

-- Evento 6
DROP EVENT IF EXISTS evt_cancelar_reservas_pendientes;
CREATE EVENT evt_cancelar_reservas_pendientes
ON SCHEDULE EVERY 30 MINUTE
DO UPDATE reservas SET estado = 'Cancelada' WHERE estado = 'Pendiente' AND fecha_inicio < DATE_ADD(NOW(), INTERVAL 2 HOUR);

-- Evento 7
DROP EVENT IF EXISTS evt_recordatorio_reserva_1hora;
CREATE EVENT evt_recordatorio_reserva_1hora
ON SCHEDULE EVERY 1 HOUR
DO INSERT INTO logs_auditoria (tabla_afectada, registro_id, accion, fecha_hora, detalles, usuario_db)
SELECT 'reservas', id, 'RECORDATORIO_1_HORA', NOW(), CONCAT('Reserva en 1 hora - Usuario: ', usuario_id, ' Espacio: ', espacio_id), 'SYSTEM'
FROM reservas WHERE fecha_inicio BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 1 HOUR) AND estado = 'Confirmada';

-- Evento 8
DROP EVENT IF EXISTS evt_eliminar_reservas_antiguas;
CREATE EVENT evt_eliminar_reservas_antiguas
ON SCHEDULE EVERY 1 WEEK STARTS NOW() + INTERVAL 1 DAY
DO DELETE FROM reservas WHERE fecha_fin < DATE_SUB(NOW(), INTERVAL 7 DAY) AND estado = 'No Show';

-- Evento 9
DROP EVENT IF EXISTS evt_reporte_semanal_ocupacion;
CREATE EVENT evt_reporte_semanal_ocupacion
ON SCHEDULE EVERY 1 WEEK STARTS NOW() + INTERVAL 1 DAY
DO INSERT INTO logs_auditoria (tabla_afectada, registro_id, accion, fecha_hora, detalles, usuario_db)
VALUES ('reportes', 0, 'REPORTE_OCUPACION_SEMANAL', NOW(), CONCAT('Total reservas esta semana: ', (SELECT COUNT(*) FROM reservas WHERE fecha_inicio >= DATE_SUB(NOW(), INTERVAL 7 DAY))), 'SYSTEM');

-- Evento 10
DROP EVENT IF EXISTS evt_liberar_reservas_bloqueadas;
CREATE EVENT evt_liberar_reservas_bloqueadas
ON SCHEDULE EVERY 15 MINUTE
DO UPDATE reservas SET estado = 'Cancelada' 
WHERE estado = 'Confirmada' AND fecha_inicio < DATE_SUB(NOW(), INTERVAL 15 MINUTE)
AND usuario_id NOT IN (SELECT usuario_id FROM accesos WHERE DATE(fecha_hora_entrada) = DATE(NOW()));

-- Evento 11
DROP EVENT IF EXISTS evt_recordatorio_pago_pendiente;
CREATE EVENT evt_recordatorio_pago_pendiente
ON SCHEDULE EVERY 3 DAYS STARTS NOW() + INTERVAL 1 DAY
DO INSERT INTO logs_auditoria (tabla_afectada, registro_id, accion, fecha_hora, detalles, usuario_db)
SELECT 'facturas', id, 'RECORDATORIO_PAGO', NOW(), CONCAT('Factura pendiente - Usuario: ', usuario_id, ' Monto: ', monto_total), 'SYSTEM'
FROM facturas WHERE estado = 'Pendiente' AND fecha_vencimiento >= NOW();

-- Evento 12
DROP EVENT IF EXISTS evt_bloquear_servicios_facturas_vencidas;
CREATE EVENT evt_bloquear_servicios_facturas_vencidas
ON SCHEDULE EVERY 1 DAY STARTS NOW() + INTERVAL 1 DAY
DO UPDATE membresias SET estado = 'Suspendida' 
WHERE usuario_id IN (SELECT DISTINCT usuario_id FROM facturas WHERE fecha_vencimiento < DATE_SUB(NOW(), INTERVAL 10 DAY) AND estado = 'Pendiente') AND estado = 'Activa';

-- Evento 13
DROP EVENT IF EXISTS evt_resumen_facturacion_mensual;
CREATE EVENT evt_resumen_facturacion_mensual
ON SCHEDULE EVERY 1 MONTH STARTS NOW() + INTERVAL 1 MONTH
DO INSERT INTO logs_auditoria (tabla_afectada, registro_id, accion, fecha_hora, detalles, usuario_db)
VALUES ('reportes', 0, 'RESUMEN_FACTURACION_MENSUAL', NOW(), CONCAT('Total facturado este mes: ', (SELECT COALESCE(SUM(monto_total), 0) FROM facturas WHERE MONTH(fecha_emision) = MONTH(NOW()))), 'SYSTEM');

-- Evento 14
DROP EVENT IF EXISTS evt_aplicar_recargos_facturas;
CREATE EVENT evt_aplicar_recargos_facturas
ON SCHEDULE EVERY 1 DAY STARTS NOW() + INTERVAL 1 DAY
DO UPDATE facturas SET monto_total = monto_total * 1.10, saldo_pendiente = saldo_pendiente * 1.10
WHERE fecha_vencimiento < DATE_SUB(NOW(), INTERVAL 15 DAY) AND estado = 'Pendiente' AND saldo_pendiente > 0;

-- Evento 15
DROP EVENT IF EXISTS evt_reporte_ingresos_contador;
CREATE EVENT evt_reporte_ingresos_contador
ON SCHEDULE EVERY 1 MONTH STARTS NOW() + INTERVAL 1 MONTH
DO INSERT INTO logs_auditoria (tabla_afectada, registro_id, accion, fecha_hora, detalles, usuario_db)
VALUES ('reportes', 0, 'REPORTE_INGRESOS_MENSUAL', NOW(), CONCAT('Ingresos del mes: ', (SELECT COALESCE(SUM(monto), 0) FROM pagos WHERE MONTH(fecha_pago) = MONTH(NOW()) AND estado = 'Pagado')), 'CONTADOR');

-- Evento 16
DROP EVENT IF EXISTS evt_eliminar_accesos_antiguos;
CREATE EVENT evt_eliminar_accesos_antiguos
ON SCHEDULE EVERY 1 MONTH STARTS NOW() + INTERVAL 1 DAY
DO DELETE FROM accesos WHERE fecha_hora_entrada < DATE_SUB(NOW(), INTERVAL 1 YEAR);

-- Evento 17
DROP EVENT IF EXISTS evt_reporte_diario_asistencias;
CREATE EVENT evt_reporte_diario_asistencias
ON SCHEDULE EVERY 1 DAY STARTS NOW() + INTERVAL 1 DAY + INTERVAL 23 HOUR
DO INSERT INTO logs_auditoria (tabla_afectada, registro_id, accion, fecha_hora, detalles, usuario_db)
VALUES ('reportes', 0, 'REPORTE_ASISTENCIAS_DIARIO', NOW(), CONCAT('Asistencias hoy: ', (SELECT COUNT(*) FROM accesos WHERE DATE(fecha_hora_entrada) = CURDATE() AND estado = 'Permitido')), 'ADMIN');

-- Evento 18
DROP EVENT IF EXISTS evt_reporte_usuarios_inactivos;
CREATE EVENT evt_reporte_usuarios_inactivos
ON SCHEDULE EVERY 1 WEEK STARTS NOW() + INTERVAL 1 DAY
DO INSERT INTO logs_auditoria (tabla_afectada, registro_id, accion, fecha_hora, detalles, usuario_db)
VALUES ('reportes', 0, 'REPORTE_USUARIOS_INACTIVOS', NOW(), CONCAT('Usuarios sin accesos en 7 días: ', (SELECT COUNT(DISTINCT u.id) FROM usuarios u LEFT JOIN accesos a ON u.id = a.usuario_id WHERE a.fecha_hora_entrada < DATE_SUB(NOW(), INTERVAL 7 DAY) OR a.id IS NULL)), 'ADMIN');

-- Evento 19
DROP EVENT IF EXISTS evt_alertar_accesos_fuera_horario;
CREATE EVENT evt_alertar_accesos_fuera_horario
ON SCHEDULE EVERY 1 DAY STARTS NOW() + INTERVAL 1 DAY + INTERVAL 23 HOUR
DO INSERT INTO logs_auditoria (tabla_afectada, registro_id, accion, fecha_hora, detalles, usuario_db)
SELECT 'accesos', id, 'ALERTA_FUERA_HORARIO', NOW(), CONCAT('Acceso fuera de horario - Usuario: ', usuario_id), 'SYSTEM'
FROM accesos WHERE DATE(fecha_hora_entrada) = CURDATE() AND (TIME(fecha_hora_entrada) < '08:00:00' OR TIME(fecha_hora_entrada) > '20:00:00');

-- Evento 20
DROP EVENT IF EXISTS evt_reporte_top_usuarios_frecuentes;
CREATE EVENT evt_reporte_top_usuarios_frecuentes
ON SCHEDULE EVERY 1 MONTH STARTS NOW() + INTERVAL 1 MONTH
DO INSERT INTO logs_auditoria (tabla_afectada, registro_id, accion, fecha_hora, detalles, usuario_db)
VALUES ('reportes', 0, 'TOP_10_USUARIOS_MENSUAL', NOW(), CONCAT('Top usuarios del mes - Ver tabla de reportes'), 'ADMIN');

-- Verificación final
SHOW EVENTS;