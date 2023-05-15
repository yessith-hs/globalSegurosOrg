import { LightningElement, wire } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';

import BASE_PATH from "@salesforce/community/basePath";

import getContentList from "@salesforce/apex/ManagedContentController.getContentList";

export default class PreguntasFrecuentes extends LightningElement {
    active='1';
    items = [{'imagen': ''}];
    currentItems = [{'imagen': ''}];
    currentPregunta = {'imagen': ''};
    verTodasFaq = false;
    
    maxItems = 0;

    @wire(getContentList, {
        page: 0,
        pageSize: 100,
        language: "es",
        filterby: "preguntas_frecuentes"
    })
    wiredContent({ data, error }) {
        if (data) {
            this.items = data.map((entry, index) => {
                const { pregunta, respuesta, imagen } = entry.contentNodes;

                return {
                    idFaq: `faq-${index + 1}`,
                    idFaqBtnMas: `faqbtn-${index + 1}`,
                    idFaqTxt: `faqtxt-${index + 1}`,
                    key: entry.contentKey,
                    pregunta: pregunta.value,
                    respuesta: this.htmlDecode(respuesta.value),
                    imagenRespuesta: `${BASE_PATH}/sfsites/c${imagen.url}`
                };
            });
            this.currentPregunta = this.items[0];
            this.currentItems = this.items.slice(0, 5);
            this.maxItems = this.currentItems.length;
            this.active = '1';
            this.error = undefined;
        }
        if (error) {
            console.log("Error: " + JSON.stringify(error));
        }
    }

    faqIcono = globalSegurosPortal + '/images/gp-faq-icono.svg';

    htmlDecode(input) {
        const doc = new DOMParser().parseFromString(input, 'text/html')
        return doc.documentElement.textContent
    }

    handleChangePregunta(event) {
        if (this.active !== event.detail) {
            this.active = event.detail;
            this.currentPregunta = this.items[parseInt(this.active) - 1]
        }
    }

    get preguntas() {
        if (!this.verTodasFaq) 
            this.currentItems = this.items.slice(0, 5);
        else
            this.currentItems = this.items;
        
        this.maxItems = this.currentItems.length;
        
        return this.currentItems;
    }

    verTodas(event) {
        this.verTodasFaq = !this.verTodasFaq;
        this.preguntas();
    }

    handleItemSelected(event) {
        if (this.active !== event.detail) {
            this.active = event.detail;
            this.currentPregunta = this.items[parseInt(this.active) - 1]
        }
    }

    get numItems() {
        return this.maxItems;
    }

    get activeItem() {
        return this.active;
    }

}