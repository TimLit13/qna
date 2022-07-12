$(document).on('turbolinks:load', function(){
  consumer.subscriptions.create("QuestionsChannel", {
    connected() {
      console.log('Client connected')
      this.perform('follow')
    },

    disconnected() {
      console.log('Client disconnected')
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