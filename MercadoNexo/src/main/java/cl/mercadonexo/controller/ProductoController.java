package cl.mercadonexo.controller;

import cl.mercadonexo.dao.CategoriaDAO;
import cl.mercadonexo.dao.ProductoDAO;
import cl.mercadonexo.model.Producto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

/** Controlador de Productos: CRUD, filtros y operaciones masivas JPQL. */
@WebServlet(name = "ProductoController", urlPatterns = "/productos")
public class ProductoController extends BaseController {

    private final ProductoDAO productoDAO = new ProductoDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();

    // ------------------------------------------------------------------ GET

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String accion = param(req, "accion", "listar");
        try {
            switch (accion) {
                case "nuevo" -> formulario(req, resp, new Producto(), null, "Nuevo producto");
                case "editar" -> {
                    Producto p = productoDAO.buscarPorId(aLong(req.getParameter("id")));
                    if (p == null) {
                        flash(req, "El producto solicitado no existe.", "error");
                        resp.sendRedirect(req.getContextPath() + "/productos");
                        return;
                    }
                    formulario(req, resp, p, p.getCategoria().getId(), "Editar producto");
                }
                case "consultas" -> consultas(req, resp);
                default -> listar(req, resp);
            }
        } catch (Exception ex) {
            mostrarError(req, resp, ex);
        }
    }

    // ------------------------------------------------------------------ POST

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String accion = param(req, "accion", "");
        try {
            switch (accion) {
                case "guardar" -> guardar(req, resp);
                case "eliminar" -> eliminar(req, resp);
                case "ajustar" -> ajustarPrecios(req, resp);
                case "limpiar" -> eliminarSinStock(req, resp);
                default -> resp.sendRedirect(req.getContextPath() + "/productos");
            }
        } catch (Exception ex) {
            mostrarError(req, resp, ex);
        }
    }

    // ------------------------------------------------------------------ Vistas

    private void listar(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String q = param(req, "q", "");
        Long idCategoria = aLong(req.getParameter("categoria"));

        List<Producto> productos = productoDAO.buscar(q, idCategoria);
        req.setAttribute("titulo", "Productos");
        req.setAttribute("pagina", "productos");
        req.setAttribute("productos", productos);
        req.setAttribute("categorias", categoriaDAO.listar());
        req.setAttribute("q", q);
        req.setAttribute("categoriaSel", idCategoria);
        req.setAttribute("filtrado", !q.isEmpty() || idCategoria != null);
        vista(req, resp, "productos/lista.jsp");
    }

    private void formulario(HttpServletRequest req, HttpServletResponse resp,
                            Producto p, Long idCategoria, String titulo)
            throws ServletException, IOException {
        req.setAttribute("titulo", titulo);
        req.setAttribute("pagina", "productos");
        req.setAttribute("producto", p);
        req.setAttribute("categoriaSel", idCategoria);
        req.setAttribute("categorias", categoriaDAO.listar());
        vista(req, resp, "productos/formulario.jsp");
    }

    private void consultas(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Integer umbral = aInteger(req.getParameter("umbral"));
        req.setAttribute("titulo", "Consultas JPQL");
        req.setAttribute("pagina", "consultas");
        req.setAttribute("categorias", categoriaDAO.listar());
        req.setAttribute("totalProductos", productoDAO.contarTodos());
        req.setAttribute("sinStock", productoDAO.contarSinStock());
        if (umbral != null && umbral >= 0) {
            req.setAttribute("umbral", umbral);
            req.setAttribute("stockBajo", productoDAO.buscarStockBajo(umbral));
        }
        vista(req, resp, "productos/consultas.jsp");
    }

    // ------------------------------------------------------------------ Acciones

    private void guardar(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Long id = aLong(req.getParameter("id"));
        String nombre = param(req, "nombre", "");
        BigDecimal precio = aDecimal(req.getParameter("precio"));
        Integer stock = aInteger(req.getParameter("stock"));
        Long idCategoria = aLong(req.getParameter("categoria"));

        List<String> errores = new ArrayList<>();
        if (nombre.isEmpty()) {
            errores.add("El nombre es obligatorio.");
        } else if (nombre.length() > 120) {
            errores.add("El nombre no puede superar los 120 caracteres.");
        }
        if (precio == null || precio.signum() < 0) {
            errores.add("El precio debe ser un número mayor o igual a 0.");
        }
        if (stock == null || stock < 0) {
            errores.add("El stock debe ser un número entero mayor o igual a 0.");
        }
        if (idCategoria == null) {
            errores.add("Debe seleccionar una categoría.");
        }

        Producto p = new Producto(nombre, precio, stock, null);
        p.setId(id);

        if (!errores.isEmpty()) {
            req.setAttribute("errores", errores);
            formulario(req, resp, p, idCategoria, id == null ? "Nuevo producto" : "Editar producto");
            return;
        }

        if (id == null) {
            productoDAO.registrar(p, idCategoria);
            flash(req, "Producto «" + nombre + "» registrado correctamente.", "ok");
        } else {
            productoDAO.actualizar(p, idCategoria);
            flash(req, "Producto «" + nombre + "» actualizado correctamente.", "ok");
        }
        resp.sendRedirect(req.getContextPath() + "/productos");
    }

    private void eliminar(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long id = aLong(req.getParameter("id"));
        try {
            productoDAO.eliminar(id);
            flash(req, "Producto eliminado correctamente.", "ok");
        } catch (IllegalArgumentException ex) {
            flash(req, ex.getMessage(), "error");
        }
        resp.sendRedirect(req.getContextPath() + "/productos");
    }

    /** UPDATE masivo JPQL. */
    private void ajustarPrecios(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long idCategoria = aLong(req.getParameter("categoria"));
        BigDecimal porcentaje = aDecimal(req.getParameter("porcentaje"));

        if (idCategoria == null || porcentaje == null
                || porcentaje.compareTo(new BigDecimal("-90")) < 0
                || porcentaje.compareTo(new BigDecimal("200")) > 0) {
            flash(req, "Indique una categoría y un porcentaje entre -90 y 200.", "error");
        } else {
            BigDecimal factor = BigDecimal.ONE.add(
                    porcentaje.divide(new BigDecimal("100"), 4, RoundingMode.HALF_UP));
            int filas = productoDAO.ajustarPrecios(idCategoria, factor);
            flash(req, "UPDATE masivo ejecutado: " + filas + " producto(s) con precio ajustado en "
                    + porcentaje.stripTrailingZeros().toPlainString() + " %.", "ok");
        }
        resp.sendRedirect(req.getContextPath() + "/productos?accion=consultas");
    }

    /** DELETE masivo JPQL. */
    private void eliminarSinStock(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int filas = productoDAO.eliminarSinStock();
        flash(req, "DELETE masivo ejecutado: " + filas + " producto(s) sin stock eliminado(s).", "ok");
        resp.sendRedirect(req.getContextPath() + "/productos?accion=consultas");
    }
}
