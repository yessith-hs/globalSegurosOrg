import { LightningElement } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';
import { getDataCasosExito } from 'c/gpInicioDataConfig';


export default class CasosExito extends LightningElement {
    navigatorConfig;
    active;
    items;
    currentItem;
    constructor() {
        super();
        this.active = 1;
        this.navigatorConfig = getDataCasosExito();
        this.items = this.navigatorConfig.items;
        this.currentItem = this.items[0];
    }

    casoExitoImg = globalSegurosPortal + '/images/gp-inicio-caso-exito.png';
    caretLeftImg = globalSegurosPortal + '/images/navegar-caret-left.png';
    caretRightImg = globalSegurosPortal + '/images/navegar-caret-right.png';
    sloganImg = globalSegurosPortal + '/images/gp-inicio-casos-exito__slogan.png';


}