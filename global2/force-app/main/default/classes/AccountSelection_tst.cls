/*******************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Luis Macea Zabaleta
Proyecto:                Global     
Descripción:             Clase de pruaba del controlador AccountSelection_ctr  implementa la lógica de negocio para realizar las siguientes operaciones
                         -  Crear los objetos para la prueba.
                         -  Ejecutar la carga del combobox
                        
User history:          
Sprint                 
Release                 

Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     10/07/2014   Luis Macea Zabaleta            Creación de la clase.

*******************************************************************************/
@IsTest(SeeAllData=true)
private class AccountSelection_tst {
    
    public static Account createBeneficiario()
    {
        Account accb		   	=		new Account();
        accb.LastName		    =		'Baca';
        accb.NumeroDocumento__c	=		'0252555555555';
     
        Date fecha 				=		 date.newInstance(1972, 1, 23);  
		accb.PersonBirthdate	= fecha;
        insert accb;
        return accb;
    }
    
    public static Account createTomador()
    {
        Account acct				=		new Account();
        acct.LastName				=		'Ramos';
        acct.NumeroDocumento__c		=		'21652525545';
       
        Date fecha 					= 		date.newInstance(1972, 1, 23);  
		acct.PersonBirthdate	 	= 		fecha;
        insert acct;
        return acct;
     }
    
     public static Account createDesignado()
     {
      	Account accd				=		new Account();
        accd.LastName				=		'Macea';
        accd.NumeroDocumento__c		=		'6924587555';
       
        Date fecha 					= 		date.newInstance(1972, 1, 23);  
		accd.PersonBirthdate	 	= 		fecha;
        insert accd;
        return accd;
     }
     
      public static Account createAsegurado()
     {
      	Account accd				=		new Account();
        accd.LastName				=		'Peña';
        accd.NumeroDocumento__c		=		'2577876468';
       
        Date fecha 					= 		date.newInstance(1972, 1, 23);  
		accd.PersonBirthdate	 	= 		fecha;
        insert accd;
        return accd;
     }
     
    
    public static Poliza__c CreatePoliza(Account beneficiario,Account tomador,Account designado,Account asegurado)
    {
     	Poliza__c pol				=		new Poliza__c();
     	pol.Carrera__c 				= 		'Derecho';
		pol.TieneAhorro__c 			= 		true;
		pol.Financiada__c 			= 		true;
		pol.TieneSeguroVida__c 		= 		true;		
     	pol.EmpresaProducto__c		=		'Global Seguros';
     	pol.NombreBeneficiario__c	=		beneficiario.Id;
        pol.Nombre_Tomador__c       =       tomador.Id;
        pol.NombreDesignado__c      =       designado.Id;
        pol.Asegurado__c            =       asegurado.Id;
        insert pol;
        return pol;    
    }
    
    static testMethod void myUnitTest() {
       Account beneficiario 	=   new Account();
               beneficiario		=	createBeneficiario(); 
               	
       Account tomador			=	new Account();
               tomador			=	createTomador();
                
       Account designado		=   new Account();
       			designado		=	createDesignado();
       			
       Account asegurado        =   new Account();
               asegurado		=createAsegurado();			
       			
       Poliza__c poliza			=   new Poliza__c();
       poliza= CreatePoliza(beneficiario, tomador, designado, asegurado) ;
       
       System.PageReference p 						= Apexpages.currentPage();
	   p.getParameters().put( 'id',  poliza.Id ); 
	   ApexPages.Standardcontroller controller;
	   
	   Test.startTest(); 
	  	
	  	AccountSelection_ctr	accountSelection    = new AccountSelection_ctr (controller);
	  							accountSelection.strOpcion=tomador.id;			
	  	                       // accountSelection.strOpcion=tomador.Id;
	  	                        accountSelection.getItems();
	  	                        accountSelection.continuar(); 
	  
	  	Test.stopTest();
    }
}