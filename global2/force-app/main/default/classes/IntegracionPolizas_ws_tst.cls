/**
* Avanxo Colombia
* @author           KTCAMO					href:kcardenas@avanxo.com	
* Proyect:          Global Seguros
* Description:      test Class
*
* Changes (Version)
* -------------------------------------
*           No.     Fecha           Autor                   Descripción
*           -----   ----------      --------------------    ---------------
* @version  1.0    2014-07-09      Katherine Cardenas    Esta clase de test llama realiza la cobertura de las siguientes clases:
														  IntegracionPolizas_ws
*           2.0    2017-02-08	   Katherine Moreno	  	  Modificacion
************************************************************************************************************
*/

@isTest(SeeAllData=true)
private class IntegracionPolizas_ws_tst {
	
	
	public static IntegracionPolizas_ws.ObjectResponse objResponse = new IntegracionPolizas_ws.ObjectResponse();
	public static IntegracionPolizas_ws.ObjectResponsePoliza objresponsePoliza = new IntegracionPolizas_ws.ObjectResponsePoliza();
	public static IntegracionPolizas_ws.ObjectCrearyActualizarPolizaRequest objPolizareq = new IntegracionPolizas_ws.ObjectCrearyActualizarPolizaRequest();
	public static IntegracionPolizas_ws.ObjectCrearyActualizarPolizaRequest objPolizareq2 = new IntegracionPolizas_ws.ObjectCrearyActualizarPolizaRequest();
	public static IntegracionPolizas_ws.ObjectActualizarCuentaRequest objinObjAcrCunReq = new IntegracionPolizas_ws.ObjectActualizarCuentaRequest(); 
	public static IntegracionPolizas_ws.ObjectResponsePolizaOportunidad objOportunity = new IntegracionPolizas_ws.ObjectResponsePolizaOportunidad();
	public static IntegracionPolizas_ws.ObjectActualizarCuentaResponse objActualizaCuenta = new IntegracionPolizas_ws.ObjectActualizarCuentaResponse();
	public static Poliza__c 		objPoliza 			= new Poliza__c();
	public static Account   		objCuenta 			= new Account();
	public static Account   		objCuentaColeg		= new Account();
	public static Opportunity 		objOpportunity 		= new Opportunity();
	public static OpportunityLineItem objProdOport		= new OpportunityLineItem();
	public static Product2 			objProducto			= new Product2();
	public static Pricebook2		objPriceBook		= new Pricebook2();
	public static PricebookEntry 	objPriceBookEntry	= new PricebookEntry();
	public static Contact			objContacto			= new Contact();
	public static Parametros__c		objParametros		= new Parametros__c();
	public static Parametros__c		objParametros2		= new Parametros__c();
	public static Ciudades__c 		objCiudades			= new Ciudades__c();
	public static Ciudades__c 		objCiudades2		= new Ciudades__c();
	public static TipoRegistroPersona__c objTipReg1		= new TipoRegistroPersona__c();
	public static TipoRegistroPersona__c objTipReg2		= new TipoRegistroPersona__c();
	public static TipoRegistroPersona__c objTipReg3		= new TipoRegistroPersona__c();
	public static RamoTipoRegistroPolizas__c objTipRegPoli= new RamoTipoRegistroPolizas__c();
	public static List<TipoRegistroPersona__c> lstTipReg= new List<TipoRegistroPersona__c>();
	public static Pricebook2 objPricebook2 				= [Select Id, Name, IsActive From Pricebook2 where isStandard = true LIMIT 1];
	
	
	public static IntegracionPolizas_ws.ObjectActualizarCuentaRequest objTomadorReq = new IntegracionPolizas_ws.ObjectActualizarCuentaRequest();
	public static IntegracionPolizas_ws.ObjectActualizarCuentaRequest objBenefReq = new IntegracionPolizas_ws.ObjectActualizarCuentaRequest();
	public static IntegracionPolizas_ws.ObjectActualizarCuentaRequest objAcudienteReq = new IntegracionPolizas_ws.ObjectActualizarCuentaRequest();
		
			
	
