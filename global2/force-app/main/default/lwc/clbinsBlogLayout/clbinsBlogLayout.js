import { LightningElement, track, wire } from 'lwc'
import { CurrentPageReference } from 'lightning/navigation'
import { formatDate } from 'c/clbinsUtils'
import basePath from '@salesforce/community/basePath'
import getContent from '@salesforce/apex/ManagedContentController.getContent'

// * Assets
import URL_HEADER from '@salesforce/resourceUrl/header'
import URL_AVATAR from '@salesforce/resourceUrl/avatar'

export default class ClbinsBlogLayout extends LightningElement {
  headerImg = URL_HEADER
  avatarImg = URL_AVATAR
  defaultTopic = 'orientacion_educativa'

  @track blogId
  itemTopic
  topicUrl
  _topic
  _date
  _title
  _descripcion
  _body
  _autor
  _imageUrl
  _imageAltText

  // * get url topic
  URL_TOPICS = {
    'orientación educativa': `${basePath}/conexion-global/orientacion-educativa`,
    'desarrollo integral': `${basePath}/conexion-global/desarrollo-integral`,
    'habilidades socioemocionales': `${basePath}/conexion-global/habilidades-socioemocionales`
  }
  TOPICS = {
    'orientación educativa': 'orientacion_educativa',
    'desarrollo integral': 'desarrollo_integral',
    'habilidades socioemocionales': 'habilidades_socioemocionales'
  }

  // * get id post
  @wire(CurrentPageReference)
  pageReference({ state }) {
    if (state && state.blogId) {
      this.blogId = state.blogId
    }
  }

  // * get data post
  @wire(getContent, {
    contentId: '$blogId',
    page: 0,
    pageSize: 1,
    language: 'es',
    filterby: ''
  })
  wiredContent({ data, error }) {
    if (data) {
      const {
        tematica,
        fechapublicacion,
        Title,
        Descripcion,
        Publicacion,
        Portada,
        Autor
      } = data
      const date = formatDate(fechapublicacion.value)
      const body = this.htmlDecode(Publicacion.value)

      this._topic = tematica.value.toLowerCase()
      this._date = date
      this._title = Title.value
      this._descripcion = Descripcion.value
      this._body = body
      this._autor = Autor.value
      this._imageUrl = basePath + '/sfsites/c' + Portada.unauthenticatedUrl
      this._imageAltText = Portada.altText
      this.error = undefined
      this.topicUrl = this.URL_TOPICS[this._topic] ?? basePath
      this.itemTopic = this.TOPICS[this._topic] ?? this.defaultTopic
    }
    if (error) {
      console.log('Error: ' + JSON.stringify(error))
    }
  }

  get topic() {
    return this._topic
  }

  get date() {
    return this._date
  }

  get title() {
    return this._title
  }

  get descripcion() {
    return this._descripcion
  }

  get body() {
    return this._body
  }

  get autor() {
    return this._autor
  }

  get imageUrl() {
    return this._imageUrl
  }

  get backgroundStyle() {
    return `min-height: 19.169rem;
    background-image: url(${this._imageUrl});
    background-repeat:no-repeat;
    background-size:cover;
    background-position:center;
    position: relative;`
  }

  // * Formatted Rich Text
  htmlDecode(input) {
    const doc = new DOMParser().parseFromString(input, 'text/html')
    return doc.documentElement.textContent
  }
}