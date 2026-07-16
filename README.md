# CoworkingDB

Proyecto final de la asignatura de Bases de Datos. Es una base de datos relacional en MySQL que modela el funcionamiento completo de un espacio de coworking: usuarios, empresas, membresías, reservas, servicios adicionales, facturación, control de accesos y auditoría.

La particularidad del proyecto no está solo en el modelo de datos, sino en que gran parte de la lógica de negocio vive dentro del propio motor: triggers, eventos programados, funciones, procedimientos y vistas se encargan de validar, calcular y automatizar procesos sin depender de una capa de aplicación externa.

## Requisitos

| Herramienta | Detalle |
|---|---|
| MySQL Server | 8.0 o superior (necesario para roles nativos y Event Scheduler) |
| Cliente SQL | DBeaver (recomendado) |
| Git | Para clonar el repositorio |

## Instalación

**1. Clonar el repositorio**

```bash
git clone https://github.com/usuario/CoworkingDB.git
cd CoworkingDB
```

**2. Crear la base de datos**

Conectarse al servidor MySQL con un usuario con privilegios administrativos y ejecutar:

```sql
CREATE DATABASE coworkingdb
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
```

**3. Ejecutar el script maestro**

Todo el proyecto se instala desde un único archivo: `scripts/00_instalar_todo.sql`. Este script crea las tablas, inserta los datos de prueba y registra todos los objetos programables (triggers, funciones, procedimientos, eventos y vistas) en el orden correcto.

Abrir el archivo en DBeaver, con la conexión apuntando a `coworkingdb`, y ejecutarlo.

> Importante: debe ejecutarse como **script completo, con Alt + X**. Si se usa Ctrl + Enter (ejecución de sentencia individual), el motor no procesará bien los bloques `DELIMITER` que usan los triggers, funciones y procedimientos, y la instalación quedará a medias.

**4. Verificar**

```sql
SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'coworkingdb';
SELECT COUNT(*) FROM information_schema.triggers WHERE trigger_schema = 'coworkingdb';
SELECT COUNT(*) FROM information_schema.events WHERE event_schema = 'coworkingdb';
SELECT ROUTINE_TYPE, COUNT(*) FROM information_schema.routines WHERE routine_schema = 'coworkingdb' GROUP BY ROUTINE_TYPE;
SELECT COUNT(*) FROM information_schema.views WHERE table_schema = 'coworkingdb';
```

Los conteos deberían coincidir con lo que se documenta más abajo: 15 tablas, 20 triggers, 20 eventos, 20 funciones, 20 procedimientos y 20 vistas.

## Estructura del repositorio
CoworkingDB/
├── README.md
├── scripts/
│   ├── 00_instalar_todo.sql
│   ├── 01_tablas.sql
│   ├── 02_datos_prueba.sql
│   ├── 03_triggers.sql
│   ├── 04_funciones.sql
│   ├── 05_procedimientos.sql
│   ├── 06_eventos.sql
│   ├── 07_vistas.sql
│   └── 08_roles_permisos.sql
├── consultas/
│   ├── consultas_basicas.sql
│   ├── consultas_intermedias.sql
│   └── consultas_avanzadas.sql
└── documentacion/
├── diagrama_er.png
└── catalogo_objetos.md

## Estructura de la base de datos

15 tablas en total, agrupadas por módulo:

**Usuarios y empresas**

| Tabla | Descripción |
|---|---|
| usuarios | Datos personales y credenciales de acceso |
| empresas | Empresas que agrupan varios usuarios bajo una misma membresía corporativa |

**Membresías**

| Tabla | Descripción |
|---|---|
| tipos_membresia | Catálogo de planes (precio, duración, beneficios) |
| membresias | Membresías contratadas, activas o históricas |
| historial_membresias | Registro de renovaciones, cambios y cancelaciones |

**Espacios y reservas**

| Tabla | Descripción |
|---|---|
| espacios | Catálogo de espacios físicos (oficinas, salas, escritorios) |
| servicios_adicionales | Servicios extra: café, impresión, proyector, etc. |
| reservas | Reservas hechas sobre los espacios |
| reserva_servicios | Servicios adicionales asociados a cada reserva |

**Facturación y pagos**

