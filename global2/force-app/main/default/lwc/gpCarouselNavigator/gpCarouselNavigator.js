import { LightningElement, api } from 'lwc';

export default class GpCarouselNavigator extends LightningElement {
    _active = '1';
    _maxItems=0;
    @api color = 'dot_border_ffffff';
    @api width = 'dot_width36';
    // @api maxitems = 5;
    @api
    set maxitems(value) {
        if (this._maxItems !== value)
            this._maxItems = value;
    }
    get maxitems() {
        return this._maxItems;
    }

    @api textoEvento = '';
    @api marginRight = '9px'

    @api
    set active(value) {
        if (this._active !== value) {
            // desactivar
            if (this.template.querySelector(`[data-id="${value}"]`))
                this.template.querySelector(`[data-id="${value}"]`).classList.add('active');
            
            if (this.template.querySelector(`[data-id="${this._active}"]`))
                this.template.querySelector(`[data-id="${this._active}"]`).classList.remove('active');
            
            this._active = value;
        }
    }
    get active() {
        return this._active;
    }

    items = [];

    renderedCallback() {
        // initialize component
        if ( this?.template?.querySelector(`[data-id="${this._active}"]`) )
            this?.template?.querySelector(`[data-id="${this._active}"]`).classList.add('active');
    }

    get getItems() {
        // if (this.items.length == 0) {
            this.items = [];
            for (let k = 1; k <= this._maxItems; k++) {
                this.items.push({ "id": k })
            }
        // }
        return this.items;
    }

    get dotStyle() {
        return 'border: 2px solid ' +  this.color + '; width: ' + this.width + ';' +
            'margin-right: ' + this.marginRight;
    }

    get textoStyle() {
        return 'color: ' + this.color;
    }

    handleSelect(event) {
        this.template.querySelector(`[data-id="${event.target.dataset.id}"]`).classList.add('active');
        this.template.querySelector(`[data-id="${this._active}"]`).classList.remove('active');
        this._active = event.target.dataset.id;

        const selectEvent = new CustomEvent(this.textoEvento, {
            detail: event.target.dataset.id
        });
        // Fire the custom event
        this.dispatchEvent(selectEvent);
    }
}