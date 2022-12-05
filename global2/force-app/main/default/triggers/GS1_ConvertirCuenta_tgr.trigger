/***************************************************************************************************************************
*** Desarrollado por:       Avanxo Colombia                                                                              ***
*** Autor:                  Cristian Mejia (CM)                                                                          ***
*** Proyecto:                                                                                                            ***
*** Descripcion:            Trigger para pasar la informacion de la cuenta y contacto , a la informacion de la empresa   ***
*** 						cuando el Prospecto de la compañia es Global Education										 ***
***                                                                                                                      ***
*** User history:                                                                                                        ***
*** Sprint:                                                                                                              ***
*** Release:                                                                                                             ***
***                                                                                                                      ***    
*** Cambios (Versiones)                                                                                                  ***
*** -------------------------------------                                                                                ***
***             No.     Fecha           Autor                   Descripción                                              ***    
***            -----    ----------      --------------------    ---------------                                          ***
*** @version    1.0     2015-01-23      Cristian Mejia (CM)     Class created                                            ***
***************************************************************************************************************************/
trigger GS1_ConvertirCuenta_tgr on Account (after insert) 
{
	GS1_ConvertirCuenta_cls objConv = new GS1_ConvertirCuenta_cls(trigger.new);
}