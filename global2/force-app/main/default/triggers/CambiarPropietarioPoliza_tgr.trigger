trigger CambiarPropietarioPoliza_tgr on Poliza__c (before insert, before update) {
    map<String, String> mapIdPropietarios = new map<String, String>();
    set<String> setIdExternos = new set<String>();
     
    for(Poliza__c poliza :Trigger.new){
        if(poliza.Usuario_owners2__c!=null){
            setIdExternos.add(poliza.Usuario_owners2__c);  
        }
    }
    
    for(User usuarioPropietario : [Select id, CodigoUsuario__c From User Where CodigoUsuario__c in :setIdExternos]){
        mapIdPropietarios.put(usuarioPropietario.CodigoUsuario__c, usuarioPropietario.id);
    }
    
    for(Poliza__c poliza :Trigger.new){
        if(poliza.Usuario_owners2__c!=null && mapIdPropietarios.containsKey(poliza.Usuario_owners2__c)){
            poliza.OwnerId = mapIdPropietarios.get(poliza.Usuario_owners2__c);
        }
    }

}