import { LightningElement, wire } from 'lwc';

import getContentList from "@salesforce/apex/ManagedContentController.getContentList";
import basePath from "@salesforce/community/basePath";

// import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';

export default class ProductoDestacado extends LightningElement {

    // featuredImage = globalSegurosPortal + '/images/' + 'gp-inicio-featured.png';
    // featuredImage = basePath + '/images/' + 'gp-inicio-featured.png';

    items;

    @wire(getContentList, {
        page: 0,
        pageSize: 10,
        language: "es",
        filterby: "producto_destacado"
    })
    wiredContent({ data, error }) {
        console.log('data: ', data)
        if (data) {
            this.items = data.map((entry) => {
                const { Title, Descripcion, Imagen, Imagen2} = entry.contentNodes;

                return {
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
}