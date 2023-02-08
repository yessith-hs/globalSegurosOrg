import { LightningElement } from 'lwc'
import basePath from '@salesforce/community/basePath'


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

export const URL_TOPICS = {
    'orientación educativa': `${basePath}/conexion-global/orientacion-educativa`,
    'orientacion educativa': `${basePath}/conexion-global/orientacion-educativa`,
    'desarrollo integral': `${basePath}/conexion-global/desarrollo-integral`,
    'habilidades socioemocionales': `${basePath}/conexion-global/habilidades-socioemocionales`
  }