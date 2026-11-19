<%@ include file="/WEB-INF/views/fragments/header.jspf" %>

<c:choose>
<c:when test="${conexionOk}">

<%-- Banner de bienvenida --%>
<section class="bienvenida">
    <div>
        <h1>Bienvenido a MercadoNexo</h1>
        <p>Administre el catálogo de productos tecnológicos: registre, consulte, modifique y controle el stock en un solo lugar.</p>
        <span class="estado-conexion"><i></i> Conectado a SQL Server mediante JPA</span>
    </div>
    <a class="btn" href="${pageContext.request.contextPath}/productos?accion=nuevo">+ Nuevo producto</a>
</section>

<%-- Métricas --%>
<div class="metricas">
    <div class="metrica">
        <div class="icono"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linejoin="round"><path d="M21 8l-9-5-9 5 9 5 9-5zM3 8v8l9 5 9-5V8M12 13v8"/></svg></div>
        <div><div class="valor">${totalProductos}</div><div class="etiqueta">Productos registrados</div></div>
    </div>
    <div class="metrica">
        <div class="icono oro"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linejoin="round"><path d="M3 3h8l10 10-8 8L3 11V3z"/><circle cx="7.5" cy="7.5" r="1.5"/></svg></div>
        <div><div class="valor">${totalCategorias}</div><div class="etiqueta">Categorías</div></div>
    </div>
    <div class="metrica">
        <div class="icono terra"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M12 8v5M12 17h.01"/><circle cx="12" cy="12" r="9"/></svg></div>
        <div><div class="valor">${sinStock}</div><div class="etiqueta">Productos sin stock</div></div>
    </div>
    <div class="metrica">
        <div class="icono oro"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2v20M17 6H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg></div>
        <div><div class="valor" style="font-size:1.6rem;"><fmt:formatNumber value="${valorInventario}" type="currency" currencySymbol="$" maxFractionDigits="0"/></div><div class="etiqueta">Valor del inventario</div></div>
    </div>
</div>

<%-- Categorías + alertas --%>
<div class="panel-dos">
    <div class="tarjeta">
        <h2>Productos por categoría <small>${totalProductos} en total</small></h2>
        <c:forEach var="c" items="${categoriasResumen}">
            <div class="fila-cat">
                <div class="top"><strong><c:out value="${c.nombre}"/></strong><span>${c.totalProductos} producto(s)</span></div>
                <div class="barra"><span style="width:${maxProductosCat == 0 ? 0 : c.totalProductos * 100 / maxProductosCat}%"></span></div>
            </div>
        </c:forEach>
        <c:if test="${empty categoriasResumen}"><p class="vacio">Aún no hay categorías.</p></c:if>
    </div>

    <div class="tarjeta">
        <h2>Alertas de stock <small>5 unidades o menos</small></h2>
        <c:forEach var="p" items="${stockBajo}" begin="0" end="4">
            <div class="item">
                <div class="avatar">${fn:toUpperCase(fn:substring(p.nombre, 0, 1))}</div>
                <div class="info"><strong><c:out value="${p.nombre}"/></strong><small><c:out value="${p.categoria.nombre}"/></small></div>
                <c:choose>
                    <c:when test="${p.stock == 0}"><span class="badge badge-cero">Sin stock</span></c:when>
                    <c:otherwise><span class="badge badge-bajo">${p.stock} unid.</span></c:otherwise>
                </c:choose>
            </div>
        </c:forEach>
        <c:if test="${empty stockBajo}">
            <div class="item-vacio">Todo el inventario tiene stock suficiente.</div>
        </c:if>
    </div>
</div>

<%-- Últimos productos --%>
<div class="tarjeta">
    <h2>Últimos productos registrados
        <small><a href="${pageContext.request.contextPath}/productos">Ver todos</a></small></h2>
    <c:forEach var="p" items="${ultimos}">
        <div class="item">
            <div class="avatar">${fn:toUpperCase(fn:substring(p.nombre, 0, 1))}</div>
            <div class="info"><strong><c:out value="${p.nombre}"/></strong><small><c:out value="${p.categoria.nombre}"/> · ${p.stock} en stock</small></div>
            <div class="der"><fmt:formatNumber value="${p.precio}" type="currency" currencySymbol="$" maxFractionDigits="0"/></div>
        </div>
    </c:forEach>
    <c:if test="${empty ultimos}"><p class="vacio">Aún no hay productos registrados.</p></c:if>
</div>

<%-- Accesos rápidos --%>
<div class="accesos">
    <a class="acceso" href="${pageContext.request.contextPath}/productos">
        <span class="ico"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M4 6h16M4 12h16M4 18h16"/></svg></span>
        <span><strong>Productos</strong><small>Ver el catálogo</small></span>
    </a>
    <a class="acceso" href="${pageContext.request.contextPath}/categorias?accion=nuevo">
        <span class="ico"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M12 5v14M5 12h14"/></svg></span>
        <span><strong>Nueva categoría</strong><small>Agrupar productos</small></span>
    </a>
    <a class="acceso" href="${pageContext.request.contextPath}/categorias">
        <span class="ico"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linejoin="round"><path d="M3 3h8l10 10-8 8L3 11V3z"/></svg></span>
        <span><strong>Categorías</strong><small>Administrarlas</small></span>
    </a>
    <a class="acceso" href="${pageContext.request.contextPath}/productos?accion=consultas">
        <span class="ico"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="7"/><path d="M21 21l-4.3-4.3"/></svg></span>
        <span><strong>Consultas JPQL</strong><small>Búsquedas y masivas</small></span>
    </a>
</div>

</c:when>
<c:otherwise>
    <div class="encabezado"><div><h1>Panel de inicio</h1></div></div>
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
