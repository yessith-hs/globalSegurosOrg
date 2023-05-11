import { LightningElement, track, wire } from 'lwc'
import getInsurance from '@salesforce/apex/clb_ins_InsuranceListByUser.getInsurance'
import BASE_PATH from '@salesforce/community/basePath'

import { subscribe, unsubscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService'
import INSURANCE_LIST_CHANNEL from '@salesforce/messageChannel/insurance__c'

export default class ClbinsInsuranceManagement extends LightningElement {
  urlSolucionesRecomendadas = `${BASE_PATH}/soluciones-pensadas-para-ti`
  loading = true
  @track insurances = []
  subscription = null

  // * APIGeeConnection
  // @wire(getInsurance)
  // insurance({ data, error }) {
  //   if (data) {
  //     this.loading = false
  //     const response = JSON.parse(data)
  //     this.insurances = response['responseData'].responseData.policys

  //     console.log('response data parse:', response)
  //   }
  //   if (error) {
  //     console.log('response data Error: ' + JSON.parse(error))
  //   }
  // }

  @wire(MessageContext)
  messageContext

  connectedCallback() {
    this.subscribeToMessageChannel()
  }

  subscribeToMessageChannel() {
    if (this.subscription) return

    this.subscription = subscribe(this.messageContext, INSURANCE_LIST_CHANNEL, message => {
      this.handleMessage(message), { scope: APPLICATION_SCOPE }
    })
  }

  unsubscribeToMessageChannel() {
    unsubscribe(this.subscription)
    this.subscription = null
  }

  handleMessage(message) {
    if (message) {
      this.insurances = message.data
      console.log(
        '🚀 ~ file: clbinsInsuranceManagement.js:57 ~ ClbinsInsuranceManagement ~ handleMessage ~ this.insurances:',
        message.data
      )
      this.loading = false
    }
  }

  disconnectedCallback() {
    this.unsubscribeToMessageChannel()
  }
}
