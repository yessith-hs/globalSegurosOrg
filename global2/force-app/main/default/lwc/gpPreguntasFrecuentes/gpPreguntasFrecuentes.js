import { LightningElement, wire } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';
// import { getDataFAQ } from 'c/gpInicioDataConfig';

import BASE_PATH from "@salesforce/community/basePath";
import { unEscape } from "c/clbinsUtils";

import getContentList from "@salesforce/apex/ManagedContentController.getContentList";

export default class PreguntasFrecuentes extends LightningElement {
    navigatorConfig;
    active;
    items = [{'imagen': ''}];
    currentItem = {'imagen': ''};
    pregunta;
    respuesta;
    // constructor() {
    //     super();
    //     this.active = 1;
    //     this.navigatorConfig = getDataFAQ();
    //     this.items = this.navigatorConfig.items;
    //     this.currentItem = this.items[0];
    //     this.pregunta = this.currentItem.pregunta;
    //     this.respuesta = this.currentItem.respuesta;
    // }

    @wire(getContentList, {
        page: 0,
        pageSize: 10,
        language: "es",
        filterby: "preguntas_frecuentes"
    })
    wiredContent({ data, error }) {
        console.log('data: ', data)
        if (data) {
            this.items = data.map((entry) => {
                const { pregunta, respuesta, imagen } = entry.contentNodes;

                return {
                    key: entry.contentKey,
                    pregunta: pregunta.value,
                    respuesta: unEscape(respuesta.value),
                    imagenRespuesta: `${BASE_PATH}/sfsites/c${imagen.url}`
                };
            });
            this.currentItem = this.items[0];
            this.error = undefined;
            console.log('currentItem: ', this.currentItem);
        }
        if (error) {
            console.log("Error: " + JSON.stringify(error));
        }
    }

    faqIcono = globalSegurosPortal + '/images/gp-faq-icono.svg';
}