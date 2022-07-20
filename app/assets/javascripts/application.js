//= require rails-ujs
//= require turbolinks
//= require jquery3
//= require activestorage
//= require cocoon
//= require gh3
//= require_tree ./channels
//= require_tree .
//= require action_cable
//= require skim
//= require_tree ./templates


var App = App || {};
App.cable = ActionCable.createConsumer(); 
