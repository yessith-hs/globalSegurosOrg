/**
* Avanxo Colombia
* @author           CAVC							href:cvillalba@avanxo.com
* Proyect:          global Seguros
* Description:      test Class
*
* Changes (Version)
* -------------------------------------
*           No.     Fecha           Autor                   Descripción
*           -----   ----------      --------------------    ---------------
* @version   1.0    2014-07-01      CAVC     		esta clase de test llama realiza la cobertura de las siguientes clases:
													actualizacionEstadoPagos_WS
													actualizacionEstadoPagos_cls	
************************************************************************************************************
*/

@isTest
private class actualizacionEstadoPagos_tst {

    static testMethod void myUnitTest() {
    	
    	Poliza__c  ObjPoliza											= new Poliza__c();
    	ObjPoliza.AlturasPagadas__c										= 3;
    	ObjPoliza.Anio_vigente_del_pago__c								= 2014;
    	ObjPoliza.Carrera__c											= 'sistemas';
    	ObjPoliza.CiudadUniversidad__c									= 'bta';
    	ObjPoliza.EstadoSemestre__c										= 'en curso';
    	ObjPoliza.Estado__c												= 'activo';
    	ObjPoliza.FechaLimitePago__c									= date.newInstance(2014, 2, 1);
    	ObjPoliza.FechaPagoSemestre__c									= date.newInstance(2013, 1, 3);
    	ObjPoliza.Id_Externo__c											= 'asdhi234957684345039';
    	ObjPoliza.Periodo__c											= 1;
    	ObjPoliza.SubEstadoSemestre__c									= 'en curso';
    	ObjPoliza.Universidad__c										= 'U Central';
    	
    	insert ObjPoliza;
        
        actualizacionEstadoPagos_cls objEstadoPagos 					= new actualizacionEstadoPagos_cls();
        actualizacionEstadoPagos_WS.DatosEstadoPagoRequest objRequest 	= new actualizacionEstadoPagos_WS.DatosEstadoPagoRequest();
        
        objRequest.datFechaLimitePago									= date.newInstance(2014, 6, 1);
        objRequest.strIdExtPoliza										= ObjPoliza.Id_Externo__c;
		objRequest.strUniversidad										='u central';
		objRequest.strCiudadUniversidad									='bta';
		objRequest.strCarrera											='sistemas';
		objRequest.datFechaLimitePago									= date.newInstance(2014, 4, 12);
		objRequest.dblAlturasPagadas									= 12.0;
		objRequest.dblPeriodoVigenciaPago								= 2.0;
		objRequest.dblAnioVigenciaPago									= 2014;
		objRequest.strEstadoSemestre									= 'activo';
		objRequest.strSubEstadoSemestre									= 'activo';
		objRequest.datFechaPagoSemestre									= date.newInstance(2014, 1, 1);
		objRequest.strEstadoPoliza										= 'activa';
		
		test.startTest();
        objEstadoPagos.actualizarPoliza(objRequest);
        test.stopTest();
    }
    
    static testMethod void myUnitTestIDNull() {
    	
    
        
        actualizacionEstadoPagos_cls objEstadoPagos   					= new actualizacionEstadoPagos_cls();
        actualizacionEstadoPagos_WS.DatosEstadoPagoRequest objRequest 	= new actualizacionEstadoPagos_WS.DatosEstadoPagoRequest();
        
        objRequest.datFechaLimitePago									= date.newInstance(2014, 6, 1);
        objRequest.strIdExtPoliza										= '12';
		objRequest.strUniversidad										='u central';
		objRequest.strCiudadUniversidad									='bta';
		objRequest.strCarrera											='sistemas';
		objRequest.datFechaLimitePago									= date.newInstance(2014, 4, 12);
		objRequest.dblAlturasPagadas									= 12.0;
		objRequest.dblPeriodoVigenciaPago								= 2.0;
		objRequest.dblAnioVigenciaPago									= 2014;
		objRequest.strEstadoSemestre									= 'activo';
		objRequest.strSubEstadoSemestre									= 'activo';
		objRequest.datFechaPagoSemestre									= date.newInstance(2014, 1, 1);
		objRequest.strEstadoPoliza										= 'activa';
		
		test.startTest();
        objEstadoPagos.actualizarPoliza(objRequest);
        test.stopTest();
    }
    
    static testMethod void WebServicesResp() {
    	
    	Poliza__c  ObjPoliza								= new Poliza__c();
    	ObjPoliza.AlturasPagadas__c							= 3;
    	ObjPoliza.Anio_vigente_del_pago__c					= 2014;
    	ObjPoliza.Carrera__c								= 'sistemas';
    	ObjPoliza.CiudadUniversidad__c						= 'bta';
    	ObjPoliza.EstadoSemestre__c							= 'en curso';
    	ObjPoliza.Estado__c									= 'activo';
    	ObjPoliza.FechaLimitePago__c						= date.newInstance(2014, 2, 1);
    	ObjPoliza.FechaPagoSemestre__c						= date.newInstance(2013, 1, 3);
    	ObjPoliza.Id_Externo__c								= 'asdhi234957684345039';
    	ObjPoliza.Periodo__c								= 1;
    	ObjPoliza.SubEstadoSemestre__c						= 'en curso';
    	ObjPoliza.Universidad__c							= 'U Central';
    	
    	insert ObjPoliza;
        
        actualizacionEstadoPagos_cls objEstadoPagos   						= new actualizacionEstadoPagos_cls();
        actualizacionEstadoPagos_WS.DatosEstadoPagoRequest objRequest = new actualizacionEstadoPagos_WS.DatosEstadoPagoRequest();
        
        objRequest.datFechaLimitePago									= date.newInstance(2014, 6, 1);
        objRequest.strIdExtPoliza										= ObjPoliza.Id_Externo__c;
		objRequest.strUniversidad										='u central';
		objRequest.strCiudadUniversidad								='bta';
		
		objRequest.strCarrera											='sistemas';
		objRequest.datFechaLimitePago									= date.newInstance(2014, 4, 12);
		objRequest.dblAlturasPagadas									= 12.0;
		objRequest.dblPeriodoVigenciaPago								= 2.0;
		objRequest.dblAnioVigenciaPago								= 2014;
		objRequest.strEstadoSemestre									= 'activo';
		objRequest.strSubEstadoSemestre								= 'activo';
		objRequest.datFechaPagoSemestre								= date.newInstance(2014, 1, 1);
		objRequest.strEstadoPoliza									= 'activa';
		
		actualizacionEstadoPagos_WS.actualizacionEstadoPagos(objRequest);
    }
    
}