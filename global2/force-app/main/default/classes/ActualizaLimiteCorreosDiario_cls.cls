/**
********************************************************************************************************
* @company         Avanxo Colombia
* @author          Raul Orozco href=<rorozco@avanxo.com>
* @proyect         Global Seguros
* @name            ActualizaLimiteCorreosDiario_bch
* @description     Clase para consulta límite diario envío de correos.
* @dependencies    Clase OrgWideLimit_cls
* @changes (Version)
* --------   ---   ----------   ---------------------------   ------------------------------------------
*            No.   Date         Author                        Description
* --------   ---   ----------   ---------------------------   ------------------------------------------
* @version   1.0   29/08/2016  Raul Orozco           		  Creación de la clase
********************************************************************************************************
**/
public with sharing class ActualizaLimiteCorreosDiario_cls {

    public static void limiteCorreosDiario(List<EnvioMasivoEmail__c> lstConf) {
        try{
        	//Se hacen validaciones de info en conf personalizada
        	/*
        		0	HoraUltimaConsulta			FechaHora__c		
				1	IdSesion					ValorTexto__c
				2	NroMinutosConsultaSesionId	Valor__c
				3	Password					ValorTexto__c		
				4	SingleEmail					Valor__c
				5	SingleEmailMax				Valor__c
				6	Usuario						ValorTexto__c
					
        	*/
        	
        	//Se valida si existe id de sesión
        	if(lstConf[1].ValorTexto__c == null){
        		system.debug('no hay id sesion');
        		
        		partnerSoapSforceCom.LoginResult resultado = new partnerSoapSforceCom.LoginResult();
        		
        		if(!Test.isRunningTest()){
        			partnerSoapSforceCom.Soap clasePartner = new partnerSoapSforceCom.Soap();
					resultado = clasePartner.login(lstConf[6].ValorTexto__c,lstConf[3].ValorTexto__c);
        		}else{
        			resultado.sessionId = '324w3rwefsd423423423423';
        		}
				
				system.debug(resultado.sessionId);
				
				OrgWideLimit_cls objOrgWideLimit = Utils_cls.getOrgWideLimit('SingleEmail',resultado.sessionId);
				//Se establece valor de id de sesión
				lstConf[1].ValorTexto__c = resultado.sessionId;
				//Se establece última hora de consulta
				lstConf[0].FechaHora__c = Datetime.now();
				
				system.debug(objOrgWideLimit.getRemaining());
				
				Integer valor = objOrgWideLimit.getRemaining();
				Integer valorMax = objOrgWideLimit.getMax();
				//Se establece cantidad actual de email
				lstConf[4].Valor__c = valor;
				lstConf[5].Valor__c = valorMax;
				//Se actualiza la conf personalizada
				update lstConf;
        	}else{
        		system.debug('si hay id sesion');
        		
        		//Se valida si ya transcurrió el tiempo configurado para consultar id sesión
        		Datetime ahora = Datetime.now();
        		
        		if((((ahora.getTime())/1000/60) - ((lstConf[0].FechaHora__c.getTime())/1000/60)) > lstConf[2].Valor__c){
        			system.debug('ya pasó el tiempo');
        			partnerSoapSforceCom.LoginResult resultado = new partnerSoapSforceCom.LoginResult();
					if(!Test.isRunningTest()){
						partnerSoapSforceCom.Soap clasePartner = new partnerSoapSforceCom.Soap();
						resultado = clasePartner.login(lstConf[6].ValorTexto__c,lstConf[3].ValorTexto__c);
					}else{
						resultado.sessionId = '324w3rwefsd423423423423';
					}
					
					system.debug(resultado.sessionId);
					
					OrgWideLimit_cls objOrgWideLimit = Utils_cls.getOrgWideLimit('SingleEmail',resultado.sessionId);
					//Se establece valor de id de sesión
					lstConf[1].ValorTexto__c = resultado.sessionId;
					//Se establece última hora de consulta
					lstConf[0].FechaHora__c = Datetime.now();
					
					system.debug(objOrgWideLimit.getRemaining());
					
					Integer valor = objOrgWideLimit.getRemaining();
					Integer valorMax = objOrgWideLimit.getMax();
					//Se establecen los valores de email
					lstConf[4].Valor__c = valor;
					lstConf[5].Valor__c = valorMax;
					//Se actualiza la conf personalizada
					update lstConf;
				update lstConf;
        		}else{
        			system.debug('no pasó el tiempo');
        			
        			//Se consulta el límite con el id de sesión que se tiene
        			OrgWideLimit_cls objOrgWideLimit = Utils_cls.getOrgWideLimit('SingleEmail',lstConf[1].ValorTexto__c);
					//Se establece cantidad actual de email
					Integer valor = objOrgWideLimit.getRemaining();
					lstConf[4].Valor__c = valor;
					//Se actualiza la conf personalizada
					update lstConf;
        		}
        	}
        }catch(Exception e){
        	system.debug('Error ActualizaLimiteCorreosDiario_cls.limiteCorreosDiario: ' + e.getMessage() + '<>' + e.getStackTraceString());
        }
    }
    
    public static void actualizarLimiteCorreosDiario(Decimal cantidad){
    	try{
    		//Se trae la información de la conf personalizada
	    	EnvioMasivoEmail__c objEnvioMasivoEmail =	[
	    													SELECT Name,Valor__c 
	    													FROM EnvioMasivoEmail__c 
	    													WHERE Name = 'SingleEmail'
	    													LIMIT 1
															FOR UPDATE
	    												];
			
	    	
	    	//Se establece cantidad actual de email
			objEnvioMasivoEmail.Valor__c = cantidad;
			
			update objEnvioMasivoEmail;
			
    	}catch(Exception e){
    		system.debug('Error ActualizaLimiteCorreosDiario_cls.actualizarLimiteCorreosDiario: ' + e.getMessage() + '<>' + e.getStackTraceString());
    	}
    }
}