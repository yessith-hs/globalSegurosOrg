import { LightningElement, api, wire } from 'lwc'
import getContentList from '@salesforce/apex/ManagedContentController.getContentList'
import basePath from '@salesforce/community/basePath'
import { formatDate } from 'c/clbinsUtils'

export default class ClbinsMoreEntries extends LightningElement {
  @api itemtopic
  posts

  @wire(getContentList, {
    page: 0,
    pageSize: 6,
    language: 'es',
    filterby: '$itemtopic'
  })
  wiredContent({ data, error }) {
    if (data) {
      this.posts = data.map(entry => {
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
}