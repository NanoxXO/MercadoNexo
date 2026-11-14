<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>MercadoNexo · Bienvenido</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/estilos.css">
</head>
<body>
<main class="contenedor" style="display:flex;align-items:center;">
    <section class="hero" style="width:100%;">
        <h1>MercadoNexo</h1>
        <p>Sistema interno de gestión del catálogo de productos tecnológicos.
           Aplicación web Jakarta EE desplegada en GlassFish y conectada a Microsoft SQL Server mediante JPA.</p>
        <p style="margin-top:1.5rem;">
            <a class="btn" href="${pageContext.request.contextPath}/inicio">Ingresar al sistema</a>
            <a class="btn btn-claro" href="${pageContext.request.contextPath}/productos">Ver productos</a>
        </p>
    </section>
</main>
<footer class="pie">MercadoNexo SpA · Desarrollo Web 2 · EPE3</footer>
</body>
</html>
