/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Dolly Fierro Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Probar la clase Cotizador_ctr.cls y verificar que cada uno de sus métodos cumpla efectivamente su tarea.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha 			 Autor 		 		 Descripción
-------------------------------------------------------------------------------------------------------
1.0 08/07/2014 		Julio Mario Moreno 	Creación de la clase.	
*******************************************************************************************************************/
@isTest
private class Mail_tst {

    static testMethod void myUnitTest() {
    	list<String> emails = new list<String>();
    	emails.add('prueba@gmail.com');
    	emails.add('jbc@prueba.com');
        Mail_ctr objMail = new Mail_ctr();
        objMail.sendMail('jbc@prueba.com','sujeto','mensaje');
        objMail.sendMail(emails,'body','reply to','diplay name','sujeto');
        objMail.getTemplateSubject();
        objMail.getTemplateNotifi('error');
        objMail.Activate();
    }
}