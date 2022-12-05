/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Sergio Andres Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Calcular la cantidad de Horas Transcurridas desde la fecha y hora en que es recibido el caso.
- Calcular la fecha de cambio de estado para un caso y retorna el valor que debe asumir el semaforo.
- Asignar el estado del semaforo del caso segun la parametrizacion establecida en el asunto.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha Autor Descripción
-------------------------------------------------------------------------------------------------------
1.0 11/04/2014 Sergio Andres Ortiz Creación de la clase. 
2.0 22/04/2014 Sergio Andres Ortiz Generar envio de Correo electronico al cambiar el estado de los semaforos 
3.0 15/10/2014 Angel  Soto Asignación de responsable Amarillo, morado y/o rojo dependiendo de su valor actual 

*******************************************************************************************************************/
 
public class TiemposySemaforosXCaso_cls { 
   
  public Double horaCaso;
  public String semaforo;	
  public Map<Id, Asuntos__c> mapAsuntos;
  public Map<Id, User> mapUsuarios;
        
  public TiemposySemaforosXCaso_cls(){
  
    mapAsuntos=new map<Id, Asuntos__c>([SELECT Id,Empresa__c,NHorasVerde__c,NHorasAmarillo__c,NHorasRojo__c,NHorasMorado__c,ResponsableAmarillo__c, ResponsableRojo__c, ResponsableMorado__c,remitente__c,Nombre_Remitente__c 
                      FROM Asuntos__c]);
    system.debug('@@------mapAsuntos---------->'+mapAsuntos);  
    
    mapUsuarios=new map<Id, User>([SELECT Id,Email,FirstName FROM User]);
    system.debug('@@------mapAsuntos---------->'+mapAsuntos);
    
  }
  
  public TiemposySemaforosXCaso_cls(Map<Id, Asuntos__c> mapaAsuntos, Map<Id, User> mapaUsuarios ){
  
    mapAsuntos = mapaAsuntos;
    system.debug('@@------mapAsuntos---------->'+mapAsuntos);  
    mapUsuarios = mapaUsuarios;
    system.debug('@@------mapAsuntos---------->'+mapUsuarios);
    
  }
    
