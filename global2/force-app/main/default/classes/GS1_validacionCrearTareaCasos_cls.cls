/***************************************************************************************************************************
*** Desarrollado por:		Avanxo Colombia			    	                                                             ***
*** Autor:					Cristian Mejia (CM)			    	                                                         ***
*** Proyecto:											    	                                                         ***
*** Descripcion:			Clase que valida que no se puedan crear o modificar Tareas, cuando un caso se encuentra 	 ***
***							Cerrado							    	                   								     ***
*** User history:					                                                                                     ***
*** Sprint:								                                                                                 ***
*** Release:								                                                                             ***
***																														 ***	
*** Cambios (Versiones)															                                         ***
*** -------------------------------------																				 ***
***	     	    No.		Fecha			Autor					Descripción												 ***	
***		 	   -----	----------		--------------------	---------------											 ***
*** @version	1.0	    2014-12-02		Cristian Mejia (CM)     Class created											 ***
***************************************************************************************************************************/

public with sharing class GS1_validacionCrearTareaCasos_cls
{
	public GS1_validacionCrearTareaCasos_cls(List<Task> tareaNueva)
	{
		for(Task t0 : tareaNueva)
		{
			if(t0.WhatId != null)
			{
				String case_prefix = Schema.SObjectType.Case.getKeyPrefix();
				String task_whatid = t0.WhatId;
				System.debug('who: ' + t0.WhoId + ' what: ' + t0.WhatId + ' prefix: ' + case_prefix + ' eval: ' + task_whatid.startsWith(case_prefix) + ' id: ' + t0.id );
				
				if(task_whatid.startsWith(case_prefix))
				{
					Case ObjCase = [SELECT Status FROM Case WHERE Id =: t0.WhatId];
					String strStatus = ObjCase.Status;

					if(strStatus == 'Cerrado')
					{
						t0.addError('No se puede crear ni editar Tareas de un caso cerrado');
					}
				}
			}
		}
	}
}