/******************************************************************************************************************
Desarrollado por:				Avanxo Colombia
Autor:							Sergio Andres Ortiz
Proyecto:						Global Seguros
Descripción:					Clase que implementa la lógica de negocio para realizar las siguientes operaciones
									- actualizar Polizas con los datos del WS

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No.		Fecha			Autor					Descripción
-------------------------------------------------------------------------------------------------------
1.0		20/05/2014		Sergio Andres Ortiz 	Creación de la clase.

*******************************************************************************************************************/

public  class ActualizacionEstadoGestion_cls {
				
	@future(callout=true)
	public static void actualizarTarea(String IdTarea,String parWhatId,Datetime parCreatedDate,String parDescription, Boolean parEstadoGestion){
		//definicion de campos
		Boolean existePoliza = true;		
		Integer intNumPoliza;
		String  strNPoliza;		
		String  strObservacion;
		String 	strUsuarioSeguimiento;
		DateTime dateFechaSegimiento;
		String tokenTrabajo;	
		String  respuesta;
		ServiciosOperativosGlobal_WS_cls.WsSalesForceSoap objServiciosOperativos;
	
		//Task objTarea = [SELECT WhatId,CreatedDate,Description,estadoGestion__c,Id FROM Task WHERE Id =: IdTarea AND estadoGestion__c = false];
		if(parWhatId != null){
			Poliza__c objPoliza			= new Poliza__c();		
			List<Poliza__c> lstPoliza	= new List<Poliza__c>();
			
			List<Poliza__c> qryPolizaList = [SELECT N_PolizaPlan__c,RecordTypeId FROM Poliza__c 
											 WHERE Id =: parWhatId];
			
			//Validar si la lista de Polizas contiene registros.
			//String IdPoliza = qryPolizaList.get(0).Id;
					
			if(qryPolizaList.isEmpty() ==true) existePoliza=false;
			
			if(existePoliza == true){						
				strNPoliza   	= qryPolizaList.get(0).N_PolizaPlan__c;
				intNumPoliza	= integer.valueOf(strNPoliza);
				strObservacion  = parDescription;
				
				String codigoUser=getCodUsuario(UserInfo.getUserId());
				strUsuarioSeguimiento=codigoUser;
				//strUsuarioSeguimiento = UserInfo.getLastName();
				dateFechaSegimiento   = parCreatedDate;
				
				//obtener el token
				if(!test.isRunningTest()) {  
				    ObtenerTokenGlobal_cls token = new ObtenerTokenGlobal_cls();
				    tokenTrabajo = token.getToken();	
				    system.debug('@@-tokenTrabajo->'+tokenTrabajo);	
				}
			    String fechas= dateFechaSegimiento.format();
			    String fechaEnvio = dateFechaSegimiento.format('yyyyMMdd HH:mm:ss');
			    system.debug('@@-fechaEnvio->'+fechaEnvio);
			    system.debug('@@-intNumPoliza->'+intNumPoliza);
			    system.debug('@@-strUsuarioSeguimiento->'+strUsuarioSeguimiento);
			    system.debug('@@-strObservacion->'+strObservacion);
				
				//asignar el stud para el servicio
				Conexion_cls conexion = new Conexion_cls();
				if(!test.isRunningTest()) {
		    		objServiciosOperativos = conexion.getConexion_cls(tokenTrabajo);
					respuesta = conexion.GrabaSeguimBeneficio(intNumPoliza,fechaEnvio,strUsuarioSeguimiento,strObservacion,0);
				}
				else{
					respuesta = 'Ok';
				}
				system.debug('@@-Respuesta->'+respuesta);
			}else{
				system.debug('@@-Existe Poliza->'+existePoliza);
			}
			
			if(respuesta == 'Ok'){
				Task objTarea = new Task(id=IdTarea);
				objTarea.estadoGestion__c = true;
				update objTarea;
				system.debug('@@-objTarea->'+objTarea);
			}else{
				system.debug('@@-Respuesta GrabaSeguimBeneficio->'+respuesta);
			}	
		}					
	}
	
  	public  static  String getCodUsuario(String strIdUsuario){

        User objUser;
        list<User> listUsuarios = [SELECT Id,CodigoUsuario__c FROM User where id=:strIdUsuario ];

        if(listUsuarios.size()>0) {
            objUser = listUsuarios.get(0);
            return objUser.CodigoUsuario__c;
        }else{
             return null;
        }
     } 	
     
	public String callWs(){
		EndPointsWS__c parWS;
		parWS = EndPointsWS__c.getAll().get('CallOutAllServices');
		
		return null;
	}
}