import { LightningElement, wire } from 'lwc';

import globalSegurosPortal from "@salesforce/resourceUrl/global_seguros_portal";
import BASE_PATH from "@salesforce/community/basePath";
import getContentList from "@salesforce/apex/ManagedContentController.getContentList";

export default class SolucionesRecomendadas extends LightningElement {
    urlConexionGlobal = `${BASE_PATH}/conexion-global`;
    solucionesRecomendadas;
    active
    items;
    currentItem;

  @wire(getContentList, {
    page: 0,
    pageSize: 10,
    language: "es",
    filterby: "soluciones_recomendadas"
  })
  wiredContent({ data, error }) {
    console.log('data: ', data)
    if (data) {
      this.items = data.map((entry) => {
        const { contenido, ramoSeguros, colorRamoSeguros, imagen } = entry.contentNodes;

        return {
          key: entry.contentKey,
          descripcion: contenido.value,
          ramoSeguros: ramoSeguros.value,
          colorRamoSeguros: colorRamoSeguros.value,
          imagen: `${BASE_PATH}/sfsites/c${imagen.url}`,
          linkDetalle: entry.contentUrlName
        };
      });
      this.error = undefined;
    }
    if (error) {
      console.log("Error: " + JSON.stringify(error));
    }
  }
  
    botonConocerMas = globalSegurosPortal + "/images/gp-boton-ver-todo.png";
}