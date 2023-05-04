import { LightningElement } from 'lwc'

export default class TestFetchGlobal extends LightningElement {
  connectedCallback() {
    this.getDataInsurance()
      .then(data => console.log('response data', data))
      .catch(error => console.log('error', error))
  }

  getDataInsurance = async () => {
    const API_URL = 'https://apigee.globalseguros.co/develop/gsv/pst/policy/core/users/data'

    // const token = await getToken()
    // console.log('🚀 ~ file: getInsurance.js:31 ~ getDataInsurance ~ token:', token.access_token)

    fetch(API_URL, {
      Method: 'POST',
      Headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': true,
        'Access-Control-Allow-Methods': 'POST,OPTIONS',
        'Access-Control-Allow-Headers':
          'Origin, X-Requested-With, Content-Type, Accept,Authorization',
        Origin: 'https://globalseguros--ta.sandbox.my.site.com',
        'Content-Type': 'application/json',
        Accept: 'application/json',
        Authorization: 'Bearer d63InfZi17mLAjBiKqMNa5UDfuho'
      },
      Body: JSON.stringify({
        personId: 215013,
        email: null,
        documentNumber: null
      }),
      Cache: 'default',
      credentials: 'include'
    })
      .then(data => console.log('🚀 ~ file: getInsurance.js:33 ~ TestFetchGlobal ~ data:', data))
      .catch(error => console.log('error', error))
  }
}
