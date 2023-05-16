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
      console.log("🚀 ~ file: dataUserModule.js:12 ~ singlePolicy:", singlePolicy)
      return singlePolicy
    }
  }
})()
