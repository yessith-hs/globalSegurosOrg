import { LightningElement, api } from 'lwc'

export default class ClbinsInsuranceDetailsContentCard extends LightningElement {
  @api insurance

  get hasCoverages() {
    const { coverages } = this.insurance
    const hasCoverage = coverages.length === 0
    return !hasCoverage
  }

  showCoverage() {
    this.template.querySelector('.showcoverage').classList.toggle('active')
  }
}