  // Calcular la cantidad de Horas Transcurridas desde la fecha y hora en que es recibido el caso
  // ----------------------------------------------------------------------------------------------------------------
  public Double getTiempoTranscurridoXCaso(Case objCaso){    
      // Definicion de variables de trabajo
      Datetime fechacreacion =  objCaso.FechaHoraRecibido__c;
      Datetime fechacierre = objCaso.ClosedDate;      
    system.debug('@@-ID CASO >>>id->'+objCaso.id+'@@-Caso fechacreacion >>>O->'+fechacreacion+'@@-Caso fechacierre >>>C->'+fechacierre);            
        Double  rangoFinVerde;
    Double  rangoFinAmarillo;         
          
    // Obtener la fecha y hora actual
        Datetime fechaactual = datetime.now();
        
        // Si existe fecha de cierre se toma esta fecha en lugar de la fecha del dia
        if (fechacierre != null) fechaactual = fechacierre;
        system.debug('@@fechaactual-->'+fechaactual);
        // sino asignaron fecha de recibido
        if (fechacreacion == null) fechacreacion = fechaactual;
        system.debug('@@fechacreacion-->'+fechacreacion);
        
    // Tomar el horario de oficina que corresponde a Colombia
    BusinessHours bh = [SELECT Id FROM BusinessHours  WHERE name='Col'];
        
    // Obtener la diferencia en milisegundos entre la fecha de creacion  y la fecha actual teniendo en cuenta
    // el Horario de oficina y los festivos configurados en este. 
    long milisegundos = BusinessHours.diff(bh.id, fechacreacion, fechaactual);
    system.debug('@@longtime-->'+milisegundos );

    // Tomar los milisegundos y convertirlos en horas, minutos y segundos    
        System.debug('milisegundos:'+milisegundos);
        Double segundos = milisegundos / 1000;
        System.debug('segundos:'+segundos);
        Double minutos = segundos / 60;
        System.debug('minutos:'+minutos);
        Decimal horas = minutos / 60;
        System.debug('horas:'+horas);
        horaCaso=horas.setScale(2);
               
        return horaCaso;
  }
  
  
  // Calcular la fecha de cambio de estado para un caso y retorna el valor que debe asumir el semaforo
  // -----------------------------------------------------------------------------------------------------------
  public String getEstadoSemaforoXCaso(Case objCaso){  

    // Definicion de variables de trabajo
    //String idAsunto = objCaso.Asunto__c;
    String idAsunto;
        Decimal  rangoFinVerde;
    Decimal  rangoFinAmarillo;  
    Decimal rangoFinRojo;
    Decimal rangoFinMorado;  
      String semaforo;
      String responAmarillo;
      String responRojo;
      String responMorado;
      String correoRemitente;
      String nombreRemitente;         
        semaforo = 'Verde';
        ID propietario;
      Asuntos__c objAsunto;  
    list<Asuntos__c> lstAsuntos;
    list<Poliza__c> lstPoliza;
    
    
    // obtener la empresa de la póliza
    // ------------------------------
    if(objCaso.Poliza__c!= null){
      lstPoliza = [select EmpresaProducto__c from Poliza__c where id=:objCaso.Poliza__c];
    }  
    system.debug('lista poilzas' + lstPoliza);
    //Obtener el id del Asunto
    // ----------------------
    if(lstPoliza.get(0).EmpresaProducto__c!=null  )
    {
      System.debug('producto c ' + objCaso.Producto__c + ' asuntos c ' + objCaso.Asuntos__c + ' poliza ' + lstPoliza.get(0).EmpresaProducto__c);
      if(lstPoliza.size()>0){
        lstAsuntos = [select id,ResponsableVerde__c,ResponsableMorado__c,ResponsableAmarillo__c,ResponsableRojo__c,remitente__c,Nombre_Remitente__c 
                  from   Asuntos__c 
                       where Producto__c  =:  objCaso.Producto__c 
                       and   Name      =:  objCaso.Asuntos__c
                       and    Empresa__c    =: lstPoliza.get(0).EmpresaProducto__c];
      }
      //system.debug('\n\n lstAsuntos==>'+lstAsuntos);                            
      if(lstAsuntos.size()>0)
      {  
        /*Angel Soto - Start

        - Si los responsables Morado, Amarillo y Rojo están vacios se les inserta el responsable Verde
        - Si alguno de los responsables Morado, Amarillo y Rojo está con otro nombre diferente al responsable Verde permanece con el mismo*/

           objAsunto = lstAsuntos[0];

                 if( objAsunto.ResponsableMorado__c == null ){

            objAsunto.ResponsableMorado__c   = objAsunto.ResponsableVerde__c;
          }
          if( objAsunto.ResponsableAmarillo__c == null){
            
            objAsunto.ResponsableAmarillo__c   = objAsunto.ResponsableVerde__c;
          }
          if( objAsunto.ResponsableRojo__c == null ){
            
            objAsunto.ResponsableRojo__c   = objAsunto.ResponsableVerde__c;
          }
        
        try{
          update objAsunto;

        } catch (Exception e) {
          system.debug('\n\n ERROR');
        }



        
        /*Angel Soto - End */

        idAsunto =   lstAsuntos.get(0).id;                  
            system.debug('@@-idAsunto->'+idAsunto);
            system.debug('@@-mapAsuntos.get(idAsunto)->'+mapAsuntos);  
            
        rangoFinVerde = mapAsuntos.get(idAsunto).NHorasVerde__c;
        rangoFinAmarillo = mapAsuntos.get(idAsunto).NHorasAmarillo__c;
        rangoFinRojo = mapAsuntos.get(idAsunto).NHorasRojo__c;      
        rangoFinMorado = mapAsuntos.get(idAsunto).NHorasMorado__c;  
        responAmarillo = mapAsuntos.get(idAsunto).ResponsableAmarillo__c;
        responRojo = mapAsuntos.get(idAsunto).ResponsableRojo__c;
        responMorado = mapAsuntos.get(idAsunto).ResponsableMorado__c;
        correoRemitente = mapAsuntos.get(idAsunto).remitente__c;
        nombreRemitente = mapAsuntos.get(idAsunto).Nombre_Remitente__c;
        system.debug('@@-semaHVerde->'+rangoFinVerde+'@@-semaHAmarillo->'+rangoFinAmarillo);       
             
        // Conforme a los rangos calcular el estado del semaforo y envia la notificacion de escalamiento del caso        
        if (horaCaso <= rangoFinVerde){
          semaforo = 'Verde';
          if(objAsunto != null){
            propietario  = objAsunto.ResponsableVerde__c;
          }
        } else if (( rangoFinVerde < horaCaso ) && ( horaCaso <= rangoFinAmarillo )){
          semaforo = 'Amarillo';
          if(objAsunto != null){
            propietario  = objAsunto.ResponsableAmarillo__c;
          }
          //envioEMail(responAmarillo, semaforo, objCaso); 
          envioEMail(correoRemitente,nombreRemitente, responAmarillo,semaforo, objCaso); 
        } else if (( rangoFinAmarillo < horaCaso ) && ( horaCaso <= rangoFinRojo )) {
          semaforo = 'Rojo';
          if(objAsunto != null){
            propietario  = objAsunto.ResponsableRojo__c;
          }  
          //envioEMail(responRojo, semaforo, objCaso);
          envioEMail(correoRemitente,nombreRemitente,responRojo, semaforo, objCaso); 
        }else{
          semaforo = 'Morado';
          if(objAsunto != null){
            propietario  = objAsunto.ResponsableMorado__c;
          }  
          //envioEMail(responAmarillo, semaforo, objCaso);
          envioEMail(correoRemitente, nombreRemitente,responMorado,semaforo, objCaso);  
        }     
      }    
      system.debug('@@Semaforo-Nuevo propietario-->'+propietario);
      system.debug('@@Semaforo-Estado a actualizar-->'+semaforo);
      
      /* Angel Soto - Start : Establece el estado semáforo y  propietario del caso de acuerdo al color*/
      //asignar el color correspondiente al semaforo
      if(semaforo!=null){
        system.debug('@@-Color del Semaforo Actual ->>-->>'+objCaso.estadoSemaforo__c); 
        objCaso.estadoSemaforo__c = semaforo;                  
        system.debug('@@--Color asignado al semaforo -@@-->'+objCaso.estadoSemaforo__c);
        
        if(propietario != null){
          system.debug('AS - Propietario actual del caso  ->>-->>'+objCaso.OwnerId ); 
          objCaso.OwnerId  = propietario;                  
          system.debug('@@AS - Nuevo propietario del caso -@@-->'+objCaso.OwnerId );
        }
        
      }  
      /* Angel Soto - End */
      return semaforo;
    }else{
      return null;
    }

  }
  public void setUsuarioBackUpenCasos(){
     Map<ID,ID> checkUsers   = new Map<ID,ID>();
     /*
      En caso de que un Usuario esté en VACACIONES, reemplaza en todos sus casos el propietario por el usuario backup
     */
    List<User> lstUser = [SELECT id,Fecha_fin_vacaciones__c,Fecha_inicio_vacaciones__c,Name,Usuario_BackUp__c
                 FROM User where Fecha_fin_vacaciones__c >=:date.today() 
                   and Fecha_inicio_vacaciones__c >=:date.today() ];
    for  (User objUser : lstUser){
       if(objUser.Usuario_BackUp__c != null)
                checkUsers.put(objUser.Id, objUser.Usuario_BackUp__c);
    }
    List<Case> lstCases = [select id, OwnerId from Case where  OwnerId in :checkUsers.keySet() and Status <> 'Cerrado'];
        system.debug('\n\n AS - PERIODO VACACIONES-lstCases.size()==>'+lstCases.size());
        
    if( lstCases.size() > 0 ){
      for (Case objCase : lstCases ) {
            objCase.OwnerId     = checkUsers.get(objCase.OwnerId);
            objCase.PropietarioTemporal__c = true;
      }
      update lstCases;
      
    }
     /*
      Al finalizar vacaciones los casos abiertos que tienen como propietario el usuario backup vuelven a pertenecer al usuario inicial.
     */
    lstUser = [SELECT id,Fecha_fin_vacaciones__c,Fecha_inicio_vacaciones__c,Name,Usuario_BackUp__c
                 FROM User where Fecha_fin_vacaciones__c <:date.today()];
    
    for  (User objUser : lstUser){
       if(objUser.Usuario_BackUp__c != null)
                checkUsers.put(objUser.Usuario_BackUp__c,objUser.Id);
    }
    lstCases = [select id, OwnerId from Case where  OwnerId in :checkUsers.keySet() and Status <> 'Cerrado' and PropietarioTemporal__c = true];
    system.debug('\n\n AS - PERIODO FUERA DE VACACIONES-lstCases.size()==>'+lstCases.size());
    
    if( lstCases.size() > 0 ){
      for (Case objCase : lstCases ) {
            objCase.OwnerId     = checkUsers.get(objCase.OwnerId);
            objCase.PropietarioTemporal__c = false;
      }
      update lstCases;
      
    }
        
  }
  
