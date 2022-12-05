/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Sergio Andres Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Probar la clase NotificarCampana_ctr y verificar que cada uno de sus métodos cumpla efectivamente su tarea.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha 			Autor 				Descripción
-------------------------------------------------------------------------------------------------------
1.0 14/05/2014 	Sergio Andres Ortiz 	Creación de la clase.
2.0 09/09/2021 	Christian Tovar			Modificación para campañas activar y desactivar hijas
*******************************************************************************************************************/

@isTest
public class NotificarCampana_tst {
	
  	public static testMethod void myUnitTest() {
        //carga de datos desde CreaData_tst
     	Campaign objCampana = CreaData_tst.metCampana();
  		
   		//instancia de la Clase NotificarCampana_ctr
   	    System.PageReference p = Apexpages.currentPage();       	     
       	ApexPages.Standardcontroller controller;
       	
		//carga de datos simulados por la URL
       	p.getParameters().put( 'def_Campaign_id', objCampana.Id );
       	p.getParameters().put( 'def__descrip', objCampana.Description );
       	p.getParameters().put( 'def_CodigoCampana', '122' );
       	p.getParameters().put( 'def_isActiva', '1' );
       	p.getParameters().put( 'def_ciudad', 'Bogotá' );
       	p.getParameters().put( 'def_Activar', 'No' );
      
		//llamado a los metodos de la clase.
		NotificarCampana_ctr PruebaNotiCampana = new NotificarCampana_ctr(Controller);	
		PruebaNotiCampana.actualizar();		
		PruebaNotiCampana.refrescar();
		
		
		//carga de datos desde CreaData_tst
     	objCampana = CreaData_tst.metCampana2();		
       	
		//carga de datos simulados por la URL
       	p.getParameters().put( 'def_Campaign_id', objCampana.Id );
       	p.getParameters().put( 'def__descrip', objCampana.Description );
       	p.getParameters().put( 'def_CodigoCampana', '122' );
       	p.getParameters().put( 'def_isActiva', '0' );
       	p.getParameters().put( 'def_ciudad', 'Bogotá' );
       	p.getParameters().put( 'def_Activar', 'Si' );
      
		//llamado a los metodos de la clase.
		PruebaNotiCampana = new NotificarCampana_ctr(Controller);	
		PruebaNotiCampana.actualizar();		
		PruebaNotiCampana.refrescar();
        
        //carga de datos simulados por la URL
       	p.getParameters().put( 'def_Campaign_id', objCampana.Id );
       	p.getParameters().put( 'def__descrip', objCampana.Description );
       	p.getParameters().put( 'def_CodigoCampana', '122' );
       	p.getParameters().put( 'def_isActiva', '0' );
       	p.getParameters().put( 'def_ciudad', 'Bogotá' );
       	p.getParameters().put( 'def_Activar', 'No' );
      
		//llamado a los metodos de la clase.
		PruebaNotiCampana = new NotificarCampana_ctr(Controller);	
		PruebaNotiCampana.actualizar();		
		PruebaNotiCampana.refrescar();
		
		
		//carga de datos desde CreaData_tst
     	objCampana = CreaData_tst.metCampana3();	
       	
		//carga de datos simulados por la URL
       	p.getParameters().put( 'def_Campaign_id', objCampana.Id );
       	p.getParameters().put( 'def__descrip', objCampana.Description );
       	p.getParameters().put( 'def_CodigoCampana', '122' );
       	p.getParameters().put( 'def_isActiva', '1' );
       	p.getParameters().put( 'def_ciudad', 'Bogotá' );
       	p.getParameters().put( 'def_Activar', 'Si' );
      
		//llamado a los metodos de la clase.
		PruebaNotiCampana = new NotificarCampana_ctr(Controller);	
		PruebaNotiCampana.actualizar();		
		PruebaNotiCampana.refrescar(); 
        
        //carga de datos simulados por la URL
       	p.getParameters().put( 'def_Campaign_id', objCampana.Id );
       	p.getParameters().put( 'def__descrip', objCampana.Description );
       	p.getParameters().put( 'def_CodigoCampana', '122' );
       	p.getParameters().put( 'def_isActiva', '1' );
       	p.getParameters().put( 'def_ciudad', 'Bogotá' );
       	p.getParameters().put( 'def_Activar', 'No' );
      
		//llamado a los metodos de la clase.
		PruebaNotiCampana = new NotificarCampana_ctr(Controller);	
		PruebaNotiCampana.actualizar();		
		PruebaNotiCampana.refrescar(); 
    }
}