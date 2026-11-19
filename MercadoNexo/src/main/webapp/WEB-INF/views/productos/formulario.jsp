<%@ include file="/WEB-INF/views/fragments/header.jspf" %>
<div class="encabezado">
    <div>
        <h1><c:out value="${titulo}"/></h1>
        <p>Complete los datos del producto.</p>
    </div>
</div>

<c:if test="${not empty errores}">
    <div class="alerta error">
        Revise los siguientes puntos:
        <ul><c:forEach var="e" items="${errores}"><li><c:out value="${e}"/></li></c:forEach></ul>
    </div>
</c:if>

<div class="tarjeta">
    <c:choose>
        <c:when test="${empty categorias}">
            <div class="alerta error">Primero debe crear al menos una categoría.</div>
            <a class="btn" href="${pageContext.request.contextPath}/categorias?accion=nuevo">Crear categoría</a>
        </c:when>
        <c:otherwise>
            <form method="post" action="${pageContext.request.contextPath}/productos">
                <input type="hidden" name="accion" value="guardar">
                <input type="hidden" name="id" value="${producto.id}">
                <div class="form-grid">
                    <div class="campo ancho">
                        <label for="nombre">Nombre</label>
                        <input type="text" id="nombre" name="nombre" maxlength="120" required
                               value="<c:out value='${producto.nombre}'/>">
                    </div>
                    <div class="campo">
                        <label for="categoria">Categoría</label>
                        <select id="categoria" name="categoria" required>
                            <option value="">Seleccione…</option>
                            <c:forEach var="c" items="${categorias}">
                                <option value="${c.id}" ${categoriaSel == c.id ? 'selected' : ''}><c:out value="${c.nombre}"/></option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="campo">
                        <label for="precio">Precio (CLP)</label>
                        <input type="number" id="precio" name="precio" min="0" step="0.01" required
                               value="${producto.precio}">
                    </div>
                    <div class="campo">
                        <label for="stock">Stock</label>
                        <input type="number" id="stock" name="stock" min="0" step="1" required
                               value="${producto.stock}">
                    </div>
                </div>
                <div class="fila-botones">
                    <button type="submit" class="btn">Guardar</button>
                    <a class="btn btn-claro" href="${pageContext.request.contextPath}/productos">Cancelar</a>
                </div>
            </form>
        </c:otherwise>
    </c:choose>
</div>
<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
