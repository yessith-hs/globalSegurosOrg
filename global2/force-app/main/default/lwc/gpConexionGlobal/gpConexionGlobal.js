import { LightningElement, wire } from "lwc";

import globalSegurosPortal from "@salesforce/resourceUrl/global_seguros_portal";
// import { getDataConexionGlobal } from "c/gpInicioDataConfig";
import BASE_PATH from "@salesforce/community/basePath";
import { formatDate, unEscape } from "c/clbinsUtils";

import getContentList from "@salesforce/apex/ManagedContentController.getContentList";

export default class ConexionGlobal extends LightningElement {
  urlConexionGlobal = `${BASE_PATH}/conexion-global`;
  navigatorConfig;
  active;
  items=[{'imagen': ''}];
  currentItem;
  // constructor() {
  //   super();
  //   this.active = 1;
  //   this.navigatorConfig = getDataConexionGlobal();
  //   this.items = this.navigatorConfig.items;
  //   this.currentItem = this.items[0];
  // }

  @wire(getContentList, {
    page: 0,
    pageSize: 10,
    language: "es",
    filterby: "Noticias_Global"
  })
  wiredContent({ data, error }) {
    console.log('data: ', data)
    if (data) {
      this.items = data.map((entry) => {
        const { Title, Descripcion, tematica, fechapublicacion, Imagen1, Comentarios } = entry.contentNodes;

        return {
          key: entry.contentKey,
          titulo: Title.value,
          linkBoton: Descripcion.value,
          contenido: unEscape(Comentarios.value),
          fecha: formatDate(fechapublicacion.value),
          imagen: `${BASE_PATH}/sfsites/c${Imagen1.url}`
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
  botonVerTodoImg = globalSegurosPortal + "/images/gp-boton-ver-todo.png";
}