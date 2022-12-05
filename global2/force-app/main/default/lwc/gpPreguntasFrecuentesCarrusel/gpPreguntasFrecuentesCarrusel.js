import { LightningElement, api } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';

export default class PreguntasFrecuentesCarrusel extends LightningElement {
    @api config;
    active;
    items;
    currentItem;

    botonMasInactivo = globalSegurosPortal + '/images/gp-faq-boton-mas-inactivo.svg';
    botonVerTodas = globalSegurosPortal + '/images/gp-faq-boton-ver-todas.png';
}