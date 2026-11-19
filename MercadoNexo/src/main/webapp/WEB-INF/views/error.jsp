<%@ include file="/WEB-INF/views/fragments/header.jspf" %>
<div class="tarjeta">
    <h1>Ocurrió un problema</h1>
    <div class="alerta error">
        <c:out value="${error}"/>
    </div>
    <p>Si el mensaje indica un problema de conexión, revise que SQL Server esté activo y que los datos de
       <code>persistence.xml</code> sean correctos.</p>
    <a class="btn btn-claro" href="${pageContext.request.contextPath}/inicio">Volver al inicio</a>
</div>
<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
