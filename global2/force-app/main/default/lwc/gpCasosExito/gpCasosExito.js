import { LightningElement, wire } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';

import getContentList from "@salesforce/apex/ManagedContentController.getContentList";
import basePath from "@salesforce/community/basePath";

export default class CasosExito extends LightningElement {
    navigatorConfig;
    active = 1;
    items = [];
    currentItem = {'imagen': ''};

    renderedCallback() {
        // initialize component
        if (this.template.querySelector(`[data-id="cex-${this.active}"]`))
            this.template.querySelector(`[data-id="cex-${this.active}"]`).classList.remove('inactive');
    }

    @wire(getContentList, {
        page: 0,
        pageSize: 10,
        language: "es",
        filterby: "casos_exito"
    })
    wiredContent({ data, error }) {
        if (data) {
            this.items = data.map((entry, index) => {
                const { titulo, descripcion, seguro, color, publicacion, imagen} = entry.contentNodes;

                return {
                    id: `cex-${index + 1}`,
                    key: entry.contentKey,
                    titulo: titulo.value,
                    subTitulo: descripcion.value,
                    contenido: publicacion.value,
                    ramoSeguros: seguro.value,
                    colorRamoSeguros: color.value,
                    casoExitoImagen: `${basePath}/sfsites/c${imagen.url}`
                };
            });
            this.currentItem = this.items[0];
            this.error = undefined;
        }
        if (error) {
            console.log("Error: " + JSON.stringify(error));
        }
    }

    handleItemSelected(event) {
        let activeAnterior = this.active;if (this.active !== event.detail) {
            this.active = event.detail;
            this.template.querySelector(`[data-id="cex-${activeAnterior}"]`).classList.add('inactive');
            this.template.querySelector(`[data-id="cex-${this.active}"]`).classList.remove('inactive');
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

        this.template.querySelector(`[data-id="cex-${activeAnterior}"]`).classList.add('inactive');
        this.template.querySelector(`[data-id="cex-${this.active}"]`).classList.remove('inactive');
    }

    get maxItems() {
        return this.items.length;
    }

    get activeItem() {
        return this.active;
    }

    caretLeftImg = globalSegurosPortal + '/images/navegar-caret-left.png';
    caretRightImg = globalSegurosPortal + '/images/navegar-caret-right.png';
    sloganImg = globalSegurosPortal + '/images/gp-inicio-casos-exito__slogan.png';
}