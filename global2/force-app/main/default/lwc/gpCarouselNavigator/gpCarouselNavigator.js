import { LightningElement, api } from 'lwc';

export default class GpCarouselNavigator extends LightningElement {
    @api color = 'dot_border_ffffff';
    @api width = 'dot_width36';
    @api active = 1;
    @api maxitems = 5;
    items = [];

    // constructor () {
    //     super();
    //     for (var k=1; k <= this.maxitems; k++) {
    //         this.items.push({"id": k})
    //     }
    //     this.template.querySelector('[data-id="dotBoton"]').classList.add(color);
    //     this.template.querySelector('[data-id="dotBoton"]').classList.add(width);
    // }

    // handleSelect(event) {
    //     /* cambiar estilo a activo correspondiente, generar evento para informar cambio de tarjeta */
    // }
    get getItems() {
        for (let k = 1; k <= this.maxitems; k++) {
            this.items.push({ "id": k })
        }
        return this.items;
    }

    get dotStyle() {
        return 'border: 2px solid ' +  this.color + '; width: ' + this.width + ';';
    }

    get textoStyle() {
        return 'color: ' + this.color;
    }
}