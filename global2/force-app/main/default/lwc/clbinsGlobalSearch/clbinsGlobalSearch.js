import { LightningElement } from 'lwc'
// import { searchContent } from './searchContent'

export default class ClbinsGlobalSearch extends LightningElement {
  myValue = 'initial value'
  queryTerm = ''

  handleChange(event) {
    this.queryTerm = event.target.value
    console.log(
      '🚀 ~ file: clbinsGlobalSearch.js:14 ~ ClbinsGlobalSearch ~ handleChange ~ this.queryTerm',
      this.queryTerm
    )
  }

  handleSubmit(event) {
    event.preventDefault()
    console.log(
      '🚀 ~ file: clbinsGlobalSearch.js:10 ~ ClbinsGlobalSearch ~ handleSubmit ~ this.queryTerm',
      this.queryTerm
    )
    console.log('Submit')

    //   searchContent('mano')
    //     .then(data => {
    //       console.log(
    //         '🚀 ~ file: clbinsGlobalSearch.js:17 ~ ClbinsGlobalSearch ~ search ~ data',
    //         data
    //       )
    //       return
    //     })
    //     .catch(error => console.error(error.mesages))
  }
}