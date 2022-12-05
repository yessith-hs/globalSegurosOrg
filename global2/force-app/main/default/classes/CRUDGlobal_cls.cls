/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Luis Peñaranda  -  Sergio Andres Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Crear o actualizar las Cuentas para los datos provenientes del Servicio Web RecibirInfoCotizadorWS.
- Crear las Cotizaciones para los datos provenientes del Servicio Web RecibirInfoCotizadorWS.
- Crear las partidas de Cotizacion con los datos provenientes del Servicio Web RecibirInfoCotizadorWS.
- Crear o actualizar las Oportunidades para los datos provenientes del Servicio Web RecibirInfoCotizadorWS.
  
Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No.    Fecha         Autor              Descripción
-------------------------------------------------------------------------------------------------------
1.0 24/04/2014 Sergio Andres Ortiz   Creación de la clase.
2.0 25/04/2014 Luis Peñaranda        Adición de metodos.

*******************************************************************************************************************/

public class CRUDGlobal_cls {

    public string descDocumento;
    public String CodRta;   
    public String MnsjRta;
    public List<String> listRespuesta = new List<String>();  
    public string idCuenta; 
    public String idOwnerPublic=null;
   

    public TransforDatos_cls.AccountMessage UpsertCuenta(Account infoCuenta){
     	Integer lentCadena;
        String sufijo;
        TipoRegistroPersona__c tPersona;  
        system.debug('infoCuenta-4545->'+infoCuenta);
        TransforDatos_cls.AccountMessage objAccountMsg  = new TransforDatos_cls.AccountMessage();  
        objAccountMsg.respuesta_y                       = new TransforDatos_cls.ObjectResponse(); 
        try{
            // Definicion de variables de trabajo 
            Account objAccount                          = new Account(); 
            List<Account> objAccountList                = new List<Account>(); 
            Boolean existeAccount                       = true;
            List<Account> qryAccountList;
            /*List<Account> qryAccountList              = [SELECT Id  FROM Account  WHERE NumeroDocumento__c    =: infoCuenta.NumeroDocumento__c
                                                                                AND TipoDocumento__c        =: infoCuenta.TipoDocumento__c];*/

            qryAccountList              = [SELECT Id  FROM Account  WHERE Id_Externo__c=: infoCuenta.Id_Externo__c];
              

			/**************** AG[2016-06-27] Cambio para asignar el tipo de registro de la cuenta***********/
			/***********************************************************************************************/                                                                                                                               
                                                                                
            //Validar si la lista de tomadores contiene registros.
            if(qryAccountList.isEmpty() ==true) existeAccount=false;
            //Realizar INSERT o UPDATE de la cuenta
            if (existeAccount == true){
                //Asignación del Tipo de Registro teniendo en cuenta el Tipo de Persona.
                if (infoCuenta.TipoDocumento__c == Label.Gbc_TipDocNIT){
                    //TipoRegistroPersona__c tPersona     = TipoRegistroPersona__c.getInstance('Juridica');
                    system.debug('infoCuenta.Id_Externo__c-->'+infoCuenta.Id_Externo__c);
	             	lentCadena  = infoCuenta.Id_Externo__c.length();
	             	system.debug('lentCadena-->'+lentCadena);
	            	sufijo = infoCuenta.Id_Externo__c.mid(lentCadena-2,2);
	            	system.debug('sufijo-->'+sufijo);
	            	if(sufijo== 'GS' || sufijo == 'GE'){
	            		 tPersona                 = TipoRegistroPersona__c.getInstance('Intermediarios');
	            	}else{
	                	 tPersona                 = TipoRegistroPersona__c.getInstance('Juridica');      
	            	} 
	            	                    
                    objAccount.TipoPersona__pc          = tPersona.TipoPersona__c;
                    objAccount.RecordTypeId             = tPersona.TipoRegistro__c;
  
            	                    
                }
                else{
                    //TipoRegistroPersona__c tPersona     = TipoRegistroPersona__c.getInstance('Natural');
	             	lentCadena  = infoCuenta.Id_Externo__c.length();
	            	sufijo = infoCuenta.Id_Externo__c.mid(lentCadena-2,2);
	            	system.debug('sufijo-->'+sufijo);
	            	if(sufijo== 'GS' || sufijo == 'GE'){
	            		 tPersona                 = TipoRegistroPersona__c.getInstance('Intermediarios');
	            		 /*objAccount.TipoPersona__pc=null;
	            		 objAccount.LastName=null;
	            		 objAccount.Genero__pc=null;
	            		 objAccount.FirstName=null;*/
	            	}else{
	                	 tPersona                 = TipoRegistroPersona__c.getInstance('Natural');      
	            	}             
	            	system.debug('tPersona-->'+tPersona);        
                    objAccount.TipoPersona__pc          = tPersona.TipoPersona__c;
                    objAccount.RecordTypeId             = tPersona.TipoRegistro__c;
                    system.debug('objAccount-->'+objAccount);   
                }

                infoCuenta.id = qryAccountList.get(0).id;
                objAccountMsg.respuesta_y.codigoRespuesta   =   '000';
                objAccountMsg.respuesta_y.MensajeRespuesta  =   'Proceso Exitoso'; 
                system.debug('infoCuenta-->'+infoCuenta);
                update infoCuenta;
            }else{
                existeAccount   = false;
                insert infoCuenta;
                objAccountMsg.respuesta_y.codigoRespuesta   =   '000';
                objAccountMsg.respuesta_y.MensajeRespuesta  =   'Proceso Exitoso';  
                objAccountMsg.objaCuenta                    =   infoCuenta;             
                system.debug('@@@ Cuenta ->'+infoCuenta);
            }  
            idCuenta = infoCuenta.Id;
            objAccountMsg.objaCuenta=infoCuenta;
            return objAccountMsg;
        }
        catch(Exception e){
            objAccountMsg.respuesta_y.codigoRespuesta   =   '013';
            objAccountMsg.respuesta_y.MensajeRespuesta  =   'Error al crear la Cuenta:'+e.getMessage(); 
            objAccountMsg.objaCuenta                    =   null;
            return objAccountMsg;
        }
    }


