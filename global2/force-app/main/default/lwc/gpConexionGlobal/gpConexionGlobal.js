import { LightningElement, wire } from "lwc";

import globalSegurosPortal from "@salesforce/resourceUrl/global_seguros_portal";
import BASE_PATH from "@salesforce/community/basePath";
import { formatDate, unEscape } from "c/clbinsUtils";

import getContentList from "@salesforce/apex/ManagedContentController.getContentList";

export default class ConexionGlobal extends LightningElement {
    urlConexionGlobal = `${BASE_PATH}/soy-global`;
    active = 1;
    maxItems;
    items = [{ 'imagen': '' }];

    @wire(getContentList, {
        page: 0,
        pageSize: 10,
        language: "es",
        filterby: "Noticias_Global"
    })
    wiredContent({ data, error }) {
        if (data) {
            this.items = data.map((entry, index) => {
                const { Title, Descripcion, tematica, fechapublicacion, Imagen1, Comentarios } = entry.contentNodes;

                return {
                    key: entry.contentKey,
                    notaId: `nota-${index + 1}`,
                    titulo: Title.value,
                    linkBoton: entry.contentUrlName,
                    contenido: unEscape(Comentarios?.value ? Comentarios.value : ''),
                    fecha: formatDate(fechapublicacion.value),
                    imagen: `${BASE_PATH}/sfsites/c${Imagen1.url}`
                };
            });
            this.maxItems = this.items.length;
            this.error = undefined;
        }
        if (error) {
            console.log("Error: " + JSON.stringify(error));
        }
    }

    handleItemSelected(event) {
        let carrousel;
        if (this.active !== event.detail) {
            if ( this.template.querySelector(`[data-id="nota-${event.detail}"]`) ) {
                carrousel = this.template.querySelector(`[data-id="nota-${event.detail}"]`);
                carrousel.scrollIntoView({behavior: "smooth", block: "nearest", inline: "center"});
            }
        }
    }

    botonVerTodoImg = globalSegurosPortal + "/images/gp-boton-ver-todo.png";
}