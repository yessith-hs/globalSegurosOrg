import { LightningElement, api } from 'lwc'
import { STATE_COLORS, normalizeStr } from 'c/clbinsUtils'

export default class ClbinsInsuranceDetailsContent extends LightningElement {
  @api insurance
  defaultColor = 'rgb(80, 80, 80)'
  colorState

  connectedCallback() {
    if (this.insurance) {
      const color = normalizeStr(this.insurance.policyStatus)

      this.colorState = STATE_COLORS[color] ?? this.defaultColor
    }
  }

  get hasBeneficiaries() {
    const { beneficiaries } = this.insurance
    const hasBeneficiary = beneficiaries.length === 0
    return !hasBeneficiary
  }

  get stateColor() {
    return `
    background-color: ${this.colorState};
    `
  }
}

//policyStatus
