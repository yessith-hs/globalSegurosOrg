/****************************************************************************************************
    Información general 
    --------------------
    Desarrollado por:   Avanxo Colombia
    Autor:              Luis Rafael Peñaranda.
    Proyecto:           Global Seguros (CRM)
    Descripción:        invocador de visualizacion del Cotizador al hacer click sobre la cotizacion 
    
    Información sobre cambios (Versiones)  
    -------------------------------------
    Número  Fecha       Autor                       Descripción
    ------  ----------  --------------------------  -----------
    1.0     08-05-2014  Luis Rafael Peñaranda       Creacion.
    ****************************************************************************************************/
public class GetUrlCotizador_cls {  
    
    public Opportunity objOpportunity;
    public String urlCot3{get; set;}
    public String urlCotizadorTres{get; set;}
    public String descCotizadorTres{get; set;}
    public String paramCotizadorTres{get; set;}

    public Account accTomador=null;
    public Account accAcudiente=null;
    public Account accAsegurado=null;
    public Account accBeneficiario=null;    

    /*Encontar*/
    public String  getListaCotizadores(String idOportunidad, String strNumeroCotizacion,String strProductoComercial){
        
        String codigoProductoComercial  = strProductoComercial;
        String UrlCotizador=null;
        system.debug('codigoProductoComercial-->'+strProductoComercial);
        if(codigoProductoComercial != null) {
            RelacionProductoCotizador__c prodCotizador  = RelacionProductoCotizador__c.getInstance(codigoProductoComercial);
            system.debug('prodCotizador-->'+prodCotizador);
            if(prodCotizador != null){
                    String codCotizador = prodCotizador.ListaCotizadore__c;
                    URLCotizador__c cot = URLCotizador__c.getInstance(codCotizador); 
                    urlCotizadorTres        =   cot.URL__c;
                    descCotizadorTres       =   cot.Descripcion__c;
                    paramCotizadorTres      =   this.setParametrosURL(idOportunidad,strNumeroCotizacion);
                    UrlCotizador=urlCotizadorTres+paramCotizadorTres;
            }   
        }
        return UrlCotizador;
    }
   
