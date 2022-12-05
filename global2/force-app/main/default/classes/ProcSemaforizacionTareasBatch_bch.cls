/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Sergio Andres Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Proceso Batch para la actualización masiva de las Tareas del caso según la lógica aplicada en la clase TiemposySemaforosXTarea_cls

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha Autor Descripción
-------------------------------------------------------------------------------------------------------
1.0 19/04/2014 Sergio Andres Ortiz Creación de la clase.

*******************************************************************************************************************/

global class ProcSemaforizacionTareasBatch_bch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
	public String batchID1{get;set;}
	global ProcSemaforizacionTareasBatch_bch(){	 
		
	}
	
	global database.querylocator start(Database.BatchableContext BC){
		//se cargan los casos, exepto aquellos que tienen el estado del semaforo en morado
		string strBaseQuery='SELECT Id,CreatedDate,estadoSemaforo__c,IsClosed,Status,AccountId FROM Task WHERE estadoSemaforo__c <> \'Morado\'';					
		system.debug('==>strBaseQuery'+strBaseQuery);
		
		return Database.getQueryLocator(strBaseQuery);
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		
		List<Task> lstTask = new List<Task>();	
		
		lstTask=(List<Task>)scope;
		
		TiemposySemaforosXTarea_cls objTiemposSemaforo = new TiemposySemaforosXTarea_cls();
		//se itera llamando a los metodos de la clase con los datos de cada caso.
		for(Task objTarea: lstTask){
			objTiemposSemaforo.getTiempoTranscurridoXTarea(objTarea); 
			objTiemposSemaforo.getEstadoSemaforoXTarea();
			objTiemposSemaforo.setEstadoSemaforoXTarea(objTarea);						
		}
		system.debug('@@@objTiemposSemaforo->'+objTiemposSemaforo);
		system.debug('@@@lstTask->'+lstTask);
		update lstTask; 
	}
	
	global void finish(Database.BatchableContext BC){		
        EjecutorBatchSemaforoTarea_sch ia=new EjecutorBatchSemaforoTarea_sch(); 
        DateTime fechaActual= System.now().addHours(8);
        Integer minutos=fechaActual.minute();
        Integer hora=fechaActual.hour();
        Integer dia=fechaActual.day();
        integer mes=fechaActual.month();
        Integer anio=fechaActual.year();
        
        //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        String sch = '0 '+minutos+' '+hora+' '+dia+' '+mes+' ? '+anio;
        if (!Test.isRunningTest()){
            this.batchID1=System.schedule('Batch de Calculo de Semaforos por Casos Cont.. '+System.now(), sch, ia);
        }     		
	}
}