class UserController < ApplicationController
  def profile
    render json: UserBlueprint.render(current_user, view: :full)
  end

  # TODO Improvements needed on the user controller:
  # - Add ability to change the email address
  # - Allow inviting other users into our own workspaces
  # - Allow deactivating/deleting our own user
end
