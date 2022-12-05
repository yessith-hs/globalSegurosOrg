/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Dolly Fierro Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Probar la clase ConectividadWS.cls y verificar que cada uno de sus métodos cumpla efectivamente su tarea.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha 			 Autor 		 		 Descripción
-------------------------------------------------------------------------------------------------------
1.0 11/07/2014 		Julio Mario Moreno 	Modificación	
*******************************************************************************************************************/
@isTest
private class ConectividadWS_tst {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        ConectividadWS.probarConectividad('prueba');
    }
}