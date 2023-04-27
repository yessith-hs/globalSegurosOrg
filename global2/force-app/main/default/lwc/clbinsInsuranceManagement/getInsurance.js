const BASE_URL =
  'https://apigee.globalseguros.co/gt/security/access_token?grant_type=client_credentials'

const OAUTH_CLIEND_ID = 'vyNC901JQJdpoqpvUjE3ABnNbQAl07kD0B5npJiwXUubXgh1'
const OAUTH_CLIEND_SECRET = 't0HCONxCU7CgH1Nb3xcztogfHrg0x3CXF0Vr13eRXKYYuMBhLSM1eMme4ZQu4qiA'

const getToken = async () => {
  const requestOptions = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body:
      'grant_type=client_credentials&client_id=' +
      OAUTH_CLIEND_ID +
      '&client_secret=' +
      OAUTH_CLIEND_SECRET,
    redirect: 'follow'
  }

  const response = await fetch(BASE_URL, requestOptions)
  const data = response.json()
  return data
}

export const getDataInsurance = async () => {
  const API_URL =
    'https://apigee.globalseguros.co/develop/gsv/legacy/policy/core/users/get-core-user-data'

  const token = await getToken()
  console.log('🚀 ~ file: getInsurance.js:31 ~ getDataInsurance ~ token:', token.access_token)

  const raw = JSON.stringify({
    personId: 215013,
    email: null,
    documentNumber: null
  })

  const requestOptions = {
    method: 'POST',

    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token.access_token}`
    },
    body: raw
  }

  fetch(API_URL, requestOptions)
    .then(data => console.log('🚀 ~ file: getInsurance.js:33 ~ getDataInsurance ~ data:', data))
    .catch(error => console.log('error', error))

  return token
}
