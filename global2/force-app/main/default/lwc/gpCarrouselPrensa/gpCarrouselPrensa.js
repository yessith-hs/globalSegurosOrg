import { LightningElement } from 'lwc';

import { getDataPrensa } from 'c/gpInicioDataConfig';

export default class GpCarrouselPrensa extends LightningElement {

    active;
    items;
    currentItem;
    constructor() {
        super();
        this.active = 1;
        this.navigatorConfig = getDataPrensa();
        this.items = this.navigatorConfig.items;
        this.currentItem = this.items[0];
    }


}