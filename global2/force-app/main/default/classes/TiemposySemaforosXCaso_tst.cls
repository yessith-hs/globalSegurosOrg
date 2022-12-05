/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Sergio Andres Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Probar la clase TiemposSemaforo_tst y verificar que cada uno de sus métodos cumpla efectivamente su tarea.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha 	   Autor 				Descripción
-------------------------------------------------------------------------------------------------------
1.0 11/04/2014 Sergio Andres Ortiz Creación de la clase.
2.0 10/07/2014 Julio Mario Moreno  Modificación de la clase.

*******************************************************************************************************************/

@isTest


public class TiemposySemaforosXCaso_tst {
	
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
		Case objCaso = new Case();
        objCaso.estadoSemaforo__c       							= 'Verde';
        objCaso.FechaHoraRecibido__c    							= datetime.newInstanceGmt(2014, 04, 15, 15, 00, 0);
        objCaso.Asuntos__c               							= objAsunto.Name;
        objCaso.Poliza__c											= objPoliza.id;
        objCaso.Producto__c											= objAsunto.Producto__c;
        //objCaso.Compania__c											= objPoliza.EmpresaProducto__c;
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
   		system.debug('objPoliza-2->'+objPoliza);
   		system.debug ('la poliza' + objPoliza);
   		list<Poliza__c> lstPoliza = [select Name,EmpresaProducto__c from Poliza__c where id=:objPoliza.id];
   		system.debug('lstPoli3za-->'+lstPoliza);
   		system.debug ('la poliza query' + lstPoliza[0].EmpresaProducto__c);
   		Case objCaso 												= new Case();
   		objCaso														= createCase (objAsunto,objPoliza);
   		//carga de datos de un caso y asunto desde la clase CreaData   
		//Asuntos__c objAsunto = CreaData_tst.metAsunto(ObjUser.id);
		//Case objCaso = CreaData_tst.metCaso(ObjAsunto.id,objPoliza.id);		
						
   		Map<Id, Asuntos__c> mapAsuntos = new Map<Id, Asuntos__c>();
   		mapAsuntos.put(objAsunto.id, objAsunto);
   		
   		Map<Id, User> mapUsuarios = new Map<Id, User>();
   		mapUsuarios.put(objUser.id, objUser);
   		
   		//instancia de la Clase TiemposSemaforo_cls
		TiemposySemaforosXCaso_cls PruebaCaso = new TiemposySemaforosXCaso_cls(mapAsuntos, mapUsuarios);   			
		
   		//llamado a los metodos de la clase.   		   		   		
   		PruebaCaso.getTiempoTranscurridoXCaso(objCaso); 
   		PruebaCaso.setEstadoSemaforoXCaso(objCaso);  		
   		PruebaCaso.getEstadoSemaforoXCaso(objCaso);   		
   		
   		Case objCaso2 												= new Case();
        objCaso2													= createCase (objAsunto,objPoliza);
        
        //carga de datos de un segundo caso  
   		//Case objCaso2 = CreaData_tst.metCaso2(ObjAsunto.id);		
						
   		//instancia de la Clase TiemposSemaforo_cls
		TiemposySemaforosXCaso_cls PruebaCaso2 = new TiemposySemaforosXCaso_cls();   			
		
   		//llamado a los metodos de la clase.   		   		   		
   		PruebaCaso2.getTiempoTranscurridoXCaso(objCaso2); 
   		PruebaCaso2.setEstadoSemaforoXCaso(objCaso2);  		
   		PruebaCaso2.getEstadoSemaforoXCaso(objCaso2);   		
   		
   		
   		//llamada la la creacion y notificacion de campañas.
   		NotificarCampana_tst.myUnitTest();
 		  	
   		/*
   		TiemposySemaforosXCaso_cls PruebaCaso = new TiemposySemaforosXCaso_cls();   		
		Case objCaso = [select CaseNumber,Id,estadoSemaforo__c,CreatedDate,ClosedDate,FechaHoraRecibido__c,Asunto__c from case where id='500110000021ekHAAQ'];						
		PruebaCaso.getTiempoTranscurridoXCaso(objCaso);   		
		PruebaCaso.getEstadoSemaforoXCaso(objCaso);
		PruebaCaso.setEstadoSemaforoXCaso(objCaso);
   		*/   		                                       
    }
}