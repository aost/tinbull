class PostsController < ApplicationController
  def new
    params[:parent_id] = 0 if !params[:parent_id]
    topics = Topic.where(section: params[:section])
    topic = topics[params[:topic_id].to_i - 1]
    @parent = topic.posts[params[:parent_id].to_i]
    @post = Post.new
    @title = "\u201C"+@parent.text+"\u201D"
  end

  def create
    @post = Post.new(params[:post])
    topics = Topic.where(section: params[:section])
    topic = topics.at(params[:topic_id].to_i - 1)
    @post.topic_id = topic.id
    if params[:parent_id] != "0"
      @post.parent_id = topic.posts[params[:parent_id].to_i].id
    end
    @post.ip = request.remote_ip

    if @post.save
      redirect_to topic_path(@post.topic.section, @post.topic.sub_id)
    else
      render :new
    end
  end
end
