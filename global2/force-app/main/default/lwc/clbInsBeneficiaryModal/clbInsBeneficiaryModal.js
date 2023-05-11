import { LightningElement, wire, track, api } from 'lwc'
import { OmniscriptBaseMixin } from 'vlocity_ins/omniscriptBaseMixin'
import tmpl from './clbInsBeneficiaryModal.html'
import tmpl_nds from './clbInsBeneficiaryModal_nds.html'

// import { getPicklistValues } from "lightning/uiObjectInfoApi";
// import BENEFICIARY_RELATIONSHIP from "@salesforce/schema/Account.Beneficiary_Relationship__c";

export default class ClbInsBeneficiaryModal extends OmniscriptBaseMixin(LightningElement) {
  static renderMode = 'light'
  errorMessage = 'Error: Parentesco es requerido'
  helptext = 'La suma de los porcentajes designados debe ser del 100%'

  jsonData = []
  pickListvalues = []
  beneficiaries
  @api beneficiary

  // * get picklist values
  // @wire(getPicklistValues, {
  //   recordTypeId: "012000000000000AAA",
  //   fieldApiName: BENEFICIARY_RELATIONSHIP
  // })
  // getPicklistValuesForField({ data, error }) {
  //   if (data) {
  //     const { values } = data;

  //     this.pickListvalues = values.map((member) => {
  //       const { label, value } = member;
  //       return {
  //         label,
  //         value
  //       };
  //     });
  //   }

  //   if (error) {
  //     console.log(` Error while fetching Picklist values  ${error}`);
  //   }
  // }

  // * selected values
  @track BeneficiaryFirstNameValue
  @track BeneficiaryLastNameValue
  @track BeneficiaryMotherNameValue
  @track BeneficiaryMarriedNameValue
  @track BeneficiaryRelationshipValue
  @track BeneficiaryPercentageValue

  // * handlers methods
  getBeneficiaryFirstName(event) {
    this.BeneficiaryFirstNameValue = event.detail?.value ?? event.target.value
  }
  getBeneficiaryLastName(event) {
    this.BeneficiaryLastNameValue = event.detail?.value ?? event.target.value
  }
  getBeneficiaryMotherName(event) {
    this.BeneficiaryMotherNameValue = event.detail.value
  }
  getBeneficiaryMarriedName(event) {
    this.BeneficiaryMarriedNameValue = event.detail?.value ?? event.target.value
  }
  getBeneficiaryRelationship(event) {
    this.BeneficiaryRelationshipValue = event.detail?.value ?? event.target.value
  }
  getBeneficiaryPercentage(event) {
    this.BeneficiaryPercentageValue = event.detail?.value ?? event.target.value
  }

  connectedCallback() {
    if (this.beneficiary) {
      this.BeneficiaryFirstNameValue = this.beneficiary.BeneficiaryFirstName
      this.BeneficiaryLastNameValue = this.beneficiary.BeneficiaryLastName
      this.BeneficiaryMotherNameValue = this.beneficiary.BeneficiaryMotherName
      this.BeneficiaryMarriedNameValue = this.beneficiary.BeneficiaryMarriedName
      this.BeneficiaryRelationshipValue = this.beneficiary.BeneficiaryRelationship
      this.BeneficiaryPercentageValue = this.beneficiary.BeneficiaryPercentage
    }
  }

  cleanValues() {
    console.log('clean values')
    this.BeneficiaryFirstNameValue = ''
    this.BeneficiaryLastNameValue = ''
    this.BeneficiaryMotherNameValue = ''
    this.BeneficiaryMarriedNameValue = ''
    this.BeneficiaryRelationshipValue = ''
    this.BeneficiaryPercentageValue = ''
  }

  hadleCloseModal() {
    const closeModal = new CustomEvent('closemodal')
    this.dispatchEvent(closeModal)

    console.log(' close modal')
    //  this.querySelectorAll('lightning-input').forEach(element => {
    //   if(element.type === 'checkbox' || element.type === 'checkbox-button'){
    //     element.checked = false;
    //   }else{
    //     element.value = null;
    //   }
    // })

    // this.querySelectorAll('lightning-input[data-id="form"]').value = null
    // this.querySelectorAll('lightning-input[data-id="form"]').checked = false

    // this.querySelector('lightning-input[data-id="name"]').value = null
  }

  handleCreateNewBeneficiary(event) {
    event.preventDefault()
    const createNewBeneficiary = new CustomEvent('createnewbeneficiary', {
      detail: {
        BeneficiaryFirstName: this.BeneficiaryFirstNameValue,
        BeneficiaryLastName: this.BeneficiaryLastNameValue,
        BeneficiaryMotherName: this.BeneficiaryMotherNameValue,
        BeneficiaryMarriedName: this.BeneficiaryMarriedNameValue,
        BeneficiaryRelationship: this.BeneficiaryRelationshipValue,
        BeneficiaryPercentage: this.BeneficiaryPercentageValue
      }
    })
    this.dispatchEvent(createNewBeneficiary)
  }

  render() {
    // eslint-disable-next-line no-constant-condition
    return (this.layout = 'newport' ? tmpl_nds : tmpl)
  }
}
