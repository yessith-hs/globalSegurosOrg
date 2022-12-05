public class viewCases_ctr
{
	
	public List<Case> lstCases{ set;get;}
	public viewCases_ctr(ApexPages.StandardController controller)
	{
		lstCases=[SELECT Id,CaseNumber,ContactId,Asuntos__c,Subject,Status,Priority,imagenSemaforo__c,FechaHoraRecibido__c,CreatedDate,Origin ,Poliza__c, OwnerId 
		                 FROM Case where OwnerId=:UserInfo.getUserId()];
	} 
    

}