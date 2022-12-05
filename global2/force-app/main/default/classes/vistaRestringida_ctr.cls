public with sharing class vistaRestringida_ctr {
    
    public Boolean vistaPRM {get;set;}   // Indicador para desplegar la vista restringida de cuenta 
    public double numerOptys {get;set;}
    public id IdCuenta;

    public final Account acct;
    
    public vistaRestringida_ctr(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
    }
    
    public pageReference ValidaUser(){
    
system.debug('*****\n   system.Userinfo.getUserId(): '+system.Userinfo.getUserId());
system.debug('*****\n     acct.Id: '+acct.Id);
            
        pageReference P = new pageReference('/'+acct.Id+'?nooverride=1');//+'?nooverride'isdtp=mn&
        IdCuenta=acct.id;
        P.setRedirect(true);
        User U = new User();
        Account A = new Account();
        numerOptys=0;
        
        //numerOptys=[SELECT COUNT() from Opportunity Where OwnerId =:system.Userinfo.getUserId() and AccountId=:acct.Id];
        numerOptys=[SELECT COUNT() from Poliza__c Where OwnerId =:system.Userinfo.getUserId() and (Nombre_Tomador__c=:acct.Id or NombreBeneficiario__c=:acct.Id   or NombreDesignado__c=:acct.Id)];
        U = [SELECT Id,IsActive,IsPortalEnabled,ProfileId,UserType FROM User where Id =:system.Userinfo.getUserId()];
        A = [SELECT Id,OwnerId FROM Account WHERE Id=:acct.Id];
        if(U.UserType=='PowerPartner'){
            if(U.Id == A.OwnerID || numerOptys>0){
                vistaPRM=false;
                
                return P;           
            }
            else
            {
                vistaPRM=true;
                
            }
        } 
        else
        {
            vistaPRM=false;
system.debug('*****\n     vistaPRM: '+vistaPRM);
            
            return P;           
        }
system.debug('*****\n     vistaPRM: '+vistaPRM);
        return null;
    }
    
    public pageReference nuevaOpty(){
        pageReference Pg = new pageReference('/006/e?accid='+IdCuenta);//+'?nooverride'
        Pg.setRedirect(true);
        return Pg;
    }

    public list<Poliza__c> getlstPolizas(){
    	system.debug('system.Userinfo.getUserId-->'+system.Userinfo.getUserId());
        list<Poliza__c> lstPol = new list<Poliza__c>();
        lstPol=[SELECT Id, Name, RecordTypeId, N_PolizaPlan__c, Estado__c, NumeroSolicitud__c, ProductoPlan__c, FechaInicioVigencia__c, Nombre_Tomador__c, NombreDesignado__c
                FROM Poliza__c 
                WHERE OwnerId=:system.Userinfo.getUserId()
                      and (Nombre_Tomador__c=:acct.Id OR
                      Asegurado__c=:acct.Id  OR
                      NombreBeneficiario__c=:acct.Id  OR
                      NombreColegio_Jardin__c=:acct.Id  OR
                      NombreDesignado__c=:acct.Id  OR
                      Nombre_Tomador__c=:acct.Id)];
        return lstPol;
        
        
        
        
        
    }
    public list<Opportunity> getlstOptys(){
		User objUser = [Select AccountId From User Where Id=:Userinfo.getUserId()];
	    String IdCuentaUsuarioComunidad=objUser.AccountId;
		    	
        list<Opportunity> lstOpt = new list<Opportunity>();
        lstOpt=[SELECT AccountId,Amount,CloseDate,Id,Name,OwnerId,StageName 
        		FROM Opportunity
        		where OwnerId=:system.Userinfo.getUserId() and AccountId=:this.acct.id order by CloseDate DESC limit 100];
        		//where OwnerId=:system.Userinfo.getUserId() and AccountId=:IdCuentaUsuarioComunidad order by CloseDate DESC limit 100];
        return lstOpt;
    }
    
}