    public TransforDatos_cls.ContactMessage UpsertContacto(Contact infoContacto){ 
     
        TransforDatos_cls.ContactMessage objContactMsg  = new TransforDatos_cls.ContactMessage();  
        objContactMsg.respuesta_y                       = new TransforDatos_cls.ObjectResponse(); 
        Try{ 
            // Definicion de variables de trabajo 
            Contact objContact                          = new Contact(); 
            List<Contact> objContactList                = new List<Contact>(); 
            Boolean existeContact                       = true;
            List<Contact> qryContactList;


            qryContactList              = [SELECT Id  FROM Contact  WHERE IdExterno__c=: infoContacto.IdExterno__c];
                                                                                                                                                
                                                                                
            //Validar si la lista de tomadores contiene registros.
            if(qryContactList.isEmpty() ==true) existeContact=false;
            //Realizar INSERT o UPDATE de la cuenta
            if (existeContact == true){
                //Asignación del Tipo de Registro teniendo en cuenta el Tipo de Persona.
                if (infoContacto.TipoDocumento__c == Label.Gbc_TipDocNIT){
                    TipoRegistroPersona__c tPersona     = TipoRegistroPersona__c.getInstance('Juridica');
                    //objContact.TipoPersona__pc          = tPersona.TipoPersona__c;
                    objContact.RecordTypeId             = tPersona.TipoRegistro__c;
                }
                else{
                    TipoRegistroPersona__c tPersona     = TipoRegistroPersona__c.getInstance('Natural');
                   // objContact.TipoPersona__pc          = tPersona.TipoPersona__c;
                    objContact.RecordTypeId             = tPersona.TipoRegistro__c;
                }

                infoContacto.id = qryContactList.get(0).id;
                objContactMsg.respuesta_y.codigoRespuesta   =   '000';
                objContactMsg.respuesta_y.MensajeRespuesta  =   'Proceso Exitoso';  
                objContactMsg.respuesta_y.idContacto		= 	infoContacto.id;             
                update infoContacto;
                system.debug('@@@ Cuenta ->'+infoContacto);
            }else{
                existeContact   = false;
                insert infoContacto;
                objContactMsg.respuesta_y.codigoRespuesta   =   '000';
                objContactMsg.respuesta_y.MensajeRespuesta  =   'Proceso Exitoso'; 
                objContactMsg.respuesta_y.idContacto		= 	infoContacto.id; 
                objContactMsg.objaContacto                  =   infoContacto;             
                system.debug('@@@ Cuenta ->'+infoContacto);
            }  
            idCuenta = infoContacto.Id;
            objContactMsg.objaContacto=infoContacto;
            return objContactMsg;
        }
        catch(Exception e){
            objContactMsg.respuesta_y.codigoRespuesta   =   '013';
            objContactMsg.respuesta_y.MensajeRespuesta  =   'Error al crear la Cuenta:'+e.getMessage(); 
            objContactMsg.objaContacto                    =   null;
            return objContactMsg;
        }
        
    }
    
