import { LightningElement, wire } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';
import getContentList from "@salesforce/apex/ManagedContentController.getContentList";

import BASE_PATH from "@salesforce/community/basePath";

export default class GestionSeguros extends LightningElement {
    items = [{'imagen': ''}];

    gestionSeguroImg = globalSegurosPortal + '/images/gp-gestion-seguros.png';
    gestionSeguroIcoImg = globalSegurosPortal + '/images/gp-gestion-seguros-ico.svg';
    misSegurosImg = globalSegurosPortal + '/images/gp-mis-seguros.svg';
    solucionesImg = globalSegurosPortal + '/images/gp-soluciones-recomendadas-para-ti.svg';
    pagaLineaImg = globalSegurosPortal + '/images/gp-paga-en-linea.svg';
    documentosImg = globalSegurosPortal + '/images/gp-certificados-documentos.svg';
    beneficiosImg = globalSegurosPortal + '/images/gp-pago-mis-beneficios.svg';

    urlSolucionesRecomendadas = `${BASE_PATH}/soluciones-pensadas-para-ti`;
    urlGestionaTusSeguros = `${BASE_PATH}/gestiona-tus-seguros`;
    urlCertificados = `${BASE_PATH}/#`;
    urlMisBeneficios = `${BASE_PATH}/#`;

}