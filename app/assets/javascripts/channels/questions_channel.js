$(document).on('turbolinks:load', function(){
  App.cable.subscriptions.create("QuestionsChannel", {
    connected() {
      console.log('Client connected to questions channel')
      this.perform('follow')
    },

    disconnected() {
      console.log('Client disconnected from questions channel')
    },

    received(content) {
      console.log(content)
      $('.questions-list').append(content)
    },

    follow: function() {
      return this.perform('follow');
    }
  });
});