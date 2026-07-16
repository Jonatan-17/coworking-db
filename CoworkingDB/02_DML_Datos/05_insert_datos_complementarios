-- ==========================================
-- DATOS COMPLEMENTARIOS PARA CONSULTAS AVANZADAS
-- Archivo: 02_DML_Datos/05_insert_datos_complementarios.sql
-- ==========================================
SET @HOY = CURDATE();

-- 1. Usuarios adicionales (perfiles específicos para pruebas)
INSERT IGNORE INTO usuarios (id, nombre, apellidos, fecha_nacimiento, email, telefono, empresa_id, fecha_registro) VALUES
(100, 'Usuario', 'Frecuente', '1990-01-01', 'frecuente@test.com', '3001001000', NULL, DATE_SUB(@HOY, INTERVAL 100 DAY)),
(101, 'Usuario', 'FinSemana', '1991-02-02', 'finsemana@test.com', '3001001001', NULL, DATE_SUB(@HOY, INTERVAL 90 DAY)),
(102, 'Usuario', 'Mañanero', '1992-03-03', 'manana@test.com', '3001001002', NULL, DATE_SUB(@HOY, INTERVAL 80 DAY)),
(103, 'Usuario', 'Nocturno', '1993-04-04', 'noche@test.com', '3001001003', NULL, DATE_SUB(@HOY, INTERVAL 70 DAY)),
(104, 'Usuario', 'SinReservas', '1994-05-05', 'sinreservas@test.com', '3001001004', NULL, DATE_SUB(@HOY, INTERVAL 60 DAY)),
(105, 'Usuario', 'PagaNoAsiste', '1995-06-06', 'paganosiste@test.com', '3001001005', NULL, DATE_SUB(@HOY, INTERVAL 50 DAY)),
(106, 'Usuario', 'QRInvalido', '1996-07-07', 'qrinvalido@test.com', '3001001006', NULL, DATE_SUB(@HOY, INTERVAL 40 DAY)),
(107, 'Usuario', 'FueraHorario', '1997-08-08', 'fuerahorario@test.com', '3001001007', NULL, DATE_SUB(@HOY, INTERVAL 30 DAY)),
(108, 'Usuario', 'CambiaMembresia', '1998-09-09', 'cambia@test.com', '3001001008', NULL, DATE_SUB(@HOY, INTERVAL 200 DAY)),
(109, 'Usuario', 'RenovacionDiaria', '1999-10-10', 'renovacion@test.com', '3001001009', NULL, DATE_SUB(@HOY, INTERVAL 150 DAY)),
(110, 'Usuario', 'MuchasReservas', '1990-11-11', 'muchas@test.com', '3001001010', NULL, DATE_SUB(@HOY, INTERVAL 120 DAY)),
(111, 'Usuario', 'SoloEfectivo', '1991-12-12', 'efectivo@test.com', '3001001011', NULL, DATE_SUB(@HOY, INTERVAL 110 DAY)),
(112, 'Usuario', 'FacturaAlta', '1992-01-13', 'facturaalta@test.com', '3001001012', NULL, DATE_SUB(@HOY, INTERVAL 100 DAY)),
(113, 'Usuario', 'MismoServicio', '1993-02-14', 'mismo@test.com', '3001001013', NULL, DATE_SUB(@HOY, INTERVAL 90 DAY));

-- 2. Empresas adicionales y sus empleados
INSERT IGNORE INTO empresas (id, nombre, nit, telefono, email) VALUES
(6, 'Corporativo Grande SA', '900111222', '3001112222', 'info@corpgrande.com'),
(7, 'Startup Masiva LTDA', '900222333', '3102223333', 'hola@startupmasiva.com');

INSERT IGNORE INTO usuarios (id, nombre, apellidos, email, telefono, empresa_id, fecha_registro)
SELECT 200 + n, CONCAT('Empleado', n), 'Corp', CONCAT('emp', n, '@corpgrande.com'), CONCAT('300', LPAD(200+n, 7, '0')), 6, DATE_SUB(@HOY, INTERVAL n*5 DAY)
FROM (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11) AS nums;

-- 3. Membresías adicionales (historial y renovaciones)
INSERT IGNORE INTO historial_membresias (usuario_id, membresia_anterior_id, membresia_nueva_id, fecha_cambio) VALUES
(108, NULL, 1, DATE_SUB(@HOY, INTERVAL 180 DAY)), (108, 1, 2, DATE_SUB(@HOY, INTERVAL 120 DAY)),
(108, 2, 4, DATE_SUB(@HOY, INTERVAL 60 DAY)), (108, 4, 3, DATE_SUB(@HOY, INTERVAL 30 DAY));

