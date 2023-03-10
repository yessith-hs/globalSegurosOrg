public class clb_ins_UserSessionHelper {

  // * Get Token Session ID.
    @AuraEnabled(cacheable=true)
    public static String getSessionId() {
        return UserInfo.getSessionId();
    }

    // * Get Salesforce Base URL.
    @AuraEnabled(cacheable=true)
    public static String getOrgDomainUrl() {
        return URL.getOrgDomainUrl().toExternalForm();
    }

}

