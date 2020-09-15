/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interfazddsi;

//Para que funcione tiene que estar en la misma carpeta que este archivo el ojdbc8.jar
//Para compilar: javac -classpath ojdbc8.jar Consultas.java
//Para ejecutar: java -cp .:ojdbc8.jar Consultas

import java.sql.*;
import java.sql.SQLException.*;
import java.util.Scanner;
import oracle.jdbc.driver.*;
import java.util.Date;



public class ConsultasS4 extends Consultas {



    /*public static void main(String[] args) throws Exception{

        int numero_edicion = -1;
	String hora = new String();

	String[] trabajadores_libres = new String[20];

        final Scanner in = new Scanner (System.in);

        ConsultasS4 consultas = new ConsultasS4();

        consultas.initialize();

        //A partir de aqui depende de la interfaz que tenga cada uno:

	//introducir edicion correcta
        System.out.println("Introduzca numero de edicion: ");
        while(numero_edicion < 0){
            numero_edicion = Integer.parseInt(in.nextLine());

            if (numero_edicion < 0)
                System.out.println("Numero de edicion introducido no valido. Por favor, introduzcalo de nuevo: ");
        }


	System.out.println("Introducir numero de hora (dd/mm/yyyy hh:mi:ss)");
	hora=in.nextLine();

        trabajadores_libres = consultas.consultaTrabajadoresLibres(numero_edicion, hora);

        System.out.println("\nLos trabajadores libres para realizar el trabajo en el dia y hora " + hora +" son:\n");

	for(int i=0; i< 20 ; i++){
		if (trabajadores_libres[i] != null)
			System.out.println( trabajadores_libres[i] + "\n");
	}
    } */ 

   

    /**************************************************************************/
    //Esta es la funcion donde se hace la consulta
    public String[] consultaTrabajadoresLibres(int numero_edicion, String hora) throws Exception {

        String[] trabajadores_libres = new String[20];
	int j=0;

        stmt = conn.createStatement ( );

        ResultSet rset = stmt.executeQuery ("SELECT dni FROM TrabajaEn where numero = '" + numero_edicion + "'");
	//ResultSet rset = stmt.executeQuery ("SELECT dni FROM TrabajaEn NATURAL JOIN TrabajadorAsignadoA MINUS (SELECT dni from TrabajaEn NATURAL JOIN TrabajadorAsignadoA where horaInicio < '" + TO_DATE(hora, 'dd/mm/yyyy hh:mi:ss') + "' AND horaFin > '" + TO_DATE(hora, 'dd/mm/yyyy hh:mi:ss') + "' )");

        while (rset.next ()) {
            trabajadores_libres[j]=rset.getString(1);
	    j++;
        }

        return trabajadores_libres;
    }
}
