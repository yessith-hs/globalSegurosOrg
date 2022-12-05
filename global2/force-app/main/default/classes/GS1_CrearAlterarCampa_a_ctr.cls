/***************************************************************************************************************************
*** Desarrollado por:       Avanxo Colombia                                                                              ***
*** Autor:                  Cristian Mejia (CM)                                                                          ***
*** Proyecto:               Global                                                                                       ***
*** Descripcion:            Controlador que permite la creación de una campaña por medio de código, a los usuarios       ***
***                         con el perfil "Partner Community"                                                            ***
*** User history:                                                                                                        ***
*** Sprint:                                                                                                              ***
*** Release:                                                                                                             ***
***                                                                                                                      ***    
*** Cambios (Versiones)                                                                                                  ***
*** -------------------------------------                                                                                ***
***             No.     Fecha           Autor                   Descripción                                              ***    
***            -----    ----------      --------------------    ---------------                                          ***
*** @version    1.0     2014-11-13      Cristian Mejia (CM)      Class created                                           ***
***************************************************************************************************************************/

public with sharing class GS1_CrearAlterarCampa_a_ctr
{    
    public String nombreCampain {get;set;}
    public String codCampain {get;set;}
    public String compania {get;set;}
    public String descripcion {get;set;}
    public String strCual {get;set;}
    public String strCuentaMayor {get;set;}
    public String estado {get;set;}
    
    public String strproducto {get;set;}
    public String strproductoElegido {get;set;}

    public String strfuerzaVenta {get;set;}
    public String strfuerzaElegida {get;set;}

    public String tipo {get;set;}
    public String tipoElegido {get;set;}

    public date fechaini {get;set;}
    public date fechafin {get;set;}

    public boolean esActivo {get;set;}
    public boolean boolValidado {get;set;}
    public boolean ocultarCostoReal {get;set;}
    public boolean ocultarCostoMateriales {get;set;}

    public decimal intNumAsistentes {get;set;}
    public decimal intCostoPat {get;set;}
    public String strCostoPat {get;set;}
    public decimal intCostoReal {get;set;}
    public String strCostoReal {get;set;}
    public String strCostoMat {get;set;}
    public decimal intCostoMat {get;set;}
    public decimal intNumProsp {get;set;}
    public decimal intResp {get;set;}

    public Campaign objCampaign {get;set;}
    public Contact objContact {get;set;}
    public Opportunity objOpportunity {get;set;}

    public map<String, SelectOption> LeftOptionMap {get;set;}
    public map<String, SelectOption> RightOptionMap {get;set;}
    public map<String, SelectOption> LeftOptionMapProd {get;set;}
    public map<String, SelectOption> RightOptionMapProd {get;set;}
    public map<String, SelectOption> LeftOptionMapTipo {get;set;}
    public map<String, SelectOption> RightOptionMapTipo {get;set;}

    public list<SelectOption> lstFuerzaVentasCampaing {get;set;}
    public list<SelectOption> lstFuerzaElegida {get;set;}
    public list<SelectOption> lstproductosCampaing {set;get;}
    public list<SelectOption> lstproductoselegidos {set;get;}
    public list<SelectOption> lstTiposCampaing {get;set;}
    public list<SelectOption> lstTiposElegidos {get;set;}

    /* @Descripcion: Obtiene y guarda todas las opciones de la lista de seleccion del campo 'Estado' del objeto 'Campaña', 
    *  para luego mostrarlas en la visualforce
    */
    public list<SelectOption> lstEstadosCampaing 
    {
        get
        {
            list<SelectOption> lstEstados= new list<SelectOption>();

            Schema.DescribeFieldResult fieldResult = Campaign.Status.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

            for( Schema.PicklistEntry f : ple)
            {
                lstEstados.add(new SelectOption(f.getLabel(), f.getValue()));
            }

            return lstEstados;
        }
        set{} 
     }

    /* @Descripcion: Obtiene y guarda todas las opciones de la lista de seleccion del campo 'Compañía' del objeto 'Campaña', 
    *  para luego mostrarlas en la visualforce
    */
    public list<SelectOption> lstCompaniaCampaing 
    {
        get
        {
           list<SelectOption> lstCompania= new list<SelectOption>();
            
           Schema.DescribeFieldResult fieldResult = Campaign.Compania__c.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

           lstCompania.add(new SelectOption('', '--Ninguno--'));
           for( Schema.PicklistEntry f : ple)
           {
               lstCompania.add(new SelectOption(f.getLabel(), f.getValue()));
           }

           return lstCompania;
        }
        set{} 
    }

    /* @Descripcion: Obtiene y guarda todas las opciones de la lista de seleccion del campo 'Cuenta mayor' del objeto 'Campaña', 
    *  para luego mostrarlas en la visualforce
    */
    public list<SelectOption> lstCuentaMayorCampaing 
    {
        get
        {
           list<SelectOption> lstCuenta= new list<SelectOption>();

           Schema.DescribeFieldResult fieldResult = Campaign.CuentaMayor__c.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

           lstCuenta.add(new SelectOption('', '--Ninguno--'));
           for( Schema.PicklistEntry f : ple)
           {
               lstCuenta.add(new SelectOption(f.getLabel(), f.getValue()));
           }

           return lstCuenta;
        }
        set{} 
    }
    
    /* @Descripcion: Metodo que llena la lista de opciones que se muestran en las cajas del campo Fuerza de ventas de la visualForce, 
    *  tanto en la caja de Disponibles, como en la caja de seleccionados
    */
    public void setFuerzaVentas()
    {
        lstFuerzaElegida=new list<SelectOption>();         
        for(String option : RightOptionMap.keyset())
        {
            if(option!='')
            {
                option=option.replace('[','').replace(']','');
                System.debug('===========OPTION============'+option);
                lstFuerzaElegida.add(new SelectOption(option,option));            
            }
        }
          lstFuerzaVentasCampaing=new list<SelectOption>();

        for(String option : LeftOptionMap.keySet())
        {
            if(option!='')
            {
                option=option.replace('[','').replace(']','');
                System.debug('===========OPTION============'+option);
                lstFuerzaVentasCampaing.add(new SelectOption(option,option));
            }
            
        }
    }

     /* @Descripcion: Metodo que llena la lista de opciones que se muestran en las cajas del campo Productos de la visualForce, 
    *  tanto en la caja de Disponibles, como en la caja de seleccionados
    */
    public void setProductos()
    {
        lstproductoselegidos=new list<SelectOption>();         
        for(String option : RightOptionMapProd.keyset())
        {
            if(option!='')
            {
                option=option.replace('[','').replace(']','');
                System.debug('===========OPTION============'+option);
                lstproductoselegidos.add(new SelectOption(option,option));            
            }
        }
        lstproductosCampaing=new list<SelectOption>();

        for(String option : LeftOptionMapProd.keySet())
        {
            if(option!='')
            {
                option=option.replace('[','').replace(']','');
                System.debug('===========OPTION============'+option);
                lstproductosCampaing.add(new SelectOption(option,option));
            }
            
        }
    }

     /* @Descripcion: Metodo que llena la lista de opciones que se muestran en las cajas del campo Tipo de la visualForce, 
    *  tanto en la caja de Disponibles, como en la caja de seleccionados
    */
    public void setTipos()
    {
        lstTiposElegidos=new list<SelectOption>();         
        for(String option : RightOptionMapTipo.keyset())
        {
            if(option!='')
            {
                option=option.replace('[','').replace(']','');
                System.debug('===========OPTION============'+option);
                lstTiposElegidos.add(new SelectOption(option,option));            
            }
        }
        lstTiposCampaing=new list<SelectOption>();

        for(String option : LeftOptionMapTipo.keySet())
        {
            if(option!='')
            {
                option=option.replace('[','').replace(']','');
                System.debug('===========OPTION============'+option);
                lstTiposCampaing.add(new SelectOption(option,option));
            }
            
        }
    }
   
    /**
    *    Constructor
    */
    public GS1_CrearAlterarCampa_a_ctr()
    {
        objContact=new Contact();
        objOpportunity = new Opportunity();
        objCampaign= new Campaign();
		strCostoMat='0';
		strCostoReal='0';
		strCostoPat='0';
        String campanaid=(ApexPages.currentPage().getParameters().get('Id')!=null)?ApexPages.currentPage().getParameters().get('Id'):'';
        //System.debug('=====CAMPAÑAID===='+campanaid);

        lstFuerzaVentasCampaing= new list<SelectOption>();
        lstFuerzaElegida=new list<SelectOption>();
        lstproductosCampaing= new list<SelectOption>();
        lstproductoselegidos= new list<SelectOption>();
        lstTiposCampaing= new list<SelectOption>();
        lstTiposElegidos= new list<SelectOption>();

        LeftOptionMap = new map<String, SelectOption>();
        RightOptionMap = new map<String, SelectOption>();
        LeftOptionMapProd = new map<String, SelectOption>();
        RightOptionMapProd = new map<String, SelectOption>();
        LeftOptionMapTipo = new map<String, SelectOption>();
        RightOptionMapTipo = new map<String, SelectOption>();

        Schema.DescribeFieldResult fieldResult = Campaign.FuerzaVentas__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        Schema.DescribeFieldResult fieldResult1 = Campaign.Producto__c.getDescribe();
        List<Schema.PicklistEntry> ple1 = fieldResult1.getPicklistValues();

        Schema.DescribeFieldResult fieldResult2 = Campaign.Tipo__c.getDescribe();
        List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
        
        if(campanaid != NULL && campanaid != '')
        {
            mostrarDatos(campanaid);
            ocultarCostoReal = true;
            ocultarCostoMateriales = true;            

            /*************** LISTAS Fuerza de venta ******************/
            for( Schema.PicklistEntry f : ple)
            {
                if(objCampaign.FuerzaVentas__c!=null)
                {                    
                    if(f.getLabel()!='' && !objCampaign.FuerzaVentas__c.contains(f.getLabel()))
                    {
                        lstFuerzaVentasCampaing.add(new SelectOption(f.getLabel(), f.getValue()));
                        LeftOptionMap.put(f.getLabel(), new SelectOption(f.getLabel(),f.getValue()));
                    }
                }
                else
                {
                    lstFuerzaVentasCampaing.add(new SelectOption(f.getLabel(), f.getValue()));
                    LeftOptionMap.put(f.getLabel(), new SelectOption(f.getLabel(),f.getValue()));
                }
            }
            
            String strFuerzaVentas= objCampaign.FuerzaVentas__c;
            if(strFuerzaVentas!=null)
            {                
                for(String option : strFuerzaVentas.split(';'))
                {
                    option=option.replace('[','').replace(']','');
                    System.debug('===========OPTION============'+option);
                    lstFuerzaElegida.add(new SelectOption(option,option));
                    RightOptionMap.put(option,new SelectOption(option,option));
                }
            }
            /**********************************************************/
            /******************* LISTAS Productos *********************/
            for( Schema.PicklistEntry f1 : ple1)
            {
                if(objCampaign.Producto__c!=null)
                {                    
                    if(f1.getLabel()!='' && !objCampaign.Producto__c.contains(f1.getLabel()))
                    {
                        lstproductosCampaing.add(new SelectOption(f1.getLabel(), f1.getValue()));
                        LeftOptionMapProd.put(f1.getLabel(), new SelectOption(f1.getLabel(),f1.getValue()));
                    }
                }
                else
                {
                    lstproductosCampaing.add(new SelectOption(f1.getLabel(), f1.getValue()));
                    LeftOptionMapProd.put(f1.getLabel(), new SelectOption(f1.getLabel(),f1.getValue()));
                }
            }
            
            String strProductos= objCampaign.Producto__c;
            if(strProductos!=null)
            {
                for(String option : strProductos.split(';'))
                {
                    option=option.replace('[','').replace(']','');
                    System.debug('===========OPTION============'+option);
                    lstproductoselegidos.add(new SelectOption(option,option));
                    RightOptionMapProd.put(option,new SelectOption(option,option));
                }
            }
            /**********************************************************/
            /*********************** LISTAS tipos *********************/
            for( Schema.PicklistEntry f2 : ple2)
            {
                if(objCampaign.Tipo__c!=null)
                {                    
                    if(f2.getLabel()!='' && !objCampaign.Tipo__c.contains(f2.getLabel()))
                    {
                        lstTiposCampaing.add(new SelectOption(f2.getLabel(), f2.getValue()));
                        LeftOptionMapTipo.put(f2.getLabel(), new SelectOption(f2.getLabel(),f2.getValue()));
                    }
                }
                else
                {
                    lstTiposCampaing.add(new SelectOption(f2.getLabel(), f2.getValue()));
                    LeftOptionMapTipo.put(f2.getLabel(), new SelectOption(f2.getLabel(),f2.getValue()));
                }
            }

            String strtipos= objCampaign.Tipo__c;
            if(strtipos!=null)
            {                
                for(String option : strtipos.split(';'))
                {
                    option=option.replace('[','').replace(']','');
                    System.debug('===========OPTION============'+option);
                    lstTiposElegidos.add(new SelectOption(option,option));
                    RightOptionMapTipo.put(option,new SelectOption(option,option));
                }
            }
            /**********************************************************/
        }
        else
        {
            estado = 'Planeada';
            ocultarCostoReal = true;
            ocultarCostoMateriales = true;
            for( Schema.PicklistEntry f : ple)
            {
                    lstFuerzaVentasCampaing.add(new SelectOption(f.getLabel(), f.getValue()));
                    LeftOptionMap.put(f.getLabel(), new SelectOption(f.getLabel(),f.getValue()));                
            }

            for( Schema.PicklistEntry f : ple1)
            {
                    lstproductosCampaing.add(new SelectOption(f.getLabel(), f.getValue()));
                    LeftOptionMapProd.put(f.getLabel(), new SelectOption(f.getLabel(),f.getValue()));                
            }

            for( Schema.PicklistEntry f : ple2)
            {
                    lstTiposCampaing.add(new SelectOption(f.getLabel(), f.getValue()));
                    LeftOptionMapTipo.put(f.getLabel(), new SelectOption(f.getLabel(),f.getValue()));                
            }
        } 
       
    }

    /* @Descripcion: Metodo que llena los campos de la visualForce, con los datos de la camapaña, para que esta pueda ser modificada
    */
    public void mostrarDatos(String idCampaign)
    {
        strfuerzaVenta='';
        
        objCampaign= [Select CodigoCampana__c,Compania__c,IsActive,Name,Ciudad__c,ParentId,Status,StartDate,EndDate,
                             CostoPatrocinio__c,Tipo__c,Cual__c,ValidadoJuridico__c,CuentaMayor__c,Description,ActualCost,
                             NProspectosEsperado__c,ExpectedResponse,Producto__c,FuerzaVentas__c,CostoMateriales__c,NumberSent
                      FROM Campaign WHERE id =: idCampaign];

        codCampain=objCampaign.CodigoCampana__c;
        compania=objCampaign.Compania__c;
        esActivo=objCampaign.IsActive;
        nombreCampain=objCampaign.Name;
        tipo=objCampaign.Tipo__c;
        strCual=objCampaign.Cual__c;
        boolValidado=objCampaign.ValidadoJuridico__c;
        strCuentaMayor=objCampaign.CuentaMayor__c;
        descripcion=objCampaign.Description;
        
        intNumAsistentes=objCampaign.NumberSent;
        intCostoPat=Double.valueOf(objCampaign.CostoPatrocinio__c);
        strCostoPat=String.valueOf(objCampaign.CostoPatrocinio__c);
        intNumProsp=objCampaign.NProspectosEsperado__c;
        intCostoMat=Double.valueOf(objCampaign.CostoMateriales__c);
        strCostoMat=String.valueOf(objCampaign.CostoMateriales__c);
        intResp=objCampaign.ExpectedResponse;
        intCostoReal=Double.valueOf(objCampaign.ActualCost);
        strCostoReal=String.valueOf(objCampaign.ActualCost);

        //strproducto=objCampaign.Producto__c;
        System.debug('===Producto Pagina==='+strproducto);
        strfuerzaVenta=objCampaign.FuerzaVentas__c;
        System.debug('===Fuerza de ventas Pagina==='+strfuerzaVenta);
        estado=objCampaign.Status;
        objContact.FechaVinculacion__c=objCampaign.StartDate;
        objContact.FechaDesvinculacion__c=objCampaign.EndDate;
        objContact.Ciudad__c=objCampaign.Ciudad__c;        
        objOpportunity.CampaignId=objCampaign.ParentId;
    }

    /* @Descripcion: Metodo que llena la lista de campos seleccionados en el campo Fuerza de venta de la visualForce, 
    *  para luego ingresarlos en la base de datos
    */
    public void asignarSeleccionados()
    {
        Integer intContador=0;
        Integer intLongitud=RightOptionMap.size()-1;   
        for (String strkeySet : RightOptionMap.keySet())
        {
            if(strkeySet !='')
            {
                strfuerzaElegida +=strkeySet;
                if(intContador < intLongitud)
                {
                    strfuerzaElegida +=';';
                }
            }
            intContador++;
        }
        strfuerzaElegida=strfuerzaElegida.replace('[','').replace(']','');
    }

    /* @Descripcion: Metodo que llena la lista de campos seleccionados en el campo Productos de la visualForce, 
    *  para luego ingresarlos en la base de datos
    */
    public void asignarSeleccionadosProd()
    {
        Integer intContador=0;
        Integer intLongitud=RightOptionMapProd.size()-1;   
        for (String strkeySet : RightOptionMapProd.keySet())
        {
            if(strkeySet !='')
            {
                strproductoElegido +=strkeySet;
                if(intContador < intLongitud)
                {
                    strproductoElegido +=';';
                }
            }
            intContador++;
        }
        strproductoElegido=strproductoElegido.replace('[','').replace(']','');
    }

    /* @Descripcion: Metodo que llena la lista de campos seleccionados en el campo Tipos de la visualForce, 
    *  para luego ingresarlos en la base de datos
    */
    public void asignarSeleccionadosTipo()
    {
        Integer intContador=0;
        Integer intLongitud=RightOptionMapTipo.size()-1;   
        for (String strkeySet : RightOptionMapTipo.keySet())
        {
            if(strkeySet !='')
            {
                tipoElegido +=strkeySet;
                if(intContador < intLongitud)
                {
                    tipoElegido +=';';
                }
            }
            intContador++;
        }
        tipoElegido=tipoElegido.replace('[','').replace(']','');
        System.debug('-----***TiposElegidos'+tipoElegido);
    }

    /* @Descripcion: Metodo que guarda y actualiza los datos ingresados en la VisualForce 
    */
    public PageReference Save() 
    {
        System.debug('ApexPages'+ApexPages.currentPage().getParameters());
        asignarSeleccionados();
        asignarSeleccionadosProd();
        asignarSeleccionadosTipo();
        System.debug('strfuerzaElegidaSave'+strfuerzaElegida);
        try 
        {
            objCampaign=new Campaign();

            objCampaign.CodigoCampana__c=codCampain;
            objCampaign.Compania__c=compania;
            objCampaign.IsActive=esActivo;
            objCampaign.Name=nombreCampain;
            objCampaign.Ciudad__c=objContact.Ciudad__c;
            objCampaign.ParentId=objOpportunity.CampaignId;
            objCampaign.Status=estado;
            objCampaign.StartDate=objContact.FechaVinculacion__c;
            objCampaign.EndDate=objContact.FechaDesvinculacion__c;
            objCampaign.Cual__c=strCual;
            objCampaign.ValidadoJuridico__c=boolValidado;
            objCampaign.CuentaMayor__c=strCuentaMayor;
            objCampaign.Description=descripcion;
            
            objCampaign.NumberSent=intNumAsistentes;
            if(strCostoPat=='' || strCostoPat==null) strCostoPat='0';
            objCampaign.CostoPatrocinio__c=Decimal.valueOf(strCostoPat);
            objCampaign.NProspectosEsperado__c=intNumProsp;
            if(strCostoMat=='' || strCostoMat==null) strCostoMat='0';
            objCampaign.CostoMateriales__c=Decimal.valueOf(strCostoMat);
            objCampaign.ExpectedResponse=intResp;
            if(strCostoReal=='' || strCostoReal==null) strCostoReal='0';
            objCampaign.ActualCost=Decimal.valueOf(strCostoReal);

            objCampaign.FuerzaVentas__c=strfuerzaElegida;
            objCampaign.Tipo__c=tipoElegido;
            objCampaign.Producto__c=strproductoElegido;

            objCampaign.ValidadoJuridico__c=false;

            //if(objCampaign.ParentId == '' || objCampaign.ParentId == null)
            //{
            //    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Falta seleccionar una campaña principal');//Same old drama 
            //    ApexPages.addMessage(myMsg);                
            //    return null;
            //}

            String idTipoRegistro=[SELECT Id FROM RecordType WHERE Name = 'Evento' AND SobjectType = 'Campaign' LIMIT 1].id;
            objCampaign.RecordTypeId=idTipoRegistro;

            System.debug('----------CAMPAÑA------------\n'+objCampaign);

            String campanaid=(ApexPages.currentPage().getParameters().get('Id')!=null)?ApexPages.currentPage().getParameters().get('Id'):'';
            if(campanaid != NULL && campanaid != '')
            {
                objCampaign.id = [Select id FROM Campaign WHERE id =: campanaid].id;
                update objCampaign;
            }
            else
            {
                insert objCampaign;
            }
                    
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Registro guardado satisfactoriamente');
            ApexPages.addMessage(msg);
            PageReference p = new PageReference('/' + objCampaign.Id);
            p.setRedirect(true);
            return p;
            //return null;
            
        } catch (Exception e) 
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid Input.');
            //ApexPages.addMessage(myMsg);
            ApexPages.addMessages(e);
            return null;
        }           
    }

     /****
      * ClickRight - Right pointing arrow was clicked. Move selected options to the right box.
      ****/
      public PageReference ClickRight()
      {
        try 
        {
            System.debug('ApexPages'+ApexPages.currentPage().getParameters());
            lstFuerzaElegida.clear();         
            System.debug('----------ClickRightIni->strfuerzaVenta------'+strfuerzaVenta);         
            strfuerzaVenta=strfuerzaVenta.replace('[','').replace(']','');
            for(String s : strfuerzaVenta.split(','))
            {
              System.debug('---------opcion'+s.trim());
              if (s.trim()!= '' && LeftOptionMap.containsKey(s.trim())) 
              {
                RightOptionMap.put(s.trim(), LeftOptionMap.get(s.trim()));
                LeftOptionMap.remove(s.trim());
              }
            }
            lstFuerzaVentasCampaing=new List<SelectOption>();
            for(String s : LeftOptionMap.keySet())
            {
               if(s != '') 
                    lstFuerzaVentasCampaing.add(new SelectOption(s,s));
            }
            System.debug('------LISTA CAMPANA FIN----'+lstFuerzaVentasCampaing);
            strfuerzaElegida='';
            List<String> lstOptions=new List<String>();
            asignarSeleccionados();
            System.debug('----------lstOptions->'+lstOptions+'\n\n----------ClickRight->strfuerzaElegida'+strfuerzaElegida+'\n\n----------ClickRightFin->LeftOptionMap'+LeftOptionMap);
            setFuerzaVentas();           
            return null;
        } catch (Exception e) 
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid Input.');
            //ApexPages.addMessage(myMsg);
            ApexPages.addMessages(e);
            return null;
        }
      }
     
      /****
      * ClickLeft - Left pointing arrow was clicked. Move selected options to the left box.
      ****/     
    public PageReference ClickLeft()
    {
        try
        {
            lstFuerzaVentasCampaing.clear();
            System.debug('----------ClickLeftIni->strfuerzaElegida------'+strfuerzaElegida);
            strfuerzaElegida=strfuerzaElegida.replace('[','').replace(']','');
            for(String s : strfuerzaElegida.split(','))
            {
                if (s.trim()!= '' && RightOptionMap.containsKey(s.trim())) 
                {
                    LeftOptionMap.put(s.trim(), RightOptionMap.get(s.trim()));
                    RightOptionMap.remove(s.trim());
                }
            }
            lstFuerzaElegida=new List<SelectOption>();
            for(String s : RightOptionMap.keySet())
            {
                lstFuerzaElegida.add(new SelectOption(s,s));
            }

            System.debug('------LISTA CAMPANA FIN----'+lstFuerzaElegida);
            //strfuerzaElegida='';
            List<String> lstOptions=new List<String>();
            for (String strkeySet : LeftOptionMap.keySet())
            {
                lstOptions.add(strkeySet);
            }

            for(Integer i=0;i<lstOptions.size();i++)
            {
                lstOptions[i]=lstOptions[i].replace('[','').replace(']','');
                strfuerzaVenta += lstOptions[i] ;
                if(i<lstOptions.size()-1)
                    strfuerzaVenta += ',';

            }

            System.debug('----------ClickLeftFin->strfuerzaVenta'+strfuerzaVenta);
            //setFuerzaVentas(strfuerzaVenta);           
            setFuerzaVentas();
            return null;
        } catch (Exception e) 
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid Input.');
            //ApexPages.addMessage(myMsg);
            ApexPages.addMessages(e);
            return null;
        }
    }

    public PageReference ClickRightProd()
    {
        try 
        {
            System.debug('ApexPages'+ApexPages.currentPage().getParameters());
            lstproductoselegidos.clear();         
            System.debug('----------ClickRightIni->strproducto------'+strproducto);         
            strproducto=strproducto.replace('[','').replace(']','');
            for(String s : strproducto.split(','))
            {
              System.debug('---------opcion'+s.trim());
              if (s.trim()!= '' && LeftOptionMapProd.containsKey(s.trim())) 
              {
                RightOptionMapProd.put(s.trim(), LeftOptionMapProd.get(s.trim()));
                LeftOptionMapProd.remove(s.trim());
              }
            }
            lstproductoselegidos=new List<SelectOption>();
            for(String s : LeftOptionMapProd.keySet())
            {
               if(s != '') 
                    lstproductoselegidos.add(new SelectOption(s,s));
            }
            System.debug('------LISTA CAMPANA FIN----'+lstproductoselegidos);
            strproductoElegido='';
            List<String> lstOptions=new List<String>();
            asignarSeleccionadosProd();
            System.debug('----------lstOptions->'+lstOptions+'\n\n----------ClickRight->strproductoElegido'+strproductoElegido+'\n\n----------ClickRightFin->LeftOptionMap'+LeftOptionMapProd);
            setProductos();           
            return null;
        } catch (Exception e) 
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid Input.');
            //ApexPages.addMessage(myMsg);
            ApexPages.addMessages(e);
            return null;
        }
        return null;
    }

    public PageReference ClickLeftProd()
    {
        try
        {
            lstproductosCampaing.clear();
            System.debug('----------ClickLeftIni->strproductoElegido------'+strproductoElegido);
            strproductoElegido=strproductoElegido.replace('[','').replace(']','');
            for(String s : strproductoElegido.split(','))
            {
                if (s.trim()!= '' && RightOptionMapProd.containsKey(s.trim())) 
                {
                    LeftOptionMapProd.put(s.trim(), RightOptionMapProd.get(s.trim()));
                    RightOptionMapProd.remove(s.trim());
                }
            }
            lstproductoselegidos=new List<SelectOption>();
            for(String s : RightOptionMapProd.keySet())
            {
                lstproductoselegidos.add(new SelectOption(s,s));
            }

            System.debug('------LISTA CAMPANA FIN----'+lstproductoselegidos);
            //strfuerzaElegida='';
            List<String> lstOptions=new List<String>();
            for (String strkeySet : LeftOptionMapProd.keySet())
            {
                lstOptions.add(strkeySet);
            }

            for(Integer i=0;i<lstOptions.size();i++)
            {
                lstOptions[i]=lstOptions[i].replace('[','').replace(']','');
                strproducto += lstOptions[i] ;
                if(i<lstOptions.size()-1)
                    strproducto += ',';

            }

            System.debug('----------ClickLeftFin->strproducto'+strproducto);
            setProductos();
            return null;
        } catch (Exception e) 
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid Input.');
            //ApexPages.addMessage(myMsg);
            ApexPages.addMessages(e);
            return null;
        }
    }

    public PageReference ClickRightTipo()
    {
        try 
        {
            System.debug('ApexPages'+ApexPages.currentPage().getParameters());
            lstTiposElegidos.clear();         
            System.debug('----------ClickRightIni->tipo------'+tipo);         
            tipo=tipo.replace('[','').replace(']','');
            for(String s : tipo.split(','))
            {
              System.debug('---------opcion'+s.trim());
              if (s.trim()!= '' && LeftOptionMapTipo.containsKey(s.trim())) 
              {
                RightOptionMapTipo.put(s.trim(), LeftOptionMapTipo.get(s.trim()));
                LeftOptionMapTipo.remove(s.trim());
              }
            }
            lstTiposCampaing=new List<SelectOption>();
            for(String s : LeftOptionMapTipo.keySet())
            {
               if(s != '') 
                    lstTiposCampaing.add(new SelectOption(s,s));
            }
            System.debug('------LISTA CAMPANA FIN----'+lstTiposCampaing);
            tipoElegido='';
            List<String> lstOptions=new List<String>();
            asignarSeleccionadosTipo();
            System.debug('----------lstOptions->'+lstOptions+'\n\n----------ClickRight->tipoElegido'+tipoElegido+'\n\n----------ClickRightFin->LeftOptionMap'+LeftOptionMapTipo);
            setTipos();           
            return null;
        } catch (Exception e) 
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid Input.');
            //ApexPages.addMessage(myMsg);
            ApexPages.addMessages(e);
            return null;
        }
        return null;
    }

    public PageReference ClickLeftTipo()
    {
        try
        {
            lstTiposCampaing.clear();
            System.debug('----------ClickLeftIni->tipoElegido------'+tipoElegido);
            tipoElegido=tipoElegido.replace('[','').replace(']','');
            for(String s : tipoElegido.split(','))
            {
                if (s.trim()!= '' && RightOptionMapTipo.containsKey(s.trim())) 
                {
                    LeftOptionMapTipo.put(s.trim(), RightOptionMapTipo.get(s.trim()));
                    RightOptionMapTipo.remove(s.trim());
                }
            }
            lstTiposElegidos=new List<SelectOption>();
            for(String s : RightOptionMapTipo.keySet())
            {
                lstTiposElegidos.add(new SelectOption(s,s));
            }

            System.debug('------LISTA CAMPANA FIN----'+lstTiposElegidos);
            //strfuerzaElegida='';
            List<String> lstOptions=new List<String>();
            for (String strkeySet : LeftOptionMapTipo.keySet())
            {
                lstOptions.add(strkeySet);
            }

            for(Integer i=0;i<lstOptions.size();i++)
            {
                lstOptions[i]=lstOptions[i].replace('[','').replace(']','');
                tipo += lstOptions[i] ;
                if(i<lstOptions.size()-1)
                    tipo += ',';

            }

            System.debug('----------ClickLeftFin->tipo'+tipo);
            setTipos();
            return null;
        } catch (Exception e) 
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid Input.');
            //ApexPages.addMessage(myMsg);
            ApexPages.addMessages(e);
            return null;
        }
    }
}