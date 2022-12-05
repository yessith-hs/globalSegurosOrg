/******************************************************************************************************************
Desarrollado por:				Avanxo Colombia
Autor:							Sergio Andres Ortiz
Proyecto:						Global Seguros
Descripción:					Clase que implementa la lógica de negocio para realizar las siguientes operaciones
									- trigger para actualizar Polizas

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No.		Fecha			Autor					Descripción
-------------------------------------------------------------------------------------------------------
1.0		20/05/2014		Sergio Andres Ortiz 	Creación de la clase.

*******************************************************************************************************************/

trigger ActualizacionEstadoGestion_trg on Task (after insert) {
	 
	Task objTarea;

	if ( System.Trigger.isInsert ) {
			objTarea = System.Trigger.new.get(0);			
			ActualizacionEstadoGestion_cls.actualizarTarea(objTarea.Id,objTarea.WhatId,objTarea.CreatedDate,objTarea.Description,objTarea.estadoGestion__c);		     	
	}
    system.debug('@@-objTarea-->'+objTarea); 
}