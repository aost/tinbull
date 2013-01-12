class TopicsController < ApplicationController
  respond_to :html, :json, :xml

  def index
    params[:sort] ||= cookies[:sort] || "popular"
    cookies[:sort] = params[:sort]
    if !params[:section]
      if params[:sort] == "fresh"
        @topics = Topic.order('created_at DESC').page(params[:page])
      else
        @topics = Topic.where('updated_at >= ?', 7.days.ago)
        @topics.sort_by! { |t| [-t.popularity, -t.created_at.to_i] }
        @topics = Kaminari.paginate_array(@topics).page(params[:page])
      end
    else
      if params[:sort] == "fresh"
        @topics = Topic.where(section: params[:section]).order('created_at DESC').page(params[:page])
      else
        @topics = Topic.where('updated_at >= ? AND section = ?', 7.days.ago, params[:section])
        @topics.sort_by! { |t| [-t.popularity, -t.created_at.to_i] }
        @topics = Kaminari.paginate_array(@topics).page(params[:page])
      end
      @title = '~'+params[:section]
    end
    
    public_topics = []
    @topics.each do |t|
      topic = {
        name: t.name,
        section: t.section,
        sub_id: t.sub_id,
        reply_count: t.posts.length - 1,
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
    if !@topic
      raise ActiveRecord::RecordNotFound
    end
    @title = @topic.name
    @user = 
      User.where(ip: request.remote_ip).first || User.new(ip: request.remote_ip)

    public_topic = {
      name: @topic.name,
      section: @topic.section,
      content: @topic.posts[0].html,
      password_id: @topic.posts[0].password_id,
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
        sub_id: p.sub_id,
        content: p.html,
        password_id: p.password_id,
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
    @topic.posts[0].poster = 
      User.where(ip: request.remote_ip).first || User.new(ip: request.remote_ip)
    if @topic.save
      redirect_to action: :show, id: @topic.sub_id, section: @topic.section
    else
      render :new
    end
  end
end
