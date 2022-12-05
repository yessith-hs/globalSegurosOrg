/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Dolly Fierro Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Probar la clase Cotizador_ctr.cls y verificar que cada uno de sus métodos cumpla efectivamente su tarea.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha 			 Autor 		 		 Descripción
-------------------------------------------------------------------------------------------------------
1.0 01/07/2014 		Dolly Fierro Ortiz 	Creación de la clase.
2.0 03/07/2014 		Julio Mario Moreno 	Modificación
3.0 08/02/2016		Katherine Moreno	Modificación
*******************************************************************************************************************/

@isTest(SeeAllData=true)
private class Cotizador_ctr_tst {
	
	public static Account createAccount(){
		Account objAccount											= new Account();
		objAccount.RecordTypeId 									= [SELECT Id FROM RecordType where name='Beneficiario' limit 1].id;
		objAccount.LastName 										= 'Macea';
		Date fecha 													= date.newInstance(1972, 1, 23);  
		objAccount.PersonBirthdate									= fecha;
		insert objAccount;
		return objAccount;
	}
	
	public static Opportunity createOpportunity(Account objAccount,Pricebook2 standard){
		Opportunity objOpportunity									= new Opportunity();
		objOpportunity.Name											= 'Oportunidad Prueba';
		objOpportunity.AccountId									= objAccount.Id;
		Date fechaCierre 											= date.newInstance(2014, 8, 20);
		objOpportunity.CloseDate 									= System.today()+1;
		objOpportunity.StageName									= 'Prospección';
		objOpportunity.AccountId									= objAccount.id;
		objOpportunity.BeneficiarioAsegurado__c						= objAccount.id;
		insert objOpportunity;
		return objOpportunity;
	}
	
	public static void createQuote(Opportunity objOpportunity)
	{
		Quote objQuote												= new Quote(); 		
		objQuote.anexoinvalideztotalpermanente__c					= false;
		objQuote.anexosmuerteaccidental__c							= false;
		objQuote.financiada__c										= false;
		objQuote.anexoenfermedadesgraves__c 						= false;
		objQuote.name												= 'Prueba quote';
		objQuote.OpportunityId										= objOpportunity.id;
		insert objQuote;
	}
	
	public static void createPoliza(Opportunity objOpportunity){
		Poliza__c objPoliza											= new Poliza__c();
		objPoliza.Name												= 'Poliza';
		objPoliza.Oportunidad__c									= objOpportunity.id;
		insert objPoliza;
	}
	
	public static void createCampaign(){
		Ciudades__c objCiudad			= new Ciudades__c(); 
    	objCiudad.Name					= 'ciudad3';
    	objCiudad.esmunicipio__c		= true;
    	objCiudad.espais__c				= false;
    	objCiudad.EsRegion__c			= false;
    	objCiudad.EsDepartamento__c		= false;
    	objCiudad.Codigo__c				= '2_4545';
    	insert objCiudad;
    	
		Date fecha;
		Campaign objCampaign										= new Campaign();
		objCampaign.RecordTypeId									= [SELECT Id FROM RecordType where name='Campaña' limit 1].id;
		objCampaign.Name											= 'Campaña Prueba';
		objCampaign.Status											= 'Planeada';
		fecha = date.today().addDays(10);
		objCampaign.StartDate 										= fecha;
		fecha = date.today().addDays(40);
		objCampaign.EndDate											= fecha;
		objCampaign.Type											= 'Conferencia';
		objCampaign.Description										= 'Descripción de Campaña de prueba';
		objCampaign.Ciudad__c										= objCiudad.Id;
		objCampaign.CodigoCampana__c='11';
		insert objCampaign;
	}
	public static list<Product2> createProduct2(){
		list<Product2>listaProductos								= new list<Product2>();							
		Product2 objProduct2										= new Product2();
		objProduct2.Name											= 'prueba producto';
		objProduct2.IdentificadorProducto__c        				= 'GE698';
		objProduct2.ProductCode                          			= '60_1';
		objProduct2.Compania__c										= 'Global Seguros';
		Product2 objProduct22										= new Product2();
		objProduct22.Name											= 'prueba producto2';
		objProduct22.IdentificadorProducto__c        				= 'GE698';
		objProduct22.ProductCode                          			= '60_1';
		objProduct22.Compania__c									= 'Global Seguros';
		Product2 objProduct23										= new Product2();
		objProduct23.Name											= 'prueba producto3';
		objProduct23.IdentificadorProducto__c        				= 'GE698';
		objProduct23.ProductCode                          			= '60_1';
		objProduct23.Compania__c									= 'Global Seguros';
		listaProductos.add(objProduct2);
		listaProductos.add(objProduct22);
		listaProductos.add(objProduct23);
		insert listaProductos;
		return listaProductos;
	}
	
