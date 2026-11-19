<%@ include file="/WEB-INF/views/fragments/header.jspf" %>
<div class="encabezado">
    <div>
        <h1>Productos</h1>
        <p>Catálogo completo de MercadoNexo.</p>
    </div>
    <a class="btn" href="${pageContext.request.contextPath}/productos?accion=nuevo">+ Nuevo producto</a>
</div>

<div class="tarjeta">
    <form method="get" action="${pageContext.request.contextPath}/productos" class="filtros">
        <div class="campo">
            <label for="q">Buscar por nombre</label>
            <input type="text" id="q" name="q" value="<c:out value='${q}'/>" placeholder="Ej.: notebook">
        </div>
        <div class="campo">
            <label for="categoria">Categoría</label>
            <select id="categoria" name="categoria">
                <option value="">Todas</option>
                <c:forEach var="c" items="${categorias}">
                    <option value="${c.id}" ${categoriaSel == c.id ? 'selected' : ''}><c:out value="${c.nombre}"/></option>
                </c:forEach>
            </select>
        </div>
        <div class="fila-botones" style="margin-top:0;">
            <button type="submit" class="btn">Filtrar</button>
            <c:if test="${filtrado}">
                <a class="btn btn-claro" href="${pageContext.request.contextPath}/productos">Limpiar</a>
            </c:if>
        </div>
    </form>
</div>

<div class="barra-lista">
    <span>${productos.size()} producto(s) mostrado(s)</span>
    <div class="conmutador">
        <button type="button" id="btnTarjetas" class="on">Tarjetas</button>
        <button type="button" id="btnTabla">Tabla</button>
    </div>
</div>

<div id="contenido" class="modo-tarjetas">

    <%-- Vista de tarjetas --%>
    <div class="vista-tarjetas">
        <div class="grid-cards">
            <c:forEach var="p" items="${productos}">
                <article class="card">
                    <div class="card-top"></div>
                    <div class="card-body">
                        <div class="card-head">
                            <div class="avatar">${fn:toUpperCase(fn:substring(p.nombre, 0, 1))}</div>
                            <div>
                                <h3><c:out value="${p.nombre}"/></h3>
                                <span class="badge badge-cat"><c:out value="${p.categoria.nombre}"/></span>
                            </div>
                        </div>
                        <div class="precio"><fmt:formatNumber value="${p.precio}" type="currency" currencySymbol="$" maxFractionDigits="0"/> <small>CLP</small></div>
                        <div>
                            <div class="stock-fila">
                                <span>Stock</span>
                                <strong>
                                    <c:choose>
                                        <c:when test="${p.stock == 0}">Sin stock</c:when>
                                        <c:otherwise>${p.stock} unid.</c:otherwise>
                                    </c:choose>
                                </strong>
                            </div>
                            <div class="barra">
                                <span class="${p.stock == 0 ? 'cero' : (p.stock <= 5 ? 'bajo' : '')}"
                                      style="width:${p.stock == 0 ? 100 : (p.stock >= 50 ? 100 : p.stock * 2)}%"></span>
                            </div>
                        </div>
                    </div>
                    <div class="card-foot">
                        <a class="btn btn-claro btn-sm" href="${pageContext.request.contextPath}/productos?accion=editar&id=${p.id}">Editar</a>
                        <form method="post" action="${pageContext.request.contextPath}/productos"
                              onsubmit="return confirm('¿Eliminar el producto seleccionado?');">
                            <input type="hidden" name="accion" value="eliminar">
                            <input type="hidden" name="id" value="${p.id}">
                            <button type="submit" class="btn btn-peligro btn-sm">Eliminar</button>
                        </form>
                    </div>
                </article>
            </c:forEach>
        </div>
        <c:if test="${empty productos}">
            <div class="tarjeta vacio">No se encontraron productos.</div>
        </c:if>
    </div>

    <%-- Vista de tabla --%>
    <div class="vista-tabla">
        <div class="tabla-wrap">
            <table>
                <thead>
                    <tr>
                        <th>ID</th><th>Nombre</th><th>Categoría</th>
                        <th class="num">Precio</th><th class="num">Stock</th><th></th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="p" items="${productos}">
                    <tr>
                        <td>${p.id}</td>
                        <td><c:out value="${p.nombre}"/></td>
                        <td><span class="badge badge-cat"><c:out value="${p.categoria.nombre}"/></span></td>
                        <td class="num"><fmt:formatNumber value="${p.precio}" type="currency" currencySymbol="$" maxFractionDigits="0"/></td>
                        <td class="num">
                            <c:choose>
                                <c:when test="${p.stock == 0}"><span class="badge badge-cero">Sin stock</span></c:when>
                                <c:when test="${p.stock <= 5}"><span class="badge badge-bajo">${p.stock}</span></c:when>
                                <c:otherwise><span class="badge badge-ok">${p.stock}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="acciones">
                            <a class="btn btn-claro btn-sm" href="${pageContext.request.contextPath}/productos?accion=editar&id=${p.id}">Editar</a>
                            <form method="post" action="${pageContext.request.contextPath}/productos"
                                  onsubmit="return confirm('¿Eliminar el producto seleccionado?');">
                                <input type="hidden" name="accion" value="eliminar">
                                <input type="hidden" name="id" value="${p.id}">
                                <button type="submit" class="btn btn-peligro btn-sm">Eliminar</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty productos}">
                    <tr><td colspan="6" class="vacio">No se encontraron productos.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    (function () {
        var cont = document.getElementById('contenido');
        var bT = document.getElementById('btnTarjetas'), bB = document.getElementById('btnTabla');
        function modo(m) {
            cont.className = m === 'tabla' ? 'modo-tabla' : 'modo-tarjetas';
            bT.className = m === 'tabla' ? '' : 'on';
            bB.className = m === 'tabla' ? 'on' : '';
        }
        bT.addEventListener('click', function () { modo('tarjetas'); });
        bB.addEventListener('click', function () { modo('tabla'); });
    })();
</script>
<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
