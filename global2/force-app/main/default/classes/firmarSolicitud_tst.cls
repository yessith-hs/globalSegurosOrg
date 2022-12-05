/**
* Avanxo Colombia
* @author           CAVC                    href:cvillalba@avanxo.com   
* Proyect:          Global Seguros
* Description:      test Class
*
* Changes (Version)
* -------------------------------------
*           No.     Fecha           Autor                   Descripción
*           -----   ----------      --------------------    ---------------
* @version   1.0    2014-07-09      CAVC            esta clase de test llama realiza la cobertura de las siguientes clases:
                                                    firmarSolicitud_ctr
* 			 2.0	2017-02-08		Katherine Moreno		 Modificacion
************************************************************************************************************/
@isTest(SeeAllData=true)
private class firmarSolicitud_tst 
{
        Account objCuentaTst                                                = new Account();
        Opportunity objOportunidadTst                                       = new Opportunity();
        OpportunityLineItem objLineaOportunidadTst                          = new OpportunityLineItem();
        Product2 objProducto                                                = new Product2();
        PricebookEntry objListaPrecios                                      = new PricebookEntry();
        Pricebook2 objPrecios2                                              = new Pricebook2();
        Parametros__c objParametros                                         = new Parametros__c();
    
    public void createData()
    {
        string strtiporegistro = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Natural').getRecordTypeId();
        System.debug('@@strtiporegistro-->' + strtiporegistro);
        
        //Cuenta Persona Natural
        objCuentaTst.LastName                                               = 'Ramirez';
        objCuentaTst.TipoDocumento__c                                       = 'CEDULA DE CIUDADANIA';
        objCuentaTst.NumeroDocumento__c                                     = '1140819986123';
        objCuentaTst.RecordTypeId                                           = strtiporegistro;
        objCuentaTst.PersonBirthdate                                        = System.now().date();
        insert objCuentaTst;
        
        /*creando oportunidad*/
        objOportunidadTst.Name                                              = 'Oportunidad Prueba';
        objOportunidadTst.AccountId                                         = objCuentaTst.Id;
        objOportunidadTst.CloseDate                                         = System.now().date();
        objOportunidadTst.StageName                                         = 'Firma de solicitud';
        objOportunidadTst.BeneficiarioAsegurado__c                          = objCuentaTst.Id;
        insert objOportunidadTst;
        
        Parametros__c objParametros                                         = new Parametros__c();
        objParametros.Campo__c                                              = 'TipoDocumento__c';
        objParametros.Objeto__c                                             = 'Account';
        objParametros.Name                                                  = 'CEDULA DE CIUDADANIA';
        objParametros.Codigo__c                                             = '1234567';
        insert objParametros;
        
        /*creando el producto*/
        objProducto.Name                                                    = 'Varios';
        objProducto.IdentificadorProducto__c                                = 'abc12345';
        objProducto.Ramo__c                                                 = 'Seguro Educativo';
        objProducto.Compania__c                                             = 'Nueva Empresa';
        objProducto.Description                                             = 'Seguro educativo para compañia Nueva Empresa';
        objProducto.CodigoRamo__c                                           = '69';
        insert objProducto;
        
        /*consultando el Price Standar*/
        Pricebook2 standard                                                 = [Select Id, Name, IsActive From Pricebook2 where isStandard = true LIMIT 1];
        
        /*creando lista de precios*/
        objListaPrecios.UnitPrice                                           = 20000;
        objListaPrecios.UseStandardPrice                                    = false;
        objListaPrecios.IsActive                                            = true;
        objListaPrecios.Pricebook2Id                                        = standard.id;
        objListaPrecios.Product2Id                                          = objProducto.Id;
        insert objListaPrecios;
        
        /*creando linea portunidad*/
        objLineaOportunidadTst.UnitPrice                                    = 10000;
        objLineaOportunidadTst.PricebookEntryId                             = objListaPrecios.Id;
        objLineaOportunidadTst.OpportunityId                                = objOportunidadTst.Id;
        objLineaOportunidadTst.Quantity                                     = 2.0;
        insert objLineaOportunidadTst;

    }
    static testMethod void myUnitTest() 
    {
        
        /*instanciando la clase para acceder a create data*/
        firmarSolicitud_tst firmarSolicitud_tst                             = new firmarSolicitud_tst();
        firmarSolicitud_tst.createData();
        
        ApexPages.StandardController standardController                     = new ApexPages.StandardController(firmarSolicitud_tst.objOportunidadTst);
        firmarSolicitud_ctr ObjFirmarSolicitud                              = new firmarSolicitud_ctr(standardController);
        ObjFirmarSolicitud.strTipDocumento                                  = firmarSolicitud_tst.objCuentaTst.TipoDocumento__c;
        ObjFirmarSolicitud.getTipoDocumento();
        ObjFirmarSolicitud.exitoso                                          = true;
        ObjFirmarSolicitud.refrescar();
    }
    static testMethod void myUnitTestParametrosSize() 
    {
        string strtiporegistro2                                             = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Natural').getRecordTypeId();
        
        /*Cuenta Persona Natural*/
        Account objCuenta                                                   = new Account();
        objCuenta.LastName                                                  = 'Ramirez';
        objCuenta.TipoDocumento__c                                          = '';
        objCuenta.NumeroDocumento__c                                        = '1234567890';
        objCuenta.RecordTypeId                                              = strtiporegistro2;
        objCuenta.PersonBirthdate                                           = System.now().date();
        insert objCuenta;
        
        Parametros__c objParametros                                         = new Parametros__c();
        objParametros.Campo__c                                              = 'TipoDocumento__c';
        objParametros.Objeto__c                                             = 'Account';
        objParametros.Name                                                  = 'CEDULA DE CIUDADANIA';
        objParametros.Codigo__c                                             = '1234567';
        insert objParametros;
        objParametros.clear();
        
        /*instanciando la clase para acceder a create data*/
        firmarSolicitud_tst firmarSolicitud_tst                             = new firmarSolicitud_tst();
        firmarSolicitud_tst.createData();
        
        ApexPages.StandardController standardController                     = new ApexPages.StandardController(firmarSolicitud_tst.objOportunidadTst);
        firmarSolicitud_ctr ObjFirmarSolicitud                              = new firmarSolicitud_ctr(standardController);
        ObjFirmarSolicitud.strTipDocumento                                  = objCuenta.TipoDocumento__c;
        ObjFirmarSolicitud.getTipoDocumento();
        ObjFirmarSolicitud.exitoso                                          = true;
        ObjFirmarSolicitud.getRamo();
        ObjFirmarSolicitud.actualizar();
        ObjFirmarSolicitud.refrescar();
    }
    
