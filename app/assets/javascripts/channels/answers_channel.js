$(document).on('turbolinks:load', function(){
  App.cable.subscriptions.create({ channel: 'AnswersChannel', question_id: gon.question_id }, {
    connected() {
      // console.log(gon.question_id)
      console.log('Client connected to answers channel')
    },

    disconnected() {
      console.log('Client disconnected from answers channel')
    },

    received(content) {
      console.log(content)
      // $('.other-answers').append(content.answer.body)
      if (gon.user_id != content.user_id) {
        $('.other-answers').append(JST["templates/answers"]({
          answer: content.answer, 
          rating: content.rating,
          question_author: content.question_author,
          links: content.links,
          files: content.files
        }));
      } else {
        console.log('Answer already on page')
      }
    }
  })
})