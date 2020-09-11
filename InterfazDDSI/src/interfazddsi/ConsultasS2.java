/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interfazddsi;
//Para que funcione tiene que estar en la misma carpeta que este archivo el ojdbc8.jar
//Para compilar: javac -classpath ojdbc8.jar ConsultasS2.java
//Para ejecutar: java -cp .:ojdbc8.jar ConsultasS2

// ---------------------------
// ALONSO BUENO HERRERO 
// DDSI - GRUPO A-1-1

import java.sql.*;
import oracle.jdbc.*;  


import java.util.Scanner;

public class ConsultasS2 extends Consultas {
    
    static int  idPista = -1; 
    static int capacidad = -1; 
    static String nombrePista = new String(); 
        
    //Connection conn;
    //Statement stmt;
    PreparedStatement pstmt; 
    
    void setCamposParaLaConsulta(int id, int _capacidad, String _nombrePista)
    {
        idPista = id;
        capacidad = _capacidad;
        nombrePista = _nombrePista;
    }
    
    /**************************************************************************/
    /*public static void main(String[] args) throws Exception
    {
        String aux = new String(); 
        
        Scanner in = new Scanner (System.in);       

        System.out.println("Introduzca el identificador de pista");
        aux =  in.nextLine(); // System.in.read();
        idPista = Integer.parseInt(aux); 

        System.out.println("Introduzca capacidad: ");
        aux = in.nextLine();
         capacidad = Integer.parseInt(aux);

        System.out.println("Introduzca el nombre de la pista");
        
        nombrePista = in.nextLine() ;
        // alonso ----
        
        ConsultasS2 consultas = new ConsultasS2();
        
        consultas.initialize();
        
        //A partir de aqui depende de la interfaz que tenga cada uno:
        // procesar consulta
        consultas.insertData(1, nombrePista, capacidad); 
        
        // comprobando el INSERT
        int result = consultas.insertData(idPista, nombrePista, capacidad); 
        System.out.println("result = " +result); 
        if (result != 0)
        {
            System.out.println("ERROR al introducir los campos");
            System.exit(1) ; 
        } 
               
        System.out.println("Fila aÃ±adida correctamente"); 
        
    }
    */
    
    /**************************************************************************/
    //Solo tocar usuario y contrasena
    /*public void initialize() throws Exception {
        DriverManager.registerDriver( new OracleDriver()); // oracle.jdbc.driver.

        //Poner el usuario y contresena:
        conn = DriverManager.getConnection ("jdbc:oracle:thin:@oracle0.ugr.es:1521/practbd.oracle0.ugr.es", 
                                            "x6067525","x6067525");
        
        System.out.println("Conexion a la base de datos establecida");
    }*/
    
    

    // ************************************************************************
    public int insertData (int numero, String lastName,  int capacidad ) throws Exception
    {
        try
        {
            pstmt = conn.prepareStatement("INSERT INTO pista (numeropista,nombre,capacidad) VALUES (?,?,?)");
            
            pstmt.setInt(1, numero);
            pstmt.setString(2, lastName);
            pstmt.setInt(3, capacidad);

            pstmt.executeUpdate();
            
            //conn.commit();
            
            return 0; // return OK
        }
        catch (SQLException e)
        {
            //System.out.println("Error en INSERT: " + e);
            return 1; // return error
        }
            
    }
}