    /* Creación y Actualizacion de Beneficiarios*/ 
    public Boolean UpsertBeneficiario(Account infoCuenta){
        Try{
            // Definicion de variables de trabajo
            Account objAccount                          = new Account();
            List<Account> objAccountList                = new List<Account>();
            Boolean existeAccount_bnf                   = true;
            List<Account> qryAccountBnfList             = [SELECT Id
                                                           FROM Account
                                                           WHERE NumeroDocumento__c     = :infoCuenta.NumeroDocumento__c
                                                           AND TipoDocumento__c         = :infoCuenta.TipoDocumento__c
                                                          ];

            //Validar si la lista de Beneficiarios contiene registros.
            if(qryAccountBnfList.isEmpty() ==true) existeAccount_bnf=false;
            //Realizar INSERT o UPDATE del Beneficiario
            if (existeAccount_bnf == true){
                TipoRegistroPersona__c tPersona         = TipoRegistroPersona__c.getInstance('Beneficiario');
                objAccount.Id                           = qryAccountBnfList[0].Id;
                objAccount.TipoPersona__pc              = tPersona.TipoPersona__c;
                objAccount.RecordTypeId                 = tPersona.TipoRegistro__c;
                infoCuenta.id = qryAccountBnfList.get(0).id;
                update infoCuenta;                
            }else{
                TipoRegistroPersona__c tPersona         = TipoRegistroPersona__c.getInstance('Beneficiario');
                objAccount.TipoPersona__pc              = tPersona.TipoPersona__c;
                objAccount.RecordTypeId                 = tPersona.TipoRegistro__c;
                existeAccount_bnf = false;
                insert infoCuenta;
            }
            //idCuenta = infoCuenta.Id;
            return true;
        }
        catch(Exception e){
            return false;
        }
    }

