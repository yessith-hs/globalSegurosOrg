/***************************************************************************************************************************
*** Desarrollado por:       Avanxo Colombia                                                                              ***
*** Autor:                  Daniel Lopez (DL)	                                                                         ***
*** Proyecto:               Global               	                                                                     ***
*** Descripcion:            Clase de prueba       																		 ***
*** User history:                                                                                                        ***
*** Sprint:                                                                                                              ***
*** Release:                                                                                                             ***
***                                                                                                                      ***    
*** Cambios (Versiones)                                                                                                  ***
*** -------------------------------------                                                                                ***
***             No.     Fecha           Autor                   Descripción                                              ***    
***            -----    ----------      --------------------    ---------------                                          ***
*** @version    1.0     2014-11-19     	Daniel Alexander Lopez  Class created                                            ***
***************************************************************************************************************************/

@isTest
private class GS1_CrearAlterarCampa_a_tst {
	
	public static string id;
	public static Campaign objCampana;
	
	//Metodo que crea la data necesaria para la prueba
	
	@isTest public static void createData()
	{

		Ciudades__c objCiudad			= new Ciudades__c(); 
    	objCiudad.Name					= 'ciudad1';
    	objCiudad.esmunicipio__c		= true;
    	objCiudad.espais__c				= false;
    	objCiudad.EsRegion__c			= false;
    	objCiudad.EsDepartamento__c		= false;
    	insert objCiudad;

		objCampana 			=new Campaign();
        objCampana.Description          ='mensaje de descripcion.';
        objCampana.CodigoCampana__c     ='0011';
        objCampana.Ciudad__c            =objCiudad.Id;
        objCampana.ExpectedResponse     =0.0;
        objCampana.Description          ='xxx';     
        objCampana.Name                 ='Campaña';
        objCampana.NumberSent			= 200.0;
        objCampana.RecordTypeId         =[SELECT Id FROM RecordType WHERE Name = 'Campaña' AND SobjectType = 'Campaign' LIMIT 1].id;
        objCampana.Producto__c          = '[Vida individual;Pensiones;Seguro educativo]';
        objCampana.FuerzaVentas__c      = '[AGENTES Y AGENCIAS;FV DIRECTA;DISTRIBUIDORES;INSTITUCIONAL Y BANCOS;BOGOTA]';
        objCampana.ActualCost           = 0.0;
        objCampana.Tipo__c              = '[CONFERENCIA;CONFERENCIA;CONFERENCIA;CONFERENCIA]';
        objCampana.isActive 			= true;
        insert objCampana;
        id = objCampana.id;

	
	}

	//Metodo que realiza la prueba de el controlador

	@isTest static void test_method_one() {

		createData();
		ApexPages.currentPage().getParameters().put('id', id);
		GS1_CrearAlterarCampa_a_ctr ctr = new GS1_CrearAlterarCampa_a_ctr();
		ctr.strproducto = 'Seguro educativo';
		ctr.strproductoElegido = 'Seguro educativo';
		ctr.ClickRightTipo();
		ctr.ClickLeftTipo();
		ctr.ClickRightProd();
		ctr.ClickLeftProd();
		ctr.ClickRight();
		ctr.ClickLeft();
		ctr.Save();
		
	}
//Metodo que prueba el controlador
@isTest static void test_method_two() {

		createData();
		id = '';
		ApexPages.currentPage().getParameters().put('id', id);
		GS1_CrearAlterarCampa_a_ctr ctr = new GS1_CrearAlterarCampa_a_ctr();
		ctr.lstEstadosCampaing.get(0);
		ctr.lstCompaniaCampaing.get(0);
		ctr.lstCuentaMayorCampaing .get(0);
		ctr.strfuerzaElegida='';
		ctr.tipoElegido='';
		ctr.strproducto = 'Seguro educativo';
		ctr.strproductoElegido = 'Seguro educativo';
		ctr.setFuerzaVentas();
		ctr.setProductos();
		ctr.Save();
	
	}
	// Metodo que prueba el controlador por los catch
@isTest static void test_method_tree() {

		createData();
		id = '';
		ApexPages.currentPage().getParameters().put('id', id);
		GS1_CrearAlterarCampa_a_ctr ctr = new GS1_CrearAlterarCampa_a_ctr();
		ctr.ClickRightTipo();
		ctr.ClickLeftTipo();
		ctr.ClickRightProd();
		ctr.ClickLeftProd();
		ctr.ClickRight();
		ctr.ClickLeft();
		
	
	}


}