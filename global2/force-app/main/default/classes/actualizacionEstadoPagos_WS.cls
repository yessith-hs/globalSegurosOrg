/******************************************************************************************************************
Desarrollado por:				Avanxo Colombia
Autor:							Sergio Andres Ortiz
Proyecto:						Global Seguros
Descripción:					SEGUIMIENTOS: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
									- Actualizar una poliza con la información de estado de pagos suministrada por SISE 
									  mediantel el WS.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No.		Fecha			Autor					Descripción
-------------------------------------------------------------------------------------------------------
1.0		21/05/2014		Sergio Andres Ortiz 	Creación de la clase.

*******************************************************************************************************************/
global class actualizacionEstadoPagos_WS {	
	
	//Clase que define los campos del Request para el webservice Actualizacion Estado Pagos
	global virtual class DatosEstadoPagoRequest	{		
		Webservice String strIdExtPoliza;
		Webservice String strUniversidad;
		Webservice String strCiudadUniversidad;
		Webservice String strCarrera;
		Webservice Date   datFechaLimitePago;		
		Webservice Double dblAlturasPagadas;
		Webservice Double dblPeriodoVigenciaPago;
		Webservice Double dblAnioVigenciaPago;
		Webservice String strEstadoSemestre;
		Webservice String strSubEstadoSemestre;
		Webservice Date   datFechaPagoSemestre;
		Webservice String strEstadoPoliza;
	   //
	   webservice Boolean  bolNoPago;
       webservice Boolean  bolDetenerPago;
       webservice Boolean  bolNoContactar;
       webservice String   strAQuienSeEnviaComunicacion;							
	}
	
	
	
	//Clase que define los campos del Response del webservice.
	global class registroEstadoPagoResponse {
		Webservice String CodRta;	
		Webservice String MnsjRta;	
	}
	
	
	/**
	*	Precondición:		Debe estar expuesto el webservice.
	*	Postcondición:		
	*	@Description:		Webservice que actualiza una poliza con la informacion suministrada por SISE
							PARA SEGUIMIENTOS
	**/	
	WebService static registroEstadoPagoResponse actualizacionEstadoPagos(DatosEstadoPagoRequest actEstadoPago)
	{
		registroEstadoPagoResponse rta = new registroEstadoPagoResponse();

		actualizacionEstadoPagos_cls actualiza = new actualizacionEstadoPagos_cls();
		rta = actualiza.actualizarPoliza(actEstadoPago);
		 system.debug('@@-rta-@@->'+rta);
		return rta;
	}
}