 	static testMethod void crearSolicitud_tst()
   	{
   		
   		creaData();
   		armarObjetos();
   		requestPoliza();
   		
   		Test.startTest();
   			IntegracionPolizas_ws.crearSolicitud(new IntegracionPolizas_ws.ObjectCrearyActualizarPolizaRequest());
   			objPolizareq.stridExternoBeneficiario = '12';
   			IntegracionPolizas_ws.crearSolicitud(objPolizareq);
   			objPolizareq.strNumeroOportunidad=null;	
   			objPolizareq.stridExternoBeneficiario = '12';
   			IntegracionPolizas_ws.crearSolicitud(objPolizareq);
   			objPolizareq.strCodigoOperacion = 'CS';
   			objPolizareq.intNumeroSolicitud = null;
   			IntegracionPolizas_ws.crearSolicitud(objPolizareq);
   			objPolizareq.strCodigoOperacion = 'CP';
   			objPolizareq.intNumeroSolicitud = 2324;
   			IntegracionPolizas_ws.crearSolicitud(objPolizareq);
   			objPolizareq.strCodigoOperacion = 'PE';
   			IntegracionPolizas_ws.crearSolicitud(objPolizareq);
   			
   			objPolizareq.strCodigoOperacion = 'PS';
   			objPolizareq.stridExternoTomador = '888888888';
   			IntegracionPolizas_ws.crearSolicitud(objPolizareq);
   			
   			objPolizareq.stridExternoTomador = null;
   			objPolizareq.stridExternoAcudiente = '567878';
   			IntegracionPolizas_ws.crearSolicitud(objPolizareq);
   			objPolizareq.stridExternoAcudiente = null;
   			objPolizareq.stridExternoBeneficiario = '56789'; 
   			IntegracionPolizas_ws.crearSolicitud(objPolizareq);
   			objPolizareq.stridExternoBeneficiario = null;
   			objPolizareq.stridExternoBeneficiario2 = '56789'; 
   			IntegracionPolizas_ws.crearSolicitud(objPolizareq);
   			objPolizareq.stridExternoBeneficiario2 = null;
   			objPolizareq.stridExternoAsegurado = '56789'; 
   			IntegracionPolizas_ws.crearSolicitud(objPolizareq);
   			
   		Test.stopTest();
   	}
   	
   	static testMethod void actualizarCuenta_tst()
   	{
   		
   		creaData();
   		armarObjetos();
   		actCuentaRequest();
   		
   		Test.startTest();
   			IntegracionPolizas_ws.actualizarCuenta(objinObjAcrCunReq);
   			objinObjAcrCunReq.strNumeroIdentificacion = '1234568GS'; 
   			IntegracionPolizas_ws.actualizarCuenta(objinObjAcrCunReq);
   			
   			objinObjAcrCunReq.strNumeroIdentificacion = '1234568GS';
   			objinObjAcrCunReq.strEmpresa = 'GE'; 
   			IntegracionPolizas_ws.actualizarCuenta(objinObjAcrCunReq);
   			
   			objinObjAcrCunReq.intTipoIdentificacion=213245;
   			IntegracionPolizas_ws.actualizarCuenta(objinObjAcrCunReq);
	    	objinObjAcrCunReq.strNumeroIdentificacion = '1234568433GS';
	    	IntegracionPolizas_ws.actualizarCuenta(objinObjAcrCunReq);
	    	objinObjAcrCunReq.intTipoIdentificacion=null;
   			IntegracionPolizas_ws.actualizarCuenta(objinObjAcrCunReq);
   			
   			IntegracionPolizas_ws.getPolizasBenficiario(objCuenta.Id,objPoliza,objOpportunity.Id);
   		Test.stopTest();
   	}
   	
