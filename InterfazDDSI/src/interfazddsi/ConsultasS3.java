/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interfazddsi;

//Para que funcione tiene que estar en la misma carpeta que este archivo el ojdbc8.jar
//Para compilar: javac -classpath ojdbc8.jar ConsultasS3.java
//Para ejecutar: java -cp .:ojdbc8.jar ConsultasS3
import java.awt.Container;
import java.awt.event.*;
import java.sql.*;
import java.sql.SQLException.*;
import java.util.Scanner;
import oracle.jdbc.driver.*;
import java.util.*;
import java.text.SimpleDateFormat;
import java.util.Date;

import java.util.Scanner;

public class ConsultasS3 extends Consultas {
    
    PreparedStatement pstmt;     

    /*public static void main(String[] args) throws Exception{
	 
	String aux = new String();
        String dniTrabajador = new String();
	int edicion = -1;
	int numeroPedido = -1; 
//	Fecha date = new Date();

        Scanner in = new Scanner (System.in);
        
        ConsultasS3 interfaz = new ConsultasS3();

        interfaz.initialize();
        
	//Leemos el dni del trabajador
	System.out.println("Introduzca el dni del trabajdor: ");
	dniTrabajador = in.nextLine();

	//Leemos el numero de la edicion
	System.out.println("Introduzca el numero de la edicion: ");
	aux = in.nextLine();
	edicion = Integer.parseInt(aux);

	//Leemos el numero de pedido
	System.out.println("Introduzca el numero del pedido: ");
	aux = in.nextLine();
	numeroPedido = Integer.parseInt(aux);

	//Leemos la fecha
	System.out.println("Introduzca la fecha de entrega (formato dd/mm/yyyy): ");
	String fecha = in.nextLine();
	SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
	Date testDate = null;
	String date = fecha;
	try{
		testDate = df.parse(date);
		System.out.println("Se ha registrado la fecha indicada, "+testDate);
	} catch (Exception e){System.out.println("invalid format");}

	if (!df.format(testDate).equals(date)){
		System.out.println("invalid date!!");
	}
	else{
		System.out.println("valid date!!");
	}

	//Insertamos los datos en la base de datos
	//A partir de aqui depende de la interfaz que tenga cada uno
        interfaz.insertData(numeroPedido, date, edicion, dniTrabajador); 

        // comprobando el INSERT
        int result = interfaz.insertData(numeroPedido, date, edicion, dniTrabajador); 
        System.out.println("result = " +result); 
        if (result != 0)
        {
            System.out.println("ERROR al introducir los campos");
            System.exit(1) ; 
        } 
               
        System.out.println("Fila insertada correctamente");	

    }*/ 
    
    

    //Funcion para insertar los datos en la tabla 
    public int insertData (int numeroPedido, String fecha, int edicion, String dniTrabajador ) throws Exception
    {
        try
        {
            pstmt = conn.prepareStatement("INSERT INTO Entrega (numerodepedido,fechaentrega,numero,dni) VALUES (?,to_date(?, 'dd/mm/yyyy'),?,?)");
   
            pstmt.setInt(1, numeroPedido);
            pstmt.setString(2, fecha);
            pstmt.setInt(3, edicion);
	    pstmt.setString(4, dniTrabajador);
            pstmt.executeUpdate();
            //conn.commit();
            
            return 0; // return OK
        }
        catch (SQLException e)
        {
            //System.out.println("Error en INSERT: " + e);
            return 0; // return error
        }
            
    }

}