| Tabla | Descripción |
|---|---|
| pagos | Pagos individuales registrados por los usuarios |
| facturas | Facturas generadas a partir de membresías, reservas o servicios |
| factura_detalle | Conceptos que componen cada factura |
| factura_pagos | Pagos aplicados a cada factura |

**Control y auditoría**

| Tabla | Descripción |
|---|---|
| accesos | Entradas y salidas físicas registradas al coworking |
| logs_auditoria | Registro de operaciones críticas sobre la base de datos |

## Automatización implementada

En total son 100 objetos programables: 20 triggers, 20 eventos, 20 funciones, 20 procedimientos y 20 vistas. El detalle completo de cada uno está en `documentacion/catalogo_objetos.md` y en los scripts correspondientes dentro de `scripts/`. Acá algunos ejemplos representativos de cada tipo.

### Triggers (20)

Validan integridad y aplican reglas de negocio en el momento en que ocurre la operación.

- `trg_validar_solapamiento_reserva` — evita que un espacio quede reservado dos veces en el mismo horario.
- `trg_bloquear_acceso_sin_membresia` — impide registrar un acceso si el usuario no tiene membresía activa.
- `trg_pago_crea_factura` — genera automáticamente la factura al registrar un pago.

```sql
DELIMITER $$
CREATE TRIGGER trg_validar_solapamiento_reserva
BEFORE INSERT ON reservas
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM reservas
        WHERE espacio_id = NEW.espacio_id
          AND estado = 'confirmada'
          AND (NEW.hora_inicio < hora_fin AND NEW.hora_fin > hora_inicio)
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El espacio ya está reservado en ese horario';
    END IF;
END$$
DELIMITER ;
```

### Eventos programados (20)

Tareas de mantenimiento que corren solas usando el Event Scheduler.

- `evt_actualizar_membresias_vencidas` — pasa a "vencida" cualquier membresía cuya fecha ya pasó (diario).
- `evt_cancelar_reservas_pendientes` — cancela reservas sin confirmar después de 24 horas.
- `evt_aplicar_recargos_facturas` — aplica un recargo a facturas con más de 15 días de mora.

```sql
DELIMITER $$
CREATE EVENT evt_actualizar_membresias_vencidas
ON SCHEDULE EVERY 1 DAY
DO
    UPDATE membresias SET estado = 'vencida'
    WHERE fecha_fin < CURDATE() AND estado = 'activa'$$
DELIMITER ;
```

Para que estos eventos corran, el Event Scheduler tiene que estar activo (`SET GLOBAL event_scheduler = ON;`), y el script maestro ya lo hace por defecto.

### Funciones (20)

Cálculos puntuales que se reutilizan en consultas, vistas y procedimientos.

- `fn_calcular_edad` — edad exacta a partir de la fecha de nacimiento.
- `fn_dias_restantes_membresia` — días que le quedan a la membresía activa de un usuario.
- `fn_descuento_fidelidad` — porcentaje de descuento según antigüedad como cliente.

```sql
DELIMITER $$
CREATE FUNCTION fn_dias_restantes_membresia(p_usuario_id INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE dias INT;
    SELECT DATEDIFF(fecha_fin, CURDATE()) INTO dias
    FROM membresias WHERE usuario_id = p_usuario_id AND estado = 'activa' LIMIT 1;
    RETURN IFNULL(dias, 0);
END$$
DELIMITER ;
```

### Procedimientos almacenados (20)

Encapsulan procesos completos de negocio.

- `sp_crear_reserva` — valida disponibilidad y registra una nueva reserva.
- `sp_generar_factura` — arma una factura a partir de reservas y servicios pendientes de cobro.
- `sp_eliminar_usuario` — da de baja lógica a un usuario, validando que no tenga membresías activas.

```sql
DELIMITER $$
CREATE PROCEDURE sp_crear_reserva(
    IN p_usuario_id INT, IN p_espacio_id INT,
    IN p_fecha DATE, IN p_hora_inicio TIME, IN p_hora_fin TIME
)
BEGIN
    INSERT INTO reservas (usuario_id, espacio_id, fecha, hora_inicio, hora_fin, estado, fecha_creacion)
    VALUES (p_usuario_id, p_espacio_id, p_fecha, p_hora_inicio, p_hora_fin, 'pendiente', NOW());
    SELECT LAST_INSERT_ID() AS reserva_id;
END$$
DELIMITER ;
```

