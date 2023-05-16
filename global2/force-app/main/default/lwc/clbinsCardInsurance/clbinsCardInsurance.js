import { LightningElement, api } from 'lwc'
import { NavigationMixin } from 'lightning/navigation'
import { INSURANCE_COLORS } from 'c/clbinsUtils'

import basePath from '@salesforce/community/basePath'
export default class ClbinsCardInsurance extends NavigationMixin(LightningElement) {
  @api insurance
  defaultColor = 'rgb(80, 80, 80)'
  insuranceColor

  connectedCallback() {
    if (this.insurance) {
      const color = this.insurance.insuranceLineDescription.toLowerCase()

      this.insuranceColor = INSURANCE_COLORS[color] ?? this.defaultColor
    }
  }

  handleShowDetails(event) {
    this[NavigationMixin.Navigate]({
      type: 'standard__webPage',
      attributes: {
        url: `${basePath}/gestiona-tus-seguros/detalle-del-seguro?insuranceId=${event.currentTarget.dataset.id}`
      }
    })
  }

  get styleRamoSeguro() {
    return `
    height: 12px;
    width: 12px;
    border-radius: 50%;
    background-color: ${this.insuranceColor};
    display: block;
    position: absolute;
    top: 19px;
    right: 16px;
    `
  }

  get styleRamoSeguroBorder() {
    return `
    box-shadow:  0 2px 0 0 ${this.insuranceColor};
    padding: 1rem 0.5rem 0;
    `
  }

  get styleDate() {
    return `
    color:  ${this.insuranceColor};
    font-weight: 700;
    `
  }

  get progressBar() {
    return `
    background-color:  ${this.insuranceColor};
    width: ${this.insurance.timeLeft}%;
    `
  }

  get progressBarTitle() {
    return `
    color:  ${this.insuranceColor};
    `
  }
}
