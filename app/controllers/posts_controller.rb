class PostsController < ApplicationController
  def new
    topics = Topic.where(section: params[:section]).order('id ASC')
    topic = topics[params[:topic_id].to_i - 1]
    @parent = topic.posts.order('id ASC').where(sub_id: params[:parent_id].to_i).first
    @post = Post.new
    @title = "\u201C"+@parent.plain_text+"\u201D"
  end

  def create
    @post = Post.new(params[:post])
    topics = Topic.where(section: params[:section]).order('id ASC')
    topic = topics.at(params[:topic_id].to_i - 1)
    @post.topic_id = topic.id
    if params[:parent_id] != "0"
      @post.parent_id = topic.posts[params[:parent_id].to_i].id
    end
    @post.poster = 
      User.where(ip: request.remote_ip).first || User.new(ip: request.remote_ip)
    @parent = topic.posts.order('id ASC').where(sub_id: params[:parent_id].to_i).first

    if @post.save
      redirect_to topic_path(@post.topic.section, @post.topic.sub_id)
    else
      render :new
    end
  end

  def flag
    topics = Topic.where(section: params[:section])
    topic = topics[params[:topic_id].to_i - 1]
    post = topic.posts[params[:post_id].to_i]
    flagger = User.where(ip: request.remote_ip).first || User.new(ip: request.remote_ip)
    if !post.flaggers.include? flagger
      post.flaggers << flagger
    else
      post.flaggers.delete(flagger)
    end
    post.save
    redirect_to topic_path(post.topic.section, post.topic.sub_id)
  end
end
