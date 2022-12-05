trigger LlenarCostoMateriales_tgr on Materiales_x_Campanas__c(after update, after delete) {

	if(trigger.isupdate) {
	   
	   LlenarCostoMateriales_cls.CostosMateriales(trigger.new);
	}else{
		LlenarCostoMateriales_cls.CostosMateriales(trigger.old);
	}

	//LlenarCostoMateriales_cls.CostosMateriales(trigger.new);
}