-- ==========================================
-- ÍNDICES PARA OPTIMIZACIÓN DE CONSULTAS
-- ==========================================

-- Búsquedas frecuentes por usuario
CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_usuarios_empresa ON usuarios(empresa_id);

-- Consultas de estado y vencimiento
CREATE INDEX idx_membresias_estado_venc ON membresias(estado, fecha_vencimiento);
CREATE INDEX idx_membresias_usuario ON membresias(usuario_id);

-- Validación de solapamiento y disponibilidad
CREATE INDEX idx_reservas_espacio_fechas ON reservas(espacio_id, fecha_inicio, fecha_fin);
CREATE INDEX idx_reservas_estado ON reservas(estado);

-- Reportes financieros
CREATE INDEX idx_pagos_fecha_estado ON pagos(fecha_pago, estado);
CREATE INDEX idx_facturas_vencimiento ON facturas(fecha_vencimiento, estado);

-- Auditoría y accesos
CREATE INDEX idx_accesos_fecha ON accesos(fecha_hora_entrada);
CREATE INDEX idx_logs_fecha ON logs_auditoria(fecha_hora);