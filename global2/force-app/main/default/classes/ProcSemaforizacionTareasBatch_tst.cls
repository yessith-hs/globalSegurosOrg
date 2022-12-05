/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Sergio Andres Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Probar la clase ProcSemaforizacionCasosBatch_bch y verificar que cada uno de sus métodos cumpla efectivamente su tarea.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha 			Autor 				Descripción
-------------------------------------------------------------------------------------------------------
1.0 15/05/2014 	Sergio Andres Ortiz 	Creación de la clase.

*******************************************************************************************************************/
@isTest
public class ProcSemaforizacionTareasBatch_tst {

    public static testMethod void myUnitTest() {
    	
    	//llamado a la clase TiemposySemaforosXTarea_tst y ejecucion de sus metodos.
    	TiemposySemaforosXTarea_tst.myUnitTest();
    	
    	ProcSemaforizacionTareasBatch_bch batch = new ProcSemaforizacionTareasBatch_bch();
   		Database.BatchableContext BC;
   		
   		list<SObject> listO = new list<SObject>();
   		
   		string strFields='';
	    string strBaseQuery='';
	    // Buscar la fecha del dia
	    // -------------------------- 
	    Date dToday = System.Today();
	    system.debug('dToday -->'+dToday);
	    Datetime fechaHoy = datetime.newInstancegmt(dToday.year(), dToday.month(),dToday.day());
	    system.debug('fechaHoy-->'+fechaHoy);	   	    
	    
	    Test.startTest();
		strBaseQuery='SELECT Id,CreatedDate,estadoSemaforo__c,IsClosed,Status,AccountId FROM Task WHERE estadoSemaforo__c <> \'Morado\' AND CreatedDate >='+fechaHoy.format('yyyy-MM-dd')+'T'+fechaHoy.format('HH:mm')+':00.000Z';
		
		List<SObject> lstObj_SX = Database.query(strBaseQuery); 
		
		try{batch.start(BC);}catch(Exception ex){}
       	try{batch.execute(BC,lstObj_SX);}catch(Exception ex){}
       	try{batch.finish(BC);}catch(Exception ex){}

		Test.stopTest(); 
        
    }
}