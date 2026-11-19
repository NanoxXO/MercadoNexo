/* ============================================================
   MercadoNexo - Verificaciones de la Tarea 2 (sacar capturas)
   Ejecutar conectado como sa y luego como nexo_app.
   ============================================================ */

-- Modo de autenticación: 0 = Mixto (Windows + SQL Server)  |  1 = solo Windows
SELECT SERVERPROPERTY('IsIntegratedSecurityOnly') AS SoloWindows_0_es_mixto;

-- Protocolo y puerto de ESTA conexión (si es TCP debe mostrar 1433 u otro puerto configurado)
SELECT net_transport, local_net_address, local_tcp_port
FROM sys.dm_exec_connections
WHERE session_id = @@SPID;

-- Usuario actual y base de datos
SELECT SUSER_SNAME() AS login_actual, USER_NAME() AS usuario_bd, DB_NAME() AS base_actual;

-- Pertenencia a roles del usuario de la aplicación
USE MercadoNexoDB;
SELECT
    IS_ROLEMEMBER('db_datareader', 'nexo_app') AS datareader,
    IS_ROLEMEMBER('db_datawriter', 'nexo_app') AS datawriter,
    IS_ROLEMEMBER('db_ddladmin',   'nexo_app') AS ddladmin;

-- Contenido (para comprobar que los cambios hechos desde Java se reflejan)
SELECT * FROM dbo.CATEGORIA;
SELECT p.ID_PRODUCTO, p.NOMBRE, c.NOMBRE AS CATEGORIA, p.PRECIO, p.STOCK
FROM dbo.PRODUCTO p JOIN dbo.CATEGORIA c ON c.ID_CATEGORIA = p.ID_CATEGORIA
ORDER BY p.ID_PRODUCTO;
