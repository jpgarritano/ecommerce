require 'rails_helper'
require 'json_web_token'

module ControllerHelpers
  def logged_user_token(user)
    { 'Authorization' => "Bearer #{JsonWebToken.encode(user)}" }
  end
end
