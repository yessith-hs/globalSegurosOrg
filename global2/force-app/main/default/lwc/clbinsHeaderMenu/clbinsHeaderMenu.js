import { LightningElement } from "lwc";
import BASE_PATH from "@salesforce/community/basePath";
// import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';

export default class ClbinsHeaderMenu extends LightningElement {
  basePath = `${BASE_PATH}/conexion-global`;
  home = BASE_PATH;
  activeMenu() {
    this.template.querySelector("nav").classList.add("active");
    this.template.querySelector(".navmenu_background").classList.add("show");
  }
  closeMenu() {
    this.template.querySelector("nav").classList.remove("active");
    this.template.querySelector(".navmenu_background").classList.remove("show");
  }
}