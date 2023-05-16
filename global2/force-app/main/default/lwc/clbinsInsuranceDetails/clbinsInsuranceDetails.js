import { LightningElement, track, wire } from 'lwc'
import { loadScript } from 'lightning/platformResourceLoader'
import DataUserModule from '@salesforce/resourceUrl/DataUserModule'
import { subscribe, unsubscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService'
import INSURANCE_LIST_CHANNEL from '@salesforce/messageChannel/insurance__c'
import BASE_PATH from '@salesforce/community/basePath'
import { CurrentPageReference } from 'lightning/navigation'
import { INSURANCE_COLORS } from 'c/clbinsUtils'

export default class ClbinsInsuranceDetails extends LightningElement {
  static renderMode = 'light'
  gestionSeguros = `${BASE_PATH}/gestiona-tus-seguros`
  @track insuranceId
  @track sigleInsurance = {}
  loading = true
  subscription = null
  defaultColor = 'rgb(80, 80, 80)'
  insuranceColor

  // * get id insurance
  @wire(CurrentPageReference)
  pageReference({ state }) {
    if (state && state.insuranceId) {
      this.insuranceId = parseInt(state.insuranceId)
    }
  }

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
    try {
      if (message) {
        await loadScript(this, DataUserModule)
        this.sigleInsurance = window.DataUserModule.getSinglePolicy(message.data, this.insuranceId)

        // * Set color by insurance type
        if (this.sigleInsurance) {
          const color = this.sigleInsurance.insuranceLineDescription.toLowerCase()

          this.insuranceColor = INSURANCE_COLORS[color] ?? this.defaultColor
        }

        this.loading = false
      }
    } catch (error) {
      console.log(
        '🚀 ~ file: clbinsInsuranceManagement.js:64 ~ ClbinsInsuranceManagement ~ handleMessage ~ error:',
        error
      )
    }
  }

  get styleRamoSeguro() {
    return `
    display: block;
    position: absolute;
    height: 12px;
    width: 12px;
    top: 10px;
    right: 3px;
    border-radius: 50%;
    background-color: ${this.insuranceColor};
    `
  }

  get styleRamoSeguroBorder() {
    return `
    box-shadow:  0 2px 0 0 ${this.insuranceColor};
    padding: 1rem 0.5rem;
    `
  }

  disconnectedCallback() {
    this.unsubscribeToMessageChannel()
  }
}
