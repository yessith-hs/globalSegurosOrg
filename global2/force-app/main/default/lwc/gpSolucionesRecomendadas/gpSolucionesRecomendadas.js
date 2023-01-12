import { LightningElement } from 'lwc';

import globalSegurosPortal from "@salesforce/resourceUrl/global_seguros_portal";
import { getDataSolucionesRecomendadas } from "c/gpInicioDataConfig";
import BASE_PATH from "@salesforce/community/basePath";

export default class SolucionesRecomendadas extends LightningElement {
    urlConexionGlobal = `${BASE_PATH}/conexion-global`;
    solucionesRecomendadas;
    active
    items;
    currentItem;
    constructor() {
      super();
      this.active = 1;
      this.solucionesRecomendadas = getDataSolucionesRecomendadas();
      this.items = this.solucionesRecomendadas.items;
      this.currentItem = this.items[0];
    }
  
    botonConocerMas = globalSegurosPortal + "/images/gp-boton-ver-todo.png";
}