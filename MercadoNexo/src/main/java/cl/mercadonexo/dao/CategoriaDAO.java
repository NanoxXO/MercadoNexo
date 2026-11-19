package cl.mercadonexo.dao;

import cl.mercadonexo.model.Categoria;
import jakarta.persistence.EntityManager;
import java.util.List;

/**
 * Persistencia de Categoria mediante EntityManager y JPQL.
 */
public class CategoriaDAO {

    /** INSERT */
    public Categoria registrar(Categoria categoria) {
        EntityManager em = JPAUtil.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(categoria);
            em.getTransaction().commit();
            return categoria;
        } catch (RuntimeException ex) {
            rollback(em);
            throw ex;
        } finally {
            em.close();
        }
    }

    /** SELECT por clave primaria */
    public Categoria buscarPorId(Long id) {
        EntityManager em = JPAUtil.createEntityManager();
        try {
            return em.find(Categoria.class, id);
        } finally {
            em.close();
        }
    }

    /** UPDATE */
    public Categoria actualizar(Categoria datos) {
        EntityManager em = JPAUtil.createEntityManager();
        try {
            em.getTransaction().begin();
            Categoria c = em.find(Categoria.class, datos.getId());
            if (c == null) {
                throw new IllegalArgumentException("La categoría no existe.");
            }
            c.setNombre(datos.getNombre());
            c.setDescripcion(datos.getDescripcion());
            em.getTransaction().commit();
            return c;
        } catch (RuntimeException ex) {
            rollback(em);
            throw ex;
        } finally {
            em.close();
        }
    }

    /** DELETE (no permite borrar categorías con productos asociados) */
    public void eliminar(Long id) {
        EntityManager em = JPAUtil.createEntityManager();
        try {
            em.getTransaction().begin();
            Categoria c = em.find(Categoria.class, id);
            if (c == null) {
                throw new IllegalArgumentException("La categoría no existe.");
            }
            Long asociados = em.createQuery(
                    "SELECT COUNT(p) FROM Producto p WHERE p.categoria.id = :id", Long.class)
                    .setParameter("id", id)
                    .getSingleResult();
            if (asociados > 0) {
                throw new IllegalStateException("No se puede eliminar: la categoría tiene "
                        + asociados + " producto(s) asociado(s).");
            }
            em.remove(c);
            em.getTransaction().commit();
        } catch (RuntimeException ex) {
            rollback(em);
            throw ex;
        } finally {
            em.close();
        }
    }

    /** JPQL general: todas las categorías */
    public List<Categoria> listar() {
        EntityManager em = JPAUtil.createEntityManager();
        try {
            return em.createQuery("SELECT c FROM Categoria c ORDER BY c.nombre", Categoria.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /** JPQL con JOIN FETCH: categorías con su lista de productos cargada */
    public List<Categoria> listarConProductos() {
        EntityManager em = JPAUtil.createEntityManager();
        try {
            return em.createQuery(
                    "SELECT DISTINCT c FROM Categoria c LEFT JOIN FETCH c.productos ORDER BY c.nombre",
                    Categoria.class).getResultList();
        } finally {
            em.close();
        }
    }

    public long contarTodas() {
        EntityManager em = JPAUtil.createEntityManager();
        try {
            return em.createQuery("SELECT COUNT(c) FROM Categoria c", Long.class).getSingleResult();
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
