import { LightningElement, track, wire } from 'lwc'
import basePath from '@salesforce/community/basePath'
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation'
import getSessionId from '@salesforce/apex/clb_ins_UserSessionHelper.getSessionId'
import { searchContent } from './searchContent'
import { formatDate, TOPICS_NAME } from 'c/clbinsUtils'

export default class ClbinsGlobalSearchResults extends NavigationMixin(
  LightningElement
) {
  @track tokenUser
  @track term
  loading = true
  haveResults
  searchResults
  defaultTopic = 'Sin Tematica'

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
        searchContent(tokenUser, this.term).then(results => {
          if (!results.items.length) {
            this.loading = false
            this.haveResults = false
            return
          }

          this.loading = false
          this.searchResults = results.items.map(result => {
            const { publishDate, title, contentType, contentKey } = result
            return {
              contentKey,
              topic:
                TOPICS_NAME[contentType.developerName] ?? this.defaultTopic,
              publishDate: formatDate(publishDate),
              title
            }
          })

          this.haveResults = true
        })
      )
      .catch(error => console.log('error', error))
  }

  handleClick(event) {
    this[NavigationMixin.Navigate]({
      type: 'standard__webPage',
      attributes: {
        url: `${basePath}/soy-global/post?blogId=${event.currentTarget.dataset.id}`
      }
    })
  }
}
