/******************************************************************************************************************
Desarrollado por:				Avanxo Colombia 
Autor:							Luis Rafael Peñaranda.
Proyecto:						Global Seguros
Descripción:					Visualforce con la lista relacionada de cotizaciones de la oportunidad, para poner en 
								El foramto de página.							
Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No.		Fecha			Autor					Descripción
-------------------------------------------------------------------------------------------------------
1.0		08/05/2014		Luis Rafael Peñaranda		Creación de la clase.
*******************************************************************************************************************/
public class ListaCotizaciones_ctr {
	
	private final ApexPages.StandardController controller;

	public Boolean bolTabla {get;set;}
	public List<Wrapper_cls> wrap {get;set;}
	public Wrapper_cls objWrap {get;set;}
	public Boolean prueba {get;set;}	
	public Opportunity objOpportunity;
	
	/* Labels */
	public String lblstrNumeroCotizacion{get;set;}
	public String lblstrOpcionCotizacion {get;set;}
	public String lblstrNumAnosPension {get;set;}
	public String lblstrProducto {get;set;}
	public String lbldecValorPrima {get;set;}
	public String lbldatFechaCotizacion {get;set;}
	public GetUrlCotizador_cls getUrl;

	public String lblAnexoEnfermedadesGraves{get;set;}
	public String lblAnexoInvalidezTotalPermanente{get;set;}
	public String lblAnexosMuerteAccidental{get;set;}
	public String lblAnioMaduracion{get;set;}	
	public String lblValorAsegurado{get;set;}
	public String lblOpcionCotizacion{get;set;}
	
	public boolean bolSenalEducativo{get;set;}
	public boolean bolSenalVida{get;set;}
	public boolean bolSenalPensiones{get;set;}

	
	/* 	Constructor  */
	public ListaCotizaciones_ctr(ApexPages.StandardController inController){
		objOpportunity = (Opportunity)inController.getRecord();		
		bolSenalEducativo=false;
		bolSenalVida=false;
		bolSenalPensiones=false;
		String codigoProductoComercial  = this.getProductoComercial(objOpportunity.Id);
		if(codigoProductoComercial=='69_1' || codigoProductoComercial=='69_2') bolSenalEducativo=true;
		if(codigoProductoComercial=='60_1' || codigoProductoComercial=='60_100' || codigoProductoComercial=='60_5') bolSenalVida=true;
		if(codigoProductoComercial=='64_1') bolSenalPensiones=true;
		fnLabel();
		getUrl = new GetUrlCotizador_cls(); 
		system.debug('@@@objOpportunity-->I '+objOpportunity);
		bolTabla=true;
		prueba=true;
		wrap = consultarCotizaciones();

	}
	
	/* Consulta los valores de los labels de acuerdo a la región  */
	public void fnLabel(){
        lblstrNumeroCotizacion				='Número de Cotización';
        lblstrOpcionCotizacion				='Opción Cotización';
        lblstrNumAnosPension				='Años de Pensión';
        lblstrProducto						='Producto mas opcionado';
        lbldecValorPrima					='Valor Prima';
        lbldatFechaCotizacion				='Fecha Cotización';
        lblAnexoEnfermedadesGraves			='Anexo Enfermedades Graves';
        lblAnexoInvalidezTotalPermanente	='Anexo Invalidez Total Permanente';
        lblAnexosMuerteAccidental			='Anexos Muerte Accidental';
        lblAnioMaduracion					='Año Maduracion';
        lblValorAsegurado					='Valor Asegurado';
        lblOpcionCotizacion					='Opción de Cotización';
	}      
	
	public List<Wrapper_cls> consultarCotizaciones(){
		wrap = new List<Wrapper_cls>();
        list<Quote> lstQuote = [SELECT FechaCotizacion__c,ValorPrima__c,Name,NumeroAnosPension__c,OpcionCotizacion__c,Producto__c,ValorMensualDisponible__c,Producto_Comercial__c,
        						AnexoEnfermedadesGraves__c,AnexoInvalidezTotalPermanente__c,AnexosMuerteAccidental__c,AnioMaduracion__c,ValorAsegurado__c 
        						FROM Quote Where OpportunityId =:objOpportunity.Id Order By Name desc];


        						 
        OpportunityLineItem objOLI 	= getIdOpportunityLineItem(objOpportunity);	
        //system.debug('objOLI-->'+objOLI);
        //PricebookEntry 		pbe 	= getIdEntradaListaPrecio(objOLI.PricebookEntryId);					
		//Product2 			objProd = getIdProducto(codProducto);
		        			 			   						
		system.debug('lstQuote-->'+lstQuote);
		//system.debug('ProductCode-->'+objOLI.PricebookEntry.ProductCode);
		if(lstQuote.size()> 0){
			for(Quote objQT: lstQuote){
				objWrap=new Wrapper_cls();  
				objWrap.strNumeroCotizacion	=objQT.Name;
				objWrap.strProducto			=objQT.Producto__c;
				objWrap.decValorPrima		=objQT.ValorPrima__c ;
				objWrap.datFechaCotizacion	=objQT.FechaCotizacion__c ;
				objWrap.strUrlCotizador 	= getUrl.getListaCotizadores(objOpportunity.Id,objQT.Name,objOLI.PricebookEntry.ProductCode);
				
				if(objQT.AnexoEnfermedadesGraves__c!=null)
					objWrap.bolAnexoEnfermedadesGraves		=objQT.AnexoEnfermedadesGraves__c;
				
				if(objQT.AnexoInvalidezTotalPermanente__c!=null)
					objWrap.bolAnexoInvalidezTotalPermanente	=objQT.AnexoInvalidezTotalPermanente__c;
					
				if(objQT.AnexosMuerteAccidental__c!=null)
					objWrap.bolAnexosMuerteAccidental			=objQT.AnexosMuerteAccidental__c;
					
				objWrap.decAnioMaduracion				=objQT.AnioMaduracion__c;
				objWrap.strProductoOp					=objQT.Producto_Comercial__c;
				objWrap.decValorAsegurado				=objQT.ValorAsegurado__c;
				objWrap.strOpcionCotizacion				=objQT.OpcionCotizacion__c;
					
				system.debug('objWrap.strUrlCotizador-->'+objWrap.strUrlCotizador);
				wrap.add(objWrap);
			}
		}

		
		if(wrap.size()==0){
			bolTabla=false;
		}
		System.debug('........................... wrap '+wrap);
		return wrap;
		//return wrap;
	}

