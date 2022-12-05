/**
* Avanxo Colombia
* @author           Sebastián Ortiz href=<seortiz@avanxo.com>
* Proyect:          Global (Soporte)
* Description:      Clase que implementa la lógica de envio de correos del controlador "massEmailSender_ctr" para evitar 
*					conflictos de límites de CPU.
* Changes (Version)
* -------------------------------------
*            No.    Fecha           Autor                           Descripción        
*            ----   ----------      ---------------------------     -------------    
* @version   1.0    27-01-2017      Sebastián Ortiz  (SO)           Class Created 
***********************************************************************************************************************/
public with sharing class MassEmailSender_qbl implements Queueable
{
	private Map<Id, String> mapIdsEmails;
	private Decimal valorRestante;
	private String strNameReporte;
	private String strNamePlantilla;
	private String idTemplateId;
	private Decimal decTotalLista;
	public MassEmailSender_qbl(Map<Id, String> mapIdsEmails, Decimal valorRestante, String strNameReporte, String strNamePlantilla, String idTemplateId, Decimal decTotalLista)
	{
		System.debug('\n\n*@*@* MassEmailSender_qbl mapIdsEmails.size(): ' + mapIdsEmails.size());
		this.mapIdsEmails = mapIdsEmails;
		this.valorRestante= valorRestante;
		this.strNameReporte= strNameReporte;
		this.strNamePlantilla= strNamePlantilla;
		this.idTemplateId= idTemplateId;
		this.decTotalLista= decTotalLista;
	}

	public void execute(QueueableContext context)
	{
		List<Messaging.SingleEmailMessage> lstEnvioEmail 	= new List<Messaging.SingleEmailMessage>();
		List<Messaging.SingleEmailMessage> lstEmailsToSend 	= new List<Messaging.SingleEmailMessage>();
		EnvioMasivoEmail__c objConfPersonalizadaLote 		= EnvioMasivoEmail__c.getValues('NumeroEncolables');
		Integer 		decNumeroMaxLote 					= Integer.valueOf(objConfPersonalizadaLote.Valor__c);

		/*
			*inserta contacto falso
		*/
		Contact objTempContact = new Contact();
		objTempContact.FirstName = 'Estimado';
		objTempContact.LastName  = 'Usuario';
		objTempContact.Email     = UserInfo.getUserEmail();
		System.debug('======antes de insert=====>>>>> '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');
		insert objTempContact;
		System.debug('======despues de insert=====>>>>> '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');
		try
		{
			System.debug('======antes futuro recorrer=====>>>>> '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');	
			System.debug('======execute=====>>Tamanio Original>>> '+mapIdsEmails.size());
			
			Integer intNumRecorrer = mapIdsEmails.size() > decNumeroMaxLote ? decNumeroMaxLote: mapIdsEmails.size();

			List<WrpDatosEmail> lstWrapJsonEmail = new List<WrpDatosEmail>();
			Integer intReset = 0;
			for(Id idRecordId : mapIdsEmails.keySet())
			{
				if(intReset < intNumRecorrer)
				{
					String currentUserEmail = mapIdsEmails.get(idRecordId);
					String[] ccAddresses = new String[] {currentUserEmail};

					WrpDatosEmail wrapEmail = new WrpDatosEmail();
					wrapEmail.blnsetSaveAsActivity = false;
					wrapEmail.strArraysetCcAddresses = ccAddresses;
					wrapEmail.strsetWhatId = idRecordId;
					wrapEmail.strsetTemplateId = idTemplateId;
					lstWrapJsonEmail.add(wrapEmail);
					mapIdsEmails.remove(idRecordId);
					intReset ++;
				}
			}
			System.debug('=====Despues=partir===mapIdsEmails===>>New size>>> '+mapIdsEmails.size());
			System.debug('=====Despues=partir===lstWrapJsonEmail===>>Send Size>>> '+lstWrapJsonEmail.size());
			System.debug('======despues futuro recorrer=====>>>>> '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');
			for(WrpDatosEmail objwrp: lstWrapJsonEmail)
			{
				Messaging.SingleEmailMessage objSEM = new Messaging.SingleEmailMessage();
				objSEM.setTargetObjectId(objTempContact.Id);
				objSEM.setSaveAsActivity(objwrp.blnsetSaveAsActivity);
				objSEM.setToAddresses(objwrp.strArraysetCcAddresses);
				objSEM.setWhatId(objwrp.strsetWhatId);
				objSEM.setTemplateId(objwrp.strsetTemplateId);
				lstEnvioEmail.add(objSEM);
			}
			System.debug('=====Despues=partir===lstEnvioEmail===>>Send Size>>> '+lstEnvioEmail.size());

			System.debug('======antes envio roll futuro recorrer=====>>>>> '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');
			try
			{
				Savepoint sp = Database.setSavepoint();
				//this causes the email to be parsed.
			System.debug('======antes de enviar fake=====>>>>> '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');
				Messaging.sendEmail(lstEnvioEmail);
			System.debug('======despues de enviar fake=====>>>>> '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');
				//we don't actually want to send the email to the owner, so rollback.
				Database.rollback(sp);
			} catch(System.EmailException objEmailException)
			{
				System.debug('\n\n-=#=-\n' + 'Parsing objEmailException' + ': ' + objEmailException + '\n-=#=-\n');
			} finally {
				delete objTempContact;
			}
			System.debug('======antes envio roll futuro recorrer=====>>>>> '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');

			System.debug('======antes de for parser=====>>>>> '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');
			//now extract our compiled/parsed messages
			for(Messaging.SingleEmailMessage objSingleEmailMessageParsed : lstEnvioEmail)
			{
				//extract the parsed details and resend!!
				String mailSubject      = objSingleEmailMessageParsed.getSubject();
				String mailHtmlBody     = objSingleEmailMessageParsed.getHTMLBody();
				String mailTextBody     = objSingleEmailMessageParsed.getPlainTextBody();
				List<String> mailtoAddresses     = objSingleEmailMessageParsed.getToAddresses();
				String[] toAddresses    = mailtoAddresses;
				//we need a new email to attach all this data to
				Messaging.SingleEmailMessage objSingleEmailMessage = new Messaging.SingleEmailMessage();
	
				objSingleEmailMessage.setSubject(mailSubject);
				objSingleEmailMessage.setHtmlBody(mailHtmlBody);
				objSingleEmailMessage.setPlainTextBody(mailTextBody);
				objSingleEmailMessage.setToAddresses(toAddresses);
				objSingleEmailMessage.setCharset(objSingleEmailMessageParsed.getCharset());
				objSingleEmailMessage.setFileAttachments(objSingleEmailMessageParsed.getFileAttachments());
	
				lstEmailsToSend.add(objSingleEmailMessage);
			}

			System.debug('======despues de for parser=====>>>>> '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');

			System.debug('=====Despues=partir===mapIdsEmails===>>New size>>> '+mapIdsEmails.size());
			System.debug('======antes futuro enviar=====>>>>> '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');
			Messaging.sendEmail(lstEmailsToSend);
			System.debug('======despues futuro enviar=====>>>>> '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');

			//Se actualiza el valor de correos enviados en la conf personalizada
			Decimal decNuevoRestante = valorRestante - lstEmailsToSend.size();
			ActualizaLimiteCorreosDiario_cls.actualizarLimiteCorreosDiario(valorRestante - lstEmailsToSend.size());
			//Envio User correo de resultado
			

			/*decNuevoRestante*/
			if(mapIdsEmails.size() > 0 )
			{
				MassEmailSender_qbl objEnvioMasivo = new MassEmailSender_qbl(mapIdsEmails, decNuevoRestante, strNameReporte, strNamePlantilla , idTemplateId, decTotalLista);
				Id idJob = System.enqueueJob(objEnvioMasivo);
				System.debug('\n\n-=#=-\n' + 'idJob' + ': ' + idJob + '\n-=#=-\n');
			}
			else if(mapIdsEmails.size() == 0)
			{
				
				String strPlainText 	= Label.SPT_Correo_Exitoso.replace('%Plantilla%.', strNamePlantilla).replace('%Reporte%',strNameReporte).replace('%NumCorreos%',''+decTotalLista);

				Messaging.SingleEmailMessage objUserEmail = new Messaging.SingleEmailMessage();
				objUserEmail.setTargetObjectId(UserInfo.getUserId());
				objUserEmail.setSaveAsActivity(false);
				objUserEmail.subject = 'Éxito envio correo Masivo';
				objUserEmail.plainTextBody = strPlainText;
				Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {objUserEmail};
				Messaging.sendEmail(messages);
			}
		}
		catch(System.EmailException objEmailException)
		{
			//Envio User correo de resultado
			String strPlainText 	= Label.SPT_Correo_Fallido.replace('%Plantilla%.', strNamePlantilla).replace('%Reporte%',strNameReporte).replace('%NumCorreos%',''+decTotalLista).replace('%ERROR%',objEmailException.getDmlMessage(0));
			Messaging.SingleEmailMessage objUserEmail = new Messaging.SingleEmailMessage();
			objUserEmail.setTargetObjectId(UserInfo.getUserId());
			objUserEmail.setSaveAsActivity(false);
			objUserEmail.subject = 'Fallo envio correo Masivo';
			objUserEmail.plainTextBody = strPlainText;
			Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {objUserEmail};
			Messaging.sendEmail(messages);
		}

	}

	public class WrpDatosEmail
	{
		public Boolean 		blnsetSaveAsActivity;
		public String[] 	strArraysetCcAddresses;
		public String 		strsetWhatId;
		public String 		strsetTemplateId;
	}

}