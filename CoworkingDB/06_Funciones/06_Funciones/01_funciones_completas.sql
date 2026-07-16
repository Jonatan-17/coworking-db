-- ==========================================
-- FASE 6: FUNCIONES ALMACENADAS (20)
-- Archivo: 06_Funciones/01_funciones_completas.sql
-- Descripción: Funciones reutilizables para cálculos y validaciones.
-- Ejecutar COMPLETO con Alt + X
-- ==========================================

USE coworking_db;
DELIMITER $$

-- 1. fn_calcular_edad: Calcula la edad exacta de un usuario a partir de su fecha de nacimiento.
DROP FUNCTION IF EXISTS fn_calcular_edad$$
CREATE FUNCTION fn_calcular_edad(fecha_nac DATE) RETURNS INT DETERMINISTIC
BEGIN RETURN TIMESTAMPDIFF(YEAR, fecha_nac, CURDATE()); END$$

-- 2. fn_dias_restantes_membresia: Retorna los días que faltan para que venza la membresía activa de un usuario.
DROP FUNCTION IF EXISTS fn_dias_restantes_membresia$$
CREATE FUNCTION fn_dias_restantes_membresia(id_usuario INT) RETURNS INT DETERMINISTIC
BEGIN RETURN (SELECT COALESCE(DATEDIFF(fecha_vencimiento, CURDATE()), 0) FROM membresias WHERE usuario_id = id_usuario AND estado = 'Activa' ORDER BY fecha_vencimiento DESC LIMIT 1); END$$

