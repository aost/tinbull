class TopicsController < ApplicationController
  def index
    @topics = Topic.paginate(page: params[:page])
  end
end
