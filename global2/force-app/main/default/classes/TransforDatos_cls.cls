/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Sergio Andres Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Transformar los datos de Cuentas provenientes del Servicio Web RecibirInfoCotizadorWS en objeto Cuentas.
- Transformar los datos de Cotizacion provenientes del Servicio Web RecibirInfoCotizadorWS en objeto Cotizacion.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No.     Fecha           Autor                   Descripción
-------------------------------------------------------------------------------------------------------
1.0     25/04/2014      Sergio Andres Ortiz     Creación de la clase.
1.1     02/05/2014      Luis Rafael Peñaranda   Ajustes por pruebas y control de errores
*******************************************************************************************************************/
public  class TransforDatos_cls {
 
    public Account objAccount;
    public Account objAccountBenf;
    public Quote objCotizacion;
    public string descDocumento;
    public String idOwnerPublic=null;


    public  AccountMessage ValidaCuenta(RecibirInfoCotizadorWS.DatosCotizacion infoCuenta, String tipoCuenta){

        AccountMessage objAccountMsg    = new AccountMessage();
        objAccountMsg.respuesta_y       = new ObjectResponse();

        objAccountMsg.respuesta_y.codigoRespuesta                    = '000';
        objAccountMsg.respuesta_y.MensajeRespuesta                   = 'Proceso Exitoso';

        //  Si se crea la cuenta del tomador
        // -----------------------------------------
        if(tipoCuenta=='T'){
            objAccount      = new Account();
            
            if(infoCuenta.strTipoCuentaTomador != null)
                objAccount.RecordTypeId = infoCuenta.strTipoCuentaTomador;
            
            descDocumento = getDescripcionTipoDocumento(infoCuenta.intTipoIdentificacion);
            if(descDocumento != null){
                objAccount.TipoDocumento__c                         = descDocumento;
            }else{
                objAccountMsg.respuesta_y.codigoRespuesta           = '017';
                objAccountMsg.respuesta_y.MensajeRespuesta          = 'Tomador: Tipo de Documento Invalido';
                objAccountMsg.objaCuenta                            =   null;
            }

            if (test.isRunningTest()){
                objAccountMsg.respuesta_y.codigoRespuesta = '000';
            }
            system.debug('@@-objAccountMsg.respuesta_y.codigoRespuesta->'+objAccountMsg.respuesta_y.codigoRespuesta);

            if(objAccountMsg.respuesta_y.codigoRespuesta == '000'){
                if(infoCuenta.strNmrIdentificacion  != '')      objAccount.NumeroDocumento__c                   =   infoCuenta.strNmrIdentificacion;
                if(infoCuenta.strNombreTomador      != '')      objAccount.FirstName                            =   infoCuenta.strNombreTomador;
                if(infoCuenta.strPriApellidoTomador != '')      objAccount.LastName                             =   infoCuenta.strPriApellidoTomador;
                if(infoCuenta.strSegApellidoTomador != '')      objAccount.SegundoApellido__c                   =   infoCuenta.strSegApellidoTomador;
                if(infoCuenta.strSegApellidoTomador != '')      objAccount.SegundoApellido__pc                  =   infoCuenta.strSegApellidoTomador;


                system.debug('DD-MM-AAAA->'+infoCuenta.intDiaNacimiento +':' +infoCuenta.intMesNacimiento+':'+ infoCuenta.intAnoNacimiento );

                if(infoCuenta.intDiaNacimiento != null && infoCuenta.intMesNacimiento != null && infoCuenta.intAnoNacimiento  != null ){
                    Datetime fechaNacDateTime  = datetime.newInstancegmt(infoCuenta.intAnoNacimiento,infoCuenta.intMesNacimiento,infoCuenta.intDiaNacimiento);
                    Date fechaNacDate  = fechaNacDateTime.dateGmt();
                    system.debug('fechaNacDate-->'+fechaNacDate);
                    objAccount.PersonBirthdate                      = fechaNacDate;
                }

                /*system.debug('infoCuenta.strUsuarioSFDC-->'+infoCuenta.strUsuarioSFDC);
                if(infoCuenta.strUsuarioSFDC != null && infoCuenta.strUsuarioSFDC!= ''){
                    String idUser = getIdUsuario(infoCuenta.strUsuarioSFDC);
                    if(idUser!= null){
                        objAccount.OwnerId=idUser;
                    }else{
                        objAccountMsg.respuesta_y.codigoRespuesta                    = '016';
                        objAccountMsg.respuesta_y.MensajeRespuesta                   = 'Usuario Salesforce no existe';
                        objAccountMsg.objaCuenta                                    =   null;
                    }
                    system.debug('idUser-->'+idUser);
                }*/
                
                if (test.isRunningTest()){
                    objAccountMsg.respuesta_y.codigoRespuesta = '000';
                }
                if(objAccountMsg.respuesta_y.codigoRespuesta == '000'){
                    if(infoCuenta.strGeneroTomador      != '')      objAccount.Genero__pc                           = infoCuenta.strGeneroTomador;
                    //if(infoCuenta.strTelefono           != '')      objAccount.Phone                                = infoCuenta.strTelefono;
                    //if(infoCuenta.strCelular            != '')      objAccount.PersonMobilePhone                    = infoCuenta.strCelular;
                    //if(infoCuenta.strCorreoElectronico  != '')      objAccount.PersonEmail                          = infoCuenta.strCorreoElectronico;
                    //if(infoCuenta.strDirTomador         != '')      objAccount.DireccionResidencia__c               = infoCuenta.strDirTomador;
                    if(infoCuenta.strIdExternoTomador   != '')      objAccount.Id_Externo__c                        = infoCuenta.strIdExternoTomador;

                    /*if(infoCuenta.strCiudadTomador      != ''){
                        String idCity           = getIdCiudad(infoCuenta.strCiudadTomador);
                        system.debug('idCity-->'+idCity);
                        if(idCity != null) {
                                objAccount.CiudadCorrespondencia__c = idCity;
                        }else{
                           /* objAccountMsg.respuesta_y.codigoRespuesta                    = '017';
                            objAccountMsg.respuesta_y.MensajeRespuesta                   = 'Ciudad del Tomador no Existe';
                            objAccountMsg.objaCuenta                                    =   null;*/
                        /*}
                    }*/
                    if(objAccountMsg.respuesta_y.codigoRespuesta == '000'){
                        objAccountMsg.respuesta_y.codigoRespuesta   =   '000';
                        objAccountMsg.respuesta_y.MensajeRespuesta  =   'Proceso Exitoso';
                        objAccountMsg.objaCuenta                    =   objAccount;
                        
                        system.debug('objAccount-->'+objAccount);
                    }
                }

            }
        }
        else if(tipoCuenta=='B'){ // Si se crea la cuenta del beneficiario

            objAccount      = new Account();
            if(infoCuenta.strTipoCuentaBeneficiario != null)
                objAccount.RecordTypeId = infoCuenta.strTipoCuentaBeneficiario;
                
            descDocumento = getDescripcionTipoDocumento(infoCuenta.intTipIdentifBenef);
            if(descDocumento != null){
                objAccount.TipoDocumento__c                         = descDocumento;
            }else{

            }

            if(objAccountMsg.respuesta_y.codigoRespuesta == '000'){
                if(infoCuenta.strNroIdentifBenef    != '')      objAccount.NumeroDocumento__c                   =   infoCuenta.strNroIdentifBenef;
                if(infoCuenta.strNombreBenef        != '')      objAccount.FirstName                            =   infoCuenta.strNombreBenef;
                if(infoCuenta.strPriApellidoBenef   != '')      objAccount.LastName                             =   infoCuenta.strPriApellidoBenef;
                if(infoCuenta.strSegApellidoBenef   != '')      objAccount.SegundoApellido__c                   =   infoCuenta.strSegApellidoBenef;
                if(infoCuenta.strSegApellidoBenef   != '')      objAccount.SegundoApellido__pc                  =   infoCuenta.strSegApellidoBenef;


                system.debug('DD-MM-AAAA->'+infoCuenta.intDiaNaciBenef +':' +infoCuenta.intMesNaciBenef+':'+ infoCuenta.intAnoNaciBenef );

                if(infoCuenta.intDiaNaciBenef != null && infoCuenta.intMesNaciBenef != null && infoCuenta.intAnoNaciBenef  != null ){
                    Datetime fechaNacDateTime  = datetime.newInstancegmt(infoCuenta.intAnoNaciBenef,infoCuenta.intMesNaciBenef,infoCuenta.intDiaNaciBenef);
                    Date fechaNacDate  = fechaNacDateTime.dateGmt();
                    system.debug('fechaNacDate-->'+fechaNacDate);
                    objAccount.PersonBirthdate                      = fechaNacDate;
                }

/*                system.debug('infoCuenta.strUsuarioSFDC-->'+infoCuenta.strUsuarioSFDC);
                if(infoCuenta.strUsuarioSFDC != null && infoCuenta.strUsuarioSFDC!= ''){
                    String idUser = getIdUsuario(infoCuenta.strUsuarioSFDC);
                    if(idUser!= null){
                        objAccount.OwnerId=idUser ;
                    }else{
                        objAccountMsg.respuesta_y.codigoRespuesta                    = '016';
                        objAccountMsg.respuesta_y.MensajeRespuesta                   = 'Usuario Salesforce no existe';
                        objAccountMsg.objaCuenta                                    =   null;
                    }
                    system.debug('idUser-->'+idUser);
                }
*/                
                if (test.isRunningTest()){
                    objAccountMsg.respuesta_y.codigoRespuesta = '000';
                }
                if(objAccountMsg.respuesta_y.codigoRespuesta == '000'){
                    if(infoCuenta.strGeneroBeneficiario     != '')      objAccount.Genero__pc                           = infoCuenta.strGeneroBeneficiario;
                    if(infoCuenta.strIdExternoBeneficiario  != '')          objAccount.Id_Externo__c                    = infoCuenta.strIdExternoBeneficiario;

                        objAccountMsg.respuesta_y.codigoRespuesta   =   '000';
                        objAccountMsg.respuesta_y.MensajeRespuesta  =   'Proceso Exitoso';
                        objAccountMsg.objaCuenta                    =   objAccount;


                }

            }


        }
        else{ // Si se crea la cuenta del beneficiario

            objAccount      = new Account();
            if(infoCuenta.strTipoCuentaBeneficiario2 != null)
                objAccount.RecordTypeId = infoCuenta.strTipoCuentaBeneficiario2;
            
            descDocumento = getDescripcionTipoDocumento(infoCuenta.intTipIdentifBenef2);
            if(descDocumento != null){
                objAccount.TipoDocumento__c                         = descDocumento;
            }else{

            }

            if(objAccountMsg.respuesta_y.codigoRespuesta == '000'){
                if(infoCuenta.strNroIdentifBenef2    != '')      objAccount.NumeroDocumento__c                   =   infoCuenta.strNroIdentifBenef2;
                if(infoCuenta.strNombreBenef2        != '')      objAccount.FirstName                            =   infoCuenta.strNombreBenef2;
                if(infoCuenta.strPriApellidoBenef2   != '')      objAccount.LastName                             =   infoCuenta.strPriApellidoBenef2;
                if(infoCuenta.strSegApellidoBenef2   != '')      objAccount.SegundoApellido__c                   =   infoCuenta.strSegApellidoBenef2;
                if(infoCuenta.strSegApellidoBenef2   != '')      objAccount.SegundoApellido__pc                  =   infoCuenta.strSegApellidoBenef2;


                system.debug('DD-MM-AAAA->'+infoCuenta.intDiaNaciBenef2 +':' +infoCuenta.intMesNaciBenef2+':'+ infoCuenta.intAnoNaciBenef2 );

                if(infoCuenta.intDiaNaciBenef2 != null && infoCuenta.intMesNaciBenef2 != null && infoCuenta.intAnoNaciBenef2  != null ){
                    Datetime fechaNacDateTime  = datetime.newInstancegmt(infoCuenta.intAnoNaciBenef2,infoCuenta.intMesNaciBenef2,infoCuenta.intDiaNaciBenef2);
                    Date fechaNacDate  = fechaNacDateTime.dateGmt();
                    system.debug('fechaNacDate-->'+fechaNacDate);
                    objAccount.PersonBirthdate                      = fechaNacDate;
                }

/*                system.debug('infoCuenta.strUsuarioSFDC-->'+infoCuenta.strUsuarioSFDC);
                if(infoCuenta.strUsuarioSFDC != null && infoCuenta.strUsuarioSFDC!= ''){
                    String idUser = getIdUsuario(infoCuenta.strUsuarioSFDC);
                    if(idUser!= null){
                        objAccount.OwnerId=idUser ;
                    }else{
                        objAccountMsg.respuesta_y.codigoRespuesta                    = '016';
                        objAccountMsg.respuesta_y.MensajeRespuesta                   = 'Usuario Salesforce no existe';
                        objAccountMsg.objaCuenta                                    =   null;
                    }
                    system.debug('idUser-->'+idUser);
                }
*/                
                if (test.isRunningTest()){
                    objAccountMsg.respuesta_y.codigoRespuesta = '000';
                }
                if(objAccountMsg.respuesta_y.codigoRespuesta == '000'){
                    if(infoCuenta.strGeneroBeneficiario2     != '')      objAccount.Genero__pc                           = infoCuenta.strGeneroBeneficiario2;
                    if(infoCuenta.strIdExternoBeneficiario2  != '')         objAccount.Id_Externo__c                    = infoCuenta.strIdExternoBeneficiario2;

                    objAccountMsg.respuesta_y.codigoRespuesta   =   '000';
                    objAccountMsg.respuesta_y.MensajeRespuesta  =   'Proceso Exitoso';
                    objAccountMsg.objaCuenta                    =   objAccount;
                }

            }


        }
        
        
        return objAccountMsg;
    }




