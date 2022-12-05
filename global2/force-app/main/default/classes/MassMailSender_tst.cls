/**
********************************************************************************************************
* @company         Avanxo Colombia
* @author          Antonio Torres href=<rorozco@avanxo.com>
* @proyect         Global Seguros
* @name            MassMailSender_tst
* @description     Clase de prueba controlador MassMailSender_ctr
* @dependencies    MassMailSender_ctr
* @changes (Version)
* --------   ---   ----------   ---------------------------   ------------------------------------------
*            No.   Date         Author                        Description
* --------   ---   ----------   ---------------------------   ------------------------------------------
* @version   1.0   2016-07-01   Raul David Orozco S.           Creación de la clase.
********************************************************************************************************
**/
@isTest (seeAllData=true)
private class MassMailSender_tst {
/*
	@testSetup static void setupTestData(){
		EmailTemplate e = new EmailTemplate (   
												developerName = 'test', 
												FolderId = UserInfo.getUserId(), 
												TemplateType= 'Text', 
												Name = 'test', 
												IsActive = true
											); // plus any other fields that you want to set
		insert e;
		
		
	}
*/    
	static testMethod void myUnitTest() {
		Test.setMock(HttpCalloutMock.class, new MockOrgLimits());
		Test.setCurrentPage(Page.MassEmailSender_pag);
		
		/*EnvioMasivoEmail__c conf1 = new EnvioMasivoEmail__c(Name='SingleEmail',Valor__c = 1000);
		insert conf1;
		
		EnvioMasivoEmail__c conf2 = new EnvioMasivoEmail__c(Name='SingleEmailMax',Valor__c = 1000);
		insert conf2;*/
		
		list<Report> lstRep = [Select Id From Report Where Name = 'InformePruebaCMSummary'];
		list<EmailTemplate> lstET = [Select Id From EmailTemplate Where Name = 'GLB_PlantillaPrueba'];
		
		test.startTest();
		
			MassEmailSender_ctr email = new MassEmailSender_ctr();
			email.sendMassEmail();
			
			email.idTemplateId = email.lstAvailableTemplates[0].getValue();
			
			if(!lstRep.isEmpty())
				email.idReportId = lstRep[0].Id;
				
			if(!lstET.isEmpty())
				email.idTemplateId = lstET[0].Id;
				
			email.strIdColumnName = 'ACCOUNT_ID';
			email.strEmailColumnName = 'Account.Correo_electr_nico_Intermediario__c';
			//email.strEmailColumnName = 'Account.CorreoElectronicoGE__c';
		
			email.sendMassEmail();
			
			//ReportUtils_cls.getRecordCountOnReport(email.idReportId);
		test.stopTest();
		
	}

	/**
	* @author Sebastián Ortiz (SO)
	* @date 30-01-2017
	* @description Método de prueba encargado de simular cuando Descripción
	**/
	@isTest
	private static void MetodoReporteTabular()
	{
		Test.setMock(HttpCalloutMock.class, new MockOrgLimits());
		Test.setCurrentPage(Page.MassEmailSender_pag);
		list<Report> lstRep = [Select Id From Report Where Name = 'InformePruebaCMTabular'];
		list<EmailTemplate> lstET = [Select Id From EmailTemplate Where Name = 'GLB_PlantillaPrueba'];
		Test.startTest();
			MassEmailSender_ctr email = new MassEmailSender_ctr();
			email.sendMassEmail();

			email.idTemplateId = email.lstAvailableTemplates[0].getValue();
			
			if(!lstRep.isEmpty())
				email.idReportId = lstRep[0].Id;
				
			if(!lstET.isEmpty())
				email.idTemplateId = lstET[0].Id;
				
			email.strIdColumnName = 'ACCOUNT_ID';
			email.strEmailColumnName = 'Account.Correo_electr_nico_Intermediario__c';

			email.sendMassEmail();
		Test.stopTest();
	}

	/**
	* @author Sebastián Ortiz (SO)
	* @date 30-01-2017
	* @description Método de prueba encargado de simular cuando Descripción
	**/
	@isTest
	private static void MetodoFalloNoCampo()
	{
		Test.setMock(HttpCalloutMock.class, new MockOrgLimits());
		Test.setCurrentPage(Page.MassEmailSender_pag);
		list<Report> lstRep = [Select Id From Report Where Name = 'InformePruebaCMTabular'];
		list<EmailTemplate> lstET = [Select Id From EmailTemplate Where Name = 'GLB_PlantillaPrueba'];
		Test.startTest();
			MassEmailSender_ctr email = new MassEmailSender_ctr();
			email.sendMassEmail();

			email.idTemplateId = email.lstAvailableTemplates[0].getValue();
			
			if(!lstRep.isEmpty())
				email.idReportId = lstRep[0].Id;
				
			if(!lstET.isEmpty())
				email.idTemplateId = lstET[0].Id;
				
			email.strIdColumnName = 'ACCOUNT_ID';
			email.strEmailColumnName = 'Account.CorreoElectronicoGE__c';

			email.sendMassEmail();
		Test.stopTest();
	}
}