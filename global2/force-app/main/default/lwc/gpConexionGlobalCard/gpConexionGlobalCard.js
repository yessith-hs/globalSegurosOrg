import { LightningElement, api } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';

export default class GpConexionGlobalCard extends LightningElement {
    @api conexionDetail = {
        id: '48333a26-3924-44e0-9g57-3eadf3b73846',
        fecha: '12 diciembre 2022',
        titulo: 'Proyecta tus beneficios a futuro',
        contenido: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English.',
        linkBoton: 'Habilidades socioemocionales', 
        imagen: 'gp-conexion-card1.png'
    };

    get getConexionImagen() {
        return globalSegurosPortal + '/images/' + this.conexionDetail.imagen;
    }
}