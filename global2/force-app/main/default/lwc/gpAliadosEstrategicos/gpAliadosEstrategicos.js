import { LightningElement, wire } from 'lwc'

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal'

import BASE_PATH from '@salesforce/community/basePath'

import getContentList from '@salesforce/apex/clb_ins_ContentManagerCms.getContentList'

export default class AliadosEstrategicos extends LightningElement {
  items = [{ imagen: '' }]
  currentItem = { imagen: '' }

  @wire(getContentList, {
    page: 0,
    pageSize: 10,
    language: 'es',
    filterby: 'aliadosEstrategicos'
  })
  wiredContent({ data, error }) {
    if (data) {
      this.items = data.map(entry => {
        const { titulo, description, logo, urlAliado } = entry.contentNodes

        return {
          key: entry.contentKey,
          titulo: titulo.value,
          descripcion: description.value,
          urlAliado: urlAliado?.value ? urlAliado.value : '#',
          logoAliado: `${BASE_PATH}/sfsites/c${logo.url}`
        }
      })
      this.currentItem = this.items[0]
      this.error = undefined
    }
    if (error) {
      console.log('Error: ' + JSON.stringify(error))
    }
  }


}