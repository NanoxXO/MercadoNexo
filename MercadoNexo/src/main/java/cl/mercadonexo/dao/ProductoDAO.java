package cl.mercadonexo.dao;

import cl.mercadonexo.model.Categoria;
import cl.mercadonexo.model.Producto;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Persistencia de Producto: CRUD con EntityManager y consultas JPQL
 * (general, parametrizadas, UPDATE masivo y DELETE masivo).
 */
public class ProductoDAO {

    // ------------------------------------------------------------------
    // CRUD con EntityManager
    // ------------------------------------------------------------------

    /** INSERT: persist() dentro de una transacción. */
    public Producto registrar(Producto producto, Long idCategoria) {
        EntityManager em = JPAUtil.createEntityManager();
        try {
            em.getTransaction().begin();
            Categoria categoria = em.find(Categoria.class, idCategoria);
            if (categoria == null) {
                throw new IllegalArgumentException("La categoría seleccionada no existe.");
            }
            producto.setCategoria(categoria);
            em.persist(producto);
            em.getTransaction().commit();
            return producto;
        } catch (RuntimeException ex) {
            rollback(em);
            throw ex;
        } finally {
            em.close();
        }
    }

    /** SELECT por clave primaria: find(). */
    public Producto buscarPorId(Long id) {
        EntityManager em = JPAUtil.createEntityManager();
        try {
            return em.find(Producto.class, id);
        } finally {
            em.close();
        }
    }

    /** UPDATE: la entidad administrada se modifica y se sincroniza al hacer commit. */
    public Producto actualizar(Producto datos, Long idCategoria) {
        EntityManager em = JPAUtil.createEntityManager();
        try {
            em.getTransaction().begin();
            Producto p = em.find(Producto.class, datos.getId());
            if (p == null) {
                throw new IllegalArgumentException("El producto no existe.");
            }
            Categoria categoria = em.find(Categoria.class, idCategoria);
            if (categoria == null) {
                throw new IllegalArgumentException("La categoría seleccionada no existe.");
            }
            p.setNombre(datos.getNombre());
            p.setPrecio(datos.getPrecio());
            p.setStock(datos.getStock());
            p.setCategoria(categoria);
            em.getTransaction().commit();
            return p;
        } catch (RuntimeException ex) {
            rollback(em);
            throw ex;
        } finally {
            em.close();
        }
    }

    /** DELETE: remove() sobre la entidad administrada. */
    public void eliminar(Long id) {
        EntityManager em = JPAUtil.createEntityManager();
        try {
            em.getTransaction().begin();
            Producto p = em.find(Producto.class, id);
            if (p == null) {
                throw new IllegalArgumentException("El producto no existe.");
            }
            em.remove(p);
            em.getTransaction().commit();
        } catch (RuntimeException ex) {
            rollback(em);
            throw ex;
        } finally {
            em.close();
        }
    }

    // ------------------------------------------------------------------
    // Consultas JPQL
    // ------------------------------------------------------------------

    /** JPQL 1 (general): todos los productos. */
    public List<Producto> listar() {
        EntityManager em = JPAUtil.createEntityManager();
        try {
            return em.createQuery(
                    "SELECT p FROM Producto p JOIN FETCH p.categoria ORDER BY p.id",
                    Producto.class).getResultList();
        } finally {
            em.close();
        }
    }

