import { LightningElement, track, wire } from 'lwc'
import getInsurance from '@salesforce/apex/clb_ins_InsuranceListByUser.getInsurance'
import BASE_PATH from '@salesforce/community/basePath'
import { response } from './response'
// import { APIGeeConnection } from './getInsurance'
// import { fetchData } from './getInsurance2'

export default class ClbinsInsuranceManagement extends LightningElement {
  urlSolucionesRecomendadas = `${BASE_PATH}/soluciones-pensadas-para-ti`
  insurances = response['responseData'].responseData.policys

  // * Get Content List CMS
  @wire(getInsurance)
  token({ data, error }) {
    if (data) {
      console.log('response data token:', data)
      console.log('response data parse:', JSON.parse(data))
    }
    if (error) {
      console.log('response data Error: ' + JSON.parse(error))
    }
  }

  connectedCallback () {
    // fetchData()
    //   .then(data => console.log('APIGeeConnection', data))
    //   .catch(error => console.log('error', error))

    const body = JSON.stringify({
      personId: 215013,
      email: null,
      documentNumber: null
    })


    fetch('https://apigee.globalseguros.co/develop/gsv/pst/policy/core/users/data', {
      Method: 'POST',
      Headers: {
        'Access-Control-Request-Method': 'POST',
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        Authorization: 'Bearer kAEAfCnKEBtb7NC7vQ6qebDm9iNB'
      },
      Body: body,
      Cache: 'default'
    }).then(data =>
      console.log('🚀 ~ file: ClbinsInsuranceManagement.js:46 ~ getDataInsurance ~ data:', data)
    )
  }

  // * APIGeeConnection
  // async fetchData() {
  //   try {
  //     const credentials = {
  //       url: 'https://apigee.globalseguros.co/gt/security/access_token?grant_type=client_credentials',
  //       clientId: 'vyNC901JQJdpoqpvUjE3ABnNbQAl07kD0B5npJiwXUubXgh1',
  //       clientSecret: 't0HCONxCU7CgH1Nb3xcztogfHrg0x3CXF0Vr13eRXKYYuMBhLSM1eMme4ZQu4qiA'
  //     }
  //     const apigeeConnection = new APIGeeConnection(credentials, true)
  //     const response = await apigeeConnection.fetch(
  //       'POST',
  //       'https://apigee.globalseguros.co/develop/gsv/pst/policy/core/users/data',
  //       {
  //         personId: 215013,
  //         email: null,
  //         documentNumber: null
  //       }
  //     )

  //     // Respuesta de la consulta al APIGee
  //     console.log(response)
  //   } catch (error) {
  //     console.error(error)
  //   }
  // }
}
