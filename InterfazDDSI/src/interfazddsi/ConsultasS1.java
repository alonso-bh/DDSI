/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interfazddsi;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Scanner;

/**
 *
 * @author alonso
 */

public class ConsultasS1 extends Consultas {
    
    Connection conn;
    Statement stmt;
    
    /*public static void main(String[] args) throws Exception{
	
        int numero_edicion = -1;
        float dinero_aportado;
        
        final Scanner in = new Scanner (System.in);
        
        ConsultasS1 consultas = new ConsultasS1();

        consultas.initialize();
        
        System.out.println("Introduzca numero de edicion: ");
        
        while(numero_edicion < 0){
            numero_edicion = Integer.parseInt(in.nextLine());
            
            if (numero_edicion < 0)
                System.out.println("Numero de edicion introducido no valido. Por favor, introduzcalo de nuevo: ");
        }
        
        dinero_aportado = consultas.consultaDineroAportado(numero_edicion);
        
        System.out.println("El dinero total que los colaboradores aportaron en la edicion " 
                           + numero_edicion + " fue: " + dinero_aportado + "\n");
    }*/
    
    /*public void initialize() throws Exception {
        DriverManager.registerDriver( new oracle.jdbc.driver.OracleDriver());
        
        conn = DriverManager.getConnection ("jdbc:oracle:thin:@oracle0.ugr.es:1521/practbd.oracle0.ugr.es", 
                                            "x6653779","x6653779");
        
        System.out.println("Conexion a la base de datos establecida");
    }*/
    
    public float consultaDineroAportado(int numero_edicion) throws Exception {
        float total = 0;
        
        stmt = conn.createStatement (); 
        
        ResultSet rset = stmt.executeQuery ("SELECT dinero_aportado FROM Colabora where numero_edicion = '" + numero_edicion + "'");
        
        while (rset.next ()) {
            total += Float.parseFloat(rset.getString(1));
        }
        
        return total;
    }
}