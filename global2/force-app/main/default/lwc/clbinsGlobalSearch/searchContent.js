const url = 'https://login.salesforce.com/services/oauth2/token'
const url2 = 'https://login.salesforce.com/services/oauth2/authorize'
const url3 =
  'https://globalseguros--ta.sandbox.my.salesforce.com/services/oauth2/token'
const endPoint =
  '/services/data/v56.0/connect/cms/delivery/channels/0ap220000004H2EAAU/contents/query'

export const searchContent = async () => {
  let responseToken = await fetch(url3, {
    method: 'POST',
    headers: {
      'Content-Type': 'Authorization'
    },
    body: {
      grant_type: 'password',
      client_id:
        '3MVG973QtA4.tpvkEBeLAWinYEXgsTgkcbSDTppzgBjlvbCodWWIThBs2WMB36s7g0RWcVYDZJaYL9ljurEvp',
      client_secret:
        '4AF77E135677A8D88959F6938013E2CA00B0245DF96691EE59B7E4072F95D2CA',
      username: 'yessith@cloudblue.us.ta',
      password: '4#noCb5TLu76'
    }
  }).then(response => console.log('data', response))
  console.log(
    '🚀 ~ file: searchContent.js:32 ~ searchContent ~ responseToken',
    responseToken
  )

  const response = await fetch(endPoint, {
    method: 'GET',
    headers: {
      Accept: 'application/json',
      Authorization: `Bearer ${responseToken.access_token}`
    }
  })
  const data = await response.json()
  return data
}