	public static Pricebook2 createPricebook2(){
		Pricebook2 objPricebook2									= new Pricebook2();
		objPricebook2.Name											= 'prueba price';
		//objPricebook2.IsStandard = true;
		insert objPricebook2;
		return objPricebook2;
	} 
	
	public static PricebookEntry createPricebookEntry(list<Product2> objProduct2,Pricebook2 objPricebook2){
		
		PricebookEntry objPricebookEntry							= new PricebookEntry();
		objPricebookEntry.IsActive 									= true;
		objPricebookEntry.UnitPrice									= 150;
		objPricebookEntry.pricebook2id              				= objPricebook2.Id;//Test.getStandardPricebookId();
		objPricebookEntry.product2id								= objProduct2.get(0).id;
		
		insert objPricebookEntry;
		return objPricebookEntry;
	}
	
	public static void createOpportunityLineItem(Opportunity objOpportunity, PricebookEntry objPricebookEntry){
		OpportunityLineItem objOpportunityLineItem					= new OpportunityLineItem();
		objOpportunityLineItem.Quantity             				= 1;
		objOpportunityLineItem.OpportunityId						= objOpportunity.id;
		objOpportunityLineItem.TotalPrice							= 100000;
		objOpportunityLineItem.PricebookEntryId						= objPricebookEntry.id;
		insert objOpportunityLineItem;
	}
	
	public static void createCustomConfigs (){
		/*Creación configuraciones personalizadas*/
		
		RelacionProductoCotizador__c objRelacionProductoCotizador 	= new RelacionProductoCotizador__c();
		objRelacionProductoCotizador.Name							= '60_1';
		objRelacionProductoCotizador.Descripcion__c					= 'Global Protección Garantizada';
		objRelacionProductoCotizador.ListaCotizadore__c				= 'CotProGar';
		insert objRelacionProductoCotizador;
		
		URLCotizador__c objURLCotizador								= new URLCotizador__c();
		objURLCotizador.Name										= 'CotAdiSem';
		objURLCotizador.Descripcion__c								= 'Adición de Semestres';
		objURLCotizador.URL__c										= 'https://transac.globalseguroscolombia.com/CotizadoresSF/Inicio.aspx?Cot=6&Param=';
		insert objURLCotizador;
	}
	
	public static void updateConfigs (){
		RelacionProductoCotizador__c objProdCot						= [SELECT Id,Name,ListaCotizadore__c FROM RelacionProductoCotizador__c WHERE Name='60_1' limit 1];
		objProdCot.ListaCotizadore__c								= 'CotProGar,CotProGarV2,CotSegEdc';
		update objProdCot;
	}
	
	public static testMethod void testRunAs() { 
		updateConfigs();
		Pricebook2 standard = [Select Id, Name, IsActive From Pricebook2 where isStandard = true LIMIT 1];
    	Pricebook2 objPricebook2									= createPricebook2(); 
		User u 														= new User();
		u 															= [SELECT Id,LastName,Email FROM User WHERE isActive=true limit 1];
		
		Account objAccount 											= new Account();
		objAccount 													= createAccount();
		Opportunity objOpportunity									= new Opportunity();
		objOpportunity												= createOpportunity(objAccount,standard);
		createPoliza(objOpportunity);
		list<Product2> objProduct2									= createProduct2();
        PricebookEntry objPricebookEntry							= createPricebookEntry(objProduct2, standard);
		ApexPages.StandardController sc 							= new ApexPages.StandardController(objOpportunity);
		createCampaign();
		//createCustomConfigs();
		createOpportunityLineItem(objOpportunity,objPricebookEntry);
        createQuote(objOpportunity); 
		 
		Cotizador_ctr objCotizador 									= new Cotizador_ctr(sc);
		objCotizador.cotizarEducativo();
		objCotizador.cotizarVidaPensiones();
		objCotizador.displayError('prueba');
		objCotizador.validatePermission(false,'profile','http','accion','mensaje');
		//objCotizador.getHost();
	}
	public static testMethod void testRunAs2() { 
		try{
			Pricebook2 standard = [Select Id, Name, IsActive From Pricebook2 where isStandard = true LIMIT 1];
    		Pricebook2 objPricebook2									= createPricebook2(); 
			Account objAccount 											= new Account();
			objAccount 													= createAccount();
			Opportunity objOpportunity									= new Opportunity();
			objOpportunity												= createOpportunity(objAccount,standard);
			ApexPages.StandardController sc 							= new ApexPages.StandardController(objOpportunity);
			Cotizador_ctr objCotizador 									= new Cotizador_ctr(sc);
		}catch (Exception e){
			System.debug('Exception testRunAs2'+e);
		}
	}
}