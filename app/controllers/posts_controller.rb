class PostsController < ApplicationController
  def new
    params[:post_id] = 0 if !params[:post_id] 
    topics = Topic.where(section: params[:section])
    topic = topics[params[:topic_id].to_i - 1]
    @parent = topic.posts[params[:post_id].to_i]
    @title = "\u201C"+@parent.text+"\u201D"
  end
end
