-- ==========================================
-- DATOS BASE: CATÁLOGOS DEL SISTEMA
-- ==========================================

INSERT INTO tipos_membresia (nombre, precio, duracion_dias) VALUES
('Diaria', 15.00, 1), ('Mensual', 200.00, 30), 
('Corporativa', 150.00, 30), ('Premium', 350.00, 30);

INSERT INTO espacios (nombre, tipo, capacidad_maxima, precio_hora, horario_disponibilidad) VALUES
('Escritorio A1', 'Escritorio flexible', 1, 5.00, '08:00-20:00'),
('Escritorio A2', 'Escritorio flexible', 1, 5.00, '08:00-20:00'),
('Oficina Privada 1', 'Oficina privada', 4, 15.00, '08:00-20:00'),
('Sala Reuniones Alpha', 'Sala de reuniones', 10, 25.00, '08:00-20:00'),
('Sala Reuniones Beta', 'Sala de reuniones', 6, 20.00, '08:00-20:00'),
('Auditorio Principal', 'Sala de eventos', 50, 100.00, '08:00-22:00');

INSERT INTO servicios_adicionales (nombre, precio) VALUES
('Internet Premium', 10.00), ('Locker Personal', 20.00),
('Café Ilimitado', 5.00), ('Impresiones (paq 50 hojas)', 8.00),
('Uso de Proyector', 15.00);

INSERT INTO empresas (nombre, nit, telefono, email) VALUES
('Tech Solutions SAS', '900123456', '3001112233', 'contacto@techsolutions.com'),
('Marketing Digital Pro', '900654321', '3104445566', 'info@marketingpro.com'),
('Consultores Asociados', '900789012', '3207778899', 'admin@consultores.com'),
('Startup Innovadora', '900345678', '3152223344', 'hola@startupinnova.com'),
('Grupo Financiero Global', '900901234', '3009990011', 'rrhh@grupofinanciero.com');