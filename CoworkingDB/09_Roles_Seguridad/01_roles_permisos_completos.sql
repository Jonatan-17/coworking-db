-- ==========================================
-- FASE 9: ROLES Y SEGURIDAD (5 Roles)
-- Descripción: Control de acceso granular para diferentes perfiles de usuario.
-- Ejecutar COMPLETO con Alt + X o Ctrl + Enter
-- ==========================================

USE coworking_db;

-- 1. Creación de los 5 roles del sistema
CREATE ROLE IF NOT EXISTS 'rol_administrador', 'rol_recepcionista', 'rol_usuario', 'rol_gerente_corporativo', 'rol_contador';

-- 2. rol_administrador: Acceso total a todas las tablas y procedimientos.
GRANT ALL PRIVILEGES ON coworking_db.* TO 'rol_administrador';

-- 3. rol_recepcionista: Gestión operativa (usuarios, reservas, accesos). Solo lectura en finanzas.
GRANT SELECT, INSERT, UPDATE ON coworking_db.usuarios TO 'rol_recepcionista';
GRANT SELECT, INSERT, UPDATE ON coworking_db.membresias TO 'rol_recepcionista';
GRANT SELECT, INSERT, UPDATE ON coworking_db.reservas TO 'rol_recepcionista';
GRANT SELECT, INSERT, UPDATE ON coworking_db.accesos TO 'rol_recepcionista';
GRANT SELECT ON coworking_db.pagos TO 'rol_recepcionista';
GRANT SELECT ON coworking_db.facturas TO 'rol_recepcionista';

-- 4. rol_usuario: Acceso básico para clientes (leer datos propios y crear reservas).
GRANT SELECT ON coworking_db.usuarios TO 'rol_usuario';
GRANT SELECT ON coworking_db.membresias TO 'rol_usuario';
GRANT SELECT, INSERT ON coworking_db.reservas TO 'rol_usuario';
GRANT SELECT ON coworking_db.espacios TO 'rol_usuario';
GRANT SELECT ON coworking_db.facturas TO 'rol_usuario';

-- 5. rol_gerente_corporativo: Visibilidad sobre empleados de su empresa y facturación consolidada.
GRANT SELECT ON coworking_db.usuarios TO 'rol_gerente_corporativo';
GRANT SELECT ON coworking_db.empresas TO 'rol_gerente_corporativo';
GRANT SELECT ON coworking_db.membresias TO 'rol_gerente_corporativo';
GRANT SELECT ON coworking_db.facturas TO 'rol_gerente_corporativo';

-- 6. rol_contador: Acceso exclusivo a reportes financieros y facturación.
GRANT SELECT ON coworking_db.pagos TO 'rol_contador';
GRANT SELECT ON coworking_db.facturas TO 'rol_contador';
GRANT SELECT ON coworking_db.factura_detalle TO 'rol_contador';
GRANT EXECUTE ON PROCEDURE sp_reporte_ingresos_mensuales TO 'rol_contador';
GRANT EXECUTE ON PROCEDURE sp_reporte_usuarios_morosos TO 'rol_contador';

-- 7. Creación de usuarios de prueba para asignar los roles
CREATE USER IF NOT EXISTS 'admin_coworking'@'localhost' IDENTIFIED BY 'Admin123!';
CREATE USER IF NOT EXISTS 'recepcion_coworking'@'localhost' IDENTIFIED BY 'Recep123!';
CREATE USER IF NOT EXISTS 'cliente_coworking'@'localhost' IDENTIFIED BY 'Cliente123!';
CREATE USER IF NOT EXISTS 'gerente_coworking'@'localhost' IDENTIFIED BY 'Gerente123!';
CREATE USER IF NOT EXISTS 'contador_coworking'@'localhost' IDENTIFIED BY 'Conta123!';

-- 8. Asignación de roles a los usuarios de prueba
GRANT 'rol_administrador' TO 'admin_coworking'@'localhost';
GRANT 'rol_recepcionista' TO 'recepcion_coworking'@'localhost';
GRANT 'rol_usuario' TO 'cliente_coworking'@'localhost';
GRANT 'rol_gerente_corporativo' TO 'gerente_coworking'@'localhost';
GRANT 'rol_contador' TO 'contador_coworking'@'localhost';

-- 9. Activar los roles por defecto al iniciar sesión
SET DEFAULT ROLE ALL TO 'admin_coworking'@'localhost';
SET DEFAULT ROLE ALL TO 'recepcion_coworking'@'localhost';
SET DEFAULT ROLE ALL TO 'cliente_coworking'@'localhost';
SET DEFAULT ROLE ALL TO 'gerente_coworking'@'localhost';
SET DEFAULT ROLE ALL TO 'contador_coworking'@'localhost';

-- Verificación final de roles asignados
SELECT * FROM mysql.role_edges;