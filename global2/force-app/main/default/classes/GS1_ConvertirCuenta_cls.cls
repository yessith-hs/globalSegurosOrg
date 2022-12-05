/***************************************************************************************************************************
*** Desarrollado por:       Avanxo Colombia                                                                              ***
*** Autor:                  Cristian Mejia (CM)                                                                          ***
*** Proyecto:                                                                                                            ***
*** Descripcion:            Clase para pasar la informacion de la cuenta y contacto , a la informacion de la empresa     ***
*** 						cuando el Prospecto de la compañia es Global Education										 ***
***                                                                                                                      ***
*** User history:                                                                                                        ***
*** Sprint:                                                                                                              ***
*** Release:                                                                                                             ***
***                                                                                                                      ***    
*** Cambios (Versiones)                                                                                                  ***
*** -------------------------------------                                                                                ***
***             No.     Fecha           Autor                   Descripción                                              ***    
***            -----    ----------      --------------------    ---------------                                          ***
*** @version    1.0     2015-01-23      Cristian Mejia (CM)     Class created                                            ***
*** @version    1.1     2016-06-30      Andres Garrido (AG)     Class Modified                                            ***
***************************************************************************************************************************/
public with sharing class GS1_ConvertirCuenta_cls 
{
	public GS1_ConvertirCuenta_cls(List<Account> cuentaNueva) 
	{
		set<String> lstAccToUpdate = new set<String>();
		for(Account cuenta : cuentaNueva)
		{
			/*if(cuenta.ProspectodeCompania__c == 'Global Education')
			{
				cuenta.DireccionResidenciaGE__c = cuenta.DireccionResidencia__c;
				cuenta.DireccionCorrespondenciaGE__c = cuenta.DireccionCorrespondencia__c;
				cuenta.CiudadCorrespondenciaGE__c = cuenta.CiudadCorrespondencia__c;
				//System.debug('\n------------1\n'+cuenta.DireccionResidenciaGE__c);
				//System.debug('\n------------2\n'+cuenta.DireccionCorrespondenciaGE__c);
				//System.debug('\n------------3\n'+cuenta.CiudadCorrespondenciaGE__c);

				cuenta.TelefonoCorrespondenciaResidenciaGE__c	= cuenta.Phone;
				cuenta.TelefonoCorrespondenciaOficinaGE__c = cuenta.TelefonoCorrespondenciaOficina__c;
				cuenta.CorreoElectronicoGE__c = cuenta.PersonEmail;
				cuenta.CelularGE__c = cuenta.PersonMobilePhone;
				//System.debug('\n------------4\n'+cuenta.TelefonoCorrespondenciaResidenciaGE__c);
				//System.debug('\n------------5\n'+cuenta.TelefonoCorrespondenciaOficinaGE__c);
				//System.debug('\n------------6\n'+cuenta.CorreoElectronicoGE__c);
				//System.debug('\n------------7\n'+cuenta.CelularGE__c);

				cuenta.DireccionResidencia__c = '';
				cuenta.DireccionCorrespondencia__c = '';
				cuenta.CiudadCorrespondencia__c = null;
				//System.debug('\n------------8\n'+cuenta.DireccionResidencia__c);
				//System.debug('\n------------9\n'+cuenta.DireccionCorrespondencia__c);
				//System.debug('\n------------10\n'+cuenta.CiudadCorrespondencia__c);

				cuenta.Phone = null;
				cuenta.TelefonoCorrespondenciaOficina__c = '';
				cuenta.PersonEmail = '';
				cuenta.PersonMobilePhone = '';
				cuenta.PersonDoNotCall = false;
				//System.debug('\n------------11\n'+cuenta.Phone);
				//System.debug('\n------------12\n'+cuenta.TelefonoCorrespondenciaOficina__c);
				//System.debug('\n------------13\n'+cuenta.PersonEmail);
				//System.debug('\n------------14\n'+cuenta.PersonMobilePhone);
				//System.debug('\n------------15\n'+cuenta.PersonDoNotCall);
			}*/
			
			if(cuenta.Viene_de_Prospecto__c == true)
				lstAccToUpdate.add(cuenta.Id);			
		}
		
		if(!lstAccToUpdate.isEmpty())
			updateAccounts(lstAccToUpdate);
	}
	
	@future
	public static void updateAccounts(set<String> setAcc){
		list<DatosContactoComercial__c> lstDcc = new list<DatosContactoComercial__c>();
        map<String, DatosContactoComercial__c> mapAccXDcc = new map<String, DatosContactoComercial__c>();
        
		list<Account> lstAcc = [
			Select 	Id, PersonMobilePhone, CiudadCorrespondencia__c, PersonEmail, Phone, DireccionResidencia__c, OwnerId
			From 	Account
			Where 	Id = :setAcc
		];
        
        list<Opportunity> lstOpp = [
            Select 	Id, Datos_Contacto_Comercial__c, AccountId
            From	Opportunity
            Where 	AccountId = :setAcc
        ];
        
        System.debug('lstOpp==>'+lstOpp);
		
		for(Account cuenta :lstAcc){
			
			DatosContactoComercial__c dcc = new DatosContactoComercial__c();
			dcc.Cuenta__c = cuenta.Id;
			dcc.Celular__c = cuenta.PersonMobilePhone;
			dcc.Ciudad__c =  cuenta.CiudadCorrespondencia__c;
			dcc.CorreoElectronico__c = cuenta.PersonEmail;
			dcc.Direccion__c = cuenta.DireccionResidencia__c;
			dcc.Telefono__c = cuenta.Phone;
			dcc.OwnerId = cuenta.OwnerId;	
			lstDcc.add(dcc);
            mapAccXDcc.put(cuenta.Id, dcc);
            
			cuenta.PersonMobilePhone = null;
			cuenta.CiudadCorrespondencia__c = null;
			cuenta.PersonEmail = null;
			cuenta.DireccionResidencia__c = null;
			cuenta.Phone = null;
		}
		
		if(!lstDcc.isEmpty())
			insert lstDcc;
        System.debug('lstAcc==>'+lstAcc);
		if(!lstAcc.isEmpty())
			update lstAcc;
        
        for(Opportunity opp :lstOpp){
            if(opp.Datos_Contacto_Comercial__c == null && mapAccXDcc.containsKey(opp.AccountId))
                opp.Datos_Contacto_Comercial__c = mapAccXDcc.get(opp.AccountId).Id;
        }
        
        if(!lstOpp.isEmpty())
            update lstOpp;
	}
}