/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Sergio Andres Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Probar la clase EjecutorBatchSemaforoCasos_sch y verificar que cada uno de sus métodos cumpla efectivamente su tarea.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha 		Autor 				Descripción
-------------------------------------------------------------------------------------------------------
1.0 15/05/2014 Sergio Andres Ortiz Creación de la clase.
2.0 10/07/2014 Julio Moreno		   Modificacion de la clase.
*******************************************************************************************************************/
@isTest()
public  class EjecutorBatchSemaforoCasos_tst {

	public static Asuntos__c createAsuntos (User objUser){
		Asuntos__c objAsunto 										= new Asuntos__c();
		objAsunto.Name												= 'FELICITACIONES';
        objAsunto.NHorasVerde__c        							= 1;
        objAsunto.NHorasAmarillo__c     							= 2;
        objAsunto.NHorasRojo__c         							= 3;
        objAsunto.NHorasMorado__c       							= 4;
        objAsunto.ResponsableAmarillo__c 							= objUser.id;
        objAsunto.ResponsableRojo__c    							= objUser.id;
        objAsunto.ResponsableMorado__c  							= objUser.id;
        objAsunto.Producto__c										= 'Vida Grupo';
        objAsunto.Empresa__c										= 'Global Seguros';
        insert objAsunto;
        return objAsunto;
	}
	
	public static Product2 createProduct(){
		Product2 objProduct2										= new Product2();
		objProduct2.Name											= 'prueba producto';
		objProduct2.IdentificadorProducto__c        				= 'GE698';
		objProduct2.ProductCode                          			= '60_1';
		objProduct2.Compania__c										= 'Global Seguros';
		insert objProduct2;
		return objProduct2;
	}
	
	public static Poliza__c  createPoliza (Product2 objProduct2){
		Poliza__c objPoliza											= new Poliza__c();
		objPoliza.Name												= 'Poliza';
		objPoliza.EmpresaProducto__c								= 'Global Seguros';
		objPoliza.ProductoPlan__c									= objProduct2.id;
		//objPoliza.Oportunidad__c									= objOpportunity.id;
		insert objPoliza;
		system.debug('objPoliza-1->'+objPoliza);
		return objPoliza;
	}
	
	public static Case createCase (Asuntos__c objAsunto,Poliza__c objPoliza){
		 	// 'SELECT CaseNumber,Id,estadoSemaforo__c,CreatedDate,ClosedDate,FechaHoraRecibido__c,Asunto__c 
		Case objCaso = new Case();
        objCaso.estadoSemaforo__c       							= 'Verde';
        objCaso.FechaHoraRecibido__c    							= datetime.newInstanceGmt(2014, 04, 15, 15, 00, 0);
        objCaso.Asuntos__c               							= objAsunto.Name;
        //objCaso.Asunto__c											= objAsunto.id;//verHoy
        objCaso.Poliza__c											= objPoliza.id;
        objCaso.Producto__c											= objAsunto.Producto__c;
        //objCaso.Compania__c											= objPoliza.EmpresaProducto__c;
        objCaso.FechaHoraRecibido__c								= Date.newInstance(2013, 5, 12);
        objCaso.estadoSemaforo__c									= 'Verde';
        insert objCaso;
        return objCaso;
	}
	
    static testMethod void myUnitTest() {
        User objUser = CreaData_tst.metUser();
   		Asuntos__c objAsunto 										= new Asuntos__c();
   		objAsunto													= createAsuntos(objUser);
   		Product2 objProduct											= new Product2();
   		objProduct													= createProduct();
   		Poliza__c objPoliza											= new Poliza__c();
   		objPoliza													= createPoliza (objProduct);
   		Case objCaso 												= new Case();
   		objCaso														= createCase (objAsunto,objPoliza);
        //llamada la la creacion y notificacion de campañas.
   		//NotificarCampana_tst.myUnitTest();
   		//ProcSemaforizacionCasosBatch_tst.myUnitTest();   		   	
   		EjecutorBatchSemaforoCasos_sch ejecutorSh = new EjecutorBatchSemaforoCasos_sch();
   		SchedulableContext sc;
   		ejecutorSh.execute(sc);
   		
    }
}