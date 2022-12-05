import { LightningElement } from 'lwc';
import baseUrl from '@salesforce/community/basePath';
import HEADER_IMG from '@salesforce/resourceUrl/ejemplo02';


export default class ClbinsDetailGlobalConnection extends LightningElement {
  srcImg = HEADER_IMG;
  educationalUrl = `${baseUrl}/conexion-global/orientacion-educativa`;
  integralDevelopmentlUrl = `${baseUrl}/conexion-global/desarrollo-integral`;
  socioEmotionallUrl = `${baseUrl}/conexion-global/habilidades-socioemocionales`;
  codeOfConduct = `${baseUrl}/codigo-de-conducta`;
}