### Vistas (20)

Pensadas para reportes y consultas de uso frecuente.

- `vw_usuarios_membresia_activa` — usuarios con membresía vigente.
- `vw_facturas_pendientes` — cartera por cobrar.
- `vw_dashboard_usuario` — resumen operativo y financiero de un usuario en una sola consulta.

```sql
CREATE VIEW vw_facturas_pendientes AS
SELECT f.id, u.nombre AS usuario, f.fecha_emision, f.total, f.estado
FROM facturas f
JOIN usuarios u ON f.usuario_id = u.id
WHERE f.estado IN ('pendiente', 'parcial');
```

## Roles y seguridad

El acceso está controlado con roles nativos de MySQL, siguiendo el principio de menor privilegio: cada rol ve y modifica solo lo que necesita.

| Rol | Alcance |
|---|---|
| rol_administrador | Control total sobre estructura y datos |
| rol_recepcionista | Usuarios, reservas y accesos del día a día |
| rol_usuario | Solo sus propios datos, reservas y facturas |
| rol_gerente_corporativo | Membresías y facturación de su empresa |
| rol_contador | Módulo financiero: pagos, facturas y detalles |

```sql
CREATE ROLE rol_recepcionista;
GRANT SELECT, INSERT, UPDATE ON coworkingdb.reservas TO rol_recepcionista;
GRANT SELECT, INSERT, UPDATE ON coworkingdb.accesos TO rol_recepcionista;
GRANT SELECT, INSERT, UPDATE ON coworkingdb.usuarios TO rol_recepcionista;
```

Para pruebas y evaluación, el script maestro crea un usuario con rol de administrador:

| Usuario | Contraseña | Rol |
|---|---|---|
| `evaluador` | `Coworking2024*` | rol_administrador |

```sql
CREATE USER 'evaluador'@'%' IDENTIFIED BY 'Coworking2024*';
GRANT rol_administrador TO 'evaluador'@'%';
SET DEFAULT ROLE rol_administrador TO 'evaluador'@'%';
```

Esta contraseña es solo para fines académicos, no debería usarse en un entorno real.

## Ejemplos de uso

Días restantes de la membresía activa de un usuario:

```sql
SELECT u.nombre, tm.nombre AS tipo_membresia, fn_dias_restantes_membresia(u.id) AS dias_restantes
FROM usuarios u
JOIN membresias m ON u.id = m.usuario_id
JOIN tipos_membresia tm ON m.tipo_membresia_id = tm.id
WHERE u.id = 5 AND m.estado = 'activa';
```

Crear una reserva:

```sql
CALL sp_crear_reserva(5, 3, '2024-11-20', '09:00:00', '11:00:00');
```

Generar factura de un periodo:

```sql
CALL sp_generar_factura(5, '2024-11-01', '2024-11-30');
```

Panel resumen de un usuario:

```sql
SELECT * FROM vw_dashboard_usuario WHERE usuario_id = 5;
```

Más ejemplos, organizados por nivel de dificultad (100 consultas en total), están en la carpeta `consultas/`.

## Solución de problemas comunes

**Error de sintaxis cerca de `DELIMITER`**
Se está ejecutando el script sentencia por sentencia. Solución: seleccionar todo el archivo y ejecutar con Alt + X.

**Los eventos no se disparan**
El Event Scheduler está apagado. Solución: `SET GLOBAL event_scheduler = ON;`

**Error al crear roles**
La versión de MySQL es inferior a 8.0, y `CREATE ROLE` no existe en versiones anteriores. Solución: actualizar el motor.

**Los conteos de verificación no cuadran**
Probablemente el script se corrió más de una vez sobre una base ya poblada. Lo más simple es volver a crear la base de datos desde cero y ejecutar el script maestro una sola vez, completo.

## Autor JONATAN DAVID SARMIENTO

Proyecto desarrollado como trabajo final de la asignatura de Bases de Datos, enfocado en el diseño de un modelo relacional y en la automatización de reglas de negocio directamente en MySQL.
