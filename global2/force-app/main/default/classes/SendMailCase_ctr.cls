/*******************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Luis Macea Zabaleta
Proyecto:                Global     
Descripción:             Clase que implementa la lógica de negocio para realizar las siguientes operaciones
                         - Envio de Email  de notoficacion cuando se cierra un caso.
                         -  Cerrar un caso
User history:          
Sprint                 
Release                 

Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     19/05/2014   Luis Macea Zabaleta            Creación de la clase.
2.0		04/08/2014	 Manuel Medina Pérez			SendMailCase_ctr method updated.
													loadCase method updated
*******************************************************************************/

public  class SendMailCase_ctr
{
    public         String   strSubjectPrevious { get; set; }   
    public         Transient   Blob     blbAttachment{get;set;}
    public         String   strFilename{get;set;}
    public         String   strBodyPrevious{get;set;}
    public         Case     objCase{get;set;}
    public         String   strAditionalTo{get;set;}
    private        Contact  objContact;
    private        EmailTemplate objEmailTemplate;
           
    /**
    * @Method:      loadVouchers
    * @param:       StandardController 
    * @Description: Method to initialize the controller SendMailCase_ctr.
    */      
    public SendMailCase_ctr(ApexPages.StandardController controller)
    {   
        loadCase(ApexPages.currentPage().getParameters().get('id'));
        /*BEGIN - 20140804 Manuel Medina - Get emailtemplate taking Case's RecordTypeId */
        String recordTypeName = [SELECT DeveloperName
        							FROM RecordType
        							WHERE Id =: objCase.RecordTypeId
        							LIMIT 1
        						].DeveloperName;
        System.debug('@@--> recordTypeName > '+recordTypeName);
        String idTemplate = '';						
        if(recordTypeName.equals(System.Label.GBC_RecordTypeCasos)){
        	idTemplate = System.Label.Gbc_Email_Template;
        }else if(recordTypeName.equals(System.Label.GBC_RecordTypeCasos_Global_Education)){
        	idTemplate = System.Label.Gbc_Email_Template_GE;
        }        
        
        objEmailTemplate=[SELECT Id, Subject, Body, HtmlValue 
        					FROM EmailTemplate 
        					WHERE Id	=: idTemplate
        				];
        System.debug('@@--> Id Template > '+objEmailTemplate.Id);
        /*END - 20140804 Manuel Medina*/				
        loadContac(this.objCase.ContactId); 
        putFields(); 
        this.strAditionalTo='';        
    }
    
    
    /**
    * @Method:      loadCase
    * @param:       String 
    * @Description: Method to load  object case.
    */  
    public void loadCase(String  strIdcase)
    {      
      this.objCase=  [Select  c.Type,  c.SuppliedPhone, c.SuppliedName, c.SuppliedCompany, c.Status,
                       c.Reason, c.Producto__c,c.Mensaje_cierre_de_caso__c,c.ID, c.AccountId, c.RecordTypeId,
                       c.Poliza__c,c.Asuntos__c,  c.Origin, c.FechaHoraRecibido__c, c.Description,  c.CreatedDate,  c.ContactId,  c.CaseNumber
                         From Case c  where c.id=:strIdcase ];
    }  
    
     
    /**
    * @Method:      loadContac
    * @param:       String 
    * @Description: Method to load  object Contact.
    */  
    public void loadContac(String  strIdContact)
    {
      this.objContact=[Select c.SegundoApellido__c, c.Salutation,  c.ReportsToId,  c.Phone,  c.Name, c.MobilePhone,                       
                       c.LastName,   c.IsPersonAccount, c.IsEmailBounced,  c.IdExterno__c, c.Id, 
                       c.Genero__c,  c.FirstName, c.FechaVinculacion__c, c.Fax, c.EtapaVinculacion__c, 
                       c.EstadoAsesor__c, c.Especialidad__c, c.EmailBouncedReason, c.EmailBouncedDate, c.Email, c.Edad__c,
                       c.DireccionResidencia__c, c.DireccionOficina__c, c.Description, 
                       c.CreatedDate, c.Convenio__c, c.ContratoFirmado__c, c.Compania__c,
                       c.ClaveNo__c, c.Ciudad__c, c.CanalVenta__c, c.Birthdate, c.AreaDependencia__c, 
                       c.ApoyoInstitucional__c, c.Agencia__c, c.AccountId From Contact c where c.ID=:strIdContact]; 
    }       
    
    /**
    * @Method:      getContact
    * @param:       N/A 
    * @Description: Method to return  object Contact.
    */  
    public Contact getContact()
    {
        return this.objContact;
    } 
    
