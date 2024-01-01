module AuthorizationConcern
  extend ActiveSupport::Concern

  included do
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError, with: :forbidden

    protected

    def forbidden(ex)
      render json: { error: ex.message }, status: :forbidden
    end
  end
end