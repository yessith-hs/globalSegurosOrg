public  class LlenarCostoMateriales_cls {

    public static Decimal Total {get; set;}
    //public static List<Materiales_x_Campanas__c> ListIdCampania {get; set;}
    public static Map<string, Decimal> MapCampania;


    //public LlenarCostoMateriales_cls() {

    //}

    public static void CostosMateriales(List<Materiales_x_Campanas__c> ListCostos){

        MapCampania = new Map<string, Decimal>();
        
        Set<Id> setCampaniaId = new Set<Id>();

        decimal dcCostosMaterial = 0;

        for(Materiales_x_Campanas__c RMaterialesCampania : ListCostos) {
            system.debug('setCampaniaId-------->' + setCampaniaId);
           setCampaniaId.add(RMaterialesCampania.Campana__c);
        }

        List<Campaign> lstMxC =[Select id,(SELECT id, Costo__c,Campana__c FROM Materiales_x_Campa_as__r) from Campaign where id in : setCampaniaId];

        list<Campaign> listCampana;

        for(Campaign objCampania : lstMxC) {
            
            Total=0;     
            
            for(Materiales_x_Campanas__c RMaterialesCampania : objCampania.Materiales_x_Campa_as__r) {

                dcCostosMaterial = (RMaterialesCampania.Costo__c <> null) ? RMaterialesCampania.Costo__c : 0;  
                system.debug('RMaterialesCampania-------->' + RMaterialesCampania);
               //if(setCampaniaId.Contains(RMaterialesCampania.Campana__c)) {

                Total = Total + dcCostosMaterial;

                system.debug('RMaterialesCampania.Costo__c-------->' + dcCostosMaterial);
                
                system.debug('Total-------->' + Total);

                
                MapCampania.put(RMaterialesCampania.Campana__c, Total);
                 system.debug('MapCampania-------->' + MapCampania); 
               /*}else{

                Total=0;
                MapCampania.put(RMaterialesCampania.Campana__c, Total);
               }
                */
                
            }
                listCampana = new list<Campaign>();
                Campaign objCamp;
                system.debug('objCampania.id-------->' + objCampania.id);
                objCamp =  new Campaign();
                objCamp.Id = objCampania.id;
                objCamp.CostoMateriales__c = Total;
                listCampana.add(objCamp);

                system.debug('listCampana-------->' + listCampana);

        }
            
        update listCampana;
        //
        //for(Id  IdCampania : setCampaniaId) {
        //}

    }
}