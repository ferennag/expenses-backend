class UserController < ApplicationController
  def profile
    render json: UserBlueprint.render(current_user, view: :full)
  end
end
