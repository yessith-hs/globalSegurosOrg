/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Sergio Andres Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Crear los objetos para las clases de prueba

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha Autor Descripción
-------------------------------------------------------------------------------------------------------
1.0 14/04/2014 Sergio Andres Ortiz 	Creación de la clase.
2.0 08/02/2017 Katherine Moreno    	Modificacion
3.0 09/09/2021 Christian Tovar		Modificación para crear campañas hijas
*******************************************************************************************************************/
@isTest
public with sharing class CreaData_tst {

    //Creacion del objeto Asunto
    public static Asuntos__c metAsunto(String IdUsuario){
        Asuntos__c objAsunto = new Asuntos__c();
        objAsunto.NHorasVerde__c        = 1;
        objAsunto.NHorasAmarillo__c     = 2;
        objAsunto.NHorasRojo__c         = 3;
        objAsunto.NHorasMorado__c       = 4;
        objAsunto.ResponsableAmarillo__c = IdUsuario;
        objAsunto.ResponsableRojo__c    = IdUsuario;
        objAsunto.ResponsableMorado__c  = IdUsuario;

        insert objAsunto;
        return objAsunto;
    }

    //Creacion del Objeto Caso
    public static Case metCaso(String IdObjAsunto) {
        Case objCaso = new Case();
        objCaso.estadoSemaforo__c       = 'Verde';
        objCaso.FechaHoraRecibido__c    = datetime.newInstanceGmt(2014, 04, 15, 15, 00, 0);
        //objCaso.Asunto__c               = IdObjAsunto;

        insert objCaso;
        return objCaso;
    }

    //Creacion del Objeto Caso
    public static Case metCaso2(String IdObjAsunto) {
        Case objCaso                    = new Case();
        objCaso.estadoSemaforo__c       = 'Verde';
        objCaso.FechaHoraRecibido__c    = datetime.now();
        objCaso.Asuntos__c               = IdObjAsunto;

        insert objCaso;
        return objCaso;
    }

    //Creacion del Objeto Tarea
    public static Task metTarea(){
        Task objTarea                   = new Task();
        //objTarea.CreatedDate = datetime.newInstanceGmt(2014, 04, 16, 12, 10, 0);
        objTarea.estadoSemaforo__c      = 'Verde';
        objTarea.Status = 'Open';
        objTarea.Priority = 'Normal';

        insert objTarea;
        return objTarea;
    }

    //Creacion del Objeto Usuario
    public static User metUser() {
        User objUser                    = new User();
        objUser.Email                   = 'sortiz@avanxo.com';
        objUser.FirstName               = 'Sergio';
        objUser.LastName                = 'Ortiz';
        objUser.Alias                   = 'ctecnico';
        //objUser.Name  = 'Consultor Técnico1';
        objUser.Username                = 'consultor.tecnico1@global.com';
        objUser.CommunityNickname       = 'PartnersGlobal';
        objUser.EmailEncodingKey        = 'ISO-8859-1';
        objUser.LanguageLocaleKey       = 'Es';
        objUser.LocaleSidKey            = 'es_CO';
        objUser.ProfileId               =  Userinfo.getProfileId();
        objUser.TimeZoneSidKey          = 'America/Bogota';

        insert objUser;
        return objUser;
    }

    //Creacion del Objeto Campaña
    public static Campaign metCampana(){
    	Ciudades__c objCiudad			= new Ciudades__c(); 
    	objCiudad.Name					= 'ciudad1';
    	objCiudad.esmunicipio__c		= true;
    	objCiudad.espais__c				= false;
    	objCiudad.EsRegion__c			= false;
    	objCiudad.EsDepartamento__c		= false;
    	objCiudad.Codigo__c				= '1_0545';
    	insert objCiudad;
    	
        Campaign objCampana             = new Campaign();
        objCampana.Description          = 'mensaje de descripcionq.';
        objCampana.CodigoCampana__c     = '0012';
        objCampana.Ciudad__c            = objCiudad.id;
        objCampana.RecordTypeId         = [SELECT Id FROM RecordType WHERE Name = 'Alianza' limit 1].id;
        objCampana.Name                 = 'Campana Name1';
        objCampana.isActive             = true;
		objCampana.NIT__c				= '1234567891';
		
        insert objCampana;
        return objCampana;
    }

    //Creacion del Objeto Campaña
    public static Campaign metCampana2(){
    	
    	Campaign objCampana             = new Campaign();
        objCampana.Description          = 'mensaje de descripcion2.';
        objCampana.CodigoCampana__c     = '0015';
        objCampana.Ciudad__c            = [SELECT Id FROM Ciudades__c WHERE Name = 'ciudad1' limit 1].id;
        objCampana.RecordTypeId         = [SELECT Id FROM RecordType WHERE Name = 'Evento' limit 1].id;
        objCampana.ParentId				= [SELECT Id FROM Campaign WHERE Name = 'Campana Name1' limit 1].id;
        objCampana.Name                 = 'Campana Name2';
        objCampana.isActive             = false;
		objCampana.NIT__c				= '1234567891';
		
        insert objCampana;
        return objCampana;
    }

    //Creacion del Objeto Campaña
    public static Campaign metCampana3(){
    	
        Campaign objCampana             = new Campaign();
        objCampana.Description          = 'mensaje de descripcion3.';
        objCampana.CodigoCampana__c     = '0016';
        objCampana.Ciudad__c            = [SELECT Id FROM Ciudades__c WHERE Name = 'ciudad1' limit 1].id;
        objCampana.RecordTypeId         = [SELECT Id FROM RecordType WHERE Name = 'Evento' limit 1].id;
        objCampana.ParentId				= [SELECT Id FROM Campaign WHERE Name = 'Campana Name1' limit 1].id;
        objCampana.Name                 = 'Campana Name3';
        objCampana.isActive             = true;
		objCampana.NIT__c				= '1234567891';
        
        insert objCampana;
        return objCampana;
    }

    //Creacion del Objeto RecibirInfoCotizadorWS.DatosCotizacion que contiene los datos que se reciben por el WS
    public static RecibirInfoCotizadorWS.DatosCotizacion metWsRequest(){

        RecibirInfoCotizadorWS.DatosCotizacion wsRequest = new RecibirInfoCotizadorWS.DatosCotizacion();

        wsRequest.strCodCotizadorOrigen     =   Label.Gbc_CotVidaProtGarantizada;
        wsRequest.strUsuarioSFDC            =   UserInfo.getUserName();
        wsRequest.strNombreOportunidad      =   'nameOpp';
        wsRequest.strNumOportunidad         =   '0000000079';
        wsRequest.strUsuarioClave           =   'ClavUsu123';
        wsRequest.intNumCotizacion          =   12345;
        wsRequest.strIdExternoTomador       =   'CC843274279';
        wsRequest.intTipoIdentificacion     =   1;
        wsRequest.strNmrIdentificacion      =   '843274279';
        wsRequest.strNombreTomador          =   'Andres';
        wsRequest.strPriApellidoTomador     =   'Cepeda';
        wsRequest.strSegApellidoTomador     =   'Cantante';
        wsRequest.intDiaNacimiento          =   30;
        wsRequest.intMesNacimiento          =   08;
        wsRequest.intAnoNacimiento          =   1983;
        wsRequest.strGeneroTomador          =   '1';
        wsRequest.bolActividad              =   true;
        wsRequest.strTelefono               =   '3214563';
        wsRequest.strCelular                =   '3004569772';
        wsRequest.strCorreoElectronico      =   'pepe1@gmail.com';
        wsRequest.strCiudadTomador          =   '1101';
        wsRequest.strDirTomador             =   'Calle 10 No. 39-18';
        wsRequest.datFechaCotizacion        =   date.today();
        wsRequest.strProducto               =   '1_654';
        wsRequest.strProductoComercial      =   '1_654';
        wsRequest.strPlazoSeguro            =   '1';
        wsRequest.strModalidadPago          =   '1';
        wsRequest.strFormaPago              =   '1';
        wsRequest.decValorAsegurado         =   0;
        wsRequest.bolAnexMuerteAcc          =   false;
        wsRequest.bolAnexEnfermdGrave       =   false;
        wsRequest.bolAnexInvalidez          =   false;
        wsRequest.decValorPrima             =   180.00;
        wsRequest.strOpcionCotizacion       =   'strOpcionCotizacion';
        wsRequest.intNumSalariosMin         =   10;
        wsRequest.decValorMensualDisp       =   150.0;
        wsRequest.decAporteUnico            =   75.5;
        wsRequest.intNroAnosPension         =   15;
        wsRequest.intEdadDeseaPension       =   55;
        wsRequest.strIdExternoBeneficiario  =   'abxcde1232';
        wsRequest.strIdExternoBeneficiario2	=   '324refds';
        wsRequest.intTipIdentifBenef        =   5;
        wsRequest.strNroIdentifBenef        =   '123456789';
        wsRequest.strNombreBenef            =   'Nombre Benef';
        wsRequest.strGeneroBeneficiario     =   'M';
        wsRequest.strPriApellidoBenef       =   '1App Benef';
        wsRequest.strSegApellidoBenef       =   '2App Benef';
        wsRequest.intDiaNaciBenef           =   15;
        wsRequest.intMesNaciBenef           =   05;
        wsRequest.intAnoNaciBenef           =   1998;
        wsRequest.intTipIdentifBenef2        =   5;
        wsRequest.strNroIdentifBenef2        =   '123456788';
        wsRequest.strNombreBenef2           =   'Nombre Benef 2';
        wsRequest.strGeneroBeneficiario2     =   'M';
        wsRequest.strPriApellidoBenef2       =   '1App Benef 2';
        wsRequest.strSegApellidoBenef2       =   '2App Benef 2';
        wsRequest.intDiaNaciBenef2           =   15;
        wsRequest.intMesNaciBenef2           =   05;
        wsRequest.intAnoNaciBenef2           =   1998;
        wsRequest.intAnoMaduracion          =   2030;
        wsRequest.strNombreColegio          =   'Nomb Colegio';
        wsRequest.strCodigoCurso            =   'CdCurs001';
        wsRequest.datFechaTarifa            =   date.today()+10;
        wsRequest.bolFinanciada             =   false;
        wsRequest.strIdOportunidad = null;
        wsRequest.strUsuarioConLicencia = UserInfo.getUserName();
        
        wsRequest.strIntermediario = 'CC843274279';
        wsRequest.intNumeroSemestres = 1;
        wsRequest.datFechaCierre = system.today();
        wsRequest.strEvento = null;
        wsRequest.strCorreoElectronico			= 'aaaaa@aaaaa.com';
        
        wsRequest.strUsuarioSinLicencia = 'CC843274279';
        wsRequest.strNombreColegio = '23';
        wsRequest.strCodigoDivisa = 'COP';

        return wsRequest;
    }


    //Creacion del Objeto Cuenta Tomador
    public static Account metCuentaTomador(){
    	
    	Integer random = Math.Round(Math.Random() * 7897984);
        Account objAccount                  = new Account();
        RecibirInfoCotizadorWS.DatosCotizacion wsRequest    = CreaData_tst.metWsRequest();
        objAccount.TipoDocumento__c         = CRUDGlobal_cls.getDescripcionTipoDocumento(wsRequest.intTipoIdentificacion);
        objAccount.NumeroDocumento__c       = wsRequest.strNmrIdentificacion;
        objAccount.FirstName                = wsRequest.strNombreTomador;
        objAccount.LastName                 = wsRequest.strPriApellidoTomador;
        objAccount.SegundoApellido__c       = wsRequest.strSegApellidoTomador;
        objAccount.SegundoApellido__pc      = wsRequest.strSegApellidoTomador;
        objAccount.PersonBirthdate       	= date.newInstance(wsRequest.intAnoNacimiento, wsRequest.intMesNacimiento, wsRequest.intDiaNacimiento);
        objAccount.Genero__pc               = wsRequest.strGeneroTomador;
        objAccount.Phone                    = wsRequest.strTelefono;
        objAccount.PersonMobilePhone        = wsRequest.strCelular;
        objAccount.PersonEmail              = wsRequest.strCorreoElectronico;
        objAccount.Ciudad__c                = CRUDGlobal_cls.getIdCiudad(wsRequest.strCiudadTomador);
        objAccount.DireccionResidencia__c   = wsRequest.strDirTomador;
        //objAccount.Id_Externo__c            = wsRequest.strIdExternoTomador;
        objAccount.Id_Externo__c            = 'CC'+random;
        objAccount.IDPersona__c             = 4.86080930;       

        insert objAccount;
        System.debug('objAccount--->'+objAccount);
        return objAccount;
    }

     //Creacion del Objeto Cuenta Beneficiario
    public static Account metCuentaBeneficiario(){
    	Integer random = Math.Round(Math.Random() * 1045391);
    	
        Account objAccount                  = new Account();
        RecibirInfoCotizadorWS.DatosCotizacion wsRequest    = CreaData_tst.metWsRequest();
        objAccount.TipoDocumento__c         = CRUDGlobal_cls.getDescripcionTipoDocumento(wsRequest.intTipIdentifBenef);
        objAccount.NumeroDocumento__c       = wsRequest.strNroIdentifBenef;
        objAccount.FirstName                = wsRequest.strNombreBenef;
        objAccount.LastName                 = wsRequest.strPriApellidoBenef;
        objAccount.SegundoApellido__c       = wsRequest.strSegApellidoBenef;
        objAccount.SegundoApellido__pc      = wsRequest.strSegApellidoBenef;
        objAccount.PersonBirthdate       	= date.newInstance(wsRequest.intAnoNaciBenef, wsRequest.intMesNaciBenef, wsRequest.intDiaNaciBenef);
		objAccount.Id_Externo__c            = 'CC'+random;
        insert objAccount;
        return objAccount;
    }
    
    //Creacion del Objeto Cuenta Beneficiario
    public static Account metCuentaBeneficiario2(){
        Account objAccount                  = new Account();
        RecibirInfoCotizadorWS.DatosCotizacion wsRequest    = CreaData_tst.metWsRequest();
        objAccount.TipoDocumento__c         = CRUDGlobal_cls.getDescripcionTipoDocumento(5);
        objAccount.NumeroDocumento__c       = '1111111';
        objAccount.FirstName                = 'Pepito';
        objAccount.LastName                 = 'Lopez';
        objAccount.SegundoApellido__c       = wsRequest.strSegApellidoBenef;
        objAccount.SegundoApellido__pc      = wsRequest.strSegApellidoBenef;
        objAccount.PersonBirthdate       	= date.newInstance(wsRequest.intAnoNaciBenef, wsRequest.intMesNaciBenef, wsRequest.intDiaNaciBenef);

        insert objAccount;
        return objAccount;
    }

    //Creacion del Objeto Oportunidad
    public static Opportunity metOportunidad(){
    	
        //configuracion personalizada EstadoOportunidad
        EstadoOportunidad__c estadoOportunidad = new EstadoOportunidad__c();
        estadoOportunidad.Name                 = 'Prospecto';
        estadoOportunidad.Estado__c            = 'Prospección';
        insert estadoOportunidad;
        
        
        Opportunity objOpp                  =  new Opportunity ();
        Account objCuenta                   =  CreaData_tst.metCuentaTomador();
        Account objCuentaBenef              =  CreaData_tst.metCuentaBeneficiario();
        RecibirInfoCotizadorWS.DatosCotizacion wsRequest    = CreaData_tst.metWsRequest();
        objOpp.Name                         =  wsRequest.strNombreOportunidad;
        objOpp.IdentificadorOportunidad__c	=  wsRequest.strNombreOportunidad;
        objOpp.StageName                    =  estadoOportunidad.Estado__c;
        objOpp.CloseDate                    =  wsRequest.datFechaCotizacion;
        objOpp.AccountId                    =  objCuenta.id;
        objOpp.IdentificadorOportunidad__c  =  wsRequest.strNumOportunidad;
        objOpp.Designado__c                 =  objCuenta.Id;
        objOpp.BeneficiarioAsegurado__c     =  objCuentaBenef.Id;
		
        insert objOpp;
        system.debug('XXXobjOpp-->'+objOpp);
        return objOpp;
    }


    //Creacion de un Contacto
    public static Contact metContacto(){
    	RecordType rt = [Select Id From RecordType Where DeveloperName = 'Asesor'][0];
        Contact objContact                  = new Contact();
        objContact.RecordTypeId = rt.Id;
        TipoRegistroPersona__c PNatual      = CreaData_tst.metPersonaNatural();
        RecibirInfoCotizadorWS.DatosCotizacion wsRequest    = CreaData_tst.metWsRequest();
        objContact.TipoDocumento__c         = CRUDGlobal_cls.getDescripcionTipoDocumento(wsRequest.intTipoIdentificacion);
        objContact.NumeroDocumento__c       = wsRequest.strNmrIdentificacion;
        objContact.FirstName                = wsRequest.strNombreTomador;
        objContact.LastName                 = wsRequest.strPriApellidoTomador;
        objContact.SegundoApellido__c       = wsRequest.strSegApellidoTomador;
        objContact.TipoPersona__c           = 'Natural';
        objContact.Phone                    = wsRequest.strTelefono;
        objContact.Ciudad__c                = CRUDGlobal_cls.getIdCiudad(wsRequest.strCiudadTomador);
        objContact.DireccionResidencia__c   = wsRequest.strDirTomador;
        objContact.IdExterno__c             = wsRequest.strIdExternoTomador;
        

        insert objContact;
        return objContact;
    }

    public static Quote metCotizacion(){
        Quote objCotizacion                     = new Quote();
        Opportunity objOportunidad              = CreaData_tst.metOportunidad();
        RecibirInfoCotizadorWS.DatosCotizacion wsRequest    = CreaData_tst.metWsRequest();
        objCotizacion.FechaCotizacion__c                = wsRequest.datFechaCotizacion;
        objCotizacion.Producto__c                       = wsRequest.strProducto;
        objCotizacion.PlazoSeguro__c                    = wsRequest.strPlazoSeguro;
        objCotizacion.ModalidadPago__c                  = wsRequest.strModalidadPago;
        objCotizacion.FormaPago__c                      = wsRequest.strFormaPago;
        objCotizacion.ValorAsegurado__c                 = wsRequest.decValorAsegurado;
        objCotizacion.AnexosMuerteAccidental__c         = wsRequest.bolAnexMuerteAcc;
        objCotizacion.AnexoEnfermedadesGraves__c        = wsRequest.bolAnexEnfermdGrave;
        objCotizacion.AnexoInvalidezTotalPermanente__c  = wsRequest.bolAnexInvalidez;
        objCotizacion.ValorPrima__c                     = wsRequest.decValorPrima;
        objCotizacion.OpcionCotizacion__c               = wsRequest.strOpcionCotizacion;
        objCotizacion.NumeroSalariosMinimos__c          = wsRequest.intNumSalariosMin;
        objCotizacion.ValorMensualDisponible__c         = wsRequest.decValorMensualDisp;
        objCotizacion.AporteUnico__c                    = String.valueof(wsRequest.decAporteUnico);
        objCotizacion.NumeroAnosPension__c              = wsRequest.intNroAnosPension;
        objCotizacion.EdadDeseaPensionarse__c           = wsRequest.intEdadDeseaPension;
        objCotizacion.AnioMaduracion__c                 = wsRequest.intAnoMaduracion;
        objCotizacion.Nombre_colegio__c                 = wsRequest.strNombreColegio;
        objCotizacion.CodigoCurso__c                    = wsRequest.strCodigoCurso;
        objCotizacion.FechaTarifa__c                    = wsRequest.datFechaTarifa;
        objCotizacion.Financiada__c                     = wsRequest.bolFinanciada;
        objCotizacion.OpportunityId                     = objOportunidad.Id;
        objCotizacion.Name                              = String.valueof(wsRequest.intNumCotizacion);

        insert objCotizacion;
        return objCotizacion;
    }


    //Creando Tipos de Registro por Tipo de Persona Juridica.
    public static TipoRegistroPersona__c metPersonaJuridica(){
        TipoRegistroPersona__c  objTPersona = new TipoRegistroPersona__c();
        objTPersona.Name                    = 'Juridica';
        objTPersona.TipoPersona__c          = 'Jurídica';
        objTPersona.TipoRegistro__c         = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Jurídica').getRecordTypeId();

        insert objTPersona;
        return objTPersona;
    }

    //Creando Tipos de Registro por Tipo de Persona Beneficiario.
    public static TipoRegistroPersona__c metPersonaBeneficiario(){
        TipoRegistroPersona__c  objTPersona = new TipoRegistroPersona__c();
        objTPersona.Name                    = 'Beneficiario';
        objTPersona.TipoPersona__c          = 'Beneficiario';
        objTPersona.TipoRegistro__c         = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Beneficiario').getRecordTypeId();

        insert objTPersona;
        return objTPersona;
    }

    //Creando Tipos de Registro por Tipo de Persona Natural.
    public static TipoRegistroPersona__c metPersonaNatural(){
        TipoRegistroPersona__c  objTPersona = new TipoRegistroPersona__c();
        objTPersona.Name                    = 'Natural';
        objTPersona.TipoPersona__c          = 'Natural';
        objTPersona.TipoRegistro__c         = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Natural').getRecordTypeId();

        insert objTPersona;
        return objTPersona;
    }


    //Creando el registro para Lista de Precios standard
    public static ListaDePrecios__c metListaPrecios(){
    	
        ListaDePrecios__c objListaPrecios   = new ListaDePrecios__c();
        objListaPrecios.Name                = 'Standard';
        objListaPrecios.IdListaPrecios__c   = '01sG0000001RmNbIAK';    

        insert objListaPrecios;
        return objListaPrecios;
    }

    //Creando un producto de prueba
    public static Product2 metProduct2(){
        Product2 objProduct2                = new Product2();
        objProduct2.Name                    = 'ProductoPrueba';
        objProduct2.ProductCode             = '112';
        objProduct2.IdentificadorProducto__c = '1_654';
        objProduct2.CodigoRamo__c           = '69';
        objProduct2.IsActive                = true;

        insert objProduct2;
        return objProduct2;
    }

    //creando el PricebookEntry
    public static PricebookEntry metPricebookEntry(String idProd){
        PricebookEntry objPriceBookEntry    = new PricebookEntry();
        objPriceBookEntry.Pricebook2Id      = Test.getStandardPricebookId();
        objPriceBookEntry.Product2Id        = idProd;
        objPriceBookEntry.UnitPrice         = 150000.00;
        objPriceBookEntry.IsActive          = true;

        insert objPriceBookEntry;
        return objPriceBookEntry;
    }
    
    //creando el OpportunityLineItem  --PricebookEntry.Product2.CodigoRamo__c 
    public static OpportunityLineItem metOpportunityLineItem(){
        Opportunity   objOportunidad        = CreaData_tst.metOportunidad();
         Product2  objProducto               = CreaData_tst.metProduct2();
        PricebookEntry objPriceBookEntry    = CreaData_tst.metPricebookEntry(objProducto.Id);
        OpportunityLineItem objOppLI        = new OpportunityLineItem();
        ListaDePrecios__c  objListPrecios   = CreaData_tst.metListaPrecios();
        objOppLI.OpportunityId              = objOportunidad.Id;
        objOppLI.UnitPrice                  = 50000;
        //objOppLI.TotalPrice               = 80000;
        objOppLI.PricebookEntryId           = objPriceBookEntry.Id;
        objOppLI.Quantity                   = 3;
        
        insert objOppLI;
        return objOppLI;
    }

    //Creando registro de respuesta
    public static CodigosRespuesta__c metCodResp(){
        CodigosRespuesta__c objRtaCod       = new CodigosRespuesta__c();
        objRtaCod.Name                      = '000';
        objRtaCod.RtaMensaje__c             = 'Proceso Exitoso';

        insert objRtaCod;
        return objRtaCod;
    }
    
    //craando Ciudad
    public static Ciudades__c metCiudad(){
    	
    	Ciudades__c objCiudad			= new Ciudades__c(); 
    	objCiudad.Name					= 'ciudad3';
    	objCiudad.esmunicipio__c		= true;
    	objCiudad.espais__c				= false;
    	objCiudad.EsRegion__c			= false;
    	objCiudad.EsDepartamento__c		= true;
    	objCiudad.Codigo__c				= '1101';
    	insert objCiudad;
    	
        Ciudades__c ciudad                  = new Ciudades__c();
        ciudad.Codigo__c                    = '7_19_1';
        ciudad.EsDepartamento__c            = false;
        ciudad.EsMunicipio__c               = true;
        ciudad.EsPais__c                    = false;
        ciudad.EsRegion__c                  = false;
        ciudad.Name                         = 'SANTA MARTA';
        ciudad.Padre__c                     = objCiudad.Id;
        
        insert ciudad;
        return ciudad;
    }
    
    public static Parametros__c metParametros(){
        Parametros__c parametros            = new Parametros__c();
        parametros.Codigo__c                = '1';
        parametros.Name                     = 'CEDULA DE CIUDADANIA';
        parametros.Objeto__c                = 'Account';
        parametros.Campo__c                 = 'TipoDocumento__c';
        
        insert parametros;
        return parametros;    
    }
}