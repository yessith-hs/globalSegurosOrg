import { LightningElement, api, wire, track } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import createNewFeedItem from "@salesforce/apex/CustomFeedItem.createNewFeedItem";
import getFeedItem from "@salesforce/apex/CustomFeedItem.getFeedItem";
import USER_ID from "@salesforce/user/Id";
import FIRST_NAME from "@salesforce/schema/User.FirstName";
import LAST_NAME from "@salesforce/schema/User.LastName";
import { formatDate } from "c/clbinsUtils";

export default class ClbinsCustomChatter extends LightningElement {
  // commentContainer = this.template.querySelector(".allComments");
  @api blogid;
  userid = USER_ID;
  commentContainer;
  @track firstName;
  @track lastName;

  @wire(getRecord, {
    recordId: "$userid",
    fields: [FIRST_NAME, LAST_NAME]
  })
  user({ data, error }) {
    if (data) {
      this.firstName = getFieldValue(data, FIRST_NAME);
      this.lastName = getFieldValue(data, LAST_NAME);
    }

    if (error) {
      console.log("Error: " + JSON.stringify(error));
    }
  }

  @wire(getFeedItem, { blogId: "$blogid" })
  feedItemList({ data, error }) {
    if (data) {
      console.log("🚀 ~ feedItemList ~ data", data);
      for (let i = 0; i < data.length; i++) {
        const postContainer = document.createElement("div");
        const postTitle = document.createElement("h3");
        const postCreator = document.createElement("p");
        const postBody = document.createElement("p");
        const postLink = document.createElement("a");
        const postDate = formatDate(data[i].CreatedDate);

        postContainer.setAttribute(
          "c-clbinsCustomChatter_clbinsCustomChatter",
          ""
        );
        postTitle.setAttribute("c-clbinsCustomChatter_clbinsCustomChatter", "");
        postCreator.setAttribute(
          "c-clbinsCustomChatter_clbinsCustomChatter",
          ""
        );
        postBody.setAttribute("c-clbinsCustomChatter_clbinsCustomChatter", "");
        postLink.setAttribute("c-clbinsCustomChatter_clbinsCustomChatter", "");

        postContainer.classList.add("post__container");
        postTitle.classList.add("post--title");
        postCreator.classList.add("post--creator");
        postBody.classList.add("post--body");
        postLink.classList.add("post--link");

        postTitle.textContent = data[i].Title__c;
        postCreator.textContent = `${data[i].FirstName__c} ${data[i].LastName__c} en ${postDate}`;
        postBody.textContent = data[i].Body__c;
        postLink.textContent = "Reportar como inapropiado";

        postContainer.appendChild(postTitle);
        postContainer.appendChild(postCreator);
        postContainer.appendChild(postBody);
        postContainer.appendChild(postLink);

        this.commentContainer.appendChild(postContainer);
      }
    }
    if (error) {
      console.log("Error: " + JSON.stringify(error));
    }
  }

  handleAddComment(ev) {
    this.addComment(ev);
  }
  addComment(ev) {
    let commentText, title, wrapDiv;
    // Comment Container

    // const commentBox = document.createElement("div");
    // const titleBox = document.createElement("div");

    const postContainer = document.createElement("div");
    const postTitle = document.createElement("h3");
    const postCreator = document.createElement("p");
    const postBody = document.createElement("p");
    const postLink = document.createElement("a");

    // Reply Button
    // const replyButton = document.createElement("button");
    // replyButton.className = "reply";
    // replyButton.textContent = "Reply";

    if (ev.target.parentElement.classList.contains("comments_container")) {
      // wrapDiv = document.createElement("div");
      // wrapDiv.className = "wrapper";
      // wrapDiv.style.marginLeft = 0;

      // title = this.template.querySelector(".comment--title").value;
      // commentText = this.template.querySelector(".comment--body").value;
      // this.template.querySelector(".comment--title").value = "";
      // this.template.querySelector(".comment--body").value = "";

      // commentBox.textContent = commentText;
      // commentBox.style.backgroundColor = "cornflowerblue";

      // titleBox.textContent = title;

      // wrapDiv.appendChild(titleBox);
      // wrapDiv.appendChild(commentBox);
      // wrapDiv.appendChild(replyButton);

      // this.commentContainer.appendChild(wrapDiv);

      title = this.template.querySelector(".comment--title").value;
      commentText = this.template.querySelector(".comment--body").value;
      this.template.querySelector(".comment--title").value = "";
      this.template.querySelector(".comment--body").value = "";

      postContainer.setAttribute(
        "c-clbinsCustomChatter_clbinsCustomChatter",
        ""
      );
      postTitle.setAttribute("c-clbinsCustomChatter_clbinsCustomChatter", "");
      postCreator.setAttribute("c-clbinsCustomChatter_clbinsCustomChatter", "");
      postBody.setAttribute("c-clbinsCustomChatter_clbinsCustomChatter", "");
      postLink.setAttribute("c-clbinsCustomChatter_clbinsCustomChatter", "");

      postContainer.classList.add("post__container");
      postTitle.classList.add("post--title");
      postCreator.classList.add("post--creator");
      postBody.classList.add("post--body");
      postLink.classList.add("post--link");

      postTitle.textContent = title;
      postCreator.textContent = `${this.firstName} ${this.lastName}`;
      postBody.textContent = commentText;
      postLink.textContent = "Reportar como inapropiado";

      postContainer.appendChild(postTitle);
      postContainer.appendChild(postCreator);
      postContainer.appendChild(postBody);
      postContainer.appendChild(postLink);

      this.commentContainer.appendChild(postContainer);

      // Create new Feed Item
      createNewFeedItem({
        parentId: this.userid,
        blogId: this.blogid,
        body: commentText,
        title: title,
        firstName: this.firstName,
        lastName: this.lastName
      })
        .then((result) => console.log("SUCCESS", result))
        .catch((error) => console.log("ERROR", error));
    } else {
      console.log("DOESNT HAVE CLASS");
    }
  }
  // connectedCallback() {
  //   this.commentContainer = this.template.querySelectorAll(".allComments");
  //   console.log("ALLCOMMENTSNODE", this.commentContainer);
  // }
  renderedCallback() {
    this.commentContainer = this.template.querySelector(".allComments");
    console.log("USERID", this.userid);
  }
}