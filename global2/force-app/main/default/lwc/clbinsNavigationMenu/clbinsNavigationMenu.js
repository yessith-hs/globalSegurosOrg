import { LightningElement } from "lwc";
import { NavigationMixin } from "lightning/navigation";

export default class ClbInsNavigationMenu extends NavigationMixin(
  LightningElement
) {
  hideButtons = "";
  hideMenu = "hide";

  handleClickMenu() {
    this.template.querySelector(".payment").classList.remove("dynamicButton");
    this.template.querySelector(".services").classList.remove("dynamicButton");
    this.hideMenu = "hide";

    if (!this.hideButtons) {
      this.hideButtons = "hide";
    } else {
      this.hideButtons = "";
    }
  }

  handleClickPayment() {
    this.template.querySelector(".payment").classList.add("dynamicButton");
    this.template.querySelector(".services").classList.remove("dynamicButton");
    this.template
      .querySelector(".button_container--left")
      .classList.add("button_container--border");
    this.template
      .querySelector(".button_container--right")
      .classList.remove("button_container--border");
    this.hideMenu = "hide";
  }

  handleClickServices() {
    this.template.querySelector(".services").classList.add("dynamicButton");
    this.template.querySelector(".payment").classList.remove("dynamicButton");
    this.template
      .querySelector(".button_container--right")
      .classList.add("button_container--border");
    this.template
      .querySelector(".button_container--left")
      .classList.remove("button_container--border");

    if (!this.hideMenu) {
      this.hideMenu = "hide";
    } else {
      this.hideMenu = "";
    }
  }

  get buttonContainerClasses() {
    let buttonCss = `buttons_container ${this.hideButtons}`;
    return buttonCss;
  }
  get dropdownClasses() {
    let dropdownCss = `dropdown_menu ${this.hideMenu}`;
    return dropdownCss;
  }
}