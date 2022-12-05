/****************************************************************************************************
    Información general 
    -------------------
    Desarrollado por:   Avanxo Colombia
    Autor:              Luis Rafael Peñaranda.
    Proyecto:           Global Seguros (CRM)
    Descripción:        Webservice para Creación y actualiación de Intermediarios
     
    Información sobre cambios (Versiones)
    -------------------------------------
    Número  Fecha       Autor                       Descripción
    ------  ----------  --------------------------  -----------
    1.0     16-05-2014  Luis Rafael Peñaranda       Creacion.
    1.1     29-06-2016  Andrés Garrido		        Modificación para incluir campos a nivel del contacto
    ****************************************************************************************************/

global class IntegracionIntermediarios_ws {
	  // ----------------------------------
  // Metodo para Actualizar las Contactos
  // ----------------------------------
      static webservice ObjectResponse crearYActualizarIntemediario(ObjectActualizarIntermediarioRequest parRequest)
      {  
        ObjectResponse respuesta_xy = new ObjectResponse();

        Savepoint sp = Database.setSavepoint();
        respuesta_xy.codigoRespuesta='000';
        respuesta_xy.MensajeRespuesta='Proceso exitoso';
 
        TransforDatos_cls.ContactMessage objContactMsg  = new TransforDatos_cls.ContactMessage();               
        system.debug('parRequest-Actualizar Contactos->'+parRequest);
        /*Crear o actualizar la Contacto del Tomador*/
        objContactMsg       =   validarUsuario(parRequest,parRequest.intTipoIdentificacion, parRequest.strNumeroIdentificacion);
        system.debug('objContactMsg---->'+objContactMsg);
        if(objContactMsg.objaContacto==null){
            respuesta_xy.codigoRespuesta=objContactMsg.respuesta_y.codigoRespuesta;
            respuesta_xy.MensajeRespuesta=objContactMsg.respuesta_y.MensajeRespuesta;
            return respuesta_xy;
        } 
        system.debug('objContactMsg.respuesta_y.idContacto-->'+objContactMsg.respuesta_y.idContacto);
        respuesta_xy.idContacto=objContactMsg.respuesta_y.idContacto;
        return respuesta_xy;  
      }

    /*Armar el objeto Contacto para Actualizacion*/
    public static TransforDatos_cls.ContactMessage armarRegistroIntermediario(ObjectActualizarIntermediarioRequest parRequest){
                                                                                        
            Contact objContacto = new Contact();  
            Contact objContactoAux = new Contact();
            CRUDGlobal_cls crud = new CRUDGlobal_cls();
            string  descDocumento=null;
            String tipoDocDescripcion;
            String codOcupacion;
            String idPais;
            String idCiudad;
            String idOwnerPublic;
            String idClave;
            TransforDatos_cls.ContactMessage objContactMsg  = new TransforDatos_cls.ContactMessage(); 
            objContactMsg.respuesta_y 						= new  TransforDatos_cls.ObjectResponse();  
                         
            list<Recordtype> listaRt =        [SELECT Id FROM RecordType WHERE Id =:parRequest.strTipoRegistro ];   
            if(listaRt.size()>0){                   
            	objContacto.RecordTypeId              			= parRequest.strTipoRegistro;
            }else{
                objContactMsg.respuesta_y.codigoRespuesta='010';
                objContactMsg.respuesta_y.mensajeRespuesta='Tipo de registro invalido';
                objContactMsg.objaContacto = null;
                return objContactMsg;           	
            }
                        
            system.debug('parRequest-->'+parRequest);
            // Ocupacion      
            codOcupacion = getIdOcupacion(parRequest.strOcupacion); 
            if(codOcupacion != null){               
                objContacto.Ocupacion__c                         = codOcupacion;
            }else{
                // MENSAJE DE ERROR
            }
                           
            // Ciudad de Nacimiento        
            idCiudad = getIdCiudad(parRequest.strCiudadNacimiento);
            if(idCiudad != null) objContacto.Ciudad__c= idCiudad;
			
			// Propietario
            idOwnerPublic       = getIdUsuario(parRequest.strUsuarioPropietarioSFDC);
            if(idOwnerPublic!=null){ 
                objContacto.OwnerId   = idOwnerPublic;
            }else{
                objContactMsg.respuesta_y.codigoRespuesta='001';
                objContactMsg.respuesta_y.mensajeRespuesta='Usuario dueño del Contacto Invalido';
                objContactMsg.objaContacto = null;
                return objContactMsg;
            }
            
             if(parRequest.strPrimerApellido==null && parRequest.strNombres==null){
        		objContactMsg.respuesta_y.codigoRespuesta    =   '002';
        		objContactMsg.respuesta_y.MensajeRespuesta    =   'El Nombre de la Contacto es requerido';  
        		objContactMsg.objaContacto = null;
                return objContactMsg;
            }else{
	            objContacto.LastName                      			= parRequest.strPrimerApellido;                                
	            objContacto.FirstName                             	= parRequest.strNombres;            	
            }

            objContacto.Birthdate                       		= parRequest.datFechaNacimiento;           
            objContacto.SegundoApellido__c                    	= parRequest.strSegundoApellido;                                    
            objContacto.Phone     								= parRequest.strTelefonoOficina ;
			
			// Validar Id Externo            
            if(parRequest.strIdExternoContacto!=null){ 
            	objContacto.IdExterno__c                         	= parRequest.strIdExternoContacto;
            }else{
        		objContactMsg.respuesta_y.codigoRespuesta    =   '003';
        		objContactMsg.respuesta_y.MensajeRespuesta    =   'El Nombre de la Contacto es requerido';    
        		objContactMsg.objaContacto = null;
                return objContactMsg;           	
            }
            
            objContacto.Email                           		= parRequest.strCorreoElectronico;                       
            objContacto.Genero__c                            	= parRequest.strGenero; 
            descDocumento = getDescripcionTipoDocumento(parRequest.intTipoIdentificacion);
            if(descDocumento != null){
		    	objContacto.TipoDocumento__c  						= descDocumento;
            }else{
        		objContactMsg.respuesta_y.codigoRespuesta    =   '004';
        		objContactMsg.respuesta_y.MensajeRespuesta    =   'El Nombre de la Contacto es requerido';  
        		objContactMsg.objaContacto = null;
                return objContactMsg;            	
            }
		    objContacto.NumeroDocumento__c   					= parRequest.strNumeroIdentificacion;
			objContacto.Genero__c   							= parRequest.strGenero;
			
			/*if(parRequest.strGenero='Femenino'){
				objContactMsg.Salutation  =  'Sra.';
			}else{
				objContactMsg.Salutation  =  '	Sr.';
			}*/
			
			objContacto.FechaFallecimiento__c   				= parRequest.datFechaFallecimiento;
			objContacto.Compania__c 							= parRequest.strEmpresa;   			
			objContacto.DireccionResidencia__c 					= parRequest.strDireccionResidencia;			
			objContacto.DireccionOficina__c  					= parRequest.strDireccionOficina;			
			objContacto.MobilePhone 							= parRequest.strCelular;
	       	objContacto.HomePhone 								= parRequest.strTelefonoResidencia;
	       	objContacto.Phone                                   = parRequest.strTelefonoOficina;
	       	
	       	//parRequest.strCiudadCorrespondencia;
	    	//objContacto.UsuarioComunidadPartners__c 			= parRequest.bolEsUsuarioComunidadPartner;
	    	// strCorreoElectronicoRepresentanteLegal;
	    	
	        // BUscar usuario de apoyo institucional
	        idOwnerPublic        = getIdUsuario(parRequest.strApoyoinstitucional);
	        if(idOwnerPublic!=null) {
	            objContacto.ApoyoInstitucional__c = idOwnerPublic;
	        }else{
	        	objContactMsg.respuesta_y.codigoRespuesta =   '005';
	        	objContactMsg.respuesta_y.mensajeRespuesta =  'Usuario de Apoyo Institucional Inválido';	
	        	objContactMsg.objaContacto = null;
                return objContactMsg;      	
	        }	    	

	        // BUscar usuario de Ejecutivo de cuentas
	        /*idOwnerPublic        = getIdUsuario(parRequest.strEjecutivoDeCuentas);
	        if(idOwnerPublic!=null) {
	            objContacto.NombreCodEjecutivoCuentas__c = idOwnerPublic;
	        }else{
	        	objContactMsg.respuesta_y.codigoRespuesta =   '005';
	        	objContactMsg.respuesta_y.mensajeRespuesta =  'Usuario Ejecutivo de Cuentas Inválido';	
	        	objContactMsg.objaContacto = null;
                return objContactMsg;      	
	        }*/
	        	    	
	    	
	    	
	    	objContacto.EtapaVinculacion__c 					= parRequest.strEtapaVinculacion;   		
			objContacto.ClaveNo__c   							= parRequest.intClaveIntermediario;
   			objContacto.EstadoAsesor__c 						= parRequest.strEstado; 
   			objContacto.Sucursal__c 							= parRequest.strSucursal;
   			objContacto.CanalVenta__c 							= parRequest.strCanalVenta;
   			objContacto.TipoConvenio__c							= parRequest.strTipoConvenio;
			objContacto.Convenio__c   							= parRequest.strConvenio;
   			objContacto.PuntodeVenta__c 						= parRequest.strPuntoDeVenta;
   			objContacto.RamosHabilitados__c 					= parRequest.strRamosHabilitados;
   			objContacto.TipoPersona__c							= parRequest.strTipoPersona;
   			
   			// Asociar la cuenta
   			system.debug('parRequest.stridExternoCuentaAsociada-->'+parRequest.stridExternoCuentaAsociada);
   			if(parRequest.stridExternoCuentaAsociada != null){
   				objContacto.AccountId = parRequest.stridExternoCuentaAsociada;
   			}
			
			// Si tiene Padre, valida la clave del padre
			// -------------------------------------------
			if(parRequest.bolTienePadre!= null){
/*		        idClave = getIdClave(parRequest.strClaveIntermediarioPadre);
		        if(idClave!= null){
		            //objContacto.ClavePadre__c                      =       idClave;    
		        }else{
		        	objContactMsg.respuesta_y.codigoRespuesta =   '007';
		        	objContactMsg.respuesta_y.mensajeRespuesta =  'Clave Padre Intemediario Invalida'; 		        	
	        		objContactMsg.objaContacto = null;
                	return objContactMsg;                 	        	      
		        } 
*/		        
			} 
	        			
   			objContacto.TipoIntermediario__c					= parRequest.strTipoIntermediario;
   			objContacto.FechaVinculacion__c						= parRequest.datFechaAlta;
   			objContacto.FechaDesvinculacion__c 					= parRequest.datFechaBaja;
            objContacto.FechaFallecimiento__c                 	= parRequest.datFechaFallecimiento;                                         
        	objContacto.NumeroDocumento__c                      = parRequest.strNumeroIdentificacion; 
        	
        	
        	/******************[AG: 2016-06-28] Nuevos campos para el servicio web **********************/
        	objContacto.Origen_del_Intermediarios__c 			= parRequest.strOrigenIntermediario;
        	objContacto.Evaluaciones_Aprobadas__c 				= parRequest.strEvaluacionesAprobadas;
        	objContacto.Evaluaciones_Pendientes__c				= parRequest.strEvaluacionesPendientes;
        	/********************************************************************************************/                                                                            
            
            // Buscar dueño de la Contactol del Asegurado
            String idOwnerPublic1       = getIdUsuario(parRequest.strUsuarioPropietarioSFDC);
            if(idOwnerPublic1!=null) {
                objContacto.OwnerId   = idOwnerPublic1;
             }else{
        		objContactMsg.respuesta_y.codigoRespuesta    =   '008';
        		objContactMsg.respuesta_y.MensajeRespuesta    =   'Usuario dueño de la Contacto Invalido';              	
            }              
        
        try{   
            objContactMsg = crud.UpsertContacto(objContacto);            
            system.debug('objContactMsg-->'+objContactMsg);
            return  objContactMsg;          
        }
        catch(Exception e){
            objContactMsg.respuesta_y.codigoRespuesta    =   '009';
            objContactMsg.respuesta_y.MensajeRespuesta    =   'Error en al creación de la Contacto-->'+e.getMessage();
            objContactMsg.objaContacto=null;
            return objContactMsg;
        }   
    }
    
  /* Validara Tipo de Documento */
 public static TransforDatos_cls.ContactMessage  validarUsuario(ObjectActualizarIntermediarioRequest parRequest,Integer TipoDoc,String numDoc){
    String tipoDocDescripcion_x;
    Contact objContacto_x;
    TransforDatos_cls.ContactMessage objContactMsg  = new TransforDatos_cls.ContactMessage();  
    objContactMsg.respuesta_y                       = new TransforDatos_cls.ObjectResponse();   
    //system.debug('TipoContacto-validarContacto->'+TipoContacto);
    if(TipoDoc != null   && TipoDoc!= null ){
          tipoDocDescripcion_x = getDescripcionTipoDocumento(TipoDoc);
          system.debug('tipoDocDescripcion_x->'+tipoDocDescripcion_x);
         if(tipoDocDescripcion_x!=null){
            objContactMsg       =armarRegistroIntermediario(parRequest);
            system.debug('objContactMsg->'+objContactMsg);
            if(objContactMsg==null){
                return null;
            }
            return objContactMsg;
         } else{
            return null;                    
          }     
    } else{
        return null;  
    }       
 }
       
// -------------------------------------------------------------------------------
// Clase que contiene el objeto Request de los metodo creas yt actualizar Póliza.
// -------------------------------------------------------------------------------
  global class ObjectActualizarIntermediarioRequest
  {
  	webservice String   stridExternoCuentaAsociada;
    webservice String   strNombres;
    webservice String   strPrimerApellido;
    webservice String   strSegundoApellido;
    webservice String   strTipoPersona;
    webservice Integer  intTipoIdentificacion;
    webservice String   strNumeroIdentificacion;
    webservice String   stridExternoContacto;
    Webservice String   strUsuarioPropietarioSFDC;
    webservice String   strGenero;
    webservice Date     datFechaNacimiento;
    webservice String   strCiudadNacimiento;
    webservice Date     datFechaFallecimiento;
    webservice String   strDireccionOficina;
    webservice String   strDireccionResidencia;
    webservice String   strTelefonoResidencia;
    webservice String   strTelefonoOficina;
    webservice String   strCiudadCorrespondencia;
    webservice String   strCorreoElectronico;
    webservice String   strCelular;
    webservice String   strOcupacion;    
    webservice String   strTipoRegistro;
	webservice String   strUsuarioSalesforce;
	webservice String   strEmpresa;
	webservice String   strApoyoinstitucional;
	webservice String   strEjecutivoDeCuentas;
	webservice String   strEtapaVinculacion;
	webservice Integer   intClaveIntermediario;
	webservice String   strCorreoElectronicoRepresentanteLegal;
	webservice String   strEstado; 
	webservice String   strSucursal;
	webservice String   strCanalVenta;
	webservice String   strTipoConvenio;
	webservice String   strConvenio;
	webservice String   strPuntoDeVenta;
	webservice String   strRamosHabilitados;
	webservice Boolean  bolTienePadre;
	webservice String   strClaveIntermediarioPadre;
	webservice String   strTipoIntermediario;
	webservice Date   	datFechaAlta;
	webservice Date   	datFechaBaja;
	
	/***** Nuevos campo para guardar en la Oportunidad AG[2016-06-23]********/
    webservice String 	strOrigenIntermediario;
    webservice String	strEvaluacionesAprobadas;
    webservice String 	strEvaluacionesPendientes;    
    /************************************************************************/
}

/* Buscar id del usuario*/
public  static String getIdUsuario(String strUsuario){

        User objUser;
        list<User> listUsuarios = [SELECT Id FROM User where Username=:strUsuario and IsActive = true];

        if(listUsuarios.size()>0) {
            objUser = listUsuarios.get(0);
            return objUser.Id;
        }else{
             return null;
        }
     }
     
/* Obtener la descripcion de un tipo de documento*/
 public static String getDescripcionTipoDocumento(Integer tipoDocumento){
    String strTipoDocumento = String.ValueOf(tipoDocumento);
    String descripcionDocumento=null; 
    Parametros__c  objParam;
    list<Parametros__c> listParam = [SELECT Codigo__c,Name FROM Parametros__c WHERE Objeto__c = 'Account' 
                                    and Campo__c= 'TipoDocumento__c' and Codigo__c =:strTipoDocumento];     
    if(listParam.size()>0) {
            return listParam.get(0).Name;
    }else{
        return null;
    }   
 }

 /* Buscar id de Pais*/
/* public static String getIdPais(String codPais){
 
    Ciudades__c obCiudad;
    list<Ciudades__c> listCiudades = [SELECT Id FROM Ciudades__c where Codigo__c=:codPais and EsPais__c =true];
    
    if(listCiudades.size()>0) {
        obCiudad = listCiudades.get(0);
        return obCiudad.Id;
    }else{
         return null;
    }   
 }
*/
 /* Obtener la descripcion de un tipo de documento*/
 public static String getIdOcupacion(String codOcupacion){
    Parametros__c  objParam;
    list<Parametros__c> listParam = [SELECT id,Codigo__c,Name FROM Parametros__c WHERE Objeto__c = 'Contacto' 
                                    and Campo__c= 'Ocupacion__c' and Codigo__c =:codOcupacion];     
    if(listParam.size()>0) {
            return listParam.get(0).id;
    }else{
        return null;
    }   
 } 
 
  /* Buscar id de Ciudad*/
 public static String getIdCiudad(String strCodCiudad){
 
    Ciudades__c obCiudad;
    //String strCodCiudad = String.ValueOf(codCiudad);
    
    list<Ciudades__c> listCiudades = [SELECT Id FROM Ciudades__c where Codigo__c=:strCodCiudad];
    
    if(listCiudades.size()>0) {
        obCiudad = listCiudades.get(0);
        return obCiudad.Id;
    }else{
         return null;
    }
 }
       

 /* Obtener la descripcion de un tipo de documento*/
/* public static String getIdClave(String strCodClave){
    Contact  objClave;
    list<Contact> listClave = [SELECT id,Name FROM Contact WHERE IdExterno__c=:strCodClave];    
    if(listClave.size()>0) {
            return listClave.get(0).id;
    }else{
        return null;
    }   
 } 
*/ 
  global class ObjectResponse 
    {
      webservice String codigoRespuesta;
      webservice String MensajeRespuesta;
      webservice String IdContacto;   
                               
    }      
}