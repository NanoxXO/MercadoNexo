package cl.mercadonexo.controller;

import cl.mercadonexo.dao.DatosIniciales;
import cl.mercadonexo.dao.JPAUtil;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.util.Collections;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Inicializa JPA al desplegar la aplicación y libera recursos al detenerla.
 * Si SQL Server no está disponible, la aplicación igual despliega y el error
 * se informa en las páginas.
 */
@WebListener
public class AppListener implements ServletContextListener {

    private static final Logger LOG = Logger.getLogger(AppListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            JPAUtil.getEntityManagerFactory();
            DatosIniciales.cargarSiEstaVacio();
            LOG.info("MercadoNexo: conexión JPA con SQL Server inicializada correctamente.");
        } catch (Exception ex) {
            LOG.log(Level.SEVERE, "MercadoNexo: no se pudo inicializar JPA/SQL Server", ex);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        JPAUtil.close();
        ClassLoader cl = Thread.currentThread().getContextClassLoader();
        for (Driver driver : Collections.list(DriverManager.getDrivers())) {
            if (driver.getClass().getClassLoader() == cl) {
                try {
                    DriverManager.deregisterDriver(driver);
                } catch (Exception ignored) {
                    // se ignora: solo limpieza
                }
            }
        }
    }
}