   /*	
   static testMethod void cumpleCondiciones_tst()
   	{
   		
   		creaData();
   		armarObjetos();
   		actCuentaRequest();
   		
   		Test.startTest();
	   		//objPolizareq.intTipoIdentificacionTomador		=	1;
		    //objPolizareq.strUsuarioPropietarioTomadorSFDC	=	system.Userinfo.getUserName();
		    objPolizareq.stridExternoTomador				= 	'123';
		    //objPolizareq.strNumeroIdentificacionTomador		=	 '';
		    objPolizareq.strCodigoOperacion					=	'PS';
   			IntegracionPolizas_ws.crearSolicitud(objPolizareq);
   			
   		Test.stopTest();
   	}
*/   	
   	public static void creaData()
   	{
   		
   		RecordType recordTypeContact 	= [SELECT Id FROM RecordType WHERE SobjectType = 'contact'  and Name ='Asesor'];
   		
   		
   		Parametros__c objParametros0 = new Parametros__c(); 
   		objParametros0.Name 		='CEDULA DE CIUDADANIA';
   		objParametros0.Codigo__c	='1';
   		objParametros0.Campo__c	= 'TipoDocumento__c';
   		objParametros0.Objeto__c	= 'Account';
   		insert objParametros0;
   		
   		objParametros.Name 		='parametro1';
   		objParametros.Codigo__c	='1';
   		objParametros.Campo__c	= 'TipoDocumento__c';
   		objParametros.Objeto__c	= 'Account';
   		insert objParametros;
   		
   		
   		objParametros2.Name 		='parametro2';
   		objParametros2.Codigo__c	='2';
   		objParametros2.Campo__c	= 'Ocupacion__c';
   		objParametros2.Objeto__c	= 'Contacto';
   		insert objParametros2;
   		
   		objTipRegPoli.Name 					= '40';
   		objTipRegPoli.NombreTipoRegistro__c	= 'Vida_Individual_Pensiones_Voluntarias';
   		insert objTipRegPoli;
   		
   		objCiudades.name	='COLOMBIA';
   		objCiudades.Codigo__c= '7';
   		objCiudades.EsPais__c= true;
   		insert objCiudades;
   		
   		objCiudades2.name	='BOGOTA';
   		objCiudades2.Codigo__c= '7_34_1';
   		objCiudades2.EsMunicipio__c=true;
   		insert objCiudades2;
   		
   		objCuenta.FirstName			= 'Cliente Prueba1';
		objCuenta.Id_Externo__c		= '12';
		objCuenta.LastName			= 'prueba1';
		objCuenta.TipoDocumento__c	= 'CEDULA DE CIUDADANIA';
		//objCuenta.NumeroDocumento__c= '1223';
		//objCuenta.CiudadNacimientoCta__c=objCiudades2.id;
		insert objCuenta;
		
		//objCuentaColeg.RecordTypeId = [Select Id From RecordType Where DeveloperName = 'Instituciones_Educativas'][0].Id;
		objCuentaColeg.Name			= 'Cuenta Colegio1';
		objCuentaColeg.Id_Externo__c		= '123';
		objCuentaColeg.TipoDocumento__c = 'NIT';
		objCuentaColeg.NumeroDocumento__c = '1234567890';
		insert objCuentaColeg;
		
		objContacto.FirstName 	= 'Contact1';
		objContacto.LastName	= 'Prueba1';
		objContacto.IdExterno__c= '1234';
		objContacto.RecordTypeId= recordTypeContact.Id;
		insert objContacto;
		
		objPoliza.N_PolizaPlan__c		= '12123';
		objPoliza.Nombre_Tomador__c 	= objCuenta.id;
		objPoliza.NombreBeneficiario__c	= objCuenta.id;
		objPoliza.NombreDesignado__c	= objCuenta.id;
		objPoliza.Estado__c				= 'Activa';
		objPoliza.SemestresAdquiridos__c= '1';
		objPoliza.Id_Externo__c			= '123';
		objPoliza.AnioMaduracion__c		= '2020';
		objPoliza.Curso__c				= 'Kinder';
		objPoliza.MotivoPendiente__c	= 'Motivo pendiente';
		objPoliza.EstadoDocumentoPendiente__c='Estado Documentacion';
		objPoliza.NumeroSolicitud__c	= 1.0;
		insert objPoliza;
		
		objOpportunity.Name							='oportunidad1';
		objOpportunity.IdentificadorOportunidad__c 	= '1';
		objOpportunity.CloseDate					= System.today();
		objOpportunity.StageName					='Cotización';
		objOpportunity.BeneficiarioAsegurado__c		=objCuenta.Id;
		objOpportunity.ClaveNo__c					=objContacto.Id;
		insert objOpportunity;
		
		
		objProducto.name 						= 'Product1';
		objProducto.CodigoRamo__c				= 'COD1';
		objProducto.Compania__c					= 'Global Seguros';
		objProducto.Description					= 'Esta es la descripcion';
		objProducto.EsProductoComercial__c		= false;
		objProducto.IdentificadorProducto__c	= '123';
		objProducto.Plan__c						= 'GLOBAL TARJETA SEGURO';
		objProducto.ProductCode					= 'PRO1';
		objProducto.Ramo__c						= 'Seguro Educativo';
		objProducto.TipoPlan__c					= 'GLOBAL VIDA NTM';	
		objProducto.TipoProducto__c				= 'PLAN COMPLETO'; 
		objProducto.CurrencyIsoCode				= 'COP';
		insert objProducto;
		
		objPriceBook.Name		= 'PriceBook1';
		objPriceBook.IsActive	=true;
		insert objPriceBook;
		
		/*ListaDePrecios__c objListaPrecios   = new ListaDePrecios__c();
        objListaPrecios.Name                = 'prueba lista precios';
        objListaPrecios.IdListaPrecios__c   = '01sG0000001RmNbIAK';    
		insert objListaPrecios;*/
		
		objPriceBookEntry.Pricebook2Id		= objPricebook2.Id;
		objPriceBookEntry.Product2Id		= objProducto.Id;
		objPriceBookEntry.IsActive			= true;
		objPriceBookEntry.UnitPrice			= 0;
		//objPriceBookEntry.UseStandardPrice	= true;
		insert objPriceBookEntry;
		
		objProdOport.OpportunityId		= objOpportunity.Id;
		objProdOport.PricebookEntryId	= objPriceBookEntry.Id;
		objProdOport.UnitPrice	 		=1230.0;
		objProdOport.Quantity			=1;
		insert objProdOport;
		
		
   	
   	}
   	
