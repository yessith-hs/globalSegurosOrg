/******************************************************************************************************************
Desarrollado por:               Avanxo Colombia 
Autor:                          Sergio Ortiz
Proyecto:                       Global Seguros
Descripción:                    Clase que implementa la lógica de negocio para realizar las siguientes operaciones:
                                - Exponer un webservice para capturar informacion de cotizaciones de seguros.
                                - llamar a los metodos para:
                                    - Crear un Tomador/Cuenta si no existe; en caso contrario actualizarla.
                                    - Crear un Beneficiario/Cuenta si no existe; en caso contrario actualizarla.
                                    - Crear una Oportunidad si no exite; en caso contrario actualizarla.
                                    - Crear una Cotización y Partida de Cotización para la Oportunidad especificada.                            
Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No.     Fecha           Autor                   Descripción
-------------------------------------------------------------------------------------------------------
1.0     04/04/2014      Manuel Medina Pérez     Creación de la clase.
1.1     19/04/2014      Sergio Andres Ortiz     Capturar la informacion del cotizador dependiendo del tipo de seguro
1.2     02/05/2014      Luis Rafael Peñaranda   Ajustes por pruebas y control de errores
1.3     23/06/2016      Andrés Garrido          Ajustes para incluir nuevos campos en el servicio
*******************************************************************************************************************/
global virtual class RecibirInfoCotizadorWS {
    public  static CotizacionResponse                  rtaGlobal    = new CotizacionResponse();  

  
  
    //Clase que define los campos Comunes para todos los productos. 
    global virtual class DatosCotizacion    {   
        Webservice String strCodCotizadorOrigen;
        Webservice String strUsuarioSFDC;
        Webservice String strNombreOportunidad;
        Webservice String strNumOportunidad;
        Webservice String strUsuarioClave;
        Webservice Integer intNumCotizacion;
        Webservice String strIdExternoTomador;
        Webservice String strTipoCuentaTomador;     //AG[2016-06-23] Campo para guardar el tipo de registro del tomador
        Webservice String strOrigenCandidato;       //AG[2016-09-01] Campo para guardar el origen de la cuenta
        Webservice Integer intTipoIdentificacion;
        Webservice String strNmrIdentificacion;
        Webservice String strNombreTomador;
        Webservice String strPriApellidoTomador;
        Webservice String strSegApellidoTomador;
        Webservice Integer intDiaNacimiento;
        Webservice Integer intMesNacimiento;
        Webservice Integer intAnoNacimiento;
        Webservice String strGeneroTomador;
        Webservice Boolean bolActividad;
        Webservice String strTelefono;
        Webservice String strCelular;
        Webservice String strCorreoElectronico;      
        Webservice String strCiudadTomador;
        Webservice String strDirTomador;
        Webservice Date   datFechaCotizacion; 
        Webservice String strProducto;
        Webservice String strProductoComercial;
        Webservice String strPlazoSeguro;
        Webservice String strModalidadPago;     
        Webservice String strFormaPago;
        Webservice Decimal decValorAsegurado;
        Webservice Boolean bolAnexMuerteAcc;
        Webservice Boolean bolAnexEnfermdGrave;
        Webservice Boolean bolAnexInvalidez;
        Webservice Decimal decValorPrima;
        Webservice String strOpcionCotizacion;
        Webservice Integer intNumSalariosMin;
        Webservice Decimal decValorMensualDisp;
        Webservice Decimal decAporteUnico;
        Webservice Integer intNroAnosPension;
        Webservice Integer intEdadDeseaPension;
        Webservice String strIdExternoBeneficiario; 
        Webservice String strTipoCuentaBeneficiario;        //AG[2016-06-23] Campo para guardar el tipo de registro del beneficiario
        Webservice Integer intTipIdentifBenef;
        Webservice String strNroIdentifBenef;       
        Webservice String strNombreBenef;
        Webservice String strGeneroBeneficiario;        
        Webservice String strPriApellidoBenef;
        Webservice String strSegApellidoBenef;
        Webservice Integer intDiaNaciBenef;
        Webservice Integer intMesNaciBenef;
        Webservice Integer intAnoNaciBenef;
        
        /***** Datos para el segundo beneficiario AG[2016-06-23]********/
        Webservice String strIdExternoBeneficiario2;
        Webservice String strTipoCuentaBeneficiario2;       
        Webservice Integer intTipIdentifBenef2;
        Webservice String strNroIdentifBenef2;       
        Webservice String strNombreBenef2;
        Webservice String strGeneroBeneficiario2;        
        Webservice String strPriApellidoBenef2;
        Webservice String strSegApellidoBenef2;
        Webservice Integer intDiaNaciBenef2;
        Webservice Integer intMesNaciBenef2;
        Webservice Integer intAnoNaciBenef2; 
        /**************************************************************/
         
        Webservice Integer intAnoMaduracion;
        Webservice String strNombreColegio;     
        Webservice String strCodigoCurso;      
        Webservice Date   datFechaTarifa;           
        Webservice Boolean bolFinanciada;
        
        /***** Nuevos campo para guardar en la Oportunidad AG[2016-06-23]********/
        WebService String strIdOportunidad;
        WebService String strUsuarioConLicencia;
        WebService String strUsuarioSinLicencia;
        WebService String strIntermediario;
        WebService Integer intNumeroSemestres;
        Webservice Date   datFechaCierre;
        WebService String strEvento;
        WebService String strCodigoDivisa;
        WebService String strObservaciones;
        /************************************************************************/
        
    }            



    //Clase que define los campos del Response del webservice.
    global class CotizacionResponse {
        Webservice String CodRta;   
        Webservice String MnsjRta;
        Webservice String strIdOportunidad;  
    }
       
    /**
    *   Precondición:       Debe estar expuesto el webservice.                                                                          
    *   Postcondición:      
    *   @Description:       Webservice que captura información desde SISE para crear y/o actualizar
                            Cuentas, Oportunidades, Cotizaciones y Partidas de Cotización.
        @infCotizacion:     Objeto de la clase VidaIndividualRequest; que contiene los campos del Request
    **/   
    WebService static CotizacionResponse informarCotizacion(DatosCotizacion infCotizacion)
    {  
        CotizacionResponse                  rta                 = new CotizacionResponse();                             
        TransforDatos_cls.AccountMessage    ObjCuentaMsg        = new TransforDatos_cls.AccountMessage();
        TransforDatos_cls.AccountMessage    ObjCuentaBenefMsg   = new TransforDatos_cls.AccountMessage();
        TransforDatos_cls.AccountMessage    ObjCuentaBenef2Msg  = new TransforDatos_cls.AccountMessage();           
        TransforDatos_cls.QuoteMessage      quoteMsg            = new TransforDatos_cls.QuoteMessage();
        TransforDatos_cls                   enviarDatos         = new TransforDatos_cls();
        CRUDGlobal_cls                      crudVida            = new CRUDGlobal_cls();
        TransforDatos_cls.QuoteMessage      objQuoteMessage;
        TransforDatos_cls.OpportunityMessage objOpMess;
        
        // Seteo Inicial de la respuesta del proceso
        rta.CodRta                   = '000'; 
        rta.MnsjRta                  = 'Proceso Exitoso';
        rta.strIdOportunidad         = '';
        
        system.debug('infCotizacions-xx->'+infCotizacion);
        system.debug('infCotizacion.strCodCotizadorOrigen-xx->'+infCotizacion.strCodCotizadorOrigen);
        
        // Iniciar la tansacción que contenga todas las operaciones del servicio
        // ---------------------------------------------------------------------
        Savepoint sp = Database.setSavepoint();
            
            
        // Validar e instanciar la cuenta del tomadoar
        // -------------------------------------------
        if(infCotizacion.strIdExternoTomador != null){  
            
            ObjCuentaMsg    = enviarDatos.ValidaCuenta(infCotizacion,'T');
            rta.CodRta      = ObjCuentaMsg.respuesta_y.codigoRespuesta;
            rta.MnsjRta     = ObjCuentaMsg.respuesta_y.MensajeRespuesta;
            
            if(rta.CodRta == '000'){
                Boolean existeTomador = getExisteCuenta(ObjCuentaMsg.objaCuenta);
                system.debug('existeTomador-->'+existeTomador);
                system.debug('Owner Tomador-->'+ObjCuentaMsg.objaCuenta.OwnerId);
                if(!existeTomador){
                    if(infCotizacion.strUsuarioSFDC != null && infCotizacion.strUsuarioSFDC!= ''){
                        String idUser = getIdUsuario(infCotizacion.strUsuarioSFDC);
                        if(idUser!= null){
                            ObjCuentaMsg.objaCuenta.OwnerId=idUser;
                            if(infCotizacion.strOrigenCandidato != null)
                            	objCuentaMsg.objaCuenta.PersonLeadSource = infCotizacion.strOrigenCandidato;
                            ObjCuentaMsg = crudVida.UpsertCuenta(ObjCuentaMsg.objaCuenta);
                        }
                        else{
                            rta.CodRta          = '016';
                            rta.MnsjRta         = 'Usuario Salesforce no existe';
                        }
                        system.debug('idUser-->'+idUser);
                    }
                }
                else{
                    ObjCuentaMsg = getCuentaCuenta(ObjCuentaMsg.objaCuenta);
                    
                }
                rta.CodRta      = ObjCuentaMsg.respuesta_y.codigoRespuesta;
                rta.MnsjRta     = ObjCuentaMsg.respuesta_y.MensajeRespuesta;
            }
        }
        
        
        system.debug('rta.CodRta-1->'+rta.CodRta);
        system.debug('rta.MnsjRta-1->'+rta.MnsjRta); 
        // Validar e instanciar la cuenta del beneficiario
        // -------------------------------------------
        if(infCotizacion.strIdExternoBeneficiario != null && rta.CodRta=='000'){  
            ObjCuentaBenefMsg   = enviarDatos.ValidaCuenta(infCotizacion,'B');
            rta.CodRta          = ObjCuentaBenefMsg.respuesta_y.codigoRespuesta;
            rta.MnsjRta         = ObjCuentaBenefMsg.respuesta_y.MensajeRespuesta;
            if(rta.CodRta == '000'){
                Boolean existeBenef = getExisteCuenta(ObjCuentaBenefMsg.objaCuenta);
                if(!existeBenef){
                    String idUser = getIdUsuario(infCotizacion.strUsuarioSFDC);
                    if(idUser!= null){
                        ObjCuentaBenefMsg.objaCuenta.OwnerId=idUser;
                        ObjCuentaBenefMsg = crudVida.UpsertCuenta(ObjCuentaBenefMsg.objaCuenta);
                    }
                    else{
                        rta.CodRta          = '016';
                        rta.MnsjRta         = 'Usuario Salesforce no existe';
                    }
                    system.debug('idUserBenef-->'+idUser);
                }else{
                    ObjCuentaBenefMsg = getCuentaCuenta(ObjCuentaBenefMsg.objaCuenta);
                }
                rta.CodRta      = ObjCuentaBenefMsg.respuesta_y.codigoRespuesta;
                rta.MnsjRta     = ObjCuentaBenefMsg.respuesta_y.MensajeRespuesta;
            }
        }
         
        system.debug('rta.CodRta-2->'+rta.CodRta);
        system.debug('rta.MnsjRta-2->'+rta.MnsjRta);
        // Validar e instanciar la cuenta del beneficiario 2
        // -------------------------------------------
        if(infCotizacion.strIdExternoBeneficiario2 != null && rta.CodRta=='000'){  
            ObjCuentaBenef2Msg   = enviarDatos.ValidaCuenta(infCotizacion,'B2');
            rta.CodRta          = ObjCuentaBenef2Msg.respuesta_y.codigoRespuesta;
            rta.MnsjRta         = ObjCuentaBenef2Msg.respuesta_y.MensajeRespuesta;
            
            if(rta.CodRta == '000'){
                Boolean existeBenef2 = getExisteCuenta(ObjCuentaBenef2Msg.objaCuenta);
                if(!existeBenef2){
                    String idUser = getIdUsuario(infCotizacion.strUsuarioSFDC);
                    if(idUser!= null){
                        ObjCuentaBenef2Msg.objaCuenta.OwnerId=idUser;
                        ObjCuentaBenef2Msg = crudVida.UpsertCuenta(ObjCuentaBenef2Msg.objaCuenta);
                    }
                    else{
                        rta.CodRta          = '016';
                        rta.MnsjRta         = 'Usuario Salesforce no existe';
                    }
                    system.debug('idUserBenef2-->'+idUser);
                }else{
                    ObjCuentaBenef2Msg = getCuentaCuenta(ObjCuentaBenef2Msg.objaCuenta);
                }
                rta.CodRta      = ObjCuentaBenef2Msg.respuesta_y.codigoRespuesta;
                rta.MnsjRta     = ObjCuentaBenef2Msg.respuesta_y.MensajeRespuesta;
            }
        }
        system.debug('rta.CodRta-3->'+rta.CodRta);
        system.debug('rta.MnsjRta-3->'+rta.MnsjRta);    
        if(infCotizacion.intNumCotizacion == 0 || infCotizacion.intNumCotizacion == null){
            rta.CodRta = '032'; 
            rta.MnsjRta = 'El numero de cotizacion esta en ceros'; 
        }
            
        if(rta.CodRta == '000'){
            Opportunity objOp1;
            if(infCotizacion.strNumOportunidad != null && infCotizacion.strNumOportunidad != ''){
                objOp1 = getOportunidad(infCotizacion.strNumOportunidad);
                crearProducto(infCotizacion.strProductoComercial,objOp1, infCotizacion.decValorPrima);
                quoteMsg = enviarDatos.procesarCotizacion(infCotizacion,objOp1);
                system.debug('quoteMsg.respuesta_y.codigoRespuesta-IF->'+quoteMsg.respuesta_y.codigoRespuesta);
                if(quoteMsg.respuesta_y.codigoRespuesta.equals('000')){
                    objQuoteMessage =   crudVida.UpsertCotizacion(quoteMsg.objQuote, infCotizacion.strNumOportunidad);
                    rta.strIdOportunidad = objOp1.IdentificadorOportunidad__c;
                }else{
                    rta.CodRta      = quoteMsg.respuesta_y.codigoRespuesta;
                    rta.MnsjRta     = quoteMsg.respuesta_y.MensajeRespuesta;                    
                }             
            }
            else{
                objOp1 = crearOportunidadYProductoDeOportunidad(infCotizacion , ObjCuentaMsg.objaCuenta,ObjCuentaBenefMsg.objaCuenta);
                if(rtaGlobal.CodRta.equals('000')){
                    String strNumOpp = [Select IdentificadorOportunidad__c From Opportunity Where Id = :objOp1.Id][0].IdentificadorOportunidad__c;
                    rta.strIdOportunidad = strNumOpp; //AG[2016-06-23] Se incluye el IdentificadorOportunidad__c de la oportunidad en la respuesta del servicio                                    
                    system.debug('@@-ObjCuentaMsg-->'+ObjCuentaMsg); 
                }else{
                    //rta.CodRta      = objOpMess.respuesta_y.codigoRespuesta;
                    //rta.MnsjRta     = objOpMess.respuesta_y.MensajeRespuesta;
                    rta.CodRta      = rtaGlobal.CodRta;
                    rta.MnsjRta     = rtaGlobal.MnsjRta;   
                    //return rta;                                
                }
                
                
            }
            system.debug('rta.CodRta-4->'+rta.CodRta);
            system.debug('rta.MnsjRta-4->'+rta.MnsjRta); 
            if(rta.CodRta == '000'){
                //Se actualizan los datos de la oportundiad
                if(ObjCuentaMsg.objaCuenta!=null)
                	objOp1.AccountId = ObjCuentaMsg.objaCuenta.Id;
                if(ObjCuentaBenefMsg.objaCuenta!=null)
                	objOp1.BeneficiarioAsegurado__c = ObjCuentaBenefMsg.objaCuenta.Id;
                if(ObjCuentaBenef2Msg.objaCuenta!=null)
                	objOp1.Beneficiario_Contingente__c = ObjCuentaBenef2Msg.objaCuenta.Id;
                
                objOp1.Amount = infCotizacion.decValorPrima;
                objOp1.AnoMaduracion__c = infCotizacion.intAnoMaduracion;
                objOp1.NumeroSemestresOfrecidos__c = infCotizacion.intNumeroSemestres!=null ? infCotizacion.intNumeroSemestres : null;
                objOp1.Datos_Contacto_Comercial__c = crearDatoContactoComercial(infCotizacion, objOp1).Id;
                objOp1.Curso__c = infCotizacion.strCodigoCurso;
                objOp1.CampaignId = infCotizacion.strEvento;
                objOp1.Description = infCotizacion.strObservaciones;
                
                if(infCotizacion.strUsuarioConLicencia != null){
                    String usrLic = getIdUsuario(infCotizacion.strUsuarioConLicencia);
                    if(usrLic != null)
                        objOp1.Usuario_que_cotiza__c = usrLic;
                }
                if(infCotizacion.strUsuarioSinLicencia != null){
                    Contact conLic = getContact(infCotizacion.strUsuarioSinLicencia);
                    if(conLic != null)
                        objOp1.Asesor_Intermediario_que_cotiza__c = conLic.Id;
                }
                if(infCotizacion.strNombreColegio != null){
                    Account objColegio = getColegio(infCotizacion.strNombreColegio);
                    if(objColegio != null)
                        objOp1.Colegio__c = objColegio.Id;
                }
                
                update objOp1;
                
                quoteMsg = enviarDatos.procesarCotizacion(infCotizacion,objOp1);
                if(quoteMsg.respuesta_y.codigoRespuesta.equals('000')){
                    objQuoteMessage =   crudVida.UpsertCotizacion(quoteMsg.objQuote, infCotizacion.strNumOportunidad);
                    if(objQuoteMessage.respuesta_y.codigoRespuesta.equals('000'))
                        System.debug('...');
                    else{
                        rta.CodRta      = objQuoteMessage.respuesta_y.codigoRespuesta;
                        rta.MnsjRta     = objQuoteMessage.respuesta_y.MensajeRespuesta;
                        rta.strIdOportunidad = '';
                    }
                     
                }else{
                    rta.CodRta      = quoteMsg.respuesta_y.codigoRespuesta;
                    rta.MnsjRta     = quoteMsg.respuesta_y.MensajeRespuesta;
                    rta.strIdOportunidad = '';                    
                }    
            }
        }
            
        if(!rta.CodRta.equals('000')){
            Database.rollback(sp);
        }
            
        return rta;
            
    }
    
    public static Account getColegio(String externalId){
        list<Account> lstAcc = [
            Select Id From Account Where Id_Externo__c = :externalId And RecordType.DeveloperName = 'Instituciones_Educativas'
        ];
        if(!lstAcc.isEmpty())
            return lstAcc[0];
        return null;
    }
    
    public static Contact getContact(String externalId){
        list<Contact> lstContact = [
            Select Id From Contact Where IdExterno__c = :externalId
        ];
        if(!lstContact.isEmpty())
            return lstContact[0];
        return null;
    }
    
    /* Crear dato de contacto comercial */
    public static DatosContactoComercial__c crearDatoContactoComercial(DatosCotizacion infoCuenta, Opportunity objOpp){
        DatosContactoComercial__c dcc;
        if(objOpp.Datos_Contacto_Comercial__c != null) 
            dcc = new DatosContactoComercial__c(Id = objOpp.Datos_Contacto_Comercial__c);
        else
            dcc = new DatosContactoComercial__c();
            
        dcc.OwnerId = objOpp.OwnerId;
        dcc.Cuenta__c = objOpp.AccountId;
        if(infoCuenta.strTelefono           != '')      dcc.Telefono__c                = infoCuenta.strTelefono;
        if(infoCuenta.strCelular            != '')      dcc.Celular__c                 = infoCuenta.strCelular;
        if(infoCuenta.strCorreoElectronico  != '')      dcc.CorreoElectronico__c       = infoCuenta.strCorreoElectronico;
        if(infoCuenta.strDirTomador         != '')      dcc.Direccion__c               = infoCuenta.strDirTomador;


        if(infoCuenta.strCiudadTomador != ''){
            TransforDatos_cls tdcls = new TransforDatos_cls();
            String idCity = tdcls.getIdCiudad(infoCuenta.strCiudadTomador);
            if(idCity != null) {
                dcc.Ciudad__c = idCity;
            }
        }
        
        system.debug('dcc1->'+dcc);
        upsert dcc;
        
        return dcc;
    }

 /* Buscar una oportundiad en la base de datos por Nuumero de oportunidad*/
 public static Opportunity getOportunidad(String strNumOportundidad){
 
    Opportunity objOpp;
    list<Opportunity> listOpp = [
        SELECT  Id,Name,OwnerId,AccountId,BeneficiarioAsegurado__c,Beneficiario_Contingente__c,Amount,AnoMaduracion__c,
                Datos_Contacto_Comercial__c, Usuario_que_cotiza__c, Asesor_Intermediario_que_cotiza__c, NumeroSemestresOfrecidos__c,
                Colegio__c,IdentificadorOportunidad__c
        FROM    Opportunity 
        WHERE   IdentificadorOportunidad__c=:strNumOportundidad
    ];
    
    if(listOpp.size()>0) {
        objOpp = listOpp.get(0);
    }else{
        objOpp=null;
    }
    return objOpp;  
 }


 /* Crear una oportundiad */
 public static Opportunity crearOportunidadYProductoDeOportunidad(DatosCotizacion parRequest,Account objTomador,Account objBeneficiario){
        Opportunity objOpp          = new Opportunity ();
        rtaGlobal.CodRta ='000';
        //objOpp.name               = parRequest.strNumeroOportunidad;
        objOpp.Name                 = 'OPT: '+parRequest.strNombreTomador +' '+parRequest.strPriApellidoTomador; 
        objOpp.StageName            = Label.Gbc_EtapaInicialOportunidadCotizador; 
        if(objTomador != null)
     		objOpp.AccountId            = objTomador.id;
        if(objBeneficiario != null){
            objOpp.BeneficiarioAsegurado__c  = objBeneficiario.id;
        }
        
        //DateTime dT = System.now().addMonths(6);
        //Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
        //objOpp.CloseDate  = myDate;
        if(parRequest.datFechaCierre != null)
        	objOpp.CloseDate  = parRequest.datFechaCierre;
     
     	if(parRequest.strCodigoDivisa != null)
        	objOpp.CurrencyIsoCode = parRequest.strCodigoDivisa;
        // se reutiliza el campo strCelular para enviar el id del promotor
        // 09-01-2015 lrpa
        // [AG: 2016-06-29] Se cambia el mapeo por el nuevo campo del intermediario
        if(parRequest.strIntermediario != null && parRequest.strIntermediario != ''){
             list<Contact> lstContactoY              = [SELECT Id  FROM Contact  WHERE IdExterno__c=: parRequest.strIntermediario];
            if(lstContactoY.size() > 0) {
                objOpp.ClaveNo__c  = lstContactoY.get(0).id;
            }else{ 
                     rtaGlobal.CodRta ='045';
                     rtaGlobal.MnsjRta='Intermediario no existe:'+parRequest.strIntermediario;
            }           
        }
        //objOpp.ClaveNo__c           = idClave;
        
        String idOwnerPublic        = getIdUsuario(parRequest.strUsuarioSFDC);
        if(idOwnerPublic!=null) {
            objOpp.OwnerId  = idOwnerPublic;
        }else{ 
                 rtaGlobal.CodRta ='030';
                 rtaGlobal.MnsjRta='Usuario dueño de la Oportunidad Invalido';
        }
        System.debug('Se va a crear esta Oportundiad-->'+objOpp);
     	
        insert objOpp;
        crearProducto(parRequest.strProductoComercial,objOpp, parRequest.decValorPrima);
        return objOpp;
 }

 /* Crear producto de Oportunidad */
 public static OpportunityLineItem crearProducto( String codProducto, Opportunity objOpp, Decimal decValorPrima){
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
                if(objPBE!= NULL){
                    OpportunityLineItem idOLI = getIdOpportunityLineItem(objPBE.Id,objOpp);
                    if(idOLI!=null){
                        objOLI                  = new   OpportunityLineItem (id=idOLI.id);
                        //objOLI.OpportunityId  = objOpp.Id;
                        //objOLI.PricebookEntryId=objPBE.Id;                        
                        system.debug('Actualizo producto por oportunidad->'+objOLI);
                        objOLI.UnitPrice = decValorPrima!=null?decValorPrima:0;
                        update objOLI;
                    }else{
                        objOLI                  = new   OpportunityLineItem ();
                        objOLI.OpportunityId    = objOpp.Id;
                        objOLI.PricebookEntryId =objPBE.Id;
                        objOLI.Quantity         = 1;
                        objOLI.UnitPrice = decValorPrima!=null?decValorPrima:0;
                        system.debug('Creo producto por oportunidad->'+objOLI);
                        insert objOLI;      
                    }
                     
 
                }else{
                rtaGlobal.CodRta ='006';
                rtaGlobal.MnsjRta='Entrada Producto Invalido';  
                }
            }else{
                rtaGlobal.CodRta ='006';
                rtaGlobal.MnsjRta='Producto Invalido';
            }
            
            return objOLI;
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


 /* Obtener el Id de la entrada de lista de precio asociada al producto*/
 public static PricebookEntry getIdEntradaListaPrecio( String idProducto){
    PricebookEntry objELP;
    list<PricebookEntry> listELP = [SELECT Id,Name,ProductCode,IsActive
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
 
 
  /* Obtener el Id de un producto */
 public static OpportunityLineItem getIdOpportunityLineItem( String idOLI, Opportunity objOpp){
    OpportunityLineItem objOLI;
    list<OpportunityLineItem> listOli = [
        SELECT 	id, OpportunityId  
        FROM 	OpportunityLineItem 
        WHERE	OpportunityId=:objOpp.id 
        		AND PricebookEntryId=:idOLI
    ];

    
    if(listOli.size()>0) {
        objOLI = listOli.get(0);
    }else{
        objOLI=null;
    }
    return objOLI;
 }


  public static boolean getExisteCuenta( Account infoCuenta){
    Boolean existeAccount                       = true;
    list<Account> qryAccountList              = [SELECT Id  FROM Account  
                                                            WHERE Id_Externo__c=: infoCuenta.Id_Externo__c 
                                                            //and (ClienteGlobalEducation__c = true 
                                                            //or  ClienteGlobalSeguros__c = true)
												];
    if(qryAccountList.isEmpty() ==true) existeAccount=false;
    return existeAccount;
  } 
 
 
  public static TransforDatos_cls.AccountMessage getCuentaCuenta( Account infoCuenta){
    TransforDatos_cls.AccountMessage objAccountMsg  = new TransforDatos_cls.AccountMessage();
    objAccountMsg.respuesta_y = new TransforDatos_cls.ObjectResponse();
    objAccountMsg.respuesta_y.codigoRespuesta='000';
    objAccountMsg.respuesta_y.MensajeRespuesta='Proceso Exitoso';       
    list<Account> qryAccountList              = [SELECT Id,TipoPersona__pc,LastName,Genero__pc,FirstName,RecordTypeId,OwnerId  FROM Account  
                                                            WHERE Id_Externo__c=: infoCuenta.Id_Externo__c ];
    if(qryAccountList.isEmpty() ==false) {       
             objAccountMsg.objaCuenta      =   qryAccountList.get(0);
             return     objAccountMsg;  
    }else{
        return null;
    }
  } 
         
}