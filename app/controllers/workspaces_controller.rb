class WorkspacesController < ApplicationController
  def index
    render json: authenticated_user.workspaces
  end

  def show
    id = params.extract_value(:id)
    render json: authenticated_user.workspaces.find(id)
  end
end
