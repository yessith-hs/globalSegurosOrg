import { LightningElement, api, wire } from 'lwc'
import { NavigationMixin } from 'lightning/navigation'
import getContentList from '@salesforce/apex/clb_ins_ContentManagerCms.getContentList'
import basePath from '@salesforce/community/basePath'
import { formatDate, TOPICS, URL_TOPICS } from 'c/clbinsUtils'

export default class ClbinsHeaderGlobalConnection extends NavigationMixin(
  LightningElement
) {
  @api topic
  itemTopic
  topicUrl
  tematicPost
  hasData = false
  defaultTopic = 'orientacion_educativa'

  connectedCallback() {
    this.itemTopic = TOPICS[this.topic] ?? this.defaultTopic
    this.topicUrl = URL_TOPICS[this.topic] ?? basePath
  }

  @wire(getContentList, {
    page: 0,
    pageSize: 1,
    language: 'es',
    filterby: '$itemTopic'
  })
  wiredContent({ data, error }) {
    if (data) {
      this.error = undefined
      this.hasData = true
      const { Title, Descripcion, Imagen } = data[0].contentNodes
      const date = formatDate(data[0].publishedDate)

      this.tematicPost = {
        key: data[0].contentKey,
        date,
        title: Title.value,
        descripcion: Descripcion.value,
        imageUrl: `${basePath}/sfsites/c${Imagen.url}`,
        imageAltText: Imagen.value
      }
    }
    if (error) {
      console.log('Error: ' + JSON.stringify(error))
    }
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
//  this.topicUrl = URL_TOPICS[this.topic] ?? basePath
