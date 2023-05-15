import { LightningElement, api } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';

export default class GpProductoDestacadoDetCard extends LightningElement {
    _active = '1';

    @api contenidoCard =             {
        key: '1851dcf3-3d6e-45ad-9383-8d17d07b9209',
        titulo: '¿Cómo realizar un pago?',
        descripcion: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Necessitatibus iure distinctio ipsam maxime modi expedita doloremque esse illo numquam? Tempora quam nam ipsa totam sapiente. Aut optio est ea, fugiat placeat ipsa eius recusandae tenetur maxime.',
        urlVideo: ''
    };

    @api
    set active(value) {
        if (this._active !== value) {
            // desactivar
            if (this.template.querySelector(`[data-id="titulo-${value}"]`))
                this.template.querySelector(`[data-id="titulo-${value}"]`).classList.add('active');
            
            if (this.template.querySelector(`[data-id="titulo-${this._active}"]`))
                this.template.querySelector(`[data-id="titulo-${this._active}"]`).classList.remove('active');
            
            this._active = value;
        }
    }
    get active() {
        return this._active;
    }
    verVideoIco = globalSegurosPortal + '/images/' + 'gp-ver-video-ico.svg';

    verVideo(event) {
        event.preventDefault();
        let video = event.target.dataset.id;
        video = video.replace('link', 'video');
        let src = this.template.querySelector(`[data-id="${video}"]`).src.replace('\?autoplay=1', '');
        this.template.querySelector(`[data-id="${video}"]`).src = (src + '?autoplay=1');
    }
}