import { LightningElement, wire } from 'lwc'
import BASE_PATH from '@salesforce/community/basePath'

import { MessageContext, publish } from 'lightning/messageService'
import INSURANCE_LIST_CHANNEL from '@salesforce/messageChannel/insurance__c'

export default class ClbinsHeaderMenu extends LightningElement {
  styleflex = true
  gestionSeguros = `${BASE_PATH}/gestiona-tus-seguros`
  urlSoyGlobal = `${BASE_PATH}/soy-global`
  home = BASE_PATH

  //
  insurance = [
    {
      id: 1,
      policyNumber: 82477885,
      insuranceName: 'Seguro Educativo',
      color: '#0087DC',
      nextPaymentDate: '31/03/2023',
      amount: 250000,
      isExpired: false
    },
    {
      id: 2,
      policyNumber: 82478457,
      insuranceName: 'Seguro Vida',
      color: '#FF5555',
      nextPaymentDate: '31/03/2023',
      amount: 137000,
      isExpired: true
    },
    {
      id: 3,
      policyNumber: 82478457,
      insuranceName: 'Seguro Pensión',
      color: '#349F63',
      nextPaymentDate: '31/03/2023',
      amount: 137000,
      isExpired: false
    },
    {
      id: 4,
      policyNumber: 82478457,
      insuranceName: 'Renta Voluntaria',
      color: '#9B4B91',
      nextPaymentDate: '31/03/2023',
      amount: 250000,
      isExpired: false
    },
    {
      id: 5,
      policyNumber: 82478457,
      insuranceName: 'Global LifeINDX',
      color: '#FF5555',
      nextPaymentDate: '31/03/2023',
      amount: 250000,
      isExpired: true
    }
  ]

  @wire(MessageContext)
  context

  publishLMS() {
    const payload = {
      data: this.insurance
    }

    publish(this.context, INSURANCE_LIST_CHANNEL, payload)
  }

  activeMenu() {
    this.template.querySelector('nav').classList.add('active')
    this.template.querySelector('.navmenu_background').classList.add('show')
  }
  closeMenu() {
    this.template.querySelector('nav').classList.remove('active')
    this.template.querySelector('.navmenu_background').classList.remove('show')
  }
}