 /* Obtener el Id de un producto */
 public static OpportunityLineItem getIdOpportunityLineItem(Opportunity objOpp){
    OpportunityLineItem objOLI;
    list<OpportunityLineItem> listOli = [Select PricebookEntry.ProductCode   FROM OpportunityLineItem  where OpportunityId=:objOpp.id];

    
    if(listOli.size()>0) {
        objOLI = listOli.get(0);
    }else{
        objOLI=null;
    }
    return objOLI;
 }	
 
   /* Obtener el Id de la entrada de lista de precio asociada al producto*/
 public static PricebookEntry getIdEntradaListaPrecio( String idPricebookEntry){
    PricebookEntry objELP;
    list<PricebookEntry> listELP = [SELECT Id,Product2Id 
                                    FROM PricebookEntry
                                    Where Id=:idPricebookEntry];
    
    if(listELP.size()>0) {
        objELP = listELP.get(0);
    }else{
        listELP=null;
    }
    return objELP;
 }
 
  /* Obtener el Id de un producto */
 public static Product2 getCodProducto( String codProducto){
    Product2 objProd;
    list<Product2> listProd = [SELECT ProductCode,Ramo__c,TipoPlan__c,TipoProducto__c 
                                FROM Product2
                                where IdentificadorProducto__c=:codProducto];
  
    if(listProd.size()>0) {
        objProd = listProd.get(0);
    }else{
        objProd=null;
    }
    return objProd;
 }
 
 
    /*Encontar el código del producto comercual asociado a la oportunidad*/ 
    public String getProductoComercial(String idOportunidad){
        OpportunityLineItem opplineItem;
        list<OpportunityLineItem> listOpplineItem = [Select id,ProductCode from OpportunityLineItem where OpportunityId =:idOportunidad];
        if(listOpplineItem.size()>0) {
            opplineItem = listOpplineItem.get(0);
            system.debug('opplineItem.ProductCode -->'+opplineItem.ProductCode);
            Product2 ppObj2 = getProducto(opplineItem.ProductCode);
            if(ppObj2.Compania__c.equals('Global Seguros')){
                return opplineItem.ProductCode;
            }else{
                return null;
            }
        }else{
            opplineItem=null;
            system.debug('opplineItem.ProductCode -LA OPORTUNIDAD NO TIENE PRODUCTO COMERCIAL'); 
            return null;
        }   
        
    } 

    
     /* Obtener el Id de un producto */
     public static  Product2 getProducto( String codProducto){
        Product2 objProd;
        list<Product2> listProd = [SELECT CodigoRamo__c,Compania__c,Description,EsProductoComercial__c,Id,IdentificadorProducto__c,
                                    Name,Plan__c,ProductCode,Ramo__c,TipoPlan__c,TipoProducto__c
                                    FROM Product2
                                    where ProductCode=:codProducto];


        if(listProd.size()>0) {
            objProd = listProd.get(0);
        }else{
            objProd=null;
        }
        return objProd;
     } 
	/*public List<Wrapper_cls> wrapOrdenada(List<Wrapper_cls> wrapO){
	
		List<Wrapper_cls> lstWrapTemp=wrapO.clone();
		List<Wrapper_cls> lstWrap=new List<Wrapper_cls>();
		System.debug('.................. wrapO '+wrapO);
		Integer tam=wrapO.size();
		for(Integer i=0;i<tam;i++)
		{
			Wrapper_cls objWTemp;
			Wrapper_cls objWTemp2;
			Integer cont=0;
			Integer pos=0;
			for(Wrapper_cls objW:lstWrapTemp){
				
				if(objWTemp==null)
				{
					objWTemp=objW;
					System.debug('fecha 1 '+objW.fechaCreacion);
					
				}
				else
				{
					System.debug('fecha creacion '+objW.fechaCreacion);
					if(objW.fechaCreacion<objWTemp.fechaCreacion)
					{
						System.debug('fecha validada '+objW.fechaCreacion);
						objWTemp=objW;
						pos=cont;
					}
				}
				cont++;		
			}
			lstWrap.add(objWTemp);
			lstWrapTemp.remove(pos);
			system.debug('Lista '+lstWrap);
		}
		
		 
		
		return lstWrap;
	
	}*/
}