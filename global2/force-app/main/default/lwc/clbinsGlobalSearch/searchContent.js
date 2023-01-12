const baseUrl =
  'https://globalseguros--ta.sandbox.my.site.com/customer/services/data/v56.0/connect/communities/0DB220000009g2YGAQ/managed-content/delivery/contents/search'


  export const searchContent = async queryTerm => {
  const API_URL = `${baseUrl}?queryTerm=${queryTerm}`
  const response = await fetch(API_URL)
  const data = await response.json()
  return data
}