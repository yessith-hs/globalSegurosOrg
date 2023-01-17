import { LightningElement } from 'lwc';
import { listDocuments } from './data';

export default class ClbinsInsuranceDetails extends LightningElement {
  documents = listDocuments
}