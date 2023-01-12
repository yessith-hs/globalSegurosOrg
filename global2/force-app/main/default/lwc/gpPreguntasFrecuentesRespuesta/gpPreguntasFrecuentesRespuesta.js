import { LightningElement, api } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';

export default class PreguntasFrecuentesRespuesta extends LightningElement {
    urlRespuesta;
    @api respuesta;
    @api pregunta;
    @api imagen;

    // imagenRespuesta = globalSegurosPortal + '/images/gp-faq-imagen-respuesta.png';
    botonPqrfsImg = globalSegurosPortal + '/images/gp-boton-pqrfs.png';
}