   static testMethod void strEtapaDifSolicitud() 
    {
        firmarSolicitud_tst firmarSolicitud_tst                             = new firmarSolicitud_tst();
        firmarSolicitud_tst.createData();
        string strtiporegistro2                                             = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Natural').getRecordTypeId();
        
        Opportunity OportunidadTst                                          = new Opportunity();
        //creando oportunidad
        OportunidadTst.Name                                                 = 'Oportunidad Prueba';
        OportunidadTst.AccountId                                            = firmarSolicitud_tst.objCuentaTst.Id;
        OportunidadTst.CloseDate                                            = System.now().date();
        OportunidadTst.StageName                                            = 'Negociación';
        OportunidadTst.BeneficiarioAsegurado__c                             = firmarSolicitud_tst.objCuentaTst.Id;
        OportunidadTst.IdentificadorOportunidad__c                          = '';
        insert OportunidadTst;
        system.debug('@@----> mi IdentificadorOportunidad__c'+ OportunidadTst);
        
        
        //creando linea portunidad
        OpportunityLineItem lineaoprtunidad                                 = new OpportunityLineItem();
        lineaoprtunidad.UnitPrice                                           = 10000;
        lineaoprtunidad.PricebookEntryId                                    = firmarSolicitud_tst.objListaPrecios.Id;
        lineaoprtunidad.OpportunityId                                       = OportunidadTst.Id;
        lineaoprtunidad.Quantity                                            = 2.0;
        insert lineaoprtunidad;
        
        //Cuenta Persona Natural
        Account objCuenta                                                   = new Account();
        objCuenta.LastName                                                  = 'Ramirez';
        objCuenta.TipoDocumento__c                                          = '';
        objCuenta.NumeroDocumento__c                                        = '1234567890';
        objCuenta.RecordTypeId                                              = strtiporegistro2;
        objCuenta.PersonBirthdate                                           = System.now().date();
        insert objCuenta;
        
        Parametros__c objParametros                                         = new Parametros__c();
        objParametros.Campo__c                                              = 'TipoDocumento__c';
        objParametros.Objeto__c                                             = 'Account';
        objParametros.Name                                                  = 'CEDULA DE CIUDADANIA';
        objParametros.Codigo__c                                             = '1234567';
        insert objParametros;
        objParametros.clear();
        
        //instanciando la clase para acceder a create data
        
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(OportunidadTst);
        firmarSolicitud_ctr ObjFirmarSolicitud          = new firmarSolicitud_ctr(standardController);
        ObjFirmarSolicitud.strTipDocumento = objCuenta.TipoDocumento__c;
        ObjFirmarSolicitud.getTipoDocumento();
        ObjFirmarSolicitud.interfaceFirma= 'Ok';
        ObjFirmarSolicitud.exitoso= true;
        ObjFirmarSolicitud.strEtapa='Negociación';
        ObjFirmarSolicitud.getRamo();
        ObjFirmarSolicitud.actualizar();
        ObjFirmarSolicitud.refrescar();
    }
    static testMethod void strEtapaSolicitud() 
    {
        firmarSolicitud_tst firmarSolicitud_tst                             = new firmarSolicitud_tst();
        firmarSolicitud_tst.createData();
        string strtiporegistro2                                             = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Natural').getRecordTypeId();
        
        Opportunity OportunidadTst                                          = new Opportunity();
        //creando oportunidad
        OportunidadTst.Name                                                 = 'Oportunidad Prueba';
        OportunidadTst.AccountId                                            = firmarSolicitud_tst.objCuentaTst.Id;
        OportunidadTst.CloseDate                                            = System.now().date();
        OportunidadTst.StageName                                            = 'Firma de solicitud';
        OportunidadTst.BeneficiarioAsegurado__c                             = firmarSolicitud_tst.objCuentaTst.Id;
        OportunidadTst.IdentificadorOportunidad__c                          = '';
        insert OportunidadTst;
        system.debug('@@----> mi IdentificadorOportunidad__c'+ OportunidadTst);
        
        
        //creando linea portunidad
        OpportunityLineItem lineaoprtunidad                                 = new OpportunityLineItem();
        lineaoprtunidad.UnitPrice                                           = 10000;
        lineaoprtunidad.PricebookEntryId                                    = firmarSolicitud_tst.objListaPrecios.Id;
        lineaoprtunidad.OpportunityId                                       = OportunidadTst.Id;
        lineaoprtunidad.Quantity                                            = 2.0;
        insert lineaoprtunidad;
        
        //Cuenta Persona Natural
        Account objCuenta                                                   = new Account();
        objCuenta.LastName                                                  = 'Ramirez';
        objCuenta.TipoDocumento__c                                          = '';
        objCuenta.NumeroDocumento__c                                        = '1234567890';
        objCuenta.RecordTypeId                                              = strtiporegistro2;
        objCuenta.PersonBirthdate                                           = System.now().date();
        insert objCuenta;
        
        Parametros__c objParametros                                         = new Parametros__c();
        objParametros.Campo__c                                              = 'TipoDocumento__c';
        objParametros.Objeto__c                                             = 'Account';
        objParametros.Name                                                  = 'CEDULA DE CIUDADANIA';
        objParametros.Codigo__c                                             = '1234567';
        insert objParametros;
        objParametros.clear();
        
        //instanciando la clase para acceder a create data
        
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(OportunidadTst);
        firmarSolicitud_ctr ObjFirmarSolicitud          = new firmarSolicitud_ctr(standardController);
        ObjFirmarSolicitud.strTipDocumento = objCuenta.TipoDocumento__c;
        ObjFirmarSolicitud.getTipoDocumento();
        ObjFirmarSolicitud.interfaceFirma= 'Ok';
        ObjFirmarSolicitud.exitoso= true;
        ObjFirmarSolicitud.strEtapa='Firma de solicitud';
        ObjFirmarSolicitud.getRamo();
        ObjFirmarSolicitud.actualizar();
        ObjFirmarSolicitud.refrescar();
    }
     static testMethod void strEtapaFalse() 
    {
        firmarSolicitud_tst firmarSolicitud_tst                             = new firmarSolicitud_tst();
        firmarSolicitud_tst.createData();
        string strtiporegistro2                                             = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Natural').getRecordTypeId();
        
        Opportunity OportunidadTst                                          = new Opportunity();
        //creando oportunidad
        OportunidadTst.Name                                                 = 'Oportunidad Prueba';
        OportunidadTst.AccountId                                            = firmarSolicitud_tst.objCuentaTst.Id;
        OportunidadTst.CloseDate                                            = System.now().date();
        OportunidadTst.StageName                                            = 'Firma de solicitud';
        OportunidadTst.BeneficiarioAsegurado__c                             = firmarSolicitud_tst.objCuentaTst.Id;
        OportunidadTst.IdentificadorOportunidad__c                          = '';
        insert OportunidadTst;
        system.debug('@@----> mi IdentificadorOportunidad__c'+ OportunidadTst);
        
        
        //creando linea portunidad
        OpportunityLineItem lineaoprtunidad                                 = new OpportunityLineItem();
        lineaoprtunidad.UnitPrice                                           = 10000;
        lineaoprtunidad.PricebookEntryId                                    = firmarSolicitud_tst.objListaPrecios.Id;
        lineaoprtunidad.OpportunityId                                       = OportunidadTst.Id;
        lineaoprtunidad.Quantity                                            = 2.0;
        insert lineaoprtunidad;
        
        //Cuenta Persona Natural
        Account objCuenta                                                   = new Account();
        objCuenta.LastName                                                  = 'Ramirez';
        objCuenta.TipoDocumento__c                                          = '';
        objCuenta.NumeroDocumento__c                                        = '1234567890';
        objCuenta.RecordTypeId                                              = strtiporegistro2;
        objCuenta.PersonBirthdate                                           = System.now().date();
        insert objCuenta;
        
        Parametros__c objParametros                                         = new Parametros__c();
        objParametros.Campo__c                                              = 'TipoDocumento__c';
        objParametros.Objeto__c                                             = 'Account';
        objParametros.Name                                                  = 'CEDULA DE CIUDADANIA';
        objParametros.Codigo__c                                             = '1234567';
        insert objParametros;
        objParametros.clear();
        
        //instanciando la clase para acceder a create data
        
        
        ApexPages.StandardController standardController                     = new ApexPages.StandardController(OportunidadTst);
        firmarSolicitud_ctr ObjFirmarSolicitud                              = new firmarSolicitud_ctr(standardController);
        ObjFirmarSolicitud.strTipDocumento                                  = objCuenta.TipoDocumento__c;
        ObjFirmarSolicitud.getTipoDocumento();
        ObjFirmarSolicitud.interfaceFirma                                   = 'Ok';
        ObjFirmarSolicitud.exitoso                                          = true;
        ObjFirmarSolicitud.intCodSucursal                                   = null;
        ObjFirmarSolicitud.intNumSolicitud                                  = null;
        ObjFirmarSolicitud.strIdOpp                                         = null;
        ObjFirmarSolicitud.strEtapa                                         ='Firma de solicitud';
        ObjFirmarSolicitud.getRamo();
        ObjFirmarSolicitud.actualizar();
        ObjFirmarSolicitud.refrescar();
    }
   
}