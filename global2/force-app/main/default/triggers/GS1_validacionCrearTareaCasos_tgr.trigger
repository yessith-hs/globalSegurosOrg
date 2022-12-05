/***************************************************************************************************************************
*** Desarrollado por:       Avanxo Colombia                                                                              ***
*** Autor:                  Cristian Mejia (CM)                                                                          ***
*** Proyecto:                                                                                                            ***
*** Descripcion:            Trigger para lidar la creación de las tareas de casos                                        ***
***                                                                                                                      ***
*** User history:                                                                                                        ***
*** Sprint:                                                                                                              ***
*** Release:                                                                                                             ***
***                                                                                                                      ***    
*** Cambios (Versiones)                                                                                                  ***
*** -------------------------------------                                                                                ***
***             No.     Fecha           Autor                   Descripción                                              ***    
***            -----    ----------      --------------------    ---------------                                          ***
*** @version    1.0     2014-12-02      Cristian Mejia (CM)     Class created                                            ***
***************************************************************************************************************************/

trigger GS1_validacionCrearTareaCasos_tgr on Task (before insert,before update) 
{
    GS1_validacionCrearTareaCasos_cls validacion=new GS1_validacionCrearTareaCasos_cls(trigger.new);
}