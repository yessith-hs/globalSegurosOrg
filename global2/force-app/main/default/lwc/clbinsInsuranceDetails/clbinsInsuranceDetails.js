import { LightningElement } from 'lwc';
import BASE_PATH from '@salesforce/community/basePath'
import { listDocuments } from './data';

export default class ClbinsInsuranceDetails extends LightningElement {
  static renderMode = 'light'
  documents = listDocuments
  gestionSeguros = `${BASE_PATH}/gestiona-tus-seguros`
}