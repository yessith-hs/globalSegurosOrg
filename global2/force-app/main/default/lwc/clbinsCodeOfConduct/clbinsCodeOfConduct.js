import { LightningElement, wire } from 'lwc'
import getContentList from '@salesforce/apex/clb_ins_ContentManagerCms.getContentList'
import { htmlDecode } from 'c/clbinsUtils'
import basePath from '@salesforce/community/basePath'
export default class ClbinsCodeOfConduct extends LightningElement {
  topic = 'codigo_de_conducta'
  image
  body
  soyGlobal = `${basePath}/conexion-global`

  // * Get Content CMS
  @wire(getContentList, {
    page: 0,
    pageSize: 1,
    language: 'es',
    filterby: '$topic'
  })
  wiredContent({ data, error }) {
    if (data) {
      const { contenido, imagen } = data[0].contentNodes
      this.body = htmlDecode(contenido.value)
      this.image = `${basePath}/sfsites/c${imagen.url}`
    }
    if (error) {
      console.log('Error: ' + JSON.stringify(error))
    }
  }
}
