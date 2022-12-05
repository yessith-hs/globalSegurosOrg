/****************************************************************************************************
    Información general 
    -------------------
    Desarrollado por:   Avanxo Colombia
    Autor:              Luis Rafael Peñaranda.
    Proyecto:           Global Seguros (CRM)
    Descripción:        invocador de Cotizadores via Mashup 
    
    Información sobre cambios (Versiones) 
    -------------------------------------
    Número  Fecha       Autor                       Descripción
    ------  ----------  --------------------------  -----------
    1.0     23-04-2014  Luis Rafael Peñaranda       Creacion.
    2.0		29-06-2016	Raul David Orozco			Se agregan parámetros extra a la URL
    ****************************************************************************************************/
public class Cotizador_ctr {  
    
    public Boolean display { get; set; }
    public Boolean displayError { get; set; }
    public String url { get; set; }
    public String typeOperation {get; set;}
    public String idOperation {get; set;}
    public String idCase {get; set;} 
    public String redirect {get; set;}
    public String errorMessage {get; set;}
    public String origin {get; set;}
    public Opportunity objOpportunity;
    public Poliza__c objPoliza;
    
    public Boolean senalVerCotizadorUno{get; set;}
    public Boolean senalVerCotizadorDos{get; set;}
    public Boolean senalVerCotizadorTres{get; set;}

    public String urlCot1{get; set;}
    public String urlCot2{get; set;}
    public String urlCot3{get; set;}

    public String urlCotizadorUno{get; set;}
    public String urlCotizadorDos{get; set;}
    public String urlCotizadorTres{get; set;}

    
    public String descCotizadorUno{get; set;}
    public String descCotizadorDos{get; set;}
    public String descCotizadorTres{get; set;}

    public String paramCotizadorUno{get; set;}
    public String paramCotizadorDos{get; set;}
    public String paramCotizadorTres{get; set;}
    
        
    public Account accTomador=null;
    public Account accAcudiente=null;
    public Account accAsegurado=null;
    public Account accBeneficiario=null;    
    public String tipoRegistroPoliza;
    public String nombreTipoRegistroPoliza;
    public String codigoProductoComercial;
    
    public PageReference cotizarEducativo(){
        return null;        
    }

    public PageReference cotizarVidaPensiones(){
        return null;        
    }

    
    /* CONSTRUCTOR */
    public Cotizador_ctr(ApexPages.StandardController inController)
    {

        PageReference pageRef = ApexPages.currentPage();
        Map<String,String> mapParameters = pageRef.getParameters();
        objOpportunity = (Opportunity)inController.getRecord();     
        this.getListaCotizadores(objOpportunity.Id);
        this.getRamoProductoPoliza(objOpportunity.Id);
        //String param=this.setParametrosURL(); // Obtener parametros
        //nombreTipoRegistroPoliza  = this.getNombreTipoRegistroPoliza(objOpportunity.id);
        display = false;
        displayError = false;
        
        //url='http://www.eltiempo.com/'+param;
        url='https://transac.globalseguroscolombia.com/CotizadorVida2.0/LoginIni.aspx?ID=1';
    }

    /*Encontar*/
    public void getListaCotizadores(String idOportunidad){
        String codigoProductoComercial  = this.getProductoComercial(objOpportunity.Id);
        system.debug('codigoProductoComercial-->'+codigoProductoComercial);
        if(codigoProductoComercial != null) {
            
            RelacionProductoCotizador__c relProdCotizador   = RelacionProductoCotizador__c.getInstance(codigoProductoComercial);
            system.debug('relProdCotizador-->'+relProdCotizador);
            if(relProdCotizador != null){
                
                List<String> listCodcotizadores = relProdCotizador.ListaCotizadore__c.split(',');  
                integer i=1;
                system.debug('listCodcotizadores-->'+listCodcotizadores);
                for(String cotizador:listCodcotizadores){   
                    URLCotizador__c cot = URLCotizador__c.getInstance(cotizador); 
                    system.debug('cot-->'+cot);
                    system.debug('valor I-->'+i);
                    senalVerCotizadorTres = true;
                    urlCotizadorTres = cot.URL__c;
                    descCotizadorTres = cot.Descripcion__c;
                    paramCotizadorTres = this.setParametrosURL();
                    urlCot3 = urlCotizadorTres+paramCotizadorTres;
                    /*if(i==3){
                        senalVerCotizadorTres   =   true;
                        urlCotizadorTres        =   cot.URL__c;
                        descCotizadorTres       =   cot.Descripcion__c;
                        paramCotizadorTres      =   this.setParametrosURL();
                        i++;
                        urlCot3=urlCotizadorTres+paramCotizadorTres;

                    }       
                    if(i==2){
                        
                        senalVerCotizadorDos    =   true;
                        urlCotizadorDos         =   cot.URL__c;
                        descCotizadorDos        =   cot.Descripcion__c;
                        paramCotizadorDos       =   this.setParametrosURL();
                        urlCot2=urlCotizadorDos+paramCotizadorDos;
                        i++;

                        
                    }                               
                    if(i==1){
                        senalVerCotizadorUno    = true;
                        urlCotizadorUno         = cot.URL__c;
                        descCotizadorUno        = cot.Descripcion__c;
                        paramCotizadorUno       = this.setParametrosURL();
                        urlCot1=urlCotizadorUno+paramCotizadorUno;
                        i++;
                    }*/
                        
                }
                
            }else{
                
            }
        }else{
            
        }   
    } 
          
