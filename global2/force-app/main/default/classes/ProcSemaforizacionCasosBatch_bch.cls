/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Sergio Andres Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Proceso Batch para la actualización masiva de los casos según la lógica aplicada en la clase TiemposySemaforosXCaso_cls

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha Autor Descripción
------------------------------------------------------------------------------------------------------- 
1.0 11/04/2014 Sergio Andres Ortiz Creación de la clase.

*******************************************************************************************************************/

global class ProcSemaforizacionCasosBatch_bch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
	public String batchID1{get;set;}
	global ProcSemaforizacionCasosBatch_bch(){	 
		
	}
	
	global database.querylocator start(Database.BatchableContext BC){
		//se cargan los casos, exepto aquellos que tienen el estado del semaforo en morado
		string strBaseQuery='SELECT CaseNumber,Id,estadoSemaforo__c,CreatedDate,ClosedDate,FechaHoraRecibido__c,Asuntos__c,Poliza__c,Producto__c FROM Case WHERE estadoSemaforo__c <> \'Morado\' and Status<>\'Cerrado\' order by CreatedDate Desc';					
		system.debug('==>strBaseQuery'+strBaseQuery);
		
		return Database.getQueryLocator(strBaseQuery);
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		
		List<Case> lstCase = new List<Case>();	
		
		lstCase=(List<Case>)scope;
		
		TiemposySemaforosXCaso_cls objTiemposSemaforo = new TiemposySemaforosXCaso_cls();
		//se itera llamando a los metodos de la clase con los datos de cada caso.
		for(Case objCaso: lstCase){
			objTiemposSemaforo.getTiempoTranscurridoXCaso(objCaso); 
			objTiemposSemaforo.getEstadoSemaforoXCaso(objCaso);					
		}
		system.debug('@@@objTiemposSemaforo->'+objTiemposSemaforo);
		system.debug('@@@lstCase->'+lstCase);
		update lstCase; 
		
		objTiemposSemaforo.setUsuarioBackUpenCasos();
		
	}
	
	global void finish(Database.BatchableContext BC){		
        EjecutorBatchSemaforoCasos_sch ia=new EjecutorBatchSemaforoCasos_sch(); 
        DateTime fechaActual= System.now().addHours(1);
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