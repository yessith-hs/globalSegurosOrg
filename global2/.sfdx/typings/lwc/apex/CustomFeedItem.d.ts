declare module "@salesforce/apex/CustomFeedItem.createNewFeedItem" {
  export default function createNewFeedItem(param: {parentId: any, blogId: any, blogTitle: any, blogTopic: any, body: any, title: any, firstName: any, lastName: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomFeedItem.getFeedItems" {
  export default function getFeedItems(param: {blogId: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomFeedItem.getFeedItem" {
  export default function getFeedItem(param: {itemId: any}): Promise<any>;
}
