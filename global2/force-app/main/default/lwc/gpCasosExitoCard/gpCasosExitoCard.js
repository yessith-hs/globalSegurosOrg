import { LightningElement, api } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';

export default class GpCasosExitoCard extends LightningElement {
    @api casoExito = {
        id: '78333a26-3924-44e0-9g57-3eadf3b73846',
        ramoSeguros: 'Seguro Educativo',
        colorRamoSeguros: 'color: #0087dc',
        titulo: 'Daniela Viana 01',
        subTitulo: 'Graduada de Política y Relaciones Internacionales en la Universidad Sergio Arboleda',
        contenido: '“Papi: Aún recuerdo esa navidad en la que no me diste el regalo que yo deseaba, me diste un sobre que decía Global. Yo sonreí, pero créeme que no entendí mi regalo, quedé preguntándome ¿y mi muñeca? Hoy puedo decir que es el mejor regalo que me has dado”...'
    };

    // eslint-disable-next-line no-useless-concat
    botonAgendaCitaImg = globalSegurosPortal + '/images/' + 'gp-boton-agenda-cita.png';

    get getStyleRamoSeguro() {
        return `color: ${this.casoExito.colorRamoSeguros} !important`;
    }


    get getStyleDotRamoSeguro() {
        return `color: ${this.casoExito.colorRamoSeguros} !important; background-color: ${this.casoExito.colorRamoSeguros}`;
    }
}