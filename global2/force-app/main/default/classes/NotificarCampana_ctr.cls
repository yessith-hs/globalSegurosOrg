/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Sergio Andres Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Contiene la logica para activar/inactivar campañas.
- controlador para la pagina NotificarCampana_pag

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha Autor Descripción
-------------------------------------------------------------------------------------------------------
1.0 06/05/2014 Sergio Andres Ortiz Creación de la clase. 
2.0 09/05/2014 Luis Peñaranda Modificacion metodos.
3.0 29/07/2021 Christian Tovar Eliminación validación cuenta padre.
*******************************************************************************************************************/

public with sharing class NotificarCampana_ctr {
    //definicion de varialbes publicas	
    public Map<String, String> mapParameters;
    public String  desdeActivar;
    public String  IdCampana {get; set;}
    public Integer intActiva;
    public String  interfaceCamapana;	
    public boolean exitoso;
    public String tokenTrabajo;
    
    public NotificarCampana_ctr(ApexPages.StandardController inController)
    {      	
        //variablaes de trabajo  	  	
        ServiciosOperativosGlobal_WS_cls.WsSalesForceSoap obj;
        mapParameters 				= new map<String, String>();
        mapParameters 				= ApexPages.currentPage().getParameters();
        String strId		  		= mapParameters.get('def_Campaign_id');		
        String strDescripcion	  	= mapParameters.get('def__descrip');
        Integer intCodigoCampana	= integer.valueOf(mapParameters.get('def_CodigoCampana'));
        intActiva					= integer.valueof(mapParameters.get('def_isActiva'));
        String  strCiudad			= mapParameters.get('def_ciudad');
        String  nombreCamp			= mapParameters.get('Nombre');
        //Integer intRamo				= integer.valueOf(mapParameters.get('def_codRam'));
        desdeActivar				= mapParameters.get('def_Activar');
        IdCampana = strId;
        list<Campaign> listnewCampana_y = [select RecordTypeId,ParentId,Name  from Campaign where id=: IdCampana];
        
        system.debug('Prueba final: ' + listnewCampana_y.get(0).Name + ' ' + listnewCampana_y.get(0).ParentId);
        system.debug('@@-Variables recibidas por la URL -strId->'+strId);
        system.debug('@@-Variables recibidas por la URL -strDescripcion->'+strDescripcion);
        system.debug('@@-Variables recibidas por la URL -intCodigoCampana->'+intCodigoCampana);
        system.debug('@@-Variables recibidas por la URL -intActiva->'+intActiva);
        system.debug('@@-Variables recibidas por la URL -strCiudad->'+strCiudad);
        system.debug('@@-Variables recibidas por la URL -desdeActivar->'+desdeActivar);
        
        if (test.isRunningTest()){	    	
            interfaceCamapana 	=  'Ok';       
        }
        else{
            if( listnewCampana_y.get(0).ParentId != null){
                //obtener el token  
                ObtenerTokenGlobal_cls token = new ObtenerTokenGlobal_cls();
                tokenTrabajo = token.getToken();	
                system.debug('@@-tokenTrabajo->'+tokenTrabajo);	
                
                //asignar el stud para el servicio
                Conexion_cls conexion = new Conexion_cls();
                obj = conexion.getConexion_cls(tokenTrabajo);
                
                if((desdeActivar == 'Si') && (intActiva == 0)) {
                    interfaceCamapana=conexion.GrabaCampania(nombreCamp, intCodigoCampana, true, strCiudad,0);
                }else{
                    interfaceCamapana=conexion.GrabaCampania(nombreCamp, intCodigoCampana, false, strCiudad,0);
                }
            }
        }
        system.debug('@@-cadena-> '+interfaceCamapana);	
        if(interfaceCamapana == 'Ok'){
            exitoso = true;
        }else{
            exitoso = false;
        } 
        system.debug('@@-Exitoso->'+exitoso);	
    }												
    
    //metodo que activa o inactiva el Checkbox que indica si la campaña esta activa
    public PageReference actualizar()
    {
        Campaign newCampana = new Campaign(Id=IdCampana);
        list<Campaign> listnewCampana_y = [select RecordTypeId,ParentId  from Campaign where id=: IdCampana];
        if(exitoso == true){
            system.debug('@@-desdeActivar->'+desdeActivar);
            system.debug('@@-intActiva->'+intActiva);       
            system.debug('@@-newCampana_y->'+listnewCampana_y);	
            system.debug('@@-Label.Gbc_TipoRegCampanaAlianza->'+Label.Gbc_TipoRegCampanaAlianza);			
            
            if(listnewCampana_y!= null ){
                System.debug('Parent Id ' + listnewCampana_y.get(0).ParentId);
                if( listnewCampana_y.get(0).ParentId != null){
                    Campaign newCampana_y = listnewCampana_y.get(0);
                    if (test.isRunningTest()){	    	
                        newCampana_y.RecordTypeId = Label.Gbc_TipoRegCampanaAlianza;
                    }
                    // Pasar de Activa a Inactiva
                    // ----------------------------------------------
                    if((desdeActivar == 'No') && (intActiva == 1)) {
                        newCampana.IsActive = false;
                        update newCampana;
                        system.debug('@@-newCampana->'+newCampana);	
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, Label.Gbc_Inactiva));
                    }
                    else if((desdeActivar == 'No') && (intActiva == 0)){
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, Label.Gbc_yaInactiva));
                    }  
                    // Pasar de Inactiva a Activa
                    // ----------------------------------------------			
                    else if((desdeActivar == 'Si') && (intActiva == 0)){
                        newCampana.IsActive = true;
                        update newCampana;
                        system.debug('@@-newCampana->'+newCampana);	
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, Label.Gbc_Activa));		
                    }
                    else if((desdeActivar == 'Si') && (intActiva == 1)){
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, Label.Gbc_yaActiva));
                    }
                }
                else {
                    Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'La campaña no es Campaña Hija, No puede ejecutarse la acción'));
                }
            }
        }
        else {
            if( listnewCampana_y.get(0).ParentId != null) {
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, Label.Gbc_NotificacionError+'\n'+interfaceCamapana));
            }
            else {
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'La campaña no es Campaña Hija, No puede ejecutarse la acción'));
            }
            
        }
        return null;
    }
    
    //metodo para refrescar la pagina y mostrar el checkbox del estado de la campaña activo
    public PageReference refrescar()
    {
        PageReference pr = new PageReference('/'+IdCampana);
        pr.setRedirect(true);
        system.debug('@@Ingreso a Refrescar->'+IdCampana+'---pr--'+pr);
        return pr;		
    }
    
    // Metodo futuro para noificar la campaña en la creación
    // -------------------------------------------------------
    @Future(callout=true)
    public static void notificarCampana(String idCampana)
    {      	
        boolean exitoso;
        String tokenTrabajo;
        String mensajeRespuesta;
        list<Campaign> listnewCampana_y = [select id,RecordTypeId,Description,CodigoCampana__c,Ciudad__c,Ciudad__r.Name,ParentId  from Campaign where id=: IdCampana];
        Campaign objCampana = listnewCampana_y.get(0);
        system.debug('@@-objCampana->'+objCampana);
        //variablaes de trabajo  	  	
        String strId		  		= objCampana.id;
        String strDescripcion	  	= objCampana.Description;
        Integer intCodigoCampana	= Integer.ValueOf(objCampana.CodigoCampana__c);
        String  strCiudad			= objCampana.Ciudad__r.Name;
        
        system.debug('@@-Variables recibidas por la URL -strId->'+strId);
        system.debug('@@-Variables recibidas por la URL -strDescripcion->'+strDescripcion);
        system.debug('@@-Variables recibidas por la URL -intCodigoCampana->'+intCodigoCampana);
        system.debug('@@-Variables recibidas por la URL -strCiudad->'+strCiudad);
        
        if (test.isRunningTest()){
            mensajeRespuesta 	=  'Ok';       
        }
        else{    	
            if(objCampana.ParentId != null){
                //obtener el token 			
                ObtenerTokenGlobal_cls token = new ObtenerTokenGlobal_cls();
                tokenTrabajo = token.getToken();	
                system.debug('@@-tokenTrabajo->'+tokenTrabajo);		 
                //asignar el token 
                ServiciosOperativosGlobal_WS_cls.WsSalesForceSoap obj = new ServiciosOperativosGlobal_WS_cls.WsSalesForceSoap();
                obj.set_token(tokenTrabajo); 
                
                mensajeRespuesta=obj.GrabaCampania(strDescripcion, intCodigoCampana, true, strCiudad, '');
                system.debug('@@-cadena-> '+mensajeRespuesta);	
            }
        }
        if(mensajeRespuesta == 'Ok'){
            exitoso = true;
        }else{
            exitoso = false;
        } 
        system.debug('@@-interfaceCamapana->'+mensajeRespuesta);
        system.debug('@@-Exitoso->'+exitoso);	
    }
}