    /** JPQL 2 (con parámetros): filtro opcional por texto y por categoría. */
    public List<Producto> buscar(String texto, Long idCategoria) {
        List<String> condiciones = new ArrayList<>();
        if (texto != null && !texto.isBlank()) {
            condiciones.add("LOWER(p.nombre) LIKE :texto");
        }
        if (idCategoria != null) {
            condiciones.add("p.categoria.id = :idCategoria");
        }

        StringBuilder jpql = new StringBuilder("SELECT p FROM Producto p JOIN FETCH p.categoria");
        if (!condiciones.isEmpty()) {
            jpql.append(" WHERE ").append(String.join(" AND ", condiciones));
        }
        jpql.append(" ORDER BY p.id");

        EntityManager em = JPAUtil.createEntityManager();
        try {
            TypedQuery<Producto> q = em.createQuery(jpql.toString(), Producto.class);
            if (texto != null && !texto.isBlank()) {
                q.setParameter("texto", "%" + texto.trim().toLowerCase() + "%");
            }
            if (idCategoria != null) {
                q.setParameter("idCategoria", idCategoria);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    /** JPQL 3 (con parámetro): productos con stock menor o igual al umbral. */
    public List<Producto> buscarStockBajo(int umbral) {
        EntityManager em = JPAUtil.createEntityManager();
        try {
            return em.createQuery(
                    "SELECT p FROM Producto p JOIN FETCH p.categoria "
                    + "WHERE p.stock <= :umbral ORDER BY p.stock, p.nombre",
                    Producto.class)
                    .setParameter("umbral", umbral)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * JPQL 4 (UPDATE masivo): multiplica el precio de todos los productos de una
     * categoría por un factor (ej.: 1.10 = +10 %). Retorna filas afectadas.
     */
    public int ajustarPrecios(Long idCategoria, BigDecimal factor) {
        EntityManager em = JPAUtil.createEntityManager();
        try {
            em.getTransaction().begin();
            Categoria categoria = em.find(Categoria.class, idCategoria);
            if (categoria == null) {
                throw new IllegalArgumentException("La categoría seleccionada no existe.");
            }
            int filas = em.createQuery(
                    "UPDATE Producto p SET p.precio = p.precio * :factor WHERE p.categoria = :categoria")
                    .setParameter("factor", factor)
                    .setParameter("categoria", categoria)
                    .executeUpdate();
            em.getTransaction().commit();
            return filas;
        } catch (RuntimeException ex) {
            rollback(em);
            throw ex;
        } finally {
            em.close();
        }
    }

    /** JPQL 5 (DELETE masivo): elimina todos los productos sin stock. Retorna filas afectadas. */
    public int eliminarSinStock() {
        EntityManager em = JPAUtil.createEntityManager();
        try {
            em.getTransaction().begin();
            int filas = em.createQuery("DELETE FROM Producto p WHERE p.stock = 0").executeUpdate();
            em.getTransaction().commit();
            return filas;
        } catch (RuntimeException ex) {
            rollback(em);
            throw ex;
        } finally {
            em.close();
        }
    }

    /** JPQL: últimos productos registrados (los de mayor id). */
    public List<Producto> ultimosRegistrados(int cantidad) {
        EntityManager em = JPAUtil.createEntityManager();
        try {
            return em.createQuery(
                    "SELECT p FROM Producto p JOIN FETCH p.categoria ORDER BY p.id DESC",
                    Producto.class)
                    .setMaxResults(cantidad)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /** JPQL de agregación: valor total del inventario (SUM precio * stock). */
    public BigDecimal valorInventario() {
        EntityManager em = JPAUtil.createEntityManager();
        try {
            Object r = em.createQuery("SELECT SUM(p.precio * p.stock) FROM Producto p")
                    .getSingleResult();
            return r == null ? BigDecimal.ZERO : new BigDecimal(r.toString());
        } finally {
            em.close();
        }
    }

    public long contarTodos() {
        EntityManager em = JPAUtil.createEntityManager();
        try {
            return em.createQuery("SELECT COUNT(p) FROM Producto p", Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }

    public long contarSinStock() {
        EntityManager em = JPAUtil.createEntityManager();
        try {
            return em.createQuery("SELECT COUNT(p) FROM Producto p WHERE p.stock = 0", Long.class)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }

    private static void rollback(EntityManager em) {
        if (em.getTransaction().isActive()) {
            em.getTransaction().rollback();
        }
    }
}