    /*Encontar el código del producto comercual asociado a la oportunidad*/ 
    public String getProductoComercial(String idOportunidad){
        OpportunityLineItem opplineItem;
        list<OpportunityLineItem> listOpplineItem = [Select id,ProductCode from OpportunityLineItem where OpportunityId =:idOportunidad];
        if(listOpplineItem.size()>0) {
            opplineItem = listOpplineItem.get(0);
            system.debug('opplineItem.ProductCode -->'+opplineItem.ProductCode);
            /*Product2 ppObj2 = getProducto(opplineItem.ProductCode);
            if(ppObj2.Compania__c.equals('Global Seguros')){
                return opplineItem.ProductCode;
            }else{
                return null;
            }*/
            return opplineItem.ProductCode;
        }else{
            opplineItem=null;
            system.debug('opplineItem.ProductCode -LA OPORTUNIDAD NO TIENE PRODUCTO COMERCIAL'); 
            return null;
        }   
        
    }    
    /*Construir el URL para la invocación del Cotizador respectivo*/
    public String setParametrosURL(){
        system.debug('Entro a encriptar -->');
        
            ParametrosURL objParametrosURL = new ParametrosURL();
            
            /*********************************************************************
            *** Fecha: 30/06/2016
            *** Autor: Raul David Orozco
            *** Propósito: Se agregan parámetros extra a la url de los cotizadores
            *********************************************************************/
            objOpportunity =	[ 
            						SELECT 
            							AccountId,
            							BeneficiarioAsegurado__c,
            							Designado__c,
            							Name,
            							AuxiliarIdentificador__c,
            							Colegio__c,
										Curso__c,
										CampaignId,
										ClaveNo__r.IdExterno__c,
                						Description,
										Beneficiario_Contingente__r.Id_Externo__c,
										Beneficiario_Contingente__r.TipoDocumento__c,
										Beneficiario_Contingente__r.NumeroDocumento__c,
										Beneficiario_Contingente__r.FirstName,
										Beneficiario_Contingente__r.Genero__pc,
										Beneficiario_Contingente__r.LastName,
										Beneficiario_Contingente__r.SegundoApellido__c,
										Beneficiario_Contingente__r.PersonBirthdate,
										Datos_Contacto_Comercial__r.Telefono__c,
										Datos_Contacto_Comercial__r.Celular__c,
										Datos_Contacto_Comercial__r.CorreoElectronico__c,
										Datos_Contacto_Comercial__r.Ciudad__r.Codigo__c,
										Datos_Contacto_Comercial__r.Direccion__c
            						FROM 
            							Opportunity 
            						WHERE 
            							id=:objOpportunity.id
            					];
            /****************************************************************/
            
            if(objOpportunity.AccountId != null)                    accTomador      =this.getCuenta(objOpportunity.AccountId);
            if(objOpportunity.Designado__c != null)                 accAcudiente    =this.getCuenta(objOpportunity.Designado__c);
            if(objOpportunity.BeneficiarioAsegurado__c != null)     accBeneficiario =this.getCuenta(objOpportunity.BeneficiarioAsegurado__c);
            
            String parametrosURL;
             
            //////OJO  PRUEBAS QUITAR DE AQUI OJOOOOOOOOOOOOOOOOOOOOOO
            //objParametrosURL.strUsuarioSalesforce                       =   'USFR=ncruzv_242@gsf.com';
            objParametrosURL.strUsuarioSalesforce                       =   'USFR='     +   userinfo.getUserName(); 
            objParametrosURL.strNumeroOportunidad                       =   '&NOPP='    +   objOpportunity.AuxiliarIdentificador__c; 
            if(objPoliza != null) {
                objParametrosURL.strNumeroCotizacion    =   '&NCOT='    +   objPoliza.Name;
            }else{
                objParametrosURL.strNumeroCotizacion    =   '&NCOT=0' ;
            }       
            
            objParametrosURL.strTipoIdentificacionTomador               =   '&TIDT='    +   getCodigoTipoDocumento(accTomador.TipoDocumento__c);
            objParametrosURL.strNumeroIdentificacionTomador             =   '&NIDT='    +   accTomador.NumeroDocumento__c ;         
            objParametrosURL.strNombresTomador                          =   '&NOMT='    +   accTomador.Firstname ;
            
            if(accTomador.LastName != null && accTomador.LastName != '' && accTomador.LastName!= ' '){
                List<String> listApellidos = accTomador.LastName.split(' ');
                objParametrosURL.strPrimerApellidoTomador                   =   '&PAPT='    +   listApellidos[0];
            }else{
                objParametrosURL.strPrimerApellidoTomador                   =   '&PAPT=';
            }
            
            
            if(accTomador.SegundoApellido__c != null && accTomador.SegundoApellido__c != '' && accTomador.SegundoApellido__c!= ' '){    
                objParametrosURL.strSegundoApellidoTomador                  =   '&SAPT='    +   accTomador.SegundoApellido__c;
            }else{
          		if(accTomador.LastName != null && accTomador.LastName != '' && accTomador.LastName!= ' '){
            		List<String> listApellidos = accTomador.LastName.split(' ');  
            		system.debug('listApellidos-->'+listApellidos);
            		system.debug('listApellidos.size-->'+listApellidos.size());
            		if(listApellidos.size()>1){
            			objParametrosURL.strSegundoApellidoTomador                  =   '&SAPT='+listApellidos[1];
            			if(listApellidos.size()>2){
            				objParametrosURL.strSegundoApellidoTomador                  +=  ' '+listApellidos[2];
            			}
            			objParametrosURL.strPrimerApellidoTomador                   =   '&PAPT='+listApellidos[0];
            		}else{
            			objParametrosURL.strSegundoApellidoTomador                  =   '&SAPT=';
            		}
            	}else{
                	objParametrosURL.strSegundoApellidoTomador                  =   '&SAPT=';
            	}
            }
            system.debug('accTomador.PersonBirthdate-->'+accTomador.PersonBirthdate);
            if(accTomador.PersonBirthdate != null){
                Datetime tomadorFechanacimiento = datetime.newInstance(accTomador.PersonBirthdate.year(), accTomador.PersonBirthdate.month(),accTomador.PersonBirthdate.day());
                objParametrosURL.strDiaNacimiento                       =   '&DNAT='    +   tomadorFechanacimiento.dayGmt();
                objParametrosURL.strMesNacimientoTomador                =   '&MNAT='    +   tomadorFechanacimiento.monthGmt();
                objParametrosURL.strAnoNacimientoTomador                =   '&ANAT='    +   tomadorFechanacimiento.yearGmt();
                system.debug('tomadorFechanacimiento-->'+tomadorFechanacimiento);
            }else{
                objParametrosURL.strDiaNacimiento                       =   '&DNAT=';
                objParametrosURL.strMesNacimientoTomador                =   '&MNAT=';
                objParametrosURL.strAnoNacimientoTomador                =   '&ANAT='    ;               
            }
            //
            if(accTomador.Genero__pc != null && accTomador.Genero__pc != '' && accTomador.Genero__pc!= ' '){    
                objParametrosURL.strGeneroTomadorTomador                    =   '&GENT='    +   accTomador.Genero__pc.substring(0,1);
            }else{
                objParametrosURL.strGeneroTomadorTomador                    =   '&GENT=';
            }
            
            if(accTomador.TipoVinculacionLaboral__c != null ){  
                objParametrosURL.strActividadTomador                        =   '&ACTT='    +   accTomador.TipoVinculacionLaboral__c;
            }else{
                objParametrosURL.strActividadTomador                        =   '&ACTT=';
            }
            system.debug('@@-aobjParametrosURL.strActividadTomador -->'+objParametrosURL.strActividadTomador);
            system.debug('@@-accTomador.TipoVinculacionLaboral__c-->'+accTomador.TipoVinculacionLaboral__c);
            if(accTomador.Phone != null && accTomador.Phone != '' && accTomador.Phone!= ' '){   
                objParametrosURL.strTelefonoTomador                         =   '&TELT='    +   accTomador.Phone;
            }else{
                objParametrosURL.strTelefonoTomador                         =   '&TELT=';
            }
            
            if(accTomador.PersonEmail != null && accTomador.PersonEmail != '' && accTomador.PersonEmail != ' '){    
                objParametrosURL.strCorreoElectronicoTomador                =   '&EMAT='    +   accTomador.PersonEmail;
            }else{
                objParametrosURL.strCorreoElectronicoTomador                =   '&EMAT=';
            }
            
            if(accTomador.Celular__c != null && accTomador.Celular__c != '' && accTomador.Celular__c != ' '){   
                objParametrosURL.strCelularTomador                          =   '&CELT='    +   accTomador.Celular__c;
            }else{
                objParametrosURL.strCelularTomador                          =   '&CELT=';
            }
            
            if(accTomador.DireccionCorrespondencia__c != null && accTomador.DireccionCorrespondencia__c != '' && accTomador.DireccionCorrespondencia__c != ' '){    
                            objParametrosURL.strCelularTomador                          =   '&DIRT='    +   accTomador.DireccionCorrespondencia__c;
            }else{
                objParametrosURL.strCelularTomador                          =   '&DIRT=';
            }
            
            /* Si la oportunidad tiene un Beneficiario*/    
            if(accBeneficiario != null){ 
                system.debug('accBeneficiario.TipoDocumento__c-->'+accBeneficiario.TipoDocumento__c);
                if( accBeneficiario.TipoDocumento__c != null && accBeneficiario.TipoDocumento__c != ''){            
                    objParametrosURL.strTipoIdentificacionBeneficiario      =   '&TIDB='    +   getCodigoTipoDocumento(accBeneficiario.TipoDocumento__c);
                }else{
                    objParametrosURL.strTipoIdentificacionBeneficiario      =   '&TIDB=';
                }
                
                objParametrosURL.strNumeroIdentificacionBeneficiario    =   '&NIDB=';
                if(accBeneficiario.NumeroDocumento__c!=null)
                objParametrosURL.strNumeroIdentificacionBeneficiario    =   objParametrosURL.strNumeroIdentificacionBeneficiario    +   accBeneficiario.NumeroDocumento__c;
                
                objParametrosURL.strNombresBeneficiario                 =   '&NOMB=';
                if(accBeneficiario.Firstname!=null)
                objParametrosURL.strNombresBeneficiario                 =   objParametrosURL.strNombresBeneficiario     +   accBeneficiario.Firstname;
                
                objParametrosURL.strPrimerApellidoBeneficiario          =   '&PAPB=';
                if(accBeneficiario.LastName !=null)
                objParametrosURL.strPrimerApellidoBeneficiario          =   objParametrosURL.strPrimerApellidoBeneficiario  +   accBeneficiario.LastName;
                
                objParametrosURL.strSegundoApellidoBeneficiarior        =   '&SAPB=';
                if(accBeneficiario.SegundoApellido__c!=null){
                	objParametrosURL.strSegundoApellidoBeneficiarior        =   objParametrosURL.strSegundoApellidoBeneficiarior    +   accBeneficiario.SegundoApellido__c; 
                }else{
	          		if(accBeneficiario.LastName != null && accBeneficiario.LastName != '' && accBeneficiario.LastName!= ' '){
	            		List<String> listApellidos = accBeneficiario.LastName.split(' ');  
	            		system.debug('listApellidos-->'+listApellidos);
	            		system.debug('listApellidos.size-->'+listApellidos.size());
	            		if(listApellidos.size()>1){
	            			objParametrosURL.strSegundoApellidoBeneficiarior                 +=   listApellidos[1];
	            			if(listApellidos.size()>2){
	            				objParametrosURL.strSegundoApellidoBeneficiarior             +=  ' '+listApellidos[2];
	            			}
	            			objParametrosURL.strPrimerApellidoBeneficiario                   =   '&PAPB='+listApellidos[0];
	            		}else{
	            			objParametrosURL.strSegundoApellidoBeneficiarior                  =   '&SAPB=';
	            		}
	            	}else{
	                	objParametrosURL.strSegundoApellidoBeneficiarior                  =   '&SAPB=';
	            	}                	
                }            
                system.debug('accBeneficiario.PersonBirthdate-->'+accBeneficiario.PersonBirthdate);
                if(accBeneficiario.PersonBirthdate != null){
                    Datetime benefFechanacimiento = datetime.newInstance(accBeneficiario.PersonBirthdate.year(), accBeneficiario.PersonBirthdate.month(),accBeneficiario.PersonBirthdate.day());           
                    objParametrosURL.strDiaNacimientoBeneficiario           =   '&DNAB='    +   benefFechanacimiento.dayGmt();
                    objParametrosURL.strMesNacimientoBeneficiario           =   '&MNAB='    +   benefFechanacimiento.monthGmt();
                    objParametrosURL.strAnoNacimientoBeneficiario           =   '&ANAB='    +   benefFechanacimiento.yearGmt();
                }else{
                    objParametrosURL.strDiaNacimientoBeneficiario           =   '&DNAB=';
                    objParametrosURL.strMesNacimientoBeneficiario           =   '&MNAB=';
                    objParametrosURL.strAnoNacimientoBeneficiario           =   '&ANAB=';
                }
            }else{
                objParametrosURL.strTipoIdentificacionBeneficiario      =   '&TIDB=';
                objParametrosURL.strNumeroIdentificacionBeneficiario    =   '&NIDB=';
                objParametrosURL.strNombresBeneficiario                 =   '&NOMB=';
                objParametrosURL.strPrimerApellidoBeneficiario          =   '&PAPB=';
                objParametrosURL.strSegundoApellidoBeneficiarior        =   '&SAPB=';
                objParametrosURL.strDiaNacimientoBeneficiario           =   '&DNAB=';
                objParametrosURL.strMesNacimientoBeneficiario           =   '&MNAB=';
                objParametrosURL.strAnoNacimientoBeneficiario           =   '&ANAB=';
            }
            
            /************** PARAMETROS EXTRA ***************************/
            objParametrosURL.strIdExternoColegio		=   '&IECO='    +   objOpportunity.Colegio__c;
            objParametrosURL.strCodigoCurso				=   '&CODC='    +   objOpportunity.Curso__c;
            objParametrosURL.strIdCampana				=   '&IDCA='    +   objOpportunity.CampaignId;
            objParametrosURL.strIdIntermediario			=   '&IDIN='    +   objOpportunity.ClaveNo__r.IdExterno__c;
        	objParametrosURL.strObservaciones			= 	'&OBSO='	+	objOpportunity.Description;
            
            //Se evalúa que exista beneficiario contingente
            if(objOpportunity.Beneficiario_Contingente__c <> null){
            	objParametrosURL.strIdExternoBeneficiario2	=   '&IEBC='    +   objOpportunity.Beneficiario_Contingente__r.Id_Externo__c;
	            objParametrosURL.intTipIdentifBenef2		=   '&ITIB='    +   objOpportunity.Beneficiario_Contingente__r.TipoDocumento__c;
	            objParametrosURL.strNroIdentifBenef2		=   '&NIBD='    +   objOpportunity.Beneficiario_Contingente__r.NumeroDocumento__c;
	            objParametrosURL.strNombreBenef2			=   '&NMBD='    +   objOpportunity.Beneficiario_Contingente__r.FirstName;
	            objParametrosURL.strGeneroBeneficiario2		=   '&GNBD='    +   objOpportunity.Beneficiario_Contingente__r.Genero__pc;
	            objParametrosURL.strPriApellidoBenef2		=   '&PABD='    +   objOpportunity.Beneficiario_Contingente__r.LastName;
	            objParametrosURL.strSegApellidoBenef2		=   '&SABD='    +   objOpportunity.Beneficiario_Contingente__r.SegundoApellido__c;
				objParametrosURL.intDiaNaciBenef2			=   '&DNBD='    +   objOpportunity.Beneficiario_Contingente__r.PersonBirthdate.day();
				objParametrosURL.intMesNaciBenef2			=   '&MNBD='    +   objOpportunity.Beneficiario_Contingente__r.PersonBirthdate.month();
				objParametrosURL.intAnoNaciBenef2			=   '&ANBD='    +   objOpportunity.Beneficiario_Contingente__r.PersonBirthdate.year();
            }else{
            	objParametrosURL.strIdExternoBeneficiario2	=   '&IEBC=';
	            objParametrosURL.intTipIdentifBenef2		=   '&ITIB=';
	            objParametrosURL.strNroIdentifBenef2		=   '&NIBD=';
	            objParametrosURL.strNombreBenef2			=   '&NMBD=';
	            objParametrosURL.strGeneroBeneficiario2		=   '&GNBD=';
	            objParametrosURL.strPriApellidoBenef2		=   '&PABD=';
	            objParametrosURL.strSegApellidoBenef2		=   '&SABD=';
				objParametrosURL.intDiaNaciBenef2			=   '&DNBD=';
				objParametrosURL.intMesNaciBenef2			=   '&MNBD=';
				objParametrosURL.intAnoNaciBenef2			=   '&ANBD=';
            }
            
			//Se evalúa que existan datos de contacto comercial
			if(objOpportunity.Datos_Contacto_Comercial__c <> null){
				objParametrosURL.strTelefono				=   '&TLCC='    +   objOpportunity.Datos_Contacto_Comercial__r.Telefono__c;
				objParametrosURL.strCelular					=   '&CLCC='    +   objOpportunity.Datos_Contacto_Comercial__r.Celular__c;
				objParametrosURL.strCorreoElectronico		=   '&CECC='    +   objOpportunity.Datos_Contacto_Comercial__r.CorreoElectronico__c;
				objParametrosURL.strCiudadTomador			=   '&CICC='    +   objOpportunity.Datos_Contacto_Comercial__r.Ciudad__r.Codigo__c;
				objParametrosURL.strDirTomador				=   '&DRCC='    +   objOpportunity.Datos_Contacto_Comercial__r.Direccion__c;
			}else{
				objParametrosURL.strTelefono				=   '&TLCC=';
				objParametrosURL.strCelular					=   '&CLCC=';
				objParametrosURL.strCorreoElectronico		=   '&CECC=';
				objParametrosURL.strCiudadTomador			=   '&CICC=';
				objParametrosURL.strDirTomador				=   '&DRCC=';
			}
            
            /***********************************************************/
            
            system.debug('objParametrosURL-->'+objParametrosURL);
            parametrosURL = encriptarParametrosURL(objParametrosURL);
            
            system.debug('parametrosURL-->'+parametrosURL);
            return parametrosURL;   
    }
    
    
    /*Encriptar Parametros*/
     public String encriptarParametrosURL(ParametrosURL parObjParametrosURL){
        String cadenaPlana;
        String cadenaEncriptada;
        
                        parObjParametrosURL.strUsuarioSalesforce                = parObjParametrosURL.strUsuarioSalesforce.replace('null','');
                        parObjParametrosURL.strNumeroOportunidad                = parObjParametrosURL.strNumeroOportunidad.replace('null','');                  
                        parObjParametrosURL.strNumeroCotizacion                 = parObjParametrosURL.strNumeroCotizacion.replace('null','');   
                        parObjParametrosURL.strTipoIdentificacionTomador        = parObjParametrosURL.strTipoIdentificacionTomador.replace('null','');  
                        parObjParametrosURL.strNumeroIdentificacionTomador      = parObjParametrosURL.strNumeroIdentificacionTomador.replace('null','');    
                        parObjParametrosURL.strNombresTomador                   = parObjParametrosURL.strNombresTomador.replace('null',''); 
                        parObjParametrosURL.strPrimerApellidoTomador            = parObjParametrosURL.strPrimerApellidoTomador.replace('null','');  
                        parObjParametrosURL.strSegundoApellidoTomador           = parObjParametrosURL.strSegundoApellidoTomador.replace('null',''); 
                        parObjParametrosURL.strDiaNacimiento                    = parObjParametrosURL.strDiaNacimiento.replace('null','');  
                        parObjParametrosURL.strMesNacimientoTomador             = parObjParametrosURL.strMesNacimientoTomador.replace('null','');   
                        parObjParametrosURL.strAnoNacimientoTomador             = parObjParametrosURL.strAnoNacimientoTomador.replace('null','');   
                        parObjParametrosURL.strGeneroTomadorTomador             = parObjParametrosURL.strGeneroTomadorTomador.replace('null','');   
                        parObjParametrosURL.strActividadTomador                 = parObjParametrosURL.strActividadTomador.replace('null','');   
                        parObjParametrosURL.strTelefonoTomador                  = parObjParametrosURL.strTelefonoTomador.replace('null','');    
                        parObjParametrosURL.strCorreoElectronicoTomador         = parObjParametrosURL.strCorreoElectronicoTomador.replace('null','');   
                        parObjParametrosURL.strCelularTomador                   = parObjParametrosURL.strCelularTomador.replace('null',''); 
                        parObjParametrosURL.strTipoIdentificacionBeneficiario   = parObjParametrosURL.strTipoIdentificacionBeneficiario.replace('null',''); 
                        parObjParametrosURL.strNumeroIdentificacionBeneficiario = parObjParametrosURL.strNumeroIdentificacionBeneficiario.replace('null','');   
                        parObjParametrosURL.strNombresBeneficiario              = parObjParametrosURL.strNombresBeneficiario.replace('null','');
                        parObjParametrosURL.strPrimerApellidoBeneficiario       = parObjParametrosURL.strPrimerApellidoBeneficiario.replace('null','');
                        system.debug('parObjParametrosURL.strSegundoApellidoBeneficiarior-->'+parObjParametrosURL.strSegundoApellidoBeneficiarior);
                        parObjParametrosURL.strSegundoApellidoBeneficiarior     = parObjParametrosURL.strSegundoApellidoBeneficiarior.replace('null','');
                        parObjParametrosURL.strDiaNacimientoBeneficiario        = parObjParametrosURL.strDiaNacimientoBeneficiario.replace('null','');
                        parObjParametrosURL.strMesNacimientoBeneficiario        = parObjParametrosURL.strMesNacimientoBeneficiario.replace('null','');
                        parObjParametrosURL.strAnoNacimientoBeneficiario        = parObjParametrosURL.strAnoNacimientoBeneficiario.replace('null','');
                        
                        /************** PARAMETROS EXTRA ***************************/
			            parObjParametrosURL.strIdExternoColegio					= parObjParametrosURL.strIdExternoColegio.replace('null','');
			            parObjParametrosURL.strCodigoCurso						= parObjParametrosURL.strCodigoCurso.replace('null','');
			            parObjParametrosURL.strIdCampana						= parObjParametrosURL.strIdCampana.replace('null','');
			            parObjParametrosURL.strIdIntermediario					= parObjParametrosURL.strIdIntermediario.replace('null','');
			            parObjParametrosURL.strIdExternoBeneficiario2			= parObjParametrosURL.strIdExternoBeneficiario2.replace('null','');
			            parObjParametrosURL.intTipIdentifBenef2					= parObjParametrosURL.intTipIdentifBenef2.replace('null','');
			            parObjParametrosURL.strNroIdentifBenef2					= parObjParametrosURL.strNroIdentifBenef2.replace('null','');
			            parObjParametrosURL.strNombreBenef2						= parObjParametrosURL.strNombreBenef2.replace('null','');
			            parObjParametrosURL.strGeneroBeneficiario2				= parObjParametrosURL.strGeneroBeneficiario2.replace('null','');
			            parObjParametrosURL.strPriApellidoBenef2				= parObjParametrosURL.strPriApellidoBenef2.replace('null','');
			            parObjParametrosURL.strSegApellidoBenef2				= parObjParametrosURL.strSegApellidoBenef2.replace('null','');
						parObjParametrosURL.intDiaNaciBenef2					= parObjParametrosURL.intDiaNaciBenef2.replace('null','');
						parObjParametrosURL.intMesNaciBenef2					= parObjParametrosURL.intMesNaciBenef2.replace('null','');
						parObjParametrosURL.intAnoNaciBenef2					= parObjParametrosURL.intAnoNaciBenef2.replace('null','');
						parObjParametrosURL.strTelefono							= parObjParametrosURL.strTelefono.replace('null','');
						parObjParametrosURL.strCelular							= parObjParametrosURL.strCelular.replace('null','');
						parObjParametrosURL.strCorreoElectronico				= parObjParametrosURL.strCorreoElectronico.replace('null','');
						parObjParametrosURL.strCiudadTomador					= parObjParametrosURL.strCiudadTomador.replace('null','');
						parObjParametrosURL.strDirTomador						= parObjParametrosURL.strDirTomador.replace('null','');
			            /***********************************************************/
                        
        cadenaPlana =   parObjParametrosURL.strUsuarioSalesforce                    +
                        parObjParametrosURL.strNumeroOportunidad                    +                   
                        parObjParametrosURL.strNumeroCotizacion                     +   
                        parObjParametrosURL.strTipoIdentificacionTomador            +   
                        parObjParametrosURL.strNumeroIdentificacionTomador          +   
                        parObjParametrosURL.strNombresTomador                       +   
                        parObjParametrosURL.strPrimerApellidoTomador                +   
                        parObjParametrosURL.strSegundoApellidoTomador               +   
                        parObjParametrosURL.strDiaNacimiento                        +   
                        parObjParametrosURL.strMesNacimientoTomador                 +   
                        parObjParametrosURL.strAnoNacimientoTomador                 +   
                        parObjParametrosURL.strGeneroTomadorTomador                 +   
                        parObjParametrosURL.strActividadTomador                     +   
                        parObjParametrosURL.strTelefonoTomador                      +   
                        parObjParametrosURL.strCorreoElectronicoTomador             +   
                        parObjParametrosURL.strCelularTomador                       +   
                        parObjParametrosURL.strTipoIdentificacionBeneficiario       +   
                        parObjParametrosURL.strNumeroIdentificacionBeneficiario     +   
                        parObjParametrosURL.strNombresBeneficiario                  +
                        parObjParametrosURL.strPrimerApellidoBeneficiario           +
                        parObjParametrosURL.strSegundoApellidoBeneficiarior         +
                        parObjParametrosURL.strDiaNacimientoBeneficiario            +
                        parObjParametrosURL.strMesNacimientoBeneficiario            +
                        parObjParametrosURL.strAnoNacimientoBeneficiario            +
                        
                        /************** PARAMETROS EXTRA ***************************/
                        parObjParametrosURL.strIdExternoColegio					+
						parObjParametrosURL.strCodigoCurso						+
						parObjParametrosURL.strIdCampana						+
						parObjParametrosURL.strIdIntermediario					+
						parObjParametrosURL.strIdExternoBeneficiario2			+
						parObjParametrosURL.intTipIdentifBenef2					+
						parObjParametrosURL.strNroIdentifBenef2					+
						parObjParametrosURL.strNombreBenef2						+
						parObjParametrosURL.strGeneroBeneficiario2				+
						parObjParametrosURL.strPriApellidoBenef2				+
						parObjParametrosURL.strSegApellidoBenef2				+
						parObjParametrosURL.intDiaNaciBenef2					+
						parObjParametrosURL.intMesNaciBenef2					+
						parObjParametrosURL.intAnoNaciBenef2					+
						parObjParametrosURL.strTelefono							+
						parObjParametrosURL.strCelular							+
						parObjParametrosURL.strCorreoElectronico				+
						parObjParametrosURL.strCiudadTomador					+
						parObjParametrosURL.strDirTomador						;
                        /***********************************************************/
        
        system.debug('parametrosURLSinEncriptar-->'+cadenaPlana);               
        CifradoAES128_cls cfr = new CifradoAES128_cls();
        cadenaEncriptada = cfr.CifrarUtf8(cadenaPlana);
        
        
        return cadenaEncriptada;
        
     }   
     
     
    /*obtener data de una cuenta*/
    public Account getCuenta(String idCuenta){
        Account objAccount;
        list<Account> lstobjAccount = [SELECT   PersonBirthdate,SegundoApellido__c,Ocupacion__pc,DireccionCorrespondencia__c,Celular__c,Edad__pc,EstadoCivil__c,FirstName,IDPersona__c,Id_Externo__c,LastName,id,Genero__pc,
                                        Nacionalidad__c,Name,PersonEmail,Phone,TipoDocumento__c,TipoDocumento__pc,NumeroDocumento__c,TipoVinculacionLaboral__c                                        
                                        FROM Account where id=:idCuenta];
        if(lstobjAccount.size()>0) {
            objAccount = lstobjAccount.get(0);
        }else{
            objAccount=null;
        }
        return objAccount;
        
    }

            
    /*obtener la poliza asociada a la oportunidad*/
    public String getRamoProductoPoliza(String idOportunidad){
        Poliza__c objPoliza;
        list<Poliza__c> lstobjPoliza = [SELECT  id,Name,RecordTypeId,ProductoPlan__r.Ramo__c    FROM Poliza__c where Oportunidad__c =:idOportunidad];   
                                        
        if(lstobjPoliza.size()>0) {
            return lstobjPoliza.get(0).ProductoPlan__r.Ramo__c;
        }else{
            objPoliza=null;
            return null;
        }
        
    }
        
