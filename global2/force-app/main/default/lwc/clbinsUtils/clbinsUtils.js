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
  seguro_educativo: 'rgb(0, 135, 220)',
  seguro_vida: 'rgb(255, 90, 90)',
  seguro_pension: 'rgb(0, 180, 120)',
  accidentes_personales: 'rgb(190, 45, 85)',
  renta_voluntaria: 'rgb(155, 80, 145)',
  global_life: 'rgb(255, 90, 90)',
  vida_grupo_deudor: 'rgb(0, 135, 220)',
  vida_grupo_voluntario: 'rgb(0, 135, 220)'
}

export const STATE_COLORS = {
  vigente: 'rgb(19, 206, 102)',
  en_pago_de_beneficios: 'rgb(45, 142, 255)',
  en_pago_de_pension: 'rgb(0, 156, 104)',
  poliza_pendiente_de_inicio_de_pension: 'rgb(140, 128, 0)',
  en_pago_de_renta: 'rgb(155, 80, 145)',
  poliza_pendiente_de_inicio_de_renta: 'rgb(140, 128, 0)',
  prorroga: 'rgb(255, 204, 61)'
}

export const normalizeStr = str => {
  const string = str
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .split(' ')
    .join('_')
    .toLowerCase()
  return string
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

export const uuidv4 = () => {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
    const r = (Math.random() * 16) | 0,
      v = c === 'x' ? r : (r & 0x3) | 0x8
    return v.toString(16)
  })
}
