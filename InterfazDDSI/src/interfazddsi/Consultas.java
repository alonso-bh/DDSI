/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interfazddsi;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;


/**
 *
 * @author alonso
 */
public class Consultas {
    
    Connection conn;
    Statement stmt;
    
    
    public void initialize() throws Exception {
        DriverManager.registerDriver( new oracle.jdbc.driver.OracleDriver());
        
        String cadenaConexion = "jdbc:oracle:thin:@host:port/nombre_bd" ;
        String user = "user"; 
        String pass = "pass"; 
        
        conn = DriverManager.getConnection (cadenaConexion, user, pass);
        
        System.out.println("Conexion a la base de datos establecida");
        
        
    }
    
    public void cerrarConexion() throws SQLException
    {
        conn.close(); 
    }
    
}
