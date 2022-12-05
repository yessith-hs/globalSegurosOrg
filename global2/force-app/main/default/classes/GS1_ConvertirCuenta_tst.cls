/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Probar la clase GS1_ConvertirCuenta_tgr y verificar que cada uno de sus métodos cumpla efectivamente su tarea.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha 			 Autor 		 		 Descripción
-------------------------------------------------------------------------------------------------------
1.0 01/07/2014 		Avanxo			 	Creación de la clase.
2.0 08/02/2016		Katherine Moreno	Modificación
*******************************************************************************************************************/
@isTest
private class GS1_ConvertirCuenta_tst 
{
	
	@isTest static void test_method_one() 
	{

		Ciudades__c ObjCiudad = new Ciudades__c();
		ObjCiudad.Name = 'Ciudad';
		ObjCiudad.Codigo__c = '1_2345';
		objCiudad.EsMunicipio__c = true;
		insert ObjCiudad;

		Account objAccount = new Account();

		objAccount.LastName = 'Prueba';
		objAccount.TipoDocumento__pc = 'CEDULA DE CIUDADANIA';
		objAccount.NumeroDocumento__c = '1032123456';
		objAccount.Id_Externo__c = '1010';
		objAccount.ProspectodeCompania__c = 'Global Education';

		objAccount.DireccionResidencia__c = 'Kr 99 # 99A - 99';
		objAccount.DireccionCorrespondencia__c = 'Kr 99 # 99B - 99';
		objAccount.CiudadCorrespondencia__c = ObjCiudad.Id;

		objAccount.Phone = '1234567';
		objAccount.TelefonoCorrespondenciaOficina__c = '7654321';
		objAccount.PersonEmail = 'correo@prueba.gx';
		objAccount.PersonMobilePhone = '3101234567';


		objAccount.DireccionResidenciaGE__c = '';
		objAccount.DireccionCorrespondenciaGE__c = '';
		//objAccount.CiudadCorrespondenciaGE__c = '';
		objAccount.TelefonoCorrespondenciaResidenciaGE__c = '';
		objAccount.TelefonoCorrespondenciaOficinaGE__c = '';
		objAccount.CorreoElectronicoGE__c = '';
		objAccount.CelularGE__c = '';

		objAccount.Viene_de_Prospecto__c = true;
		System.debug('\n ====== Cuenta Antigua ======= \n'+objAccount);
		insert objAccount;
        
        Opportunity objOpp                  =  new Opportunity ();
        objOpp.Name                         =  'Name Opp Prueba';
        objOpp.IdentificadorOportunidad__c	=  '00001232543';
        objOpp.StageName                    =  'Cotización';
        objOpp.CloseDate                    =  Date.today();
        objOpp.AccountId                    =  objAccount.id;
        objOpp.Designado__c                 =  objAccount.Id;		
        insert objOpp;
        
        

	}
	
}