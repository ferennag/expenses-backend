class WorkspacesController < ApplicationController
  def index
    workspaces = policy_scope(Workspace)
    render json: WorkspaceBlueprint.render(workspaces.all)
  end

  def show
    id = params.extract_value(:id)
    workspace = Workspace.find(id)
    authorize workspace
    render json: WorkspaceBlueprint.render(workspace)
  end

  # TODO add ability to create, update, delete a workspace
end
