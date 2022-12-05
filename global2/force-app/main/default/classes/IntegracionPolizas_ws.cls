/****************************************************************************************************
    Información general 
    -------------------
    Desarrollado por:   Avanxo Colombia
    Autor:              Luis Rafael Peñaranda.
    Proyecto:           Global Seguros (CRM)
    Descripción:        Webservice para integración de polizas 
    
    Codigos de Operacion:
        CS: Creación de Solicitud
        CP: Creación de Polizas
        AS: Actualización de solicitud
        AP: Actualización de Polizas
        PE: Cambio de Solicitud a Poliza.
            
    Información sobre cambios (Versiones)
    -------------------------------------
    Número  Fecha       Autor                       Descripción
    ------  ----------  --------------------------  -----------
    1.0     04-04-2014  Luis Rafael Peñaranda       Creacion.
    ****************************************************************************************************/


global class IntegracionPolizas_ws {

    public static Account   accTomador;
    public static Account   accAcudiente;
    public static Account   accBeneficiario;
    public static Account   accBeneficiario2;
    public static Account   accAsegurado;

    public static String   idTomadorUser;
    public static String   idAcudienteUser;
    public static String   idBeneficiarioUser;
    public static String   idBeneficiario2User;
    public static String   idAseguradoUser;
        
    public static Poliza__c objPolizaGen;
    public static ObjectResponsePoliza respuesta_x;
    
    
    webservice static  ObjectResponsePoliza crearSolicitud(ObjectCrearyActualizarPolizaRequest parRequest){  
        respuesta_x = new ObjectResponsePoliza();
        ObjectResponsePolizaOportunidad objRespuesta;
        String tipoDocDescripcion;
        system.debug('parRequest-@@@->'+parRequest);
        // Create a savepoint while AccountNumber is null
        Savepoint sp = Database.setSavepoint(); 
        respuesta_x.codigoRespuesta='000';
        respuesta_x.MensajeRespuesta='Proceso exitoso';
        
        //Valido que al menos una des las cuentas venga diligenciada
        if(parRequest.stridExternoTomador == null && parRequest.stridExternoAcudiente == null && parRequest.stridExternoBeneficiario == null && parRequest.stridExternoAsegurado == null && parRequest.stridExternoBeneficiario2 == null){
            respuesta_x.codigoRespuesta='001';
            respuesta_x.MensajeRespuesta='Datos Invalidos: Debe diligenciar al menos una cuenta. ';
            return respuesta_x; 
        }
        
        
        system.debug('parRequest.strCodigoOperacion-@@@->'+parRequest.strCodigoOperacion);
        // Si es creación de Solicitud
        // -------------------------------------------------------------------
        if(parRequest.strCodigoOperacion.equals('CS') || parRequest.strCodigoOperacion.equals('AS')){ // Si es creación o Actualizacion de solicitud
            // El número de solicitud debe venir vacio y el numero de  poliza diigenciados   
            if(parRequest.intNumeroSolicitud==null  ||   parRequest.intNumeroPoliza!=null){
                respuesta_x.codigoRespuesta='026';
                respuesta_x.MensajeRespuesta='Al Crear o Actualizar Solicitud, el  número de Poliza debe venir vacio y el numero de  Solicitud diligenciado';
                return respuesta_x;                    
            }
        }
        
         // Si es creación de Poliza
         // -------------------------------------------------------------------
        if(parRequest.strCodigoOperacion.equals('CP')|| parRequest.strCodigoOperacion.equals('AP')){ // Si es creación o Actualiacion de poliza
            // El número de solicitud debe venir vacio y el numero de  poliza diigenciados   
            if(parRequest.intNumeroSolicitud!=null  || parRequest.intNumeroPoliza==null){
                respuesta_x.codigoRespuesta='027';
                respuesta_x.MensajeRespuesta='Al Crear o Actualizar pólizas, El número de solicitud debe venir vacio y el numero de  poliza diligenciado'; 
                return respuesta_x;                      
            }
        } 
            
        // Si es creación de Poliza
        // -------------------------------------------------------------------
        if(parRequest.strCodigoOperacion.equals('PE')){ // Si es cambo de solicitud a Poliza, deben venir ambas diligenciadas
            
            // El número de solicitud debe venir vacio y el numero de  poliza diigenciados   
            if(parRequest.intNumeroSolicitud==null  || parRequest.intNumeroPoliza==null){
                respuesta_x.codigoRespuesta='028';
                respuesta_x.MensajeRespuesta='Al pasar de Solicitud a Pólza, se debe enviar los números de Solicitud y de Pólza';   
                return respuesta_x;                 
            }
        }
        
        system.debug('parRequest.stridExternoTomador-@@@->'+parRequest.stridExternoTomador);
        //Valido la cuenta tomador
        if(parRequest.stridExternoTomador != null){
            accTomador = obtenerObjCuenta(parRequest.stridExternoTomador);
            if(accTomador==null){
                respuesta_x.codigoRespuesta='001';
                respuesta_x.MensajeRespuesta='Tomador Invalido: No existe una cuenta con el identificador '+parRequest.stridExternoTomador+'.';
                return respuesta_x;
            }
            idTomadorUser   =   accTomador.id;
        }
        
        system.debug('parRequest.stridExternoAcudiente-@@@->'+parRequest.stridExternoAcudiente);        
        //Valido la cuenta Acudiente
        if(parRequest.stridExternoAcudiente != null){
            accAcudiente = obtenerObjCuenta(parRequest.stridExternoAcudiente);
            if(accAcudiente == null){
                respuesta_x.codigoRespuesta='001';
                respuesta_x.MensajeRespuesta='Acudiente Invalido: No existe una cuenta con el identificador '+parRequest.stridExternoAcudiente+'.';
                return respuesta_x;
            }
            idAcudienteUser =   accAcudiente.id;
        }
        
        system.debug('parRequest.stridExternoBeneficiario-@@@->'+parRequest.stridExternoBeneficiario);
        //Valido la cuenta Beneficiario
        if(parRequest.stridExternoBeneficiario != null){
            accBeneficiario = obtenerObjCuenta(parRequest.stridExternoBeneficiario);
            if(accBeneficiario == null){
                respuesta_x.codigoRespuesta='001';
                respuesta_x.MensajeRespuesta='Beneficiario Invalido: No existe una cuenta con el identificador '+parRequest.stridExternoBeneficiario+'.';
                return respuesta_x;
            }
            idBeneficiarioUser  =   accBeneficiario.id;
        }
        
        //Valido la cuenta Beneficiario 2
        if(parRequest.stridExternoBeneficiario2 != null){
            accBeneficiario2 = obtenerObjCuenta(parRequest.stridExternoBeneficiario2);
            if(accBeneficiario2 == null){
                respuesta_x.codigoRespuesta='001';
                respuesta_x.MensajeRespuesta='Beneficiario 2 Invalido: No existe una cuenta con el identificador '+parRequest.stridExternoBeneficiario2+'.';
                return respuesta_x;
            }
            idBeneficiario2User =   accBeneficiario2.id;
        }
        
        system.debug('parRequest.stridExternoAsegurado-@@@->'+parRequest.stridExternoAsegurado);
        //Valido la cuenta Beneficiario 2
        if(parRequest.stridExternoAsegurado != null){
            accAsegurado = obtenerObjCuenta(parRequest.stridExternoAsegurado);
            if(accAsegurado == null){
                respuesta_x.codigoRespuesta='001';
                respuesta_x.MensajeRespuesta='Asegurado Invalido: No existe una cuenta con el identificador '+parRequest.stridExternoAsegurado+'.';
                return respuesta_x;
            }
            idAseguradoUser = accAsegurado.Id;
            
        }
        
        // Proceso de creación y actulización de Oportunidades, Polizas y Producto
        objRespuesta  = armarRegistroPoliza(parRequest, accTomador, accAcudiente, accBeneficiario, accAsegurado);  
        
        system.debug('objRespuesta-@@@->'+objRespuesta);
        if(objRespuesta.objPoliza!=null) {
            objPolizaGen=  objRespuesta.objPoliza;
        } else{
            respuesta_x.codigoRespuesta=objRespuesta.codigoRespuesta;
            respuesta_x.MensajeRespuesta=objRespuesta.MensajeRespuesta;                 
        }           
                 
        if(respuesta_x.codigoRespuesta.equals('000')){
            if(objRespuesta.objOportunidad!=null){
                String nomBenef='';
                if( accBeneficiario != null){
                    nomBenef=   accBeneficiario.FirstName+' '+accBeneficiario.LastName;
                }
                
                //Boolean rtaWs = 
                system.debug('objRespuesta.objOportunidad-->'+objRespuesta.objOportunidad
                );
                system.debug('objRespuesta.objOportunidad.AuxiliarIdentificador__c-->'+objRespuesta.objOportunidad.AuxiliarIdentificador__c);
                //informarCreacionOportunidadASise(objRespuesta.objOportunidad.AuxiliarIdentificador__c,parRequest.intCodigoRamo,nomBenef,accTomador.TipoDocumento__c,accTomador.NumeroDocumento__c);
                /*if(!rtaWs){
                    Database.rollback(sp);
                }*/
                //busqueda del tipo de documento como entero.
                list<Parametros__c> listParamDoc = [SELECT Codigo__c,Name FROM Parametros__c 
                                                        WHERE Objeto__c = 'Account' and Campo__c= 'TipoDocumento__c' and Name =:accTomador.TipoDocumento__c];
                system.debug('@@-listParamDoc->'+listParamDoc);       
                list<Opportunity> lstOpp = [select AuxiliarIdentificador__c from Opportunity where  id=:objRespuesta.objOportunidad.Id];      
                respuesta_x.inttipoDocumento          =   integer.valueOf(listParamDoc.get(0).Codigo__c);
                respuesta_x.strnumeroOportunidad      =   String.ValueOF(lstOpp.get(0).AuxiliarIdentificador__c);
                respuesta_x.intCodigoRamo             =   parRequest.intCodigoRamo;
                respuesta_x.strnumeroDocumento        =   accTomador.NumeroDocumento__c;
                respuesta_x.strusuarioSFDC            =   userinfo.getUserName();
                respuesta_x.strnombreBeneficiario     =   nomBenef;
                  
                if(idTomadorUser!=null)             respuesta_x.idTomador               =   idTomadorUser;    
                if(idAcudienteUser!=null)               respuesta_x.idDesignado             =   idAcudienteUser;    
                if(idBeneficiarioUser!=null)            respuesta_x.idBeneficiario          =   idBeneficiarioUser;    
                if(idAseguradoUser!=null)               respuesta_x.idAsegurado             =   idAseguradoUser; 
                
                system.debug('@@-respuesta_x->'+respuesta_x); 
            }           
        }
        else{
            Database.rollback(sp);
        }
        return respuesta_x;  
    }    
    
 
  /* Validara Tipo de Documento */
 public static TransforDatos_cls.AccountMessage  validarCuenta_ACT(ObjectActualizarCuentaRequest parRequest,Integer TipoDoc,String numDoc){
    String tipoDocDescripcion_x;
    Account objCuenta_x;
    TransforDatos_cls.AccountMessage objAccountMsg  = new TransforDatos_cls.AccountMessage();  
    objAccountMsg.respuesta_y                       = new TransforDatos_cls.ObjectResponse();   
    system.debug('TipoDoc-validarCuenta->'+TipoDoc);
    if(TipoDoc != null   && TipoDoc!= null ){
         tipoDocDescripcion_x = getDescripcionTipoDocumento(TipoDoc);
         system.debug('tipoDocDescripcion_x->'+tipoDocDescripcion_x);
         if(tipoDocDescripcion_x!=null){
            objAccountMsg       =armarRegistroCuenta_ACT(parRequest);
            system.debug('objAccountMsg->'+objAccountMsg);       
         } 
         else{
            objAccountMsg.respuesta_y.codigoRespuesta    =   '001';
        	objAccountMsg.respuesta_y.MensajeRespuesta   =   'Debe ingresar un tipo de documento válido: intTipoIdentificacion';
         }     
    } else{
        objAccountMsg.respuesta_y.codigoRespuesta    =   '001';
        objAccountMsg.respuesta_y.MensajeRespuesta   =   'Debe enviar el campo tipo de documento: intTipoIdentificacion';  
    }       
    return objAccountMsg;
 }
 

  // ----------------------------------
  // Metodo para Actualizar las cuentas
  // ----------------------------------
      static webservice ObjectResponse actualizarCuenta(ObjectActualizarCuentaRequest parRequest)
      {  
        ObjectResponse respuesta_xy = new ObjectResponse();

        Savepoint sp = Database.setSavepoint();
        respuesta_xy.codigoRespuesta='000';
        respuesta_xy.MensajeRespuesta='Proceso exitoso';

        TransforDatos_cls.AccountMessage objAccountMsg  = new TransforDatos_cls.AccountMessage();               
        system.debug('parRequest-Actualizar Cuentas->'+parRequest);
        /*Crear o actualizar la cuenta del Tomador*/
        objAccountMsg       =   validarCuenta_ACT(parRequest,parRequest.intTipoIdentificacion, parRequest.strNumeroIdentificacion);
        system.debug('objAccountMsg->'+objAccountMsg);
        if(objAccountMsg.objaCuenta==null){
            respuesta_xy.codigoRespuesta=objAccountMsg.respuesta_y.codigoRespuesta;
            respuesta_xy.MensajeRespuesta=objAccountMsg.respuesta_y.MensajeRespuesta;
            return respuesta_xy;
        } 
        
        //respuesta_xy.idCuenta = objAccountMsg.respuesta_y.idContacto;
        respuesta_xy.idCuenta = objAccountMsg.objaCuenta.id;
        return respuesta_xy;  
      }  
    
    
    /*Armar el objeto Cuenta para Actualizacion*/
    public static TransforDatos_cls.AccountMessage armarRegistroCuenta_ACT(ObjectActualizarCuentaRequest parRequest){
                                                                                        
            Account objCuenta = new Account();  
            Account objCuentaAux = new Account();
            CRUDGlobal_cls crud = new CRUDGlobal_cls();
            string  descDocumento=null;
            String tipoDocDescripcion;
            String codOcupacion;
            String idPais;
            String idCiudad;
            Integer lentCadena;
            String sufijo;
            TipoRegistroPersona__c tPersona;
            TransforDatos_cls.AccountMessage objAccountMsg  = new TransforDatos_cls.AccountMessage(); 
    		objAccountMsg.respuesta_y       = new TransforDatos_cls.ObjectResponse();
            tipoDocDescripcion = getDescripcionTipoDocumento(parRequest.intTipoIdentificacion);
            
            lentCadena  = parRequest.stridExternoCuenta.length();
            sufijo = parRequest.stridExternoCuenta.mid(lentCadena-2,2);
            system.debug('sufijo-->'+sufijo);
                
            if (tipoDocDescripcion ==Label.Gbc_TipDocNIT || (sufijo== 'GS' || sufijo == 'GE')){

                if(sufijo== 'GS' || sufijo == 'GE'){
                     tPersona                 = TipoRegistroPersona__c.getInstance('Intermediarios');
                }else{
                     tPersona                 = TipoRegistroPersona__c.getInstance('Juridica');      
                }               
                                                                          
                objCuenta.RecordTypeId              = tPersona.TipoRegistro__c;
                objCuenta.Name                      = parRequest.strPrimerApellido;
                if(parRequest.strPrimerApellido==null){
                    objAccountMsg.respuesta_y.codigoRespuesta    =   '038';
                    objAccountMsg.respuesta_y.MensajeRespuesta    =   'El Nombre de la cuenta es requerido';                    
                }
                objCuenta.Id_Externo__c                         = parRequest.strIdExternoCuenta;
            }               
            else{
                lentCadena  = parRequest.stridExternoCuenta.length();
                sufijo = parRequest.stridExternoCuenta.mid(lentCadena-2,2);
                system.debug('sufijo-->'+sufijo);
                if(sufijo== 'GS' || sufijo == 'GE'){
                     tPersona                 = TipoRegistroPersona__c.getInstance('Intermediarios');
                }else{
                     tPersona                 = TipoRegistroPersona__c.getInstance('Natural');      
                } 
                     
                objCuenta.TipoPersona__pc                       = tPersona.TipoPersona__c;                                          
                objCuenta.RecordTypeId                          = tPersona.TipoRegistro__c;  
                if(parRequest.strNombres!= null)       
                objCuenta.FirstName                             = parRequest.strNombres;
                objCuenta.PersonBirthdate                    = parRequest.datFechaNacimiento;
                    
                idCiudad = getIdCiudad(parRequest.strCiudadNacimiento);
                if(idCiudad != null) objCuenta.CiudadNacimientoCta__c= idCiudad;
                                    
                objCuenta.PersonMobilePhone                     = parRequest.strCelularCorrespondencia;
                objCuenta.PersonEmail                           = parRequest.strCorreoElectronicoCorrespondencia;                       
                objCuenta.Genero__pc                            = parRequest.strGenero; 
                
                codOcupacion = getIdOcupacion(parRequest.strOcupacion); 
                if(codOcupacion != null){               
                    objCuenta.Ocupacion__pc                         = codOcupacion;
                }else{
                    // MENSAJE DE ERROR
                }
                
                objCuenta.EstadoCivil__c                        = parRequest.strEstadoCivil;    
                objCuenta.LastName                              = parRequest.strPrimerApellido;
                objCuenta.SegundoApellido__c                    = parRequest.strSegundoApellido;        
                //objCuenta.SegundoApellido__pc                   = parRequest.strSegundoApellido;                            
                objCuenta.TelefonoCorrespondenciaOficina__c     = parRequest.strTelefonoCorrespondenciaOficina ;
                objCuenta.Id_Externo__c                         = parRequest.strIdExternoCuenta;
                
                idPais = getIdPais(parRequest.strNacionalidad); 
                if(idPais != null){ 
                    objCuenta.Nacionalidad__c                       = idPais;
                }else{
                    // MENSAJE DE ERROR
                }
                objCuenta.FechaFallecimiento__c                 = parRequest.datFechaFallecimiento;                                         
            }   
            
            if(parRequest.strTipoCuenta != null){
            	RecordType rt = [Select Id From RecordType Where Id = :parRequest.strTipoCuenta][0];
            	objCuenta.RecordTypeId = rt.Id; 
            }        
            
            // Buscar dueño de la cuental del Asegurado
            String idOwnerPublic1       = getIdUsuario(parRequest.strUsuarioPropietarioSFDC);
            if(idOwnerPublic1!=null) {
                objCuenta.OwnerId   = idOwnerPublic1;
             }else{
                objAccountMsg.respuesta_y.codigoRespuesta    =   '032';
                objAccountMsg.respuesta_y.MensajeRespuesta    =   'Usuario dueño de la Cuenta Invalido';                
            }              
            
            descDocumento = getDescripcionTipoDocumento(parRequest.intTipoIdentificacion);
            if(descDocumento != null){
                objCuenta.TipoDocumento__c                          = descDocumento;
            }else{
                // Mensaje de error
            }
            
            objCuenta.NumeroDocumento__c                        = parRequest.strNumeroIdentificacion;
            idCiudad = getIdCiudad(parRequest.strCiudadCorrespondencia);
            if(idCiudad != null) objCuenta.CiudadCorrespondencia__c= idCiudad;  
                                                        
            objCuenta.Phone                                     = parRequest.strTelefonoCorrespondenciaResidencia;  
            objCuenta.DireccionCorrespondencia__c               = parRequest.strDireccionCorrespondencia;                       
            objCuenta.fax                                       = parRequest.strFaxCorrespondencia;
            objCuenta.Celular__c								= parRequest.strCelularCorrespondencia;
        	objCuenta.Correo_electr_nico_Intermediario__c		= parRequest.strCorreoElectronicoCorrespondencia;
            
            /****** [AG 2016-06-28] Nuevos campos para la integración ****************************************/
            String idCiudadTelCorresp = getIdCiudad(parRequest.strCiudadTelCorrespondencia);
            String idCiudadTelOfi = getIdCiudad(parRequest.strCiudadTelOficina);
            
            if(parRequest.strEmpresa != null){
                if(parRequest.strEmpresa=='GS'){
                    objCuenta.Empresa__c = Label.Gbc_GlobalSeguros;
                    objCuenta.ClienteGlobalSeguros__c = true;
                    objCuenta.DireccionCorrespondencia__c = parRequest.strDireccionCorrespondencia;
                    objCuenta.Phone = parRequest.strTelefonoCorrespondenciaResidencia;
                    objCuenta.TelefonoCorrespondenciaOficina__c = parRequest.strTelefonoCorrespondenciaOficina;
                    if(idCiudad != null) objCuenta.CiudadCorrespondencia__c = idCiudad;
                    
                    //objCuenta.PersonEmail = parRequest.strCorreoElectronicoCorrespondencia;
                    //objCuenta.PersonMobilePhone = parRequest.strCelularCorrespondencia;
                    
                    objCuenta.Ciudad_Telefono_Correspondencia__c = idCiudadTelCorresp;
                    objCuenta.Ciudad_Telefono_Oficina__c = idCiudadTelOfi;
                    objCuenta.Calidad_de_Persona_GS__c = parRequest.strCalidadPersonaGS;
                    
                }
                else if (parRequest.strEmpresa=='GE'){
                    objCuenta.Empresa__c =Label.Gbc_GlobalEducation;
                    objCuenta.ClienteGlobalEducation__c = true;
                    objCuenta.DireccionCorrespondenciaGE__c = parRequest.strDireccionCorrespondencia;
                    objCuenta.TelefonoCorrespondenciaResidenciaGE__c = parRequest.strTelefonoCorrespondenciaResidencia;
                    objCuenta.TelefonoCorrespondenciaOficinaGE__c = parRequest.strTelefonoCorrespondenciaOficina;
                    if(idCiudad != null) objCuenta.CiudadCorrespondenciaGE__c = idCiudad;
                    
                    objCuenta.CorreoElectronicoGE__c = parRequest.strCorreoElectronicoCorrespondencia;
                    objCuenta.CelularGE__c = parRequest.strCelularCorrespondencia;
                    
                    objCuenta.Ciudad_Telefono_CorrespondenciaGE__c = idCiudadTelCorresp;
                    objCuenta.Ciudad_Telefono_OficinaGE__c = idCiudadTelOfi;
                    objCuenta.Calidad_de_Persona_GE__c = parRequest.strCalidadPersonaGE;
                }
            }
            
            objCuenta.Validacion_de_Correo__c = parRequest.strValidacionCorreo;
            objCuenta.Estado_del_Asesor__c = parRequest.strEstadoAsesor;
            
            /*************************************************************************************************/
        
        try{ 
            system.debug('Cuenta-->'+objCuenta);
            objAccountMsg = crud.UpsertCuenta(objCuenta);           
            system.debug('objAccountMsg-->'+objAccountMsg);
            return  objAccountMsg;          
        }
        catch(Exception e){
            objAccountMsg.respuesta_y.codigoRespuesta    =   '022';
            objAccountMsg.respuesta_y.MensajeRespuesta    =   'Error en al creación de la cuenta-->'+e.getMessage();
            objAccountMsg.objaCuenta=null;
            return objAccountMsg;
        }   
    }
    
    public static ObjectResponsePolizaOportunidad  armarRegistroPoliza(ObjectCrearyActualizarPolizaRequest parRequest, Account objTomador, Account objAcudiente, Account objBeneficario, Account objAsegurado){
        
        ObjectResponsePolizaOportunidad objRtaCompuesta = new ObjectResponsePolizaOportunidad();
        
        try{
            Opportunity newOportunidad;
            Poliza__c objPoliza;
            Poliza__c objPolizaExist = getPoliza(parRequest.strIdExternoPoliza);
            system.debug('objPolizaExist-->'+objPolizaExist);
            system.debug('objTomador-->'+objTomador.id);
            if(objPolizaExist==null){ 
                system.debug('Se crea la Poliza');
                 objPoliza = new Poliza__c();
                 objPoliza.Nombre_Tomador__c              =       objTomador.Id;
                system.debug('Se crea la Poliza-->'+objPoliza);
            }else{
                system.debug('Se Actualiza la Poliza');
                 objPoliza=objPolizaExist;
                 objPoliza.Nombre_Tomador__c              =       objTomador.Id;
                 objPoliza = objPolizaExist;
                system.debug('Se Actualiza la Poliza-->'+objPoliza);
            }
                    
            System.debug('Entro a Armar registro de poliza-->'+parRequest);
            
            System.debug('objTomador-F1->'+objTomador);
            System.debug('objAcudiente-F1->'+objAcudiente);
            System.debug('objBeneficario-F1->'+objBeneficario);
            System.debug('objAsegurado-F1->'+objAsegurado);                         
            
            System.debug('strIdExternoClaveAgente->'+parRequest.strIdExternoClaveAgente);
            String idClave = getIdClave(parRequest.strIdExternoClaveAgente);
            System.debug('idClave->'+idClave);
            
            if(idClave!= null){
                objPoliza.Clave__c                      =       idClave;    
            }else{
                objRtaCompuesta.objPoliza= null;
                objRtaCompuesta.codigoRespuesta =   '005';
                objRtaCompuesta.mensajeRespuesta =  'Clave Intemediario Invalida';                  
                return objRtaCompuesta;                   
            }

                        
            if(objAcudiente!= null)     objPoliza.NombreDesignado__c  =   objAcudiente.Id;
            objPoliza.Id_Externo__c                 =       parRequest.strIdExternoPoliza;
            
            // Actualizar No. de Solicitud
            // ------------------------------------
            if(parRequest.intNumeroSolicitud!=null){
                objPoliza.NumeroSolicitud__c            =       parRequest.intNumeroSolicitud;
                objPoliza.Name                          =      '0';
            }
            
            // Actualizar No. de Poliza
            // ------------------------------------         
            if(parRequest.intNumeroPoliza!=null){
                objPoliza.N_PolizaPlan__c               =       String.ValueOf(parRequest.intNumeroPoliza);
                objPoliza.Name                          =       String.ValueOf(parRequest.intNumeroPoliza);
            }        
            
            /*Validar si existe la oportundiad*/ 
            Opportunity objOpp ;
            System.debug('parRequest.strNumeroOportunidad->'+parRequest.strNumeroOportunidad);
            if(parRequest.strNumeroOportunidad !=null && parRequest.strNumeroOportunidad !=''){
                objOpp                      =       getOportunidad(parRequest.strNumeroOportunidad);
                if(objOpp==null){
                    objRtaCompuesta.objPoliza= null;
                    objRtaCompuesta.codigoRespuesta =   '045';
                    objRtaCompuesta.mensajeRespuesta =  'El número de oportunidad enviado no existe';                  
                    return objRtaCompuesta;                   
                }
            }else{
                objOpp=null;
            }
            System.debug('parRequest.strCodigoProducto->'+parRequest.strCodigoProducto);
            if(parRequest.strCodigoProducto== null){
                objRtaCompuesta.objPoliza= null;
                objRtaCompuesta.codigoRespuesta =   '043';
                objRtaCompuesta.mensajeRespuesta =  'Producto Invalido';                    
                return objRtaCompuesta;                  
            }else{
                if(objOpp != null ){ // Asociar la oportundiad existente
                    
                  //  if(objOpp.AccountId ==  objTomador.Id){ // Validar si la oportundiad esta asociada a la cuenta del tomador y actualizarla
                        objOpp= actualizarOportunidadYProductoDeOportunidad(parRequest,objOpp,objTomador, objAcudiente,  objBeneficario,  objAsegurado,idClave);
                        objPoliza.Oportunidad__c   = objOpp.Id;
                        objRtaCompuesta.objOportunidad  =   null;
                    //}else{
                        
                   // }
                }else{// Crear una oportundiad  y su producto relacionado       
                     objOpp                         = crearOportunidadYProductoDeOportunidad(parRequest,objTomador, objAcudiente,  objBeneficario,  objAsegurado,idClave);
                     system.debug('objOpp--22->'+objOpp);
                     objPoliza.Oportunidad__c       = objOpp.Id;
                     objRtaCompuesta.objOportunidad =   objOpp; 
                }
                
               // Asignación de beneficiario a la poliza
               // Si ya existe un benmeficiario en la poliza y el que viene en el servicio
               // Es diferente, entonces se borra el beneficiario actualemente asociado a la poliza
               // y se asocia el nuevo, el que trae el WS
               // El beneficiario se borra desde que no tenga otras polizas u otras oportunidad asociadas
               // -------------------------------------------------------------------------------------------
               system.debug('objBeneficario-tratamiento beneficairo->'+objBeneficario);
               if(objBeneficario!=null) {
                    system.debug('Entro--> objBeneficario-tratamiento beneficairo->'+objBeneficario);
                    if(objPoliza.NombreBeneficiario__c == null){
                        system.debug('Asignar el nuevo beneficiraio porque la poliza no tiene beneficiario->'+objBeneficario.Id);
                        objPoliza.NombreBeneficiario__c         =       objBeneficario.Id;
                    }else{
                        system.debug('Verificación del beneficiario->'+objBeneficario.Id);
                        if(objPoliza.NombreBeneficiario__c !=   objBeneficario.Id){
                            system.debug('Verificación del beneficiario-2->'+objBeneficario.Id);
                            getPolizasBenficiario(objPoliza.NombreBeneficiario__c, objPoliza, objOpp.Id);
                            objPoliza.NombreBeneficiario__c         =       objBeneficario.Id;
                        }
                    }
                }
            
                
                /*Crear producto relacionado a la Poliza*/
                /* --------------------------------------*/
                Product2 objProd = getIdProductoPoliza(parRequest.strCodigoProducto);
                if(objProd!=null){
                    objPoliza.ProductoPlan__c               =       objProd.Id;
                }else{
                    objRtaCompuesta.objPoliza= null;
                    objRtaCompuesta.codigoRespuesta =   '028';
                    objRtaCompuesta.mensajeRespuesta =  'Producto Invalido';                    
                    return objRtaCompuesta;
                }   
                
                //objPoliza.AlturasPagadas__c           =       parRequest.AlturasPagadas__c;   
                objPoliza.TieneAhorro__c                =       parRequest.bolTieneAhorro;      
                objPoliza.AnioMaduracion__c             =       parRequest.strAnoMaduracion;
        
                // BUscar usuario de apoyo institucional
                String idOwnerPublic        = getIdUsuario(parRequest.strApoyoInstitucional);
                if(idOwnerPublic!=null) {
                    objPoliza.ApoyoInstitucional__c = idOwnerPublic;
                }else{
                    objRtaCompuesta.objPoliza= null;
                    objRtaCompuesta.codigoRespuesta =   '026';
                    objRtaCompuesta.mensajeRespuesta =  'Usuario de Apoyo Institucional Inválido';  
                    return objRtaCompuesta;             
                }       
            
                objPoliza.AquienEnviaCorrespondencia__c =       parRequest.strAQuienEenviarCorrespondencia;
                objPoliza.Curso__c                      =       parRequest.strCodigoCurso;
                objPoliza.Estado__c                     =       parRequest.strEstadoPoliza;
                objPoliza.EstadoDocumentoPendiente__c   =       parRequest.strEstadoDocumentosPendientes;
                if(objAsegurado != null)
                objPoliza.Asegurado__c                    =      objAsegurado.id;
                
                //objPoliza.Asegurado__c                    =       parRequest.intCodigoProducto;
                objPoliza.SemestresAdquiridos__c        =       parRequest.strSemestresAdquiridos;
                objPoliza.MotivoPendiente__c            =       parRequest.strMotivoPendiente;
                //objPoliza.EstadoDocumentoPendiente__c   =       parRequest.strDocumentosPendientes;
                String tipoRegistroPoliza = getTipoRegPoliza(parRequest.intCodigoRamo);
                objPoliza.RecordTypeId = tipoRegistroPoliza;
                // Obtener el id de Colegio, ya que el colegio es una lupa a Cuentas
                // -----------------------------------------------------------------  
                system.debug('parRequest.strNombreColegio-->'+parRequest.strNombreColegio);  
                if(parRequest.strNombreColegio!= null){
                    Account ObjColegio = obtenerObjCuenta(parRequest.strNombreColegio);
                    system.debug('ObjColegio-->'+ObjColegio);
                    if(ObjColegio!=null){
                        system.debug('Enre a asigngnar colegio-->'+ObjColegio);           
                        objPoliza.NombreColegio_Jardin__c       =       ObjColegio.Id;
                    }
                }
                //objPoliza.Asegurado__c                =       parRequest.intCodigoFuenteRefMercadeo;
                objPoliza.EstadoInformacionPendiente__c =       parRequest.strEstadoInformacionPendiente;
                objPoliza.FechaEmision__c               =       parRequest.datFechaEmision;
                objPoliza.FechaInicioVigencia__c        =       parRequest.datFechaInicioVigencia;
                objPoliza.FechaProximaRenovacion__c     =       parRequest.datFechaProximaRenovacion;
                objPoliza.FechaTerminacionVigencia__c   =       parRequest.datFechaFinVigencia;             
                objPoliza.FechaRecibo__c                =       parRequest.datFechaRecibo;
                objPoliza.Financiada__c                 =       parRequest.bolFinanciada;
                objPoliza.NCuotasFaltan__c              =       parRequest.strNumeroCuotasFaltanFinanciacion;
                objPoliza.Tasa__c                       =       parRequest.decTasaFinanciacion; 
                objPoliza.ModalidadPago__c              =       parRequest.strModalidadPago;
                objPoliza.FormadePago__c                =       parRequest.strFormaPpago;
                objPoliza.PlazoSeguro__c                =       parRequest.strPlazoSeguroVida;
                objPoliza.TipoMovimiento__c             =       parRequest.strTipoMovimiento;   
                objPoliza.ValorAsegurado__c             =       parRequest.decValorAsegurado;
                objPoliza.ValorPrima__c                 =       parRequest.decValorPrima;
                objPoliza.Sucursal__c                   =       parRequest.strSucursal;
                //objPoliza.                            =       parRequest.intTipoaAgente;
                objPoliza.TieneSeguroVida__c            =       parRequest.bolTieneSeguroVida;
                objPoliza.EntidadFinancia__c            =       parRequest.strEntidadFinancia;
                
                if(parRequest.datFechaTarifa!=null){
                    objPoliza.FechaTarifa__c                =       parRequest.datFechaTarifa;
                }
              
                
                String idCampana = obtenerIdCamapa(String.valueOf(parRequest.intCodigoFuenteRefMercadeo));
                if(idCampana!= null){
                    objPoliza.campana__c =idCampana; 
                }               
                
                String idOwnerPublic2        = getIdUsuario(parRequest.strUsuarioPropietarioPolizaSFDC);
                if(idOwnerPublic2!=null) {
                    objPoliza.OwnerId  = idOwnerPublic2;
                }else{ 
                    objRtaCompuesta.objPoliza= null;
                    objRtaCompuesta.codigoRespuesta =   '030';
                    objRtaCompuesta.mensajeRespuesta =  'Usuario Propietario de la Póliza  Inválido';  
                    return objRtaCompuesta;  
                }
                 
                objPoliza.CalificacionClienteGlobal__c  =       parRequest.strCalificacionClienteGlobal;
                objPoliza.EstadoCredito__c              =       parRequest.strEstadoCredito;
                objPoliza.TipoRefinanciamiento__c       =       parRequest.strTipoRefinanciamiento;
                objPoliza.SaldoCredito__c               =       parRequest.decSaldoCredito;
                objPoliza.ValorExtraPrima__c            =       parRequest.decValorExtraPrima;                
                objPoliza.ParentescoTomadorBeneficiario__c  =       parRequest.strParentescoTomadorBeneficiario; 
                
                /*********** AG[2016-06-27] Nuevos campos para guardar en la póliza***********/
                objPoliza.Fecha_de_Aniversario__c = parRequest.datFechaAniversario;
                objPoliza.Fecha_Proximo_Aniversario__c = parRequest.datFechaProximoAniversario;
                objPoliza.Fecha_de_Pago_Cuota_Inicial__c = parRequest.datFechaPagoCuotaInicial;
                objPoliza.Termin_el_Cr_dito__c = parRequest.blnTerminoCredito;
                objPoliza.Valor_Cuota_de_Financiaci_n__c = parRequest.decValorCuotaFinanciacion;
                objPoliza.NCuotasFaltan__c = parRequest.intNumeroCuotasPendientes;
                objPoliza.FechaRecibo__c = parRequest.datFechaRecibo;
                objPoliza.Valor_Asegurado_Nuevo__c = parRequest.decValorAseguradoNuevo;
                objPoliza.Prima_seg_n_el_Nuevo_Valor__c = parRequest.decPrimaNuevoValor;
                objPoliza.Reserva_de_Ahorro__c = parRequest.blnIntencionAhorro;
                objPoliza.Coberturas__c = parRequest.strCoberturas;
                objPoliza.Conversi_n__c = parRequest.blnEsConversion;
                objPoliza.CurrencyIsoCode = parRequest.strCodigoDivisa;
                /*****************************************************************************/
                               
                System.debug('Se va a crear esta poliza-->'+objPoliza);
                upsert objPoliza;    
                objRtaCompuesta.objPoliza= objPoliza;     
                respuesta_x.codigoRespuesta     =   '000';
                respuesta_x.MensajeRespuesta    =   'Proceso Exitoso';             
                return objRtaCompuesta;
            }
        }
        catch(Exception e){
            objRtaCompuesta.objPoliza= null;
            objRtaCompuesta.codigoRespuesta =   '034';
            objRtaCompuesta.mensajeRespuesta =  'Error en al creación la Poliza:'+e.getMessage();
            system.debug('Error en al creación la Poliza:'+e.getMessage());
            return objRtaCompuesta;
        }         
            
    }

    /* Obtener  Campaña*/
    public static String obtenerIdCamapa(String codCampana){
        system.debug('codCampana-->'+codCampana);
        list<Campaign> lstCampanas;
        lstCampanas =[ SELECT CodigoCampana__c FROM Campaign WHERE CodigoCampana__c =: codCampana];
        system.debug('lstCampanas-->'+lstCampanas);
        if (lstCampanas.size()>0){
            return lstCampanas.get(0).id;
        } 
        return null;
    } 
    

    /* Buscar si el beneficiario de la poliza existe, si existe*/
    public  static void getPolizasBenficiario(String idBeneficiario, Poliza__c objPoliza, String idOportunidad){

        Opportunity objUser;
        list<Opportunity> listOpportunity;
        list<Poliza__c> listPoliza;
        list<Account> listObjBenef;
        Boolean senal=false;
        
        
        system.debug('idBeneficiario->'+idBeneficiario);
        system.debug('objPoliza->'+objPoliza);
        system.debug('idOportunidad->'+idOportunidad);
        
        
        listObjBenef=[select id from Account where id=:idBeneficiario];
        system.debug('Verificación del beneficiario-listObjBenef->'+listObjBenef);
        if(listObjBenef.size()>0){
            
            listOpportunity = [SELECT Id FROM Opportunity where BeneficiarioAsegurado__c=:idBeneficiario];
            system.debug('Verificación del beneficiario-listOpportunity->'+listOpportunity);
            for(Opportunity objOp: listOpportunity) {
                if(objOp.Id != idOportunidad){
                    senal=true;
                }
            }
            
            if(objPoliza.Id != null){
                listPoliza = [SELECT Id FROM Poliza__c where NombreBeneficiario__c=:idBeneficiario];
                system.debug('Verificación del beneficiario-listPoliza->'+listPoliza);
                for(Poliza__c objPol: listPoliza)   {
                    if(objPol.Id != objPoliza.Id){
                        senal=true;
                    }
                }               
            }
            
        }
        
        if(!senal) {
            system.debug('Se elimina el beneficiario anterior->'+listObjBenef.get(0));
            delete listObjBenef.get(0);
        }
     } 
     

/* Obtener  Cuenta*/
    public static Account obtenerObjCuenta(String IdExternoCuenta){
        system.debug('IdExternoCuenta-->'+IdExternoCuenta);
        list<Account> lstCuentas;
        lstCuentas =[ SELECT Id, Name, FirstName, LastName, TipoDocumento__c, NumeroDocumento__c  FROM Account   WHERE Id_Externo__c=: IdExternoCuenta];
        system.debug('lstCuentas-->'+lstCuentas);
        if (lstCuentas.size()>0){
            return lstCuentas.get(0);
        } 
        return null;
    } 
    
 /* Crear una oportundiad */
 public static Opportunity crearOportunidadYProductoDeOportunidad(ObjectCrearyActualizarPolizaRequest parRequest,Account objTomador, Account objAcudiente, Account objBeneficario, Account objAsegurado, String idClave){
        Opportunity objOpp          = new Opportunity ();
        //objOpp.name               = parRequest.strNumeroOportunidad;
        //objOpp.Name                 = 'OPT: '+parRequest.strNombresTomador +' '+parRequest.strPrimerApellidoTomador;
        objOpp.Name                 = 'OPT: '+objTomador.Name; 
        objOpp.StageName            = Label.Gbc_EtapaInicialOportunidad;
        objOpp.CloseDate            = parRequest.datFechaCierre;
        objOpp.AccountId            = objTomador.id;
        if(objBeneficario!= null)   objOpp.BeneficiarioAsegurado__c = objBeneficario.id;
        if(objAcudiente!= null)     objOpp.Designado__c             = objAcudiente.id;
        objOpp.ClaveNo__c           = idClave;
      	
     	objOpp.CurrencyIsoCode 		= parRequest.strCodigoDivisa;
     
        String idOwnerPublic        = getIdUsuario(parRequest.strUsuarioPropietarioPolizaSFDC);
        if(idOwnerPublic!=null) {
            objOpp.OwnerId  = idOwnerPublic;
        }else{
                respuesta_x.codigoRespuesta='030';
                respuesta_x.MensajeRespuesta='Usuario dueño de la Oportunidad Invalido';
        }
        System.debug('Se va a crear esta Oportundiad-->'+objOpp);
        insert objOpp;
        crearProducto(parRequest.strCodigoProductoDummy,objOpp,parRequest.decValorPrima);
        return objOpp;
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
     
  /* Crear una oportundiad */
 public static Opportunity actualizarOportunidadYProductoDeOportunidad(ObjectCrearyActualizarPolizaRequest parRequest,Opportunity objOpp,Account objTomador, Account objAcudiente, Account objBeneficario, Account objAsegurado, String idClave){
        //objOpp.name                 = parRequest.strNumeroOportunidad;
        //objOpp.StageName            = parRequest.strEstadoPoliza;
        //objOpp.CloseDate            = parRequest.datFechaFinVigencia;
        objOpp.AccountId            = objTomador.id;
        if(objBeneficario!= null)   objOpp.BeneficiarioAsegurado__c = objBeneficario.id;
        if(objAcudiente!= null)     objOpp.Designado__c             = objAcudiente.id;
        objOpp.ClaveNo__c           = idClave;       
        String idOwnerPublic        = getIdUsuario(parRequest.strUsuarioPropietarioPolizaSFDC);
        if(idOwnerPublic!=null) {
            objOpp.OwnerId  = idOwnerPublic;
        }else{
                respuesta_x.codigoRespuesta='030';
                respuesta_x.MensajeRespuesta='Usuario dueño de la Oportunidad Invalido o Inactivo';
        }        
        
        update objOpp;
        System.debug('Se va a Actualizar esta Oportundiad-->'+objOpp);
     	
     	//AG: Ajuste para actualizar el importe
     	crearProducto(parRequest.strCodigoProductoDummy,objOpp,parRequest.decValorPrima);
     
        return objOpp;
 }
 
 /* Crear producto de Oportunidad */
 public static OpportunityLineItem crearProducto( String codProducto, Opportunity objOpp, Decimal valorPrima){
            OpportunityLineItem objOLI;
            PricebookEntry      objPBE          = new PricebookEntry();
            //objOLI.ProductCode=productoComerncial;
            
            system.debug('objOLI-crearProducto->'+objOLI);
            Product2 objProd = getIdProducto(codProducto);
            system.debug('objProd-crearProducto->'+objProd);
            if(objProd!=null){
            	objOpp.Producto_Comercial__c = objProd.Name;
                objPBE = getIdEntradaListaPrecio(objProd.Id);
                system.debug('objPBE-crearProducto->'+objPBE);
                IF(objPBE!= NULL){
                    OpportunityLineItem idOLI = getIdOpportunityLineItem(objPBE.Id,objOpp);
                    if(idOLI!=null){
                        objOLI                  = new   OpportunityLineItem (id=idOLI.id);
                        //objOLI.OpportunityId  = objOpp.Id;
                        //objOLI.PricebookEntryId=objPBE.Id;                        
                        system.debug('Actualizo producto por oportunidad->'+objOLI);
                        objOLI.Quantity         = 1;
                        objOLI.UnitPrice = valorPrima!=null?valorPrima:0;
                        update objOLI;
                    }else{
                        objOLI                  = new   OpportunityLineItem ();
                        objOLI.OpportunityId    = objOpp.Id;
                        objOLI.PricebookEntryId =objPBE.Id;
                        objOLI.Quantity         = 1;
                        objOLI.UnitPrice 		= valorPrima!=null?valorPrima:0;
                        system.debug('Creo producto por oportunidad->'+objOLI);
                        insert objOLI;      
                    }
 
                }else{
                respuesta_x.codigoRespuesta='006';
                respuesta_x.MensajeRespuesta='Entrada Producto Invalido';  
                }
            }else{
                respuesta_x.codigoRespuesta='006';
                respuesta_x.MensajeRespuesta='Producto Invalido';
            }
            return objOLI;
 }

 
 /* Obtener el Id de un producto */
 public static OpportunityLineItem getIdOpportunityLineItem( String idOLI, Opportunity objOpp){
    OpportunityLineItem objOLI;
    list<OpportunityLineItem> listOli = [
        SELECT 	id, OpportunityId  
        FROM 	OpportunityLineItem 
        WHERE	OpportunityId=:objOpp.id
    			//AND PricebookEntryId=:idOLI
    ];

    
    if(listOli.size()>0) {
        objOLI = listOli.get(0);
    }else{
        objOLI=null;
    }
    return objOLI;
 }
 
 /* Obtener el Id de un producto */
 public static Product2 getIdProducto( String codProducto){
    Product2 objProd;
    list<Product2> listProd = [SELECT CodigoRamo__c,Compania__c,Description,EsProductoComercial__c,Id,IdentificadorProducto__c,
                                Name,Plan__c,ProductCode,Ramo__c,TipoPlan__c,TipoProducto__c 
                                FROM Product2
                                where IdentificadorProducto__c=:codProducto];

    
    if(listProd.size()>0) {
        objProd = listProd.get(0);
    }else{
        objProd=null;
    }
    return objProd;
 }
 
 
  /* Obtener el Id de un producto */
 public static Product2 getIdProductoPoliza( String codProducto){
    Product2 objProd;
    list<Product2> listProd = [SELECT CodigoRamo__c,Compania__c,Description,EsProductoComercial__c,Id,IdentificadorProducto__c,
                                Name,Plan__c,ProductCode,Ramo__c,TipoPlan__c,TipoProducto__c 
                                FROM Product2
                                where IdentificadorProducto__c=:codProducto];

    
    if(listProd.size()>0) {
        objProd = listProd.get(0);
    }else{
        objProd=null;
    }
    return objProd;
 }
  
 /* Obtener la poliza, identificando si existe, usando los campos: Numero de poliza y Sucursal */
 public static Poliza__c getPoliza( String codIdExternoPoliza){
    Poliza__c objPoliza;
    list<Poliza__c> listPoliza = [SELECT id,Name,NombreBeneficiario__c    FROM Poliza__c  where   Id_Externo__c =:codIdExternoPoliza];

    
    if(listPoliza.size()>0) {
        objPoliza = listPoliza.get(0);
    }else{
        objPoliza=null;
    }
    return objPoliza;
 }
 /* Obtener el Id de la entrada de lista de precio asociada al producto*/
 public static PricebookEntry getIdEntradaListaPrecio( String idProducto){
    PricebookEntry objELP;
    list<PricebookEntry> listELP = [SELECT Id,Name,ProductCode, IsActive
                                    FROM PricebookEntry
                                    Where Product2Id=:idProducto
                                    and Pricebook2Id=:Label.Gbc_IdListaPrecioEstandar
                                    and IsActive=true
                                   ];
    
    if(listELP.size()>0) {
        objELP = listELP.get(0);
    }else{
        listELP=null;
    }
    return objELP;
 }

       
  
 /* Buscar una oportundiad en la base de datos por Nuumero de oportunidad*/
 public static Opportunity getOportunidad(String numeroOportundidad){
 
    Opportunity objOpp;
    list<Opportunity> listOpp = [SELECT Id,Name,AccountId FROM Opportunity where IdentificadorOportunidad__c=:numeroOportundidad];
    
    if(listOpp.size()>0) {
        objOpp = listOpp.get(0);
    }else{
        objOpp=null;
    }
    return objOpp;  
 }

 /* Buscar id de Pais*/
 public static String getIdPais(String codPais){
 
    Ciudades__c obCiudad;
    list<Ciudades__c> listCiudades = [SELECT Id FROM Ciudades__c where Codigo__c=:codPais and EsPais__c =true];
    
    if(listCiudades.size()>0) {
        obCiudad = listCiudades.get(0);
        return obCiudad.Id;
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
 
  /* Obtenerel id del tipo de registro de la poliza de acuerdo con el ramo*/
 public static String getTipoRegPoliza(Integer intCodRamo){
    string rtype=null;
    String strRamo;
    String strCodRamo = String.valueOf(intCodRamo);
      RamoTipoRegistroPolizas__c recordTypex     = RamoTipoRegistroPolizas__c.getInstance(strCodRamo); 
      system.debug('getTipoRegPoliza-codRamo->'+strCodRamo);
      if(recordTypex != null){
            if (recordTypex.NombreTipoRegistro__c != null){
                strRamo=recordTypex.NombreTipoRegistro__c;
                
            }else{
                strRamo='Default';
            }
      }else{
        strRamo='Default';
      } 
      system.debug('getTipoRegPoliza-strRamo->'+strRamo);
      
       list<RecordType> listaRT = [SELECT id,DeveloperName,Name,NamespacePrefix,SobjectType 
                                    FROM RecordType WHERE SobjectType = 'Poliza__c' 
                                    AND DeveloperName =:strRamo];
        system.debug('getTipoRegPoliza-listaRT->'+listaRT);
        if(listaRT.size()>0){
            rtype = listaRT.get(0).Id;
        }else{
            rtype=null;
        }
        system.debug('getTipoRegPoliza-rtype->'+rtype);
      return rtype;                                                                              
 } 
 
  

 /* Obtener la descripcion de un tipo de documento*/
 public static String getIdClave(String strCodClave){
    Contact  objClave;
    list<Contact> listClave = [SELECT id,Name FROM Contact WHERE IdExterno__c=:strCodClave LIMIT 1];    
    if(listClave.size()>0) {
            return listClave.get(0).id;
    }else{
        return null;
    }   
 } 
      
 // ----------------------------------------------------------------
 // Clase que contiene el objeto Response de todos los métodos.
 // --------------------------------------------------------------
  global class ObjectResponse 
    {
      webservice String codigoRespuesta;
      webservice String MensajeRespuesta;
      webservice String idCuenta;                              
    }


 // ----------------------------------------------------------------
 // Clase que contiene el objeto Response del metodo de creacion de polizas.
 // --------------------------------------------------------------
  global class ObjectResponsePoliza 
    {
      webservice String strnumeroOportunidad;
      webservice Integer intCodigoRamo;
      webservice String strnombreBeneficiario;
      webservice Integer inttipoDocumento;
      webservice String strnumeroDocumento;
      webservice String strusuarioSFDC;
      webservice String codigoRespuesta;
      webservice String MensajeRespuesta;
      webservice String idTomador;    
      webservice String idDesignado;    
      webservice String idBeneficiario;    
      webservice String idAsegurado;                                
    }
    
// -------------------------------------------------------------------------------
// Clase que contiene el objeto Request de los metodo creas yt actualizar Póliza.
// -------------------------------------------------------------------------------
  global class ObjectCrearyActualizarPolizaRequest 
  {
    Webservice String   strUsuarioPropietarioPolizaSFDC;
    webservice String   strCodigoOperacion;
    webservice String   strNumeroOportunidad;
    webservice Integer  intNumeroSolicitud;
    webservice Integer  intNumeroPoliza;
    webservice String   strIdExternoPoliza;
    webservice Integer  intCodigoRamo;
    webservice String   strCodigoProducto;
    webservice String   strCodigoProductoDummy;
    webservice String   strSemestresAdquiridos;
    webservice String   strAnoMaduracion;
    webservice String   strIdExternoClaveAgente;
    webservice String   strNombreColegio;
    webservice Integer  intCodigoFuenteRefMercadeo;
    webservice String   strCodigoCurso;
    webservice String   strEstadoPoliza;
    webservice String   strMotivoPendiente;
    webservice String   strEstadoDocumentosPendientes;
    webservice String   strDocumentosPendientes;
    webservice String   strEstadoInformacionPendiente;
    webservice Date     datFechaEmision;
    webservice Date     datFechaInicioVigencia;
    webservice Date     datFechaProximaRenovacion;
    webservice Date     datFechaFinVigencia;
    webservice Date     datFechaRecibo;
    webservice Date     datFechaTarifa; 
    webservice Boolean  bolFinanciada;
    webservice String   strEntidadFinancia;
    webservice Integer  strNumeroCuotasFaltanFinanciacion;
    webservice Decimal  decTasaFinanciacion;
    webservice String   strModalidadPago;
    webservice String   strFormaPpago;
    webservice String   strPlazoSeguroVida;
    webservice Boolean  bolTieneAhorro;
    webservice Boolean  bolTieneSeguroVida; 
    webservice String   strTipoMovimiento;
    webservice Decimal  decValorAsegurado;
    webservice Decimal  decValorPrima;
    webservice String   strApoyoInstitucional;
    webservice String   strAQuienEenviarCorrespondencia;
    webservice String   strSucursal;
    webservice Integer  intTipoaAgente;    
    
    /********* Nuevos datos para la poliza *************/
    webservice String stridExternoTomador;
    webservice String stridExternoAcudiente;
    webservice String stridExternoBeneficiario;
    webservice String stridExternoAsegurado;
    webservice String stridExternoBeneficiario2;
    /***************************************************/
    
    webservice String   strCalificacionClienteGlobal;
    webservice String   strEstadoCredito;
    webservice String   strTipoRefinanciamiento;
    webservice Decimal  decSaldoCredito;
    webservice Decimal  decValorExtraPrima;
    webservice String   strCoberturas;
    webservice String   strParentescoTomadorBeneficiario;   
    
    /********* Nuevos datos para la poliza *************/
    webservice Date datFechaCierre;
    webservice Date datFechaAniversario;
    webservice Date datFechaProximoAniversario;
    webservice Date datFechaPagoCuotaInicial;
    webservice Boolean blnTerminoCredito;
    webservice Decimal decValorCuotaFinanciacion;
    webservice Integer intNumeroCuotasPendientes;
    webservice Decimal decValorAseguradoNuevo;
    webservice Decimal decPrimaNuevoValor;
    webservice Boolean blnIntencionAhorro;
    webservice Boolean blnEsConversion;
    webservice String  strCodigoDivisa;
    /***************************************************/
  }      

// -------------------------------------------------------------------------------
// Clase que contiene el objeto Request de los metodo crear y actualizar Cuenta.
// -------------------------------------------------------------------------------
  global class ObjectActualizarCuentaRequest
  {
    webservice String   strNombres;
    webservice String   strPrimerApellido;
    webservice String   strSegundoApellido;
    webservice String   strTipoPersona;
    webservice Integer  intTipoIdentificacion;
    webservice String   strNumeroIdentificacion;
    webservice String   stridExternoCuenta;
    Webservice String   strUsuarioPropietarioSFDC;
    webservice String   strNacionalidad;
    webservice String   strGenero;
    webservice Date     datFechaNacimiento;
    webservice String   strCiudadNacimiento;
    webservice Date     datFechaFallecimiento;
    webservice String   strEstadoCivil;
    webservice String   strDireccionCorrespondencia;
    webservice String   strTelefonoCorrespondenciaResidencia;
    webservice String   strTelefonoCorrespondenciaOficina;
    webservice String   strCiudadCorrespondencia;
    webservice String   strFaxCorrespondencia;
    webservice String   strCorreoElectronicoCorrespondencia;
    webservice String   strCelularCorrespondencia;
    webservice String   strOcupacion;
    
    /***** Nuevos campo para guardar en la Cuenta AG[2016-06-23]********/
    webservice String   strEmpresa;
    webservice String   strCiudadTelCorrespondencia;
    webservice String   strCiudadTelOficina;
    webservice String   strTipoCuenta;
    webservice String   strCalidadPersonaGS;
    webservice String   strCalidadPersonaGE;
    webservice String   strValidacionCorreo;
    webservice String   strEstadoAsesor;
    
    /************************************************************************/
    
    
}

  // ----------------------------------------------------------------
 // Clase que contiene el objeto Response edl método de armar pliza.
 // --------------------------------------------------------------
  global class ObjectResponsePolizaOportunidad 
    {
      webservice Poliza__c      objPoliza;
      webservice Opportunity    objOportunidad;  
      webservice String codigoRespuesta;
      webservice String MensajeRespuesta;                               
    }
    
 // ----------------------------------------------------------------
 // Clase que contiene el objeto Response de todos los métodos.
 // --------------------------------------------------------------
  global class ObjectActualizarCuentaResponse 
    {
      webservice String codigoRespuesta;
      webservice String MensajeRespuesta;                            
    }
}