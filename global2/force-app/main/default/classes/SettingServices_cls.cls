/**
* @author Henry William Dorado
* @author <a href="mailto:wdorado@avanxo.com">
* @author <a target="_blank" href="http://www.avanxo.com">www.avanxo.com</a>
* @version 1.0,  &nbsp; Jun-2010.
     Maneja los datos de configuración del servicio (Enpoint,Cetificados,Correo de Notificacion,Numero Máximo de llamadas) y maneja las notificaciones de correo electrónico.
**/
public  class SettingServices_cls {

	public String msgError;					//contiene los mensajes de error
	public  String EndPoint;					//contiene los mensajes de error
	public  String Certificado;				//guarda la informacion del cerificado del servicio
	public  String mailNotificacion;			//contiene el correo electronico donde llegan las nifiticaciones
	public String NombreServicio;			//nombre del servicio web
	
	private  decimal numMaxCallsNormal;		//numero maximo de llamadas a el servicio web  
	private  decimal numMaxCallshigh;			//numero maximo de llamadas a el servicio web  alta concurrencia
	private  decimal numMaxCallslow;			//numero maximo de llamadas a el servicio web  baja concurrencia
	public  decimal numMaxCalls; 
	private  Integer timeoutNormal;            //tiempos de espera para servicios con una concurrencia nomal
	private Integer timeoutLow;               //tiempos de espera para servicios con baja concurrencia 
	private  Integer timeoutHigh;              //tiempos de espera para servicios con alta concurrencia 
	public  Integer timeout;

	public  Boolean notEmail;					//esta variable define si se debe notificar por correo o no
	public  Boolean notWService;				//si se notificara por WS
	public  EndPointsWS__c parWS;
    public  EndPointsWS__c SettingWS;     //carga la configuracion personalizada por servicio  
 	public  Mail_ctr sndMail;					//clase que me permite enviar ocrreos electronicos
 
	//CONSTRUCTOR
	public SettingServices_cls( String NombServicio )
	{	
		
		//se carga la configuracion personalizada global del servicio
		
		sndMail = new Mail_ctr();		//clase que permite enviar un corrreo electronico
		parWS = EndPointsWS__c.getAll().get('CallOutAllServices');
		mailNotificacion = parWS.Notify__c;
		notEmail = parWS.Email_Notification__c;
		NombreServicio = parWS.Name; 
		EndPoint = parWS.Name; 
		numMaxCallsNormal = parWS.attempts__c;
		numMaxCallshigh=parWS.attemptsHigh__c;	
		numMaxCallslow=parWS.attemptsLow__c;
		timeoutNormal = Integer.valueOf(parWS.timeoutNormal__c);
		timeoutLow=Integer.valueOf(parWS.timeoutLow__c);
		timeoutHigh=Integer.valueOf(parWS.timeoutHigh__c);
	    
	    numMaxCalls=numMaxCallsNormal;
	    timeout=timeoutNormal;
		EndPoint = parWS.EndPoint__c;
		 


				
			SettingWS = EndPointsWS__c.getAll().get(NombServicio);
			
			//SERVICIOS DE ALTA CONCURRENCIA
			if( SettingWS != null && SettingWS.ConcurrenceHigh__c && SettingWS.ChangeNumMaxCalls__c ){
				numMaxCalls = numMaxCallshigh;
			}
			if( SettingWS != null && SettingWS.ConcurrenceHigh__c && SettingWS.ChangeTimeOut__c ){
				timeout = timeoutHigh;
			}
			//SERVICIOS DE BAJA CONCURRENCIA
			if( SettingWS != null && SettingWS.ConcurrenceLow__c && SettingWS.ChangeNumMaxCalls__c ){
				numMaxCalls = numMaxCallslow;timeout=timeoutLow;
			}
			if( SettingWS != null && SettingWS.ConcurrenceLow__c && SettingWS.ChangeTimeOut__c ){
				timeout = timeoutLow;
			}
		    if(SettingWS!=null)
		    {
		    	if( SettingWS.Notify__c != null && SettingWS.Notify__c.length() > 0 )
		    		mailNotificacion = SettingWS.Notify__c;
			    if( SettingWS.Email_Notification__c != null )
			    	notEmail = SettingWS.Email_Notification__c;
			    if( SettingWS.EndPoint__c != null && SettingWS.EndPoint__c.length() > 0 )
			    	EndPoint = SettingWS.EndPoint__c;
		    } 
	
	}
	/** 
	*	Hace las notificacion en caso de haber un error recurrente al invocar los servicios web
	*	@param Error. mensaje de error obtenido al invocar el servicio web 
	*	@return. 
	**/
	public void notificacion(System.exception ex)
	{
		String msgError='';
		if(ex!=null&&ex.getMessage()!=null)msgError=ex.getMessage();
		if(notEmail){
		//LLAMAR A NOTIFICACION POR EMAIL
		sndMail.sendMail(mailNotificacion, sndMail.getTemplateSubject(), sndMail.getTemplateNotifi(NombreServicio + msgError));
		}
	}
	
	/** 
	*	Hace las notificacion en caso de haber un error recurrente al invocar los servicios web
	*	@param Error. mensaje de error obtenido al invocar el servicio web 
	*	@return. 
	**/
	public void notificacion(System.exception ex, string extraInfo)
	{
		String msgError='';
		if(ex!=null&&ex.getMessage()!=null)msgError=ex.getMessage();
		if(!test.isRunningTest() && notEmail){
		//LLAMAR A NOTIFICACION POR EMAIL
		sndMail.sendMail(mailNotificacion, sndMail.getTemplateSubject(), sndMail.getTemplateNotifi(NombreServicio + msgError + extraInfo));
		}
	}
	
	/** 
	*	Controla el llamado a la notificacion de erroes por correo electronico
	*	@param numattempts. numero de llamador
	*	@param e. Excepcion
	*	@return Boolean. 
	**/
	public  Boolean ControlNotificacionEmail(decimal numattempts,System.exception e)
	{
		
		if(numattempts>=numMaxCalls)
		{
			notificacion(e);//envia el correo electronico con el error ocurrido
			return false;
		}
		return true ; 
	} 
	
	/*---------------- YNR ------------------- */
	public  Boolean ControlNotificacionEmail(decimal numattempts,System.exception e, string msjCallout)
	{
		
		if(numattempts>=numMaxCalls)
		{
			notificacion(e,msjCallout);//envia el correo electronico con el error ocurrido
			return false;
		}
		return true ; 
	}

	//retorna el endpoint
	public String returnEndPoint(String EnpointActual)
	{
		String rstEnpoint;
	  try{
		  rstEnpoint=parWS.EndPoint__c+EnpointActual.subString( EnpointActual.lastIndexOf('\\'));
	  }catch(System.exception e){return null;}
		return rstEnpoint;
	}


	
}