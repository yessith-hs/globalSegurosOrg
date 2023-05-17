import { LightningElement, wire, api } from 'lwc'

export default class ClbinsInsuranceDetailsContent extends LightningElement {
  @api insurance

  get hasBeneficiaries() {
    const { beneficiaries } = this.insurance
    const hasBeneficiary = beneficiaries.length === 0
    return !hasBeneficiary
  }
}
