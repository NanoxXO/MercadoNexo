package cl.mercadonexo.controller;

import cl.mercadonexo.dao.CategoriaDAO;
import cl.mercadonexo.dao.ProductoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import cl.mercadonexo.model.Categoria;
import java.io.IOException;
import java.util.List;

/** Panel de inicio: resumen y verificación de la conexión con SQL Server. */
@WebServlet(name = "InicioController", urlPatterns = "/inicio")
public class InicioController extends BaseController {

    private final ProductoDAO productoDAO = new ProductoDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("titulo", "Inicio");
        req.setAttribute("pagina", "inicio");
        try {
            req.setAttribute("totalProductos", productoDAO.contarTodos());
            req.setAttribute("totalCategorias", categoriaDAO.contarTodas());
            req.setAttribute("sinStock", productoDAO.contarSinStock());
            req.setAttribute("valorInventario", productoDAO.valorInventario());
            req.setAttribute("stockBajo", productoDAO.buscarStockBajo(5));
            req.setAttribute("ultimos", productoDAO.ultimosRegistrados(4));

            List<Categoria> resumen = categoriaDAO.listarConProductos();
            int max = 0;
            for (Categoria c : resumen) {
                max = Math.max(max, c.getTotalProductos());
            }
            req.setAttribute("categoriasResumen", resumen);
            req.setAttribute("maxProductosCat", max);
            req.setAttribute("conexionOk", true);
        } catch (Exception ex) {
            Throwable causa = ex;
            while (causa.getCause() != null && causa.getCause() != causa) {
                causa = causa.getCause();
            }
            req.setAttribute("conexionOk", false);
            req.setAttribute("errorConexion", causa.getMessage());
        }
        vista(req, resp, "inicio.jsp");
    }
}
