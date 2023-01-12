import { LightningElement,api } from 'lwc';
import { NavigationMixin } from "lightning/navigation";

import basePath from "@salesforce/community/basePath";
export default class ClbinsCardInsurance extends NavigationMixin(
  LightningElement
)  {
   @api insurance;

  handleClick(event) {
    this[NavigationMixin.Navigate]({
      type: 'standard__webPage',
      attributes: {
        url: `${basePath}/gestiona-tus-seguros/detalle-del-seguro?insuranceId=${event.currentTarget.dataset.id}`
      }
    })
  }
}