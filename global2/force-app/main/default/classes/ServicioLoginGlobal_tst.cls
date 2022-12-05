/**
* Avanxo Colombia
* @author           CAVC					Ahref:cvillalba@avanxo.com	
* Proyect:          Global Seguros
* Description:      test class
*
* Changes (Version)
* -------------------------------------
*           No.     Fecha           Autor                   Descripción
*           -----   ----------      --------------------    ---------------
* @version   1.0    2014-07-11      CAVC     		esta clase de test llama realiza la cobertura de las siguiente clase:
													ServicioLoginGlobal_WS
************************************************************************************************************/
@isTest
private class ServicioLoginGlobal_tst {
		
    static testMethod void myUnitTest() 
    {
    	
       	ApexPages.StandardController standardController;
        ServicioLoginGlobal_WS.ObtenerAcceso_element ObjController 				= new ServicioLoginGlobal_WS.ObtenerAcceso_element();
        ServicioLoginGlobal_WS.ObtenerAccesoResponse_element ObjController2		= new ServicioLoginGlobal_WS.ObtenerAccesoResponse_element();
        ServicioLoginGlobal_WS.WsLoginSoap		ObjController3					= new ServicioLoginGlobal_WS.WsLoginSoap();
        
        
    
    	
    	      
    }
}