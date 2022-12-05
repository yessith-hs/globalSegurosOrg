/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Sergio Andres Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Probar la clase EjecutorBatchSemaforoTarea_sch y verificar que cada uno de sus métodos cumpla efectivamente su tarea.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha 		Autor 				Descripción
-------------------------------------------------------------------------------------------------------
1.0 15/05/2014 Sergio Andres Ortiz Creación de la clase.

*******************************************************************************************************************/
@isTest
public class EjecutorBatchSemaforoTarea_tst {

    public static testMethod void myUnitTest() {
		//llamada la la creacion y notificacion de campañas.
   		NotificarCampana_tst.myUnitTest();
 		  		
   		ProcSemaforizacionTareasBatch_tst.myUnitTest();   		   	
   		EjecutorBatchSemaforoTarea_sch ejecutorSh = new EjecutorBatchSemaforoTarea_sch();
   		SchedulableContext sc;
   		ejecutorSh.execute(sc);        

    }
}