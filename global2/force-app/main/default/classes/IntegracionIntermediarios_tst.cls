/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class IntegracionIntermediarios_tst {
	
	public static IntegracionIntermediarios_ws.ObjectActualizarIntermediarioRequest objReq = new IntegracionIntermediarios_ws.ObjectActualizarIntermediarioRequest();
	
	
	
	public static Account   		objCuenta 			= new Account();
	public static Parametros__c		objParametros		= new Parametros__c();
	public static Parametros__c		objParametros2		= new Parametros__c();
	public static Ciudades__c 		objCiudades			= new Ciudades__c();
	public static Ciudades__c 		objCiudades2		= new Ciudades__c();
	public static Contact			objContacto			= new Contact();
	
	
	

    static testMethod void myUnitTest() {
        creaData();
        getRequest();
        
        Test.startTest();
        	IntegracionIntermediarios_ws.crearYActualizarIntemediario(objReq);
        	objReq.strApoyoinstitucional=null;
        	IntegracionIntermediarios_ws.crearYActualizarIntemediario(objReq);
        	objReq.strIdExternoContacto=null;
        	IntegracionIntermediarios_ws.crearYActualizarIntemediario(objReq);
        	objReq.strPrimerApellido=null;
        	objReq.strNombres=null;
        	IntegracionIntermediarios_ws.crearYActualizarIntemediario(objReq);
        	objReq.strUsuarioPropietarioSFDC = null;
        	IntegracionIntermediarios_ws.crearYActualizarIntemediario(objReq);
        	objReq.strTipoRegistro = '23456';
        	IntegracionIntermediarios_ws.crearYActualizarIntemediario(objReq);
        
        Test.stopTest();
    }
    
    public static void creaData()
   	{
   	
   		
   		
   		objParametros = new Parametros__c(); 
   		objParametros.Name 		='CEDULA DE CIUDADANIA';
   		objParametros.Codigo__c	='1';
   		objParametros.Campo__c	= 'TipoDocumento__c';
   		objParametros.Objeto__c	= 'Account';
   		insert objParametros;
   		
   		
   		objParametros2.Name 		='parametro2';
   		objParametros2.Codigo__c	='2';
   		objParametros2.Campo__c	= 'Ocupacion__c';
   		objParametros2.Objeto__c	= 'Contacto';
   		insert objParametros2;
   		
   		
   		objCiudades.name	='COLOMBIA';
   		objCiudades.Codigo__c= '7';
   		objCiudades.EsPais__c= true;
   		insert objCiudades;
   		
   		objCiudades2.name	='BOGOTA';
   		objCiudades2.Codigo__c= '7_34_1';
   		objCiudades2.EsMunicipio__c=true;
   		insert objCiudades2;
   		
   		objCuenta.Name			= 'Cliente Prueba1';
		objCuenta.Id_Externo__c		= '12';
		objCuenta.TipoDocumento__c	= 'CEDULA DE CIUDADANIA';
		//objCuenta.RecordTypeId 	= [Select Id From RecordType Where DeveloperName = 'Intermediarios'][0].Id;
		//objCuenta.NumeroDocumento__c= '1223';
		//objCuenta.CiudadNacimientoCta__c=objCiudades2.id;
		insert objCuenta;
		
		RecordType recordTypeContact 	= [SELECT Id FROM RecordType WHERE SobjectType = 'contact'  and Name ='Asesor'];
		objContacto.FirstName 	= 'Contact1';
		objContacto.LastName	= 'Prueba1';
		objContacto.IdExterno__c= '8888888';
		objContacto.RecordTypeId= recordTypeContact.Id;
		insert objContacto;
		
   	
   	}
   	
   	
   	public static void getRequest(){
   		objReq.bolTienePadre 				= true;
   		objReq.datFechaAlta					= system.today();
   		objReq.datFechaBaja					= system.today();
   		objReq.datFechaFallecimiento 		= null;
   		objReq.datFechaNacimiento			= system.today().addYears(-25);
   		objReq.intClaveIntermediario		= 12345;
   		objReq.intTipoIdentificacion 		= 1;
   		objReq.strApoyoinstitucional		= UserInfo.getUserName();
   		objReq.strCanalVenta				= 'Canal 1';
   		objReq.strCelular					= '12345677876';
   		objReq.strCiudadCorrespondencia		= '7_34_1';
   		objReq.strCiudadNacimiento			= '7_34_1';
   		objReq.strClaveIntermediarioPadre	= objContacto.IdExterno__c;
   		objReq.strConvenio					= 'Convenio';
   		objReq.strCorreoElectronico			= 'aaaaaa@aaaaaa.com';
   		objReq.strCorreoElectronicoRepresentanteLegal = 'aaaaa1@aaaa.com';
   		objReq.strDireccionOficina			= 'cra';
   		objReq.strDireccionResidencia		= 'cra1';
   		objReq.strEjecutivoDeCuentas		= 'Ejec';
   		objReq.strEmpresa					= 'GS';
   		objReq.strEstado					= 'Activo';
   		objReq.strEtapaVinculacion			= 'Inicio';
   		objReq.strEvaluacionesAprobadas		= 'Educativo';
   		objReq.strEvaluacionesPendientes	= 'Educativo';
   		objReq.strGenero					= 'Masculino';
   		objReq.stridExternoContacto			= 'IdContactAVx';
   		objReq.stridExternoCuentaAsociada	= objCuenta.Id;
   		objReq.strNombres 					= 'Intermediario';
   		objReq.strNumeroIdentificacion		= '12345676';
   		objReq.strOcupacion					= '2';
   		objReq.strOrigenIntermediario		= 'Internet';
   		objReq.strPrimerApellido			= '1';
   		objReq.strPuntoDeVenta				= 'PV 1';
   		objReq.strRamosHabilitados			= '41';
   		objReq.strSegundoApellido			= '2';
   		objReq.strSucursal					= 'Suc 1';
   		objReq.strTelefonoOficina			= '3245253';
   		objReq.strTelefonoResidencia		= '1234564';
   		objReq.strTipoConvenio				= 'TP';
   		objReq.strTipoIntermediario			= 'TI';
   		objReq.strTipoPersona				= 'Intermediario';
   		objReq.strTipoRegistro				= [Select Id From RecordType Where SObjectType='Contact' And DeveloperName = 'Asesor'][0].Id;
   		objReq.strUsuarioPropietarioSFDC	= UserInfo.getUserName();
   		objReq.strUsuarioSalesforce			= UserInfo.getUserName();
   	}
}