const uuidv4 = () => {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
    const r = (Math.random() * 16) | 0,
      v = c === 'x' ? r : (r & 0x3) | 0x8
    return v.toString(16)
  })
}

;(() => {
  window.DataUserModule = {
    // * get all policies
    getPolicies: function (data) {
      return data.policys
    },

    // * get single policy by id
    getSinglePolicy: function (data, id) {
      const policies = data.policys
      const singlePolicy = policies.find(({ endorsementId }) => endorsementId === id)
      console.log('🚀 ~ file: dataUserModule.js:12 ~ singlePolicy:', singlePolicy)
      return singlePolicy
    },

    // * get product conditions
    getProductConditions: function (data, id) {
      const policies = data.policys
      const singlePolicy = policies.find(({ endorsementId }) => endorsementId === id)
      const conditions = singlePolicy.productConditions
      const newConditions = conditions.map(item => ({ ...item, id: uuidv4() }))
      return newConditions
    }
  }
})()
