import { LightningElement } from 'lwc'
import SVG_LOGO from '@salesforce/resourceUrl/EsstudiaPartner'
import { NavigationMixin } from 'lightning/navigation'
import basePath from '@salesforce/community/basePath'

export default class ClbinsPartners extends NavigationMixin(LightningElement) {
  EsstudiaPartner = `${SVG_LOGO}#EsstudiaPartner`

  show() {
    this[NavigationMixin.Navigate]({
      type: 'comm__namedPage',
      attributes: {
        componentName: 'vlocity_ins__vlocityLWCOmniWrapper'
      },
      state: {
        c__target: 'c:clbinsTestEnglish',
        c__layout: 'newport', // or can be 'newport'
        c__tabIcon: 'custom:custom18',
        c__tabLabel: 'clbinsTest'
      }
    })
  }

  handleClick() {
    this[NavigationMixin.Navigate]({
      type: 'standard__webPage',
      attributes: {
        url: `${basePath}/OmniScriptType/clbins/OmniScriptSubType/Test/OmniScriptLang/English"`
      }
    })
  }
}