   	public static void requestPoliza()
   	{
   		objPolizareq.strUsuarioPropietarioPolizaSFDC	=	UserInfo.getUserName();
	    objPolizareq.strCodigoOperacion					=	'PS';
	    objPolizareq.strNumeroOportunidad				=	objOpportunity.IdentificadorOportunidad__c;
	    system.debug('Integer.valueOf(objPoliza.NumeroSolicitud__c) --> ' + Integer.valueOf(objPoliza.NumeroSolicitud__c) + '--> '+objPoliza.NumeroSolicitud__c
	    				+'\n Integer.valueOf(objPoliza.N_PolizaPlan__c)-->' + Integer.valueOf(objPoliza.N_PolizaPlan__c) +' -->'+ objPoliza.N_PolizaPlan__c);
	    objPolizareq.intNumeroSolicitud					=	Integer.valueOf(objPoliza.NumeroSolicitud__c);
	    objPolizareq.intNumeroPoliza					=	Integer.valueOf(objPoliza.N_PolizaPlan__c);
	    objPolizareq.strIdExternoPoliza					=	objPoliza.Id_Externo__c;
	    objPolizareq.intCodigoRamo						=	69;
	    objPolizareq.strCodigoProducto					=	objProducto.IdentificadorProducto__c;
	    objPolizareq.strCodigoProductoDummy				=	objProducto.IdentificadorProducto__c;
	    objPolizareq.strSemestresAdquiridos				=	objPoliza.SemestresAdquiridos__c;
	    objPolizareq.strAnoMaduracion					= 	objPoliza.AnioMaduracion__c;
	    objPolizareq.strIdExternoClaveAgente			=	objContacto.IdExterno__c;
	    objPolizareq.strNombreColegio					=	objCuentaColeg.Id_Externo__c;
	    objPolizareq.intCodigoFuenteRefMercadeo			=	0;
	    objPolizareq.strCodigoCurso						=	objPoliza.Curso__c;
	    objPolizareq.strEstadoPoliza					=	objPoliza.Estado__c;
	    objPolizareq.strMotivoPendiente					=	objPoliza.MotivoPendiente__c;
	    objPolizareq.strEstadoDocumentosPendientes		=	objPoliza.EstadoDocumentoPendiente__c;
	    objPolizareq.strDocumentosPendientes			=	'';
	    objPolizareq.strEstadoInformacionPendiente		=	'Estado de informacion pendiente';
	    objPolizareq.datFechaEmision					= 	system.now().date();
	    objPolizareq.datFechaInicioVigencia				=	system.now().date();
	    objPolizareq.datFechaProximaRenovacion			=	system.now().date();
	    objPolizareq.datFechaFinVigencia				=	system.now().date();
	    objPolizareq.datFechaRecibo						=	system.now().date();
	    objPolizareq.datFechaTarifa						=	system.now().date(); 
	    objPolizareq.bolFinanciada						=	false;
	    objPolizareq.strEntidadFinancia					=	'Entidad Financiada';
	    objPolizareq.strNumeroCuotasFaltanFinanciacion	= 	0;
	    objPolizareq.decTasaFinanciacion				= 	1.0;
	    objPolizareq.strModalidadPago					=	'Cuatro Pagos';
	    objPolizareq.strFormaPpago						=	'Mensual';
	    objPolizareq.strPlazoSeguroVida					=	'';
	    objPolizareq.bolTieneAhorro						=	false;
	    objPolizareq.bolTieneSeguroVida					=	false; 
	    objPolizareq.strTipoMovimiento					=	'';
	    objPolizareq.decValorAsegurado					=	0.0;
	    objPolizareq.decValorPrima						=	0.0;
	    objPolizareq.strApoyoInstitucional				=	UserInfo.getUserName();
	    objPolizareq.strAQuienEenviarCorrespondencia	=	'';
	    objPolizareq.strSucursal						=	'';
	    objPolizareq.intTipoaAgente						=	0;
//	    objPolizareq.strNombresTomador					=	'Nombre Tomador';
//	    objPolizareq.strPrimerApellidoTomador			=	'Apellido Tomador';
//	    objPolizareq.strSegundoApellidoTomador			=	'';
//	    objPolizareq.strTipoPersonaTomador				=	'';
//	    objPolizareq.intTipoIdentificacionTomador		=	1;
//	    objPolizareq.strUsuarioPropietarioTomadorSFDC	=	UserInfo.getUserName();
	    objPolizareq.stridExternoTomador				= 	objCuenta.Id_Externo__c;
//	    objPolizareq.strIdExternoBeneficiario						='45';
/*	    objPolizareq.strNumeroIdentificacionTomador		=	 '123145';
	    objPolizareq.strNacionalidadTomador				=	objCiudades.id;
	    objPolizareq.strGeneroTomador					=	'';
	    objPolizareq.datFechaNacimientoTomador			=	system.now().date();
	    objPolizareq.strCiudadNacimientoTomador			=	objCiudades2.Codigo__c;
	    objPolizareq.datFechaFallecimientoTomador		=	system.now().date();
	    objPolizareq.strEstadoCivilTomador				=	'';
	    objPolizareq.strDireccionCorrespondenciaTomador	=	'';
	    objPolizareq.strTelefonoCorrespondenciaResidenciaTomador	='';
	    objPolizareq.strTelefonoCorrespondenciaOficinaTomador		='';
	    objPolizareq.strCiudadCorrespondenciaTomador				=objCiudades2.Codigo__c;
	    objPolizareq.strFaxCorrespondenciaTomador					='';
	    objPolizareq.strCorreoElectronicoCorrespondenciaTomador		='';
	    objPolizareq.strCelularCorrespondenciaTomador				='';
	    objPolizareq.strOcupacionTomador							=objParametros2.Codigo__c;
	    objPolizareq.strNombresAcudiente							='Nombre Acudiente';
	    objPolizareq.strPrimerApellidoAcudiente						='Apellido Acudiente';
	    objPolizareq.strSegundoApellidoAcudiente					='';
	    objPolizareq.strTipoPersonaAcudiente						='';
	    objPolizareq.intTipoIdentificacionAcudiente					=1;
	    objPolizareq.strNumeroIdentificacionAcudiente				='1234';
	    objPolizareq.stridExternoAcudiente							='13';  
	    objPolizareq.strUsuarioPropietarioAcudienteSFDC				=objUser.Username;
	    objPolizareq.strNacionalidadAcudiente						=objCiudades.id;
	    objPolizareq.strGeneroAcudiente								='';
	    objPolizareq.datFechaNacimientoAcudiente					=system.now().date();
	    objPolizareq.strCiudadNacimientoAcudiente					=objCiudades2.id;
	    objPolizareq.datFechaFallecimientoAcudiente					=system.now().date();
	    objPolizareq.strEstadoCivilAcudiente						='';
	    objPolizareq.strDireccionCorrespondenciaAcudiente			='';
	    objPolizareq.strTelefonoCorrespondenciaResidenciaAcudiente	='';
	    objPolizareq.strTelefonoCorrespondenciaOficinaAcudiente		=''; 
	    objPolizareq.strCiudadCorrespondenciaAcudiente				=objCiudades2.Codigo__c;
	    objPolizareq.strFaxCorrespondenciaAcudiente					='';
	    objPolizareq.strCorreoElectronicoCorrespondenciaAcudiente	='';
	    objPolizareq.strCelularCorrespondenciaAcudiente				='';
	    objPolizareq.strOcupacionAcudiente							=objParametros2.Codigo__c;
	    objPolizareq.strNombresBeneficiario							='Nombre Beneficiario';
	    objPolizareq.strPrimerApellidoBeneficiario					='Apellido Beneficiario';
	    objPolizareq.strSegundoApellidoBeneficiario					='';
	    objPolizareq.strTipoPersonaBeneficiario						='';
	    objPolizareq.intTipoIdentificacionBeneficiario				=1;
	    objPolizareq.strNumeroIdentificacionBeneficiario			='456223';
	    objPolizareq.strIdExternoBeneficiario						='45';     
	    objPolizareq.strUsuarioPropietarioBeneficiarioSFDC			=objUser.Username;
	    objPolizareq.strNacionalidadBeneficiario					=objCiudades.id;
	    objPolizareq.strGeneroBeneficiario							='';
	    objPolizareq.datFechaNacimientoBeneficiario					=system.now().date();
	    objPolizareq.strCiudadNacimientoBeneficiario				=objCiudades2.id;
	    objPolizareq.datFechaFallecimientoBeneficiario				=system.now().date();
	    objPolizareq.strDireccionCorrespondenciaBeneficiario		='';
	    objPolizareq.strTelefonoCorrespondenciaResidenciaBeneficiario='';
	    objPolizareq.strTelefonoCorrespondenciaOficinaBeneficiario	='';
	    objPolizareq.strCiudadCorrespondenciaBeneficiario			=objCiudades2.Codigo__c;
	    objPolizareq.strFaxCorrespondenciaBeneficiario				='';
	    objPolizareq.strCorreoElectronicoCorrespondenciaBeneficiario='';
	    objPolizareq.strCelularCorrespondenciaBeneficiario			='';
	    objPolizareq.strNombresAsegurado							='Nombre Asegurado';
	    objPolizareq.strPrimerApellidoAsegurado						='Apellido Asegurado';
	    objPolizareq.strSegundoApellidoAsegurado					='';
	    objPolizareq.strTipoPersonaAsegurado						='';
	    objPolizareq.intTipoIdentificacionAsegurado					=1;
	    objPolizareq.strNumeroIdentificacionAsegurado				='15423';
	    objPolizareq.stridExternoAsegurado							='65';  
	    objPolizareq.strUsuarioPropietarioAseguradoSFDC				=objUser.Username;
	    objPolizareq.strNacionalidadAsegurado						=objCiudades.id;
	    objPolizareq.strGeneroAsegurado								='';
	    objPolizareq.datFechaNacimientoAsegurado					=system.now().date();
	    objPolizareq.strCiudadNacimientoAsegurado					=objCiudades2.id;
	    objPolizareq.dateFechaFallecimientoAsegurado				=system.now().date();
	    objPolizareq.strEstadoCivilAsegurado						='';
	    objPolizareq.strDireccionCorrespondenciaAsegurado			='';
	    objPolizareq.strTelefonoCorrespondenciaResidenciaAsegurado	='';
	    objPolizareq.strTelefonoCorrespondenciaOficinaAsegurado		='';
	    objPolizareq.strFaxCorrespondenciaAsegurado					='';
	    objPolizareq.strCorreoElectronicoCorrespondenciaAsegurado	='';
	    objPolizareq.strCelularcCorrespondenciaAsegurado			='';
	    objPolizareq.strCiudadCorrespondenciaAsegurado				=objCiudades2.Codigo__c;  
	    objPolizareq.strOcupacionAsegurado							=objParametros2.Codigo__c;
*/	 
		objPolizareq.datFechaCierre = system.today().addMonths(5);
		objPolizareq.datFechaAniversario = system.today();
        objPolizareq.datFechaProximoAniversario = system.today();
        objPolizareq.datFechaPagoCuotaInicial = system.today();
        objPolizareq.blnTerminoCredito = false;
        objPolizareq.decValorCuotaFinanciacion = 1000;
        objPolizareq.intNumeroCuotasPendientes = 1;
        objPolizareq.datFechaRecibo = system.today();
        objPolizareq.decValorAseguradoNuevo = 10000;
        objPolizareq.decPrimaNuevoValor = 10;
        objPolizareq.blnIntencionAhorro = false;
        objPolizareq.strCoberturas = null;   
   	}
   	public static void actCuentaRequest()
   	{
   		objinObjAcrCunReq.strNombres							='Cuenta1';
	    objinObjAcrCunReq.strPrimerApellido						='Actualiza Cuenta1';
	    objinObjAcrCunReq.strSegundoApellido					='';
	    objinObjAcrCunReq.strTipoPersona						='';
	    objinObjAcrCunReq.intTipoIdentificacion					=1;
	    objinObjAcrCunReq.strNumeroIdentificacion				='1234568';
	    objinObjAcrCunReq.stridExternoCuenta					='75';
	    objinObjAcrCunReq.strUsuarioPropietarioSFDC				=UserInfo.getUserName();
	    objinObjAcrCunReq.strNacionalidad						=objCiudades.id;
	    objinObjAcrCunReq.strGenero								='';
	    objinObjAcrCunReq.datFechaNacimiento					=system.now().date();
	    objinObjAcrCunReq.strCiudadNacimiento					=objCiudades2.id;
	    objinObjAcrCunReq.datFechaFallecimiento					=	system.now().date();
	    objinObjAcrCunReq.strEstadoCivil						='';
	    objinObjAcrCunReq.strDireccionCorrespondencia			='';
	    objinObjAcrCunReq.strTelefonoCorrespondenciaResidencia	='';
	    objinObjAcrCunReq.strTelefonoCorrespondenciaOficina		='';
	    objinObjAcrCunReq.strCiudadCorrespondencia				=objCiudades2.Codigo__c;
	    objinObjAcrCunReq.strFaxCorrespondencia					='';
	    objinObjAcrCunReq.strCorreoElectronicoCorrespondencia	='';
	    objinObjAcrCunReq.strCelularCorrespondencia				='';
	    objinObjAcrCunReq.strOcupacion							=objParametros2.Codigo__c;
	    objinObjAcrCunReq.strEmpresa							='GS';
   	}
   	
   	
   	public static void actTomadorRequest()
   	{
   		objTomadorReq.strNombres							='Tomador';
	    objTomadorReq.strPrimerApellido						='Actualiza Tomador';
	    objTomadorReq.strSegundoApellido					='';
	    objTomadorReq.strTipoPersona						='';
	    objTomadorReq.intTipoIdentificacion					=1;
	    objTomadorReq.strNumeroIdentificacion				='1234568987';
	    objTomadorReq.stridExternoCuenta					=objCuenta.Id_Externo__c;
	    objTomadorReq.strUsuarioPropietarioSFDC				=UserInfo.getUserName();
	    objTomadorReq.strNacionalidad						=objCiudades.id;
	    objTomadorReq.strGenero								='';
	    objTomadorReq.datFechaNacimiento					=system.now().date();
	    objTomadorReq.strCiudadNacimiento					=objCiudades2.id;
	    objTomadorReq.datFechaFallecimiento					=	system.now().date();
	    objTomadorReq.strEstadoCivil						='';
	    objTomadorReq.strDireccionCorrespondencia			='';
	    objTomadorReq.strTelefonoCorrespondenciaResidencia	='';
	    objTomadorReq.strTelefonoCorrespondenciaOficina		='';
	    objTomadorReq.strCiudadCorrespondencia				=objCiudades2.Codigo__c;
	    objTomadorReq.strFaxCorrespondencia					='';
	    objTomadorReq.strCorreoElectronicoCorrespondencia	='';
	    objTomadorReq.strCelularCorrespondencia				='';
	    objTomadorReq.strOcupacion							=objParametros2.Codigo__c;
	    objTomadorReq.strEmpresa							='GE';
   	}
   	
