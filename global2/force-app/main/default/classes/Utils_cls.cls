/**
**************************************************************************************************************
* @company         Avanxo Colombia
* @author          Antonio Torres href=<atorres@avanxo.com>
* @proyect         Global Seguros
* @name            Utils_cls
* @description     Utility class
* @dependencies    Class "OrgWideLimit_cls"
* @changes (Version)
* --------   ---   ----------   ---------------------------   ------------------------------------------------
*            No.   Date         Author                        Description
* --------   ---   ----------   ---------------------------   ------------------------------------------------
* @version   1.0   2016-06-21   Antonio Torres (AT)           Creation of the class.
* @version   2.0   2016-08-26   Antonio Torres (AT)           Class access modified and some methods moved to
*                                                             "ReportUtils_cls" class.
**************************************************************************************************************
**/

public without sharing class Utils_cls {
    private static String strLatestApiVersion;

    /**
    * @method      getOrgWideLimit
    * @description Returns the org wide limit from the limit passed as parameter.
    * @author      Antonio Torres - 2016-06-21
    */
    public static OrgWideLimit_cls getOrgWideLimit(String strLimitName,String idSesion) {
        String strEndpoint =    System.URL.getSalesforceBaseURL().toExternalForm() +
                                '/services/data/v' +
                                getLatestApiVersion() +
                                '/limits';
        
        System.debug('\n\n-=#=-\n' + 'strEndpoint' + ': ' + strEndpoint + '\n-=#=-\n');

        HttpRequest objRequest = new HttpRequest();
        objRequest.setEndpoint(strEndpoint); // Remember to allow access to this endpoint (Instance URL), on remote site settings.
        if(idSesion <> null){
        	objRequest.setHeader('Authorization', 'OAuth ' + idSesion);
        }else{
        	objRequest.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionID());
        }
        objRequest.setMethod('GET');

        Http objHTTP = new Http();
        HttpResponse objHttpResponse = objHTTP.send(objRequest);
        
        String strResponse = objHttpResponse.getBody();
        System.debug('\n\n-=#=-\n' + 'getOrgWideLimit.strResponse' + ': ' + strResponse + '\n-=#=-\n');

        OrgWideLimit_cls objOrgWideLimit = new OrgWideLimit_cls(strLimitName);
        try {
            Map<String, Object> mapOrgWideLimits = (Map<String, Object>)JSON.deserializeUntyped(strResponse);
            //System.debug('\n\n-=#=-\n' + 'getOrgWideLimit.mapOrgWideLimits' + ': ' + mapOrgWideLimits + '\n-=#=-\n');

            objOrgWideLimit.setMax(Integer.valueOf(((Map<String, Object>)mapOrgWideLimits.get(strLimitName)).get('Max')));
            objOrgWideLimit.setRemaining(Integer.valueOf(((Map<String, Object>)mapOrgWideLimits.get(strLimitName)).get('Remaining')));
        } catch(Exception objException) {
            objOrgWideLimit.setMax(-1);
            objOrgWideLimit.setRemaining(-1);
        }

        System.debug('\n\n-=#=-\n' + 'Limit "' + strLimitName + '" (Max)' + ': ' + objOrgWideLimit.getMax() + '\n-=#=-\n');
        System.debug('\n\n-=#=-\n' + 'Limit "' + strLimitName + '" (Remaining)' + ': ' + objOrgWideLimit.getRemaining() + '\n-=#=-\n');

        return objOrgWideLimit;
    }

    /**
    * @method      getLatestApiVersion
    * @description Returns the latest available API version in this instance.
    * @author      Antonio Torres - 2016-06-21
    */
    public static String getLatestApiVersion() {
        if(strLatestApiVersion == null) {
            HttpRequest objRequest = new HttpRequest();
            objRequest.setEndpoint(System.URL.getSalesforceBaseURL().toExternalForm() + '/services/data/'); // Remember to allow access to this endpoint (Instance URL), on remote site settings.
            objRequest.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionID());
            objRequest.setMethod('GET');

            Http objHTTP = new Http();
            HttpResponse objHttpResponse = objHTTP.send(objRequest);

            String strResponse = objHttpResponse.getBody();
            System.debug('\n\n-=#=-\n' + 'getLatestApiVersion.strResponse' + ': ' + strResponse + '\n-=#=-\n');
            
            List<Object> lstResponse = (List<Object>)JSON.deserializeUntyped(strResponse);
            //System.debug('\n\n-=#=-\n' + 'getLatestApiVersion.lstResponse' + ': ' + lstResponse + '\n-=#=-\n');

            strLatestApiVersion = String.valueOf(((Map<String, Object>)lstResponse[lstResponse.size() - 1]).get('version'));
            System.debug('\n\n-=#=-\n' + 'Latest API Version' + ': ' + strLatestApiVersion + '\n-=#=-\n');
        }
        
        return strLatestApiVersion;
    }
}