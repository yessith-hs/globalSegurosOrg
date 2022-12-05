import { LightningElement, api } from 'lwc';

import { getDataProdDestDetalle } from 'c/gpInicioDataConfig';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';

export default class ProductoDestacadoDetalle extends LightningElement {
    @api detailTitulo = 'Ahora es mucho más fácil';
    @api detailDescrip = 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English.'

    active;
    items;
    currentItem;
    constructor() {
        super();
        this.active = 1;
        this.navigatorConfig = getDataProdDestDetalle();
        this.items = this.navigatorConfig.items;
        this.currentItem = this.items[0];
    }

    pagoEnLineaImage = globalSegurosPortal + '/images/' + 'gp-boton-pago-en-linea.png';
}