import { LightningElement, wire } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';

import getContentList from "@salesforce/apex/ManagedContentController.getContentList";
import basePath from "@salesforce/community/basePath";

export default class CasosExito extends LightningElement {
    navigatorConfig;
    active;
    items;
    currentItem = {'imagen': ''};

    @wire(getContentList, {
        page: 0,
        pageSize: 10,
        language: "es",
        filterby: "casos_exito"
    })
    wiredContent({ data, error }) {
        console.log('data: ', data)
        if (data) {
            this.items = data.map((entry) => {
                const { titulo, descripcion, seguro, color, publicacion, imagen} = entry.contentNodes;

                return {
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
            console.log('currentItem: ', this.currentItem);
        }
        if (error) {
            console.log("Error: " + JSON.stringify(error));
        }
    }

    caretLeftImg = globalSegurosPortal + '/images/navegar-caret-left.png';
    caretRightImg = globalSegurosPortal + '/images/navegar-caret-right.png';
    sloganImg = globalSegurosPortal + '/images/gp-inicio-casos-exito__slogan.png';
}