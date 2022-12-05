/******************************************************************************************************************
Desarrollado por:				Avanxo Colombia
Autor:							Luis Peñaranda
Proyecto:						Global Seguros
Descripción:					Trigger que implementa la lógica de negocio para realizar las siguientes operaciones
									- Consumir servicio web de GLobal para informar Acompañamientos

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No.		Fecha			Autor					Descripción
-------------------------------------------------------------------------------------------------------
1.0		23/05/2014		Luis Rafael Peñaranda 	Creación de la clase.

*******************************************************************************************************************/

trigger AcompanamientoIntermediario_tgr on EvaluacionSeguimiento__c (after insert)  {
	 
	EvaluacionSeguimiento__c objEvaluacionSeguimiento;

	if ( System.Trigger.isInsert ) {
			objEvaluacionSeguimiento = System.Trigger.new.get(0);			
			AcompanamientoIntermediario_cls.notificarAcompanamiento(objEvaluacionSeguimiento.id,objEvaluacionSeguimiento.FechaAcompanamiento__c,objEvaluacionSeguimiento.AsesorEvaluado__c);		     	
	}
    system.debug('@@-objEvaluacionSeguimiento-->'+objEvaluacionSeguimiento); 
}