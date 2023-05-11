require 'json_web_token'

class SessionsController < ApplicationController
  def authenticate
    user = User.find_by_email(params[:email])

    if user && user.valid_password?(params[:password])
      render json: { auth_token: JsonWebToken.encode(user) }
    else
      render json: { errors: 'email or password incorrect' }, status: :unprocessable_entity
    end
  end
end