    /** Obtiene el host.
    *@return  String con el host de Salesforce o una cadena vacia si no se logra obtener.
    **/
    /*
    private String getHost(){
        String host;
        Integer result=0;
        if(redirect!=null){
            for(Integer i=0;i<3 && result>=0 ;i++){
                result= redirect.indexOf('/',result)+1;     
            }
        }
        if(result>0)
            return redirect.substring(0,result);
        else
            return '';  
   }
    */
    
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
    /**Invocar Cotizador Uno**/ 
    /*public void inovocarCotizadorUno()
    {       url=urlCotizadorUno+paramCotizadorUno;
            display=true;
    }*/


    /**Invocar Cotizador Dos**/ 
    /*public void inovocarCotizadorDos()
    {       url=urlCotizadorDos+paramCotizadorDos;
            display=true;
    }*/
    
    
    /**Invocar Cotizador Tres**/ 
    /*public void inovocarCotizadorTres()
    {       url=urlCotizadorTres+paramCotizadorTres;
            display=true;
    }*/
    
    /** Valida permiso para solicitar diseÃ±o (Para cubrir el 100%).
    *@validate Indica si se debe validar.
    *@currentProfile nombre del perfil actual 
    *@url direcciÃ³n del Mashup si es exitoso.
    *@action AcciÃ³n a validar
    *@message Mensaje que se mostrara.
    *@return  null.
    **/
    public PageReference validatePermission(boolean validate,  String currentProfile, String url, String action, String message){
/*      IQuery queryManager= new QueryImpl();
        if(validate && !queryManager.havePermission(currentProfile,action)){
            return displayError(message);
        }
        this.url = url;*/
        return null;
    }
    