    /**
    * @Method:      send
    * @param:       N/A 
    * @Description: Method to send mail to the Contact of case.
    */  
    public Pagereference send()     
    {   
        Pagereference page=null;
        boolean senal=getTareasActivas(); 
        if(senal){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El caso tiene tareas activas, no puede cerrarse'));
	    }else{
	        if (blbAttachment!=null && blbAttachment.size()==0)
	        {       
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.Gbc_Error_Adjunto));       
	        }else{ 
	              if (blbAttachment!=null && this.blbAttachment.size()>9437184)
	              {
	                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.Gbc_Error_tamano_Adjunto));            
	              }else{       
	                 updateCase();               
	                 
	                 String strURL = '/'+objCase.Id;    
	                 page = new PageReference( strURL );
	                 page.setRedirect( true );
	                 
	                 // Define the email     
	                 Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();            
	                 Lead objLead = new Lead();
	                 if(test.isRunningTest()){  
	                 	objLead= [SELECT Lead.Id FROM Lead  where FirstName='HUGO']; 
						System.debug('<----'+objLead);                 	
	                 }else{
	                 	objLead= [SELECT Lead.Id FROM Lead  where Lead.Id=:System.Label.Gbc_IdLead]; 
	                 }
	                 
	                 Asuntos__c  objAsunto= getSender();
	                 System.debug('@@@ objeto asunto---->'+ objAsunto);  
	                 if(objAsunto!=null && objAsunto.Remitente__c !=null && objAsunto.Nombre_Remitente__c!=null )
	                 {
	                 	
	                  // email.setReplyTo(objAsunto.Remitente__c);
	                   System.debug('@@@ correo remitente---->'+objAsunto.Remitente__c);  
	                   
	                   List<OrgWideEmailAddress> lstOrgWideEmailId = [Select id from OrgWideEmailAddress where Address=: objAsunto.Remitente__c];
					   if(lstOrgWideEmailId.size() != 0)
					   {
					   	 System.debug('@@@ id correo organizacion ---->'+lstOrgWideEmailId[0].id); 		   	 
						 email.setOrgWideEmailAddressId(lstOrgWideEmailId[0].id); 
					   } 
	                   
	                   
	                 }  
	                 email.setTargetObjectId(objLead.ID);
	                 email.setSaveAsActivity(false);
	                 email.setWhatId(objCase.Id);
	                 email.setTemplateId(objEmailTemplate.ID); 
	                
	                 
	                       
	                 // Create the email attachment
	                 List<Messaging.EmailFileAttachment> lstFileAttachments;
	                 if(blbAttachment!=null)
	                 {
	                 	Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
	                 	efa.setFileName(strFilename);
	                 	efa.setBody(blbAttachment);
	                 	lstFileAttachments =new List<Messaging.EmailFileAttachment>{efa};
	                 }
	                 // Create the email Addresses
	                 List<string> lstToAddresses = new List<string>();
	                 if (this.objContact.Email != null)
	                 {    
	                    lstToAddresses.add(this.objContact.Email);        
	                 }
	                 
	                 // add emails aditionalTo
	                 System.debug('*********strAditionalTo---------->'+this.strAditionalTo);
	                 if(this.strAditionalTo!=null)
	                 {
	                   List<String> lstAditionalTo=this.strAditionalTo.split(',');
	                   System.debug('*********lstAditionalTo---------->'+lstAditionalTo);	
	                   for(String strMailAditional:lstAditionalTo)
	                   {
	                   	if(checkEmailFormat(strMailAditional))
	                   	{
	                   	 System.debug('*********strMailAditional---------->'+strMailAditional);	
	                     lstToAddresses.add(strMailAditional);
	                   	}
	                   }
	                 }       
	          
	                 // Sets the paramaters of the email    
	                 email.setToAddresses( lstToAddresses);
	                 if(blbAttachment!=null)
	                 {                
	                 	email.setFileAttachments(lstFileAttachments); 
	                 }    
	                 
	                 // Sends the email     
	                 if(!test.isRunningTest()) 
	                 Messaging.SendEmailResult [] msresult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
	                 insertTask();     
	            }
	        }
	      }
        return page;      
    }
    
     /**
    * @Method:      checkEmailFormat
    * @param:       String email 
    * @Description: Method for  check  Email Format.
    */  
    public  Boolean checkEmailFormat(String email) {
        String emailRegEx = '[a-zA-Z0-9\\.\\!\\#\\$\\%\\&\\*\\/\\=\\?\\^\\_\\+\\-\\`\\{\\|\\}\\~\'._%+-]+@[a-zA-Z0-9\\-.-]+\\.[a-zA-Z]+';
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
        Boolean result = MyMatcher.matches();
        return result;
    }
    
    
    public Asuntos__c getSender()
    {
        Asuntos__c objAsunto=null;
        list<Asuntos__c> lstAsuntos;
        list<Poliza__c> lstPoliza;
        // obtener la empresa de la póliza
        // ------------------------------
        if(this.objCase.Poliza__c!= null)
        {
            lstPoliza = [select EmpresaProducto__c from Poliza__c where id=:this.objCase.Poliza__c];
        }   
         System.debug('@@lista poliza---->'+lstPoliza );
         
          System.debug('@@lista caso ---->'+this.objCase.Producto__c +'  '+this.objCase.Asuntos__c+'   '+lstPoliza.get(0).EmpresaProducto__c);
        //Obtener el id del Asunto
        // ----------------------
        if(lstPoliza.size()>0)
        {
            lstAsuntos = [select id, remitente__c,Nombre_Remitente__c  from Asuntos__c
            where Producto__c   =: this.objCase.Producto__c 
                                    and Name     =: this.objCase.Asuntos__c
                                    and Empresa__c   =: lstPoliza.get(0).EmpresaProducto__c];
        }
          System.debug('@@lista asuntos---->'+lstAsuntos);
        if( lstAsuntos!=null &&lstAsuntos.size()>0)
        {
            objAsunto=lstAsuntos.get(0);
        }
        
        return objAsunto; 
    
    }
    
    /**
    * @Method:      updateCase
    * @param:       N/A 
    * @Description: Method to close the case.
    */ 
    public void updateCase()
    {       
       this.objCase.Status=System.Label.Gbc_EstatusCaso;
       update objCase;   
    }
    
    
    /**
    * @Method:      insertTask
    * @param:       N/A 
    * @Description: Method to create a Task case associated.
    */  
    public void insertTask()
    {
          Task objTask=new Task();
            String strAditional='';
            if(this.strAditionalTo!=null)
             {
               List<String> lstAditionalTo=this.strAditionalTo.split(',');
               System.debug('*********lstAditionalTo---------->'+lstAditionalTo);	
               for(String strMailAditional:lstAditionalTo)
               {
               	if(checkEmailFormat(strMailAditional))
               	{
               	 System.debug('*********strMailAditional---------->'+strMailAditional);	
                 strAditional=strAditional +' '+  strMailAditional;
               	}
               }
             } 
          
          
          String strBody        =   +'\n Adicional para: '+strAditional +'\n Archivo adjunto:'+this.strFilename+'\n'+strBodyPrevious.replaceAll('<[^>]+>',' ');
          strBody               =   strBody.replace('&nbsp;',' ');
          string   strComment   =   (objCase.Mensaje_cierre_de_caso__c==null) ? '' :objCase.Mensaje_cierre_de_caso__c ; 
          strBody               =   strBody+ strComment.replaceAll('<[^>]+>',' ');
          strBody               =   strBody.replace('&nbsp;',' ');              
          objTask.Subject       =   System.Label.Gbc_AsuntoTarea+strSubjectPrevious ;
          objTask.WhoId         =   objContact.Id;
          objTask.WhatId        =   objCase.Id; 
          objTask.Priority      =   System.Label.Gbc_PrioridadTarea;
          objTask.Description   =   strSubjectPrevious+'\n'+strBody;
          objTask.Status        =   System.Label.Gbc_StatusTarea;       
          objTask.ActivityDate  =   Date.today();       
          insert objTask;
          if(blbAttachment!=null){
            insertAttachment(objTask.ID);
          }
    }
    
    
    
    /**
    * @Method:      insertAttachment
    * @param:       N/A 
    * @Description: Method to create a Attachment Task associated.
    */  
    public void insertAttachment(String strIdTask)
    {
      Attachment objAttachment=new Attachment();
      objAttachment.Body=this.blbAttachment;
      objAttachment.Name=this.strFilename;
      objAttachment.ParentId=strIdTask;
      System.debug('<--- aca'+objAttachment);
      insert objAttachment;
    } 
    
     /**
    * @Method:      putFields
    * @param:       N/A 
    * @Description: Method to replace  the values objects.
    */   
   public void putFields()
   {    
        String strReplace;
        String strHTMLField;
        String replaceToken = '(?i)\\{!id\\}';
        this.strBodyPrevious        =       this.objEmailTemplate.HtmlValue;
        this.strSubjectPrevious     =       this.objEmailTemplate.Subject;
        
        Case objCaseConsulta        =       [SELECT AccountId,AssetId,Asuntos__c,BusinessHoursId,CaseNumber,
                                                    CiudadWeb__c,ClosedDate,Compania__c,ContactId,CorreoElectronicoGE__c,
                                                    CreatedById,CreatedDate,CurrencyIsoCode,Description,estadoSemaforo__c,
                                                    FechaHoraRecibido__c,Id,imagenSemaforo__c,IsClosed,IsClosedOnCreate,
                                                    IsDeleted,IsEscalated,LastModifiedById,LastModifiedDate,LastReferencedDate,
                                                    LastViewedDate,Mensaje_cierre_de_caso__c,Movil__c,Nombres__c,NombrProductoPlan__c,
                                                    NumeroDocumento__c,Origin,OtroTipo__c,OwnerId,ParentId,Poliza__c,Producto__c,
                                                    Reason,RecordTypeId,Status,Subject,SuppliedName,SuppliedPhone,SystemModstamp,
                                                    TipodeConsulta__c,TipoInformes__c,Tipo__c,Type FROM Case  where id=:objCase.Id]; 
        Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Case.fields.getMap();
         
        strReplace                  =       (this.objContact.Name!=null) ? this.objContact.Name  : '';           
        this.strBodyPrevious        =       this.strBodyPrevious.replace('{!Case.Contact}', strReplace);
        this.strSubjectPrevious     =       this.strSubjectPrevious.replace('{!Case.Contact}', strReplace); 


        this.strBodyPrevious        =       this.strBodyPrevious.replace('{!Case.Mensaje_cierre_de_caso__c}', '');


        List<Account> lstAccount    =       [SELECT Name from Account where  Id=:this.objCase.AccountId];
        strReplace                  =       (lstAccount.isEmpty()) ? '' : (lstAccount[0].Name!=null) ? lstAccount[0].Name : '';         
        this.strBodyPrevious        =       this.strBodyPrevious.replace('{!Case.Account}', strReplace);
        this.strSubjectPrevious     =       this.strSubjectPrevious.replace('{!Case.Account}', strReplace); 
        
        List<Poliza__c> lstPoliza   =       [SELECT Name from Poliza__c where  Id=:this.objCase.Poliza__c];
        strReplace                  =       (lstPoliza.isEmpty()) ? '' : (lstPoliza[0].Name!=null) ? lstPoliza[0].Name : ''; 
        this.strBodyPrevious        =       this.strBodyPrevious.replace('{!Case.Poliza__c}', strReplace);
        this.strSubjectPrevious     =       this.strSubjectPrevious.replace('{!Case.Poliza__c}', strReplace);   
        
        //List<Asuntos__c> lstAsunto  =       [SELECT Name from Asuntos__c where Id=:this.objCase.Asunto__c];
       /* List<Asuntos__c> lstAsunto  =       [SELECT Name from Asuntos__c ];
        strReplace                  =      (lstAsunto.isEmpty()) ? '' : (lstAsunto[0].Name!=null) ? lstAsunto[0].Name : '';
        this.strBodyPrevious        =       this.strBodyPrevious.replace('{!Case.Subject}', strReplace);
        this.strSubjectPrevious     =       this.strSubjectPrevious.replace('{!Case.Subject}', strReplace); */

        this.strBodyPrevious        =       this.strBodyPrevious.replace(']]>', '');  

        for (String fieldName: schemaFieldMap.keySet())
        {
          try { 
              
              strHTMLField  =   '(?i)\\{!Case.'+fieldName+'\\}';

              System.debug('\n\n>>>>>>>>>>>>>>>strHTMLField '+strHTMLField +'\n\n');
              strReplace   =    (objCaseConsulta.get(fieldName)!=null) ? String.valueOf(objCaseConsulta.get(fieldName))  : '';
              System.debug('\n\n>>>>>>>>>>>>>>>strReplace '+strReplace +'\n\n');
              this.strBodyPrevious        =       this.strBodyPrevious.replaceAll(strHTMLField, strReplace);
              this.strSubjectPrevious     =       this.strSubjectPrevious.replaceAll(strHTMLField, strReplace);   
            } catch (SObjectException e)    { 
                 
              }
        }
   
        
      
         
    } 
    public boolean getTareasActivas()
    {
    	boolean senal=false;
    	list<Task> lstTask =[SELECT Id,IsClosed,Status FROM Task 	WHERE WhatId	=: this.objCase.id ];
    	if(lstTask.size()>0) {
    		for(Task ta:lstTask){
    			if(ta.Status=='Abierto'){
    				senal=true;
    			}	
    		}
    	}else{
        	return false;
    	} 
    	return senal;  
    }  
}