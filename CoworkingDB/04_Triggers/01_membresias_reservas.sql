DELIMITER $$

USE coworking_db$$

-- 1. Calcular fecha de vencimiento automática
CREATE TRIGGER trg_membresia_fecha_vencimiento
BEFORE INSERT ON membresias
FOR EACH ROW
BEGIN
    SET NEW.fecha_vencimiento = DATE_ADD(NEW.fecha_inicio, 
        INTERVAL (SELECT duracion_dias FROM tipos_membresia WHERE id = NEW.tipo_membresia_id) DAY);
END$$

-- 2. Activar membresía al pagar
CREATE TRIGGER trg_pago_activa_membresia
AFTER INSERT ON pagos
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Pagado' THEN
        UPDATE membresias SET estado = 'Activa' 
        WHERE usuario_id = NEW.usuario_id AND fecha_vencimiento >= NEW.fecha_pago;
    END IF;
END$$

-- 3. Suspender membresía por factura vencida
CREATE TRIGGER trg_factura_vencida_suspende_membresia
AFTER UPDATE ON facturas
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Pendiente' AND NEW.fecha_vencimiento < NOW() THEN
        UPDATE membresias SET estado = 'Suspendida' 
        WHERE usuario_id = NEW.usuario_id AND estado = 'Activa';
    END IF;
END$$

-- 4. Log de cambios de membresía
CREATE TRIGGER trg_log_cambio_membresia
AFTER UPDATE ON membresias
FOR EACH ROW
BEGIN
    IF OLD.tipo_membresia_id != NEW.tipo_membresia_id THEN
        INSERT INTO historial_membresias (usuario_id, membresia_anterior_id, membresia_nueva_id, fecha_cambio)
        VALUES (NEW.usuario_id, OLD.id, NEW.id, NOW());
    END IF;
END$$

-- 5. Bloquear borrado de membresía con reservas activas
CREATE TRIGGER trg_bloquear_borrado_membresia
BEFORE DELETE ON membresias
FOR EACH ROW
BEGIN
    DECLARE v_reservas INT;
    SELECT COUNT(*) INTO v_reservas FROM reservas 
    WHERE usuario_id = OLD.usuario_id AND estado IN ('Pendiente', 'Confirmada');
    IF v_reservas > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar: tiene reservas activas';
    END IF;
END$$

-- 6. Validar solapamiento de reservas
CREATE TRIGGER trg_validar_solapamiento_reserva
BEFORE INSERT ON reservas
FOR EACH ROW
BEGIN
    DECLARE v_solapamientos INT;
    SELECT COUNT(*) INTO v_solapamientos FROM reservas 
    WHERE espacio_id = NEW.espacio_id AND estado IN ('Pendiente', 'Confirmada')
    AND NEW.fecha_inicio < fecha_fin AND NEW.fecha_fin > fecha_inicio;
    IF v_solapamientos > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Ya existe una reserva en ese horario';
    END IF;
END$$

-- 7. Estado inicial de reserva
CREATE TRIGGER trg_estado_inicial_reserva
BEFORE INSERT ON reservas
FOR EACH ROW
BEGIN
    IF NEW.estado IS NULL THEN SET NEW.estado = 'Pendiente'; END IF;
END$$

-- 8. Confirmar reserva al pagar
CREATE TRIGGER trg_pago_confirma_reserva
AFTER INSERT ON pagos
FOR EACH ROW
BEGIN
    UPDATE reservas SET estado = 'Confirmada' 
    WHERE usuario_id = NEW.usuario_id AND estado = 'Pendiente' AND costo_total = NEW.monto LIMIT 1;
END$$

-- 9. Cancelar reservas sin membresía
CREATE TRIGGER trg_cancelar_reservas_sin_membresia
AFTER UPDATE ON membresias
FOR EACH ROW
BEGIN
    IF NEW.estado IN ('Suspendida', 'Vencida') AND OLD.estado = 'Activa' THEN
        UPDATE reservas SET estado = 'Cancelada' 
        WHERE usuario_id = NEW.usuario_id AND estado = 'Pendiente' AND fecha_inicio > NOW();
    END IF;
END$$

-- 10. Log de cancelación de reservas
CREATE TRIGGER trg_log_cancelacion_reserva
AFTER UPDATE ON reservas
FOR EACH ROW
BEGIN
    IF OLD.estado != 'Cancelada' AND NEW.estado =