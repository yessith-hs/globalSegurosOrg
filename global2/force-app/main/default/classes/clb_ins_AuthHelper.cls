public class clb_ins_AuthHelper implements Callable {
	
    
    public Object call(String methodName, Map<String,object> arguments) {
        Map<String, Object> input = (Map<String, Object>) arguments.get('input');
        Map<String, Object> output = (Map<String, Object>) arguments.get('output');
                       
        try{
            switch on methodName {
                when ('getBase64EncodeCredentials') {
                    String username = String.valueOf(input.get('Username'));
                    String password = String.valueOf(input.get('Password'));
                    
                    String encoded = clb_ins_AuthHelper.getBase64EncodeCredentials(username, password);
                    System.debug('username=' + username);
                    System.debug('password=' + password);
                    System.debug('getBase64EncodeCredentials(' + username + ':' + password + ')=' + encoded);
                    
                    output.put('Base64EncodeCredentials', encoded);
                    System.debug(arguments);
                } 
                when else {
                    throw new CalloutException('Method not implemented');
                }
            }
        } catch(Exception e){
            System.debug(e.getMessage() + '=>' + e.getStackTraceString());
        }
        
        return output;
    }
    
    public static String getBase64EncodeCredentials(String username, String password){
        String encodedCredentials = EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password));

        return encodedCredentials;
    }
    
}