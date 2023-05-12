import { LightningElement, wire } from 'lwc'
import getInsurance from '@salesforce/apex/clb_ins_InsuranceListByUser.getInsurance'

export default class ClbinsInsuranceDetailsContent extends LightningElement {
  insurance = []

  connectedCallback() {
    console.log('data', this.insurance)
  }

  // * APIGee Connection
  @wire(getInsurance)
  response({ data, error }) {
    if (data) {
      this.loading = false
      const response = JSON.parse(data)
      this.insurance = response['responseData'].responseData.policys[0]
    }
    if (error) {
      console.log('response data Error: ' + JSON.parse(error))
    }
  }
}
