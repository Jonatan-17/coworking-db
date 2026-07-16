# CoworkingDB

## Descripción del proyecto

**CoworkingDB** es un sistema de gestión de bases de datos desarrollado en **MySQL 8.0** para administrar el funcionamiento de un espacio de coworking.

El proyecto integra la administración de usuarios, empresas, membresías, reservas de espacios, servicios adicionales, accesos, pagos, facturación y auditoría del sistema mediante objetos avanzados de bases de datos.

Además del modelo relacional, el proyecto implementa automatización utilizando **Triggers, Eventos, Funciones, Procedimientos Almacenados y Vistas**, permitiendo reducir procesos manuales y garantizar la integridad de la información.

Este repositorio está diseñado con fines académicos y demuestra la implementación de conceptos avanzados de SQL, normalización, automatización y administración de bases de datos.

---

# Requisitos del sistema

Antes de ejecutar el proyecto asegúrese de contar con el siguiente software instalado.

| Software        | Versión recomendada |
|----------      -|------------------- -|
| MySQL Server    |  8.0 o superior     |
| DBeaverCommunity|  Última versión     |
| Git             | Última versión      |

También es recomendable disponer de:

- Windows 10/11 o Linux
- 8 GB de memoria RAM
- Acceso de administrador sobre MySQL
- Permisos para crear eventos y procedimientos almacenados

---

# Guía de instalación

## Paso 1. Clonar el repositorio

```bash
git clone https://github.com/usuario/CoworkingDB.git

cd CoworkingDB
```

---

## Paso 2. Crear la base de datos

Conectarse a MySQL y ejecutar:

```sql
CREATE DATABASE coworkingdb;
USE coworkingdb;
```

---

## Paso 3. Ejecutar el script maestro

Abrir el archivo:

```
00_instalar_todo.sql
```

Ejecutarlo utilizando:

**Alt + X**

> **Importante**
>
> No utilizar **Ctrl + Enter**, ya que únicamente ejecutará una instrucción y el proyecto requiere ejecutar todos los scripts en orden.

---

## Paso 4. Verificar la instalación

Comprobar que existan:

- 15 tablas
- 20 triggers
- 20 eventos
- 20 funciones
- 20 procedimientos
- 20 vistas

Puede verificar mediante:

```sql
SHOW TABLES;

SHOW TRIGGERS;

SHOW EVENTS;

SHOW FUNCTION STATUS
WHERE Db='coworkingdb';

SHOW PROCEDURE STATUS
WHERE Db='coworkingdb';
```

---

# Estructura del repositorio

```text
CoworkingDB
│
├── 00_instalar_todo.sql
│
├── scripts
│   ├── 01_database.sql
│   ├── 02_tablas.sql
│   ├── 03_insert_datos.sql
│   ├── 04_consultas.sql
│   ├── 05_funciones.sql
│   ├── 06_procedimientos.sql
│   ├── 07_triggers.sql
│   ├── 08_eventos.sql
│   ├── 09_vistas.sql
│   ├── 10_roles.sql
│   └── 11_permisos.sql
│
├── consultas
│   ├── basicas.sql
│   ├── intermedias.sql
│   └── avanzadas.sql
│
├── diagramas
│   ├── modelo_er.png
│   └── modelo_relacional.pdf
│
├── docs
│   └── Manual.pdf
│
└── README.md
```

---

# Estructura de la base de datos

La base de datos está organizada en módulos funcionales.

| Módulo | Tablas |
|---------|---------|
| Usuarios | usuarios, empresas |
| Membresías | tipos_membresia, membresias, historial_membresias |
| Espacios | espacios |
| Servicios | servicios_adicionales, reserva_servicios |
| Reservas | reservas |
| Facturación | pagos, facturas, factura_detalle, factura_pagos |
| Control de acceso | accesos |
| Auditoría | logs_auditoria |

Total de tablas:

