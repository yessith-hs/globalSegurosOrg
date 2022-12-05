trigger InfomarCamana_tgr on Campaign (after insert) {

 //definicion del objeto Campaña
       Campaign objCampanaNew;

       if (System.Trigger.isInsert) {
           objCampanaNew = System.Trigger.new.get(0); 
            if(objCampanaNew.ParentId == null){    
           		NotificarCampana_ctr.notificarCampana(objCampanaNew.id);
            }                      
       }
  	 system.debug('@@newCamapna->'+objCampanaNew);
}