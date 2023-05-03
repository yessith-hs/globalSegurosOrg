// const BASE_URL =
//   'https://apigee.globalseguros.co/gt/security/access_token?grant_type=client_credentials'

// const OAUTH_CLIEND_ID = 'vyNC901JQJdpoqpvUjE3ABnNbQAl07kD0B5npJiwXUubXgh1'
// const OAUTH_CLIEND_SECRET = 't0HCONxCU7CgH1Nb3xcztogfHrg0x3CXF0Vr13eRXKYYuMBhLSM1eMme4ZQu4qiA'

// const getToken = async () => {
//   const response = await fetch(BASE_URL, {
//     method: 'POST',
//     headers: {
//       'Content-Type': 'application/x-www-form-urlencoded'
//     },
//     body:
//       'grant_type=client_credentials&client_id=' +
//       OAUTH_CLIEND_ID +
//       '&client_secret=' +
//       OAUTH_CLIEND_SECRET,
//     redirect: 'follow'
//   })
//   const data = response.json()
//   return data
// }

export const getDataInsurance = async () => {
  const API_URL = 'https://apigee.globalseguros.co/develop/gsv/pst/policy/core/users/data'

  // const token = await getToken()
  // console.log('🚀 ~ file: getInsurance.js:31 ~ getDataInsurance ~ token:', token.access_token)

  const body = JSON.stringify({
    personId: 215013,
    email: null,
    documentNumber: null
  })

  fetch(API_URL, {
    Method: 'POST',
    Headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      Authorization: 'Bearer 09GQHxnxkOAs3dPTfICYjTYC2Xou'
    },
    Body: body,
    Cache: 'default'
  })
    .then(data => console.log('🚀 ~ file: getInsurance.js:33 ~ getDataInsurance ~ data:', data))
    .catch(error => console.log('error', error))
}
/**
 *       'Access-Control-Allow-Origin': '*',
      'Access-Control-Request-Method': 'POST',
      'Access-Control-Request-Headers': 'Special-Request-Header',
      'Access-Control-Allow-Headers': Content-Type
      'Access-Control-Allow-Credentials': true,
      Origin: 'https://globalseguros--ta.sandbox.my.site.com',
 */
// headers.append('Accept', 'application.json')
