Topic = Backbone.Model.extend({})

TopicsCollection = Backbone.Collection.extend
  model: Topic
  url: '/.json'

TopicsView = Backbone.View.extend
  el: $('#view')

TopicView = Backbone.View.extend({})

TinBullView = Backbone.View.extend
  el: $('#foreground')

TinBullRouter = Backbone.Router.extend({})

t = new TopicsCollection
t.reset()
console.log t
