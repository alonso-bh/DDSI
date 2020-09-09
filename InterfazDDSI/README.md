# Proyecto

## ¿Cómo probar la app?

Debido a que la parte obligatoria del proyecto era sólo el desarrollo de la app con una interfaz textual, ésta está completamente funcional, pero la ídem gráfica, que se ha desarrollado con posterioridad a la evaluación y corrección del proyecto está aún inacabada (falta únicamente la ventana del Subsistema 4). Por eso, se detalla a continuación cómo se puede probar de una forma muy simple esta aplicación al completo, aunque de una forma "rudimentaria".

Una vez se conecta a la red VPN de la UGR (en caso de ser miembro), puede ejecutar los ficheros Java llamados "Consultas.java" y "ConsultasSX.java", con X en {2,3,4}. Cada fichero se corresponde con una interfaz textual (es decir, en línea de comandos) para probar la funcionalidad implementada de ese subsistema. 

Si no se puede acceder a la VPN referida, o bien se produce algún error, siempre se puede modificar el código de nuestro programa para conectarse a otra base de datos relacional y poder hacer las pruebas en cada uno de los cuatro ficheros JAVA referidos (evidentemente, antes habrá que ejecutar el script SQL que hemos elaborado para crear las tablas relacionales, rellenarlas con datos de prueba y lanzar los disparadores implementados). Si se usa el script proporcionado en el repositorio, se recomienda revisarlo antes de lanzarlo, para crear únicamente lo que queremos, dejando comentadas o borrando el resto de sentencias SQL. 

Posteriormente se desarrollará la documentación para la interfaz gráfica cuando ésta esté completada y funcional, y el ejecutable de la app listo. 
