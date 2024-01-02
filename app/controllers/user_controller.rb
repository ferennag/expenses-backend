class UserController < ApplicationController
  def profile
    render json: UserBlueprint.render(current_user)
  end
end
