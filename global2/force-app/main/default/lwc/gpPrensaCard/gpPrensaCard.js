import { LightningElement, api } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';

export default class PrensaCard extends LightningElement {
    @api notaPrensa= {
        key: '5abcbcc1-74dc-47b9-93c1-3bb2b39d7c8c',
        logoPrensa: 'Semana 002',
        titulo: 'Seguros educativos permitieron que jóvenes colombianos siguieran en la universidad durante la pandemia',
        descripcion: 'Lorem, ipsum dolor sit amet consectetur adipisicing elit, voluptatum distinctio dicta porro voluptas.',
        imagen: 'gp-prensa-001.png',
        urlPrensa: ''
    };

    // get notaPrensaImagen() {
    //     return globalSegurosPortal + '/images/' + this.notaPrensa.imagen;
    // }
}