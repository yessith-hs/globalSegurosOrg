import { LightningElement, wire, track } from 'lwc'
import { MessageContext, publish } from 'lightning/messageService'
import INSURANCE_LIST_CHANNEL from '@salesforce/messageChannel/insurance__c'
import getInsurance from '@salesforce/apex/clb_ins_InsuranceListByUser.getInsurance'

export default class ClbInsLmsPublisherWebComponent extends LightningElement {
  @track insurances
  publishEvent

  // * Publish LMS
  @wire(MessageContext)
  messageContext

  // * APIGee Connection
  @wire(getInsurance)
  insurance({ data, error }) {
    if (data) {
      this.loading = false
      const response = JSON.parse(data)
      this.insurances = response['responseData'].responseData.policys

      // * Publish LMS
      this.publishEvent = setTimeout(() => {
        const payload = {
          data: this.insurances
        }

        publish(this.messageContext, INSURANCE_LIST_CHANNEL, payload)
      }, 1000)
    }
    if (error) {
      console.log('response data Error: ' + JSON.parse(error))
    }
  }

  disconnectedCallback() {
    clearTimeout(this.publishEvent)
  }
}
