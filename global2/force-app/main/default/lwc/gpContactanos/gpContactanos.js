import { LightningElement } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';
import BASE_PATH from "@salesforce/community/basePath";

export default class Contactanos extends LightningElement {
    urlServicioCliente = `${BASE_PATH}/comuniquese-con-nosotros/`;
    
    agendaCitaIco = globalSegurosPortal + '/images/gp-ico-agenda-cita.svg';
    contactanosImage = globalSegurosPortal + '/images/gp-contactanos.png';
    servicioClienteImg = globalSegurosPortal + '/images/gp-ico-servicio-cliente.svg';
    botonAgendaCitaImg = globalSegurosPortal + '/images/gp-boton-agenda-cita.png';
}