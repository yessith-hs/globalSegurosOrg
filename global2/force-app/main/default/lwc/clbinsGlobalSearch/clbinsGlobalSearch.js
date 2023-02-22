import { LightningElement, track } from 'lwc'
import { NavigationMixin } from 'lightning/navigation'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import basePath from '@salesforce/community/basePath'

export default class ClbinsGlobalSearch extends NavigationMixin(
  LightningElement
) {
  @track queryTerm = ''

  handleChange(event) {
    this.queryTerm = event.target.value
  }

  handleSubmit(event) {
    event.preventDefault()

    if (!this.queryTerm) {
      const event = new ShowToastEvent({
        title: 'Campos vacíos',
        message: 'Por favor ingresa una query.',
        variant: 'error'
      })
      this.dispatchEvent(event)
      return
    }

    this[NavigationMixin.Navigate]({
      type: 'standard__webPage',
      attributes: {
        url: `${basePath}/conexion-global/search-results/?term=${this.queryTerm}`
      }
    })
  }
}