   // Cabiar el estado del semaforo en el caso.
  // -----------------------------------------------------------------------------------------------------------
  public void setEstadoSemaforoXCaso(Case objCaso){  
        
    //obtener el color del semaforo correspondiente 
    semaforo = getEstadoSemaforoXCaso(objCaso);     
    
    //asignar el color correspondiente al semaforo
    if(semaforo!=null){
      system.debug('@@-Color del Semaforo Actual ->>-->>'+objCaso.estadoSemaforo__c); 
      objCaso.estadoSemaforo__c = semaforo;                  
      system.debug('@@--Color asignado al semaforo -@@-->'+objCaso.estadoSemaforo__c);
    }                  
  }  
   
  //enviar Email al responsable segun el cambio de color en el semaforo
  // -----------------------------------------------------------------------------------------------------------
  //public void envioEMail(String IdUsuario, String semaforo, Case objCaso) {
  public void envioEMail(String correoRemitente,String nombreRemitante, String IdUsuario,String semaforo, Case objCaso) {
  	system.debug('IdUsuario-->'+IdUsuario + 'casp-->'+objCaso.Casenumber);
  	
  	if(Limits.getEmailInvocations() <= Limits.getLimitEmailInvocations()){    
	    User respon = [SELECT Id,Email,FirstName FROM User WHERE id=:IdUsuario];  
	    if(IdUsuario!=null && mapUsuarios.get(IdUsuario).Email!=null && mapUsuarios.get(IdUsuario).FirstName!=null){
	      String correo = mapUsuarios.get(IdUsuario).Email; 
	      String nombre = mapUsuarios.get(IdUsuario).FirstName;
	     // String correo = correoRemitente;
	      //String nombre = nombreRemitante;
	            
	      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();      
	      String[] toAddresses = new String[] {correo};
	         mail.setToAddresses(toAddresses);
	      mail.setUseSignature( false );
	      mail.setSaveAsActivity( false );      
	      mail.setSubject(Label.Bbc_Asunto+' '+nombre);
	         mail.setPlainTextBody(Label.Bbc_Saludo+' '+nombre + '. ' +Label.Bbc_Body1+' ' +objCaso.CaseNumber +
	                      + '. ' +Label.Bbc_Body2+' ' + semaforo + '. ' + Label.Bbc_Body3);        
	
	
	       List<OrgWideEmailAddress> lstOrgWideEmailId = [Select id,Address from OrgWideEmailAddress where Address=: correoRemitente];
		   if(lstOrgWideEmailId.size() != 0 )
		   {
		   	 if(lstOrgWideEmailId[0].Address != '' && lstOrgWideEmailId[0].Address != null){
		   		 System.debug('@@@ id correo organizacion ---->'+lstOrgWideEmailId[0].id); 		   	 
			 	mail.setOrgWideEmailAddressId(lstOrgWideEmailId[0].id); 
		   	}
		   } 
	                      
	      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
	    }
	  
	  }
  }

  
}