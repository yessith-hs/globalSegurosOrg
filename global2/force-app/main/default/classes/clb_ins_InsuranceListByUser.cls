public class clb_ins_InsuranceListByUser {

    // * Get Access Token
    public static HttpResponse getAccessToken() {
        final String OAUTH_CLIEND_ID ='vyNC901JQJdpoqpvUjE3ABnNbQAl07kD0B5npJiwXUubXgh1';
        final String OAUTH_CLIEND_SECRET ='t0HCONxCU7CgH1Nb3xcztogfHrg0x3CXF0Vr13eRXKYYuMBhLSM1eMme4ZQu4qiA';

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint('https://apigee.globalseguros.co/gt/security/access_token?grant_type=client_credentials');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setBody('grant_type=client_credentials&client_id=' + OAUTH_CLIEND_ID + '&client_secret=' + OAUTH_CLIEND_SECRET);

        HttpResponse response = http.send(request);
        System.debug('Respose Status Code' + response.getStatusCode());
        System.debug('Respose Body' + response.getBody());

        if(response.getStatusCode() == 200) {
          Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

        }

        return response;

    }



    // * Get Insurance By User



}