    /*Se Inserta la Cotización  y la partida de cotizacion, Si la cotizacion ya existe, se actualiza, sino se crea una nueva*/
    public TransforDatos_cls.QuoteMessage UpsertCotizacion(Quote infoCotizacion, String strNumOportunidad){
            TransforDatos_cls.QuoteMessage  objQuoteMessage = new TransforDatos_cls.QuoteMessage();
            objQuoteMessage.respuesta_y = new TransforDatos_cls.ObjectResponse(); 
            Quote objQuote                              = infoCotizacion;
            List<Quote> objQuoteList                    = new List<Quote>();
            QuoteLineItem objQuoteLineItem              = new QuoteLineItem();
            List<QuoteLineItem> objQuoteLineItemList    = new List<QuoteLineItem>();
            ListaDePrecios__c listaPrecios              = ListaDePrecios__c.getInstance('Standard');
            Boolean existeQuote                         = true;
            List<Quote> qryQuoteList;
            //SELECT sobre Cotización para la cotización del REQUEST.
            system.debug('UpsertCotizacion-infoCotizacion->'+infoCotizacion);
            system.debug('UpsertCotizacion-strNumOportunidad->'+strNumOportunidad);
        Try{

            upsert objQuote;                
            system.debug('@@-objQuote-->'+objQuote);            
            /*objQuoteLineItem.Quantity = 1;
            objQuoteLineItem.UnitPrice = 100;               
            system.debug('@@-objQuoteLineItem-->'+objQuoteLineItem);
            objQuoteLineItem.QuoteId = objQuote.id;
            Product2 objProd = getIdProducto(infoCotizacion.Producto__c);
            system.debug('objProd-crearProducto->'+infoCotizacion.Producto__c);
            if(objProd!=null){
                objQuoteLineItem.Product2Id=objProd.id;
                PricebookEntry      objPBE = getIdEntradaListaPrecio(objProd.Id);
                system.debug('objPBE-crearProducto->'+objPBE);
                IF(objPBE!= NULL){
                    objQuoteLineItem.PricebookEntryId=objPBE.Id;
                }
            }
                        
            insert objQuoteLineItem;    */                  
            
            objQuoteMessage.objQuote                        = objQuote;
            objQuoteMessage.respuesta_y.codigoRespuesta = '000';
            objQuoteMessage.respuesta_y.MensajeRespuesta    = 'Cotizacion creada exitosamente'; 
            return objQuoteMessage;
        }catch(Exception e){
            objQuoteMessage.objQuote                        = null;
            objQuoteMessage.respuesta_y.codigoRespuesta = '012';
            objQuoteMessage.respuesta_y.MensajeRespuesta    = 'Error al crear la Cotizacion';
            system.debug('@@-listRespuesta->'+listRespuesta);
            return null; 
        }
    }

    /* Crear y Actualizar oportunidades*/    

     public  TransforDatos_cls.OpportunityMessage UpsertOportunidad(String strNumOportunidad, String strNombreOportunidad,Account objTomador,Account objBenef, Quote objCotizacion, String strUsuarioSFDC){
        
        TransforDatos_cls.OpportunityMessage objOpportunityMessage  = new TransforDatos_cls.OpportunityMessage();
        objOpportunityMessage.respuesta_y = new TransforDatos_cls.ObjectResponse();
        Opportunity objOpp  ; 
        try{
            EstadoOportunidad__c estadoOportunidad      = EstadoOportunidad__c.getInstance('Prospecto');
            objOpp                          =  new Opportunity ();
            system.debug('strNumOportunidad-->'+strNumOportunidad);
            system.debug('objTomador-->'+objTomador);
            system.debug('objBenef-->'+objBenef);
            system.debug('objCotizacion-->'+objCotizacion);
            List<Opportunity> objOpportunityList        = new List<Opportunity>();
            Boolean existeOportunidad                   = true;
            
            idOwnerPublic = getIdUsuario(strUsuarioSFDC);
            
            List<Opportunity> qryOpportunityList        = [SELECT Id, AccountId FROM Opportunity  
                                                            WHERE IdentificadorOportunidad__c   = :strNumOportunidad 
                                                            AND AccountId=:objTomador.Id];

            
            if (qryOpportunityList.isEmpty() ==false ) {
                objOpp.Name                 = strNombreOportunidad;         
                objOpp.StageName            = estadoOportunidad.Estado__c;
                objOpp.CloseDate            = objCotizacion.FechaCotizacion__c;
                objOpp.AccountId            = objTomador.id;
                
                if( objBenef != null)   objOpp.BeneficiarioAsegurado__c = objBenef.id; // Asignacion de beneficiarios
                
                system.debug('@@-Actualizo Oportundiad->'+objOpp);
                objOpportunityMessage.objOportunidad    = objOpp;
                objOpportunityMessage.respuesta_y.codigoRespuesta   = '000';
                objOpportunityMessage.respuesta_y.MensajeRespuesta  = 'Cotizacion creada exitosamente';                 
                update objOpp;
            }else{

                objOpp.Name                 = strNombreOportunidad;
                objOpp.StageName            = estadoOportunidad.Estado__c;
                objOpp.CloseDate            = objCotizacion.FechaCotizacion__c;
                objOpp.AccountId            = objTomador.id;
                
                if( objBenef != null)   objOpp.BeneficiarioAsegurado__c = objBenef.id; // Asignacion de beneficiarios
                
                objOpp.OwnerId              = idOwnerPublic;
                system.debug('@@-Creo Oportundiad->'+objOpp);
                insert objOpp;
                objOpportunityMessage.objOportunidad    = objOpp;
                objOpportunityMessage.respuesta_y.codigoRespuesta   = '000';
                objOpportunityMessage.respuesta_y.MensajeRespuesta  = 'Cotizacion creada exitosamente';                 
                }
                system.debug('@@-objCotizacion.ProductoComercial__c-UpsertOportunidad->'+objCotizacion.Producto_Comercial__c);
                system.debug('@@-objOportunidad-UpsertOportunidad->'+objOpp);
                TransforDatos_cls.OpportunityLineItemMessage objOpportunityLineItemMessage  = crearProducto(objCotizacion.Producto_Comercial__c,objOpp);
                system.debug('@@-objOLi->'+objOpportunityLineItemMessage.objOportunidadLineItem);               
				            	
                if(objOpportunityLineItemMessage.respuesta_y.codigoRespuesta.equals('000')){
                    insert objOpportunityLineItemMessage.objOportunidadLineItem;
                }else{                                  
                    objOpportunityMessage.respuesta_y.codigoRespuesta   = objOpportunityLineItemMessage.respuesta_y.codigoRespuesta;
                    objOpportunityMessage.respuesta_y.MensajeRespuesta  =objOpportunityLineItemMessage.respuesta_y.MensajeRespuesta;
                    objOpportunityMessage.objOportunidad =null;                 
                    
                }
                system.debug('@@-objOportunidad->'+objOpp);
                return objOpportunityMessage;
            }
            catch(Exception e){
                objOpportunityMessage.objOportunidad    = objOpp;
                objOpportunityMessage.respuesta_y.codigoRespuesta   = '000';
                objOpportunityMessage.respuesta_y.MensajeRespuesta  = 'Error en la creación de la oportundiad:'+e.getMessage();                 
                return objOpportunityMessage;
            }
     }
    
    
 

