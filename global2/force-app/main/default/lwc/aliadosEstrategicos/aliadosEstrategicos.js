import { LightningElement } from 'lwc';

import globalSegurosPortal from '@salesforce/resourceUrl/global_seguros_portal';

export default class AliadosEstrategicos extends LightningElement {
    // Expose the static resource URL for use in the template
    cicolLogo = globalSegurosPortal + '/images/gp-aliado-cicol-logo.png';
    esstudiaLogo = globalSegurosPortal + '/images/gp-aliado-estudia-logo.png';
    cleverULogo = globalSegurosPortal + '/images/gp-aliado-cleveru-logo.png';

}