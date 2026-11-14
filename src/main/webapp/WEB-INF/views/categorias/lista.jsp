<%@ include file="/WEB-INF/views/fragments/header.jspf" %>
<div class="encabezado">
    <div>
        <h1>Categorías</h1>
        <p>Agrupan los productos del catálogo (relación 1:N con Producto).</p>
    </div>
    <a class="btn" href="${pageContext.request.contextPath}/categorias?accion=nuevo">+ Nueva categoría</a>
</div>

<div class="tabla-wrap">
    <table>
        <thead>
            <tr><th>ID</th><th>Nombre</th><th>Descripción</th><th class="num">Productos</th><th></th></tr>
        </thead>
        <tbody>
        <c:forEach var="c" items="${categorias}">
            <tr>
                <td>${c.id}</td>
                <td><strong><c:out value="${c.nombre}"/></strong></td>
                <td><c:out value="${c.descripcion}"/></td>
                <td class="num"><span class="badge badge-cat">${c.totalProductos}</span></td>
                <td class="acciones">
                    <a class="btn btn-claro btn-sm" href="${pageContext.request.contextPath}/categorias?accion=editar&id=${c.id}">Editar</a>
                    <form method="post" action="${pageContext.request.contextPath}/categorias"
                          onsubmit="return confirm('¿Eliminar la categoría seleccionada?');">
                        <input type="hidden" name="accion" value="eliminar">
                        <input type="hidden" name="id" value="${c.id}">
                        <button type="submit" class="btn btn-peligro btn-sm">Eliminar</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty categorias}">
            <tr><td colspan="5" class="vacio">Aún no hay categorías registradas.</td></tr>
        </c:if>
        </tbody>
    </table>
</div>
<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
