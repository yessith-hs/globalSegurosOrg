import { LightningElement } from 'lwc';

import ICONO_EDUCATIVA from "@salesforce/resourceUrl/educativa";
import URL_IMG3 from '@salesforce/resourceUrl/ejemplo01';

export default class ClbinsCmsEducational extends LightningElement {
  title = "Orientación educativa";
  icon = ICONO_EDUCATIVA;
  image = URL_IMG3;
  content =
    "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters.";

}