    /** Muestra mensaje de error.
    *@param message Mensaje a Mostrar.
    *@return  null.
    **/
    public PageReference displayError(String message){
        display = false;
        displayError = true;
        errorMessage = message;
        return null;
    }

 /* Obtener la descripcion de un tipo de documento*/
 public  String getCodigoTipoDocumento(String descDocumento){
    Parametros__c  objParam;
    System.debug('descDocumento-->'+descDocumento);
    list<Parametros__c> listParam = [SELECT Codigo__c,Name FROM Parametros__c WHERE Objeto__c = 'Account' 
                                    and Campo__c= 'TipoDocumento__c' and Name =:descDocumento];     
    if(listParam.size()>0) {
        System.debug('listParam.get(0).Codigo__c-->'+listParam.get(0).Codigo__c);
            return listParam.get(0).Codigo__c;
    }else{
        return null;
    }   
 }
     
   public class ParametrosURL{
    
            String  strUsuarioSalesforce;
            String  strNumeroOportunidad;
            String  strNumeroCotizacion;
            String  strTipoIdentificacionTomador;
            String  strNumeroIdentificacionTomador;
            String  strNombresTomador;
            String  strPrimerApellidoTomador;
            String  strSegundoApellidoTomador;
            String  strDiaNacimiento;
            String  strMesNacimientoTomador;
            String  strAnoNacimientoTomador;
            String  strGeneroTomadorTomador;
            String  strActividadTomador;
            String  strTelefonoTomador;
            String  strCorreoElectronicoTomador;
            String  strCelularTomador;          
            String  strTipoIdentificacionBeneficiario;
            String  strNumeroIdentificacionBeneficiario;
            String  strNombresBeneficiario;
            String  strPrimerApellidoBeneficiario;
            String  strSegundoApellidoBeneficiarior;
            String  strDiaNacimientoBeneficiario;
            String  strMesNacimientoBeneficiario;
            String  strAnoNacimientoBeneficiario;
			/******************** PARAMETROS EXTRA ******************/
			String	strIdExternoColegio;
			String	strCodigoCurso;
			String	strIdCampana;
			String	strIdIntermediario;
			String	strIdExternoBeneficiario2;
			String	intTipIdentifBenef2;
			String	strNroIdentifBenef2;
			String	strNombreBenef2;
			String	strGeneroBeneficiario2;
			String	strPriApellidoBenef2;
			String	strSegApellidoBenef2;
			String	intDiaNaciBenef2;
			String	intMesNaciBenef2;
			String	intAnoNaciBenef2;
			String	strTelefono;
			String	strCelular;
			String	strCorreoElectronico;
			String	strCiudadTomador;
			String	strDirTomador;
       		String 	strObservaciones;
   }
    
}