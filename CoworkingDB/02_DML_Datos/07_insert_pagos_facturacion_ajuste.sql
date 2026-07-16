-- ==========================================
-- AJUSTE DE DATOS: PAGOS Y FACTURACIÓN
-- Archivo: 02_DML_Datos/07_insert_pagos_facturacion_ajuste.sql
-- ==========================================
SET @HOY = CURDATE();

-- 1. Usuario 15 sin pagos PayPal (para Consulta #49)
INSERT INTO pagos (usuario_id, monto, metodo_pago, fecha_pago, estado) VALUES
(15, 200.00, 'Tarjeta', DATE_SUB(@HOY, INTERVAL 10 DAY), 'Pagado'),
(15, 150.00, 'Efectivo', DATE_SUB(@HOY, INTERVAL 5 DAY), 'Pagado');

-- 2. Factura corporativa > $1000 (para Consulta #52)
INSERT INTO facturas (usuario_id, monto_total, saldo_pendiente, fecha_emision, fecha_vencimiento, estado) VALUES
(21, 1200.00, 0.00, DATE_SUB(@HOY, INTERVAL 5 DAY), DATE_ADD(@HOY, INTERVAL 25 DAY), 'Pagada');

INSERT INTO factura_detalle (factura_id, concepto, monto) VALUES
((SELECT MAX(id) FROM facturas), 'Membresía Corporativa Anual', 1200.00);

-- 3. Factura pendiente > $200 (para Consulta #56)
UPDATE facturas SET monto_total = 250.00, saldo_pendiente = 250.00 
WHERE usuario_id = 8 AND estado = 'Pendiente';

-- 4. Usuario que paga mismo servicio más de una vez (para Consulta #57)
INSERT INTO factura_detalle (factura_id, concepto, monto) VALUES
(1, 'Membresía Mensual', 200.00);

-- 5. Pago tardío (para Consulta #53)
INSERT INTO pagos (usuario_id, monto, metodo_pago, fecha_pago, estado) VALUES
(6, 200.00, 'Transferencia', DATE_SUB(@HOY, INTERVAL 5 DAY), 'Pagado');

-- 6. Facturación corporativa Tech Solutions (para Consulta #59)
INSERT INTO facturas (usuario_id, monto_total, saldo_pendiente, fecha_emision, fecha_vencimiento, estado) VALUES
(22, 300.00, 0.00, DATE_SUB(@HOY, INTERVAL 3 DAY), DATE_ADD(@HOY, INTERVAL 27 DAY), 'Pagada');

INSERT INTO factura_detalle (factura_id, concepto, monto) VALUES
((SELECT MAX(id) FROM facturas), 'Servicios Adicionales', 300.00);

-- 7. Factura de reserva pagada (para consultas de reservas facturadas)
INSERT INTO facturas (usuario_id, monto_total, saldo_pendiente, fecha_emision, fecha_vencimiento, estado) VALUES
(2, 75.00, 0.00, DATE_SUB(@HOY, INTERVAL 3 DAY), DATE_ADD(@HOY, INTERVAL 27 DAY), 'Pagada');

INSERT INTO factura_detalle (factura_id, concepto, monto) VALUES
((SELECT MAX(id) FROM facturas), 'Reserva Sala Reuniones Beta', 75.00);

INSERT INTO pagos (usuario_id, monto, metodo_pago, fecha_pago, estado) VALUES
(2, 75.00, 'Tarjeta', DATE_SUB(@HOY, INTERVAL 3 DAY), 'Pagado');

INSERT INTO factura_pagos (factura_id, pago_id, monto_aplicado, fecha_aplicacion) VALUES
((SELECT MAX(id) FROM facturas), (SELECT MAX(id) FROM pagos), 75.00, DATE_SUB(@HOY, INTERVAL 3 DAY));

-- Verificación
SELECT 'Pagos Totales' as Tabla, COUNT(*) FROM pagos
UNION ALL SELECT 'Facturas Totales', COUNT(*) FROM facturas
UNION ALL SELECT 'Detalle Facturas', COUNT(*) FROM factura_detalle;