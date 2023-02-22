public class clb_ins_UserSessionHelper {

    @AuraEnabled(cacheable=true)
    public static String getSessionId() {
        return UserInfo.getSessionId();
    }
    
}