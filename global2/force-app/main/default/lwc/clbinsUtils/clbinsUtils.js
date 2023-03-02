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

export const skeletonPosts = [
  { id: 1 },
  { id: 2 },
  { id: 3 },
  { id: 4 },
  { id: 5 },
  { id: 6 }
]
export const skeletonLastPosts = [{ id: 1 }, { id: 2 }, { id: 3 }]
