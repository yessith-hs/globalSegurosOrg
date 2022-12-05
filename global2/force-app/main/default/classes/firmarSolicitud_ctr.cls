/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Sergio Andres Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Contiene la logica para Firmar Oportunidades.
- controlador para la pagina firmarSolicitud_pag.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha Autor Descripción
-------------------------------------------------------------------------------------------------------
1.0 08/05/2014 Sergio Andres Ortiz Creación de la clase. 

*******************************************************************************************************************/

public with sharing class firmarSolicitud_ctr { 
    //definicion de variables publicas  
    public Map<String, String> mapParameters;
    public String  IdOportunidad {get; set;}
    public String  interfaceFirma;
    public String  strEtapa;
    public boolean exitoso;
    public String  strIdOpp {get; set;}
    public String  strTomador {get; set;}
    public String  strBeneficiario {get; set;}
    public String  strCampana {get; set;}
    public String  strNumOportunidad {get; set;}
    public String strCodOperacion {get; set;}
    public Integer intCodSucursal {get; set;}
    public Integer intTipDocumento {get; set;}
    public Integer intNumSolicitud {get; set;}
    public String  strNumDocumento {get; set;}
    public String  strTipDocumento {get; set;}
    public String  strNombreBeneficiario {get; set;}
    public Integer intCodRamo {get; set;}
    public Opportunity objOportunidad {get; set;}
    ServiciosOperativosGlobal_WS_cls.WsSalesForceSoap obj;
    
    public firmarSolicitud_ctr(ApexPages.StandardController inController) {  
          
        
        objOportunidad = (Opportunity)  inController.getRecord();               
        String idOportunidad = objOportunidad.Id;
        system.debug('@@-idOportunidad-1->'+idOportunidad);
        list<Opportunity> lstOpp = [select Id,AccountId, BeneficiarioAsegurado__c, StageName,CampaignId,IdentificadorOportunidad__c 
                                     from Opportunity where id=:objOportunidad.Id];
        if(lstOpp!= null){
            objOportunidad= lstOpp.get(0);
            strIdOpp                    = objOportunidad.Id;        
            strTomador                  = objOportunidad.AccountId;
            strBeneficiario             = objOportunidad.BeneficiarioAsegurado__c;      
            strEtapa                    = objOportunidad.StageName;
            strCampana                  = objOportunidad.CampaignId;
            strNumOportunidad           = objOportunidad.IdentificadorOportunidad__c;
            IdOportunidad               = objOportunidad.Id;
        }
        
        system.debug('@@-idOportunidad-2->'+idOportunidad);
        system.debug('@@-def_Opportunity_id->'+strIdOpp);
        system.debug('@@-def__strTomador->'+strTomador);
        system.debug('@@-def_BeneficiarioAsegurado->'+strBeneficiario);     
        system.debug('@@-def_estado->'+strEtapa);
        system.debug('@@-def_campana->'+strCampana);
        system.debug('@@-strNumOportunidad->'+strNumOportunidad);
        String doc;
    }
                                            


    //metodo para obtener el tipo de documento
    public PageReference getTipoDocumento()
    {
        //busqueda del tipo de documento como entero.
        list<Parametros__c> listParamDoc = [SELECT Codigo__c,Name FROM Parametros__c 
                                            WHERE Objeto__c = 'Account' and Campo__c= 'TipoDocumento__c' and Name =:strTipDocumento];

        if (listParamDoc.SIZE() == 0){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'El tipo de documento del tomador es invalido'));
            return null;
        }
                                                    
        system.debug('c'+listParamDoc);             
        intTipDocumento = integer.valueOf(listParamDoc.get(0).Codigo__c);
        return null;
    }   
    
    //metodo que cambia la Etapa de la oportunidad a Solicitud Firmada o indica los cambios en la Etapa.
    public Boolean getRamo(){
        Boolean bolSenal=true;
        //busqueda del codigo Ramo.
        list<OpportunityLineItem> lstOpportunityLineItem;
        lstOpportunityLineItem = [SELECT PricebookEntry.Product2.CodigoRamo__c  FROM OpportunityLineItem  WHERE OpportunityId =: strIdOpp];
        system.debug('lstOpportunityLineItem-->'+lstOpportunityLineItem);
        //system.debug('lstOpportunityLineItem.get(0).PricebookEntry.Product2.CodigoRamo__c-->'+lstOpportunityLineItem.get(0).PricebookEntry.Product2.CodigoRamo__c);
        
        if(lstOpportunityLineItem.size() > 0 ){
            
            if(lstOpportunityLineItem.get(0).PricebookEntry != null){
                
                if(lstOpportunityLineItem.get(0).PricebookEntry.Product2!=null){
                    
                    if (lstOpportunityLineItem.get(0).PricebookEntry.Product2.CodigoRamo__c!=null){
                         intCodRamo = integer.valueOf(lstOpportunityLineItem.get(0).PricebookEntry.Product2.CodigoRamo__c);
                    }else{
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'El producto asociado no tiene código de ramo'));
                        bolSenal=false;
                    }
                }else{
                    Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'La Oportunidad no tiene producto asociado'));
                    bolSenal=false;
                }           
            }else{
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'La Oportunidad no tiene un Producto Asociado'));
                bolSenal=false;
            } 
        }else{
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'La Oportunidad no tiene un Producto Asociado'));
                bolSenal=false;
        }   

        return bolSenal;    
    }

  
    //metodo que cambia la Etapa de la oportunidad a Solicitud Firmada o indica los cambios en la Etapa.
    public PageReference actualizar()
    {
        //busqueda del Numero de documento y del tipo de documento.
        list<Account> lstCuentaTomador;
        lstCuentaTomador = [SELECT Id,NumeroDocumento__c,TipoDocumento__c  FROM Account     WHERE id    = :strTomador];
        system.debug('@@-lstCuentaTomador->'+lstCuentaTomador);
        system.debug('@@-lstCuentaTomador.get(0).TipoDocumento__c->'+lstCuentaTomador.get(0).TipoDocumento__c);
        strNumDocumento=lstCuentaTomador.get(0).NumeroDocumento__c;
        strTipDocumento=lstCuentaTomador.get(0).TipoDocumento__c;

        //busqueda del Nombre del beneficiario.
        list<Account> lstCuentaBeneficiario;
        if((strBeneficiario == Null)||(strBeneficiario == '')){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'El Beneficiario es requerido!'));
        }else{
	        lstCuentaBeneficiario = [SELECT Id,Name  FROM Account   WHERE id    = :strBeneficiario];
	        if(lstCuentaBeneficiario!=null){
	            system.debug('@@-lstCuentaBeneficiario->'+lstCuentaBeneficiario);
	            system.debug('@@-lstCuentaBeneficiario.get(0).Nombre->'+lstCuentaBeneficiario.get(0).Name);
	            strNombreBeneficiario=lstCuentaBeneficiario.get(0).Name;
	        }
        }
        
        
        // buscar el ramo
        // ---------------
        exitoso = getRamo();
        if(exitoso){
            system.debug('@@-intCodRamo'+intCodRamo);
            //metodo para obtener el tipo de documento
            getTipoDocumento();
        
            //busqueda del codigo de Operacion en la configuracion personalizada
            CodigoOperacion__c cod_operacion = CodigoOperacion__c.getInstance('CodigoOperacion');
            system.debug('@@-CodigoOperacion__c->'+cod_operacion.CodigoOperacion__c);
            strCodOperacion = cod_operacion.CodigoOperacion__c;
         
            String tokenTrabajo;
            //obtener el token
            if(!test.isRunningTest()) {                 
                ObtenerTokenGlobal_cls token = new ObtenerTokenGlobal_cls();
                tokenTrabajo = token.getToken();
            }   
            system.debug('@@-tokenTrabajo->'+tokenTrabajo);
                 
            //asignar el token 
            String nombreUsuario = userinfo.getUserName();
            
            //asignar el stud para el servicio
            Conexion_cls conexion = new Conexion_cls();
            if(!test.isRunningTest()) 
            {
                obj = conexion.getConexion_cls(tokenTrabajo);
            }    
            system.debug('strCodOperacion--@->'+strCodOperacion);
            system.debug('strNumOportunidad--@->'+strNumOportunidad);
            system.debug('intTipDocumento--@->'+intTipDocumento);
            system.debug('strNumDocumento--@->'+strNumDocumento);
            system.debug('intCodRamo--@->'+intCodRamo);
            system.debug('strNombreBeneficiario--@->'+strNombreBeneficiario);
            system.debug('nombreUsuario--@->'+nombreUsuario);
            system.debug('intCodSucursal--@->'+intCodSucursal);
            system.debug('intNumSolicitud--@->'+intNumSolicitud);
        
            if(!test.isRunningTest()) 
            { 
                if (intCodRamo==null){
                    Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'El producto asociado no tiene código de ramo'));
                }else{
                    interfaceFirma=conexion.GrabaOportunidad(strCodOperacion,strNumOportunidad,intTipDocumento,strNumDocumento,intCodRamo,strNombreBeneficiario,nombreUsuario,0);
                }
            }
            system.debug('@@-*******interfaceFirma*********-> '+interfaceFirma);    
            if(interfaceFirma == 'Ok'){
                exitoso = true;
            }else{
                exitoso = false;
            } 
        
            system.debug('@@-Exitoso->'+exitoso);   
   
    
            //verificar campos
            if((strIdOpp == Null)||(strIdOpp == '')){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'El ID de la Oportunidad es requerido!'));
            }
            else if((strTomador == Null)||(strTomador == '')){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'El Tomador es requerido!'));
            }
            else if((strBeneficiario == Null)||(strBeneficiario == '')){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'El Beneficiario es requerido!'));
            }
            else if((strCampana == Null)||(strCampana == '')){
                //Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'El ID de la Campaña es requerido!'));
            }
            else if((strNumOportunidad == Null)||(strNumOportunidad == '')){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'El Numero de la Oportunidad es requerido!'));
            }
            else if((strCodOperacion == Null)||(strCodOperacion == '')){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'El Codigo de Operacion es requerido!'));
            }
            else if(intTipDocumento == Null){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'El Tipo de Documento es requerido!'));
            }
            else if((strNumDocumento == Null)||(strNumDocumento == '')){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'El Numero de Documento es requerido!'));
            }
             else if(intCodRamo == Null){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'El Codigo Ramo es requerido!'));
            }
            else if(intNumSolicitud == Null){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'El Numero de Solicitud es requerido!'));
            }
            else if(intCodSucursal == Null){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, '!El Codigo de Sucursal es requerido'));
            }
            
        }
        
        if(exitoso == true)
        {
            system.debug('@@-strEtapa->'+strEtapa);
            if(strEtapa != Label.Bbc_SolicitudFirmada) 
            {
                objOportunidad.StageName = Label.Bbc_SolicitudFirmada;
                update objOportunidad;
                system.debug('@@-objOportunidad->'+objOportunidad); 
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, Label.Bbc_Firmada));
            }
            else if(strEtapa == 'Firma de solicitud')
            {
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, Label.Bbc_YaFirmada));
            }
            else 
            {
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, Label.Bbc_NoCambio));
            }
        }
        /*else{ 
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, Label.Bbc_mError +' \n'+interfaceFirma));
        }*/
                    
        return null;
    }
    
    //metodo para refrescar la pagina y mostrar el checkbox del estado de la campaña activo
    public PageReference refrescar()
    {
        PageReference pr = new PageReference('/'+objOportunidad.Id);
        pr.setRedirect(true);
        system.debug('@@Ingreso a Refrescar->'+objOportunidad.Id+'---pr--'+pr);
        return pr;      
    }   
        
}