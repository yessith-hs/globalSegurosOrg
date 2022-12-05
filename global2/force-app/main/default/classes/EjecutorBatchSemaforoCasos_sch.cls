/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Sergio Andres Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Proceso Programado para la actualización masiva de los casos según la lógica aplicada en la clase TiemposySemaforosXCaso_cls
  segun sea agendado en trabajos programados.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha Autor Descripción
-------------------------------------------------------------------------------------------------------
1.0 19/04/2014 Sergio Andres Ortiz Creación de la clase.

*******************************************************************************************************************/

global class EjecutorBatchSemaforoCasos_sch implements Schedulable 
{ 
    //se llama al execute del batch para la actualizacion programada del cambio de estado del semaforo.
    global void execute(SchedulableContext sc) 
    {    
            database.executebatch(new ProcSemaforizacionCasosBatch_bch(),10);            
    }
    
}