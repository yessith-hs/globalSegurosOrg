trigger ActualizarSenalPolizasEnCuentas_tgr on Poliza__c (after delete, after insert,after update) {
    
    ActualizarSenalPolizasEnCuentas_cls objClase = new ActualizarSenalPolizasEnCuentas_cls();
     
    List<Poliza__c> lstPolizas         = Trigger.new;
    // Si el proceso es de iserción 
    if(Trigger.isInsert  || Trigger.isUpdate){ 
        objClase.procesarActualziacion(lstPolizas);   
    }
    
    if(Trigger.isDelete ){ 
        lstPolizas         = Trigger.old;
        objClase.procesarActualziacion(lstPolizas);   
    }
}