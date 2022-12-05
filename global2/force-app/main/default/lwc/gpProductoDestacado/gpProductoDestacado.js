import { LightningElement } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';

export default class ProductoDestacado extends LightningElement {

    featuredImage = globalSegurosPortal + '/images/' + 'gp-inicio-featured.png';
}