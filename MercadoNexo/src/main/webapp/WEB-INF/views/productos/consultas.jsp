<%@ include file="/WEB-INF/views/fragments/header.jspf" %>
<div class="encabezado">
    <div>
        <h1>Consultas JPQL</h1>
        <p>Consultas sobre el modelo de objetos: ${totalProductos} producto(s), ${sinStock} sin stock.</p>
    </div>
</div>

<div class="tarjeta">
    <h2>1. Consulta general</h2>
    <pre class="jpql">SELECT p FROM Producto p JOIN FETCH p.categoria ORDER BY p.id</pre>
    <a class="btn btn-claro" href="${pageContext.request.contextPath}/productos">Ver listado completo</a>
</div>

<div class="tarjeta">
    <h2>2. Consulta con parámetro: stock bajo</h2>
    <pre class="jpql">SELECT p FROM Producto p JOIN FETCH p.categoria WHERE p.stock &lt;= :umbral ORDER BY p.stock, p.nombre</pre>
    <form method="get" action="${pageContext.request.contextPath}/productos" class="filtros">
        <input type="hidden" name="accion" value="consultas">
        <div class="campo corto">
            <label for="umbral">Stock máximo (umbral)</label>
            <input type="number" id="umbral" name="umbral" min="0" value="${empty umbral ? 5 : umbral}">
        </div>
        <button type="submit" class="btn">Consultar</button>
    </form>

    <c:if test="${not empty umbral}">
        <div class="tabla-wrap" style="margin-top:1rem;">
            <table>
                <thead><tr><th>ID</th><th>Nombre</th><th>Categoría</th><th class="num">Stock</th></tr></thead>
                <tbody>
                <c:forEach var="p" items="${stockBajo}">
                    <tr>
                        <td>${p.id}</td>
                        <td><c:out value="${p.nombre}"/></td>
                        <td><span class="badge badge-cat"><c:out value="${p.categoria.nombre}"/></span></td>
                        <td class="num">${p.stock}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty stockBajo}">
                    <tr><td colspan="4" class="vacio">Ningún producto con stock ≤ ${umbral}.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </c:if>
</div>

<div class="dos-col">
    <div class="tarjeta">
        <h2>3. UPDATE masivo</h2>
        <pre class="jpql">UPDATE Producto p SET p.precio = p.precio * :factor
WHERE p.categoria = :categoria</pre>
        <form method="post" action="${pageContext.request.contextPath}/productos">
            <input type="hidden" name="accion" value="ajustar">
            <div class="campo">
                <label for="catAjuste">Categoría</label>
                <select id="catAjuste" name="categoria" required>
                    <option value="">Seleccione…</option>
                    <c:forEach var="c" items="${categorias}">
                        <option value="${c.id}"><c:out value="${c.nombre}"/></option>
                    </c:forEach>
                </select>
            </div>
            <div class="campo" style="margin-top:.8rem;">
                <label for="porcentaje">Ajuste de precio (%)</label>
                <input type="number" id="porcentaje" name="porcentaje" step="0.1" min="-90" max="200" value="10" required>
            </div>
            <div class="fila-botones">
                <button type="submit" class="btn"
                        onclick="return confirm('¿Aplicar el ajuste de precios a toda la categoría?');">Aplicar ajuste</button>
            </div>
        </form>
    </div>

    <div class="tarjeta">
        <h2>4. DELETE masivo</h2>
        <pre class="jpql">DELETE FROM Producto p WHERE p.stock = 0</pre>
        <p>Elimina de una sola vez todos los productos sin stock
           (actualmente <strong>${sinStock}</strong>).</p>
        <form method="post" action="${pageContext.request.contextPath}/productos">
            <input type="hidden" name="accion" value="limpiar">
            <div class="fila-botones">
                <button type="submit" class="btn btn-peligro"
                        onclick="return confirm('¿Eliminar definitivamente todos los productos sin stock?');">Eliminar productos sin stock</button>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
