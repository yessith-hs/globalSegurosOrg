import { LightningElement } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';
import BASE_PATH from "@salesforce/community/basePath";

export default class GpSolucionSeguroEducativo extends LightningElement {
    urlSolucionesRecomendadas = `${BASE_PATH}/soluciones-pensadas-para-ti`;
    botonVolverAtrasImg = globalSegurosPortal + "/images/gp-boton-volver-atras.png";
    botonAgendaCitaImg = globalSegurosPortal + "/images/gp-boton-agenda-cita.png";

    get getSolucionImagen() {
        return globalSegurosPortal + '/images/gp-soluciones-seguro-educativo.jpg';
    }

    get getSolucionLink() {
        return `${BASE_PATH}/soluciones-pensadas-para-ti/${this.contenido.link}`;
    }

    get getStyleRamoSeguro() {
        return `background-color: #0087dc; border-color: #0087dc;`
    }

    get getContactanosImagen() {
        return globalSegurosPortal + '/images/gp-contactanos1.png';
    }
}