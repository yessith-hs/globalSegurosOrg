public class ActualizarSenalPolizasEnCuentas_cls {
	Boolean esGlobalSeguros=false;
	Boolean esGlobalEducation=false;
	String cuentaAnterior=null;		
	list<Poliza__c> lstPoltemp;
	list<Id> lstIdAccount = new list<Id>();
	list<Id> lstIdBenef = new list<Id>();
	list<Id> lstIdDesig = new list<Id>();
	map<id,Account> mapAccount = new map<id,Account> ();
	map<id,list<Poliza__c>> mapPolizasXCuentaBD 		= new map<id,list<Poliza__c>>();
	list<Poliza__c> lstPolAct = null;
	list<Poliza__c> lstPolBor = null;
	Boolean SenalPolizaBorrada=false;
	/* Realizar proceso*/
	public void procesarActualziacion(list<Poliza__c> lstPolizas){
		
		// Recorrer las polizas del trigger y tomar las cuentas
		for(Poliza__c objPol:lstPolizas){
			if(objPol.Nombre_Tomador__c!=null)
			lstIdAccount.add(objPol.Nombre_Tomador__c);
		}
	
		// Recorrer las polizas del trigger y tomar los beneficiarios
		for(Poliza__c objPol:lstPolizas){
			if(objPol.NombreBeneficiario__c!=null)
			lstIdBenef.add(objPol.NombreBeneficiario__c);
		}

		// Recorrer las polizas del trigger y tomar los Toamdores
		for(Poliza__c objPol:lstPolizas){
			if(objPol.NombreDesignado__c!=null)
			lstIdDesig.add(objPol.NombreDesignado__c);
		}		
		
		
		// Armar lista con las cuentas de las polizas a procesar Tomadores
		list<Account> lstAccount =[SELECT id,ClienteGlobalEducation__c,ClienteGlobalSeguros__c FROM Account WHERE id =: lstIdAccount];

		// Armar lista con las cuentas de las polizas a procesar Beneficiarios
		list<Account> lstBenef =[SELECT id,ClienteGlobalEducation__c,ClienteGlobalSeguros__c FROM Account WHERE id =: lstIdBenef];

		// Armar lista con las cuentas de las polizas a procesar Designados
		list<Account> lstDesig =[SELECT id,ClienteGlobalEducation__c,ClienteGlobalSeguros__c FROM Account WHERE id =: lstIdDesig];
		
				

		// ---------------------------- Obtener todas las polizas de las cuentas para procesos con tomadores
		list<Poliza__c> lstPolizasBD = new list<Poliza__c>();
		lstPolizasBD = [select id,EmpresaProducto__c,Nombre_Tomador__c,Estado__c from Poliza__c where Nombre_Tomador__c=:lstIdAccount order by Nombre_Tomador__c desc];
		// Armar mapa con cuantas y sus listas de polizas
		cuentaAnterior=null;
		for(Poliza__c objPol:lstPolizasBD){
			
			if(cuentaAnterior == null ){
				cuentaAnterior	=	objPol.Nombre_Tomador__c;
				lstPoltemp 		= 	new list<Poliza__c>();
			}
			
			if(cuentaAnterior <>objPol.Nombre_Tomador__c){
				mapPolizasXCuentaBD.put(cuentaAnterior,lstPoltemp);
				lstPoltemp 		= 	new list<Poliza__c>();
				cuentaAnterior	=	objPol.Nombre_Tomador__c;	
			}		
				
			lstPoltemp.add(objPol);
		}	
		mapPolizasXCuentaBD.put(cuentaAnterior,lstPoltemp);	

		for(Account acc: lstAccount){
			esGlobalSeguros=false;
			esGlobalEducation=false;			
			
			// Recorrer lista de polizas de la BD
			lstPolAct = mapPolizasXCuentaBD.get(acc.Id);
			if(lstPolAct != null){
				for(Poliza__c pol:lstPolAct){
					if(pol.Estado__c != 'Cancelada'){
						if(pol.EmpresaProducto__c == System.Label.Gbc_GlobalSeguros) esGlobalSeguros = true;
						if(pol.EmpresaProducto__c == System.Label.Gbc_GlobalEducation) esGlobalEducation = true;
					}
				}		
			}	
			acc.ClienteGlobalEducation__c	= esGlobalEducation;
			acc.ClienteGlobalSeguros__c		= esGlobalSeguros;
		}
		update 	lstAccount;
		
		//--------------------------- Obtener todas las polizas de las cuentas para procesos con Beneficiarios --------------------------------------
		system.debug('ENTRO AL PROCESO DE BENEFICIARIOS');
		mapPolizasXCuentaBD 		= new map<id,list<Poliza__c>>();
		lstPolizasBD = new list<Poliza__c>();
		lstPolizasBD = [select id,EmpresaProducto__c,NombreBeneficiario__c,Estado__c from Poliza__c where NombreBeneficiario__c=:lstIdBenef order by NombreBeneficiario__c desc];
		// Armar mapa con cuantas y sus listas de polizas
		cuentaAnterior=null;
		for(Poliza__c objPol:lstPolizasBD){
			//system.debug('ENTRO AL  FOR-objPol->'+objPol);
			if(cuentaAnterior == null ){
				cuentaAnterior	=	objPol.NombreBeneficiario__c;
				lstPoltemp 		= 	new list<Poliza__c>();
			}
			
			if(cuentaAnterior <>objPol.NombreBeneficiario__c){
				mapPolizasXCuentaBD.put(cuentaAnterior,lstPoltemp);
				lstPoltemp 		= 	new list<Poliza__c>();
				cuentaAnterior	=	objPol.NombreBeneficiario__c;	
			}		
				
			lstPoltemp.add(objPol);
		}	
		mapPolizasXCuentaBD.put(cuentaAnterior,lstPoltemp);	

		for(Account acc: lstBenef){
			esGlobalSeguros=false;
			esGlobalEducation=false;			
			//system.debug('ENTRO AL  FOR-acc->'+acc);
			// Recorrer lista de polizas de la BD
			lstPolAct = mapPolizasXCuentaBD.get(acc.Id);
			if(lstPolAct != null){
				for(Poliza__c pol:lstPolAct){
					system.debug('ENTRO AL  FOR-pol-bENEF->'+pol);
					if(pol.Estado__c != 'Cancelada'){
						//system.debug('ENTRO AL  ID-ESTADO-BENEF->'+pol);
						if(pol.EmpresaProducto__c == System.Label.Gbc_GlobalSeguros) esGlobalSeguros = true;
						if(pol.EmpresaProducto__c == System.Label.Gbc_GlobalEducation) esGlobalEducation = true;
					}
				}	
			}		
			acc.ClienteGlobalEducation__c	= esGlobalEducation;
			acc.ClienteGlobalSeguros__c		= esGlobalSeguros;
		}
		system.debug('lstAccount-BENEF->'+lstBenef);
		update 	lstBenef;		



		//--------------------------- Obtener todas las polizas de las cuentas para procesos con Designados --------------------------------------
		system.debug('ENTRO AL PROCESO DE DESIGNADOS');
		mapPolizasXCuentaBD 		= new map<id,list<Poliza__c>>();
		lstPolizasBD = new list<Poliza__c>();
		lstPolizasBD = [select id,EmpresaProducto__c,NombreDesignado__c,Estado__c from Poliza__c where NombreDesignado__c=:lstIdDesig order by NombreDesignado__c desc];
		// Armar mapa con cuantas y sus listas de polizas
		cuentaAnterior=null;
		for(Poliza__c objPol:lstPolizasBD){
			//system.debug('ENTRO AL  FOR-objPol->'+objPol);
			if(cuentaAnterior == null ){
				cuentaAnterior	=	objPol.NombreDesignado__c;
				lstPoltemp 		= 	new list<Poliza__c>();
			}
			
			if(cuentaAnterior <>objPol.NombreDesignado__c){
				mapPolizasXCuentaBD.put(cuentaAnterior,lstPoltemp);
				lstPoltemp 		= 	new list<Poliza__c>();
				cuentaAnterior	=	objPol.NombreDesignado__c;	
			}		
				
			lstPoltemp.add(objPol);
		}	
		mapPolizasXCuentaBD.put(cuentaAnterior,lstPoltemp);	

		for(Account acc: lstDesig){
			esGlobalSeguros=false;
			esGlobalEducation=false;			
			//system.debug('ENTRO AL  FOR-acc->'+acc);
			// Recorrer lista de polizas de la BD
			lstPolAct = mapPolizasXCuentaBD.get(acc.Id);
			if(lstPolAct != null){ 
				for(Poliza__c pol:lstPolAct){
					//system.debug('ENTRO AL  FOR-pol-Desig->'+pol);
					if(pol.Estado__c != 'Cancelada'){
						//system.debug('ENTRO AL  ID-ESTADO-BENEF->'+pol);
						if(pol.EmpresaProducto__c == System.Label.Gbc_GlobalSeguros) esGlobalSeguros = true;
						if(pol.EmpresaProducto__c == System.Label.Gbc_GlobalEducation) esGlobalEducation = true;
					}
				}	
			}		
			acc.ClienteGlobalEducation__c	= esGlobalEducation;
			acc.ClienteGlobalSeguros__c		= esGlobalSeguros;
		}
		system.debug('lstAccount-Desig->'+lstBenef);
		update 	lstDesig;					
	} 	

}