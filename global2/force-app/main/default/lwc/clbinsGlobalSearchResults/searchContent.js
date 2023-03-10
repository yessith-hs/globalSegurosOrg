const versionData = 'services/data/v56.0'
const endPoint =
  'connect/cms/delivery/channels/0ap220000004H2EAAU/contents/search'

export const searchContent = async (token, term, instanceName) => {
  const url = `${instanceName}/${versionData}/${endPoint}?queryTerm=${term}`
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
