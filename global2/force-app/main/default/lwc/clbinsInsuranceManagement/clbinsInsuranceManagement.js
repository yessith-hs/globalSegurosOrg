import { LightningElement } from 'lwc'
import BASE_PATH from '@salesforce/community/basePath'
import { insurance } from './data'
import { getDataInsurance } from './getInsurance'
export default class ClbinsInsuranceManagement extends LightningElement {
  gestionSeguros = `${BASE_PATH}/gestiona-tus-seguros`
  urlSolucionesRecomendadas = `${BASE_PATH}/soluciones-pensadas-para-ti`
  insurances = insurance

  connectedCallback() {
    getDataInsurance()
      .then(data => console.log('response', data))
      .catch(error => console.log('error', error))
  }
}
