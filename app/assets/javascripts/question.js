$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.edit-question-link', function(e){
    e.preventDefault();
    $(this).hide();
    let questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');
  })
});

$(document).on('turbolinks:load', function(){
  cable.subscriptions.create('QuestionsChannel', {
    connected() {
    console.log('Client connected')
    this.perform('follow')
  },
  received(content) {
      console.log(content)
      $('.questions-list').append(content)
    }
  });
})