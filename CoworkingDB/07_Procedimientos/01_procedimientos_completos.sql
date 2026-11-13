-- ==========================================
-- FASE 7: PROCEDIMIENTOS ALMACENADOS (20)
-- Archivo: 07_Procedimientos/01_procedimientos_completos.sql
-- Descripción: Operaciones complejas encapsuladas para gestión del coworking.
-- Ejecutar COMPLETO con Alt + X
-- ==========================================

USE coworking_db;
DELIMITER $$

-- 1. sp_registrar_usuario: Inserta un nuevo usuario con fecha de registro automática.
DROP PROCEDURE IF EXISTS sp_registrar_usuario$$
CREATE PROCEDURE sp_registrar_usuario(
    IN p_nombre VARCHAR(50), IN p_apellidos VARCHAR(50), 
    IN p_email VARCHAR(100), IN p_telefono VARCHAR(20)
)
BEGIN
    INSERT INTO usuarios (nombre, apellidos, email, telefono, fecha_registro)
    VALUES (p_nombre, p_apellidos, p_email, p_telefono, NOW());
END$$

-- 2. sp_actualizar_datos_usuario: Actualiza email y teléfono de un usuario existente.
DROP PROCEDURE IF EXISTS sp_actualizar_datos_usuario$$
CREATE PROCEDURE sp_actualizar_datos_usuario(
    IN p_id INT, IN p_email VARCHAR(100), IN p_telefono VARCHAR(20)
)
BEGIN
    UPDATE usuarios SET email = p_email, telefono = p_telefono WHERE id = p_id;
END$$

-- 3. sp_crear_membresia: Crea una nueva membresía activa para un usuario.
DROP PROCEDURE IF EXISTS sp_crear_membresia$$
CREATE PROCEDURE sp_crear_membresia(
    IN p_usuario_id INT, IN p_tipo_id INT
)
BEGIN
    INSERT INTO membresias (usuario_id, tipo_membresia_id, fecha_inicio, estado)
    VALUES (p_usuario_id, p_tipo_id, NOW(), 'Activa');
END$$

-- 4. sp_renovar_membresia: Extiende la vigencia de la última membresía de un usuario en 30 días.
DROP PROCEDURE IF EXISTS sp_renovar_membresia$$
CREATE PROCEDURE sp_renovar_membresia(IN p_usuario_id INT)
BEGIN
    UPDATE membresias 
    SET estado = 'Activa', fecha_vencimiento = DATE_ADD(fecha_vencimiento, INTERVAL 30 DAY)
    WHERE usuario_id = p_usuario_id AND id = (SELECT MAX(id) FROM membresias WHERE usuario_id = p_usuario_id);
END$$

-- 5. sp_cancelar_membresia: Suspende todas las membresías activas de un usuario.
DROP PROCEDURE IF EXISTS sp_cancelar_membresia$$
CREATE PROCEDURE sp_cancelar_membresia(IN p_usuario_id INT)
BEGIN
    UPDATE membresias SET estado = 'Suspendida' 
    WHERE usuario_id = p_usuario_id AND estado = 'Activa';
END$$

-- 6. sp_crear_reserva: Registra una nueva reserva en estado pendiente.
DROP PROCEDURE IF EXISTS sp_crear_reserva$$
CREATE PROCEDURE sp_crear_reserva(
    IN p_usuario_id INT, IN p_espacio_id INT, 
    IN p_inicio DATETIME, IN p_fin DATETIME, IN p_costo DECIMAL(10,2)
)
BEGIN
    INSERT INTO reservas (usuario_id, espacio_id, fecha_inicio, fecha_fin, estado, costo_total)
    VALUES (p_usuario_id, p_espacio_id, p_inicio, p_fin, 'Pendiente', p_costo);
END$$

-- 7. sp_cancelar_reserva: Cambia el estado de una reserva a 'Cancelada'.
DROP PROCEDURE IF EXISTS sp_cancelar_reserva$$
CREATE PROCEDURE sp_cancelar_reserva(IN p_reserva_id INT)
BEGIN
    UPDATE reservas SET estado = 'Cancelada' WHERE id = p_reserva_id;
END$$

-- 8. sp_confirmar_reserva: Cambia el estado de una reserva a 'Confirmada'.
DROP PROCEDURE IF EXISTS sp_confirmar_reserva$$
CREATE PROCEDURE sp_confirmar_reserva(IN p_reserva_id INT)
BEGIN
    UPDATE reservas SET estado = 'Confirmada' WHERE id = p_reserva_id;
END$$

-- 9. sp_agregar_servicio_reserva: Añade un servicio adicional a una reserva existente.
DROP PROCEDURE IF EXISTS sp_agregar_servicio_reserva$$
CREATE PROCEDURE sp_agregar_servicio_reserva(
    IN p_reserva_id INT, IN p_servicio_id INT, IN p_subtotal DECIMAL(10,2)
)
BEGIN
    INSERT INTO reserva_servicios (reserva_id, servicio_id, subtotal)
    VALUES (p_reserva_id, p_servicio_id, p_subtotal);
END$$

-- 10. sp_consultar_disponibilidad: Cuenta reservas ocupadas en un espacio para una fecha específica.
DROP PROCEDURE IF EXISTS sp_consultar_disponibilidad$$
CREATE PROCEDURE sp_consultar_disponibilidad(
    IN p_espacio_id INT, IN p_fecha DATETIME
)
BEGIN
    SELECT COUNT(*) AS reservas_ocupadas 
    FROM reservas 
    WHERE espacio_id = p_espacio_id 
    AND DATE(fecha_inicio) = DATE(p_fecha) 
    AND estado IN ('Pendiente', 'Confirmada');
