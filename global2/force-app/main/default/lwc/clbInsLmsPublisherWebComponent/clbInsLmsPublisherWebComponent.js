import { LightningElement, wire, track } from 'lwc'
import { MessageContext, publish } from 'lightning/messageService'
import INSURANCE_LIST_CHANNEL from '@salesforce/messageChannel/insurance__c'
import getInsurance from '@salesforce/apex/clb_ins_InsuranceListByUser.getInsurance'

export default class ClbInsLmsPublisherWebComponent extends LightningElement {
  publishEvent

  // * Publish LMS
  @wire(MessageContext)
  messageContext

  // * APIGee Connection
  @wire(getInsurance)
  insurance({ data, error }) {
    if (data) {
      try {
        this.loading = false
        const response = JSON.parse(data)
        const insurance = response['responseData'].responseData

        // * Publish LMS
        this.publishEvent = setTimeout(() => {
          const payload = {
            data: insurance
          }

          publish(this.messageContext, INSURANCE_LIST_CHANNEL, payload)
          console.log('Publish Data')
        }, 1000)
      } catch (error) {
        console.log('Catch Error: ' + JSON.parse(error))
      }
    }
    if (error) {
      console.log('response data Error: ' + JSON.parse(error))
    }
  }

  disconnectedCallback() {
    clearTimeout(this.publishEvent)
  }
}