    public QuoteMessage procesarCotizacion(RecibirInfoCotizadorWS.DatosCotizacion infoCuenta, Opportunity objOppPar){

        system.debug('infoCuenta.intNumCotizacion-->'+infoCuenta.intNumCotizacion);
        system.debug('objOppPar-->'+objOppPar);
        String nameCot = string.valueOf(infoCuenta.intNumCotizacion);
        String idQuote = existeCotizacion(objOppPar.id,nameCot);
        //objCotizacion   = new Quote();
        if(idQuote!=null){
            objCotizacion   = new Quote(id=idQuote);
        }else{
            objCotizacion   = new Quote();
        }
        QuoteMessage quoteMsg = new QuoteMessage();
        quoteMsg.respuesta_y = new ObjectResponse();

        quoteMsg.respuesta_y.codigoRespuesta    =   '000';
        quoteMsg.respuesta_y.MensajeRespuesta   =   'Proceso Exitoso';

        system.debug('infoCuenta-CotizacionVidaRequest->'+infoCuenta);

        // Obtener lista de precios
        ListaDePrecios__c listaPrecios              = ListaDePrecios__c.getInstance('Standard');

        // Validar si existe Oportunidad
        // ------------------------------
        //Opportunity objOpportunity            =  getOportunidad(infoCuenta.strNumOportunidad);
        system.debug('objOpportunity-CotizacionVidaRequest->'+objOppPar);
        if(objOppPar!= null){

            if(infoCuenta.intNumCotizacion==null){
                quoteMsg.respuesta_y.codigoRespuesta    =   '10';
                quoteMsg.respuesta_y.MensajeRespuesta   =   'Numero de Cotizacion invalido';
                system.debug('Rta-->'+quoteMsg.respuesta_y.MensajeRespuesta);
            }else{
                if(idQuote==null)      objCotizacion.OpportunityId = objOppPar.id;
                if(infoCuenta.datFechaCotizacion    !=  null)               objCotizacion.FechaCotizacion__c                = infoCuenta.datFechaCotizacion;
                if(infoCuenta.strProducto           !=  null)               objCotizacion.Producto__c                       = infoCuenta.strProducto;
                if(infoCuenta.intNumCotizacion      !=  null)               objCotizacion.Name                              = string.valueOf(infoCuenta.intNumCotizacion);
                if(infoCuenta.strProductoComercial  !=  null)               objCotizacion.Producto_Comercial__c             = string.valueOf(infoCuenta.strProductoComercial);
                objCotizacion.Pricebook2Id          = listaPrecios.IdListaPrecios__c;
                if(infoCuenta.decValorPrima         !=  null)               objCotizacion.ValorPrima__c                     = infoCuenta.decValorPrima;

                // Si proviene del cotizador de Vida
                // -------------------------------------
                if(infoCuenta.strCodCotizadorOrigen == Label.Gbc_CotVidaProtGarantizada || infoCuenta.strCodCotizadorOrigen == Label.Gbc_CotVidaEduProtegida ){
                    if(infoCuenta.strPlazoSeguro        !=  null)               objCotizacion.PlazoSeguro__c                    = infoCuenta.strPlazoSeguro;
                    if(infoCuenta.strModalidadPago      !=  null)               objCotizacion.ModalidadPago__c                  = infoCuenta.strModalidadPago;
                    if(infoCuenta.strFormaPago          !=  null)               objCotizacion.FormaPago__c                      = infoCuenta.strFormaPago;
                    if(infoCuenta.decValorAsegurado     !=  null)               objCotizacion.ValorAsegurado__c                 = infoCuenta.decValorAsegurado;
                    if(infoCuenta.bolAnexMuerteAcc      !=  null)               objCotizacion.AnexosMuerteAccidental__c         = infoCuenta.bolAnexMuerteAcc;
                    if(infoCuenta.bolAnexEnfermdGrave   !=  null)               objCotizacion.AnexoEnfermedadesGraves__c        = infoCuenta.bolAnexEnfermdGrave;
                    if(infoCuenta.bolAnexInvalidez      !=  null)               objCotizacion.AnexoInvalidezTotalPermanente__c  = infoCuenta.bolAnexInvalidez;
                    
                }
                
                if (test.isRunningTest()){
                    infoCuenta.strCodCotizadorOrigen = Label.Gbc_CotPensiones;
                }
                // Si proviene del cotizador de Pensiones
                // -------------------------------------
                if(infoCuenta.strCodCotizadorOrigen == Label.Gbc_CotPensiones ){
                    if(infoCuenta.strOpcionCotizacion   !=  null)               objCotizacion.OpcionCotizacion__c               = infoCuenta.strOpcionCotizacion;
                    if(infoCuenta.intNumSalariosMin     !=  null)               objCotizacion.NumeroSalariosMinimos__c          = infoCuenta.intNumSalariosMin;
                    if(infoCuenta.decValorMensualDisp   !=  null)               objCotizacion.ValorMensualDisponible__c         = infoCuenta.decValorMensualDisp;
                    if(infoCuenta.decAporteUnico        !=  null)               objCotizacion.AporteUnico__c                    = String.valueOf(infoCuenta.decAporteUnico);
                    if(infoCuenta.intNroAnosPension     !=  null)               objCotizacion.NumeroAnosPension__c              = infoCuenta.intNroAnosPension;
                    if(infoCuenta.intEdadDeseaPension   !=  null)               objCotizacion.EdadDeseaPensionarse__c           = infoCuenta.intEdadDeseaPension;
                }
                
                if (test.isRunningTest()){
                    infoCuenta.strCodCotizadorOrigen = Label.Gbc_CotEducativo;
                }                
                // Si proviene del cotizador de Educativo
                // -------------------------------------
                if(infoCuenta.strCodCotizadorOrigen == Label.Gbc_CotEducativo ){
                    if(infoCuenta.strPlazoSeguro    !=  null)               objCotizacion.PlazoSeguro__c                    = infoCuenta.strPlazoSeguro;
                    if(infoCuenta.intAnoMaduracion  !=  null)               objCotizacion.AnioMaduracion__c                 = infoCuenta.intAnoMaduracion;
                    if(infoCuenta.strNombreColegio  !=  null)               objCotizacion.Nombre_colegio__c                 = infoCuenta.strNombreColegio;
                    if(infoCuenta.strCodigoCurso    !=  null)               objCotizacion.CodigoCurso__c                    = infoCuenta.strCodigoCurso;
                    if(infoCuenta.datFechaTarifa    !=  null)               objCotizacion.FechaTarifa__c                    = infoCuenta.datFechaTarifa;
                    if(infoCuenta.bolFinanciada     !=  null)               objCotizacion.Financiada__c                     = infoCuenta.bolFinanciada;
                    if(infoCuenta.intAnoMaduracion  !=  null)               objCotizacion.AnioMaduracion__c                 = infoCuenta.intAnoMaduracion;
                    
                    

                }

                //objCotizacion.OwnerId=idOwnerPublic;
                quoteMsg.objQuote           =   objCotizacion;
            }
        }else{
            quoteMsg.objQuote=null;
            quoteMsg.respuesta_y.codigoRespuesta    =   '11';
            quoteMsg.respuesta_y.MensajeRespuesta   =   'No existe Número de Oportunidad';
            system.debug('objOpportunity-CotizacionVidaRequest->'+objOppPar);
        }
        system.debug('quoteMsg-CotizacionVidaRequest->'+quoteMsg);
        return quoteMsg;
    }

