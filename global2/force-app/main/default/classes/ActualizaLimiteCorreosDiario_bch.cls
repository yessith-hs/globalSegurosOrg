/**
********************************************************************************************************
* @company         Avanxo Colombia
* @author          Raul Orozco href=<rorozco@avanxo.com>
* @proyect         Global Seguros
* @name            ActualizaLimiteCorreosDiario_bch
* @description     Clase batch consulta límite diario envío de correos.
* @dependencies    ActualizaLimiteCorreosDiario_cls
* @changes (Version)
* --------   ---   ----------   ---------------------------   ------------------------------------------
*            No.   Date         Author                        Description
* --------   ---   ----------   ---------------------------   ------------------------------------------
* @version   1.0   28/08/2016  Raul Orozco           		  Creación de la clase
********************************************************************************************************
**/
global class ActualizaLimiteCorreosDiario_bch implements Database.Batchable<sObject>,Database.AllowsCallouts{
	global Database.QueryLocator start(Database.BatchableContext BC) {
		//Se trae el valor de la conf personalizada
		String query = 'SELECT Name,Valor__c,FechaHora__c,ValorTexto__c FROM EnvioMasivoEmail__c WHERE Name IN (\'SingleEmail\',\'SingleEmailMax\',\'IdSesion\',\'HoraUltimaConsulta\',\'Usuario\',\'Password\',\'NroMinutosConsultaSesionId\') ORDER BY Name';
		
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, List<EnvioMasivoEmail__c> lstConf) {
		//Se invoca la clase
		 ActualizaLimiteCorreosDiario_cls.limiteCorreosDiario(lstConf);		
	}
	
	global void finish(Database.BatchableContext BC) {
        //Se programa el batch automaticamente de acuerdo al parametro de la conf. personalizada
        if(EnvioMasivoEmail__c.getAll().containsKey('TiempoEjecucionBatch')){
        	Integer intervalo = Integer.valueOf(EnvioMasivoEmail__c.getAll().get('TiempoEjecucionBatch').Valor__c);
            DateTime fechaActual= System.now().addMinutes(intervalo);
            System.debug('\n----Intervalo-----'+intervalo);
            
            Integer minutos=fechaActual.minute();
            Integer hora=fechaActual.hour();
            Integer dia=fechaActual.day();
            integer mes=fechaActual.month();
            Integer anio=fechaActual.year();
            Integer segundo = fechaActual.second();
            //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
            String tiempo = segundo+' '+minutos+' '+hora+' '+dia+' '+mes+' ? '+anio;
            ActualizaLimiteCorreosDiario_sch sch = new ActualizaLimiteCorreosDiario_sch();
            System.debug('\n\n###sch'+tiempo);
            if(!Test.isRunningTest()) 
                Id tarea=System.schedule('ActualizaLimiteCorreosDiario_sch ' + system.now(), tiempo, sch);
        }
	}	
}