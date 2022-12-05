/**
********************************************************************************************************
* @company         Avanxo Colombia
* @author          Antonio Torres href=<rorozco@avanxo.com>
* @proyect         Global Seguros
* @name            MassMailSender_tst
* @description     Clase de prueba ActualizaLimiteCorreosDiario_sch
* @dependencies    ActualizaLimiteCorreosDiario_sch
* @changes (Version)
* --------   ---   ----------   ---------------------------   ------------------------------------------
*            No.   Date         Author                        Description
* --------   ---   ----------   ---------------------------   ------------------------------------------
* @version   1.0   29/08/2016   Raul David Orozco S.           Creación de la clase.
********************************************************************************************************
**/
@isTest
private class ActualizaLimiteCorreosDiarioSch_tst {
	//Sin datos en la conf personalizada
    static testMethod void prueba1() {
        list<EnvioMasivoEmail__c> lstConf = new list<EnvioMasivoEmail__c>();
        
		EnvioMasivoEmail__c conf1 = new EnvioMasivoEmail__c(Name='SingleEmail',Valor__c = 1000);
		lstConf.add(conf1);
		
		EnvioMasivoEmail__c conf2 = new EnvioMasivoEmail__c(Name='SingleEmailMax',Valor__c = 1000);
		lstConf.add(conf2);
		
		EnvioMasivoEmail__c conf3 = new EnvioMasivoEmail__c(Name='Usuario',ValorTexto__c = 'usuario');
		lstConf.add(conf3);
		
		EnvioMasivoEmail__c conf4 = new EnvioMasivoEmail__c(Name='Password',ValorTexto__c = '123456789');
		lstConf.add(conf4);
		
		EnvioMasivoEmail__c conf5 = new EnvioMasivoEmail__c(Name='NroMinutosConsultaSesionId',Valor__c = 120);
		lstConf.add(conf5);
		
		EnvioMasivoEmail__c conf6 = new EnvioMasivoEmail__c(Name='IdSesion',ValorTexto__c = null);
		lstConf.add(conf6);
		
		EnvioMasivoEmail__c conf7 = new EnvioMasivoEmail__c(Name='HoraUltimaConsulta',FechaHora__c = null);
		lstConf.add(conf7);
        
        EnvioMasivoEmail__c conf8 = new EnvioMasivoEmail__c(Name='TiempoEjecucionBatch',Valor__c = 30);
		lstConf.add(conf8);
        
        insert lstConf;
		
		Test.StartTest();
			Test.setMock(HttpCalloutMock.class, new MockOrgLimits());
			ActualizaLimiteCorreosDiario_sch consulta = new ActualizaLimiteCorreosDiario_sch();      
			String sch = '0  00 1 3 * ?';
			system.schedule('Test ActualizaLimiteCorreosDiario_bch', sch, consulta);
		Test.stopTest();
    }
    
    //Con sesión id, no pasa el tiempo de renovación
    static testMethod void prueba2() {
		EnvioMasivoEmail__c conf1 = new EnvioMasivoEmail__c(Name='SingleEmail',Valor__c = 1000);
		insert conf1;
		
		EnvioMasivoEmail__c conf2 = new EnvioMasivoEmail__c(Name='SingleEmailMax',Valor__c = 1000);
		insert conf2;
		
		EnvioMasivoEmail__c conf3 = new EnvioMasivoEmail__c(Name='Usuario',ValorTexto__c = 'usuario');
		insert conf3;
		
		EnvioMasivoEmail__c conf4 = new EnvioMasivoEmail__c(Name='Password',ValorTexto__c = '123456789');
		insert conf4;
		
		EnvioMasivoEmail__c conf5 = new EnvioMasivoEmail__c(Name='NroMinutosConsultaSesionId',Valor__c = 120);
		insert conf5;
		
		EnvioMasivoEmail__c conf6 = new EnvioMasivoEmail__c(Name='IdSesion',ValorTexto__c = '2345234234fgdgfg3454235345345');
		insert conf6;
		
		EnvioMasivoEmail__c conf7 = new EnvioMasivoEmail__c(Name='HoraUltimaConsulta',FechaHora__c = Datetime.now());
		insert conf7;
		
		Test.StartTest();
			Test.setMock(HttpCalloutMock.class, new MockOrgLimits());
			ActualizaLimiteCorreosDiario_sch consulta = new ActualizaLimiteCorreosDiario_sch();      
			String sch = '0  00 1 3 * ?';
			system.schedule('Test ActualizaLimiteCorreosDiario_bch', sch, consulta);
		Test.stopTest();
    }
    
    //Con sesión id, ya pasó el tiempo de renovación
    static testMethod void prueba3() {
		EnvioMasivoEmail__c conf1 = new EnvioMasivoEmail__c(Name='SingleEmail',Valor__c = 1000);
		insert conf1;
		
		EnvioMasivoEmail__c conf2 = new EnvioMasivoEmail__c(Name='SingleEmailMax',Valor__c = 1000);
		insert conf2;
		
		EnvioMasivoEmail__c conf3 = new EnvioMasivoEmail__c(Name='Usuario',ValorTexto__c = 'usuario');
		insert conf3;
		
		EnvioMasivoEmail__c conf4 = new EnvioMasivoEmail__c(Name='Password',ValorTexto__c = '123456789');
		insert conf4;
		
		EnvioMasivoEmail__c conf5 = new EnvioMasivoEmail__c(Name='NroMinutosConsultaSesionId',Valor__c = 120);
		insert conf5;
		
		EnvioMasivoEmail__c conf6 = new EnvioMasivoEmail__c(Name='IdSesion',ValorTexto__c = '2345234234fgdgfg3454235345345');
		insert conf6;
		
		EnvioMasivoEmail__c conf7 = new EnvioMasivoEmail__c(Name='HoraUltimaConsulta',FechaHora__c = Datetime.now().addHours(-3));
		insert conf7;
		
		Test.StartTest();
			Test.setMock(HttpCalloutMock.class, new MockOrgLimits());
			ActualizaLimiteCorreosDiario_sch consulta = new ActualizaLimiteCorreosDiario_sch();      
			String sch = '0  00 1 3 * ?';
			system.schedule('Test ActualizaLimiteCorreosDiario_bch', sch, consulta);
		Test.stopTest();
    }
}