class AuthController < ApplicationController
  skip_before_action :authorization, only: [:login]

  def login
    email, password = params.require([:email, :password])
    user = User.find_by_email(email)
    if user.present? && user.authenticate(password)
      jwt_payload = { email: user.email }
      render json: { message: "Successful login", token: encode_token(jwt_payload) }
    else
      render json: { error: "Invalid username or password" }, status: :unauthorized
    end
  end

  def logout
    render json: { message: "Success" }
  end
end
