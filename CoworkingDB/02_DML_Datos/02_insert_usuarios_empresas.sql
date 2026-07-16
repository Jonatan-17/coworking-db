-- ==========================================
-- USUARIOS INDIVIDUALES Y CORPORATIVOS
-- ==========================================
SET @HOY = CURDATE();

INSERT INTO usuarios (nombre, apellidos, fecha_nacimiento, email, telefono, empresa_id) VALUES
-- Individuales
('Carlos', 'Perez', '1990-05-15', 'carlos.p@email.com', '3001234567', NULL),
('Ana', 'Gomez', '1995-08-20', 'ana.gomez@email.com', '3109876543', NULL),
('Luis', 'Rodriguez', '1988-12-01', 'luis.r@email.com', '3205554433', NULL),
('Maria', 'Lopez', '1992-03-10', 'maria.lopez@email.com', '3156667788', NULL),
('Jorge', 'Martinez', '1998-07-25', 'jorge.m@email.com', '3008889900', NULL),
('Sofia', 'Hernandez', '1993-11-30', 'sofia.h@email.com', '3101112222', NULL),
('Diego', 'Ramirez', '1985-02-14', 'diego.ramirez@email.com', '3203334444', NULL),
('Laura', 'Torres', '1996-09-05', 'laura.torres@email.com', '3155556666', NULL),
('Andres', 'Diaz', '1991-04-18', 'andres.diaz@email.com', '3007778888', NULL),
('Camila', 'Muñoz', '1994-06-22', 'camila.munoz@email.com', '3109990000', NULL),
('Felipe', 'Castro', '1989-01-08', 'felipe.castro@email.com', '3201113333', NULL),
('Valentina', 'Ortiz', '1997-10-12', 'valentina.ortiz@email.com', '3152224444', NULL),
('Sebastian', 'Rojas', '1990-08-30', 'sebastian.rojas@email.com', '3004445555', NULL),
('Daniela', 'Vargas', '1993-05-17', 'daniela.vargas@email.com', '3106667777', NULL),
('Mateo', 'Silva', '1987-12-25', 'mateo.silva@email.com', '3208889999', NULL),
('Isabella', 'Reyes', '1995-03-03', 'isabella.reyes@email.com', '3150001111', NULL),
('Nicolas', 'Florez', '1992-07-19', 'nicolas.florez@email.com', '3002223333', NULL),
('Gabriela', 'Mendez', '1998-11-08', 'gabriela.mendez@email.com', '3104445555', NULL),
('Juan', 'Acosta', '1986-04-14', 'juan.acosta@email.com', '3206667777', NULL),
('Paula', 'Navarro', '1994-09-21', 'paula.navarro@email.com', '3158889999', NULL),
-- Corporativos Tech Solutions
('Empleado', 'Tech1', '1990-01-01', 'emp1@techsolutions.com', '3001001001', 1),
('Empleado', 'Tech2', '1991-02-02', 'emp2@techsolutions.com', '3001001002', 1),
('Empleado', 'Tech3', '1992-03-03', 'emp3@techsolutions.com', '3001001003', 1),
-- Corporativos Marketing Pro
('Empleado', 'Mkt1', '1993-04-04', 'emp1@marketingpro.com', '3102002001', 2),
('Empleado', 'Mkt2', '1994-05-05', 'emp2@marketingpro.com', '3102002002', 2),
-- Corporativos Consultores
('Empleado', 'Con1', '1995-06-06', 'emp1@consultores.com', '3203003001', 3),
('Empleado', 'Con2', '1996-07-07', 'emp2@consultores.com', '3203003002', 3),
('Empleado', 'Con3', '1997-08-08', 'emp3@consultores.com', '3203003003', 3),
-- Corporativos Startup
('Empleado', 'Start1', '1998-09-09', 'emp1@startupinnova.com', '3154004001', 4),
('Empleado', 'Start2', '1999-10-10', 'emp2@startupinnova.com', '3154004002', 4);