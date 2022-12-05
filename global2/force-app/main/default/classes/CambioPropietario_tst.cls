@isTest
private class CambioPropietario_tst {

    static testMethod void myUnitTest() {
        Lead lead = new Lead();
        lead.Usuario_owners2__c = System.Userinfo.getUserId();
        lead.Email = 'usuario@dominio.comm';
        lead.Phone = '2345678';
        lead.FirstName = 'nombre';
        lead.LastName = 'apellido';
        insert lead;
    }
}