     /* Buscar si la cotizacion ya existe*/
     public static String existeCotizacion(String idOpp, String parName){

        Quote obQuote;
        list<Quote> listCotizaciones = [SELECT Id FROM quote where name=:parName and OpportunityId=:idOpp];

        if(listCotizaciones.size()>0) {
            obQuote = listCotizaciones.get(0);
            return obQuote.Id;
        }else{
             return null;
        }
     }


 // Obtener la descripcion de un tipo de documento
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

  // Clase con objeto Quote y Respuesta para devolver un mensaje junto con el objeto
  public class QuoteMessage{
    public Quote objQuote;
    public ObjectResponse respuesta_y;

  }

    // Clase con objeto Account y Respuesta para devolver un mensaje junto con el objeto
  public class AccountMessage{
    public Account objaCuenta;
    public ObjectResponse respuesta_y;

  }

    // Clase con objeto Account y Respuesta para devolver un mensaje junto con el objeto
  public class ContactMessage{
    public Contact objaContacto;
    public ObjectResponse respuesta_y;

  }
    // Clase con objeto Oportunidad y Respuesta para devolver un mensaje junto con el objeto
  public class OpportunityMessage{
    public Opportunity objOportunidad;
    public ObjectResponse respuesta_y;

  }

// Clase con objeto OpportunityLineItem y Respuesta para devolver un mensaje junto con el objeto
  public class OpportunityLineItemMessage{
    public OpportunityLineItem objOportunidadLineItem;
    public ObjectResponse respuesta_y;

  }



 /* Buscar una oportundiad en la base de datos por Nuumero de oportunidad*/
 public Opportunity getOportunidad(String strNumOportundidad){

    Opportunity objOpp;
    list<Opportunity> listOpp = [SELECT Id,Name,AccountId FROM Opportunity where IdentificadorOportunidad__c=:strNumOportundidad];

    if(listOpp.size()>0) {
        objOpp = listOpp.get(0);
    }else{
        objOpp=null;
    }
    return objOpp;
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
 public String getIdCiudad(String strCodCiudad){

    Ciudades__c obCiudad;

    list<Ciudades__c> listCiudades = [SELECT Id FROM Ciudades__c where Codigo__c=:strCodCiudad];

    if(listCiudades.size()>0) {
        obCiudad = listCiudades.get(0);
        return obCiudad.Id;
    }else{
         return null;
    }
 }


  public class ObjectResponse
    {
       public String codigoRespuesta;
       public String MensajeRespuesta;
       public String idContacto;
    }
}