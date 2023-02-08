import { LightningElement } from 'lwc'
import { searchContent } from './searchContent'

export default class ClbinsGlobalSearch extends LightningElement {
  myValue = 'initial value'
  queryTerm = ''
  data

  connectedCallback() {
    const API_URL =
      'https://globalseguros--ta.sandbox.my.salesforce.com/services/data/v56.0/connect/cms/delivery/channels/0ap220000004H2EAAU/contents/query'

    fetch(API_URL, {
      method: 'GET',
      headers: {
        Accept: 'application/json'
      }
    })
      .then(response => {
        if (response.ok) {
          return response.json()
        }
      })
      .then(responseJason => {
        this.data = responseJason
        console.log(
          '🚀 ~ file: clbinsGlobalSearch.js:28 ~ ClbinsGlobalSearch ~ connectedCallback ~ responseJason',
          responseJason
        )
      })
      .catch(error => console.error(error.mesages))
  }

  handleChange(event) {
    this.queryTerm = event.target.value
  }

  handleSubmit(event) {
    event.preventDefault()

    console.log('data', this.data)

    searchContent('mano')
      .then(data => {
        console.log(
          '🚀 ~ file: clbinsGlobalSearch.js:17 ~ ClbinsGlobalSearch ~ search ~ data',
          data
        )
        return
      })
      .catch(error => console.error(error.mesages))
  }
}
