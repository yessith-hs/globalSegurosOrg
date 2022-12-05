import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

import basePath from "@salesforce/community/basePath";

export default class ClbinsCardPost extends NavigationMixin(
  LightningElement
)  {
  @api post;

  handleClick(event) {
    this[NavigationMixin.Navigate]({
      type: "standard__webPage",
      attributes: {
        url: `${basePath}/conexion-global/post?blogId=${event.currentTarget.dataset.id}`
      }
    });
  }
}