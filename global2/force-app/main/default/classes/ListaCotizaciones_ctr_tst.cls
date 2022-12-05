/*******************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Luis Macea Zabaleta
Proyecto:                Global     
Descripción:             Clase de pruaba del controlador SendMailCase_ctr  implementa la lógica de negocio para realizar las siguientes operaciones
                         -  Crear los objetos para la prueba.
                         -  Ejecutar el método de  envio de email.
User history:          
Sprint                 
Release                 

Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------        
1.0     01/07/2014   Julio Mario Moreno             Creación de la clase.
*******************************************************************************/
@isTest(SeeAllData=true)
private class ListaCotizaciones_ctr_tst {
	
	public static Opportunity createOpportunity(Pricebook2 standard)
	{
		Date fecha 												= system.today();
		Date fecha2 											= fecha.addDays(1);								
		Opportunity objOpportunity								= new Opportunity();
		objOpportunity.CloseDate                    			= fecha2;		
		objOpportunity.Name										= 'Oportunidad';
		objOpportunity.StageName								= 'Cotización';	
		objOpportunity.Pricebook2Id								= standard.id;
		insert objOpportunity;
		return objOpportunity;		
	}
	
	public static void createQuote(Opportunity objOpportunity)
	{
		Quote objQuote											= new Quote(); 		
		objQuote.anexoinvalideztotalpermanente__c				= false;
		objQuote.anexosmuerteaccidental__c						= false;
		objQuote.financiada__c									= false;
		objQuote.anexoenfermedadesgraves__c 					= false;
		objQuote.name											= 'Prueba quote';
		objQuote.OpportunityId									= objOpportunity.id;
		insert objQuote;
	}
	
	public static Product2 createProduct2(){
		Product2 objProduct2									= new Product2();
		objProduct2.Name										= 'prueba producto';
		objProduct2.IdentificadorProducto__c       				= 'GE698';
		objProduct2.ProductCode									= 'GE698';
		objProduct2.Compania__c									= 'Global Seguros';
		insert objProduct2;
		return objProduct2;
	}
	
	public static Pricebook2 createPricebook2(){
		Pricebook2 objPricebook2								= new Pricebook2();
		objPricebook2.Name										= 'prueba price';
		//objPricebook2.IsStandard = true;
		insert objPricebook2;
		return objPricebook2; 
	} 
	
	public static PricebookEntry createPricebookEntry(Product2 objProduct2,Pricebook2 objPricebook2){
		PricebookEntry objPricebookEntry						= new PricebookEntry();
		objPricebookEntry.UseStandardPrice						= false;
		objPricebookEntry.IsActive 								= true;
		objPricebookEntry.UnitPrice								= 0;
		objPricebookEntry.pricebook2id              			= objPricebook2.id;
		objPricebookEntry.product2id							= objProduct2.id;
		insert objPricebookEntry;
		return objPricebookEntry;
	}
	
	public static void createOpportunityLineItem(Opportunity objOpportunity, PricebookEntry objPricebookEntry){
		OpportunityLineItem objOpportunityLineItem				= new OpportunityLineItem();
		objOpportunityLineItem.Quantity             			= 1;
		objOpportunityLineItem.OpportunityId					= objOpportunity.id;
		objOpportunityLineItem.TotalPrice						= 100000;
		objOpportunityLineItem.PricebookEntryId					= objPricebookEntry.id;
		//objOpportunityLineItem.ProductCode						= '60_1';
		insert objOpportunityLineItem;
	}
	
    static testMethod void myUnitTest() {
    	Pricebook2 standard = [Select Id, Name, IsActive From Pricebook2 where isStandard = true LIMIT 1];
    	Pricebook2 objPricebook2								= createPricebook2(); 
        Opportunity objOpportunity								= createOpportunity(standard);
        Product2 objProduct2									= createProduct2();
        PricebookEntry objPricebookEntry						= createPricebookEntry(objProduct2, standard);
        createOpportunityLineItem(objOpportunity,objPricebookEntry);
        createQuote(objOpportunity);       
        
      	ApexPages.StandardController controller 				= new ApexPages.StandardController(objOpportunity);
	  	ListaCotizaciones_ctr cotizaCtr							= new ListaCotizaciones_ctr(controller);
	  	ListaCotizaciones_ctr.getIdEntradaListaPrecio(objPricebookEntry.id);
	  	ListaCotizaciones_ctr.getCodProducto(objProduct2.IdentificadorProducto__c);
    }
}