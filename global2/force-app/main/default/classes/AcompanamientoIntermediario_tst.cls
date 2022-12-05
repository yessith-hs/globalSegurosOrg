@isTest
private class AcompanamientoIntermediario_tst 
{
	
	 public static Contact objContacto                    = new Contact(); 
	 public static Account objCuenta                      = new Account();
	 public static EvaluacionSeguimiento__c objEvaluacion = new EvaluacionSeguimiento__c();
	 //public static List<EvaluacionSeguimiento__c> IdEvaluacion = new List<EvaluacionSeguimiento__c>();
	
	public void prepararDatos()
	{
		
		//Data Cuenta
		objCuenta.Name = 'Cuenta de prueba';
		insert objCuenta;
		System.debug('Cuenta--> ' + objCuenta);
		
		RecordType objrecordtype = [SELECT Id, Name FROM RecordType WHERE sObjectType = 'contact' and Name = 'Asesor'];
		
		//Data Contacto
		objContacto.ClaveNo__c           = 12; 
		objContacto.TipoIntermediario__c = 'Intermediario';
		objContacto.IdExterno__c         = '98765_4321';
		objContacto.LastName             = 'Sánchez Herrera';
		objContacto.NumeroDocumento__c   = '123456';
		objContacto.AccountId            = objCuenta.Id;
		objContacto.RecordTypeId         = objrecordtype.Id;
		insert objContacto;
		System.debug('Contacto--> ' + objContacto);
		
		//Data EvaluacionSeguimiento
		System.debug('antes objEvaluacion--> ' + objEvaluacion);
		objEvaluacion.Name = 'Objeto Evaluacion Seguimiento';
		objEvaluacion.FechaAcompanamiento__c = System.today();
		objEvaluacion.AsesorEvaluado__c   = objContacto.Id;
		insert objEvaluacion;
		System.debug('despues objEvaluacion--> ' + objEvaluacion);
		
		//IdEvaluacion = [SELECT Id FROM EvaluacionSeguimiento__c WHERE Id = :objEvaluacion.Id];
	
	}
	
	static testMethod void myUnitTest() 
    {	
    	System.debug('Entro--> ');
    	AcompanamientoIntermediario_tst objAcompanamiento = new AcompanamientoIntermediario_tst();
    	System.debug('Entro1--> ');
    	objAcompanamiento.prepararDatos();
    	System.debug('Entro2--> ');
        //User objUsuario = [SELECT Id FROM User WHERE Id = :Userinfo.getUserId() ];
        System.debug('Entro3--> ');
        //System.debug('Usuario--> ' + objUsuario);
        /*System.runAs(objUsuario)
        {*/
        	System.debug('Entro4--> ');
        	Test.startTest();
        	System.debug('Entro5--> ');
        	//system.debug('@@parFechaAcompanamiento--> ' + System.now().date());
        	system.debug('@@parAsesorEvaluado--> ' + objContacto.Id);
        	system.debug('@@objEvaluacion.Id--> ' +  objEvaluacion.Id);
        	//IdEvaluacion.get(0).Id
        	AcompanamientoIntermediario_cls.notificarAcompanamiento(objEvaluacion.Id, System.now().date(), objContacto.Id);
        	//AcompanamientoIntermediario_cls.notificarAcompanamiento('Prueba @future', System.now().date(), '1x');
        	Test.stopTest(); 
        //}
    }
}