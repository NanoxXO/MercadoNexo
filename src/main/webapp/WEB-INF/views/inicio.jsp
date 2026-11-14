<%@ include file="/WEB-INF/views/fragments/header.jspf" %>
<div class="encabezado">
    <div>
        <h1>Panel de inicio</h1>
        <p>Resumen del catálogo y estado de la conexión con SQL Server.</p>
    </div>
    <a class="btn" href="${pageContext.request.contextPath}/productos?accion=nuevo">+ Nuevo producto</a>
</div>

<c:choose>
    <c:when test="${conexionOk}">
        <div class="alerta ok">Conexión con SQL Server establecida correctamente mediante JPA.</div>
        <div class="metricas">
            <div class="metrica"><div class="valor">${totalProductos}</div><div class="etiqueta">Productos registrados</div></div>
            <div class="metrica"><div class="valor">${totalCategorias}</div><div class="etiqueta">Categorías</div></div>
            <div class="metrica"><div class="valor">${sinStock}</div><div class="etiqueta">Productos sin stock</div></div>
        </div>
        <div class="tarjeta">
            <h2>Accesos rápidos</h2>
            <div class="fila-botones" style="margin-top:.5rem;">
                <a class="btn btn-claro" href="${pageContext.request.contextPath}/productos">Listado de productos</a>
                <a class="btn btn-claro" href="${pageContext.request.contextPath}/categorias">Categorías</a>
                <a class="btn btn-claro" href="${pageContext.request.contextPath}/productos?accion=consultas">Consultas JPQL</a>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="alerta error">
            <strong>No fue posible conectar con SQL Server.</strong>
            <ul>
                <li>Verifique que la base <code>MercadoNexoDB</code> exista y que el servicio SQL Server esté activo.</li>
                <li>Confirme que TCP/IP esté habilitado y el puerto (1433 por defecto).</li>
                <li>Revise usuario y clave en <code>persistence.xml</code>.</li>
            </ul>
            <p><small>Detalle: <c:out value="${errorConexion}"/></small></p>
        </div>
    </c:otherwise>
</c:choose>
<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
