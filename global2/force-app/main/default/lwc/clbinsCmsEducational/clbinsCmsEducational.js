import { LightningElement, wire } from 'lwc'
import basePath from '@salesforce/community/basePath'
import getContentList from '@salesforce/apex/ManagedContentController.getContentList'
import { htmlDecode } from 'c/clbinsUtils'
import ICONO_EDUCATIVA from '@salesforce/resourceUrl/educativa'

export default class ClbinsCmsEducational extends LightningElement {
  topic = 'main_seccion_linea_tematica'
  icon = ICONO_EDUCATIVA
  title = 'Orientación educativa'
  image
  body

  // * Get Content CMS
  @wire(getContentList, {
    page: 0,
    pageSize: 3,
    language: 'es',
    filterby: '$topic'
  })
  wiredContent({ data, error }) {
    if (data) {
      const response = data.find(
        ({ title }) => title.toLowerCase() === this.title.toLowerCase()
      )
      const { body, image } = response.contentNodes
      this.body = htmlDecode(body.value)
      this.image = `${basePath}/sfsites/c${image.url}`
    }
    if (error) {
      console.log('Error: ' + JSON.stringify(error))
    }
  }
}