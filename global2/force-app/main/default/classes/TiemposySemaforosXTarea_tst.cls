/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Sergio Andres Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Probar la clase TiemposSemaforo_tst y verificar que cada uno de sus métodos cumpla efectivamente su tarea.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha Autor Descripción
-------------------------------------------------------------------------------------------------------
1.0 11/04/2014 Sergio Andres Ortiz Creación de la clase.

*******************************************************************************************************************/

@isTest
public class TiemposySemaforosXTarea_tst {
	public static testMethod void myUnitTest() {	
		
		TiemposySemaforosXTarea__c rangoCambioSemaforo = new TiemposySemaforosXTarea__c();
		rangoCambioSemaforo.Name = 'NHorasSemaforo';
		rangoCambioSemaforo.NHorasSemaforo__c = 1;
		insert rangoCambioSemaforo;
        
		//carga de datos de un caso y asunto desde la calse CreaData   		   		 		
		Task objTarea = CreaData_tst.metTarea();
		   		
   		//instancia de la Clase TiemposSemaforo_cls
		TiemposySemaforosXTarea_cls PruebaTarea = new TiemposySemaforosXTarea_cls();   			
		
   		//llamado a los metodos de la clase.   		   		   		
   		PruebaTarea.getTiempoTranscurridoXTarea(objTarea);   		
		PruebaTarea.getEstadoSemaforoXTarea();
		PruebaTarea.setEstadoSemaforoXTarea(objTarea);
		
		//llamada la la creacion y notificacion de campañas.
   		NotificarCampana_tst.myUnitTest();
   		
   		/*
   		TiemposySemaforosXTarea_cls PruebaTarea = new TiemposySemaforosXTarea_cls();   		
		Task objTarea = [SELECT Id,CreatedDate,estadoSemaforo__c,IsClosed,Priority,Status FROM Task WHERE id='00T11000004G2ENEA0'];						
		PruebaTarea.getTiempoTranscurridoXTarea(objTarea);   		
		PruebaTarea.getEstadoSemaforoXTarea();
		PruebaTarea.setEstadoSemaforoXTarea(objTarea);	
        */                               
    }
}