import { LightningElement } from 'lwc';
import ICONO_HABILIDADES from "@salesforce/resourceUrl/habilidades";
import URL_IMG3 from '@salesforce/resourceUrl/ejemplo01';

export default class ClbinsCmsSocioEmotional extends LightningElement {
  icon = ICONO_HABILIDADES;
  title = "Habilidades socioemocionales";
  image = URL_IMG3;
  content =
    "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters.";
}