1. usuarios
2. empresas
3. tipos_membresia
4. espacios
5. servicios_adicionales
6. membresias
7. reservas
8. reserva_servicios
9. pagos
10. facturas
11. factura_detalle
12. factura_pagos
13. accesos
14. historial_membresias
15. logs_auditoria

---

# Automatización implementada

El proyecto incorpora un conjunto completo de objetos de automatización.

## Triggers (20)

1. trg_validar_solapamiento_reserva
2. trg_bloquear_acceso_sin_membresia
3. trg_actualizar_estado_pago
4. trg_generar_historial_membresia
5. trg_log_insert_usuario
6. trg_log_update_usuario
7. trg_log_delete_usuario
8. trg_validar_capacidad_espacio
9. trg_actualizar_fecha_modificacion
10. trg_validar_email
11. trg_generar_factura
12. trg_actualizar_reserva
13. trg_controlar_cancelacion
14. trg_registrar_acceso
15. trg_controlar_stock_servicio
16. trg_validar_membresia
17. trg_actualizar_factura
18. trg_actualizar_pago
19. trg_control_integridad
20. trg_auditoria_general

### Ejemplo

```sql
INSERT INTO reservas
VALUES (...);
```

El trigger:

```
trg_validar_solapamiento_reserva
```

evita reservas en horarios ya ocupados.

---

## Eventos (20)

1. evt_actualizar_membresias_vencidas
2. evt_cancelar_reservas_pendientes
3. evt_generar_respaldo_logs
4. evt_limpiar_logs
5. evt_actualizar_estado_facturas
6. evt_cerrar_reservas
7. evt_actualizar_estadisticas
8. evt_notificar_vencimientos
9. evt_borrar_temporales
10. evt_archivar_historial
11. evt_generar_reportes
12. evt_validar_usuarios
13. evt_cerrar_accesos
14. evt_recalcular_descuentos
15. evt_actualizar_espacios
16. evt_control_servicios
17. evt_validar_pagos
18. evt_eliminar_reservas_vencidas
19. evt_recalcular_ocupacion
20. evt_actualizar_dashboard

### Ejemplo

```sql
SHOW EVENTS;
```

---

## Funciones (20)

1. fn_calcular_edad
2. fn_dias_restantes_membresia
3. fn_descuento_fidelidad
4. fn_total_factura
5. fn_total_pagado
6. fn_espacios_disponibles
7. fn_estado_membresia
8. fn_nombre_completo
9. fn_calcular_iva
10. fn_porcentaje_ocupacion
11. fn_total_reservas
12. fn_total_servicios
13. fn_meses_antiguedad
14. fn_usuario_activo
15. fn_total_empresa
16. fn_reservas_activas
17. fn_saldo_pendiente
18. fn_horas_reservadas
19. fn_total_facturado
20. fn_ultimo_acceso

### Ejemplo

```sql
SELECT fn_dias_restantes_membresia(5);
```

---

## Procedimientos almacenados (20)

1. sp_crear_reserva
2. sp_generar_factura
3. sp_eliminar_usuario
4. sp_registrar_pago
5. sp_registrar_acceso
6. sp_crear_empresa
7. sp_actualizar_membresia
8. sp_cancelar_reserva
9. sp_generar_historial
10. sp_cerrar_factura
11. sp_crear_usuario
12. sp_actualizar_usuario
13. sp_eliminar_empresa
14. sp_registrar_servicio
15. sp_generar_reporte
16. sp_cambiar_estado
17. sp_actualizar_pago
18. sp_actualizar_factura
19. sp_limpiar_logs
20. sp_recalcular_estadisticas

### Ejemplo

```sql
CALL sp_crear_reserva(
3,
5,
'2026-08-01',
'09:00',
'11:00'
);
```

---

## Vistas (20)

