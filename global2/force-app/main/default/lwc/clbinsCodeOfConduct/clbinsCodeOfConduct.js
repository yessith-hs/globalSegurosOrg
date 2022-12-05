import { LightningElement } from 'lwc';
import BackgroundImg from "@salesforce/resourceUrl/codeOfConduct";
import BASE_PATH from "@salesforce/community/basePath";

export default class ClbinsCodeOfConduct extends LightningElement {
  imageUrl = BackgroundImg;
  basePath = `${BASE_PATH}/conexion-global`;

  // get getBackgroundImage() {
  //   return `background-image:url(${this.imageUrl})`;
  // }
}