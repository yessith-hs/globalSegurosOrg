import { LightningElement } from "lwc";
import globalSegurosPortal from "@salesforce/resourceUrl/global_seguros_portal";
import { getDataConexionGlobal } from "c/gpInicioDataConfig";
import BASE_PATH from "@salesforce/community/basePath";

export default class ConexionGlobal extends LightningElement {
  urlConexionGlobal = `${BASE_PATH}/conexion-global`;
  navigatorConfig;
  active;
  items;
  currentItem;
  constructor() {
    super();
    this.active = 1;
    this.navigatorConfig = getDataConexionGlobal();
    this.items = this.navigatorConfig.items;
    this.currentItem = this.items[0];
  }

  botonVerTodoImg = globalSegurosPortal + "/images/gp-boton-ver-todo.svg";
}