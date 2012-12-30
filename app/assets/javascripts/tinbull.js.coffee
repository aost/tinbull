$ ->

  Topic = Backbone.Model.extend({})

  TopicView = Backbone.View.extend
    tagName: 'li'
    className: 'topic'
    template: _.template(
      '<li class="topic">
        <div class="reply-count"><%= reply_count %></div>
        <a class="name" href="~/<%= section %>/<%= sub_id %>"><%= name %></a>
        <a class="section" href="~/<%= section %>">~<%= section %></a>
        <div class="info">
          <p title="<%= first_post_at %> &ndash; <%= last_post_at %>">x x ago</p>
          <br />
        </div>
      </li>')
    events:
      'click .name': 'viewTopic'
      'click .section': 'viewSection'
    viewTopic: ->
      return
    viewSection: ->
      return

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
  t.fetch()
  Backbone.history.start()
  console.log t