    /*Construir el URL para la invocación del Cotizador respectivo*/
    public String setParametrosURL(String idOportunidad,String strNumeroCotizacion){
        system.debug('Entro a encriptar -->'+idOportunidad+'-----'+strNumeroCotizacion);
        
            ParametrosURL objParametrosURL = new ParametrosURL();
            objOpportunity = [ SELECT AccountId,BeneficiarioAsegurado__c,Designado__c,Name,AuxiliarIdentificador__c FROM Opportunity where id=:idOportunidad];
            if(objOpportunity.AccountId != null)                    accTomador      =this.getCuenta(objOpportunity.AccountId);
            if(objOpportunity.Designado__c != null)                 accAcudiente    =this.getCuenta(objOpportunity.Designado__c);
            if(objOpportunity.BeneficiarioAsegurado__c != null)     accBeneficiario =this.getCuenta(objOpportunity.BeneficiarioAsegurado__c);
            
            String parametrosURL;
             
            objParametrosURL.strUsuarioSalesforce                       =   'USFR='     +   userinfo.getUserName(); 
            objParametrosURL.strNumeroOportunidad                       =   '&NOPP='    +   objOpportunity.AuxiliarIdentificador__c; 

            objParametrosURL.strNumeroCotizacion    =   '&NCOT='    +   strNumeroCotizacion;
    
            
            objParametrosURL.strTipoIdentificacionTomador               =   '&TIDT='    +   getCodigoTipoDocumento(accTomador.TipoDocumento__c);
            objParametrosURL.strNumeroIdentificacionTomador             =   '&NIDT='    +   accTomador.NumeroDocumento__c ;         
            objParametrosURL.strNombresTomador                          =   '&NOMT='    +   accTomador.Firstname ;
            if(accTomador.LastName != null && accTomador.LastName != '' && accTomador.LastName!= ' '){
                objParametrosURL.strPrimerApellidoTomador                   =   '&PAPT='    +   accTomador.LastName;
            }else{
                objParametrosURL.strPrimerApellidoTomador                   =   '&PAPT=';
            }
            if(accTomador.SegundoApellido__c != null && accTomador.SegundoApellido__c != '' && accTomador.SegundoApellido__c!= ' '){    
                objParametrosURL.strSegundoApellidoTomador                  =   '&SAPT='    +   accTomador.SegundoApellido__c;
            }else{
                objParametrosURL.strSegundoApellidoTomador                  =   '&SAPT=';
            }
            system.debug('accTomador.PersonBirthdate-->'+accTomador.PersonBirthdate);
            if(accTomador.PersonBirthdate != null){
                Datetime tomadorFechanacimiento = datetime.newInstance(accTomador.PersonBirthdate.year(), accTomador.PersonBirthdate.month(),accTomador.PersonBirthdate.day());
                objParametrosURL.strDiaNacimiento                       =   '&DNAT='    +   tomadorFechanacimiento.dayGmt();
                objParametrosURL.strMesNacimientoTomador                =   '&MNAT='    +   tomadorFechanacimiento.monthGmt();
                objParametrosURL.strAnoNacimientoTomador                =   '&ANAT='    +   tomadorFechanacimiento.yearGmt();
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
            
            if(accTomador.Ocupacion__pc != null ){  
                objParametrosURL.strActividadTomador                        =   '&ACTT='    +   accTomador.Ocupacion__pc;
            }else{
                objParametrosURL.strActividadTomador                        =   '&ACTT=';
            }
            
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
                
                objParametrosURL.strNumeroIdentificacionBeneficiario    =   '&NIDB='    +   accTomador.NumeroDocumento__c != null? accTomador.NumeroDocumento__c: '';
                objParametrosURL.strNombresBeneficiario                 =   '&NOMB='    +   accTomador.Name != null? accTomador.Name: '';
                objParametrosURL.strPrimerApellidoBeneficiario          =   '&PAPB='    +   accTomador.LastName != null? accTomador.LastName: '';
                objParametrosURL.strSegundoApellidoBeneficiarior        =   '&SAPB='    +   accTomador.SegundoApellido__c != null? accTomador.SegundoApellido__c: '';
                
                    
                if(accTomador.PersonBirthdate != null){
                    Datetime benefFechanacimiento = datetime.newInstance(accBeneficiario.PersonBirthdate.year(), accBeneficiario.PersonBirthdate.month(),accBeneficiario.PersonBirthdate.day());            
                    objParametrosURL.strDiaNacimientoBeneficiario           =   '&DNAB='    +   benefFechanacimiento.dayGmt();
                    objParametrosURL.strMesNacimientoBeneficiario           =   '&MNAB='    +   benefFechanacimiento.monthGmt();
                    objParametrosURL.strAnoNacimientoBeneficiario           =   '&ANAB='    +   benefFechanacimiento.yearGmt();
                }else{
                    objParametrosURL.strDiaNacimientoBeneficiario           =   '&DNAB='    ;
                    objParametrosURL.strMesNacimientoBeneficiario           =   '&MNAB='    ;
                    objParametrosURL.strAnoNacimientoBeneficiario           =   '&ANAB=';
                }
            }else{
                objParametrosURL.strTipoIdentificacionBeneficiario      =   '&TIDB=';
                objParametrosURL.strNumeroIdentificacionBeneficiario    =   '&NIDB=';
                objParametrosURL.strNombresBeneficiario                 =   '&NOMB=';
                objParametrosURL.strPrimerApellidoBeneficiario          =   '&PAPB=';
                objParametrosURL.strSegundoApellidoBeneficiarior        =   '&SAPB=';
                objParametrosURL.strDiaNacimientoBeneficiario           =   '&DNAB='    ;
                objParametrosURL.strMesNacimientoBeneficiario           =   '&MNAB='    ;
                objParametrosURL.strAnoNacimientoBeneficiario           =   '&ANAB=';
            }
            
            parametrosURL = encriptarParametrosURL(objParametrosURL);
            
            system.debug('parametrosURL-->'+parametrosURL);
            return parametrosURL;   
    }
    
    
    /*Encriptar Parametros*/
     public String encriptarParametrosURL(ParametrosURL parObjParametrosURL){
        String cadenaPlana;
        String cadenaEncriptada;
        
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
                        parObjParametrosURL.strAnoNacimientoBeneficiario            ;
        
        system.debug('parametrosURLSinEncriptar-->'+cadenaPlana);               
        CifradoAES128_cls cfr = new CifradoAES128_cls();
        cadenaEncriptada = cfr.CifrarUtf8(cadenaPlana);
        
        system.debug('cadenaEncriptada-->'+cadenaEncriptada);    
        return cadenaEncriptada;
        
     }   
     
     
    /*obtener data de una cuenta*/
    public Account getCuenta(String idCuenta){
        Account objAccount;
        list<Account> lstobjAccount = [SELECT   SegundoApellido__c,Ocupacion__pc,DireccionCorrespondencia__c,Celular__c,Edad__pc,EstadoCivil__c,FirstName,IDPersona__c,Id_Externo__c,LastName,id,Genero__pc,
                                        Nacionalidad__c,Name,PersonBirthdate,PersonEmail,Phone,TipoDocumento__c,TipoDocumento__pc,NumeroDocumento__c                                        
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
   }
    
}