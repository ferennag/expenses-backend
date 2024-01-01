class WorkspacesController < ApplicationController
  def index
    workspaces = policy_scope(Workspace)
    render json: workspaces.all
  end

  def show
    id = params.extract_value(:id)
    workspace = Workspace.find(id)
    authorize workspace
    render json: workspace
  end
end
