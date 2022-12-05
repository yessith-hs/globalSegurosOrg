/******************************************************************************************************************
Desarrollado por:				Avanxo Colombia
Autor:							Sergio Andres Ortiz
Proyecto:						Global Seguros
Descripción:					Clase que implementa la lógica de negocio para realizar las siguientes operaciones
									- Actualizar una poliza con la información de estado de pagos suministrada por SISE 
									  mediantel el WS.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No.		Fecha			Autor					Descripción
-------------------------------------------------------------------------------------------------------
1.0		21/05/2014		Sergio Andres Ortiz 	Creación de la clase.

*******************************************************************************************************************/
		
public  class actualizacionEstadoPagos_cls {
	
	public actualizacionEstadoPagos_WS.registroEstadoPagoResponse  actualizarPoliza(actualizacionEstadoPagos_WS.DatosEstadoPagoRequest infoPoliza){
		actualizacionEstadoPagos_WS.registroEstadoPagoResponse obrRta= new actualizacionEstadoPagos_WS.registroEstadoPagoResponse();
		obrRta.CodRta    	=   '000';
        obrRta.MnsjRta    =   'Proceso Exitoso';
		Poliza__c objPoliza;
		try{
			objPoliza = [SELECT AlturasPagadas__c,Anio_vigente_del_pago__c,Carrera__c,CiudadUniversidad__c,EstadoSemestre__c,Estado__c,
										  FechaLimitePago__c,FechaPagoSemestre__c,Id,Id_Externo__c,Periodo__c,SubEstadoSemestre__c,Universidad__c,
										  NoPago__c,DetenerPago__c,NoContactar__c,AQuienSeEnviAComunicacion__c //
								   FROM Poliza__c  WHERE Id_Externo__c =: infoPoliza.strIdExtPoliza];
								   
			objPoliza.AlturasPagadas__c				=  	infoPoliza.dblAlturasPagadas;
			objPoliza.Anio_vigente_del_pago__c		=	infoPoliza.dblAnioVigenciaPago;
			objPoliza.Carrera__c					=	infoPoliza.strCarrera;
			objPoliza.CiudadUniversidad__c			=  	infoPoliza.strCiudadUniversidad;
			objPoliza.EstadoSemestre__c				= 	infoPoliza.strEstadoSemestre;
			objPoliza.Estado__c						=  	infoPoliza.strEstadoPoliza;
			objPoliza.FechaLimitePago__c			=  	infoPoliza.datFechaLimitePago;
			objPoliza.FechaPagoSemestre__c			=	infoPoliza.datFechaPagoSemestre;
			objPoliza.Periodo__c					= 	infoPoliza.dblPeriodoVigenciaPago;
			objPoliza.SubEstadoSemestre__c			=	infoPoliza.strSubEstadoSemestre;
			objPoliza.Universidad__c				=	infoPoliza.strUniversidad;
			//
			objPoliza.NoPago__c						=   infoPoliza.bolNoPago;
            objPoliza.DetenerPago__c				=   infoPoliza.bolDetenerPago;
            objPoliza.NoContactar__c				=   infoPoliza.bolNoContactar;
            objPoliza.AQuienSeEnviAComunicacion__c  =	infoPoliza.strAQuienSeEnviaComunicacion;
			
			
			update objPoliza;
		
		}catch(Exception e){
            obrRta.CodRta    	=   '001';
            obrRta.MnsjRta    =   'Error en la Actualización de la Póliza-->'+e.getMessage();
            system.debug('@@-Mensaje Error->'+ 'Error en la Actualización de la Póliza-->'+e.getMessage());
            return obrRta;
        } 
		system.debug('@@-objPoliza->'+objPoliza);		
		return obrRta;
	}	
}