import { LightningElement, api } from 'lwc';

export default class ClbinsCarouselNavigator extends LightningElement {
  @api color = 'dot_border_ffffff';
    @api width = 'dot_width36';
    @api active = 1;
    @api maxitems = 5;
    @api textoEvento = '';
    @api marginRight = '9px'
    items = [];

    get getItems() {
        if (this.items.length == 0) {
            for (let k = 1; k <= this.maxitems; k++) {
                this.items.push({ "id": k })
            }
        }
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
        this.template.querySelector(`[data-id="${this.active}"]`).classList.remove('active');
        this.active = event.target.dataset.id;

        const selectEvent = new CustomEvent(this.textoEvento, {
            detail: event.target.dataset.id
        });
        // Fire the custom event
        this.dispatchEvent(selectEvent);
    }
}