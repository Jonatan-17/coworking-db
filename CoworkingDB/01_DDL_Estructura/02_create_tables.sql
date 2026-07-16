-- ==========================================
-- TABLAS PRINCIPALES (CATÁLOGOS)
-- ==========================================

-- Empresas corporativas
CREATE TABLE empresas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nit VARCHAR(20) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100)
);

-- Tipos de membresía disponibles
CREATE TABLE tipos_membresia (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    duracion_dias INT NOT NULL
);

-- Espacios físicos del coworking
CREATE TABLE espacios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tipo ENUM('Escritorio flexible', 'Oficina privada', 'Sala de reuniones', 'Sala de eventos') NOT NULL,
    capacidad_maxima INT NOT NULL,
    precio_hora DECIMAL(10, 2) NOT NULL,
    horario_disponibilidad VARCHAR(100)
);

-- Servicios adicionales facturables
CREATE TABLE servicios_adicionales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL
);

-- ==========================================
-- TABLAS TRANSACCIONALES
-- ==========================================

-- Usuarios del sistema
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    empresa_id INT NULL
);

-- Membresías activas o históricas
CREATE TABLE membresias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    tipo_membresia_id INT NOT NULL,
    fecha_inicio DATETIME NOT NULL,
    fecha_vencimiento DATETIME NOT NULL,
    estado ENUM('Activa', 'Suspendida', 'Vencida') NOT NULL DEFAULT 'Activa'
);

-- Reservas de espacios
CREATE TABLE reservas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    espacio_id INT NOT NULL,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    estado ENUM('Pendiente', 'Confirmada', 'Cancelada', 'No Show') NOT NULL DEFAULT 'Pendiente',
    costo_total DECIMAL(10, 2) NOT NULL DEFAULT 0.00
);

-- Pagos realizados
CREATE TABLE pagos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    metodo_pago ENUM('Efectivo', 'Tarjeta', 'Transferencia', 'PayPal') NOT NULL,
    fecha_pago DATETIME NOT NULL,
    estado ENUM('Pagado', 'Pendiente', 'Cancelado') NOT NULL DEFAULT 'Pendiente'
);

-- Facturas emitidas
CREATE TABLE facturas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    monto_total DECIMAL(10, 2) NOT NULL,
    saldo_pendiente DECIMAL(10, 2) NOT NULL,
    fecha_emision DATETIME NOT NULL,
    fecha_vencimiento DATETIME NOT NULL,
    estado ENUM('Pagada', 'Pendiente', 'Parcial', 'Anulada') NOT NULL DEFAULT 'Pendiente',
    motivo_anulacion VARCHAR(255) NULL
);

-- Control de accesos (entradas/salidas)
CREATE TABLE accesos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    fecha_hora_entrada DATETIME NOT NULL,
    fecha_hora_salida DATETIME NULL,
    metodo_acceso ENUM('QR', 'RFID') NOT NULL,
    estado ENUM('Permitido', 'Rechazado') NOT NULL DEFAULT 'Permitido',
    motivo_rechazo VARCHAR(100) NULL
);

-- ==========================================
-- TABLAS INTERMEDIAS Y AUDITORÍA
-- ==========================================

-- Historial de cambios de membresía
CREATE TABLE historial_membresias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    membresia_anterior_id INT,
    membresia_nueva_id INT,
    fecha_cambio DATETIME NOT NULL
);

-- Servicios contratados por reserva
CREATE TABLE reserva_servicios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reserva_id INT NOT NULL,
    servicio_id INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    subtotal DECIMAL(10, 2) NOT NULL
);

-- Detalle de conceptos por factura
CREATE TABLE factura_detalle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    factura_id INT NOT NULL,
    concepto VARCHAR(100) NOT NULL,
    monto DECIMAL(10, 2) NOT NULL
);

-- Aplicación de pagos a facturas
CREATE TABLE factura_pagos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    factura_id INT NOT NULL,
    pago_id INT NOT NULL,
    monto_aplicado DECIMAL(10, 2) NOT NULL,
    fecha_aplicacion DATETIME NOT NULL
);

-- Log general de auditoría del sistema
CREATE TABLE logs_auditoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tabla_afectada VARCHAR(50) NOT NULL,
    registro_id INT NOT NULL,
    accion VARCHAR(50) NOT NULL,
    fecha_hora DATETIME NOT NULL,
    detalles TEXT NULL,
    usuario_db VARCHAR(50) NOT NULL
);