/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 * @version 2.0 Katherine Moreno Modificacion
 */
@isTest
private class GetUrlCotizador_tst {
	
	public static Account createAccount(Account objAccount,String lastName,String idRecord,String noDocumento){
		objAccount.LastName 										= lastName;
		Date fecha 													= date.newInstance(1972, 1, 23);  
		objAccount.PersonBirthdate									= fecha;
		objAccount.RecordTypeId										= idRecord;
		objAccount.TipoDocumento__c									= 'CEDULA DE CIUDADANIA';
		objAccount.NumeroDocumento__c								= noDocumento;
		insert objAccount;
		return objAccount;
	}
	
	public static Opportunity createOpportunity(Account objAccount,Account objAccount2){
		Opportunity objOpportunity									= new Opportunity();
		objOpportunity.Name											= 'Oportunidad Prueba';
		objOpportunity.AccountId									= objAccount.Id;
		Date fechaCierre 											= date.newInstance(2014, 8, 20);
		objOpportunity.CloseDate 									= System.today()+1;
		objOpportunity.StageName									= 'Prospección';
		objOpportunity.AccountId									= objAccount.id;
		objOpportunity.BeneficiarioAsegurado__c						= objAccount.id;
		objOpportunity.Designado__c									= objAccount2.id;
		insert objOpportunity;
		return objOpportunity;
	}
	
	public static RelacionProductoCotizador__c createCustomConfigs (){
		/*Creación configuraciones personalizadas*/
		
		RelacionProductoCotizador__c objRelacionProductoCotizador 	= new RelacionProductoCotizador__c();
		objRelacionProductoCotizador.Name							= '60_1';
		objRelacionProductoCotizador.Descripcion__c					= 'Global Protección Garantizada';
		objRelacionProductoCotizador.ListaCotizadore__c				= 'CotProGar';
		insert objRelacionProductoCotizador;
		
		URLCotizador__c objURLCotizador								= new URLCotizador__c();
		objURLCotizador.Name										= 'CotProGar';
		objURLCotizador.Descripcion__c								= 'Adición de Semestres';
		objURLCotizador.URL__c										= 'https://transac.globalseguroscolombia.com/CotizadoresSF/Inicio.aspx?Cot=6&Param=';
		insert objURLCotizador;
		return objRelacionProductoCotizador;
	}
	
	public static void createConfigAes(){
		List <ParametrosEncripcionAES128__c> my_list = new List <ParametrosEncripcionAES128__c>();
    	ParametrosEncripcionAES128__c objConfiguracion = new ParametrosEncripcionAES128__c();
		objConfiguracion.Name = 'InitializationVector';
		objConfiguracion.Valor__c = '6QAZ2WSX6EDC4RFV';
		my_list.add(objConfiguracion);
		ParametrosEncripcionAES128__c objConfiguracion2 = new ParametrosEncripcionAES128__c();
		objConfiguracion2.Name = 'EncryptionKey';
		objConfiguracion2.Valor__c = '6QAZ2WSX6EDC4RFV';
		my_list.add(objConfiguracion2);
		insert my_list;    	
	}
	
	public static void createParametros(){
		List <Parametros__c> my_list 								= new List <Parametros__c>();
		Parametros__c objParams 									= new Parametros__c();
		objParams.Name												='parametros1';
		my_list.add(objParams);
		Parametros__c objParams2 									= new Parametros__c();
		objParams2.Name												='parametros2';
		my_list.add(objParams2);
		insert my_list;
	}
	
	public static void createPoliza(){
    	Poliza__c objPoliza											= new Poliza__c();
    	objPoliza.TieneSeguroVida__c								= true;
    	objPoliza.Financiada__c										= true;
    	objPoliza.TieneAhorro__c									= true;
    	insert objPoliza;
    }
	
    static testMethod void getListaCotizadores() {
    	Id record1 													= [SELECT Id FROM RecordType where name='Beneficiario' limit 1].id;
    	Id record2 													= [SELECT Id FROM RecordType where name='Persona Natural' limit 1].id;
    	createConfigAes();
    	RelacionProductoCotizador__c objRelacionProductoCotizador 	= new RelacionProductoCotizador__c();
    	objRelacionProductoCotizador=createCustomConfigs();
    	Account objAccount 											= new Account();
		objAccount 													= createAccount(objAccount,'Macea',record1,'123456789');
		System.debug('<----Los objetos'+ objAccount.id);
		Account objAccount2											= new Account();
		objAccount2 												= createAccount(objAccount2,'Moreno',record2,'987654321');
		System.debug('<----Los objetos'+ objAccount2.id);
		Opportunity objOpportunity									= new Opportunity();
		objOpportunity												= createOpportunity(objAccount,objAccount2);
		
		test.startTest();
		
		GetUrlCotizador_cls objCotizador 							= new GetUrlCotizador_cls();
		objCotizador.getListaCotizadores(objOpportunity.id,'2',objRelacionProductoCotizador.Name);
		
		test.stopTest();
		//getRamoProductoPoliza
    }
    
    static testMethod void getCodigoTipoDocumento (){
    	test.startTest();
    	
    	GetUrlCotizador_cls objCotizador 							= new GetUrlCotizador_cls();
    	objCotizador.getCodigoTipoDocumento('Documento');
    	createParametros();
    	objCotizador.getCodigoTipoDocumento('Documento');
    	
    	test.stopTest();
    }
    
    static testMethod void getRamoProductoPoliza(){
    	Id record1 													= [SELECT Id FROM RecordType where name='Beneficiario' limit 1].id;
    	Id record2 													= [SELECT Id FROM RecordType where name='Persona Natural' limit 1].id;
    	Account objAccount 											= new Account();
		objAccount 													= createAccount(objAccount,'Macea',record1,'123456789');
		System.debug('<----Los objetos'+ objAccount.id);
		Account objAccount2											= new Account();
		objAccount2 												= createAccount(objAccount2,'Moreno',record2,'987654321');
		System.debug('<----Los objetos'+ objAccount2.id);
		Opportunity objOpportunity									= new Opportunity();
		objOpportunity												= createOpportunity(objAccount,objAccount2);
		createParametros();
		
		test.startTest();
		
		GetUrlCotizador_cls objCotizador 							= new GetUrlCotizador_cls();
		objCotizador.getRamoProductoPoliza(objOpportunity.id);
		createPoliza();
		objCotizador.getRamoProductoPoliza(objOpportunity.id);
		
		test.stopTest();
    }
}