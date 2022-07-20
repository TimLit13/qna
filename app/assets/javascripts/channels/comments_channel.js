$(document).on('turbolinks:load', function(){
  App.cable.subscriptions.create({ channel: 'CommentsChannel', question_id: gon.question_id }, {
    connected() {
      // console.log(gon.question_id)
      console.log('Client connected to comments channel')
    },

    disconnected() {
      console.log('Client disconnected from comments channel')
    },

    received(content) {
      console.log(content)
      // let commentClass = content.type + '-id-' + content.type_id + '-comments'
      // console.log(commentClass)
      // $('.' + commentClass).append('<p>' + content.comment.body + '</p>')
      // $('.' + commentClass).append('<p>by ' + content.author.email + '</p>')
      if (gon.user_id != content.author.id) {
        let commentClass = content.type + '-id-' + content.type_id + '-comments'
        console.log(commentClass)
        $('.' + commentClass).append(JST["templates/comments"]({
          comment: content.comment, 
          author: content.author
        }));
      } else {
        console.log('Comment already on page')
      }
    }
  })
})