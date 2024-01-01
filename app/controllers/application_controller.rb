class ApplicationController < ActionController::API
  before_action :authorize

  class UnAuthorized < StandardError; end

  rescue_from UnAuthorized, with: :unauthorized

  protected

  def unauthorized(ex)
    render json: { error: ex.message }, status: :unauthorized
  end

  def authorize
    token = decoded_token
    raise UnAuthorized, "Unauthorized" unless token.present?

    @user = User.find_by_email(token[0]['email'])
    raise UnAuthorized, "Unauthorized" unless @user.present?
  end

  def decoded_token
    return nil unless auth_header.present?
    raise ActionController::BadRequest, "Invalid authorization header" unless valid_bearer?(auth_header)

    jwt = auth_header.split(' ')[1]
    JWT.decode(jwt, Rails.application.credentials.secret_key_base, true)
  rescue JWT::DecodeError
    nil
  end

  def auth_header
    request.headers['Authorization']
  end

  def valid_bearer?(bearer)
    re = /Bearer .+/
    re.match? bearer
  end

  def encode_token(payload)
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end
end