    /* BUscar id en tabla de parametros*/
    public String BuscarIdParametros( String parCampo, String parCodigo){
        Parametros__c objParametros;
        String IdObjeto=null;
        list<Parametros__c> lstParametros;
        lstParametros = [SELECT Id,Name FROM Parametros__c where Campo__c=:parCampo and Codigo__c=:parCodigo];
        if (lstParametros.size()>0){
            IdObjeto=lstParametros.get(0).id;
        }
        return IdObjeto;
    }

    /* Obtener  Cuenta*/
    public Account obtenerObjCuenta( String tipoIdentificacion, String numeroIdentificacion, Integer IDPersona,Boolean esBeneficiario){

        list<Account> lstCuentas;

        if(esBeneficiario){ // Si es Beneficiario
            lstCuentas = [SELECT Id  FROM Account   WHERE IDPersona__c  = :IDPersona];
        }else{ // Si no es beneficiario
            lstCuentas = [SELECT Id  FROM Account   WHERE NumeroDocumento__c    = :numeroIdentificacion  AND TipoDocumento__c       = :tipoIdentificacion];
        }

        if (lstCuentas.size()>0){
            return lstCuentas.get(0);
        } 
        return null;
    }

    /* Obtener Oportunidad*/
    public Opportunity obtenerOportunidad( String parNumeroOportundiad){
        List<Opportunity> lstOportunidades      = [SELECT Id, AccountId, BeneficiarioAsegurado__c FROM Opportunity  WHERE Name  = :parNumeroOportundiad];
        if (lstOportunidades.size()>0){
            return lstOportunidades.get(0);
        }
        return null;
    }


