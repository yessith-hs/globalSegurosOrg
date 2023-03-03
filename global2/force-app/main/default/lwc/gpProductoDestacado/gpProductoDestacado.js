import { LightningElement, wire } from 'lwc';

import getContentList from "@salesforce/apex/ManagedContentController.getContentList";
import basePath from "@salesforce/community/basePath";

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';

export default class ProductoDestacado extends LightningElement {

    items=[];
    active=1;
    i = 0;

    renderedCallback() {
        // initialize component
        if (this.template.querySelector(`[data-id="pdi-${this.active}"]`))
            this.template.querySelector(`[data-id="pdi-${this.active}"]`).classList.remove('inactive');
        // this.template.querySelector(`[data-id="pdi-${this.active}"]`).classList.add('active');
    }

    @wire(getContentList, {
        page: 0,
        pageSize: 10,
        language: "es",
        filterby: "producto_destacado"
    })
    wiredContent({ data, error }) {
        if (data) {
            this.items = data.map((entry, index) => {
                const { Title, Descripcion, Imagen, Imagen2} = entry.contentNodes;
                return {
                    id: `pdi-${index + 1}`,
                    key: entry.contentKey,
                    detailTitulo: Title.value,
                    detailDescripcion: Descripcion.value,
                    botonImagen: `${basePath}/sfsites/c${Imagen2.url}`,
                    botonAltText: Imagen2.altText,
                    imagen: `${basePath}/sfsites/c${Imagen.url}`, 
                    imagenAltText: Imagen.altText
                };
            });
            this.error = undefined;
        }
        if (error) {
            console.log("Error: " + JSON.stringify(error));
        }
    }

    handleItemSelected(event) {
        let activeAnterior = this.active;
        // console.log(`handleItemSelected: ${even.detail} - ${activeAnterior}`)
        if (this.active !== event.detail) {
            this.active = event.detail;
            this.template.querySelector(`[data-id="pdi-${activeAnterior}"]`).classList.add('inactive');
            this.template.querySelector(`[data-id="pdi-${this.active}"]`).classList.remove('inactive');
        }
    }

    navigateToProducto(event) {
        let activeAnterior = this.active;
        event.preventDefault();
        if (event.target.dataset.id === "right-caret") {
            if (this.active + 1 > this.items.length) {
                this.active = 1;
            } else {
                this.active = this.active + 1;
            }
        } 
        
        if (event.target.dataset.id === "left-caret") {
            if (this.active - 1 < 1 ) {
                this.active = this.items.length;
            } else {
                this.active = this.active - 1;
            }
        } 

        this.template.querySelector(`[data-id="pdi-${activeAnterior}"]`).classList.add('inactive');
        this.template.querySelector(`[data-id="pdi-${this.active}"]`).classList.remove('inactive');
    }

    get maxProductItems() {
        return this.items.length;
    }

    get activeProduct() {
        return this.active;
    }

    caretLeftImg = globalSegurosPortal + '/images/navegar-caret-left.png';
    caretRightImg = globalSegurosPortal + '/images/navegar-caret-right.png';
}