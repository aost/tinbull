class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

  def render_missing_page
    render template: "shared/404", status: 404
  end

  def render_record_not_found
    render template: "shared/404", status: 404
  end
end
