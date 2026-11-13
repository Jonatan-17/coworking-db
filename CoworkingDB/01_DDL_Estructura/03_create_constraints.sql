-- ==========================================
-- LLAVES FORÁNEAS (INTEGRIDAD REFERENCIAL)
-- ==========================================

ALTER TABLE usuarios ADD CONSTRAINT fk_usuarios_empresa 
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE SET NULL;

ALTER TABLE membresias ADD CONSTRAINT fk_membresias_usuario 
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id);
ALTER TABLE membresias ADD CONSTRAINT fk_membresias_tipo 
    FOREIGN KEY (tipo_membresia_id) REFERENCES tipos_membresia(id);

ALTER TABLE reservas ADD CONSTRAINT fk_reservas_usuario 
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id);
ALTER TABLE reservas ADD CONSTRAINT fk_reservas_espacio 
    FOREIGN KEY (espacio_id) REFERENCES espacios(id);

ALTER TABLE pagos ADD CONSTRAINT fk_pagos_usuario 
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id);

ALTER TABLE facturas ADD CONSTRAINT fk_facturas_usuario 
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id);

ALTER TABLE accesos ADD CONSTRAINT fk_accesos_usuario 
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id);

ALTER TABLE historial_membresias ADD CONSTRAINT fk_hist_memb_usuario 
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id);

ALTER TABLE reserva_servicios ADD CONSTRAINT fk_rs_reserva 
    FOREIGN KEY (reserva_id) REFERENCES reservas(id);
ALTER TABLE reserva_servicios ADD CONSTRAINT fk_rs_servicio 
    FOREIGN KEY (servicio_id) REFERENCES servicios_adicionales(id);

ALTER TABLE factura_detalle ADD CONSTRAINT fk_fd_factura 
    FOREIGN KEY (factura_id) REFERENCES facturas(id);

ALTER TABLE factura_pagos ADD CONSTRAINT fk_fp_factura 
    FOREIGN KEY (factura_id) REFERENCES facturas(id);
ALTER TABLE factura_pagos ADD CONSTRAINT fk_fp_pago 
    FOREIGN KEY (pago_id) REFERENCES pagos(id);