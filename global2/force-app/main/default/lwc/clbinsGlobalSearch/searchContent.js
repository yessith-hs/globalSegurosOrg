const baseUrl =
  'https://globalseguros--ta.sandbox.my.site.com/customer/services/data/v56.0/connect/cms/delivery/channels/0ap220000004H2E/contents/query?startDate=2023-01-13T00:00:00.000Z'

const baseUrl2 =
  'https://globalseguros--ta.sandbox.my.site.com/customer//services/data/v56.0/connect/cms/delivery/channels/0ap220000004H2E/contents/query'


  export const searchContent = async () => {
  // const API_URL = `${baseUrl}?queryTerm=${queryTerm}`
  const response = await fetch(baseUrl)
  const data = await response.json()
  return data
}