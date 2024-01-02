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

  # TODO auth improvements needed
  # - Setup email sending
  # - Setup email confirmation process
  # - Store jwt tokens for users, and allow revoking specific sessions of users. Revoked tokens shouldn't be able to be used
  # - Experiment with token expiration. how would that work with mobile/desktop applications without forcing the user to log in all the time
  # - Store info about the login device. If it's an unknown device, send notification to users
end
