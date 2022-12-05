/**
********************************************************************************************************
* @company         Avanxo Colombia
* @author          Raul Orozco href=<rorozco@avanxo.com>
* @proyect         Global Seguros
* @name            ActualizaLimiteCorreosDiario_sch
* @description     Clase scheduler consulta límite diario envío de correos.
* @dependencies    ActualizaLimiteCorreosDiario_cls
* @changes (Version)
* --------   ---   ----------   ---------------------------   ------------------------------------------
*            No.   Date         Author                        Description
* --------   ---   ----------   ---------------------------   ------------------------------------------
* @version   1.0   29/08/2016  Raul Orozco           		  Creación de la clase
********************************************************************************************************
**/
global class ActualizaLimiteCorreosDiario_sch implements Schedulable {
   global void execute(SchedulableContext SC) {
      ActualizaLimiteCorreosDiario_bch consulta = new ActualizaLimiteCorreosDiario_bch();
      Database.executebatch(consulta); 
   }
}