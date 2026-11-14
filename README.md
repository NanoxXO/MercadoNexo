# MercadoNexo · EPE3 Desarrollo Web 2

Aplicación web **Jakarta EE 10 (WAR)** con **JPA (EclipseLink)**, **SQL Server** y patrón **MVC**, desplegada en **GlassFish 7**.
Interfaz en tonos **beige y conchevino**.

## Estructura (MVC)

```
src/main/java/cl/mercadonexo
├── model/        Producto.java, Categoria.java                (MODELO: entidades JPA)
├── dao/          JPAUtil, ProductoDAO, CategoriaDAO, ...       (MODELO: persistencia con EntityManager + JPQL)
└── controller/   ProductoController, CategoriaController,
                  InicioController, AppListener, EncodingFilter (CONTROLADOR: servlets)
src/main/webapp
├── index.jsp                                                  (página inicial)
├── resources/css/estilos.css                                  (paleta beige + conchevino)
└── WEB-INF/views/ ...                                         (VISTAS: JSP + JSTL, sin lógica de persistencia)
src/main/resources/META-INF/persistence.xml                    (unidad de persistencia MercadoNexoPU)
sql/                                                           (scripts de base de datos)
```

## Tarea 1 · Entorno y proyecto
1. Instalar **JDK 21**, **Apache NetBeans**, **GlassFish 7.x** y Maven (viene con NetBeans).
2. NetBeans → *Tools ▸ Servers ▸ Add Server ▸ GlassFish Server* (apuntar a la carpeta de GlassFish).
3. *File ▸ Open Project* → carpeta `MercadoNexo`. (El proyecto ya es Maven, `packaging = war`.)
4. Clic derecho al proyecto ▸ *Properties ▸ Run* → Server: **GlassFish**, Java EE version: **Jakarta EE 10 Web**.
5. *Clean and Build* y *Run*. Abre `http://localhost:8080/MercadoNexo/` (página inicial `index.jsp`).

## Tarea 2 · Base de datos SQL Server
1. En SSMS ejecutar, en orden: `sql/01_crear_base_datos.sql` y `sql/02_crear_tablas_y_datos.sql` (el 02 es opcional: JPA también crea las tablas).
2. **Autenticación SQL Server**: clic derecho al servidor ▸ *Properties ▸ Security ▸ SQL Server and Windows Authentication mode* → reiniciar el servicio.
3. **TCP/IP y puerto**: *SQL Server Configuration Manager ▸ SQL Server Network Configuration ▸ Protocols for MSSQLSERVER ▸ TCP/IP = Enabled*;
   en *Properties ▸ IP Addresses ▸ IPAll* → *TCP Port = 1433*. Reiniciar el servicio.
4. Verificar con `sql/03_verificacion.sql` (modo mixto, puerto TCP, roles del usuario `nexo_app`) y con
   `Test-NetConnection localhost -Port 1433` en PowerShell. **Sacar capturas** de cada paso.

## Tarea 3 · JDBC + JPA
- `pom.xml`: dependencia `com.microsoft.sqlserver:mssql-jdbc` (se empaqueta en el WAR).
- `persistence.xml`: proveedor `org.eclipse.persistence.jpa.PersistenceProvider`, URL, usuario y clave.
  Si su instancia usa otro puerto/usuario/clave, **editar solo ese archivo**.
  Si aparece un error SSL/TLS, cambiar en la URL `encrypt=true` por `encrypt=false`.

## Tarea 4 · Entidades
`Producto` (id, nombre, categoría, precio, stock) y `Categoria`; relación **@ManyToOne / @OneToMany** (1 categoría → N productos).

## Tarea 5 · EntityManager
`ProductoDAO` / `CategoriaDAO`: `persist`, `find`, actualización de entidad administrada y `remove`, todo con `EntityTransaction` (commit/rollback).
El SQL generado queda visible en el log de GlassFish (`eclipselink.logging.level.sql=FINE`).

## Tarea 6 · JPQL (`ProductoDAO`)
| Requisito | Método |
|---|---|
| Consulta general | `listar()` |
| Consulta con parámetros | `buscar(texto, idCategoria)` y `buscarStockBajo(umbral)` |
| UPDATE masivo | `ajustarPrecios(idCategoria, factor)` |
| DELETE masivo | `eliminarSinStock()` |

Se ejecutan desde el menú **Consultas JPQL** de la aplicación.

## Tarea 7 · MVC
- **Modelo**: `model` + `dao`. **Controlador**: servlets en `controller`. **Vista**: JSP en `WEB-INF/views` (no accesibles directamente, sin acceso a datos).

## Tarea 8 · Despliegue final
`Run` en NetBeans o copiar `target/MercadoNexo.war` a *GlassFish ▸ Applications ▸ Deploy*.
Al iniciar, si la tabla está vacía, se cargan datos de ejemplo. Panel **Inicio** indica si la conexión con SQL Server está OK.

### Checklist de evidencia sugerida
1. Versiones (`java -version`, `mvn -v`) y GlassFish en ejecución.
2. Página inicial en el navegador.
3. SSMS: base, usuario/roles, TCP/IP habilitado, puerto, resultado de `03_verificacion.sql`.
4. CRUD en la app y el mismo cambio visto en SSMS.
5. Las 4 operaciones JPQL (antes/después en SSMS).
6. Log de GlassFish con el SQL generado.
