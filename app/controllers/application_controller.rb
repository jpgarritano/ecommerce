require 'json_web_token'

class ApplicationController < ActionController::Base
  before_filter :authenticate
  # protect_from_forgery
  attr_reader :current_user
  respond_to :json

  def authenticate
    return head :unauthorized unless request.headers['Authorization'].present?

    jwt_payload = ::JsonWebToken.decode(request)
    @current_user = User.find(jwt_payload['id'])
  end

  def user_for_paper_trail
    nil # disable whodunnit tracking
  end
end
