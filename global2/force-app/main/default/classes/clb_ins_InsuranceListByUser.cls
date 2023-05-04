public class clb_ins_InsuranceListByUser {

  // * Get Access Token
  @AuraEnabled(cacheable=true)
  public static String getAccessToken() {

    String OAUTH_CLIEND_ID ='vyNC901JQJdpoqpvUjE3ABnNbQAl07kD0B5npJiwXUubXgh1';
    String OAUTH_CLIEND_SECRET ='t0HCONxCU7CgH1Nb3xcztogfHrg0x3CXF0Vr13eRXKYYuMBhLSM1eMme4ZQu4qiA';
    String URL_API='https://apigee.globalseguros.co/gt/security/access_token?grant_type=client_credentials';

    Http http = new Http();
    HttpRequest request = new HttpRequest();

    request.setEndpoint(URL_API);
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    request.setBody('grant_type=client_credentials&client_id=' + OAUTH_CLIEND_ID + '&client_secret=' + OAUTH_CLIEND_SECRET);

    HttpResponse response = http.send(request);
    System.debug('Respose Status Code' + response.getStatusCode());
    System.debug('Respose Body' + response.getBody());

    return response.getBody();

  }


  // * Get Insurance
  @AuraEnabled(cacheable=true)
  public static String getInsurance() {
    String token = getAccessToken();
    Map<String,Object>jsonMap=(Map<String,Object>)JSON.deserializeUntyped(token);
    String accessToken = (String)jsonMap.get('access_token');
    System.debug('token: ' + accessToken);


    String URL_API = 'https://apigee.globalseguros.co/develop/gsv/pst/policy/core/users/data';

    String personId = '215013';
    String email = null;
    String documentNumber = null;
    String requestBody = '{"personId": ' + personId + ', "email": ' + email + ', "documentNumber": ' + documentNumber + '}';

    System.debug('requestBody: ' + requestBody);


    HttpRequest request = new HttpRequest();
    request.setEndpoint(URL_API);
    request.setMethod('POST');
    request.setHeader('Access-Control-Allow-Origin', '*');
    request.setHeader('Accept', 'application/json');
    request.setHeader('Origin', 'https://globalseguros--ta.sandbox.my.site.com');
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    request.setHeader('Authorization', 'Bearer' + accessToken);
    request.setBody(requestBody);

    Http http = new Http();
    HttpResponse response = http.send(request);

    System.debug('Respose Status Code: ' + response.getStatusCode());
    System.debug('Respose Body: ' + response.getBody());
    System.debug('Respose getHeaderKeys: ' + response.getHeaderKeys());

    return response.getBody();
  }
}