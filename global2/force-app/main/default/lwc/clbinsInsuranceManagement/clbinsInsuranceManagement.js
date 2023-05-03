import { LightningElement, track, wire } from 'lwc'
import BASE_PATH from '@salesforce/community/basePath'
import { response } from './response'
import { getDataInsurance } from './getInsurance'

// import getAccessToken from '@salesforce/apex/clb_ins_InsuranceListByUser.getAccessToken'
import { APPLICATION_SCOPE, MessageContext, subscribe, unsubscribe } from 'lightning/messageService'
import INSURANCE_LIST_CHANNEL from '@salesforce/messageChannel/insurance__c'

export default class ClbinsInsuranceManagement extends LightningElement {
  urlSolucionesRecomendadas = `${BASE_PATH}/soluciones-pensadas-para-ti`
  insurances = response['responseData'].responseData.policys

  subscription = null
  @track receivedInsurance = []


  // @wire(getAccessToken)
  // accessToken({ data, error }) {
  //   if (data) {
  //     console.log('token:', data)
  //   }
  //   if (error) {
  //     console.log('Error: ' + JSON.stringify(error))
  //   }
  // }

  @wire(MessageContext)
  context

  // * Encapsulate logic for Lightning message service subscribe and unsubsubscribe
  subscribeToMessageChannel() {
    if (this.subscription) return

    this.subscription = subscribe(this.context, INSURANCE_LIST_CHANNEL, message => {
      this.handleMessage(message), { scope: APPLICATION_SCOPE }
    })
  }

  unsubscribeToMessageChannel() {
    unsubscribe(this.subscription)
    this.subscription = null
  }

  // * Handler for message received by component
  handleMessage(message) {
    console.log(
      '🚀 ~ file: clbinsInsuranceManagement.js:33 ~ ClbinsInsuranceManagement ~ handleMessage ~ message:',
      message
    )
    this.receivedInsurance = message.data
  }

  // * Standard lifecycle hooks used to subscribe and unsubsubscribe to the message channel
  connectedCallback() {
    getDataInsurance()

    this.subscribeToMessageChannel()
  }

  disconnectedCallback() {
    this.unsubscribeToMessageChannel()
  }
}