-- 3. fn_total_pagado_usuario: Suma el total de dinero pagado por un usuario en estado 'Pagado'.
DROP FUNCTION IF EXISTS fn_total_pagado_usuario$$
CREATE FUNCTION fn_total_pagado_usuario(id_usuario INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN RETURN (SELECT COALESCE(SUM(monto), 0) FROM pagos WHERE usuario_id = id_usuario AND estado = 'Pagado'); END$$

-- 4. fn_estado_membresia_usuario: Obtiene el estado actual de la última membresía de un usuario.
DROP FUNCTION IF EXISTS fn_estado_membresia_usuario$$
CREATE FUNCTION fn_estado_membresia_usuario(id_usuario INT) RETURNS VARCHAR(20) DETERMINISTIC
BEGIN RETURN (SELECT estado FROM membresias WHERE usuario_id = id_usuario ORDER BY id DESC LIMIT 1); END$$

-- 5. fn_horas_reservadas_usuario: Calcula el total de horas que un usuario ha reservado espacios confirmados.
DROP FUNCTION IF EXISTS fn_horas_reservadas_usuario$$
CREATE FUNCTION fn_horas_reservadas_usuario(id_usuario INT) RETURNS INT DETERMINISTIC
BEGIN RETURN (SELECT COALESCE(SUM(TIMESTAMPDIFF(HOUR, fecha_inicio, fecha_fin)), 0) FROM reservas WHERE usuario_id = id_usuario AND estado = 'Confirmada'); END$$

-- 6. fn_costo_promedio_reserva: Calcula el costo promedio de todas las reservas de un usuario.
DROP FUNCTION IF EXISTS fn_costo_promedio_reserva$$
CREATE FUNCTION fn_costo_promedio_reserva(id_usuario INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN RETURN (SELECT COALESCE(AVG(costo_total), 0) FROM reservas WHERE usuario_id = id_usuario); END$$

-- 7. fn_cantidad_reservas_mes: Cuenta cuántas reservas hizo un usuario en un mes específico.
DROP FUNCTION IF EXISTS fn_cantidad_reservas_mes$$
CREATE FUNCTION fn_cantidad_reservas_mes(id_usuario INT, mes INT) RETURNS INT DETERMINISTIC
BEGIN RETURN (SELECT COUNT(*) FROM reservas WHERE usuario_id = id_usuario AND MONTH(fecha_inicio) = mes); END$$

-- 8. fn_espacio_mas_usado: Identifica el tipo de espacio que más ha utilizado un usuario.
DROP FUNCTION IF EXISTS fn_espacio_mas_usado$$
CREATE FUNCTION fn_espacio_mas_usado(id_usuario INT) RETURNS VARCHAR(50) DETERMINISTIC
BEGIN RETURN (SELECT e.tipo FROM reservas r INNER JOIN espacios e ON r.espacio_id = e.id WHERE r.usuario_id = id_usuario GROUP BY e.tipo ORDER BY COUNT(*) DESC LIMIT 1); END$$

-- 9. fn_ingresos_totales_mes: Suma los ingresos totales del coworking en un mes específico.
DROP FUNCTION IF EXISTS fn_ingresos_totales_mes$$
CREATE FUNCTION fn_ingresos_totales_mes(mes INT) RETURNS DECIMAL(12,2) DETERMINISTIC
BEGIN RETURN (SELECT COALESCE(SUM(monto), 0) FROM pagos WHERE MONTH(fecha_pago) = mes AND estado = 'Pagado'); END$$

-- 10. fn_descuento_fidelidad: Calcula el % de descuento basado en la cantidad total de reservas del usuario.
DROP FUNCTION IF EXISTS fn_descuento_fidelidad$$
CREATE FUNCTION fn_descuento_fidelidad(id_usuario INT) RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
    DECLARE total INT; SET total = (SELECT COUNT(*) FROM reservas WHERE usuario_id = id_usuario);
    IF total > 20 THEN RETURN 15.00; ELSEIF total > 10 THEN RETURN 10.00; ELSEIF total > 5 THEN RETURN 5.00; ELSE RETURN 0.00; END IF;
END$$

-- 11. fn_validar_capacidad_espacio: Valida si un espacio soporta una cantidad específica de personas.
DROP FUNCTION IF EXISTS fn_validar_capacidad_espacio$$
CREATE FUNCTION fn_validar_capacidad_espacio(id_espacio INT, cantidad_personas INT) RETURNS BOOLEAN DETERMINISTIC
BEGIN RETURN (SELECT capacidad_maxima >= cantidad_personas FROM espacios WHERE id = id_espacio); END$$

-- 12. fn_dias_membresia_vencida: Calcula cuántos días han pasado desde que venció la membresía de un usuario.
DROP FUNCTION IF EXISTS fn_dias_membresia_vencida$$
CREATE FUNCTION fn_dias_membresia_vencida(id_usuario INT) RETURNS INT DETERMINISTIC
BEGIN RETURN (SELECT COALESCE(DATEDIFF(CURDATE(), fecha_vencimiento), 0) FROM membresias WHERE usuario_id = id_usuario AND estado = 'Vencida' ORDER BY id DESC LIMIT 1); END$$

-- 13. fn_total_facturado_usuario: Suma el monto total de todas las facturas emitidas a un usuario.
DROP FUNCTION IF EXISTS fn_total_facturado_usuario$$
CREATE FUNCTION fn_total_facturado_usuario(id_usuario INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN RETURN (SELECT COALESCE(SUM(monto_total), 0) FROM facturas WHERE usuario_id = id_usuario); END$$

-- 14. fn_saldo_pendiente_usuario: Calcula la deuda total pendiente de un usuario.
DROP FUNCTION IF EXISTS fn_saldo_pendiente_usuario$$
CREATE FUNCTION fn_saldo_pendiente_usuario(id_usuario INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN RETURN (SELECT COALESCE(SUM(saldo_pendiente), 0) FROM facturas WHERE usuario_id = id_usuario); END$$

-- 15. fn_accesos_fines_semana: Cuenta cuántos accesos permitidos ha tenido un usuario en fines de semana.
DROP FUNCTION IF EXISTS fn_accesos_fines_semana$$
CREATE FUNCTION fn_accesos_fines_semana(id_usuario INT) RETURNS INT DETERMINISTIC
BEGIN RETURN (SELECT COUNT(*) FROM accesos WHERE usuario_id = id_usuario AND DAYOFWEEK(fecha_hora_entrada) IN (1, 7)); END$$

-- 16. fn_promedio_asistencias_mensuales: Calcula el promedio mensual de asistencias de un usuario en el año actual.
DROP FUNCTION IF EXISTS fn_promedio_asistencias_mensuales$$
CREATE FUNCTION fn_promedio_asistencias_mensuales(id_usuario INT) RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN RETURN (SELECT COUNT(*) / 12 FROM accesos WHERE usuario_id = id_usuario AND YEAR(fecha_hora_entrada) = YEAR(CURDATE())); END$$

-- 17. fn_calificar_usuario: Califica el comportamiento del usuario (Bueno, Regular, Malo) según sus accesos rechazados.
DROP FUNCTION IF EXISTS fn_calificar_usuario$$
CREATE FUNCTION fn_calificar_usuario(id_usuario INT) RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
    DECLARE rechazados INT; SET rechazados = (SELECT COUNT(*) FROM accesos WHERE usuario_id = id_usuario AND estado = 'Rechazado');
    IF rechazados = 0 THEN RETURN 'Bueno'; ELSEIF rechazados <= 3 THEN RETURN 'Regular'; ELSE RETURN 'Malo'; END IF;
END$$

-- 18. fn_costo_total_con_servicios: Calcula el costo total de una reserva sumando sus servicios adicionales.
DROP FUNCTION IF EXISTS fn_costo_total_con_servicios$$
CREATE FUNCTION fn_costo_total_con_servicios(id_reserva INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN RETURN (SELECT r.costo_total + COALESCE(SUM(rs.subtotal), 0) FROM reservas r LEFT JOIN reserva_servicios rs ON r.id = rs.reserva_id WHERE r.id = id_reserva); END$$

-- 19. fn_tiempo_uso_espacio: Calcula el total de horas que un espacio específico ha sido utilizado.
DROP FUNCTION IF EXISTS fn_tiempo_uso_espacio$$
CREATE FUNCTION fn_tiempo_uso_espacio(id_espacio INT) RETURNS INT DETERMINISTIC
BEGIN RETURN (SELECT COALESCE(SUM(TIMESTAMPDIFF(HOUR, fecha_inicio, fecha_fin)), 0) FROM reservas WHERE espacio_id = id_espacio AND estado = 'Confirmada'); END$$

-- 20. fn_generar_codigo_acceso: Genera un código único de acceso temporal para un usuario.
DROP FUNCTION IF EXISTS fn_generar_codigo_acceso$$
CREATE FUNCTION fn_generar_codigo_acceso(id_usuario INT) RETURNS VARCHAR(20) DETERMINISTIC
BEGIN RETURN CONCAT('CW-', id_usuario, '-', DATE_FORMAT(CURDATE(), '%Y%m'), '-', LPAD(FLOOR(RAND() * 9999), 4, '0')); END$$

DELIMITER ;