END$$

-- 11. sp_registrar_pago: Registra un nuevo pago en estado 'Pagado'.
DROP PROCEDURE IF EXISTS sp_registrar_pago$$
CREATE PROCEDURE sp_registrar_pago(
    IN p_usuario_id INT, IN p_monto DECIMAL(10,2), IN p_metodo VARCHAR(20)
)
BEGIN
    INSERT INTO pagos (usuario_id, monto, metodo_pago, fecha_pago, estado)
    VALUES (p_usuario_id, p_monto, p_metodo, NOW(), 'Pagado');
END$$

-- 12. sp_generar_factura: Crea una nueva factura pendiente con vencimiento a 30 días.
DROP PROCEDURE IF EXISTS sp_generar_factura$$
CREATE PROCEDURE sp_generar_factura(
    IN p_usuario_id INT, IN p_monto DECIMAL(10,2)
)
BEGIN
    INSERT INTO facturas (usuario_id, monto_total, saldo_pendiente, fecha_emision, fecha_vencimiento, estado)
    VALUES (p_usuario_id, p_monto, p_monto, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 'Pendiente');
END$$

-- 13. sp_anular_factura: Anula una factura registrando el motivo.
DROP PROCEDURE IF EXISTS sp_anular_factura$$
CREATE PROCEDURE sp_anular_factura(IN p_factura_id INT, IN p_motivo VARCHAR(100))
BEGIN
    UPDATE facturas SET estado = 'Anulada', motivo_anulacion = p_motivo WHERE id = p_factura_id;
END$$

-- 14. sp_aplicar_pago_a_factura: Vincula un pago a una factura específica.
DROP PROCEDURE IF EXISTS sp_aplicar_pago_a_factura$$
CREATE PROCEDURE sp_aplicar_pago_a_factura(
    IN p_factura_id INT, IN p_pago_id INT, IN p_monto_aplicado DECIMAL(10,2)
)
BEGIN
    INSERT INTO factura_pagos (factura_id, pago_id, monto_aplicado, fecha_aplicacion)
    VALUES (p_factura_id, p_pago_id, p_monto_aplicado, NOW());
END$$

-- 15. sp_consultar_saldo_usuario: Calcula el saldo pendiente total de un usuario.
DROP PROCEDURE IF EXISTS sp_consultar_saldo_usuario$$
CREATE PROCEDURE sp_consultar_saldo_usuario(IN p_usuario_id INT)
BEGIN
    SELECT COALESCE(SUM(saldo_pendiente), 0) AS saldo_total 
    FROM facturas WHERE usuario_id = p_usuario_id AND estado != 'Anulada';
END$$

-- 16. sp_registrar_acceso: Registra la entrada de un usuario al coworking.
DROP PROCEDURE IF EXISTS sp_registrar_acceso$$
CREATE PROCEDURE sp_registrar_acceso(
    IN p_usuario_id INT, IN p_metodo VARCHAR(20), IN p_estado VARCHAR(20)
)
BEGIN
    INSERT INTO accesos (usuario_id, fecha_hora_entrada, metodo_acceso, estado)
    VALUES (p_usuario_id, NOW(), p_metodo, p_estado);
END$$

-- 17. sp_reporte_ingresos_mensuales: Suma los ingresos totales de un mes específico.
DROP PROCEDURE IF EXISTS sp_reporte_ingresos_mensuales$$
CREATE PROCEDURE sp_reporte_ingresos_mensuales(IN p_mes INT)
BEGIN
    SELECT SUM(monto) AS total_ingresos 
    FROM pagos WHERE MONTH(fecha_pago) = p_mes AND estado = 'Pagado';
END$$

-- 18. sp_reporte_usuarios_morosos: Lista usuarios con facturas vencidas y su deuda total.
DROP PROCEDURE IF EXISTS sp_reporte_usuarios_morosos$$
CREATE PROCEDURE sp_reporte_usuarios_morosos()
BEGIN
    SELECT u.id, u.nombre, SUM(f.saldo_pendiente) AS deuda_total
    FROM usuarios u INNER JOIN facturas f ON u.id = f.usuario_id
    WHERE f.estado = 'Pendiente' AND f.fecha_vencimiento < NOW()
    GROUP BY u.id, u.nombre;
END$$

-- 19. sp_reporte_ocupacion_espacios: Muestra la cantidad de reservas confirmadas por espacio.
DROP PROCEDURE IF EXISTS sp_reporte_ocupacion_espacios$$
CREATE PROCEDURE sp_reporte_ocupacion_espacios()
BEGIN
    SELECT e.nombre, COUNT(r.id) AS total_reservas
    FROM espacios e LEFT JOIN reservas r ON e.id = r.espacio_id AND r.estado = 'Confirmada'
    GROUP BY e.id, e.nombre ORDER BY total_reservas DESC;
END$$

-- 20. sp_eliminar_usuario: Elimina un usuario solo si no tiene reservas activas (validación de integridad).
DROP PROCEDURE IF EXISTS sp_eliminar_usuario$$
CREATE PROCEDURE sp_eliminar_usuario(IN p_usuario_id INT)
BEGIN
    DECLARE v_reservas INT;
    SELECT COUNT(*) INTO v_reservas FROM reservas WHERE usuario_id = p_usuario_id AND estado IN ('Pendiente', 'Confirmada');
    
    IF v_reservas = 0 THEN
        DELETE FROM usuarios WHERE id = p_usuario_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar: tiene reservas activas';
    END IF;
END$$

DELIMITER ;

-- Verificación final
SHOW PROCEDURE STATUS WHERE Db = 'coworking_db';