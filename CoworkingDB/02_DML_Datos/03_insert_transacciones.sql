-- ==========================================
-- MEMBRESÍAS, RESERVAS, PAGOS Y FACTURAS
-- ==========================================
SET @HOY = CURDATE();

-- Membresías (activas, vencidas, suspendidas)
INSERT INTO membresias (usuario_id, tipo_membresia_id, fecha_inicio, fecha_vencimiento, estado) VALUES
(1, 2, @HOY - INTERVAL 10 DAY, @HOY + INTERVAL 20 DAY, 'Activa'),
(2, 4, @HOY - INTERVAL 5 DAY, @HOY + INTERVAL 25 DAY, 'Activa'),
(3, 1, @HOY, @HOY + INTERVAL 1 DAY, 'Activa'),
(4, 2, @HOY - INTERVAL 15 DAY, @HOY + INTERVAL 15 DAY, 'Activa'),
(5, 3, @HOY - INTERVAL 20 DAY, @HOY + INTERVAL 10 DAY, 'Activa'),
(6, 2, @HOY - INTERVAL 40 DAY, @HOY - INTERVAL 10 DAY, 'Vencida'),
(7, 1, @HOY - INTERVAL 5 DAY, @HOY - INTERVAL 4 DAY, 'Vencida'),
(8, 3, @HOY - INTERVAL 30 DAY, @HOY, 'Suspendida'),
(9, 2, @HOY - INTERVAL 25 DAY, @HOY - INTERVAL 5 DAY, 'Suspendida'),
(21, 3, @HOY - INTERVAL 10 DAY, @HOY + INTERVAL 20 DAY, 'Activa'),
(22, 3, @HOY - INTERVAL 10 DAY, @HOY + INTERVAL 20 DAY, 'Activa'),
(23, 3, @HOY - INTERVAL 10 DAY, @HOY + INTERVAL 20 DAY, 'Activa'),
(24, 3, @HOY - INTERVAL 10 DAY, @HOY + INTERVAL 20 DAY, 'Activa'),
(25, 3, @HOY - INTERVAL 10 DAY, @HOY + INTERVAL 20 DAY, 'Activa'),
(26, 3, @HOY - INTERVAL 10 DAY, @HOY + INTERVAL 20 DAY, 'Activa'),
(27, 3, @HOY - INTERVAL 10 DAY, @HOY + INTERVAL 20 DAY, 'Activa'),
(28, 3, @HOY - INTERVAL 10 DAY, @HOY + INTERVAL 20 DAY, 'Activa'),
(29, 3, @HOY - INTERVAL 10 DAY, @HOY + INTERVAL 20 DAY, 'Activa'),
(30, 3, @HOY - INTERVAL 10 DAY, @HOY + INTERVAL 20 DAY, 'Activa');

-- Reservas de espacios
INSERT INTO reservas (usuario_id, espacio_id, fecha_inicio, fecha_fin, estado, costo_total) VALUES
(1, 4, CONCAT(@HOY, ' 09:00:00'), CONCAT(@HOY, ' 11:00:00'), 'Confirmada', 50.00),
(2, 3, CONCAT(@HOY, ' 10:00:00'), CONCAT(@HOY, ' 12:00:00'), 'Confirmada', 30.00),
(3, 1, @HOY + INTERVAL 2 DAY, @HOY + INTERVAL 2 DAY + INTERVAL 4 HOUR, 'Pendiente', 20.00),
(4, 5, @HOY + INTERVAL 3 DAY, @HOY + INTERVAL 3 DAY + INTERVAL 3 HOUR, 'Pendiente', 60.00),
(5, 6, @HOY - INTERVAL 5 DAY, @HOY - INTERVAL 5 DAY + INTERVAL 5 HOUR, 'Cancelada', 0.00),
(6, 4, @HOY - INTERVAL 2 DAY, @HOY - INTERVAL 2 DAY + INTERVAL 2 HOUR, 'No Show', 50.00),
(7, 2, @HOY - INTERVAL 10 DAY, @HOY - INTERVAL 10 DAY + INTERVAL 6 HOUR, 'Confirmada', 30.00),
(8, 1, @HOY - INTERVAL 15 DAY, @HOY - INTERVAL 15 DAY + INTERVAL 8 HOUR, 'Confirmada', 40.00),
(9, 4, CONCAT(@HOY, ' 09:30:00'), CONCAT(@HOY, ' 11:30:00'), 'Pendiente', 50.00),
(21, 3, CONCAT(@HOY, ' 14:00:00'), CONCAT(@HOY, ' 16:00:00'), 'Confirmada', 30.00),
(24, 5, @HOY + INTERVAL 1 DAY, @HOY + INTERVAL 1 DAY + INTERVAL 4 HOUR, 'Confirmada', 80.00);

-- Pagos realizados
INSERT INTO pagos (usuario_id, monto, metodo_pago, fecha_pago, estado) VALUES
(1, 200.00, 'Tarjeta', @HOY - INTERVAL 10 DAY, 'Pagado'),
(2, 350.00, 'PayPal', @HOY - INTERVAL 5 DAY, 'Pagado'),
(3, 15.00, 'Efectivo', @HOY, 'Pagado'),
(4, 200.00, 'Transferencia', @HOY - INTERVAL 15 DAY, 'Pagado'),
(5, 150.00, 'Tarjeta', @HOY - INTERVAL 20 DAY, 'Pagado'),
(6, 200.00, 'Tarjeta', @HOY - INTERVAL 40 DAY, 'Pagado'),
(7, 15.00, 'Efectivo', @HOY - INTERVAL 5 DAY, 'Pagado'),
(8, 150.00, 'Transferencia', @HOY - INTERVAL 30 DAY, 'Pagado'),
(9, 200.00, 'Tarjeta', @HOY - INTERVAL 25 DAY, 'Pagado'),
(10, 50.00, 'PayPal', @HOY - INTERVAL 2 DAY, 'Pendiente');

