// const endPoint ='connect/cms/delivery/channels/0ap220000004H2EAAU/contents/query'

const baseUrl =
  'https://globalseguros--ta.sandbox.my.salesforce.com/services/data/v56.0'
const endPoint =
  '/connect/cms/delivery/channels/0ap220000004H2EAAU/contents/search'

export const searchContent = async (token, term) => {
  const url = `${baseUrl}${endPoint}?queryTerm=${term}`
  const response = await fetch(url, {
    method: 'GET',
    headers: {
      Accept: 'application/json',
      Authorization: `Bearer ${token}`
    }
  })
  const data = await response.json()
  return data
}