   	public static void actBenefRequest()
   	{
   		objBenefReq.strNombres							='Cuenta1';
	    objBenefReq.strPrimerApellido						='Actualiza Cuenta1';
	    objBenefReq.strSegundoApellido					='';
	    objBenefReq.strTipoPersona						='';
	    objBenefReq.intTipoIdentificacion					=1;
	    objBenefReq.strNumeroIdentificacion				='12321343456888';
	    objBenefReq.stridExternoCuenta					='45';
	    objBenefReq.strUsuarioPropietarioSFDC				=UserInfo.getUserName();
	    objBenefReq.strNacionalidad						=objCiudades.id;
	    objBenefReq.strGenero								='';
	    objBenefReq.datFechaNacimiento					=system.now().date();
	    objBenefReq.strCiudadNacimiento					=objCiudades2.id;
	    objBenefReq.datFechaFallecimiento					=	system.now().date();
	    objBenefReq.strEstadoCivil						='';
	    objBenefReq.strDireccionCorrespondencia			='';
	    objBenefReq.strTelefonoCorrespondenciaResidencia	='';
	    objBenefReq.strTelefonoCorrespondenciaOficina		='';
	    objBenefReq.strCiudadCorrespondencia				=objCiudades2.Codigo__c;
	    objBenefReq.strFaxCorrespondencia					='';
	    objBenefReq.strCorreoElectronicoCorrespondencia	='';
	    objBenefReq.strCelularCorrespondencia				='';
	    objBenefReq.strOcupacion							=objParametros2.Codigo__c;
	    objBenefReq.strEmpresa							='GE';
   	}
   	
