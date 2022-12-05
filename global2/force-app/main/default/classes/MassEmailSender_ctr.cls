/**
********************************************************************************************************
* @company         Avanxo Colombia
* @author          Antonio Torres href=<atorres@avanxo.com>
* @proyect         Global Seguros
* @name            MassEmailSender_ctr
* @description     Controller for visualforce page "MassEmailSender_pag".
* @dependencies    Class Utils_Cls
* @changes (Version)
* --------   ---   ----------   ---------------------------   ------------------------------------------
*            No.   Date         Author                        Description
* --------   ---   ----------   ---------------------------   ------------------------------------------
* @version   1.0   2016-06-23   Antonio Torres (AT)           Creation of the class.
********************************************************************************************************
**/

public with sharing class MassEmailSender_ctr {
	public List<SelectOption> lstAvailableTemplates     {get; set;}
	public List<SelectOption> lstAvailableReports       {get; set;}
	public Id idTemplateId                              {get; set;}
	public Id idReportId                                {get; set;}
	public String strIdColumnName                       {get; set;}
	public String strEmailColumnName                    {get; set;}
	public Boolean blnDisable                    		{get; set;}
	public Boolean blnIdFieldDisabled                   {get; set;}
	public Boolean blnEmailFieldDisabled                {get; set;}
	public Boolean blnSendButtonDisabled                {get; set;}
	public OrgWideLimit_cls objOrgWideLimit             {get; set;}
	public Decimal valorRestante                        {get; set;}
	public Decimal valorMax                             {get; set;}
	public String textoCabecera                         {get; set;}
	public Map<Id, String> mapIdTemplateName;
	

	public MassEmailSender_ctr() {
		blnDisable = false;
		lstAvailableTemplates = retrieveAvailableTemplates();
		
		lstAvailableReports = retrieveAvailableReports();
		if(!lstAvailableReports.isEmpty()) {
			idReportId = lstAvailableReports[0].getValue();
			getIdColumNames();
			getEmailColumNames();
		}

		try {
			EnvioMasivoEmail__c objConfPersonalizadaRestante = EnvioMasivoEmail__c.getValues('SingleEmail');
			valorRestante = objConfPersonalizadaRestante.Valor__c;
			
			EnvioMasivoEmail__c objConfPersonalizadaMax = EnvioMasivoEmail__c.getValues('SingleEmailMax');
			valorMax = objConfPersonalizadaMax.Valor__c;
			
			textoCabecera = Label.MES_INF_MassEmailQuantity.replace('%CantDisp%',String.valueOf(valorRestante.intValue())).replace('%CantTotal%',String.valueOf(valorMax.intValue()));
			//objOrgWideLimit = Utils_cls.getOrgWideLimit('SingleEmail',null);
		} catch(Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.MES_MSG_LimitCheck.replace('%MsjError%', e.getMessage())));
		}
	}
	
	/**
	* @method      retrieveAvailableTemplates
	* @description Returns a list with the available templates.
	* @author      Antonio Torres - 2016-06-23
	*/
	public List<SelectOption> retrieveAvailableTemplates() {
		mapIdTemplateName = new Map<Id, String>();
		List<SelectOption> lstTemplateSelectOptions = new List<SelectOption>();
		List<EmailTemplate> lstTemplates = [SELECT Id
												  ,Name
											  FROM EmailTemplate
											 WHERE IsActive = true
										  ORDER BY Name];

		for(EmailTemplate objTemplate : lstTemplates) {
			lstTemplateSelectOptions.add(new SelectOption(objTemplate.Id, objTemplate.Name));
			if(!mapIdTemplateName.containsKey(objTemplate.Id))
				mapIdTemplateName.put(objTemplate.Id, objTemplate.Name);
		}

		return lstTemplateSelectOptions;
	}
	
	/**
	* @method      retrieveAvailableReports
	* @description Returns a list with the available reports.
	* @author      Antonio Torres - 2016-06-23
	*/
	public List<SelectOption> retrieveAvailableReports() {
		List<SelectOption> lstReportSelectOptions = new List<SelectOption>();
		List<Report> lstReports = [SELECT Id
										 ,Name
									 FROM Report
									WHERE Format IN('Tabular', 'Summary')
									  AND IsDeleted = false
								 ORDER BY Name];

		for(Report objReport : lstReports) {
			lstReportSelectOptions.add(new SelectOption(objReport.Id, objReport.Name));
		}

		return lstReportSelectOptions;
	}

	/**
	* @method      getIdColumNames
	* @description Returns a list of SelectOption with the column names that are from Id type, on the report with Id equals to variable "idReportId".
	* @author      Antonio Torres - 2016-06-24
	*/
	public List<SelectOption> getIdColumNames() {
		List<SelectOption> lstIdColumnNameSelectOptions = ReportUtils_cls.getColumnNamesOfTypeOnReport(idReportId, Reports.ColumnDataType.ID_DATA);
		if(lstIdColumnNameSelectOptions.isEmpty()) {
			strIdColumnName = null;
			blnIdFieldDisabled = true;
		} else {
			blnIdFieldDisabled = false;
		}
		return lstIdColumnNameSelectOptions;
	}

	/**
	* @method      getEmailColumNames
	* @description Returns a list of SelectOption with the column names that are from Email type, on the report with Id equals to variable "idReportId".
	* @author      Antonio Torres - 2016-06-24
	*/
	public List<SelectOption> getEmailColumNames() {
		List<SelectOption> lstEmailColumnNameSelectOptions = ReportUtils_cls.getColumnNamesOfTypeOnReport(idReportId, Reports.ColumnDataType.EMAIL_DATA);
		if(lstEmailColumnNameSelectOptions.isEmpty()) {
			strEmailColumnName = null;
			blnEmailFieldDisabled = true;
		} else {
			blnEmailFieldDisabled = false;
		}
		return lstEmailColumnNameSelectOptions;
	}

	/**
	* @method      sendMassEmail
	* @description Sends mass email to the list of records returned by a report, using the specified email template.
	* @author      Antonio Torres - 2016-06-21
	*/
	public PageReference sendMassEmail() {
		System.debug('======Entro boton=====>>>>> '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');
		try{
			if(idTemplateId == null || idReportId == null || strIdColumnName == null || strEmailColumnName == null) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.MES_MSG_RequiredFieldsMissing));
				return null;
			}
			
			// Report Medatada (Info)
			System.debug('======Antes de describir reporte=====>>>>> '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');
			Reports.ReportMetadata objReportMetadata = Reports.ReportManager.describeReport(idReportId).getReportMetadata();
			System.debug('=====despues de describir reporte=====>>>>> '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');
			//System.debug('\n\n-=#=-\n' + 'objReportMetadata.getId()' + ': ' + objReportMetadata.getId() + '\n-=#=-\n');
			//System.debug('\n\n-=#=-\n' + 'objReportMetadata.getName()' + ': ' + objReportMetadata.getName() + '\n-=#=-\n');
			//System.debug('\n\n-=#=-\n' + 'objReportMetadata.getDeveloperName()' + ': ' + objReportMetadata.getDeveloperName() + '\n-=#=-\n');
			//System.debug('\n\n-=#=-\n' + 'objReportMetadata.getDetailColumns()' + ': ' + objReportMetadata.getDetailColumns() + '\n-=#=-\n');
			//System.debug('\n\n-=#=-\n' + 'objReportMetadata.getReportFormat()' + ': ' + objReportMetadata.getReportFormat() + '\n-=#=-\n');
	
			// Executes report
			//Reports.ReportResults objReportResults = Reports.ReportManager.runReport(idReportId, objReportMetadata, true);
			System.debug('======Antes de ejecutar reporte=====>>>>> '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');
			Reports.ReportResults objReportResults = Reports.ReportManager.runReport(idReportId, true);
			System.debug('=====despues de ejecutar reporte=====>>>>> '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');
	
			Integer intRecordCount = ReportUtils_cls.getRecordCountOnReportResults(objReportResults);
			if(intRecordCount == 0) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.MES_MSG_NoReportResults));
				return null;
			}
	
			try {
				//objOrgWideLimit = Utils_cls.getOrgWideLimit('SingleEmail',null);
				//if(intRecordCount > objOrgWideLimit.getRemaining()) {
				if(intRecordCount > valorRestante) {
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.MES_MSG_UnavailableQuantity.replace('%CantDisp%',  String.valueOf(valorRestante))
																															.replace('%CantTotal%', String.valueOf(valorMax))
																															.replace('%CantReq%',   String.valueOf(intRecordCount))));
					return null;
				}
			} catch(Exception e) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.MES_MSG_LimitCheck.replace('%MsjError%', e.getMessage())));
				return null;
			}
	
			// Get ids and emails
			System.debug('======Antes de mapa=====>>>>> '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');
			Map<Id, String> mapIdsEmails = getMapIdEmailOnReportResults(objReportResults, strIdColumnName, strEmailColumnName);
			System.debug('======despues de mapa=====>>>>> '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');
			System.debug('\n\n-=#=-\n' + 'mapIdsEmails' + ': ' + mapIdsEmails + '\n-=#=-\n');
	
			if(mapIdsEmails == null) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.MES_MSG_ReportExtractError));
				return null;
			}

			System.debug('====idTemplateId=======>>>>> '+idTemplateId+ ' ====== '+Limits.getCpuTime()+' ===milliseconds=de=== '+Limits.getLimitCpuTime()+' ====milliseconds=permitidos=====');
			//nuevo bloque de envio SON 25-01-2017
				MassEmailSender_qbl objEnvioMasivo = new MassEmailSender_qbl(mapIdsEmails, valorRestante, objReportMetadata.getName(), mapIdTemplateName.get(idTemplateId), idTemplateId, mapIdsEmails.size());
				Id idJob = System.enqueueJob(objEnvioMasivo);
				System.debug('\n\n-=#=-\n' + 'idJob' + ': ' + idJob + '\n-=#=-\n');

				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Se está realizando el envio de correo cuando el proceso acabe se le enviará un correo con los resultados'));
				blnDisable = true;
				blnIdFieldDisabled = true;
				blnEmailFieldDisabled = true;
			//SON end
		}catch(Reports.InvalidFilterException objReportException){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.MES_MSG_SendError.replace('Error: %MsjError%.', 'Favor revise el reporte utilizado.')));
			for (String error : objReportException.getFilterErrors()) {
				System.debug('\n\n-=#=-\n' + 'Error ejecución reporte' + ': ' +  error + '\n-=#=-\n');
			}
		}catch(Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.MES_MSG_SendError.replace('Error: %MsjError%.', '')));
			System.debug('\n\n-=#=-\n' + 'Error general correo masivo' + ': ' + + e.getMessage() + '<>' + e.getStackTraceString() + '\n-=#=-\n');
		}

		return null;
	}

	/**
	* @method      getMapIdEmailOnReportResults
	* @description Returns a map with records ids and emails values contained on specified report results, using specified column names.
	* @author      Antonio Torres - 2016-06-22
	*/
	private Map<Id, String> getMapIdEmailOnReportResults(Reports.ReportResults results, String strIdColumnName, String strEmailColumnName) {
		Reports.ReportExtendedMetadata objReportExtendedMetadata = results.getReportExtendedMetadata();
		//System.debug('\n\n-=#=-\n' + 'objReportExtendedMetadata' + ': ' + objReportExtendedMetadata + '\n-=#=-\n');

		Integer intIdColumnIndex    = ReportUtils_cls.getColumnNameIndexOnReportResults(results, strIdColumnName);
		Integer intEmailColumnIndex = ReportUtils_cls.getColumnNameIndexOnReportResults(results, strEmailColumnName);

		if(intIdColumnIndex == -1) {
			//System.debug('\n\n-=#=-\n' + 'Id Column Name not found' + ': ' + strIdColumnName + '\n-=#=-\n');
			return null;    
		}

		if(intEmailColumnIndex == -1) {
			//System.debug('\n\n-=#=-\n' + 'Email Column Name not found' + ': ' + strEmailColumnName + '\n-=#=-\n');
			return null;    
		}

		Map<Id, String> mapIdsEmails = new Map<Id, String>();

		if(results.getReportMetadata().getReportFormat() == Reports.ReportFormat.TABULAR) {
			//System.debug('\n\n-=#=-\n' + 'Rows Tabular' + ': ' + ((Reports.ReportFactWithDetails)results.getFactMap().get('T!T')).getRows() + '\n-=#=-\n');

			for(Reports.ReportDetailRow objReportDetailRow : ((Reports.ReportFactWithDetails)results.getFactMap().get('T!T')).getRows()) {
				//System.debug('\n\n-=#=-\n' + 'TABULAR objReportDetailRow' + ': ' + objReportDetailRow + '\n-=#=-\n');

				//System.debug('\n\n-=#=-\n' + 'TABULAR objReportDetailRow.getDataCells().get(Id)' + ': ' + Id.valueOf(String.valueOf(objReportDetailRow.getDataCells().get(intIdColumnIndex).getValue())) + '\n-=#=-\n');
				//System.debug('\n\n-=#=-\n' + 'TABULAR objReportDetailRow.getDataCells().get(Email)' + ': ' + objReportDetailRow.getDataCells().get(intEmailColumnIndex).getValue() + '\n-=#=-\n');
				mapIdsEmails.put(Id.valueOf(String.valueOf(objReportDetailRow.getDataCells().get(intIdColumnIndex).getValue())), String.valueOf(objReportDetailRow.getDataCells().get(intEmailColumnIndex).getValue()));
			}
		} else if(results.getReportMetadata().getReportFormat() == Reports.ReportFormat.SUMMARY) {
			return getMapIdEmailRecursivelyOnReportSummaryFactMap(results.getFactMap(), results.getGroupingsDown().getGroupings(), intIdColumnIndex, intEmailColumnIndex);
		}

		return mapIdsEmails;
	}

	/**
	* @method      getMapIdEmailRecursivelyOnReportSummaryFactMap
	* @description Returns the record count on summary reports, iterating recursively over report groups.
	* @author      Antonio Torres - 2016-06-23
	*/
	private Map<Id, String> getMapIdEmailRecursivelyOnReportSummaryFactMap(Map<String, Reports.ReportFact> mapFactMap, List<Reports.GroupingValue> lstGroupingValues, Integer intIdColumnIndex, Integer intEmailColumnIndex) {
		Map<Id, String> mapIdsEmails = new Map<Id, String>();

		for(Reports.GroupingValue objGroupingValue : lstGroupingValues) {
			if(objGroupingValue.getGroupings().size() > 0) {
				mapIdsEmails.putAll(getMapIdEmailRecursivelyOnReportSummaryFactMap(mapFactMap, objGroupingValue.getGroupings(), intIdColumnIndex, intEmailColumnIndex));
			} else {
				//System.debug('\n\n-=#=-\n' + 'Rows Summary' + ': ' + ((Reports.ReportFactWithDetails)mapFactMap.get(objGroupingValue.getKey() + '!T')).getRows() + '\n-=#=-\n');

				for(Reports.ReportDetailRow objReportDetailRow : ((Reports.ReportFactWithDetails)mapFactMap.get(objGroupingValue.getKey() + '!T')).getRows()) {
					//System.debug('\n\n-=#=-\n' + 'SUMMARY objReportDetailRow' + ': ' + objReportDetailRow + '\n-=#=-\n');

					//System.debug('\n\n-=#=-\n' + 'SUMMARY objReportDetailRow.getDataCells().get(Id)' + ': ' + Id.valueOf(String.valueOf(objReportDetailRow.getDataCells().get(intIdColumnIndex).getValue())) + '\n-=#=-\n');
					//System.debug('\n\n-=#=-\n' + 'SUMMARY objReportDetailRow.getDataCells().get(Email)' + ': ' + objReportDetailRow.getDataCells().get(intEmailColumnIndex).getValue() + '\n-=#=-\n');
					mapIdsEmails.put(Id.valueOf(String.valueOf(objReportDetailRow.getDataCells().get(intIdColumnIndex).getValue())), String.valueOf(objReportDetailRow.getDataCells().get(intEmailColumnIndex).getValue()));
				}
			}
		}
		return mapIdsEmails;
	}
}