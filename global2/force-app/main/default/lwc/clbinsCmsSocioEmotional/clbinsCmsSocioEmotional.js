import { LightningElement, wire } from 'lwc'
import basePath from '@salesforce/community/basePath'
import getContentList from '@salesforce/apex/clb_ins_ContentManagerCms.getContentList'
import { htmlDecode } from 'c/clbinsUtils'
import ICONO_HABILIDADES from '@salesforce/resourceUrl/habilidades'

export default class ClbinsCmsSocioEmotional extends LightningElement {
  topic = 'main_seccion_linea_tematica'
  icon = ICONO_HABILIDADES
  title = 'Habilidades socioemocionales'
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
