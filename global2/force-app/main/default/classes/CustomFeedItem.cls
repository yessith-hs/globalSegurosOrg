/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 02-23-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public class CustomFeedItem {
    @AuraEnabled
    public static clb_ins_CustomFeedItem__c createNewFeedItem(
        String parentId,
        String blogId,
        String blogTitle,
        String blogTopic,
        String body,
        String title,
        String firstName,
        String lastName
    ) {
        clb_ins_CustomFeedItem__c item = null;

        try {
            clb_ins_CustomFeedItem__c newItem = new clb_ins_CustomFeedItem__c();
            newItem.ParentId__c = parentId; // ownerId, publisherId
            newItem.BlogId__c = blogId;
            newItem.BlogTitle__c = blogTitle;
            newItem.Topic__c = blogTopic;
            newItem.Body__c = body;
            newItem.Title__c = title; // subject
            newItem.FirstName__c = firstName;
            newItem.LastName__c = lastName;
            //newItem.Status__c = 'PendingModeration'; // PickList PendingModeration, Rejected, Approved

            insert newItem;

            // item = newItem;
            item = [
                SELECT Id, Title__c, Body__c, FirstName__c, LastName__c, CreatedDate
                FROM clb_ins_CustomFeedItem__c
                WHERE Id = :newItem.Id
            ];
        } catch (Exception e) {
            System.debug('Error inserting record: ' + e.getMessage());
        }

        return item;
    }

    @AuraEnabled(cacheable=true)
    public static List<clb_ins_CustomFeedItem__c> getFeedItems(String blogId) {
        List<clb_ins_CustomFeedItem__c> feedList = [
            SELECT Id, ParentId__c, Title__c, Body__c, FirstName__c, LastName__c, CreatedDate
            FROM clb_ins_CustomFeedItem__c
            WHERE blogId__c = :blogId AND Status__c = 'Approved'
            ORDER BY CreatedDate DESC
            LIMIT 200
        ]; // add WHERE status__c = 'Approved'

        System.debug(feedList);

        return feedList;
    }

    @AuraEnabled(cacheable=true)
    public static clb_ins_CustomFeedItem__c getFeedItem(String itemId) {
        clb_ins_CustomFeedItem__c feedItem = [
            SELECT Id, ParentId__c, Title__c, Body__c, FirstName__c, LastName__c, CreatedDate
            FROM clb_ins_CustomFeedItem__c
            WHERE Id = :itemId AND Status__c = 'Approved'
            ORDER BY CreatedDate DESC
            LIMIT 1
        ]; // add WHERE status__c = 'Approved'

        System.debug(feedItem);

        return feedItem;
    }
}