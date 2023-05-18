import { LightningElement, track, wire } from 'lwc'
import { loadScript } from 'lightning/platformResourceLoader'
import DataUserModule from '@salesforce/resourceUrl/DataUserModule'
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

  async handleMessage(message) {
    if (message) {
      try {
        console.log('Subscribe To Message Channel')
        await loadScript(this, DataUserModule)
        this.insurances = window.DataUserModule.getPolicies(message.data)

        this.loading = false
      } catch (error) {
        console.log(
          '🚀 ~ file: clbinsInsuranceManagement.js:42 ~ ClbinsInsuranceManagement ~ handleMessage ~ error:',
          error
        )
      }
    }
  }

  disconnectedCallback() {
    this.unsubscribeToMessageChannel()
  }
}
