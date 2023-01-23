public class clb_ins_EconomicActivityHelper implements vlocity_ins.VlocityOpenInterface {
    
    // Get All Relationship Types for Account when the Omniscript is compiled.
    public static void PopulatePicklist(Map<String, Object> input, 
                                 Map<String, Object> outMap, 
                                 Map<String, Object> options) {
        List<Map<String, String>> outputOptions = new List <Map<String, String>>();
        	for (clb_ins_EconomicActivity__c activity: [Select Id, Name, clb_ins_Description__c
                                                      	FROM clb_ins_EconomicActivity__c
                                                       	LIMIT 10]) {
				Map<String, String> tempMap = new Map <String, String> ();
                tempMap.put('name', activity.Id);
                // Language Independent
                tempMap.put('value', activity.Name);
                // Displayed in Picklist
                outputOptions.add(tempMap);
        }
        outMap.put('options', outputOptions);
    }
    
	public Boolean invokeMethod(String methodName, 
                                Map<String, Object> input, 
                                Map<String, Object> outMap, 
                                Map<String, Object> options) {

		if (methodName.equals('PopulatePicklist')) {
            PopulatePicklist(input, outMap, options);
		}
                                    
        return true;
    }
    
}