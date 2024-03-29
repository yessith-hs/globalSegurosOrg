import { LightningElement, wire } from 'lwc'
import baseUrl from '@salesforce/community/basePath'
import getContentList from '@salesforce/apex/clb_ins_ContentManagerCms.getContentList'
import { htmlDecode } from 'c/clbinsUtils'

export default class ClbinsDetailGlobalConnection extends LightningElement {
  topic = 'hero_soy_global'
  title
  image
  body
  educationalUrl = `${baseUrl}/soy-global/orientacion-educativa`
  integralDevelopmentlUrl = `${baseUrl}/soy-global/desarrollo-integral`
  socioEmotionallUrl = `${baseUrl}/soy-global/habilidades-socioemocionales`
  codeOfConduct = `${baseUrl}/codigo-de-conducta`

  @wire(getContentList, {
    page: 0,
    pageSize: 1,
    language: 'es',
    filterby: '$topic'
  })
  wiredContent({ data, error }) {
    if (data) {
      const { body, image } = data[0].contentNodes
      this.title = data[0].title
      this.body = htmlDecode(body.value)
      this.image = `${baseUrl}/sfsites/c${image.url}`
    }
    if (error) {
      console.log('Error: ' + JSON.stringify(error))
    }
  }
}
