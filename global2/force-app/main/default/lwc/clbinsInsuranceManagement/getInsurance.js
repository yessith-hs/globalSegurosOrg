/**
 * @author Soulberto Lorenzo <soulberto@cloudblue.us>
 * @created 2023-04-29
 */
export class APIGeeConnection {
  /**
   *
   * @type {boolean} [isDebugging=true]
   */
  isDebugging = false
  /**
   *
   * @typedef Object
   * @property {String} access_token
   */
  token = null
  constructor(credentials = { url: '', clientId: '', clientSecret: '' }, isDebugging = false) {
    this.authUrl = credentials.url
    this.clientId = credentials.clientId
    this.clientSecret = credentials.clientSecret
    this.isDebugging = isDebugging
  }
  debug(message) {
    if (this.isDebugging) console.log(`[${this.constructor.name}] ${message}`)
  }
  error(message) {
    if (this.isDebugging) console.error(`[${this.constructor.name}] ${message}`)
  }
  async getToken() {
    const response = await fetch(this.authUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: `grant_type=client_credentials&client_id=${this.clientId}&client_secret=${this.clientSecret}`
    })
    const data = await response.json()

    this.token = data
    this.debug(`Getted Access Token=${this.token.access_token}`)
  }
  /**
   *
   * @param {'GET'|'POST'} method
   * @param {String} url
   * @param {Object} [payload]
   * @returns
   */
  async fetch(method, url, payload = {}) {
    try {
      await this.getToken()

      this.debug(`Fetching data from=${url} using access_token=${this.token.access_token}`)
      const raw = await fetch(url, {
        method: method,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          Accept: 'application/json',
          'Access-Control-Allow-Credentials': true,
          Origin: 'https://globalseguros--ta.sandbox.my.site.com',
          Authentication: `Bearer ${this.token.access_token}`
        },
        body: JSON.stringify(payload),
        Cache: 'default',
        credentials: 'include'
      })

      const response = await raw.json()

      return JSON.stringify(response)
    } catch (error) {
      this.error(error)
    }

    return null
  }
}

/**
 * Demostración de uso de la biblioteca de consulta a través de APIGee
 */
;(async function () {
  try {
    const credentials = {
      url: 'https://apigee.globalseguros.co/gt/security/access_token?grant_type=client_credentials',
      clientId: 'vyNC901JQJdpoqpvUjE3ABnNbQAl07kD0B5npJiwXUubXgh1',
      clientSecret: 't0HCONxCU7CgH1Nb3xcztogfHrg0x3CXF0Vr13eRXKYYuMBhLSM1eMme4ZQu4qiA'
    }
    const apigeeConnection = new APIGeeConnection(credentials, true)
    const response = await apigeeConnection.fetch(
      'POST',
      'https://apigee.globalseguros.co/develop/gsv/pst/policy/core/users/data',
      {
        personId: 215013,
        email: null,
        documentNumber: null
      }
    )

    // Respuesta de la consulta al APIGee
    console.log(response)
  } catch (error) {
    console.error(error)
  }
})()
