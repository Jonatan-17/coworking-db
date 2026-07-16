-- ==========================================
-- SCRIPT MAESTRO DE INSTALACIÓN - COWORKINGDB
-- ==========================================
-- Descripción: Orquesta la creación completa de la base de datos CoworkingDB.
-- Instrucciones: Ejecutar este archivo COMPLETO usando Alt + X en DBeaver.
-- Advertencia: No ejecutar línea por línea (Ctrl+Enter) debido a los DELIMITERS.
-- Autor: Jonatan | Fecha: Julio 2026
-- ==========================================

-- 1. Configuración inicial del entorno
SET GLOBAL event_scheduler = ON;
SET FOREIGN_KEY_CHECKS = 0; -- Desactivar FK temporalmente para evitar errores de orden en DML

-- 2. Creación de la base de datos
CREATE DATABASE IF NOT EXISTS coworking_db 
    CHARACTER SET utf8mb4 
    COLLATE utf8mb4_0900_ai_ci;

USE coworking_db;

SELECT '>> INICIANDO INSTALACIÓN DE COWORKINGDB...' AS ESTADO;

-- ==========================================
-- FASE 1: ESTRUCTURA DE DATOS (DDL)
-- ==========================================
SELECT '>> Fase 1: Creando estructura de tablas e índices...' AS PROGRESO;

SOURCE 01_DDL_Estructura/01_create_database.sql;
SOURCE 01_DDL_Estructura/02_create_tables.sql;
SOURCE 01_DDL_Estructura/03_create_constraints.sql;
SOURCE 01_DDL_Estructura/04_create_indexes.sql;

-- ==========================================
-- FASE 2: POBLADO DE DATOS (DML)
-- ==========================================
SELECT '>> Fase 2: Insertando datos iniciales y de prueba...' AS PROGRESO;

SOURCE 02_DML_Datos/01_insert_catalogos.sql;
SOURCE 02_DML_Datos/02_insert_usuarios_empresas.sql;
SOURCE 02_DML_Datos/03_insert_transacciones.sql;
SOURCE 02_DML_Datos/04_insert_enriquecimiento.sql;
SOURCE 02_DML_Datos/05_insert_datos_complementarios.sql;
SOURCE 02_DML_Datos/06_insert_ajuste_final.sql;
SOURCE 02_DML_Datos/07_insert_pagos_facturacion_ajuste.sql;

-- Reactivar integridad referencial tras insertar datos
SET FOREIGN_KEY_CHECKS = 1;

-- ==========================================
-- FASE 3: AUTOMATIZACIÓN Y LÓGICA DE NEGOCIO
-- ==========================================
SELECT '>> Fase 3: Instalando triggers, eventos y objetos programables...' AS PROGRESO;

SOURCE 04_Triggers/01_membresias_reservas.sql;
SOURCE 04_Triggers/02_pagos_accesos.sql;

SOURCE 05_Eventos/01_eventos_completos.sql;

SOURCE 06_Funciones/01_funciones_completas.sql;

SOURCE 07_Procedimientos/01_procedimientos_completos.sql;

SOURCE 08_Vistas/01_vistas_completas.sql;

-- ==========================================
-- FASE 4: SEGURIDAD Y ROLES
-- ==========================================
SELECT '>> Fase 4: Configurando roles y permisos...' AS PROGRESO;

SOURCE 09_Roles_Seguridad/01_roles_permisos_completos.sql;

-- ==========================================
-- VERIFICACIÓN FINAL AUTOMÁTICA
-- ==========================================
SELECT '=========================================' AS '';
SELECT 'VERIFICACIÓN DE INSTALACIÓN' AS ESTADO;
SELECT '=========================================' AS '';

-- Validación de cantidades esperadas
SELECT 
    CASE WHEN COUNT(*) = 15 THEN 'OK (15)' ELSE CONCAT('ERROR: Se encontraron ', COUNT(*), ' tablas') END AS Tablas,
    (SELECT CASE WHEN COUNT(*) = 20 THEN 'OK (20)' ELSE CONCAT('ERROR: Se encontraron ', COUNT(*), ' triggers') END FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA = 'coworking_db') AS Triggers,
    (SELECT CASE WHEN COUNT(*) = 20 THEN 'OK (20)' ELSE CONCAT('ERROR: Se encontraron ', COUNT(*), ' eventos') END FROM information_schema.EVENTS WHERE EVENT_SCHEMA = 'coworking_db') AS Eventos,
    (SELECT CASE WHEN COUNT(*) = 20 THEN 'OK (20)' ELSE CONCAT('ERROR: Se encontraron ', COUNT(*), ' funciones') END FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = 'coworking_db' AND ROUTINE_TYPE = 'FUNCTION') AS Funciones,
    (SELECT CASE WHEN COUNT(*) = 20 THEN 'OK (20)' ELSE CONCAT('ERROR: Se encontraron ', COUNT(*), ' procedimientos') END FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = 'coworking_db' AND ROUTINE_TYPE = 'PROCEDURE') AS Procedimientos,
    (SELECT CASE WHEN COUNT(*) = 20 THEN 'OK (20)' ELSE CONCAT('ERROR: Se encontraron ', COUNT(*), ' vistas') END FROM information_schema.VIEWS WHERE TABLE_SCHEMA = 'coworking_db') AS Vistas
FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'coworking_db';

SELECT '=========================================' AS '';
SELECT 'INSTALACIÓN FINALIZADA CORRECTAMENTE' AS RESULTADO;
SELECT '=========================================' AS '';
