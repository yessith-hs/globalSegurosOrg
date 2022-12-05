/******************************************************************************************************************
Desarrollado por:				Avanxo Colombia
Autor:							Luis Rafael Peñaranda
Proyecto:						Global Seguros
Descripción:					Clase que implementa la lógica de para configuracion de EndPoints
								En la invocación de servicios web

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No.		Fecha			Autor					Descripción
-------------------------------------------------------------------------------------------------------
1.0		23/05/2014		Luis Rafael Peñaranda 	Creación de la clase.

*******************************************************************************************************************/

public class Conexion_cls {
	 
	ServicioLoginGlobal_WS.WsLoginSoap studLogin;
	ServiciosOperativosGlobal_WS_cls.WsSalesForceSoap studOperativo;
	String servicioInterface = '';
	SettingServices_cls  st;
	 
	public  ServiciosOperativosGlobal_WS_cls.WsSalesForceSoap getConexion_cls(String token){
		
		studOperativo = new ServiciosOperativosGlobal_WS_cls.WsSalesForceSoap();
		studOperativo.set_token(token);
		st				=	new SettingServices_cls('CallOutAllServices');			
		studOperativo.endpoint_x	= 		st.EndPoint;	//establece el enpoint 
		system.debug('@@stud.endpoint_x--> '+studOperativo.endpoint_x);		
		studOperativo.timeout_x= 		st.timeout;
		studOperativo.clientCertPasswd_x=st.parWS.clientCertPasswd__c; 	
		return 	studOperativo;
	}


	public  ServicioLoginGlobal_WS.WsLoginSoap getConexionLogin_cls(){
		SettingServices_cls  st;
		studLogin = new ServicioLoginGlobal_WS.WsLoginSoap();
		st				=	new SettingServices_cls('LoginServiceCallout');			
		studLogin.endpoint_x	= 		st.EndPoint;	//establece el enpoint 
		system.debug('@@stud.endpoint_x--> '+studLogin.endpoint_x);		
		studLogin.timeout_x= 		st.timeout;
		studLogin.clientCertPasswd_x=st.parWS.clientCertPasswd__c; 	
		return 	studLogin;
	} 




	// Grabar Oportunidad
	public String  GrabaOportunidad(String strCodOperacion,String strNumOportunidad,Integer intTipDocumento,String strNumDocumento,Integer intCodRamo,String strNombreBeneficiario,String nombreUsuario, decimal numattempts) {

		String  interfaceOportunidad;
			try
		{
			interfaceOportunidad= studOperativo.GrabaOportunidad(strCodOperacion,strNumOportunidad,intTipDocumento,strNumDocumento,intCodRamo,0,0,strNombreBeneficiario,nombreUsuario);
			System.debug('=====>rta interfaceOportunidad:'+interfaceOportunidad);			
	
			
		}
		catch( System.exception e )
		{ 
			servicioInterface = 'GrabaSeguimBeneficio';		
			if(st.ControlNotificacionEmail(numattempts,e,servicioInterface)) {
				numattempts++;
				return GrabaOportunidad(strCodOperacion,strNumOportunidad, intTipDocumento, strNumDocumento, intCodRamo, strNombreBeneficiario, nombreUsuario,  numattempts);
			}
				
		}
		return interfaceOportunidad;
	}
	
	// Actualizar Beneficios
	public String  GrabaSeguimBeneficio(Integer intNumPoliza,String dateFechaSegimiento,String strUsuarioSeguimiento,String strObservacion, decimal numattempts){
		String  respuesta;
			try
		{
			if(!test.isRunningTest())
				
			{
				respuesta= studOperativo.GrabaSeguimBeneficio(intNumPoliza,dateFechaSegimiento,strUsuarioSeguimiento,strObservacion);
				System.debug('=====>rta respuesta:'+respuesta);			
	
			}
		}
		catch( System.exception e )
		{ 
			servicioInterface = 'GrabaSeguimBeneficio';		
			if(st.ControlNotificacionEmail(numattempts,e,servicioInterface)) {
				numattempts++;
				return GrabaSeguimBeneficio(intNumPoliza,dateFechaSegimiento,strUsuarioSeguimiento,strObservacion, numattempts);
			}
				
		}
		return respuesta;
	}
	
	
	public String  GrabaAcompAgente(Integer tipo_agente,Integer cod_agente,String fechaAcomp,String userName, decimal numattempts){
		String  respuestaWS;
			try
		{
			respuestaWS= studOperativo.GrabaAcompAgente(tipo_agente,cod_agente,fechaAcomp,userName);
			System.debug('=====>rta respuestaWS:'+respuestaWS);			
	
			
		}
		catch( System.exception e )
		{ 
			servicioInterface = 'GrabaAcompAgente';		
			if(st.ControlNotificacionEmail(numattempts,e,servicioInterface)) {
				numattempts++;
				return GrabaAcompAgente(tipo_agente,cod_agente,fechaAcomp,userName,  numattempts);
			}
				
		}
		return respuestaWS;
	}
	
	
	public String  GrabaCampania(String nombreCamp, integer intCodigoCampana, Boolean senal, String strCiudad,decimal numattempts){
		String interfaceCamapana;
			try
		{
			interfaceCamapana= studOperativo.GrabaCampania(nombreCamp, intCodigoCampana, senal, strCiudad, '');
			System.debug('=====>rta interfaceCamapana:'+interfaceCamapana);			
	
			
		}
		catch( System.exception e )
		{ 
			servicioInterface = 'GrabaCampania';		
			if(st.ControlNotificacionEmail(numattempts,e,servicioInterface)) {
				numattempts++;
				return GrabaCampania(nombreCamp, intCodigoCampana, senal, strCiudad,numattempts);
			}
				
		}
		return interfaceCamapana;
	}
		
	
	public String  ObtenerAcceso(decimal numattempts){
		String token;
			try
		{
			token= studLogin.ObtenerAcceso(System.Label.Gbc_UsuarioWS,System.Label.Gbc_claveWS); 
			System.debug('=====>rta token:    '+token);			
	
			
		}
		catch( System.exception e )
		{ 
			servicioInterface = 'get Token';		
			if(st.ControlNotificacionEmail(numattempts,e,servicioInterface)) {
				numattempts++;
				return ObtenerAcceso(numattempts);
			}
				
		}
		return token;
	}	
}