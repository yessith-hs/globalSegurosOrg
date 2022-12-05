global class clb_ins_AuthHelper2 implements vlocity_ins.VlocityOpenInterface {
	   
    public static String getBase64EncodeCredentials(String username, String password){
        String encodedCredentials = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password));

        return encodedCredentials;
    }
    
    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {
        Boolean result = false;
        
        try{
            switch on methodName {
                when ('getBase64EncodeCredentials') {
                    String username = String.valueOf(input.get('Username'));
                    String password = String.valueOf(input.get('Password'));
                    
                    String encoded = clb_ins_AuthHelper2.getBase64EncodeCredentials(username, password);
                    System.debug('username=' + username);
                    System.debug('password=' + password);
                    System.debug('getBase64EncodeCredentials(' + username + ':' + password + ')=' + encoded);
                    
                    output.put('Base64EncodeCredentials', encoded);
                    System.debug(output);
                    result = true;
                } 
                when else {
                    throw new CalloutException('Method not implemented');
                }
            }
        } catch(Exception e){
            System.debug(e.getMessage() + '=>' + e.getStackTraceString());
        }
        
        return result;
    }
    
}