INSERT IGNORE INTO membresias (usuario_id, tipo_membresia_id, fecha_inicio, fecha_vencimiento, estado)
SELECT 109, 1, DATE_SUB(@HOY, INTERVAL n DAY), DATE_SUB(@HOY, INTERVAL (n-1) DAY), 'Vencida'
FROM (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15) AS nums;

INSERT IGNORE INTO membresias (usuario_id, tipo_membresia_id, fecha_inicio, fecha_vencimiento, estado) VALUES
(105, 2, DATE_SUB(@HOY, INTERVAL 10 DAY), DATE_ADD(@HOY, INTERVAL 20 DAY), 'Activa');

-- 4. Reservas adicionales (volumen y casos especiales)
INSERT IGNORE INTO reservas (id, usuario_id, espacio_id, fecha_inicio, fecha_fin, estado, costo_total)
SELECT 100 + n, 110, FLOOR(1 + (n % 6)), DATE_SUB(@HOY, INTERVAL n DAY), DATE_SUB(@HOY, INTERVAL n DAY) + INTERVAL 2 HOUR, 'Confirmada', 25.00
FROM (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20 UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24 UNION ALL SELECT 25) AS nums;

INSERT IGNORE INTO reservas (usuario_id, espacio_id, fecha_inicio, fecha_fin, estado, costo_total) VALUES
(110, 1, CONCAT(@HOY, ' 09:00:00'), CONCAT(@HOY, ' 11:00:00'), 'Confirmada', 100.00);

-- 5. Accesos adicionales (patrones de asistencia)
INSERT IGNORE INTO accesos (usuario_id, fecha_hora_entrada, fecha_hora_salida, metodo_acceso, estado)
SELECT 100, DATE_SUB(@HOY, INTERVAL n DAY), DATE_SUB(@HOY, INTERVAL n DAY) + INTERVAL 8 HOUR, 'QR', 'Permitido'
FROM (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20 UNION ALL SELECT 21 UNION ALL SELECT 22) AS nums;

INSERT IGNORE INTO accesos (usuario_id, fecha_hora_entrada, fecha_hora_salida, metodo_acceso, estado)
SELECT 101, CASE WHEN MOD(n, 2) = 0 THEN DATE_SUB(@HOY, INTERVAL (n*7) DAY) - INTERVAL 1 DAY ELSE DATE_SUB(@HOY, INTERVAL (n*7) DAY) + INTERVAL 1 DAY END, CASE WHEN MOD(n, 2) = 0 THEN DATE_SUB(@HOY, INTERVAL (n*7) DAY) - INTERVAL 1 DAY + INTERVAL 4 HOUR ELSE DATE_SUB(@HOY, INTERVAL (n*7) DAY) + INTERVAL 1 DAY + INTERVAL 4 HOUR END, 'QR', 'Permitido'
FROM (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) nums;

INSERT IGNORE INTO accesos (usuario_id, fecha_hora_entrada, fecha_hora_salida, metodo_acceso, estado)
SELECT 102, CONCAT(DATE_SUB(@HOY, INTERVAL n DAY), ' 08:00:00'), CONCAT(DATE_SUB(@HOY, INTERVAL n DAY), ' 12:00:00'), 'QR', 'Permitido'
FROM (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) nums;

INSERT IGNORE INTO accesos (usuario_id, fecha_hora_entrada, fecha_hora_salida, metodo_acceso, estado)
SELECT 103, CONCAT(DATE_SUB(@HOY, INTERVAL n DAY), ' 16:00:00'), CONCAT(DATE_SUB(@HOY, INTERVAL n DAY), ' 20:00:00'), 'RFID', 'Permitido'
FROM (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) nums;

INSERT IGNORE INTO accesos (usuario_id, fecha_hora_entrada, fecha_hora_salida, metodo_acceso, estado) VALUES
(104, DATE_SUB(@HOY, INTERVAL 5 DAY), DATE_SUB(@HOY, INTERVAL 5 DAY) + INTERVAL 6 HOUR, 'RFID', 'Permitido'),
(104, DATE_SUB(@HOY, INTERVAL 3 DAY), DATE_SUB(@HOY, INTERVAL 3 DAY) + INTERVAL 5 HOUR, 'QR', 'Permitido'),
(100, CONCAT(@HOY, ' 09:00:00'), NULL, 'QR', 'Permitido'),
(102, CONCAT(@HOY, ' 10:00:00'), NULL, 'RFID', 'Permitido'),
(100, CONCAT(@HOY, ' 08:00:00'), CONCAT(@HOY, ' 10:00:00'), 'QR', 'Permitido'),
(100, CONCAT(@HOY, ' 12:00:00'), CONCAT(@HOY, ' 14:00:00'), 'QR', 'Permitido'),
(100, CONCAT(@HOY, ' 16:00:00'), CONCAT(@HOY, ' 18:00:00'), 'QR', 'Permitido');

