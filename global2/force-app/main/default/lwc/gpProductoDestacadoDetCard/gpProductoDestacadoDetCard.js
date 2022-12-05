import { LightningElement, api } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';

export default class GpProductoDestacadoDetCard extends LightningElement {
    @api contenidoCard =             {
        id: '1851dcf3-3d6e-45ad-9383-8d17d07b9209',
        titulo: '¿Cómo realizar un pago?',
        descripcion: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Necessitatibus iure distinctio ipsam maxime modi expedita doloremque esse illo numquam? Tempora quam nam ipsa totam sapiente. Aut optio est ea, fugiat placeat ipsa eius recusandae tenetur maxime.',
        icono: '',
        textoIcono: '',
        tipoRecurso: 'video',
        recurso: 'video-sample1.avi'
    };

    verVideoIco = globalSegurosPortal + '/images/' + 'gp-ver-video-ico.svg';

    get getVideo() {
        return globalSegurosPortal + '/images/' + this.contenidoCard.recurso;
    }
}