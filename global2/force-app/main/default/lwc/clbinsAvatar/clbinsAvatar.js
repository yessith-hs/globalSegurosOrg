import { LightningElement, wire, track,api } from 'lwc'
import { getRecord, getFieldValue } from 'lightning/uiRecordApi'

import DEFAULT_AVATAR from '@salesforce/resourceUrl/avatar'
import FIRST_NAME from '@salesforce/schema/User.FirstName'
import LAST_NAME from '@salesforce/schema/User.LastName'
import USER_AVATAR from '@salesforce/schema/User.FullPhotoUrl'


import USER_ID from '@salesforce/user/Id'

export default class ClbinsAvatar extends LightningElement {
  @api styleflex
  userId = USER_ID
  @track firstName
  @track lastName
  @track userAvatar

  renderedCallback () {
    if (this.styleflex) {
      this.template.querySelector('.menu-avatar').classList.add('mobile')
    }
  }

  @wire(getRecord, {
    recordId: '$userId',
    fields: [ FIRST_NAME, LAST_NAME, USER_AVATAR]
  })
  user({ data, error }) {
    if (data) {
      this.firstName = getFieldValue(data, FIRST_NAME)
      this.lastName = getFieldValue(data, LAST_NAME)
      this.userAvatar = getFieldValue(data, USER_AVATAR) || DEFAULT_AVATAR
    }

    if (error) {
      console.log('Error: ' + JSON.stringify(error))
    }
  }

  get fullName() {
    return `${this.firstName} ${this.lastName}`
  }
}