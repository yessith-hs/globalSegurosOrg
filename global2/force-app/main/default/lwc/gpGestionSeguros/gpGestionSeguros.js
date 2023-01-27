import { LightningElement, wire } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';
import getContentList from "@salesforce/apex/ManagedContentController.getContentList";

import BASE_PATH from "@salesforce/community/basePath";

export default class GestionSeguros extends LightningElement {
    items = [{'imagen': ''}];

    // @wire(getContentList, {
    //     page: 0,
    //     pageSize: 10,
    //     language: "es",
    //     filterby: "gestiona_tus_seguros"
    // })
    // wiredContent({ data, error }) {
    //     console.log('data: ', data)
    //     if (data) {
    //         this.items = data.map((entry) => {
    //             const { Title, texto_mensaje, url } = entry.contentNodes;

    //             return {
    //                 key: entry.contentKey,
    //                 titulo: Title.value,
    //                 descripcion: texto_mensaje.value,
    //                 url: url?.value ? url.value : '#'
    //             };
    //         });
    //         this.error = undefined;
    //         console.log('currentItem: ', this.currentItem);
    //     }
    //     if (error) {
    //         console.log("Error: " + JSON.stringify(error));
    //     }
    // }

    gestionSeguroImg = globalSegurosPortal + '/images/gp-gestion-seguros.png';
    gestionSeguroIcoImg = globalSegurosPortal + '/images/gp-gestion-seguros-ico.svg';
    misSegurosImg = globalSegurosPortal + '/images/gp-mis-seguros.svg';
    solucionesImg = globalSegurosPortal + '/images/gp-soluciones-recomendadas-para-ti.svg';
    pagaLineaImg = globalSegurosPortal + '/images/gp-paga-en-linea.svg';
    documentosImg = globalSegurosPortal + '/images/gp-certificados-documentos.svg';
    beneficiosImg = globalSegurosPortal + '/images/gp-pago-mis-beneficios.svg';

    urlSolucionesRecomendadas = `${BASE_PATH}/soluciones-pensadas-para-ti`;
}