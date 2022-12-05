/****************************************************************************************************
    Información general 
    -------------------
    Desarrollado por:   Avanxo Colombia
    Autor:              Luis Peñaranda.
    Proyecto:           Global Seguros (CRM)
    Descripción:        Clase para Obtener el token para autenticacion de los servicios web que expone SISE
       
    Información sobre cambios (Versiones)
    -------------------------------------
    Número  Fecha       Autor                       Descripción
    ------  ----------  --------------------------  -----------
    1.0     23-04-2014  Luis Peñaranda       		Creacion.
    ****************************************************************************************************/
public class ObtenerTokenGlobal_cls {
	ServicioLoginGlobal_WS.WsLoginSoap slg;
	Conexion_cls con = new Conexion_cls();
	
	public ObtenerTokenGlobal_cls(){
		 slg = con.getConexionLogin_cls(); 
	}
	/* Metodo de obtencion del token del token para autenticacion de los servicios web que expone SISE*/
	public String getToken(){
		String token=con.ObtenerAcceso(0);
		system.debug('El token es-->'+token);		
		return token;
	} 
}