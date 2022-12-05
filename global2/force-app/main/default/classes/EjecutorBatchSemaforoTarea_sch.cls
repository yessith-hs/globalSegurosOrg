/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Sergio Andres Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Proceso Programado para la actualización masiva de las tareas según la lógica aplicada en la clase TiemposySemaforosXTarea_cls
  segun sea programada la configuracion personalizada TiemposySemaforosXTarea.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha Autor Descripción
-------------------------------------------------------------------------------------------------------
1.0 19/04/2014 Sergio Andres Ortiz Creación de la clase.

*******************************************************************************************************************/

global class EjecutorBatchSemaforoTarea_sch implements Schedulable 
{ 
	//se llama al execute del batch para la actualizacion programada del cambio de estado del semaforo.
    global void execute(SchedulableContext sc) 
    {    
            database.executebatch(new ProcSemaforizacionTareasBatch_bch(),100);            
    }
    
}