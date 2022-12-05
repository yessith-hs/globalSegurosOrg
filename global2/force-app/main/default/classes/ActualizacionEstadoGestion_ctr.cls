public with sharing class ActualizacionEstadoGestion_ctr {
	//definicion de varialbes publicas
	public String IdTarea {get; set;}
	public boolean exitoso {get; set;}
	public Boolean	existePoliza {get; set;}
	public boolean tareaActualizada {get; set;}
	public String  respuesta {get; set;}
	public String tokenTrabajo {get; set;}
	public Task objTarea {get; set;}

    public ActualizacionEstadoGestion_ctr(ApexPages.StandardController inController)
    {	
    	//definicion de variables	
		Integer intNumPoliza;
		String  strNPoliza;		
		String  strObservacion;
		String 	strUsuarioSeguimiento;
		DateTime dateFechaSegimiento;
		String tokenTrabajo;	
		ServiciosOperativosGlobal_WS_cls.WsSalesForceSoap objServiciosOperativos;
    	
    	//asignacion del objeto tarea por el controlador
    	Task objTareaController	= (Task)  inController.getRecord();  			  	
    	IdTarea 				= objTareaController.Id;    	
    	existePoliza 			= true;
    	tareaActualizada 		= false;
    	    	  	  	
		objTarea = [SELECT WhatId,CreatedDate,Description,estadoGestion__c,Id FROM Task WHERE Id =: IdTarea];
		system.debug('@@-objTarea'+objTarea); 
		if(objTarea.estadoGestion__c == false){
		
			Poliza__c objPoliza			= new Poliza__c();		
			List<Poliza__c> lstPoliza	= new List<Poliza__c>();
			
			List<Poliza__c> qryPolizaList = [SELECT N_PolizaPlan__c,RecordTypeId FROM Poliza__c 
											 WHERE Id =: objTarea.WhatId];
			
			//Validar si la lista de Polizas contiene registros.
			String IdPoliza = qryPolizaList.get(0).Id;
					
			if(qryPolizaList.isEmpty() ==true) existePoliza=false;
			
			if(existePoliza == true){						
				strNPoliza   	= qryPolizaList.get(0).N_PolizaPlan__c;
				intNumPoliza	= integer.valueOf(strNPoliza);
				strObservacion  = objTarea.Description;
				String codigoUser=getIdUsuario(UserInfo.getUserId());
				//strUsuarioSeguimiento = UserInfo.getLastName();
				strUsuarioSeguimiento=codigoUser;
				dateFechaSegimiento   = objTarea.CreatedDate;
				
				//obtener el token  
			    ObtenerTokenGlobal_cls token = new ObtenerTokenGlobal_cls();
			    if(!Test.isRunningTest())
			    {
			    	tokenTrabajo = token.getToken();
			    }
			    else
			    {
			    	 tokenTrabajo =System.Userinfo.getSessionId();
			    }
			    
			    system.debug('@@-tokenTrabajo->'+tokenTrabajo);	
				
				//asignar el stud para el servicio
				Conexion_cls conexion = new Conexion_cls();
		    	objServiciosOperativos = conexion.getConexion_cls(tokenTrabajo);
		    	respuesta = conexion.GrabaSeguimBeneficio(intNumPoliza,dateFechaSegimiento.format(),strUsuarioSeguimiento,strObservacion,0);
					
							
				
				system.debug('@@-Respuesta->'+respuesta);
			}			
		}
		else
		{
			tareaActualizada = true;
		}		
		if(respuesta == 'Ok'){			
			exitoso = true;
		}
		else
		{
			exitoso = false;
		}
		system.debug('@@-Exitoso->'+exitoso);
    }

    //metodo que actualiza el estado Gestion de la tarea
    public PageReference actualizar()
	{
		if(existePoliza == false){				
			Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, Label.Bbc_NoExistePoliza));		
		}
		else if((exitoso == true) && (tareaActualizada == false)){	
			objTarea.estadoGestion__c = true;
			update objTarea;		
			Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, Label.Bbc_TareaActualizada));					
		}
		else if(tareaActualizada == true){
			Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, Label.Bbc_TareaYaActualizada));
		}
		else{
			Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, Label.Gbc_NotificacionError+'\n'+respuesta));
		}
		return null;
	}

	//metodo para refrescar la pagina y volver a la tarea
	public PageReference refrescar()
	{
		PageReference pr = new PageReference('/'+IdTarea);
		pr.setRedirect(true);
		system.debug('@@Ingreso a Refrescar->'+IdTarea+'---pr--'+pr);
		return pr;
	}
	/* Buscar id del usuario*/
  public   String getIdUsuario(String strIdUsuario){

        User objUser;
        list<User> listUsuarios = [SELECT Id,CodigoUsuario__c FROM User where id=:strIdUsuario ];

        if(listUsuarios.size()>0) {
            objUser = listUsuarios.get(0);
            return objUser.CodigoUsuario__c;
        }else{
             return null;
        }
     } 
     
}