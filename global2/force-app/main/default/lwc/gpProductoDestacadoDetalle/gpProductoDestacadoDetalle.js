import { LightningElement, api, wire } from 'lwc';

import getContentList from "@salesforce/apex/ManagedContentController.getContentList";

export default class ProductoDestacadoDetalle extends LightningElement {
    @api detailTitulo = 'Ahora es mucho más fácil';
    @api detailDescrip = 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English.'

    _active = 1;
    maxItems;
    items;
    currentItem;

    @wire(getContentList, {
        page: 0,
        pageSize: 10,
        language: "es",
        filterby: "sliderVideo"
    })
    wiredContent({ data, error }) {
        if (data) {
            this.items = data.map((entry, index) => {
                const { titulo, description, urlVideo } = entry.contentNodes;

                return {
                    key: entry.contentKey,
                    videoId: `video-${index + 1}`,
                    linkId: `link-${index + 1}`,
                    tituloId: `titulo-${index + 1}`,
                    titulo: titulo.value,
                    descripcion: description.value,
                    urlVideo: urlVideo.value
                };
            });
            this.error = undefined;
            this.maxItems = this.items.length;
        }
        if (error) {
            console.log("Error: " + JSON.stringify(error));
        }
    }

    handleItemSelected(event) {
        let carrousel;
        if (this._active !== event.detail) {
            // hacer scroll al video seleccionado
            if ( this.template.querySelector(`[data-id="video-${event.detail}"]`) ) {
                carrousel = this.template.querySelector(`[data-id="video-${event.detail}"]`);
                carrousel.scrollIntoView({behavior: "smooth", block: "nearest", inline: "center"});
                this._active = event.detail;
            }
        }
    }
    
    get active() {
        return this._active;
    }

}