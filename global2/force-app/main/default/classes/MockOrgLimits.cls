@isTest
global class MockOrgLimits implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Host', 'ap1.salesforce.com');
        
        
        Map<String,MockOrgLimits.valores> cuerpo = new Map<String,MockOrgLimits.valores>();
        cuerpo.put('MassEmail',new MockOrgLimits.valores('1000','1000'));
        cuerpo.put('SingleEmail',new MockOrgLimits.valores('1000','998'));
        
        list<MockOrgLimits.valoresX> cuerpoX = new list<MockOrgLimits.valoresX>();
        cuerpoX.add(new MockOrgLimits.valoresX('Spring \'16','36.0','/services/data/v36.0'));
        cuerpoX.add(new MockOrgLimits.valoresX('Summer \'15','34.0','/services/data/v34.0'));
		
		String auxBody = '';
        if(req.getEndPoint().contains('/limits'))
        	auxBody = JSON.serialize(cuerpo);
        else
        	auxBody = JSON.serialize(cuerpoX);
        
        //res.setBody('{"MassEmail":{"Max":1000,"Remaining":1000},"SingleEmail":{"Max":1000,"Remaining":998}}');
        
        String sbody = auxBody;
        res.setHeader('Content-Length', String.valueOf(sbody.length()));
        res.setBody(sbody);
        res.setStatusCode(200);
        return res;
    }
    
    public class valores{
    	public String max {get; set;}
    	public String min {get; set;}
    	
    	public valores(String parMax, String parMin){
    		max = parMax;
    		min = parMin;
    	}
    }
    
    
    public class valoresX{
    	public String label {get; set;}
    	public String version {get; set;}
    	public String url {get; set;}
    	
    	public valoresX(String parLabel, String parVersion, String parUrl){
    		label = parLabel;
    		version = parVersion;
    		url = parUrl;
    	}
    }
}