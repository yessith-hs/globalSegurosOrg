import { LightningElement, track, wire } from 'lwc'
import getInsurance from '@salesforce/apex/clb_ins_InsuranceListByUser.getInsurance'
import BASE_PATH from '@salesforce/community/basePath'
import { response } from './response'

export default class ClbinsInsuranceManagement extends LightningElement {
  urlSolucionesRecomendadas = `${BASE_PATH}/soluciones-pensadas-para-ti`
  // insurances = response['responseData'].responseData.policys
  loading = true

  // * APIGeeConnection
  @wire(getInsurance)
  insurance({ data, error }) {
    if (data) {
      this.loading = false
      const respose = JSON.parse(data)
      this.insurances = response['responseData'].responseData.policys

      console.log('response data parse:', respose)
    }
    if (error) {
      console.log('response data Error: ' + JSON.parse(error))
    }
  }
}
