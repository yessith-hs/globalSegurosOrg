import { LightningElement } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';

export default class GestionSeguros extends LightningElement {

    gestionSeguroImg = globalSegurosPortal + '/images/gp-gestion-seguros.png';
    gestionSeguroIcoImg = globalSegurosPortal + '/images/gp-gestion-seguros-ico.svg';
    misSegurosImg = globalSegurosPortal + '/images/gp-mis-seguros.svg';
    solucionesImg = globalSegurosPortal + '/images/gp-soluciones-recomendadas-para-ti.svg';
    pagaLineaImg = globalSegurosPortal + '/images/gp-paga-en-linea.svg';
    documentosImg = globalSegurosPortal + '/images/gp-certificados-documentos.svg';
    beneficiosImg = globalSegurosPortal + '/images/gp-pago-mis-beneficios.svg';

}