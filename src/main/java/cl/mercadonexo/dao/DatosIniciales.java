package cl.mercadonexo.dao;

import cl.mercadonexo.model.Categoria;
import cl.mercadonexo.model.Producto;
import java.math.BigDecimal;

/**
 * Carga datos de ejemplo la primera vez que se ejecuta la aplicación
 * (solo si la tabla CATEGORIA está vacía).
 */
public final class DatosIniciales {

    private DatosIniciales() {
    }

    public static void cargarSiEstaVacio() {
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        ProductoDAO productoDAO = new ProductoDAO();

        if (categoriaDAO.contarTodas() > 0) {
            return;
        }

        Categoria notebooks = categoriaDAO.registrar(new Categoria("Notebooks", "Computadores portátiles"));
        Categoria celulares = categoriaDAO.registrar(new Categoria("Smartphones", "Teléfonos inteligentes"));
        Categoria accesorios = categoriaDAO.registrar(new Categoria("Accesorios", "Periféricos y complementos"));
        Categoria monitores = categoriaDAO.registrar(new Categoria("Monitores", "Pantallas y displays"));

        productoDAO.registrar(new Producto("Notebook Pro 14\"", new BigDecimal("899990"), 12, null), notebooks.getId());
        productoDAO.registrar(new Producto("Notebook Air 13\"", new BigDecimal("749990"), 8, null), notebooks.getId());
        productoDAO.registrar(new Producto("Smartphone Nova X", new BigDecimal("459990"), 25, null), celulares.getId());
        productoDAO.registrar(new Producto("Smartphone Lite 5G", new BigDecimal("219990"), 0, null), celulares.getId());
        productoDAO.registrar(new Producto("Mouse inalámbrico", new BigDecimal("14990"), 60, null), accesorios.getId());
        productoDAO.registrar(new Producto("Teclado mecánico", new BigDecimal("39990"), 3, null), accesorios.getId());
        productoDAO.registrar(new Producto("Monitor 27\" QHD", new BigDecimal("259990"), 5, null), monitores.getId());
    }
}