     /* Crear producto de Oportunidad */
     public  TransforDatos_cls.OpportunityLineItemMessage  crearProducto( String codProducto, Opportunity objOpp){
        TransforDatos_cls.OpportunityLineItemMessage objOpportunityLineItemMessage = new TransforDatos_cls.OpportunityLineItemMessage();
        objOpportunityLineItemMessage.respuesta_y = new TransforDatos_cls.ObjectResponse();
        
        objOpportunityLineItemMessage.respuesta_y.codigoRespuesta       =   '000';
        objOpportunityLineItemMessage.respuesta_y.MensajeRespuesta      =   'Proceso Exitoso';

       
            system.debug('codProducto-crearProducto->'+codProducto);
            system.debug('objOpp-crearProducto->'+objOpp);
            OpportunityLineItem objOLI          = new   OpportunityLineItem ();
            PricebookEntry      objPBE          = new PricebookEntry();
            //objOLI.ProductCode=productoComerncial;
            objOLI.OpportunityId                = objOpp.Id;
            Product2 objProd = getIdProducto(codProducto);
            system.debug('objProd-crearProducto->'+objProd);
            if(objProd!=null){
                objPBE = getIdEntradaListaPrecio(objProd.Id);
                system.debug('objPBE-crearProducto->'+objPBE);
                IF(objPBE!= NULL){
                    objOLI.PricebookEntryId=objPBE.Id;
                    objOLI.Quantity=1;
                    objOLI.TotalPrice=0;
                }else{
                    objOpportunityLineItemMessage.respuesta_y.codigoRespuesta       =   '018';
                    objOpportunityLineItemMessage.respuesta_y.MensajeRespuesta      =   'Lista de Precio no Existe';
                }
            }else{
                    objOpportunityLineItemMessage.respuesta_y.codigoRespuesta       =   '019';
                    objOpportunityLineItemMessage.respuesta_y.MensajeRespuesta      =   'Producto no Existe';
            }
            system.debug('objOLI-->'+objOLI);
            objOpportunityLineItemMessage.objOportunidadLineItem=objOLI;
            return objOpportunityLineItemMessage;
     }


     /* Obtener el Id de un producto */
     public static  Product2 getIdProducto( String codProducto){
        Product2 objProd;
        list<Product2> listProd = [SELECT CodigoRamo__c,Compania__c,Description,EsProductoComercial__c,Id,IdentificadorProducto__c,
                                    Name,Plan__c,ProductCode,Ramo__c,TipoPlan__c,TipoProducto__c
                                    FROM Product2
                                    where ProductCode=:codProducto];


        if(listProd.size()>0) {
            objProd = listProd.get(0);
        }else{
            objProd=null;
        }
        return objProd;
     }


     /* Obtener el Id de la entrada de lista de precio asociada al producto*/
     public static  PricebookEntry getIdEntradaListaPrecio( String idProducto){
        PricebookEntry objELP;
        list<PricebookEntry> listELP = [SELECT Id,Name,ProductCode
                                        FROM PricebookEntry
                                        Where Product2Id=:idProducto
                                        and Pricebook2Id=:Label.Gbc_IdListaPrecioEstandar];

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
        list<Opportunity> listOpp = [SELECT Id,Name FROM Opportunity where Name=:numeroOportundidad];

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

      /* Buscar id del usuario*/
     public  String getIdUsuario(String strUsuario){

        User objUser;
        list<User> listUsuarios = [SELECT Id FROM User where Username=:strUsuario];

        if(listUsuarios.size()>0) {
            objUser = listUsuarios.get(0);
            return objUser.Id;
        }else{
             return null;
        }
     }
     


      /* Buscar id de Ciudad*/
     public static String getIdCiudad(String codCiudad){

        Ciudades__c obCiudad;
        list<Ciudades__c> listCiudades = [SELECT Id FROM Ciudades__c where Codigo__c=:codCiudad];

        if(listCiudades.size()>0) {
            obCiudad = listCiudades.get(0);
            return obCiudad.Id;
        }else{
             return null;
        }
     }
    // ------------------------------------------

     /* Obtener la descripcion de un tipo de documento*/
     public static String getDescripcionTipoDocumento(Integer tipoDocumento){
        String strTipoDocumento = String.ValueOf(tipoDocumento);
        String descripcionDocumento=null;
        Parametros__c  objParam;
        list<Parametros__c> listParam = [SELECT Codigo__c,Name FROM Parametros__c WHERE Objeto__c = 'Account' and Campo__c= 'TipoDocumento__c' and Codigo__c =:strTipoDocumento];
        if(listParam.size()>0) {
                return listParam.get(0).Name;
        }else{
            return null;
        }
     }   
}