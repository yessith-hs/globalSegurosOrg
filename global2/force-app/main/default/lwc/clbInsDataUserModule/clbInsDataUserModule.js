import { LightningElement } from 'lwc'

export default class ClbInsDataUserModule extends LightningElement {
  // * get all policys
  static getPolicies(data) {
    return data.policys
  }
}
