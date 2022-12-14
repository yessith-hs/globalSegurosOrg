import { LightningElement } from 'lwc';
import baseUrl from '@salesforce/community/basePath';

// * Assets
import ICONO_INTEGRAL from "@salesforce/resourceUrl/integral";
import ICONO_EDUCATIVA from "@salesforce/resourceUrl/educativa";
import ICONO_HABILIDADES from "@salesforce/resourceUrl/habilidades";


export default class ClbinsSliderThematicLine extends LightningElement {
  // * set icons
  iconoIntegral = ICONO_INTEGRAL;
  iconoEducativa = ICONO_EDUCATIVA;
  iconoHabilidades = ICONO_HABILIDADES;
  // * set url
  educationalUrl = `${baseUrl}/conexion-global/orientacion-educativa`;
  integralDevelopmentlUrl = `${baseUrl}/conexion-global/desarrollo-integral`;
  socioEmotionallUrl = `${baseUrl}/conexion-global/habilidades-socioemocionales`;
}
/**
 * orientacion_educativa
 * desarrollo_integral
 * habilidades_socioemocionales
 */