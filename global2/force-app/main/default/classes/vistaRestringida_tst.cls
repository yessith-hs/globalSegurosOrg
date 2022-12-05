/**
* Avanxo Colombia
* @author           CAVC					Ahref:cvillalba@avanxo.com	
* Proyect:          Global Seguros
* Description:      test class
*
* Changes (Version)
* -------------------------------------
*           No.     Fecha           Autor                   Descripción
*           -----   ----------      --------------------    ---------------
* @version   1.0    2014-07-07      CAVC     		esta clase de test llama realiza la cobertura de las siguiente clase:
													vistaRestringida_ctr
************************************************************************************************************
*/
@isTest
private class vistaRestringida_tst {

	public Contact 	 		Mycontact							= new Contact();
		   Account   		MyAccount							= new Account();
		   Account   		MyAccount2							= new Account();
		   Opportunity		MyOpportunity						= new Opportunity();
		   Poliza__c        MyPoliza							= new Poliza__c();		   
		   
		   /*creo los datos que voy a utilizar con un usuario[0]*/
	public void CrearDatos()
	{
		Mycontact.LastName										= 'Schwnerteiger';
		insert Mycontact;
		list <User> MyUser 										= [SELECT Id,IsActive,IsPortalEnabled,ProfileId,UserType FROM User 
																  where  UserType = 'PowerPartner'AND IsActive=true LIMIT 2];
																
		/*inserto la cuenta como un usuario traido de la consulta anterior*/																						
		system.runAs(MyUser[0])
		 {
		 	System.debug('@@--> MyAccount > '+MyAccount);
		 	MyAccount.Name										= 'Mi cuenta de test';
		 	MyAccount.RecordTypeId								= '012G0000000WWsR';
			insert MyAccount;	
		 }		 
		 		
	}	   
    /*creo los datos que voy a utilizar con un usuario[1]*/
    public void CrearDatos2()
	{
		Mycontact.LastName										= 'Schwnerteiger';
		insert Mycontact;
		
		list <User> MyUser 										= [SELECT Id,IsActive,IsPortalEnabled,ProfileId,UserType FROM User 
																	where  UserType = 'PowerPartner'AND IsActive=true LIMIT 2];		
		/*inserto la cuenta como un usuario traido de la consulta anterior*/	 
		 system.runAs(MyUser[1])
		 {
			System.debug('@@--> MyAccount2 > '+MyAccount2);
			MyAccount2.Name										= 'Mprueba test';
		 	MyAccount2.RecordTypeId								= '012G0000000WWsR';
		 	insert MyAccount2;		
		 }
	}
    
    static testMethod void myUnitTest0() 
    {
    
      	vistaRestringida_tst miClass 							= new vistaRestringida_tst();
      	miClass.CrearDatos();
      	
       	ApexPages.StandardController standardController 		= new ApexPages.StandardController(miClass.MyAccount);
       	vistaRestringida_ctr MyController 						= new vistaRestringida_ctr(standardController);
       	list <User> MyUser 										= [SELECT Id,IsActive,IsPortalEnabled,ProfileId,UserType FROM User where 
       																 UserType = 'PowerPartner'AND IsActive=true LIMIT 2];
		 
		 system.runAs(MyUser[0])
		 {
		 
		 	MyController.ValidaUser();
		 	
		 }
       
       MyController.getlstOptys();
       MyController.getlstOptys();
       MyController.ValidaUser();
       MyController.nuevaOpty();
       

    }
     static testMethod void myUnitTest2() 
    {
    
      	vistaRestringida_tst miClass 							= new vistaRestringida_tst();
      	miClass.CrearDatos2();

       	ApexPages.StandardController standardController 		= new ApexPages.StandardController(miClass.MyAccount2);
       	vistaRestringida_ctr MyController 						= new vistaRestringida_ctr(standardController);
       	list <User> MyUser 										= [SELECT Id,IsActive,IsPortalEnabled,ProfileId,UserType FROM 
       																User where  UserType = 'PowerPartner'AND IsActive=true LIMIT 2];
		MyController.ValidaUser();
       	MyController.getlstOptys();
       	MyController.getlstOptys();
       	MyController.getlstPolizas();
       	MyController.nuevaOpty();
      
    }
     
}