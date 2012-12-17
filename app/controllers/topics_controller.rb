class TopicsController < ApplicationController
  def index
    if !params[:section]
      @topics = Topic.paginate(page: params[:page])
    else
      @topics = Topic.where(section: params[:section]).paginate(page: params[:page])
      @title = '~'+params[:section]
    end
  end

  def show
    topics = Topic.where(section: params[:section])
    @topic = topics.at(params[:id].to_i - 1)
    @title = @topic.name
  end
end
