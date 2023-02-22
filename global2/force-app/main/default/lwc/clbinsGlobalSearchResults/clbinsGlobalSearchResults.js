import { LightningElement, track, wire } from 'lwc'
import basePath from '@salesforce/community/basePath'
import { CurrentPageReference } from 'lightning/navigation'
import getSessionId from '@salesforce/apex/clb_ins_UserSessionHelper.getSessionId'
import { searchContent } from './searchContent'

export default class ClbinsGlobalSearchResults extends LightningElement {
  @track tokenUser
  @track term
  loading
  haveResults
  searchResults

  // * get id post
  @wire(CurrentPageReference)
  pageReference({ state }) {
    if (state && state.term) {
      this.term = state.term
    }
  }

  connectedCallback() {
    getSessionId()
      .then(tokenUser =>
        searchContent(tokenUser, this.term)
          .then(results => {
          if (!results.items.length) {
            this.loading = false
            this.haveResults = false
            return
          }

          this.loading = false
          this.searchResults = results.items
          this.haveResults = true
        })
      )
      .catch(error => console.log('error', error))
  }
}
