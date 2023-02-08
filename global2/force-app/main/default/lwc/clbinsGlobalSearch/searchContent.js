const baseUrl =
  'https://globalseguros--ta.sandbox.my.site.com/customer/services/data/v56.0/connect/cms/delivery/channels/0ap220000004H2E/contents/query?startDate=2023-01-13T00:00:00.000Z'

  //base /services/data/v56.0/connect/cms/delivery/channels/0ap220000004H2EAAU/contents/query

  // https://globalseguros--ta.sandbox.lightning.force.com/services/data/v56.0/connect/cms/delivery/channels/0ap220000004H2EAAU/contents/query

  // https://globalseguros--ta.sandbox.my.salesforce.com/services/data/v56.0/connect/cms/delivery/channels/0ap220000004H2EAAU/contents/query

const baseUrl2 =
  'https://globalseguros--ta.sandbox.lightning.force.com/services/data/v56.0/connect/cms/delivery/channels/0ap220000004H2EAAU/contents/query'
const baseUrl3 =
  'https://globalseguros--ta.sandbox.my.salesforce.com/services/data/v56.0/connect/cms/delivery/channels/0ap220000004H2EAAU/contents/query'



  export const searchContent = async () => {
    // const API_URL = `${baseUrl}?queryTerm=${queryTerm}`
    const response = await fetch(baseUrl3, {
      method: 'GET',
      headers: {
        Accept: 'application/json'
      }
    })
    const data = await response.json()
    return data
  }