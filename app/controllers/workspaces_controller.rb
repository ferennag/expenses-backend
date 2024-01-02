class WorkspacesController < WorkspaceBaseController
  before_action :load_workspace, except: [:index]

  def index
    workspaces = policy_scope(Workspace)
    render json: WorkspaceBlueprint.render(workspaces.all)
  end

  def show
    render json: WorkspaceBlueprint.render(@workspace)
  end

  # TODO add ability to create, update, delete a workspace

  protected

  def workspace_id_param
    :id
  end
end
