import { LightningElement, wire,track } from 'lwc'
import { getRecord, getFieldValue } from 'lightning/uiRecordApi'


import USER_NAME from '@salesforce/schema/User.Username'
import FIRST_NAME from '@salesforce/schema/User.FirstName'
import LAST_NAME from '@salesforce/schema/User.LastName'
import USER_AVATAR from '@salesforce/schema/User.FullPhotoUrl'
import USER_ROL_NAME from '@salesforce/schema/User.UserRole.Name'

import USER_ID from '@salesforce/user/Id'

export default class ClbinsUserInfo extends LightningElement {
  userId = USER_ID
  @track userName
  @track firstName
  @track lastName
  @track userRolName
  @track userAvatar


  @wire(getRecord, {
    recordId: '$userId',
    fields: [USER_NAME, FIRST_NAME, LAST_NAME, USER_ROL_NAME, USER_AVATAR]
  })
  user({ data, error }) {
    if (data) {
      this.userName = getFieldValue(data, USER_NAME)
      this.firstName = getFieldValue(data, FIRST_NAME)
      this.lastName = getFieldValue(data, LAST_NAME)
      this.userRolName = getFieldValue(data, USER_ROL_NAME)
      this.userAvatar = getFieldValue(data, USER_AVATAR)
    }

    if (error) {
      console.log('Error: ' + JSON.stringify(error))
    }
  }
}