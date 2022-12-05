trigger DisparadorOportunidad_tgr on Opportunity (before insert) {
    //Se actualiza el dato de contacto comercial de la oportunidad con el dato de contacto de la cuenta realcionda y que tenga el mismo owner
    //No está contemplado el procesamiento masivo
    if(trigger.new[0].Datos_Contacto_Comercial__c == null){
        list<DatosContactoComercial__c> lstDC = [
            Select 	Id
            From 	DatosContactoComercial__c
            Where	Cuenta__c = :trigger.new[0].AccountId And
            		OwnerId = :trigger.new[0].OwnerId
		];
        
        if(!lstDC.isEmpty())
            trigger.new[0].Datos_Contacto_Comercial__c = lstDC[0].Id;
    }
}