public  class ValidarCierreCaso_ctr
{	
    /**
    * @Method:      loadVouchers
    * @param:       StandardController 
    * @Description: Method to initialize the controller SendMailCase_ctr.
    */      
    public         String   strIdCaso { get; set; } 
    public         String   strIdPoliza { get; set; } 
    
    public ValidarCierreCaso_ctr(ApexPages.StandardController controller)
    {   
        strIdCaso = ApexPages.currentPage().getParameters().get('id');
              list<Case> lstCaso=  [Select Poliza__c From Case   where id=:strIdCaso ];
              if(lstCaso.size()>0){
              	strIdPoliza=lstCaso.get(0).Poliza__c;
              }
             
    }
 }