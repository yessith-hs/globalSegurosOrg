import { LightningElement, api } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';
import BASE_PATH from "@salesforce/community/basePath";

export default class GpSolucionesRecomendadasCard extends LightningElement {
    @api contenido = {
        id: '48333a26-3924-44e0-9g57-3eadf3b73846',
        ramoSeguros: 'Seguro Educativo',
        colorRamoSeguros: '#ff0000',
        contenido: 'Ver a los hijos felices y graduados como profesionales, es un logro que muchos padres por eventualidades financieras no pueden alcanzar.',
        linkDetalle: 'seguro-educativo', 
        imagen: 'gp-soluciones-seguro-educativo.jpg'
    };

    urlSolucionesRecomendadas = `${BASE_PATH}/soluciones-recomendadas`;
    botonConocerMasImg = globalSegurosPortal + "/images/gp-boton-conoce-mas.svg";

    // get getSolucionImagen() {
    //     return globalSegurosPortal + '/images/' + this.contenido.imagen;
    // }

    get getSolucionLink() {
        return `${BASE_PATH}/soluciones-pensadas-para-ti/${this.contenido.linkDetalle}`;
    }

    get getStyleRamoSeguro() {
        return `background-color: ${this.contenido.colorRamoSeguros}; border-color: ${this.contenido.colorRamoSeguros};`
    }
}