import { LightningElement, api, wire } from 'lwc'
import { NavigationMixin } from 'lightning/navigation'
import getContentList from '@salesforce/apex/clb_ins_ContentManagerCms.getContentList'
import basePath from '@salesforce/community/basePath'
import { formatDate, TOPICS, URL_TOPICS } from 'c/clbinsUtils'
export default class ClbinsHeaderGlobalConnectionCarousel extends NavigationMixin(
  LightningElement
) {
  @api topic
  items = []
  active = 1
  i = 0
  itemTopic
  topicUrl
  hasData = false
  defaultTopic = 'orientacion_educativa'

  connectedCallback() {
    this.itemTopic = TOPICS[this.topic] ?? this.defaultTopic
    this.topicUrl = URL_TOPICS[this.topic] ?? basePath
  }

  renderedCallback() {
    // initialize component
    const firstItem = this.template.querySelector(
      `[data-id="pdi-${this.active}"]`
    )
    if (firstItem) {
      firstItem.classList.remove('inactive')
    }
  }

  @wire(getContentList, {
    page: 0,
    pageSize: 4,
    language: 'es',
    filterby: '$itemTopic'
  })
  wiredContent({ data, error }) {
    if (data) {
      this.error = undefined
      this.hasData = true

      this.items = data.map((entry, index) => {
        const { Title, Descripcion, Imagen } = entry.contentNodes
        const date = formatDate(entry.publishedDate)

        return {
          id: `pdi-${index + 1}`,
          key: entry.contentKey,
          date,
          title: Title.value,
          descripcion: Descripcion.value,
          imageUrl: `${basePath}/sfsites/c${Imagen.url}`,
          imageAltText: Imagen.value
        }
      })
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

  handleItemSelected(event) {
    let activeAnterior = this.active
    if (this.active !== event.detail) {
      this.active = event.detail
      this.template
        .querySelector(`[data-id="pdi-${activeAnterior}"]`)
        .classList.add('inactive')
      this.template
        .querySelector(`[data-id="pdi-${this.active}"]`)
        .classList.remove('inactive')
    }
  }

  get maxProductItems() {
    return this.items.length
  }

  get activeProduct() {
    return this.active
  }
}
