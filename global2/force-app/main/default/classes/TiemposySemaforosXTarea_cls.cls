/******************************************************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Sergio Andres Ortiz
Proyecto: Global Seguros
Descripción: Clase que implementa la lógica de negocio para realizar las siguientes operaciones
- Calcular la cantidad de Horas Transcurridas desde la fecha y hora de creacion de la tarea
- Calcular la fecha de cambio de estado para una tarea y retorna el valor que debe asumir el semaforo.
- Asignar el estado del semaforo para las tareas segun la configuaracion personalizada TiemposySemaforosXTarea.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------------
No. Fecha Autor Descripción
-------------------------------------------------------------------------------------------------------
1.0 16/04/2014 Sergio Andres Ortiz Creación de la clase. 

*******************************************************************************************************************/

public class TiemposySemaforosXTarea_cls {
	
	public Double horaTarea;
	public String semaforo;
	public TiemposySemaforosXTarea__c	rangoCambioSemaforo;
	
	
	// Calcular la cantidad de Horas Transcurridas desde la fecha y hora en que es creada la tarea
	// ----------------------------------------------------------------------------------------------------------------
	public Double getTiempoTranscurridoXTarea(Task objTarea){ 
		Datetime fechacreacion; 	
    	system.debug('@@-ID Tarea >>>id->'+objTarea.id+'@@-tarea fechacreacion >>>O->'+objTarea);
    	// Definicion de variables de trabajo
    	if (test.isRunningTest()){
    		 fechacreacion =  datetime.now()-10;
    	}else{
    		 fechacreacion =  objTarea.CreatedDate;
    	}
    		
		system.debug('@@-ID Tarea >>>id->'+objTarea.id+'@@-tarea fechacreacion >>>O->'+fechacreacion);		        
        		    	
		// Obtener la fecha y hora actual
        Datetime fechaactual = datetime.now();
              
		// Tomar el horario de oficina que corresponde a Colombia
		BusinessHours bh = [SELECT Id FROM BusinessHours  WHERE name='Col'];
				
		// Obtener la diferencia en milisegundos entre la fecha de creacion  y la fecha actual teniendo en cuenta
		// el Horario de oficina y los festivos configurados en este. 
		long milisegundos = BusinessHours.diff(bh.id, fechacreacion, fechaactual);
		system.debug('@@longtime-->'+milisegundos );

		// Tomar los milisegundos y convertirlos en horas, minutos y segundos		
        System.debug('milisegundos:'+milisegundos);
        Double segundos = milisegundos / 1000;
        System.debug('segundos:'+segundos);
        Double minutos = segundos / 60;
        System.debug('minutos:'+minutos);
        Decimal horas = minutos / 60;
        System.debug('horas:'+horas);
        horaTarea=horas.setScale(2);
               
        return horaTarea;
	}
	
	
	// Calcular la fecha de cambio de estado para una tarea y retorna el valor que debe asumir el semaforo
	// -----------------------------------------------------------------------------------------------------------
	public String getEstadoSemaforoXTarea(){  
		
		// Definicion de variables de trabajo        
        rangoCambioSemaforo= TiemposySemaforosXTarea__c.getInstance('NHorasSemaforo'); 
        //rangoCambioSemaforo= TiemposySemaforosXTarea__c.getInstance('NHorasSemaforo');
		semaforo = 'Verde';         
        Decimal rangoFinVerde = rangoCambioSemaforo.NHorasSemaforo__c;
		Decimal rangoFinAmarillo = rangoCambioSemaforo.NHorasSemaforo__c*2;
		Decimal rangoFinRojo = rangoCambioSemaforo.NHorasSemaforo__c*3;			
				
		system.debug('@@-semaHVerde->'+rangoFinVerde+'@@-semaHAmarillo->'+rangoFinAmarillo+'@@-semaHAmarillo->'+rangoFinRojo);       
       	
		// Conforme a los rangos calcular el estado del semaforo
		if (horaTarea <= rangoFinVerde){
			semaforo = 'Verde';
		} else if (( rangoFinVerde < horaTarea ) && ( horaTarea <= rangoFinAmarillo )){
			semaforo = 'Amarillo';
		} else if (( rangoFinAmarillo < horaTarea ) && ( horaTarea <= rangoFinRojo )){
			semaforo = 'Rojo';			
		}  else{
			semaforo = 'Morado';
		}		 
            
        system.debug('@@Semaforo-Estado a actualizar-->'+semaforo);
		return semaforo;
	}
	
		
	// Cabiar el estado del semaforo en la tarea.
	// -----------------------------------------------------------------------------------------------------------
	public void setEstadoSemaforoXTarea(Task objTarea){  
				
		//obtener el color del semaforo correspondiente 
		semaforo = getEstadoSemaforoXTarea(); 		
		
		//asignar el color correspondiente al semaforo
		system.debug('@@-Color del Semaforo Actual ->>-->>'+objTarea.estadoSemaforo__c); 
		objTarea.estadoSemaforo__c = semaforo;		        			
		system.debug('@@--Color asignado al semaforo -@@-->'+objTarea.estadoSemaforo__c);									
	}	
}