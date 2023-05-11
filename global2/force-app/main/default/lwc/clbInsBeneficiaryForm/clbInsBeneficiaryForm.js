import { LightningElement, track } from 'lwc'
import { OmniscriptBaseMixin } from 'vlocity_ins/omniscriptBaseMixin'

import { uuidv4 } from './generateUuid'

export default class ClbInsBeneficiaryForm extends OmniscriptBaseMixin(LightningElement) {
  @track isActive = false
  @track beneficiaries
  @track isEdit = false
  @track beneficiaryEditId
  @track beneficiaryEdit
  jsonData = []

  connectedCallback() {
    this.jsonData = JSON.parse(JSON.stringify(this.omniJsonData))

    this.beneficiaries = this.jsonData.Beneficiaries ?? null
  }

  updateDataJson() {
    this.jsonData.Beneficiaries = this.beneficiaries
    this.omniApplyCallResp(this.jsonData)
  }

  showModal() {
    this.isActive = true
  }

  closeModal() {
    this.isActive = false
  }

  // * Add new beneficiary
  createNewBeneficiary(event) {
    const {
      BeneficiaryFirstName,
      BeneficiaryLastName,
      BeneficiaryMotherName,
      BeneficiaryMarriedName,
      BeneficiaryRelationship,
      BeneficiaryPercentage
    } = event.detail

    if (this.isEdit) {
      const data = {
        BeneficiaryFirstName,
        BeneficiaryLastName,
        BeneficiaryMotherName,
        BeneficiaryMarriedName,
        BeneficiaryRelationship,
        BeneficiaryPercentage
      }
      this.editBeneficiary(this.beneficiaryEditId, data)
    } else {
      if (this.beneficiaries) {
        this.beneficiaries = [
          ...this.beneficiaries,
          {
            OldBeneficiaryId: uuidv4(),
            BeneficiaryFirstName,
            BeneficiaryLastName,
            BeneficiaryMotherName,
            BeneficiaryMarriedName,
            BeneficiaryRelationship,
            BeneficiaryPercentage
          }
        ]

        this.updateDataJson()
        this.isActive = false
      } else {
        this.beneficiaries = [
          {
            OldBeneficiaryId: uuidv4(),
            BeneficiaryFirstName,
            BeneficiaryLastName,
            BeneficiaryMotherName,
            BeneficiaryMarriedName,
            BeneficiaryRelationship,
            BeneficiaryPercentage
          }
        ]

        this.updateDataJson()
        this.isActive = false
      }
    }
  }

  // * Delet beneficiary
  deletBeneficiary(event) {
    const beneficiaryId = event.currentTarget.dataset.id

    const beneficiariesList = [...this.beneficiaries]

    this.beneficiaries = beneficiariesList.filter(
      ({ OldBeneficiaryId }) => OldBeneficiaryId !== beneficiaryId
    )

    this.updateDataJson()
  }

  // * Edit beneficiary
  editBeneficiary(beneficiaryId, data) {
    const beneficiariesList = [...this.beneficiaries]

    this.beneficiaries = beneficiariesList.map(beneficiary =>
      beneficiary.OldBeneficiaryId === beneficiaryId
        ? {
            ...beneficiary,
            BeneficiaryFirstName: data.BeneficiaryFirstName,
            BeneficiaryLastName: data.BeneficiaryLastName,
            BeneficiaryMotherName: data.BeneficiaryMotherName,
            BeneficiaryMarriedName: data.BeneficiaryMarriedName,
            BeneficiaryRelationship: data.BeneficiaryRelationship,
            BeneficiaryPercentage: data.BeneficiaryPercentage
          }
        : beneficiary
    )
    this.BeneficiaryFirstNameValue = null

    this.updateDataJson()
      this.querySelectorAll('lightning-input').forEach(element => console.log(element))
    this.isActive = false
    this.isEdit = false
  }

  showEditModal(event) {
    event.preventDefault()

    this.beneficiaryEditId = event.currentTarget.dataset.id

    this.beneficiaryEdit = this.beneficiaries.find(
      ({ OldBeneficiaryId }) => OldBeneficiaryId === this.beneficiaryEditId
    )

    this.isActive = true
    this.isEdit = true
  }
}