	public static void armarObjetos()
	{
		   	
		objResponse.codigoRespuesta = ''; 
		objResponse.MensajeRespuesta= '';
		objResponse.idCuenta		= ''; 
		
	    objOportunity.objPoliza 		= new Poliza__c();
	    objOportunity.objOportunidad 	= new Opportunity();
	    objOportunity.MensajeRespuesta	=''; 
	    objOportunity.codigoRespuesta	='';
	   
	    objActualizaCuenta.codigoRespuesta	='';
	    objActualizaCuenta.MensajeRespuesta	='';
	    
	    Opportunity auxidenOport = [Select AuxiliarIdentificador__c from Opportunity where id =:objOpportunity.id limit 1];
	    objresponsePoliza.strnumeroOportunidad		=objOpportunity.IdentificadorOportunidad__c;
	    objresponsePoliza.intCodigoRamo				=0;
	    objresponsePoliza.strnombreBeneficiario		='';
	    objresponsePoliza.inttipoDocumento			=0;
	    objresponsePoliza.strnumeroDocumento		='';
	    objresponsePoliza.strusuarioSFDC			=UserInfo.getUserName();
	    objresponsePoliza.codigoRespuesta			='';
	    objresponsePoliza.MensajeRespuesta			='';
	    objresponsePoliza.idTomador					='';    
	    objresponsePoliza.idDesignado				='';    
	    objresponsePoliza.idBeneficiario			='';    
	    objresponsePoliza.idAsegurado				='';   
	    
	    
	}
	
}