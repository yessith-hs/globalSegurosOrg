/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CifradoAES128_tst {

    static testMethod void myUnitTest() {
    	try{
    		CifradoAES128_cls objCifrado = new CifradoAES128_cls();
    	}catch (Exception e){
    		System.debug('CifradoAES128_tst creado sin parametros');
    	}
    	String textoCifrado;
    	List <ParametrosEncripcionAES128__c> my_list = new List <ParametrosEncripcionAES128__c>();
    	ParametrosEncripcionAES128__c objConfiguracion = new ParametrosEncripcionAES128__c();
		objConfiguracion.Name = 'InitializationVector';
		objConfiguracion.Valor__c = '6QAZ2WSX6EDC4RFV';
		my_list.add(objConfiguracion);
		ParametrosEncripcionAES128__c objConfiguracion2 = new ParametrosEncripcionAES128__c();
		objConfiguracion2.Name = 'EncryptionKey';
		objConfiguracion2.Valor__c = '6QAZ2WSX6EDC4RFV';
		my_list.add(objConfiguracion2);
		insert my_list;    	
        CifradoAES128_cls objCifrado = new CifradoAES128_cls();
        textoCifrado=objCifrado.CifrarUtf8('prueba');
        objCifrado.DesCifrarUtf8(textoCifrado);
    }
}