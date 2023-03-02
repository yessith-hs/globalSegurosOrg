import { LightningElement, api, wire, track } from 'lwc'
import { getRecord, getFieldValue } from 'lightning/uiRecordApi'
import { formatDate } from 'c/clbinsUtils'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import createNewFeedItem from '@salesforce/apex/CustomFeedItem.createNewFeedItem'
import getFeedItems from '@salesforce/apex/CustomFeedItem.getFeedItems'
import USER_ID from '@salesforce/user/Id'
import FIRST_NAME from '@salesforce/schema/User.FirstName'
import LAST_NAME from '@salesforce/schema/User.LastName'

export default class ClbinsCustomChatter extends LightningElement {
  @api blogid
  @api blogtopic
  @api blogtitle
  @track firstName
  @track lastName
  @track comments = []
  commentContainer
  userid = USER_ID

  // Get User Id
  @wire(getRecord, {
    recordId: '$userid',
    fields: [FIRST_NAME, LAST_NAME]
  })
  user({ data, error }) {
    if (data) {
      this.firstName = getFieldValue(data, FIRST_NAME)
      this.lastName = getFieldValue(data, LAST_NAME)
    }

    if (error) {
      console.log('Error: ' + JSON.stringify(error))
    }
  }

  // Get Comments
  @wire(getFeedItems, { blogId: '$blogid' })
  feedItemList({ data, error }) {
    if (data) {
      if (data.length > 0) {
        const updatedData = data.map(comment => {
          return { ...comment, CreatedDate: formatDate(comment.CreatedDate) }
        })
        this.comments = updatedData
        console.log('bool', data.length)
      } else {
        this.comments = false
      }
    }
    if (error) {
      console.log('Error: ' + JSON.stringify(error))
    }
  }

  handleAddComment() {
    if (
      !this.template.querySelector('.comment--title').value ||
      !this.template.querySelector('.comment--body').value
    ) {
      const event = new ShowToastEvent({
        title: 'Campos vacíos',
        message: 'Por favor ingresa un título y un comentario.',
        variant: 'error'
      })
      this.dispatchEvent(event)
    } else {
      this.addComment()
    }
  }

  addComment() {
    let comment
    const title = this.template.querySelector('.comment--title').value
    const commentText = this.template.querySelector('.comment--body').value
    const BtnSendComment = this.template.querySelector('.addComment')
    BtnSendComment.disabled = true
    BtnSendComment.classList.add('addCommentBlock')

    const topic = this.blogtopic
      .split(' ')
      .map(word => word[0].toUpperCase() + word.substring(1))
      .join(' ')

    const success = new ShowToastEvent({
      title: 'Comentario Creado',
      message: 'Gracias. Tu comentario fue creado exitosamente.',
      variant: 'success'
    })
    const fail = new ShowToastEvent({
      title: 'Error',
      message:
        'El comentario no pudo ser creado, por favor inténtalo nuevamente.',
      variant: 'error'
    })

    // Create new Comment
    createNewFeedItem({
      parentId: this.userid,
      blogId: this.blogid,
      body: commentText,
      title: title,
      firstName: this.firstName,
      lastName: this.lastName,
      blogTitle: this.blogtitle,
      blogTopic: topic
    })
      .then(result => {
        console.log('data', result)

        this.template.querySelector('.comment--title').value = ''
        this.template.querySelector('.comment--body').value = ''
        this.template.querySelector('.addComment').disabled = false

        this.dispatchEvent(success)
        comment = { ...result, CreatedDate: formatDate(result.CreatedDate) }
        if (this.comments.length) {
          this.comments.unshift(comment)
        } else {
          this.comments = [comment]
        }
      })
      .catch(error => {
        console.log('ERROR', error)
        this.dispatchEvent(fail)
      })
      .finally(() => {
        BtnSendComment.disabled = false
        BtnSendComment.classList.remove('addCommentBlock')
      })
  }
}
