import { LightningElement, wire } from 'lwc';

// import { getDataPrensa } from 'c/gpInicioDataConfig';

import BASE_PATH from "@salesforce/community/basePath";
import { unEscape } from "c/clbinsUtils";

import getContentList from "@salesforce/apex/ManagedContentController.getContentList";

export default class GpCarrouselPrensa extends LightningElement {

    active;
    items = [{'imagen': ''}];
    currentItem = {'imagen': ''};
    // constructor() {
    //     super();
    //     this.active = 1;
    //     this.navigatorConfig = getDataPrensa();
    //     this.items = this.navigatorConfig.items;
    //     this.currentItem = this.items[0];
    // }
    @wire(getContentList, {
        page: 0,
        pageSize: 10,
        language: "es",
        filterby: "prensa"
    })
    wiredContent({ data, error }) {
        console.log('data: ', data)
        if (data) {
            this.items = data.map((entry) => {
                const { titulo, descripcion, logoPrensa, imagen, urlPrensa } = entry.contentNodes;

                return {
                    key: entry.contentKey,
                    titulo: titulo.value,
                    descripcion: descripcion.value,
                    urlPrensa: urlPrensa.value,
                    imagen: `${BASE_PATH}/sfsites/c${imagen.url}`,
                    logoPrensa: `${BASE_PATH}/sfsites/c${logoPrensa.url}`
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

}