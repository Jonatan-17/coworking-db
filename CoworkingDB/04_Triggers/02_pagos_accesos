DELIMITER $$

USE coworking_db$$

-- 11. Crear factura al registrar pago
CREATE TRIGGER trg_pago_crea_factura
AFTER INSERT ON pagos
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Pagado' THEN
        INSERT INTO facturas (usuario_id, monto_total, saldo_pendiente, fecha_emision, fecha_vencimiento, estado)
        VALUES (NEW.usuario_id, NEW.monto, 0, NEW.fecha_pago, DATE_ADD(NEW.fecha_pago, INTERVAL 30 DAY), 'Pagada');
    END IF;
END$$

-- 12. Actualizar factura a pagada
CREATE TRIGGER trg_pago_factura_pagada
AFTER INSERT ON factura_pagos
FOR EACH ROW
BEGIN
    UPDATE facturas SET estado = 'Pagada', saldo_pendiente = 0 WHERE id = NEW.factura_id;
END$$

-- 13. Bloquear eliminación de pago con factura
CREATE TRIGGER trg_bloquear_borrado_pago
BEFORE DELETE ON pagos
FOR EACH ROW
BEGIN
    DECLARE v_facturas INT;
    SELECT COUNT(*) INTO v_facturas FROM factura_pagos WHERE pago_id = OLD.id;
    IF v_facturas > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar: existe factura asociada';
    END IF;
END$$

-- 14. Actualizar saldo pendiente
CREATE TRIGGER trg_actualizar_saldo_pendiente
AFTER INSERT ON factura_pagos
FOR EACH ROW
BEGIN
    UPDATE facturas SET saldo_pendiente = monto_total - 
        (SELECT COALESCE(SUM(monto_aplicado), 0) FROM factura_pagos WHERE factura_id = NEW.factura_id)
    WHERE id = NEW.factura_id;
END$$

-- 15. Log de pagos anulados
CREATE TRIGGER trg_log_pago_anulado
AFTER UPDATE ON pagos
FOR EACH ROW
BEGIN
    IF OLD.estado != 'Cancelado' AND NEW.estado = 'Cancelado' THEN
        INSERT INTO logs_auditoria (tabla_afectada, registro_id, accion, fecha_hora, detalles, usuario_db)
        VALUES ('pagos', NEW.id, 'ANULADO', NOW(), CONCAT('Monto: ', NEW.monto), CURRENT_USER());
    END IF;
END$$

-- 16. Registrar asistencia al validar acceso
CREATE TRIGGER trg_acceso_registra_asistencia
AFTER INSERT ON accesos
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Permitido' THEN
        INSERT INTO logs_auditoria (tabla_afectada, registro_id, accion, fecha_hora, detalles, usuario_db)
        VALUES ('accesos', NEW.id, 'ENTRADA', NOW(), 'Usuario ingresó', CURRENT_USER());
    END IF;
END$$

-- 17. Bloquear acceso sin membresía activa
CREATE TRIGGER trg_bloquear_acceso_sin_membresia
BEFORE INSERT ON accesos
FOR EACH ROW
BEGIN
    DECLARE v_membresia_activa INT;
    SELECT COUNT(*) INTO v_membresia_activa FROM membresias 
    WHERE usuario_id = NEW.usuario_id AND estado = 'Activa' AND fecha_vencimiento >= NEW.fecha_hora_entrada;
    IF v_membresia_activa = 0 THEN
        SET NEW.estado = 'Rechazado';
        SET NEW.motivo_rechazo = 'Membresía inactiva o vencida';
    END IF;
END$$

-- 18. Actualizar última fecha de acceso
CREATE TRIGGER trg_actualizar_ultimo_acceso
AFTER INSERT ON accesos
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Permitido' THEN
        UPDATE usuarios SET fecha_registro = NOW() WHERE id = NEW.usuario_id;
    END IF;
END$$

-- 19. Registrar salida automática
CREATE TRIGGER trg_registrar_salida_automatica
BEFORE INSERT ON accesos
FOR EACH ROW
BEGIN
    UPDATE accesos SET fecha_hora_salida = NEW.fecha_hora_entrada 
    WHERE usuario_id = NEW.usuario_id AND fecha_hora_salida IS NULL AND fecha_hora_entrada < NEW.fecha_hora_entrada
    ORDER BY fecha_hora_entrada DESC LIMIT 1;
END$$

-- 20. Log de accesos rechazados
CREATE TRIGGER trg_log_acceso_rechazado
AFTER INSERT ON accesos
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Rechazado' THEN
        INSERT INTO logs_auditoria (tabla_afectada, registro_id, accion, fecha_hora, detalles, usuario_db)
        VALUES ('accesos', NEW.id, 'RECHAZADO', NOW(), CONCAT('Motivo: ', NEW.motivo_rechazo), CURRENT_USER());
    END IF;
END$$

DELIMITER ;