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
													ServiciosOperativosGlobal_WS_cls
************************************************************************************************************/
@isTest
private class ServiciosOperativosGlobal_WS_tst {

    static testMethod void myUnitTest() {
    	
        Apexpages.Standardcontroller Standardcontroller;
        ServiciosOperativosGlobal_WS_cls.GrabaAcompAgenteResponse_element objGrabaAgenteRes 								= new ServiciosOperativosGlobal_WS_cls.GrabaAcompAgenteResponse_element();
        ServiciosOperativosGlobal_WS_cls.GrabaSeguimBeneficio_element objGrabaSegui 										= new ServiciosOperativosGlobal_WS_cls.GrabaSeguimBeneficio_element ();
        ServiciosOperativosGlobal_WS_cls.GrabaSeguimBeneficioResponse_element	objGrabaSeRes								= new ServiciosOperativosGlobal_WS_cls.GrabaSeguimBeneficioResponse_element();
        ServiciosOperativosGlobal_WS_cls.set_tokenResponse_element	objToken												= new ServiciosOperativosGlobal_WS_cls.set_tokenResponse_element();
        ServiciosOperativosGlobal_WS_cls.set_tokenResponse_element	setToken												= new ServiciosOperativosGlobal_WS_cls.set_tokenResponse_element();
        ServiciosOperativosGlobal_WS_cls.GrabaAcompAgente_element		GrabaAcom											= new ServiciosOperativosGlobal_WS_cls.GrabaAcompAgente_element();
        ServiciosOperativosGlobal_WS_cls.GrabaOportunidad_element		Grabaopor											= new ServiciosOperativosGlobal_WS_cls.GrabaOportunidad_element();
        ServiciosOperativosGlobal_WS_cls.get_tokenResponse_element	tokenResponse_element									= new ServiciosOperativosGlobal_WS_cls.get_tokenResponse_element();
        ServiciosOperativosGlobal_WS_cls.set_token_element	token_element													= new ServiciosOperativosGlobal_WS_cls.set_token_element();
        ServiciosOperativosGlobal_WS_cls.get_token_element	get_token_element												= new ServiciosOperativosGlobal_WS_cls.get_token_element();
        ServiciosOperativosGlobal_WS_cls.GrabaCampaniaResponse_element	GrabaCampaniaResponse_element						= new ServiciosOperativosGlobal_WS_cls.GrabaCampaniaResponse_element();
        ServiciosOperativosGlobal_WS_cls.GrabaCampania_element	GrabaCampania_element										= new ServiciosOperativosGlobal_WS_cls.GrabaCampania_element();
        ServiciosOperativosGlobal_WS_cls.GrabaOportunidadResponse_element	GrabaOportunidadResponse_element				= new ServiciosOperativosGlobal_WS_cls.GrabaOportunidadResponse_element();
        ServiciosOperativosGlobal_WS_cls.WsSalesForceSoap					WsSalesForceSoap								= new ServiciosOperativosGlobal_WS_cls.WsSalesForceSoap();
        
    }
}