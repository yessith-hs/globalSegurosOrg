/*******************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Luis Macea Zabaleta
Proyecto:                Global     
Descripción:             Clase que implementa la lógica de negocio para realizar las siguientes operaciones
                         -Seleccionar una cuenta para la creacion de un caso.
                         
User history:          
Sprint                 
Release                 

Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     09/07/2014   Luis Macea Zabaleta            Creación de la clase.

*******************************************************************************/

       
public with sharing class AccountSelection_ctr
{    
	public Poliza__c objPoliza;
	private List<Account> lstBeneficiario;
	private List<Account> lstTomador;
	private List<Account> lstDesignado;
	private List<Account> lstAsegurado;	    
	public String strOpcion{ get; set; } 
	public String tipoReg ;  
	
	 /**
 	* @Method:      AccountSelection_ctr
 	* @param:       StandardController 
 	* @Description: Method to initialize the controller AccountSelection_ctr.
 	*/  
	public AccountSelection_ctr(ApexPages.StandardController controller)
	{	
		String  strIdPoliza 		=		ApexPages.currentPage().getParameters().get('id');	
		
		this.objPoliza				=		[Select NombreBeneficiario__c,Name,Nombre_Tomador__c,NombreDesignado__c,Asegurado__c,EmpresaProducto__c,ProductoCaso__c from Poliza__c where id=:strIdPoliza];
		System.debug('****this.objPoliza---->'+this.objPoliza);
		
		
		
		if(this.objPoliza.EmpresaProducto__c=='Global Seguros'){
			RecordType recordTypeContact 	= [SELECT Id FROM RecordType WHERE SobjectType = 'Case'  and DeveloperName  =:System.label.Gbc_TipoRegistroCasoGS];
			tipoReg=recordTypeContact.id;
		}else{
			RecordType recordTypeContact 	= [SELECT Id FROM RecordType WHERE SobjectType = 'Case'  and DeveloperName  =:System.label.Gbc_TipoRegistroCasoGE];
			tipoReg=recordTypeContact.id;
		}
		system.debug('tipoReg-->'+tipoReg);
		this.lstBeneficiario		=		[Select Name,Id,RecordTypeId from Account where id=:this.objPoliza.NombreBeneficiario__c];		
		
		this.lstTomador				=		[Select Name,Id,RecordTypeId from Account where id=:this.objPoliza.Nombre_Tomador__c];	
		
		this.lstDesignado			=		[Select Name,Id,RecordTypeId from Account where id=:this.objPoliza.NombreDesignado__c];
		
		this.lstAsegurado			=	    [Select Name,Id,RecordTypeId from Account where id=:this.objPoliza.Asegurado__c];
	}
	
	
	 /**
 	* @Method:      getItems
 	* @param:       N/A 
 	* @Description: Method for return the Account associated to policy.
 	*/  
	 public List<SelectOption> getItems()
	 {
         List<SelectOption> options		= new List<SelectOption>();
         
         for(Account objAcc:this.lstBeneficiario)
         	options.add(new SelectOption(objAcc.id,'Beneficiario - '+objAcc.Name));
         	
         for(Account objAcc:this.lstTomador)
         	options.add(new SelectOption(objAcc.id,'Tomador/Suscriptor - '+objAcc.Name));
         
         for(Account objAcc:this.lstDesignado)
         	options.add(new SelectOption(objAcc.id,'Acudiente/Designado - '+objAcc.Name));
         
         for(Account objAcc:this.lstAsegurado)
         	options.add(new SelectOption(objAcc.id,'Asegurado - '+objAcc.Name));  	
           	         
          return options;
     }
     
    /**
 	* @Method:      continuar
 	* @param:       N/A 
 	* @Description: Method   send the id  account for create the Case.
 	*/  
     public Pagereference continuar()
     {   
     	String strURL;    
		List<Account> lstAccount    =       [SELECT Name,RecordTypeId from Account where  Id=:this.strOpcion];
        TipoRegistroPersona__c tPersona     = TipoRegistroPersona__c.getInstance('Juridica');
        Contact cont =  getContactXAccount(this.strOpcion);
		system.debug('cont-->'+cont);

		system.debug('cont-->'+cont);
		system.debug('tPersona-->'+tPersona);
		system.debug('lstAccount-->'+lstAccount);
		if(lstAccount.get(0).RecordTypeId != tPersona.TipoRegistro__c || cont == null ){
			if(this.objPoliza.EmpresaProducto__c=='Global Seguros')
			{
				strURL = '/500/e?'+System.Label.Bbc_urlCrearCaso+'='+this.objPoliza.Name+'&'+System.Label.Bbc_urlCrearCaso+'_lkid='+this.objPoliza.Id+'&def_account_id='+this.strOpcion+'&'+System.Label.Bbc_idCampoCompania+'='+objPoliza.EmpresaProducto__c+'&'+System.Label.Gbc_ProductoCaso+'='+objPoliza.ProductoCaso__c+'&retURL='+objPoliza.Id+'&RecordType='+tipoReg;
			}else{
				//strURL = '/500/e?'+System.Label.Bbc_urlCrearCaso+'='+this.objPoliza.Name+'&'+System.Label.Bbc_urlCrearCaso+'_lkid='+this.objPoliza.Id+'&def_account_id='+this.strOpcion+'&'+System.Label.Gbc_ProductoCaso+'='+objPoliza.ProductoCaso__c+'&retURL='+objPoliza.Id+'&RecordType='+tipoReg;
				strURL = '/500/e?'+System.Label.Bbc_urlCrearCaso+'='+this.objPoliza.Name+'&'+System.Label.Bbc_urlCrearCaso+'_lkid='+this.objPoliza.Id+'&def_account_id='+this.strOpcion+'&retURL='+objPoliza.Id+'&RecordType='+tipoReg;
			}
     		
		}else{
			if(this.objPoliza.EmpresaProducto__c=='Global Seguros')
			{
				strURL = '/500/e?'+System.Label.Bbc_urlCrearCaso+'='+this.objPoliza.Name+'&'+System.Label.Bbc_urlCrearCaso+'_lkid='+this.objPoliza.Id+'&cas3='+cont.Name+'&def_account_id='+this.strOpcion+'&'+System.Label.Bbc_idCampoCompania+'='+objPoliza.EmpresaProducto__c+'&'+System.Label.Gbc_ProductoCaso+'='+objPoliza.ProductoCaso__c+'&retURL='+objPoliza.Id+'&RecordType='+tipoReg;
			}else{
				//strURL = '/500/e?'+System.Label.Bbc_urlCrearCaso+'='+this.objPoliza.Name+'&'+System.Label.Bbc_urlCrearCaso+'_lkid='+this.objPoliza.Id+'&cas3='+cont.Name+'&def_account_id='+this.strOpcion+'&'+System.Label.Gbc_ProductoCaso+'='+objPoliza.ProductoCaso__c+'&retURL='+objPoliza.Id+'&RecordType='+tipoReg;
				strURL = '/500/e?'+System.Label.Bbc_urlCrearCaso+'='+this.objPoliza.Name+'&'+System.Label.Bbc_urlCrearCaso+'_lkid='+this.objPoliza.Id+'&cas3='+cont.Name+'&def_account_id='+this.strOpcion+'&retURL='+objPoliza.Id+'&RecordType='+tipoReg;
			}			
		} 
     	PageReference pageRef =  new PageReference(strURL);     	
     	pageRef.setRedirect(true);     	
     	return pageRef;
     }
     
     
 /* Obtener contacto asociado a la cuenta mas receintemente cerado*/
 public static Contact getContactXAccount(String parIdCuenta){
 	system.debug('parIdCuenta-->'+parIdCuenta);
    list<Contact> listClave = [SELECT id,Name FROM Contact WHERE accountId=:parIdCuenta order by CreatedDate desc];    
    if(listClave.size()>0) {
            return listClave.get(0);
    }else{
        return null;
    }   
 }
	

	
}