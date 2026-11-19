<%@ include file="/WEB-INF/views/fragments/header.jspf" %>
<div class="encabezado">
    <div>
        <h1>Categorías</h1>
        <p>Agrupan los productos del catálogo (relación 1:N con Producto).</p>
    </div>
    <a class="btn" href="${pageContext.request.contextPath}/categorias?accion=nuevo">+ Nueva categoría</a>
</div>

<div class="grid-cards">
    <c:forEach var="c" items="${categorias}">
        <article class="card">
            <div class="card-top"></div>
            <div class="card-body">
                <div class="card-head">
                    <div class="avatar">${fn:toUpperCase(fn:substring(c.nombre, 0, 1))}</div>
                    <div>
                        <h3><c:out value="${c.nombre}"/></h3>
                        <span class="badge badge-cat">${c.totalProductos} producto(s)</span>
                    </div>
                </div>
                <p class="card-desc"><c:out value="${empty c.descripcion ? 'Sin descripción' : c.descripcion}"/></p>
            </div>
            <div class="card-foot">
                <a class="btn btn-claro btn-sm" href="${pageContext.request.contextPath}/productos?categoria=${c.id}">Ver productos</a>
                <a class="btn btn-claro btn-sm" href="${pageContext.request.contextPath}/categorias?accion=editar&id=${c.id}">Editar</a>
                <form method="post" action="${pageContext.request.contextPath}/categorias"
                      onsubmit="return confirm('¿Eliminar la categoría seleccionada?');">
                    <input type="hidden" name="accion" value="eliminar">
                    <input type="hidden" name="id" value="${c.id}">
                    <button type="submit" class="btn btn-peligro btn-sm">Eliminar</button>
                </form>
            </div>
        </article>
    </c:forEach>
</div>
<c:if test="${empty categorias}">
    <div class="tarjeta vacio">Aún no hay categorías registradas.</div>
</c:if>
<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