1. vw_usuarios_membresia_activa
2. vw_facturas_pendientes
3. vw_dashboard_usuario
4. vw_reservas_activas
5. vw_ingresos_mensuales
6. vw_ocupacion_espacios
7. vw_historial_pagos
8. vw_servicios_utilizados
9. vw_empresas_activas
10. vw_usuarios_activos
11. vw_accesos_hoy
12. vw_dashboard_admin
13. vw_dashboard_contador
14. vw_dashboard_gerente
15. vw_reservas_canceladas
16. vw_total_facturado
17. vw_estadisticas
18. vw_resumen_general
19. vw_membresias_vencidas
20. vw_ocupacion_diaria

### Ejemplo

```sql
SELECT *
FROM vw_dashboard_usuario;
```

---

# Roles de usuario

El sistema implementa control de acceso mediante cinco roles.

| Rol | Permisos principales |
|------|----------------------|
| Administrador | Control total del sistema |
| Recepcionista | Gestión de reservas, usuarios y accesos |
| Usuario | Consultas personales y reservas |
| Gerente Corporativo | Consultas empresariales y reportes |
| Contador | Gestión de pagos, facturas y reportes financieros |

## Usuario de prueba

```text
Usuario:
admin

Contraseña:
Admin123*
```

---

# Ejemplos de uso

## Crear un usuario

```sql
INSERT INTO usuarios
(
nombre,
correo
)
VALUES
(
'Juan Pérez',
'juan@email.com'
);
```

---

## Crear una reserva

```sql
CALL sp_crear_reserva(
1,
2,
'2026-08-10',
'08:00',
'10:00'
);
```

---

## Consultar espacios disponibles

```sql
SELECT *
FROM espacios
WHERE disponible='SI';
```

---

## Consultar usuarios activos

```sql
SELECT *
FROM vw_usuarios_membresia_activa;
```

---

## Generar factura

```sql
CALL sp_generar_factura(8);
```

---

## Consultar facturas pendientes

```sql
SELECT *
FROM vw_facturas_pendientes;
```

---

## Consultar días restantes de membresía

```sql
SELECT fn_dias_restantes_membresia(3);
```

---

# Consultas SQL incluidas

El repositorio incorpora **100 consultas SQL**, clasificadas según su nivel de complejidad.

| Categoría | Cantidad |
|------------|----------|
| Básicas | 35 |
| Intermedias | 35 |
| Avanzadas | 30 |

Las consultas incluyen:

- SELECT
- JOIN
- GROUP BY
- HAVING
- ORDER BY
- UNION
- Subconsultas
- CTE
- Funciones agregadas
- Consultas con vistas
- Consultas utilizando procedimientos
- Consultas utilizando funciones

---

# Solución de problemas comunes

## Error al ejecutar el script

Verifique que está utilizando:

```
Alt + X
```

No utilice:

```
Ctrl + Enter
```

---

## Error de permisos

Conceda privilegios suficientes al usuario de MySQL.

```sql
GRANT ALL PRIVILEGES
ON coworkingdb.*
TO 'usuario'@'%';
```

---

## Los eventos no aparecen

Verifique:

```sql
SHOW VARIABLES
LIKE 'event_scheduler';
```

Si está deshabilitado:

```sql
SET GLOBAL event_scheduler = ON;
```

---

## No aparecen procedimientos

Verifique:

```sql
SHOW PROCEDURE STATUS
WHERE Db='coworkingdb';
```

---

## No aparecen funciones

Ejecute:

```sql
SHOW FUNCTION STATUS
WHERE Db='coworkingdb';
```

---

## No aparecen triggers

```sql
SHOW TRIGGERS;
```

---

## Error por clave foránea

Asegúrese de ejecutar el archivo maestro completo respetando el orden establecido.

---

# Autor: JONATAN DAVID SARMIENTO

**Proyecto:** CoworkingDB

**Tecnologías utilizadas**

- MySQL 8.0
- SQL
- DBeaver
- Git
- GitHub

Proyecto académico orientado a demostrar el diseño, implementación y automatización de una base de datos para la administración integral de un espacio de coworking, aplicando buenas prácticas de modelado relacional, integridad referencial y programación SQL avanzada.