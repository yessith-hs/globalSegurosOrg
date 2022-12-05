/**
* Avanxo Colombia
* @author           KTCAMO					href:kcardenas@avanxo.com	
* Proyect:          Global Seguros
* Description:      test Class
*
* Changes (Version)
* -------------------------------------
*           No.     Fecha           Autor                   Descripción
*           -----   ----------      --------------------    ---------------
* @version  1.0    2014-07-08      Katherine Cardenas    Esta clase de test llama realiza la cobertura de las siguientes clases:
														  ActualizarSenalPolizasEnCuentas_tgr
														  ActualizarSenalPolizasEnCuentas_cls
************************************************************************************************************
*/
@isTest
public with sharing class ActualizarSenalPolizasEnCuentas_tst {
	
	static testMethod void procesarActualziacion_tst()
	{
		List <Poliza__c> lstPoliza		= new List<Poliza__c>();
		
		Account objCliente1 			= new Account();
		objCliente1.FirstName			= 'Cliente Prueba';
		objCliente1.Id_Externo__c		= '12';
		objCliente1.LastName			= 'prueba';
				
		insert objCliente1;
		
		Account objCliente2 			= new Account();
		objCliente2.FirstName			= 'Cliente Prueba1';
		objCliente2.Id_Externo__c		= '21';
		objCliente2.LastName			= 'prueba2';
				
		insert objCliente2;
		
		
		 // Creando Poliza
		Poliza__c objPoliza = New Poliza__c();
		objPoliza.N_PolizaPlan__c		= '12123';
		objPoliza.Nombre_Tomador__c 	= objCliente1.id;
		objPoliza.NombreBeneficiario__c	= objCliente1.id;
		objPoliza.NombreDesignado__c	= objCliente1.id;
		objPoliza.Estado__c				= 'Activa';
		lstPoliza.add(objPoliza);
		
		Poliza__c objPoliza2 = New Poliza__c();
		objPoliza2.N_PolizaPlan__c		= '111234';
		objPoliza2.Nombre_Tomador__c 	= objCliente2.id;
		objPoliza2.NombreBeneficiario__c= objCliente2.id;
		objPoliza2.NombreDesignado__c	= objCliente2.id;
		objPoliza2.Estado__c			= 'Activa';
		lstPoliza.add(objPoliza2);
		
		insert lstPoliza;
        
        
		delete lstPoliza[1];
		 
	}

}