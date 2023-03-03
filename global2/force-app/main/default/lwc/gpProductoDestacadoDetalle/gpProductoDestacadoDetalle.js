import { LightningElement, api, wire } from 'lwc';

import { getDataProdDestDetalle } from 'c/gpInicioDataConfig';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';

import getContentList from "@salesforce/apex/ManagedContentController.getContentList";
import basePath from "@salesforce/community/basePath";

export default class ProductoDestacadoDetalle extends LightningElement {
    @api detailTitulo = 'Ahora es mucho más fácil';
    @api detailDescrip = 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English.'

    active;
    items;
    currentItem;
    constructor() {
        super();
        this.active = 1;
        this.navigatorConfig = getDataProdDestDetalle();
        this.items = this.navigatorConfig.items;
        this.currentItem = this.items[0];
    }

    @wire(getContentList, {
        page: 0,
        pageSize: 10,
        language: "es",
        filterby: "sliderVideo"
    })
    wiredContent({ data, error }) {
        console.log('data: ', data)
        if (data) {
            this.items = data.map((entry, index) => {
                const { titulo, description, urlVideo } = entry.contentNodes;

                return {
                    key: entry.contentKey,
                    videoId: `video-${index + 1}`,
                    linkId: `link-${index + 1}`,
                    titulo: titulo.value,
                    descripcion: description.value,
                    urlVideo: urlVideo.value
                };
            });
            this.error = undefined;
        }
        if (error) {
            console.log("Error: " + JSON.stringify(error));
        }
    }

    // pagoEnLineaImage = globalSegurosPortal + '/images/' + 'gp-boton-pago-en-linea.png';
}