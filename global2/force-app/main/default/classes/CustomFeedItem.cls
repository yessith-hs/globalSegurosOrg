public class CustomFeedItem {
	@AuraEnabled
    public static clb_ins_CustomFeedItem__c createNewFeedItem(String parentId, String blogId, String body, String title, String firstName, String lastName) {
        clb_ins_CustomFeedItem__c item = new clb_ins_CustomFeedItem__c();
        
        try {
            item.ParentId__c = parentId;
	        item.BlogId__c = blogId;
            item.Body__c = body;
            item.Title__c = title;
            item.FirstName__c = firstName;
            item.LastName__c = lastName;
        
    	    insert item;
        
			System.debug(item);     
        } catch(Exception e) {
            System.debug('Error inserting record: ' +  e.getMessage() );
        }
        
       return item;
    }
    
	@AuraEnabled(cacheable=true)
    public static List<clb_ins_CustomFeedItem__c> getFeedItem(String blogId) {
        List<clb_ins_CustomFeedItem__c> feedList = [SELECT ParentId__c, Title__c, Body__c, FirstName__c, LastName__c, CreatedDate FROM clb_ins_CustomFeedItem__c WHERE blogId__c = :blogId ORDER BY CreatedDate DESC LIMIT 200];
        
        System.debug(feedList);
        
        return feedList;
    }
    
}