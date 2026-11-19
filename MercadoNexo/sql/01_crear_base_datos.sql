/* ============================================================
   MercadoNexo - Tarea 2: Creación y preparación de la base
   Ejecutar en SSMS / Azure Data Studio con un usuario administrador (sa)
   ============================================================ */

USE master;
GO

-- 1) Base de datos
IF DB_ID(N'MercadoNexoDB') IS NULL
    CREATE DATABASE MercadoNexoDB;
GO

-- 2) Login con autenticación de SQL Server (usado por la aplicación Java)
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'nexo_app')
    CREATE LOGIN nexo_app WITH PASSWORD = N'Nexo2026!App', CHECK_POLICY = OFF;
GO

-- 3) Usuario de base de datos y permisos
USE MercadoNexoDB;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'nexo_app')
    CREATE USER nexo_app FOR LOGIN nexo_app;
GO

ALTER ROLE db_datareader ADD MEMBER nexo_app;   -- SELECT
ALTER ROLE db_datawriter ADD MEMBER nexo_app;   -- INSERT / UPDATE / DELETE
ALTER ROLE db_ddladmin   ADD MEMBER nexo_app;   -- CREATE/ALTER TABLE (EclipseLink: create-or-extend-tables)
GO
