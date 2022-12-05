import { LightningElement } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';
import { getDataFAQ } from 'c/gpInicioDataConfig';

export default class PreguntasFrecuentes extends LightningElement {
    navigatorConfig;
    active;
    items;
    currentItem;
    pregunta;
    respuesta;
    constructor() {
        super();
        this.active = 1;
        this.navigatorConfig = getDataFAQ();
        this.items = this.navigatorConfig.items;
        this.currentItem = this.items[0];
        this.pregunta = this.currentItem.pregunta;
        this.respuesta = this.currentItem.respuesta;
    }

    faqIcono = globalSegurosPortal + '/images/gp-faq-icono.svg';
}