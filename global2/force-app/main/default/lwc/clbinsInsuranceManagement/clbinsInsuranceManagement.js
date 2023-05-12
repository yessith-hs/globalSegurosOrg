import { LightningElement, track, wire } from 'lwc'

import { subscribe, unsubscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService'

import INSURANCE_LIST_CHANNEL from '@salesforce/messageChannel/insurance__c'

import { firstAdditionalCard, secondAdditionalCard } from 'c/clbinsUtils'

export default class ClbinsInsuranceManagement extends LightningElement {
  @track insurances = []
  loading = true
  subscription = null
  firstAdditionalCard = firstAdditionalCard
  secondAdditionalCard = secondAdditionalCard

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
      this.loading = false
    }
  }

  disconnectedCallback() {
    this.unsubscribeToMessageChannel()
  }
}
