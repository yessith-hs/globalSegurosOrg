import { LightningElement, api } from 'lwc'
import { NavigationMixin } from 'lightning/navigation'

import basePath from '@salesforce/community/basePath'
export default class ClbinsCardInsurance extends NavigationMixin(
  LightningElement
) {
  @api insurance

  handleClick (event) {
    this[NavigationMixin.Navigate]({
      type: 'standard__webPage',
      attributes: {
        url: `${basePath}/gestiona-tus-seguros/detalle-del-seguro?insuranceId=${event.currentTarget.dataset.id}`
      }
    })
  }

  get getStyleRamoSeguro() {
    return `
    height: 12px;
    width: 12px;
    border-radius: 50%;
    background-color: ${this.insurance.color};
    display: block;
    position: absolute;
    top: 19px;
    right: 16px;
    `
  }

  get getStyleRamoSeguroBorder() {
    return `
    box-shadow:  0 2px 0 0 ${this.insurance.color};
    margin-bottom: 0.7rem;
    padding: 1rem 1rem 0;
    `
  }
}
