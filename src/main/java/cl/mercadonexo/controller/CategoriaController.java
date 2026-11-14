package cl.mercadonexo.controller;

import cl.mercadonexo.dao.CategoriaDAO;
import cl.mercadonexo.model.Categoria;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/** Controlador de Categorías (CRUD). */
@WebServlet(name = "CategoriaController", urlPatterns = "/categorias")
public class CategoriaController extends BaseController {

    private final CategoriaDAO categoriaDAO = new CategoriaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String accion = param(req, "accion", "listar");
        try {
            switch (accion) {
                case "nuevo" -> formulario(req, resp, new Categoria(), "Nueva categoría");
                case "editar" -> {
                    Categoria c = categoriaDAO.buscarPorId(aLong(req.getParameter("id")));
                    if (c == null) {
                        flash(req, "La categoría solicitada no existe.", "error");
                        resp.sendRedirect(req.getContextPath() + "/categorias");
                        return;
                    }
                    formulario(req, resp, c, "Editar categoría");
                }
                default -> listar(req, resp);
            }
        } catch (Exception ex) {
            mostrarError(req, resp, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String accion = param(req, "accion", "");
        try {
            switch (accion) {
                case "guardar" -> guardar(req, resp);
                case "eliminar" -> eliminar(req, resp);
                default -> resp.sendRedirect(req.getContextPath() + "/categorias");
            }
        } catch (Exception ex) {
            mostrarError(req, resp, ex);
        }
    }

    private void listar(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("titulo", "Categorías");
        req.setAttribute("pagina", "categorias");
        req.setAttribute("categorias", categoriaDAO.listarConProductos());
        vista(req, resp, "categorias/lista.jsp");
    }

    private void formulario(HttpServletRequest req, HttpServletResponse resp, Categoria c, String titulo)
            throws ServletException, IOException {
        req.setAttribute("titulo", titulo);
        req.setAttribute("pagina", "categorias");
        req.setAttribute("categoria", c);
        vista(req, resp, "categorias/formulario.jsp");
    }

    private void guardar(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Long id = aLong(req.getParameter("id"));
        String nombre = param(req, "nombre", "");
        String descripcion = param(req, "descripcion", "");

        Categoria c = new Categoria(nombre, descripcion.isEmpty() ? null : descripcion);
        c.setId(id);

        List<String> errores = new ArrayList<>();
        if (nombre.isEmpty()) {
            errores.add("El nombre de la categoría es obligatorio.");
        } else if (nombre.length() > 80) {
            errores.add("El nombre no puede superar los 80 caracteres.");
        }
        if (!errores.isEmpty()) {
            req.setAttribute("errores", errores);
            formulario(req, resp, c, id == null ? "Nueva categoría" : "Editar categoría");
            return;
        }

        try {
            if (id == null) {
                categoriaDAO.registrar(c);
                flash(req, "Categoría «" + nombre + "» registrada correctamente.", "ok");
            } else {
                categoriaDAO.actualizar(c);
                flash(req, "Categoría «" + nombre + "» actualizada correctamente.", "ok");
            }
        } catch (RuntimeException ex) {
            errores.add("No se pudo guardar la categoría (¿el nombre ya existe?).");
            req.setAttribute("errores", errores);
            formulario(req, resp, c, id == null ? "Nueva categoría" : "Editar categoría");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/categorias");
    }

    private void eliminar(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long id = aLong(req.getParameter("id"));
        try {
            categoriaDAO.eliminar(id);
            flash(req, "Categoría eliminada correctamente.", "ok");
        } catch (IllegalStateException | IllegalArgumentException ex) {
            flash(req, ex.getMessage(), "error");
        }
        resp.sendRedirect(req.getContextPath() + "/categorias");
    }
}
