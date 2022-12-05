/******************************************************************************************************************
Desarrollado por:				Avanxo Colombia
Autor:							Luis Rafael Peñaranda
Proyecto:						Global Seguros
Descripción:					Clase que implementa la lógica de negocio para realizar las siguientes operaciones
									- Consumir servicio web de GLobal para informar Acompañamientos

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No.		Fecha			Autor					Descripción
-------------------------------------------------------------------------------------------------------
1.0		23/05/2014		Luis Rafael Peñaranda 	Creación de la clase.

*******************************************************************************************************************/

public  class AcompanamientoIntermediario_cls 
{
				
	@future(callout=true)
	public static void notificarAcompanamiento(String IdEvaluacionSeguimiento, Date parFechaAcompanamiento,String parAsesorEvaluado)
	{
		//definicion de campos
		 Boolean existeContacto = true;		
		 String tokenTrabajo;	 
		 String  respuesta;
		 String  respuestaWS;
		 String[] datAgente;
		 String fechaAcomp;
		 Integer intDay;
		 Integer intMonth;
		 Integer intYear;
		 ServiciosOperativosGlobal_WS_cls.WsSalesForceSoap obj;
	
		//Task objTarea = [SELECT WhatId,CreatedDate,Description,estadoGestion__c,Id FROM Task WHERE Id =: IdTarea AND estadoGestion__c = false];
		
		String userName  = userinfo.getUserName();
		
		system.debug('parAsesorEvaluado--> ' + parAsesorEvaluado);
		system.debug('IdEvaluacionSeguimiento--> ' + IdEvaluacionSeguimiento);
		system.debug('parFechaAcompanamiento--> '+ parFechaAcompanamiento);
		List<Contact> lstContactos = [SELECT id,ClaveNo__c,TipoIntermediario__c,IdExterno__c FROM Contact 
										 WHERE Id =: parAsesorEvaluado];
		
		System.debug('Lista Contactos --> ' + lstContactos);
		
		Contact objContact = lstContactos.get(0);
		System.debug('objContact--> ' + objContact);
		if(objContact.IdExterno__c!=null)
		{
			
			datAgente = objContact.IdExterno__c.split('_');
			System.debug('datAgente--> ' + datAgente);
			Integer tipo_agente =Integer.ValueOf(datAgente[0]);
			Integer cod_agente =Integer.ValueOf(datAgente[1]);

			
			fechaAcomp=String.valueOf(parFechaAcompanamiento);
			fechaAcomp = fechaAcomp.replace('-','');
			system.debug('@@-dateFechaSegimiento->'+parFechaAcompanamiento);
			system.debug('@@-fechaFormateada->'+fechaAcomp);	
			
			system.debug('datAgente.size--> ' + datAgente.size());
				 			
			if(datAgente.size()==2)
			{	
				system.debug('lstContactos.isEmpty()--> ' + lstContactos.isEmpty());				
				if(lstContactos.isEmpty() == true)
				{					 
					existeContacto=false;
				}		
				if(existeContacto == true)
				{						
					//obtener el token  				
					if(!test.isRunningTest()) 
					{	 
				    	ObtenerTokenGlobal_cls token = new ObtenerTokenGlobal_cls();
				    	tokenTrabajo = token.getToken();
					}	
				    system.debug('@@-tokenTrabajo->'+tokenTrabajo);	
					
					//asignar el stud para el servicio
					if(!test.isRunningTest()) 
					{
						Conexion_cls conexion = new Conexion_cls();
			    		obj = conexion.getConexion_cls(tokenTrabajo);
						respuestaWS = conexion.GrabaAcompAgente(tipo_agente,cod_agente,fechaAcomp,userName,0);
	    			}// Se agrega este else 10-07-2014
	    			else
	    			{
	    				respuestaWS = 'Ok';
	    			}
					system.debug('@@-Respuesta->'+respuestaWS);
				}else
				{
					system.debug('@@-Existe Contacto->'+existeContacto);
				}
			
				if(respuestaWS == 'Ok')
				{
					EvaluacionSeguimiento__c objEvaluacionSeguimiento = new EvaluacionSeguimiento__c(id=IdEvaluacionSeguimiento);
					objEvaluacionSeguimiento.estadoAcompanamiento__c = true;
					update objEvaluacionSeguimiento;
					system.debug('@@-objEvaluacionSeguimiento->'+objEvaluacionSeguimiento);
				}else
				{
					system.debug('@@-Respuesta notificarAcompanamiento->'+respuestaWS);
				}
			}	
		}					
	}

}