-- Facturas emitidas
INSERT INTO facturas (usuario_id, monto_total, saldo_pendiente, fecha_emision, fecha_vencimiento, estado) VALUES
(1, 200.00, 0.00, @HOY - INTERVAL 10 DAY, @HOY + INTERVAL 20 DAY, 'Pagada'),
(2, 350.00, 0.00, @HOY - INTERVAL 5 DAY, @HOY + INTERVAL 25 DAY, 'Pagada'),
(3, 15.00, 0.00, @HOY, @HOY + INTERVAL 1 DAY, 'Pagada'),
(4, 200.00, 0.00, @HOY - INTERVAL 15 DAY, @HOY + INTERVAL 15 DAY, 'Pagada'),
(5, 150.00, 0.00, @HOY - INTERVAL 20 DAY, @HOY + INTERVAL 10 DAY, 'Pagada'),
(6, 200.00, 200.00, @HOY - INTERVAL 40 DAY, @HOY - INTERVAL 10 DAY, 'Pendiente'),
(7, 15.00, 0.00, @HOY - INTERVAL 5 DAY, @HOY - INTERVAL 4 DAY, 'Pagada'),
(8, 150.00, 150.00, @HOY - INTERVAL 30 DAY, @HOY, 'Pendiente'),
(9, 200.00, 0.00, @HOY - INTERVAL 25 DAY, @HOY - INTERVAL 5 DAY, 'Pagada'),
(10, 50.00, 50.00, @HOY - INTERVAL 2 DAY, @HOY + INTERVAL 28 DAY, 'Pendiente');

-- Accesos al coworking
INSERT INTO accesos (usuario_id, fecha_hora_entrada, fecha_hora_salida, metodo_acceso, estado, motivo_rechazo) VALUES
(1, CONCAT(@HOY, ' 08:30:00'), CONCAT(@HOY, ' 18:00:00'), 'QR', 'Permitido', NULL),
(2, CONCAT(@HOY, ' 09:00:00'), CONCAT(@HOY, ' 17:30:00'), 'RFID', 'Permitido', NULL),
(3, CONCAT(@HOY, ' 10:00:00'), NULL, 'QR', 'Permitido', NULL),
(6, CONCAT(@HOY, ' 08:00:00'), CONCAT(@HOY, ' 08:01:00'), 'QR', 'Rechazado', 'Membresía Vencida'),
(7, CONCAT(@HOY, ' 09:00:00'), CONCAT(@HOY, ' 09:01:00'), 'RFID', 'Rechazado', 'Membresía Vencida'),
(8, CONCAT(@HOY, ' 11:00:00'), CONCAT(@HOY, ' 11:01:00'), 'QR', 'Rechazado', 'Membresía Suspendida'),
(21, CONCAT(@HOY, ' 08:00:00'), CONCAT(@HOY, ' 17:00:00'), 'RFID', 'Permitido', NULL),
(24, CONCAT(@HOY, ' 09:30:00'), CONCAT(@HOY, ' 18:30:00'), 'QR', 'Permitido', NULL),
(1, @HOY - INTERVAL 1 DAY, @HOY - INTERVAL 1 DAY + INTERVAL 9 HOUR, 'QR', 'Permitido', NULL),
(2, @HOY - INTERVAL 1 DAY, @HOY - INTERVAL 1 DAY + INTERVAL 8 HOUR, 'RFID', 'Permitido', NULL),
(3, @HOY - INTERVAL 2 DAY, @HOY - INTERVAL 2 DAY + INTERVAL 7 HOUR, 'QR', 'Permitido', NULL),
(4, @HOY - INTERVAL 3 DAY, @HOY - INTERVAL 3 DAY + INTERVAL 6 HOUR, 'RFID', 'Permitido', NULL),
(5, @HOY - INTERVAL 4 DAY, @HOY - INTERVAL 4 DAY + INTERVAL 5 HOUR, 'QR', 'Permitido', NULL);

-- Servicios adicionales en reservas
INSERT INTO reserva_servicios (reserva_id, servicio_id, cantidad, subtotal) VALUES
(1, 1, 1, 10.00), (1, 5, 1, 15.00),
(2, 3, 2, 10.00),
(10, 1, 1, 10.00),
(11, 5, 1, 15.00);

-- Detalle de facturas
INSERT INTO factura_detalle (factura_id, concepto, monto) VALUES
(1, 'Membresía Mensual', 200.00), (2, 'Membresía Premium', 350.00),
(3, 'Membresía Diaria', 15.00), (4, 'Membresía Mensual', 200.00),
(5, 'Membresía Corporativa', 150.00), (6, 'Membresía Mensual', 200.00),
(7, 'Membresía Diaria', 15.00), (8, 'Membresía Corporativa', 150.00),
(9, 'Membresía Mensual', 200.00), (10, 'Reserva Sala Reuniones', 50.00);

-- Aplicación de pagos a facturas
INSERT INTO factura_pagos (factura_id, pago_id, monto_aplicado, fecha_aplicacion) VALUES
(1, 1, 200.00, @HOY - INTERVAL 10 DAY),
(2, 2, 350.00, @HOY - INTERVAL 5 DAY),
(3, 3, 15.00, @HOY),
(4, 4, 200.00, @HOY - INTERVAL 15 DAY),
(5, 5, 150.00, @HOY - INTERVAL 20 DAY),
(7, 7, 15.00, @HOY - INTERVAL 5 DAY),
(9, 9, 200.00, @HOY - INTERVAL 25 DAY);