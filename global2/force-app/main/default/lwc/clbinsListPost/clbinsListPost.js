import { LightningElement, api, wire, track } from 'lwc'
import getContentList from '@salesforce/apex/ManagedContentController.getContentList'
import basePath from '@salesforce/community/basePath'
import { formatDate } from 'c/clbinsUtils'

import Id from '@salesforce/community/Id'
import { listContent } from 'lightning/cmsDeliveryApi'
export default class ClbinsListPost extends LightningElement {
  @api topic
  hasEntries
  listEntries
  maxEntries = 10
  @track maxEntriesShow = 2

  @wire(listContent, { communityId: '$Id' })
  cmsRecords

  // * Get Content List CMS
  @wire(getContentList, {
    page: 0,
    pageSize: '$maxEntries',
    language: 'es',
    filterby: '$topic'
  })
  wiredContent({ data, error }) {
    if (data) {
      this.listEntries = data.map(entry => {
        const { Title, Descripcion, Imagen } = entry.contentNodes
        const date = formatDate(entry.publishedDate)

        return {
          key: entry.contentKey,
          date,
          title: Title.value,
          descripcion: Descripcion.value,
          imageUrl: `${basePath}/sfsites/c${Imagen.url}`,
          imageAltText: Imagen.value
        }
      })

      this.error = undefined
    }
    if (error) {
      console.log('Error: ' + JSON.stringify(error))
    }
  }

  nextEntries() {
    this.maxEntriesShow += 2
  }

  get entries () {
    if (this.listEntries) {
      console.log(
        '🚀 ~ file: clbinsListPost.js:61 ~ ClbinsListPost ~ cmsRecords',
        this.cmsRecords
      )
      const totalEntries = this.listEntries.length
      this.hasEntries = this.maxEntriesShow >= totalEntries ? false : true

      return this.listEntries.slice(0, this.maxEntriesShow)
    }
  }
}

