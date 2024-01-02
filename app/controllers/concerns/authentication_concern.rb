module AuthenticationConcern
  extend ActiveSupport::Concern

  class UnAuthenticated < StandardError; end

  included do
    before_action :authorization
    rescue_from UnAuthenticated, with: :unauthenticated

    protected

    def unauthenticated(ex)
      render json: { error: ex.message }, status: :unauthorized
    end

    def current_user
      raise UnAuthenticated, "UnAuthenticated" if @user.nil?
      @user
    end

    def authorization
      token = decoded_token
      raise UnAuthenticated, "UnAuthenticated" unless token.present?

      @user = User.joins(workspaces: :accounts).find_by_email(token[0]['email'])
      raise UnAuthenticated, "UnAuthenticated" unless @user.present?
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
end