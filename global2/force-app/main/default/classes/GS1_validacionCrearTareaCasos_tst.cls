@isTest
private class GS1_validacionCrearTareaCasos_tst 
{
	
        Static Product2 objProduct2 {get;set;}
        Static Poliza__c objPoliza {get;set;}
        Static Case objCaso {get;set;}
        Static Task objTarea {get;set;}
        Static Task objTarea2 {get;set;}

	public static void crearData() 
	{
                
                objProduct2 = new Product2();
                objProduct2.Name = 'ProductoPrueba';
                objProduct2.ProductCode = '112';
                objProduct2.CodigoRamo__c = '69';
                objProduct2.Compania__c   = 'Global Seguros';
                objProduct2.IsActive      = true;
                insert objProduct2;

                objPoliza = new Poliza__c();
                objPoliza.EmpresaProducto__c = 'Global Seguros';
                objPoliza.EstadoPago__c = 'Realizado';
                objPoliza.Estado__c = 'Poliza emitida';
                objPoliza.FechaEmision__c = System.today();
                objPoliza.FormadePago__c = 'ANUAL';
                objPoliza.ProductoPlan__c = objProduct2.id;
                insert objPoliza;
                System.debug('***Poliza__c ' + objPoliza);

		objCaso = new Case();
		objCaso.estadoSemaforo__c = 'Verde';
                objCaso.FechaHoraRecibido__c = datetime.newInstanceGmt(2014, 04, 15, 15, 00, 0);
                ObjCaso.Status = 'Abierto';
                ObjCaso.Poliza__c = objPoliza.id;
                ObjCaso.Producto__c = 'Seguro Educativo';
                ObjCaso.Compania__c = 'Global Seguros';
                ObjCaso.RecordTypeId = [SELECT Id,Name FROM RecordType WHERE Name = 'Global Seguros' AND SobjectType = 'Case'].id;
                insert objCaso;
                System.debug('---------------------objCaso-------------'+objCaso);

                //objTarea.CreatedDate = datetime.newInstanceGmt(2014, 04, 16, 12, 10, 0);
                objTarea = new Task();
                objTarea.estadoSemaforo__c = 'Verde';
                objTarea.Status = 'Open';
                objTarea.Priority = 'Normal';
                objTarea.WhatId = objCaso.id;
                insert objTarea;
                System.debug('==========Tarea1============\n'+objTarea);

                objTarea2 = new Task();
                objTarea2.estadoSemaforo__c = 'Verde';
                objTarea2.Status = 'Open';
                objTarea2.Priority = 'Normal';
                objTarea2.WhatId = objCaso.id;
                insert objTarea2;
                System.debug('==========Tarea2============\n'+objTarea2);

	}

	static testMethod void test_method_one() {
		crearData();

                ObjCaso.Status = 'Cerrado';
                update ObjCaso;

                Task objTarea3 = new Task();
                objTarea3.estadoSemaforo__c = 'Verde';
                objTarea3.Status = 'Open';
                objTarea3.Priority = 'Normal';
                objTarea3.WhatId = objCaso.id;
                //insert objTarea3;
                System.debug('==========Tarea3============\n'+objTarea3);
	}
	
}