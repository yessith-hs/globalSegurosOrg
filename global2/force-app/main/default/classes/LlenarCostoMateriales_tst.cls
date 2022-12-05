@isTest
private class LlenarCostoMateriales_tst {

		public static testMethod void myUnitTest() {
        //carga de datos desde CreaData_tst
     	//Campaign objCampana = CreaData_tst.metCampana();

     	//Creacion del Objeto Campaña
    	
    	Ciudades__c objCiudad			= new Ciudades__c(); 
    	objCiudad.Name					= 'ciudad1';
    	objCiudad.esmunicipio__c		= true;
    	objCiudad.espais__c				= false;
    	objCiudad.EsRegion__c			= false;
    	objCiudad.EsDepartamento__c		= false;
    	insert objCiudad;
    	
        Campaign objCampana = new Campaign();
        objCampana.Description          = 'mensaje de descripcion.';
        objCampana.CodigoCampana__c     = '0011';
        objCampana.Ciudad__c            = objCiudad.Id;
        //objCampana.Codigoramo__c = 013;
        objCampana.Name                 = 'Campana Name';
        objCampana.isActive = true;

        insert objCampana;
      

      	Materiales__c objMateriales = new Materiales__c();
        objMateriales.Costo__c = 5454; 
        //objMateriales.NombreMaterial__c = 'safafaf';
        insert objMateriales;

		List<Materiales_x_Campanas__c> ListMaterialesXCampania = new List<Materiales_x_Campanas__c>();

     	Materiales_x_Campanas__c objMaterialesCampanas = new Materiales_x_Campanas__c();
     	 // Creando Materiales X Campaña
     	objMaterialesCampanas.Costo__c 	= 200;
     	objMaterialesCampanas.Campana__c = objCampana.Id;
     	objMaterialesCampanas.NombreMaterial__c = objMateriales.Id;
     	//objMaterialesCampanas.NombreMaterial__c = 'sadasda';
        
		ListMaterialesXCampania.add(objMaterialesCampanas);

		insert ListMaterialesXCampania;

		for(Materiales_x_Campanas__c rMC : ListMaterialesXCampania){
			rMC.Costo__c 				= 500;
			rMC.Campana__c 				= objCampana.Id;
     		rMC.NombreMaterial__c 		= objMateriales.Id;
			//objMaterialesCampanas.NombreMaterial__c = 'sadasda';
		}
		update ListMaterialesXCampania;

		delete ListMaterialesXCampania;
     	//llamado a los metodos de la clase.
		//LlenarCostoMateriales_cls PruebaLlenarCostoMateriales = new LlenarCostoMateriales_cls();

	}
	
}