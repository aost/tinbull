$ ->

  Topic = Backbone.Model.extend({})

  Topics = Backbone.Collection.extend
    model: Topic
    url: '/.json'

  TopicsView = Backbone.View.extend
    el: '#view'

  TinBullView = Backbone.View.extend
    el: '#foreground'

  TinBullRouter = Backbone.Router.extend
    routes:
      '/': 'topics'
      '/~:section': 'topics'

  t = new Topics
  t.reset()
  Backbone.history.start()
  console.log t
