import { LightningElement, wire } from 'lwc'

import getContentList from '@salesforce/apex/clb_ins_ContentManagerCms.getContentList'
import basePath from '@salesforce/community/basePath'

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal'

export default class ProductoDestacado extends LightningElement {
  items

  @wire(getContentList, {
    page: 0,
    pageSize: 10,
    language: 'es',
    filterby: 'producto_destacado'
  })
  wiredContent({ data, error }) {
    if (data) {
      this.items = data.map(entry => {
        const { Title, Descripcion, Imagen, Imagen2 } = entry.contentNodes

        return {
          key: entry.contentKey,
          detailTitulo: Title.value,
          detailDescripcion: Descripcion.value,
          botonImagen: `${basePath}/sfsites/c${Imagen2.url}`,
          botonAltText: Imagen2.altText,
          imagen: `${basePath}/sfsites/c${Imagen.url}`,
          imagenAltText: Imagen.altText
        }
      })
      this.error = undefined
    }
    if (error) {
      console.log('Error: ' + JSON.stringify(error))
    }
  }

  handleItemSelected(event) {
    console.log('item seleccionado: ', event.detail)
  }

  caretLeftImg = globalSegurosPortal + '/images/navegar-caret-left.png'
  caretRightImg = globalSegurosPortal + '/images/navegar-caret-right.png'
}
