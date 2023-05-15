import { LightningElement, api } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';

export default class PreguntasFrecuentesCarrusel extends LightningElement {
    @api items;

    @api
    set maxitems( value ) {
        this._maxitems = value;
    }
    get maxitems() {
        return this._maxitems;
    }

    @api
    set active(value) {
        let carrousel;
        if (this._active !== value) {
            if (this.template.querySelector(`[data-id="faqtxt-${this._active}"]`))
                this.template.querySelector(`[data-id="faqtxt-${this._active}"]`).classList.remove('active-pregunta');

            this.template.querySelector(`[data-id="faqtxt-${value}"]`).classList.add('active-pregunta');

            // hacer scroll en la pregunta 
            if ( this.template.querySelector(`[data-id="faq-${value}"]`) ) {
                carrousel = this.template.querySelector(`[data-id="faq-${value}"]`);
                carrousel.scrollIntoView({behavior: "smooth", block: "nearest", inline: "center"});
            }
            
            this._active = value;
        }
    }
    get active() {
        return this._active;
    }

    _active = '1';
    _maxitems = '1';

    renderedCallback() {
        if ( this?.template?.querySelector(`[data-id="faqtxt-${this._active}"]`) )
            this?.template?.querySelector(`[data-id="faqtxt-${this._active}"]`).classList.add('active-pregunta');
    }

    verTodas(event) {
        event.preventDefault();
        const verTodasEvent = new CustomEvent('vertodas', {
            detail: 1
        });
        this.dispatchEvent(verTodasEvent); 
    }

    activatePregunta(event) {
        event.preventDefault();

        let selected = event.target.dataset.id.replace('faqbtn-', '');

        this.managePregunta(selected);
    }

    managePregunta(selected) {
        const selectEvent = new CustomEvent('changepregunta', {
            detail: selected
        });

        this.dispatchEvent(selectEvent); 
    }

    handleItemSelected(event) {
        let carrousel;
        if (this._active !== event.detail) {
            // // hacer scroll en la pregunta 
            // if ( this.template.querySelector(`[data-id="faq-${event.detail}"]`) ) {
            //     carrousel = this.template.querySelector(`[data-id="faq-${event.detail}"]`);
            //     carrousel.scrollIntoView({behavior: "smooth", inline: "start"});
            // }
            
            this.managePregunta(event.detail);
        }
    }

    botonMasInactivo = globalSegurosPortal + '/images/gp-faq-boton-mas-inactivo.svg';
    botonVerTodas = globalSegurosPortal + '/images/gp-faq-boton-ver-todas.png';
}