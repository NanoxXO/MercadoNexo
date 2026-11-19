<%@ include file="/WEB-INF/views/fragments/header.jspf" %>
<div class="encabezado">
    <div>
        <h1><c:out value="${titulo}"/></h1>
        <p>Defina el nombre y una breve descripción.</p>
    </div>
</div>

<c:if test="${not empty errores}">
    <div class="alerta error">
        Revise los siguientes puntos:
        <ul><c:forEach var="e" items="${errores}"><li><c:out value="${e}"/></li></c:forEach></ul>
    </div>
</c:if>

<div class="tarjeta">
    <form method="post" action="${pageContext.request.contextPath}/categorias">
        <input type="hidden" name="accion" value="guardar">
        <input type="hidden" name="id" value="${categoria.id}">
        <div class="form-grid">
            <div class="campo">
                <label for="nombre">Nombre</label>
                <input type="text" id="nombre" name="nombre" maxlength="80" required
                       value="<c:out value='${categoria.nombre}'/>">
            </div>
            <div class="campo ancho">
                <label for="descripcion">Descripción</label>
                <textarea id="descripcion" name="descripcion" rows="3" maxlength="200"><c:out value="${categoria.descripcion}"/></textarea>
            </div>
        </div>
        <div class="fila-botones">
            <button type="submit" class="btn">Guardar</button>
            <a class="btn btn-claro" href="${pageContext.request.contextPath}/categorias">Cancelar</a>
        </div>
    </form>
</div>
<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