INSERT IGNORE INTO accesos (usuario_id, fecha_hora_entrada, fecha_hora_salida, metodo_acceso, estado, motivo_rechazo) VALUES
(107, CONCAT(@HOY, ' 07:30:00'), CONCAT(@HOY, ' 07:35:00'), 'QR', 'Rechazado', 'Fuera de horario'),
(107, CONCAT(@HOY, ' 20:30:00'), CONCAT(@HOY, ' 20:35:00'), 'RFID', 'Rechazado', 'Fuera de horario'),
(106, CONCAT(@HOY, ' 09:00:00'), CONCAT(@HOY, ' 09:01:00'), 'QR', 'Rechazado', 'Membresía Vencida'),
(106, CONCAT(@HOY, ' 08:00:00'), CONCAT(@HOY, ' 08:00:01'), 'QR', 'Rechazado', 'QR Inválido'),
(106, CONCAT(@HOY, ' 09:00:00'), CONCAT(@HOY, ' 09:00:01'), 'QR', 'Rechazado', 'QR Inválido');

-- 6. Pagos y Facturas adicionales (casos de borde)
INSERT IGNORE INTO pagos (id, usuario_id, monto, metodo_pago, fecha_pago, estado) VALUES
(100, 111, 200.00, 'Efectivo', DATE_SUB(@HOY, INTERVAL 10 DAY), 'Pagado'),
(101, 111, 150.00, 'Tarjeta', DATE_SUB(@HOY, INTERVAL 5 DAY), 'Pagado'),
(102, 105, 200.00, 'Transferencia', DATE_SUB(@HOY, INTERVAL 5 DAY), 'Pagado'),
(100, 100, 500.00, 'Tarjeta', DATE_SUB(@HOY, INTERVAL 3 DAY), 'Pagado'),
(112, 112, 800.00, 'PayPal', DATE_SUB(@HOY, INTERVAL 2 DAY), 'Pagado'),
(103, 100, 100.00, 'Tarjeta', DATE_SUB(@HOY, INTERVAL 20 DAY), 'Cancelado');

INSERT IGNORE INTO facturas (id, usuario_id, monto_total, saldo_pendiente, fecha_emision, fecha_vencimiento, estado, motivo_anulacion) VALUES
(100, 112, 1500.00, 0.00, DATE_SUB(@HOY, INTERVAL 5 DAY), DATE_ADD(@HOY, INTERVAL 25 DAY), 'Pagada', NULL),
(101, 113, 300.00, 0.00, DATE_SUB(@HOY, INTERVAL 10 DAY), DATE_ADD(@HOY, INTERVAL 20 DAY), 'Anulada', 'Error en facturación'),
(102, 105, 350.00, 350.00, DATE_SUB(@HOY, INTERVAL 15 DAY), DATE_SUB(@HOY, INTERVAL 5 DAY), 'Pendiente', NULL);

INSERT IGNORE INTO factura_detalle (factura_id, concepto, monto) VALUES
(100, 'Membresía Corporativa Anual', 1500.00),
(101, 'Reserva Cancelada', 300.00),
(102, 'Membresía Premium', 350.00),
(1, 'Membresía Mensual', 200.00),
(100, 'Membresía Mensual', 200.00);

INSERT IGNORE INTO facturas (usuario_id, monto_total, saldo_pendiente, fecha_emision, fecha_vencimiento, estado)
SELECT u.id, 500.00, 0.00, DATE_SUB(@HOY, INTERVAL 3 DAY), DATE_ADD(@HOY, INTERVAL 27 DAY), 'Pagada'
FROM usuarios u WHERE u.empresa_id = 6 LIMIT 5;

INSERT IGNORE INTO factura_pagos (factura_id, pago_id, monto_aplicado, fecha_aplicacion) VALUES
(100, 102, 1500.00, DATE_SUB(@HOY, INTERVAL 5 DAY)),
(102, 102, 0.00, DATE_SUB(@HOY, INTERVAL 5 DAY));

-- Verificación final de datos insertados
SELECT 'Usuarios Totales' as Tabla, COUNT(*) FROM usuarios
UNION ALL SELECT 'Accesos Totales', COUNT(*) FROM accesos
UNION ALL SELECT 'Reservas Totales', COUNT(*) FROM reservas
UNION ALL SELECT 'Pagos Totales', COUNT(*) FROM pagos
UNION ALL SELECT 'Facturas Totales', COUNT(*) FROM facturas;