package cl.mercadonexo.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.logging.Level;
import java.util.logging.Logger;

/** Utilidades comunes a los controladores. */
public abstract class BaseController extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(BaseController.class.getName());

    protected static final String VISTAS = "/WEB-INF/views/";

    protected static String param(HttpServletRequest req, String nombre, String porDefecto) {
        String v = req.getParameter(nombre);
        return (v == null || v.isBlank()) ? porDefecto : v.trim();
    }

    protected static Long aLong(String valor) {
        if (valor == null || valor.isBlank()) {
            return null;
        }
        try {
            return Long.valueOf(valor.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    protected static Integer aInteger(String valor) {
        if (valor == null || valor.isBlank()) {
            return null;
        }
        try {
            return Integer.valueOf(valor.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    protected static BigDecimal aDecimal(String valor) {
        if (valor == null || valor.isBlank()) {
            return null;
        }
        try {
            return new BigDecimal(valor.trim().replace(',', '.'));
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    /** Mensaje "flash": se muestra una vez tras redirigir (patrón Post/Redirect/Get). */
    protected static void flash(HttpServletRequest req, String mensaje, String tipo) {
        req.getSession().setAttribute("mensaje", mensaje);
        req.getSession().setAttribute("tipoMensaje", tipo);
    }

    protected void vista(HttpServletRequest req, HttpServletResponse resp, String ruta)
            throws ServletException, IOException {
        req.getRequestDispatcher(VISTAS + ruta).forward(req, resp);
    }

    protected void mostrarError(HttpServletRequest req, HttpServletResponse resp, Exception ex)
            throws ServletException, IOException {
        LOG.log(Level.SEVERE, "Error en la solicitud " + req.getRequestURI(), ex);
        Throwable causa = ex;
        while (causa.getCause() != null && causa.getCause() != causa) {
            causa = causa.getCause();
        }
        req.setAttribute("titulo", "Error");
        req.setAttribute("error", causa.getMessage() != null ? causa.getMessage() : causa.toString());
        resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        vista(req, resp, "error.jsp");
    }
}
