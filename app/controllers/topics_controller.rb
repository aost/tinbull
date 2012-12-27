class TopicsController < ApplicationController
  respond_to :html, :json, :xml

  def index
    params[:sort] = params[:sort] || cookies[:sort] || "popular"
    cookies[:sort] = params[:sort]
    if !params[:section]
      @topics = Topic.order('created_at DESC').page(params[:page])
    else
      @topics = Topic.where(section: params[:section]).page(params[:page])
      @title = '~'+params[:section]
    end
    
    public_topics = []
    @topics.each do |t|
      topic = {
        name: t.name,
        section: t.section,
        id: t.sub_id,
        replies: t.posts.length - 1,
        first_post_at: t.posts[0].created_at.to_s,
        last_post_at: t.posts[-1].created_at.to_s
      }
      topic.delete(:section) if params[:section]
      public_topics << topic
    end
    respond_with(public_topics)
  end

  def show
    topics = Topic.where(section: params[:section])
    @topic = topics.at(params[:id].to_i - 1)
    @title = @topic.name

    public_topic = {
      name: @topic.name,
      section: @topic.section,
      content: @topic.posts[0].html,
      poster_id: @topic.posts[0].poster_id,
      time: @topic.posts[0].created_at.to_s,
      replies: []
    }
    public_topic[:replies] = 
      build_replies(@topic.posts.where(parent_id: nil).reverse[0..-2])
    respond_with(public_topic)
  end

  def build_replies(posts)
    reply_array = []
    posts.each do |p|
      reply = {
        id: p.sub_id,
        content: p.html,
        poster_id: p.poster_id,
        time: p.created_at.to_s,
        replies: []
      }
      reply[:replies] = build_replies(p.children)
      reply_array << reply
    end
    reply_array
  end

  def new
    @topic = Topic.new
    @topic.posts.build
    @title = "New topic"
  end

  def create
    @topic = Topic.new(params[:topic])
    @topic.posts[0].ip = request.remote_ip
    if @topic.save
      redirect_to action: :show, id: @topic.sub_id, section: @topic.section
    else
      render :new
    end
  end
end
