class TopicsController < ApplicationController
  def index
    if !params[:section]
      @topics = Topic.order('created_at DESC').page(params[:page])
    else
      @topics = Topic.where(section: params[:section]).page(params[:page])
      @title = '~'+params[:section]
    end
  end

  def show
    topics = Topic.where(section: params[:section])
    @topic = topics.at(params[:id].to_i - 1)
    @title = @topic.name
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
