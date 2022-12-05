/**
* Avanxo Colombia
* @author           CAVC					href:cvillalba@avanxo.com	
* Proyect:          Global Seguros
* Description:      test Class
*
* Changes (Version)
* -------------------------------------
*           No.     Fecha           Autor                   Descripción
*           -----   ----------      --------------------    ---------------
* @version   1.0    2014-07-07      CAVC     		esta clase de test llama realiza la cobertura de las siguientes clases:
													ActualizacionEstadoGestion_cls,
													ActualizacionEstadoGestion_ctr,
													ActualizacionEstadoGestion_trg
************************************************************************************************************
*/
@isTest
private class ActualizacionEstadoGestion_tst {
	
	public Contact objContact             					= new Contact();
		   Poliza__c objPoliza 							    = new Poliza__c();
	       Account objAccount             					= new Account();
	       EndPointsWS__c objEndP 							= new EndPointsWS__c();

    public  void CreateData(){

     // creando usuario
		objContact.LastName                   				= 'Carlos v';
      	objContact.NumeroDocumento__c               		= '1345678';
      	objContact.AccountId                  				= objContact.Id;
      	insert objContact;

     // Creando Poliza
        objPoliza.N_PolizaPlan__c							= '12123';
        insert objPoliza;
        
        //Creando Cuenta
       	objAccount.Name										= 'mi cuenta test';
       	insert objAccount;
        
       
     // Creando configuracion personalizada  
        objEndP.Name										= 'CallOutAllServices';
        objEndP.Notify__c									= 'lpenaranda@avanxo.com';
        objEndP.Email_Notification__c						= true;
        objEndP.EndPoint__c									= 'https://transac.globalseguroscolombia.com/SalesService/WSSalesForce.asmx';
        objEndP.attempts__c									= 2;
        insert objEndP;
    }
    
