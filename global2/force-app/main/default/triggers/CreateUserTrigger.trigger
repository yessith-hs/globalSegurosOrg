trigger CreateUserTrigger on User (before insert) {
	
    if(trigger.isBefore){
        if(trigger.isInsert){
            
            List<String> profileList = new List<String>();
            for(User u: trigger.new){
                Map<String, Object> jsonObject = (Map<String, Object>) JSON.deserializeUntyped(u.Auth_Raw_JSON__c);
                if(jsonObject.containsKey('profileName'))
                    if(!String.isBlank((String)jsonObject.get('profileName')))
                    	profileList.add((String)jsonObject.get('profileName'));
            }
            
            List<Profile> profileDataList = [Select id,Name from Profile Where Name In: profileList];
            Map<String, Id> profileMap = new Map<String, Id>();
            for (Profile p : profileDataList) {
                profileMap.put(p.Name, p.Id);
            }

            
            for(User u: trigger.new){
                if(!String.isBlank(u.Auth_Raw_JSON__c)){
                    Map<String, Object> jsonObject = (Map<String, Object>) JSON.deserializeUntyped(u.Auth_Raw_JSON__c);
					u.LastName = jsonObject.containsKey('Name') ? (String)jsonObject.get('Name') : '';
                    u.Email = jsonObject.containsKey('email') ? (String)jsonObject.get('email') : '';
                    u.TimeZoneSidKey = 'America/Bogota';
                    u.LocaleSidKey = 'en_US';
        			u.LanguageLocaleKey =  'en_US';
        			u.EmailEncodingKey = 'UTF-8';
        			u.Username = jsonObject.containsKey('email') ? (String)jsonObject.get('email') : '';
        			u.Alias = jsonObject.containsKey('nickname') ? (String)jsonObject.get('nickname') : '';
                    String profileName = jsonObject.containsKey('profileName') ? (String)jsonObject.get('profileName') : '';
        			u.ProfileId = profileMap.containsKey(profileName) ? profileMap.get(profileName) : '';
                    u.IsActive = false;
                }
            }
        }
    }
}