({
  // doInit: function (component, event, helper) {
  //   // var recordId = component.get("v.recordId");
  //   // var urlSearchParams = new URLSearchParams(window.location.search);
  //   // var blogId = urlSearchParams.get("blogId");
  //   // ::::::::::::::::
  //    var myPageRef = component.get('v.pageReference')
  //    var blogId = myPageRef.state.blogId
  //   //  component.set('v.blogId', blogId)
  //   // console.log("RECORDID", recordId);
  //   // console.log("URLSEARCHPARAMS", urlSearchParams.get("blogId"));
  // }
  // onPageReferenceChange: function(cmp, evt, helper) {
  //       var myPageRef = cmp.get("v.pageReference");
  //       var id = myPageRef.state.c__blogId
  //       cmp.set("v.id", id);
  //   }

  onPageReferenceChange: function (cmp, evt, helper) {
    var URL = window.location.href
    var blogId = URL.split('blogId=')[1]
    cmp.set('v.recordId', blogId)
  }
})