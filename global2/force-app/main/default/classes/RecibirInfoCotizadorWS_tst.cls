/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Sergio Andres Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Probar la clase RecibirInfoCotizadorWS y verificar que cada uno de sus métodos cumpla efectivamente su tarea.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha 			Autor 				Descripción
-------------------------------------------------------------------------------------------------------
1.0 16/05/2014 	Sergio Andres Ortiz 	Creación de la clase.

*******************************************************************************************************************/

@isTest
public class RecibirInfoCotizadorWS_tst {

    public static testMethod void infoCotizador_test() {

    	//creacion de objetos
    	Account objCuentaTomador 				= CreaData_tst.metCuentaTomador();
    	Account objCuentaBenef  				= CreaData_tst.metCuentaBeneficiario();
    	Opportunity objOpp 		 				= CreaData_tst.metOportunidad();
    	Contact objContacto						= CreaData_tst.metContacto();
    	Quote objCotizacion						= CreaData_tst.metCotizacion();
    	TipoRegistroPersona__c PNatural			= CreaData_tst.metPersonaNatural();
    	TipoRegistroPersona__c PJuridica		= CreaData_tst.metPersonaJuridica();
    	TipoRegistroPersona__c PBeneficiario	= CreaData_tst.metPersonaBeneficiario();
    	CodigosRespuesta__c    CodResp			= CreaData_tst.metCodResp();
    	ListaDePrecios__c  objListaPrecios    	= CreaData_tst.metListaPrecios();
		Product2  objProduct2					= CreaData_tst.metProduct2();
		PricebookEntry objPricebookEntry		= CreaData_tst.metPricebookEntry(objProduct2.Id);
		Ciudades__c ciudad						= CreaData_tst.metCiudad();
		User usuario							= CreaData_tst.metUser();
        Parametros__c objParametros				= CreaData_tst.metParametros();

    	//instancia del objeto que contiene los datos provenientes del WS
    	RecibirInfoCotizadorWS.DatosCotizacion wsRequest = new RecibirInfoCotizadorWS.DatosCotizacion();

    	//llamado a la carga de datos desde CreaData_tst;
    	wsRequest = CreaData_tst.metWsRequest();
		String numOpp = [Select IdentificadorOportunidad__c From Opportunity Where Id=:objOpp.Id][0].IdentificadorOportunidad__c;
    	wsRequest.strNumOportunidad = numOpp;
    	//llamdo al metodo  captura información desde SISE para crear y/o actualizar Cuentas, Oportunidades, Cotizaciones y Partidas de Cotización.
    	RecibirInfoCotizadorWS.informarCotizacion(wsRequest);
        
    	wsRequest.intNumCotizacion=null;
		RecibirInfoCotizadorWS.informarCotizacion(wsRequest);
        
        wsRequest.intNumCotizacion=1234545;
        wsRequest.strNumOportunidad = null;
		RecibirInfoCotizadorWS.informarCotizacion(wsRequest);
        //instancia del objeto que contiene los datos provenientes del WS
    	RecibirInfoCotizadorWS.DatosCotizacion wsRequest2 = new RecibirInfoCotizadorWS.DatosCotizacion();

    	//llamado a la carga de datos desde CreaData_tst;
    	wsRequest2 = CreaData_tst.metWsRequest();
        wsRequest2.strNumOportunidad = Null;
        wsRequest2.strIdExternoTomador = 'CC843274279';
        wsRequest2.strIdExternoTomador = 'TI123456';
        wsRequest2.intNumCotizacion	= Integer.valueOf(objCotizacion.name);
        wsRequest2.strNumOportunidad = objOpp.IdentificadorOportunidad__c;
        RecibirInfoCotizadorWS.informarCotizacion(wsRequest2);

		RecibirInfoCotizadorWS.getOportunidad(objOpp.Id);
		RecibirInfoCotizadorWS.getCuentaCuenta(objCuentaTomador);
	
    }
}