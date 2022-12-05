import { LightningElement } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';

export default class Contactanos extends LightningElement {
    agendaCitaIco = globalSegurosPortal + '/images/gp-ico-agenda-cita.svg';
    contactanosImage = globalSegurosPortal + '/images/gp-contactanos.png';
    servicioClienteImg = globalSegurosPortal + '/images/gp-ico-servicio-cliente.svg';
    botonAgendaCitaImg = globalSegurosPortal + '/images/gp-boton-agenda-cita.png';
}