   static testMethod void PruebaestadoGestionesTrue()
   {
   	//  instanciando la misma clase para usar el metodo CreateData
   		ActualizacionEstadoGestion_tst myActEstClass 		= new ActualizacionEstadoGestion_tst();
   		myActEstClass.CreateData();
   		
   	// create Task
   		Task objTas 										= new Task(); 
   		objTas.WhatId										= myActEstClass.objPoliza.Id;
        objTas.Description									= 'nda';
        objTas.estadoGestion__c								= true;
        objTas.Status = 'Open';
        objTas.Priority = 'Normal';
        insert objTas;
   		
   	// instanciando la clase SettingsServices y pasandole el paramettro del Callout
   		SettingServices_cls objServices 					= new SettingServices_cls('CallOutAllServices');
    // llamado al metodo Token
        ObtenerTokenGlobal_cls objToken 					= new ObtenerTokenGlobal_cls();
 
        //instanciando Controlador
       	ApexPages.StandardController standardController 	= new ApexPages.StandardController(objTas);
        ActualizacionEstadoGestion_ctr ObjController 		= new ActualizacionEstadoGestion_ctr(standardController);
        ObjController.actualizar();	
   
   }
/*    static testMethod void PruebaestadoGestionesfalse()
   {
   		ActualizacionEstadoGestion_tst myActEstClass 		= new ActualizacionEstadoGestion_tst();
   		myActEstClass.CreateData();
   		// create Task
   		Task objTas 										= new Task(); 
   		objTas.WhatId										= myActEstClass.objPoliza.Id;
        objTas.Description									= 'nda';
        objTas.estadoGestion__c								= false;
        objTas.Status = 'Open';
        objTas.Priority = 'Normal';
        insert objTas;
   		
   		
   		SettingServices_cls objServices 					= new SettingServices_cls('CallOutAllServices');
   		
      // llamado al metodo Token
        ObtenerTokenGlobal_cls objToken 					= new ObtenerTokenGlobal_cls();
        //objToken.getToken();
          
          
        //instanciando Controlador
       	ApexPages.StandardController standardController 	= new ApexPages.StandardController(objTas);
        ActualizacionEstadoGestion_ctr ObjController 		= new ActualizacionEstadoGestion_ctr(standardController);
        ObjController.actualizar();	
   
   }
*/
   static testMethod void PruebaWSMetodo()
   {
   		ActualizacionEstadoGestion_tst myActEstClass 		= new ActualizacionEstadoGestion_tst();
   		myActEstClass.CreateData();
   		// create Task
   		Task objTas 										= new Task(); 
   		objTas.WhatId										= myActEstClass.objPoliza.Id;
        objTas.Description									= 'nda';
        objTas.estadoGestion__c								= true;
        objTas.Status = 'Open';
        objTas.Priority = 'Normal';
        insert objTas;
   		
   		
   		SettingServices_cls objServices 					= new SettingServices_cls('CallOutAllServices');
   		
      // llamado al metodo Token
        ObtenerTokenGlobal_cls objToken 					= new ObtenerTokenGlobal_cls();
        //objToken.getToken();
          
          
        //instanciando Controlador
       	ApexPages.StandardController standardController 	= new ApexPages.StandardController(objTas);
        ActualizacionEstadoGestion_ctr ObjController 		= new ActualizacionEstadoGestion_ctr(standardController);
        ObjController.actualizar();	
        
        ActualizacionEstadoGestion_cls objcls 				= new ActualizacionEstadoGestion_cls();
        objcls.callWs();
   
   }
    static testMethod void sinPliza()
   {
   		ActualizacionEstadoGestion_tst myActEstClass 		= new ActualizacionEstadoGestion_tst();
   		myActEstClass.CreateData();
   		// create Task
   		Task objTas 										= new Task(); 
   		objTas.WhatId										= myActEstClass.objPoliza.Id;
        objTas.Description									= 'nda';
        objTas.estadoGestion__c								= true;
        objTas.Status = 'Open';
        objTas.Priority = 'Normal';
        insert objTas;
   		
   		
   		SettingServices_cls objServices 					= new SettingServices_cls('CallOutAllServices');
   		
      // llamado al metodo Token
        ObtenerTokenGlobal_cls objToken 					= new ObtenerTokenGlobal_cls();
        //objToken.getToken();
          
          
        //instanciando Controlador
       	ApexPages.StandardController standardController 	= new ApexPages.StandardController(objTas);
        ActualizacionEstadoGestion_ctr ObjController 		= new ActualizacionEstadoGestion_ctr(standardController);
        ObjController.existePoliza							= false;
        ObjController.actualizar();	
        ObjController.refrescar();
        
        ActualizacionEstadoGestion_cls objcls 				= new ActualizacionEstadoGestion_cls();
        objcls.callWs();
   
   }
   static testMethod void ExitosoyTareaActualizada()
   {
   		ActualizacionEstadoGestion_tst myActEstClass 		= new ActualizacionEstadoGestion_tst();
   		myActEstClass.CreateData();
   		// create Task
   		Task objTas 										= new Task(); 
   		objTas.WhatId										= myActEstClass.objPoliza.Id;
        objTas.Description									= 'nda';
        objTas.estadoGestion__c								= true;
        objTas.Status = 'Open';
        objTas.Priority = 'Normal';
        insert objTas;
   		
   		
   		SettingServices_cls objServices 					= new SettingServices_cls('CallOutAllServices');
   		
      // llamado al metodo Token
        ObtenerTokenGlobal_cls objToken 					= new ObtenerTokenGlobal_cls();
        //objToken.getToken();
          
          
        //instanciando Controlador
       	ApexPages.StandardController standardController 	= new ApexPages.StandardController(objTas);
        ActualizacionEstadoGestion_ctr ObjController 		= new ActualizacionEstadoGestion_ctr(standardController);
        ObjController.existePoliza							= true;
        ObjController.exitoso 								= true;
        ObjController.tareaActualizada						= false;
        ObjController.actualizar();	
        ObjController.refrescar();
        
        ActualizacionEstadoGestion_cls objcls 				= new ActualizacionEstadoGestion_cls();
        objcls.callWs();
   
   }
   static testMethod void TareaActualizadatrue()
   {
   		ActualizacionEstadoGestion_tst myActEstClass 		= new ActualizacionEstadoGestion_tst();
   		myActEstClass.CreateData();
   		// create Task
   		Task objTas 										= new Task(); 
   		objTas.WhatId										= myActEstClass.objPoliza.Id;
        objTas.Description									= 'nda';
        objTas.estadoGestion__c								= true;
        objTas.Status = 'Open';
        objTas.Priority = 'Normal';
        insert objTas;
   		
   		
   		SettingServices_cls objServices 					= new SettingServices_cls('CallOutAllServices');
   		
      // llamado al metodo Token
        ObtenerTokenGlobal_cls objToken 					= new ObtenerTokenGlobal_cls();
        //objToken.getToken();
          
          
        //instanciando Controlador
       	ApexPages.StandardController standardController 	= new ApexPages.StandardController(objTas);
        ActualizacionEstadoGestion_ctr ObjController 		= new ActualizacionEstadoGestion_ctr(standardController);
        ObjController.existePoliza							= true;
        ObjController.tareaActualizada						= true;
        ObjController.actualizar();	
        ObjController.refrescar();
        
        ActualizacionEstadoGestion_cls objcls 				= new ActualizacionEstadoGestion_cls();
        objcls.callWs();
   
   }
   
}