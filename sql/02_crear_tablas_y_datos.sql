/* ============================================================
   MercadoNexo - Tablas (opcional: JPA también las crea al desplegar)
   y datos de ejemplo. Los nombres coinciden con las anotaciones JPA.
   ============================================================ */

USE MercadoNexoDB;
GO

IF OBJECT_ID(N'dbo.CATEGORIA', N'U') IS NULL
CREATE TABLE dbo.CATEGORIA (
    ID_CATEGORIA INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    NOMBRE       NVARCHAR(80)  NOT NULL UNIQUE,
    DESCRIPCION  NVARCHAR(200) NULL
);
GO

IF OBJECT_ID(N'dbo.PRODUCTO', N'U') IS NULL
CREATE TABLE dbo.PRODUCTO (
    ID_PRODUCTO  INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    NOMBRE       NVARCHAR(120)  NOT NULL,
    PRECIO       DECIMAL(12,2)  NOT NULL,
    STOCK        INT            NOT NULL,
    ID_CATEGORIA INT            NOT NULL,
    CONSTRAINT FK_PRODUCTO_CATEGORIA FOREIGN KEY (ID_CATEGORIA)
        REFERENCES dbo.CATEGORIA (ID_CATEGORIA)
);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CATEGORIA)
BEGIN
    INSERT INTO dbo.CATEGORIA (NOMBRE, DESCRIPCION) VALUES
        (N'Notebooks',   N'Computadores portátiles'),
        (N'Smartphones', N'Teléfonos inteligentes'),
        (N'Accesorios',  N'Periféricos y complementos'),
        (N'Monitores',   N'Pantallas y displays');

    INSERT INTO dbo.PRODUCTO (NOMBRE, PRECIO, STOCK, ID_CATEGORIA)
    SELECT v.nombre, v.precio, v.stock, c.ID_CATEGORIA
    FROM (VALUES
        (N'Notebook Pro 14"',   899990, 12, N'Notebooks'),
        (N'Notebook Air 13"',   749990,  8, N'Notebooks'),
        (N'Smartphone Nova X',  459990, 25, N'Smartphones'),
        (N'Smartphone Lite 5G', 219990,  0, N'Smartphones'),
        (N'Mouse inalámbrico',   14990, 60, N'Accesorios'),
        (N'Teclado mecánico',    39990,  3, N'Accesorios'),
        (N'Monitor 27" QHD',    259990,  5, N'Monitores')
    ) AS v(nombre, precio, stock, categoria)
    JOIN dbo.CATEGORIA c ON c.NOMBRE = v.categoria;
END
GO
