trigger CambiarPropietarioLead_tgr on Lead (before insert) {
	map<String, String> mapIdPropietarios = new map<String, String>();
	set<String> setIdExternos = new set<String>();
	
	system.debug('------------------------------------------Trigger.new '+Trigger.new);
	
	for(Lead candidato :Trigger.new){
		//system.debug('------------------------------------------Entro 1 ');
        if(candidato.Usuario_owners2__c!=null){
        	//system.debug('------------------------------------------Entro 2 '); 
            setIdExternos.add(candidato.Usuario_owners2__c);
        }
    }
    
    for(User usuarioPropietario : [Select id, CodigoUsuario__c From User Where CodigoUsuario__c in :setIdExternos]){
    	mapIdPropietarios.put(usuarioPropietario.CodigoUsuario__c, usuarioPropietario.id);
    }
    system.debug('------------------------------------------1 '+setIdExternos);
    system.debug('------------------------------------------2 '+mapIdPropietarios);
    for(Lead candidato :Trigger.new){
        if(candidato.Usuario_owners2__c!=null && mapIdPropietarios.containsKey(candidato.Usuario_owners2__c)){
            candidato.OwnerId = mapIdPropietarios.get(candidato.Usuario_owners2__c);system.debug('------------------------------------------3 '+candidato.OwnerId);
        }
    }

}