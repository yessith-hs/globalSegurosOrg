import { LightningElement } from 'lwc'
import basePath from '@salesforce/community/basePath'

import SOLUCIONES_ICON from '@salesforce/resourceUrl/insuranceSoluciones'
import CITA_ICON from '@salesforce/resourceUrl/insuranceCita'
import DEBITO_ICON from '@salesforce/resourceUrl/insuranceDebito'

export default class ClbinsUtils extends LightningElement {}

export const filterCmsTopic = (posts = [], topic) => {
  return posts.filter(entry => {
    const { tematica } = entry.contentNodes
    const cmsTopic = tematica.value.toLowerCase()
    return cmsTopic === topic.toLowerCase()
  })
}

export const formatDate = strDate => {
  const dateMilliseconds = new Date(strDate).getTime()
  const date = new Date(dateMilliseconds)
  return date.toLocaleString('es', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
    timeZone: 'UTC'
  })
}

// * Formatted Rich Text
export const htmlDecode = input => {
  const doc = new DOMParser().parseFromString(input, 'text/html')
  return doc.documentElement.textContent
}

export const unEscape = htmlStr => {
  htmlStr = htmlStr.replace(/&lt;/g, '<')
  htmlStr = htmlStr.replace(/&gt;/g, '>')
  htmlStr = htmlStr.replace(/&quot;/g, '"')
  htmlStr = htmlStr.replace(/&#39;/g, "'")
  htmlStr = htmlStr.replace(/&amp;/g, '&')
  htmlStr = htmlStr.replace(/&#92;/g, '\\')
  return htmlStr
}

export const TOPICS = {
  'orientación educativa': 'orientacion_educativa',
  'orientacion educativa': 'orientacion_educativa',
  'desarrollo integral': 'desarrollo_integral',
  'habilidades socioemocionales': 'habilidades_socioemocionales'
}

export const TOPICS_NAME = {
  orientacion_educativa: 'Orientacion Educativa',
  desarrollo_integral: 'Desarrollo Integral',
  habilidades_socioemocionales: 'Habilidades Socioemocionales'
}

export const URL_TOPICS = {
  'orientación educativa': `${basePath}/soy-global/orientacion-educativa`,
  'orientacion educativa': `${basePath}/soy-global/orientacion-educativa`,
  'desarrollo integral': `${basePath}/soy-global/desarrollo-integral`,
  'habilidades socioemocionales': `${basePath}/soy-global/habilidades-socioemocionales`
}

export const INSURANCE_COLORS = {
  'seguro educativo': 'rgb(0, 135, 220)',
  'seguro vida': 'rgb(255, 90, 90)',
  'seguro pensión': 'rgb(0, 180, 120)',
  'accidentes personales': 'rgb(190, 45, 85)',
  'renta voluntaria': 'rgb(155, 80, 145)',
  'global life': 'rgb(255, 90, 90)',
  'vida grupo deudor': 'rgb(0, 135, 220)',
  'vida grupo voluntario': 'rgb(0, 135, 220)'
}

export const skeletonPosts = [{ id: 1 }, { id: 2 }, { id: 3 }, { id: 4 }, { id: 5 }, { id: 6 }]
export const skeletonLastPosts = [{ id: 1 }, { id: 2 }, { id: 3 }]

// * ClbInsAdditionalCardInsurance
export const firstAdditionalCard = {
  title: 'Desea obtener un nuevo seguro',
  links: [
    {
      id: 1,
      title: 'Soluciones recomendadas para ti',
      icon: SOLUCIONES_ICON,
      url: `${basePath}/soluciones-pensadas-para-ti`,
      secondBtn: true
    },
    {
      id: 2,
      title: 'Agenda tu cita',
      url: basePath,
      icon: CITA_ICON
    }
  ]
}

export const secondAdditionalCard = {
  title: 'Gestiona modificaciones al registro de débito automático',
  links: [
    {
      id: 1,
      title: 'Débito automático',
      url: basePath,
      icon: DEBITO_ICON
    }
  ]
}
