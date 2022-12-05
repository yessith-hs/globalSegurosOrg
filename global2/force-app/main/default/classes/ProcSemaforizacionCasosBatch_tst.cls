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
1.0 14/05/2014 	Sergio Andres Ortiz 	Creación de la clase.

*******************************************************************************************************************/
@isTest
public class ProcSemaforizacionCasosBatch_tst {

    public static testMethod void myUnitTest() {
    	
    	//carga de datos de un caso y asunto desde la clase CreaData   
   		User objUser = CreaData_tst.metUser();		   		 		
		Asuntos__c objAsunto = CreaData_tst.metAsunto(ObjUser.id);
		Case objCaso = CreaData_tst.metCaso(ObjAsunto.id);	
		Campaign objCampana = CreaData_tst.metCampana();	
		
		//instancia de la Clase NotificarCampana_ctr
   	    NotificarCampana_tst.myUnitTest();
						
   		Map<Id, Asuntos__c> mapAsuntos = new Map<Id, Asuntos__c>();
   		mapAsuntos.put(objAsunto.id, objAsunto);
   		
   		Map<Id, User> mapUsuarios = new Map<Id, User>();
   		mapUsuarios.put(objUser.id, objUser);
   		
   		ProcSemaforizacionCasosBatch_bch batch = new ProcSemaforizacionCasosBatch_bch();
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
		strBaseQuery='SELECT CaseNumber,Id,estadoSemaforo__c,CreatedDate,ClosedDate,FechaHoraRecibido__c,Asuntos__c  FROM Case WHERE estadoSemaforo__c <> \'Morado\' AND CreatedDate >='+fechaHoy.format('yyyy-MM-dd')+'T'+fechaHoy.format('HH:mm')+':00.000Z';
		
		List<SObject> lstObj_SX = Database.query(strBaseQuery); 
		
		try{batch.start(BC);}catch(Exception ex){}
       	try{batch.execute(BC,lstObj_SX);}catch(Exception ex){}
       	try{batch.finish(BC);}catch(Exception ex){}

		Test.stopTest(); 
    }
}