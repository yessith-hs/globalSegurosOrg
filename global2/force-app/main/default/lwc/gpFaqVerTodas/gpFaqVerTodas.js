import { LightningElement } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';
import BASE_PATH from "@salesforce/community/basePath";

export default class GpFaqVerTodas extends LightningElement {
    urlSolucionesRecomendadas = `${BASE_PATH}`;
    botonVolverAtrasImg = globalSegurosPortal + "/images/gp-boton-volver-atras.png";
}